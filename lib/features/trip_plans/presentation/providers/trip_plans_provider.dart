import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/trip_plan.dart';
import '../../domain/repositories/trip_plans_repository.dart';
import '../../data/repositories/trip_plans_repository_impl.dart';

final tripPlansProvider = StateNotifierProvider<TripPlansNotifier, AsyncValue<List<TripPlan>>>((ref) {
  final repository = ref.watch(tripPlansRepositoryImplProvider);
  return TripPlansNotifier(repository);
});

class TripPlansNotifier extends StateNotifier<AsyncValue<List<TripPlan>>> {
  final TripPlansRepository _repository;

  TripPlansNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadTripPlans();
  }

  Future<void> loadTripPlans() async {
    try {
      state = const AsyncValue.loading();
      final plans = await _repository.getTripPlans();
      state = AsyncValue.data(plans);
    } catch (e, stack) {
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
    try {
      final updatedPlan = await _repository.updateTripPlan(
        uuid: uuid,
        title: title,
        plannedDate: plannedDate,
        stopsOrder: stopsOrder,
      );

      final currentList = state.valueOrNull ?? [];
      state = AsyncValue.data(
        currentList.map((p) => p.uuid == uuid ? updatedPlan : p).toList(),
      );
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteTripPlan(String uuid) async {
    try {
      await _repository.deleteTripPlan(uuid);

      final currentList = state.valueOrNull ?? [];
      state = AsyncValue.data(currentList.where((p) => p.uuid != uuid).toList());
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
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
