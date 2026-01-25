import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/alert.dart';
import '../../domain/repositories/alerts_repository.dart';
import '../../data/repositories/alerts_repository_impl.dart';
import '../../../search/domain/models/event_filter.dart';

final alertsProvider = StateNotifierProvider<AlertsNotifier, AsyncValue<List<Alert>>>((ref) {
  final repository = ref.watch(alertsRepositoryImplProvider);
  return AlertsNotifier(repository);
});

class AlertsNotifier extends StateNotifier<AsyncValue<List<Alert>>> {
  final AlertsRepository _repository;

  AlertsNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadAlerts();
  }

  Future<void> loadAlerts() async {
    try {
      state = const AsyncValue.loading();
      final alerts = await _repository.getAlerts();
      state = AsyncValue.data(alerts);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> createAlert({
    required String name,
    required EventFilter filter,
    bool enablePush = true,
    bool enableEmail = false,
  }) async {
    try {
      final newAlert = await _repository.createAlert(
        name,
        filter,
        enablePush: enablePush,
        enableEmail: enableEmail,
      );
      
      final currentList = state.valueOrNull ?? [];
      state = AsyncValue.data([newAlert, ...currentList]);
    } catch (e, stack) {
      // TODO: Handle error properly (show snackbar etc in UI)
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteAlert(String id) async {
    try {
      await _repository.deleteAlert(id);
      
      final currentList = state.valueOrNull ?? [];
      state = AsyncValue.data(currentList.where((a) => a.id != id).toList());
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
  
  /// Helper to check if a filter combination is already saved
  /// Compares all significant filter criteria
  bool isFilterSaved(EventFilter filter) {
    final alerts = state.valueOrNull;
    if (alerts == null || alerts.isEmpty) return false;

    return alerts.any((alert) => _filtersMatch(alert.filter, filter));
  }

  bool _filtersMatch(EventFilter a, EventFilter b) {
    // Compare only significant criteria (ignore default values)

    // Search query (empty strings are equivalent)
    if ((a.searchQuery.isNotEmpty || b.searchQuery.isNotEmpty) &&
        a.searchQuery != b.searchQuery) return false;

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
