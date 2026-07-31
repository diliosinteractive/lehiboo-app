import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_session_key_provider.dart';
import '../../domain/entities/trip_plan.dart';
import '../../domain/repositories/trip_plans_repository.dart';

final tripPlansProvider =
    StateNotifierProvider<TripPlansNotifier, AsyncValue<List<TripPlan>>>((ref) {
  final sessionKey = ref.watch(authSessionKeyProvider);
  final hasActiveAccount = sessionKey.accountId != null;
  final repository = ref.watch(tripPlansRepositoryProvider);
  return TripPlansNotifier(
    repository,
    hasActiveAccount: hasActiveAccount,
  );
});

class TripPlansNotifier extends StateNotifier<AsyncValue<List<TripPlan>>> {
  final TripPlansRepository _repository;
  final bool _hasActiveAccount;
  int _loadGeneration = 0;
  int _nextMutationGeneration = 0;
  final Map<String, int> _mutationGenerationByPlan = {};

  TripPlansNotifier(
    this._repository, {
    required bool hasActiveAccount,
  })  : _hasActiveAccount = hasActiveAccount,
        super(
          hasActiveAccount
              ? const AsyncValue.loading()
              : const AsyncValue.data([]),
        ) {
    if (hasActiveAccount) loadTripPlans();
  }

  Future<void> loadTripPlans() async {
    if (!mounted) return;
    final requestGeneration = ++_loadGeneration;
    if (!_hasActiveAccount) {
      state = const AsyncValue.data([]);
      return;
    }

    try {
      state = const AsyncValue.loading();
      final plans = await _repository.getTripPlans();
      if (!mounted || requestGeneration != _loadGeneration) return;
      state = AsyncValue.data(plans);
    } catch (e, stack) {
      if (!mounted || requestGeneration != _loadGeneration) return;
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> refresh() async {
    await loadTripPlans();
  }

  Future<void> updateTripPlan({
    required String uuid,
    String? title,
    DateTime? plannedDate,
    List<String>? stopsOrder,
  }) async {
    if (!mounted) return;
    _loadGeneration++;
    final mutationGeneration = ++_nextMutationGeneration;
    _mutationGenerationByPlan[uuid] = mutationGeneration;
    final updatedPlan = await _repository.updateTripPlan(
      uuid: uuid,
      title: title,
      plannedDate: plannedDate,
      stopsOrder: stopsOrder,
    );
    if (!mounted || _mutationGenerationByPlan[uuid] != mutationGeneration) {
      return;
    }

    final currentList = state.valueOrNull ?? const <TripPlan>[];
    state = AsyncValue.data(
      currentList.map((p) => p.uuid == uuid ? updatedPlan : p).toList(),
    );
  }

  Future<void> deleteTripPlan(String uuid) async {
    if (!mounted) return;
    _loadGeneration++;
    final mutationGeneration = ++_nextMutationGeneration;
    _mutationGenerationByPlan[uuid] = mutationGeneration;
    await _repository.deleteTripPlan(uuid);
    if (!mounted || _mutationGenerationByPlan[uuid] != mutationGeneration) {
      return;
    }

    final currentList = state.valueOrNull ?? const <TripPlan>[];
    state = AsyncValue.data(
      currentList.where((p) => p.uuid != uuid).toList(),
    );
  }

  /// Get a specific trip plan by UUID
  TripPlan? getTripPlan(String uuid) {
    final plans = state.valueOrNull;
    if (plans == null) return null;
    try {
      return plans.firstWhere((p) => p.uuid == uuid);
    } catch (_) {
      return null;
    }
  }
}
