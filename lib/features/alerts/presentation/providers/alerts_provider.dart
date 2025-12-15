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
    bool isAlert = false, // If false, purely saved search (no push)
  }) async {
    try {
      // Optimistic update if needed, but for now just wait for API
      final newAlert = await _repository.createAlert(
        name, 
        filter, 
        enablePush: isAlert,
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
  bool isFilterSaved(EventFilter filter) {
    final alerts = state.valueOrNull;
    if (alerts == null) return false;
    
    // We check against basic criteria
    // This logic mimics what I added in SearchScreen but uses the Alert entity
    return alerts.any((alert) => 
      alert.filter.searchQuery == filter.searchQuery &&
      alert.filter.citySlug == filter.citySlug &&
      _listsEqual(alert.filter.thematiquesSlugs, filter.thematiquesSlugs)
    );
  }

  bool _listsEqual(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
