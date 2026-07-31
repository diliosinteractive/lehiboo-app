import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/analytics/analytics_event.dart';
import '../../../../core/analytics/analytics_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/alert.dart';
import '../../domain/repositories/alerts_repository.dart';
import '../../../search/domain/models/event_filter.dart';

final alertsProvider =
    StateNotifierProvider<AlertsNotifier, AsyncValue<List<Alert>>>((ref) {
  final authenticatedUserId = ref.watch(
    authProvider.select(
      (state) => state.isAuthenticated ? state.user?.id : null,
    ),
  );
  return AlertsNotifier(
    ref.watch(alertsRepositoryProvider),
    ref,
    isAuthenticated: authenticatedUserId != null,
  );
});

class AlertsNotifier extends StateNotifier<AsyncValue<List<Alert>>> {
  final AlertsRepository _repository;
  final Ref _ref;
  final bool _isAuthenticated;
  Future<void>? _loadInFlight;

  AlertsNotifier(
    this._repository,
    this._ref, {
    required bool isAuthenticated,
  })  : _isAuthenticated = isAuthenticated,
        super(const AsyncValue.data([])) {
    if (_isAuthenticated) {
      // Initial loading is fire-and-forget. Manual refresh callers await
      // [loadAlerts] and receive failures so aggregate refresh can report them.
      unawaited(loadAlerts().catchError((_) {}));
    }
  }

  Future<void> loadAlerts() {
    if (!_isAuthenticated) {
      state = const AsyncValue.data([]);
      return Future.value();
    }

    final inFlight = _loadInFlight;
    if (inFlight != null) return inFlight;

    late final Future<void> load;
    load = _performLoad().whenComplete(() {
      if (identical(_loadInFlight, load)) {
        _loadInFlight = null;
      }
    });
    _loadInFlight = load;
    return load;
  }

  Future<void> _performLoad() async {
    final previous = state;
    try {
      state = const AsyncLoading<List<Alert>>().copyWithPrevious(previous);
      final alerts = await _repository.getAlerts();
      if (!mounted) return;
      state = AsyncValue.data(alerts);
    } catch (e, stack) {
      if (mounted) {
        state = AsyncError<List<Alert>>(e, stack).copyWithPrevious(previous);
      }
      rethrow;
    }
  }

  Future<void> createAlert({
    required String name,
    required EventFilter filter,
    bool enablePush = true,
    bool enableEmail = false,
  }) async {
    final previous = state;
    try {
      final newAlert = await _repository.createAlert(
        name,
        filter,
        enablePush: enablePush,
        enableEmail: enableEmail,
      );

      if (!mounted) return;
      final currentList = state.valueOrNull ?? [];
      state = AsyncValue.data([newAlert, ...currentList]);

      _ref.read(analyticsServiceProvider).logEvent(
        AnalyticsEvent.searchSaved,
        params: {
          AnalyticsParam.enablePush: enablePush,
          AnalyticsParam.enableEmail: enableEmail,
          AnalyticsParam.citySlug: filter.citySlug ?? 'none',
        },
      );
    } catch (e, stack) {
      if (mounted) {
        state = AsyncError<List<Alert>>(e, stack).copyWithPrevious(previous);
      }
      // Callers own the action-specific feedback. Preserve the original
      // exception so they cannot accidentally report a successful save.
      rethrow;
    }
  }

  Future<void> deleteAlert(String id) async {
    // Let the dismiss animation complete before mutating the list. More
    // importantly, propagate failures so the UI cannot announce a deletion
    // that the backend rejected.
    await _repository.deleteAlert(id);
  }

  void removeDeletedAlert(String id) {
    if (!mounted) return;
    final currentList = state.valueOrNull ?? [];
    state =
        AsyncValue.data(currentList.where((alert) => alert.id != id).toList());
  }

  /// Helper to check if a filter combination is already saved
  /// Compares all significant filter criteria
  bool isFilterSaved(EventFilter filter) {
    final alerts = state.valueOrNull;
    if (alerts == null || alerts.isEmpty) return false;

    return alerts.any((alert) => _filtersMatch(alert.filter, filter));
  }

  /// Check if a name is already used by an existing alert
  bool isNameAlreadyUsed(String name) {
    final alerts = state.valueOrNull;
    if (alerts == null || alerts.isEmpty) return false;

    final normalizedName = name.trim().toLowerCase();
    return alerts
        .any((alert) => alert.name.trim().toLowerCase() == normalizedName);
  }

  bool _filtersMatch(EventFilter a, EventFilter b) {
    // Compare only significant criteria (ignore default values)

    // Search query (empty strings are equivalent)
    if ((a.searchQuery.isNotEmpty || b.searchQuery.isNotEmpty) &&
        a.searchQuery != b.searchQuery) {
      return false;
    }

    // Location: city OR geolocation
    if (a.citySlug != b.citySlug) return false;

    // Geolocation: only compare if either has coordinates
    final aHasGeo = a.latitude != null;
    final bHasGeo = b.latitude != null;
    if (aHasGeo != bHasGeo) return false;
    if (aHasGeo && bHasGeo) {
      // Coordinates should be close enough (within ~100m)
      if ((a.latitude! - b.latitude!).abs() > 0.001) return false;
      if ((a.longitude! - b.longitude!).abs() > 0.001) return false;
    }

    // Date filter
    if (a.dateFilterType != b.dateFilterType) return false;
    if (a.dateFilterType == DateFilterType.custom) {
      if (a.startDate != b.startDate || a.endDate != b.endDate) return false;
    }

    // Boolean filters (only compare if true on either side)
    if (a.familyFriendly != b.familyFriendly) return false;
    if (a.onlyFree != b.onlyFree) return false;
    if (a.accessiblePMR != b.accessiblePMR) return false;
    if (a.onlineOnly != b.onlineOnly) return false;

    // Categories and thematiques
    if (!_listsEqual(a.categoriesSlugs, b.categoriesSlugs)) return false;
    if (!_listsEqual(a.thematiquesSlugs, b.thematiquesSlugs)) return false;

    return true;
  }

  bool _listsEqual(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
