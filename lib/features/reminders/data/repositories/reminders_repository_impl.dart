import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/reminder.dart';
import '../../domain/repositories/reminders_repository.dart';
import '../datasources/reminders_api_datasource.dart';

final remindersRepositoryProvider = Provider<RemindersRepository>((ref) {
  final dataSource = ref.watch(remindersApiDataSourceProvider);
  return RemindersRepositoryImpl(dataSource);
});

class RemindersRepositoryImpl implements RemindersRepository {
  final RemindersApiDataSource _dataSource;

  RemindersRepositoryImpl(this._dataSource);

  @override
  Future<List<Reminder>> getMyReminders({
    int page = 1,
    int perPage = 50,
  }) async {
    final dtos = await _dataSource.getMyReminders(
      page: page,
      perPage: perPage,
    );
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<List<String>> getEventReminders(String eventUuid) {
    return _dataSource.getEventReminders(eventUuid);
  }

  @override
  Future<Reminder> createReminder({
    required String eventUuid,
    required String slotUuid,
  }) async {
    final dto = await _dataSource.createReminder(
      eventUuid: eventUuid,
      slotUuid: slotUuid,
    );
    return dto.toEntity();
  }

  @override
  Future<void> deleteReminder({
    required String eventUuid,
    required String slotUuid,
  }) {
    return _dataSource.deleteReminder(
      eventUuid: eventUuid,
      slotUuid: slotUuid,
    );
  }

  @override
  Future<int> deleteAllReminders(String eventUuid) {
    return _dataSource.deleteAllReminders(eventUuid);
  }
}
