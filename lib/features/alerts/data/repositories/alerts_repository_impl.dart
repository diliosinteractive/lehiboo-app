import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/alert.dart';
import '../../domain/repositories/alerts_repository.dart';
import '../datasources/alerts_api_datasource.dart';
import '../../../search/domain/models/event_filter.dart';

final alertsRepositoryImplProvider = Provider<AlertsRepository>((ref) {
  final dataSource = ref.watch(alertsApiDataSourceProvider);
  return AlertsRepositoryImpl(dataSource);
});

class AlertsRepositoryImpl implements AlertsRepository {
  final AlertsApiDataSource _dataSource;

  AlertsRepositoryImpl(this._dataSource);

  @override
  Future<List<Alert>> getAlerts() async {
    final dtoList = await _dataSource.getAlerts();
    return dtoList.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<Alert> createAlert(
    String name,
    EventFilter filter, {
    bool enablePush = true,
    bool enableEmail = false,
  }) async {
    final dto = await _dataSource.createAlert(
      name: name,
      filter: filter,
      enablePush: enablePush,
      enableEmail: enableEmail,
    );

    // Use the original filter instead of the one parsed from API
    // This ensures the comparison works correctly
    return Alert(
      id: dto.id,
      name: dto.name,
      filter: filter, // Use original filter
      enablePush: dto.enablePushAlert,
      enableEmail: dto.enableEmailAlert,
      createdAt: DateTime.tryParse(dto.createdAt) ?? DateTime.now(),
    );
  }

  @override
  Future<void> deleteAlert(String id) async {
    await _dataSource.deleteAlert(id);
  }
}
