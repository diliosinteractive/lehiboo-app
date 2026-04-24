import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/dio_client.dart';
import '../../../../core/utils/api_response_handler.dart';
import '../models/reminder_dto.dart';

final remindersApiDataSourceProvider =
    Provider<RemindersApiDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return RemindersApiDataSource(dio);
});

class RemindersApiDataSource {
  final Dio _dio;

  RemindersApiDataSource(this._dio);

  /// Liste paginee de tous les rappels de l'utilisateur
  Future<List<ReminderDto>> getMyReminders({
    int page = 1,
    int perPage = 50,
  }) async {
    final response = await _dio.get(
      '/me/reminders',
      queryParameters: {'page': page, 'per_page': perPage},
    );

    final list = ApiResponseHandler.extractList(response.data);
    return list
        .map((e) => ReminderDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Retourne les UUID de slots rappeles pour un evenement
  Future<List<String>> getEventReminders(String eventUuid) async {
    final response = await _dio.get('/events/$eventUuid/reminders');

    final payload = ApiResponseHandler.extractObject(response.data);
    final slotIds = payload['slot_ids'];
    if (slotIds is List) {
      return slotIds.map((e) => e.toString()).toList();
    }
    return [];
  }

  /// Cree un rappel pour un creneau
  Future<ReminderDto> createReminder({
    required String eventUuid,
    required String slotUuid,
  }) async {
    final response =
        await _dio.post('/events/$eventUuid/reminders/$slotUuid');

    final payload = ApiResponseHandler.extractObject(response.data);
    return ReminderDto.fromJson(payload);
  }

  /// Supprime un rappel pour un creneau
  Future<void> deleteReminder({
    required String eventUuid,
    required String slotUuid,
  }) async {
    await _dio.delete('/events/$eventUuid/reminders/$slotUuid');
  }

  /// Supprime tous les rappels d'un evenement
  Future<int> deleteAllReminders(String eventUuid) async {
    final response = await _dio.delete('/events/$eventUuid/reminders');

    final data = response.data;
    if (data is Map<String, dynamic>) {
      return (data['deleted'] as int?) ?? 0;
    }
    return 0;
  }
}
