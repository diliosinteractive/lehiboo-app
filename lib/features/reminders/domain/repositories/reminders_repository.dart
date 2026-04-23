import '../entities/reminder.dart';

abstract class RemindersRepository {
  Future<List<Reminder>> getMyReminders({int page = 1, int perPage = 50});
  Future<List<String>> getEventReminders(String eventUuid);
  Future<Reminder> createReminder({
    required String eventUuid,
    required String slotUuid,
  });
  Future<void> deleteReminder({
    required String eventUuid,
    required String slotUuid,
  });
  Future<int> deleteAllReminders(String eventUuid);
}
