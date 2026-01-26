import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/trip_plan.dart';
import '../../domain/repositories/trip_plans_repository.dart';
import '../datasources/trip_plans_api_datasource.dart';

final tripPlansRepositoryImplProvider = Provider<TripPlansRepository>((ref) {
  final dataSource = ref.watch(tripPlansApiDataSourceProvider);
  return TripPlansRepositoryImpl(dataSource);
});

class TripPlansRepositoryImpl implements TripPlansRepository {
  final TripPlansApiDataSource _dataSource;

  TripPlansRepositoryImpl(this._dataSource);

  @override
  Future<List<TripPlan>> getTripPlans() async {
    final dtos = await _dataSource.getTripPlans();
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<TripPlan> updateTripPlan({
    required String uuid,
    String? title,
    DateTime? plannedDate,
    List<String>? stopsOrder,
  }) async {
    final dto = await _dataSource.updateTripPlan(
      uuid: uuid,
      title: title,
      plannedDate: plannedDate != null
          ? DateFormat('yyyy-MM-dd').format(plannedDate)
          : null,
      stopsOrder: stopsOrder,
    );
    return dto.toEntity();
  }

  @override
  Future<void> deleteTripPlan(String uuid) async {
    await _dataSource.deleteTripPlan(uuid);
  }
}
