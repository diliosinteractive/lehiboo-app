import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../entities/alert.dart';
import '../../../search/domain/models/event_filter.dart';

final alertsRepositoryProvider = Provider<AlertsRepository>((ref) {
  throw UnimplementedError('Provider was not initialized');
});

abstract class AlertsRepository {
  Future<List<Alert>> getAlerts();
  
  Future<Alert> createAlert(
    String name, 
    EventFilter filter, {
    bool enablePush = true,
    bool enableEmail = false,
  });
  
  Future<void> deleteAlert(String id);
}
