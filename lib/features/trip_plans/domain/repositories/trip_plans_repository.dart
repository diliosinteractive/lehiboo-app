import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entities/trip_plan.dart';

final tripPlansRepositoryProvider = Provider<TripPlansRepository>((ref) {
  throw UnimplementedError('tripPlansRepositoryProvider not initialized');
});

abstract class TripPlansRepository {
  /// Get all saved trip plans
  Future<List<TripPlan>> getTripPlans();

  /// Update a trip plan (title, date, or reorder stops)
  Future<TripPlan> updateTripPlan({
    required String uuid,
    String? title,
    DateTime? plannedDate,
    List<String>? stopsOrder,
  });

  /// Delete a trip plan
  Future<void> deleteTripPlan(String uuid);
}
