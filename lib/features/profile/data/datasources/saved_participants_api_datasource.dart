import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lehiboo/config/dio_client.dart';
import 'package:lehiboo/core/utils/api_response_handler.dart';
import 'package:lehiboo/features/profile/domain/models/saved_participant.dart';

final savedParticipantsApiDataSourceProvider =
    Provider<SavedParticipantsApiDataSource>((ref) {
  return SavedParticipantsApiDataSource(ref.read(dioProvider));
});

class SavedParticipantsApiDataSource {
  final Dio _dio;

  SavedParticipantsApiDataSource(this._dio);

  Future<List<SavedParticipant>> list() async {
    final response = await _dio.get('/me/participants');
    final data = ApiResponseHandler.extractList(response.data);

    return data
        .map((item) => SavedParticipant.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<SavedParticipant> create(SavedParticipant participant) async {
    final response = await _dio.post(
      '/me/participants',
      data: participant.toPayload(),
    );
    final data = ApiResponseHandler.extractObject(response.data);

    return SavedParticipant.fromJson(data);
  }

  Future<SavedParticipant> update(SavedParticipant participant) async {
    final response = await _dio.patch(
      '/me/participants/${participant.uuid}',
      data: participant.toPayload(),
    );
    final data = ApiResponseHandler.extractObject(response.data);

    return SavedParticipant.fromJson(data);
  }

  Future<void> delete(String uuid) async {
    await _dio.delete('/me/participants/$uuid');
  }
}
