import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/dio_client.dart';
import '../../../../core/utils/api_response_handler.dart';
import '../models/alert_dto.dart';
import '../../../search/domain/models/event_filter.dart';

final alertsApiDataSourceProvider = Provider<AlertsApiDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return AlertsApiDataSource(dio);
});

class AlertsApiDataSource {
  final Dio _dio;

  AlertsApiDataSource(this._dio);

  Future<List<AlertDto>> getAlerts() async {
    const int maxRetries = 3;
    const Duration retryDelay = Duration(milliseconds: 500);

    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        final response = await _dio.get('/me/alerts');

        // Try nested key 'alerts' first, then fall back to flat list
        try {
          final list = ApiResponseHandler.extractList(response.data, key: 'alerts');
          return list.map((e) => AlertDto.fromJson(e as Map<String, dynamic>)).toList();
        } on ApiFormatException {
          final list = ApiResponseHandler.extractList(response.data);
          return list.map((e) => AlertDto.fromJson(e as Map<String, dynamic>)).toList();
        }
      } on DioException catch (e) {
        if (e.response?.statusCode != null && e.response!.statusCode! >= 500) {
          if (attempt < maxRetries) {
            debugPrint('⚠️ 5xx Error fetching alerts. Retrying... ($attempt/$maxRetries)');
            await Future.delayed(retryDelay * attempt);
            continue;
          }
        }
        rethrow;
      }
    }
    throw Exception('Failed to fetch alerts after $maxRetries attempts');
  }

  Future<AlertDto> createAlert({
    required String name,
    required EventFilter filter,
    bool enablePush = true,
    bool enableEmail = false,
  }) async {
    // Convert filter to payload
    final Map<String, dynamic> payload = {
      'name': name,
      'enable_push_alert': enablePush,
      'enable_email_alert': enableEmail,
      ...filter.toQueryParams(),
    };

    // Clean up incompatible keys from toQueryParams
    if (payload.containsKey('search')) {
      payload['search_query'] = payload['search'];
      payload.remove('search');
    }
    if (payload.containsKey('location')) {
      payload['city_slug'] = payload['location'];
      payload.remove('location');
    }
    if (payload.containsKey('category')) {
      payload['categories'] = (payload['category'] as String).split(',');
      payload.remove('category');
    }
    if (payload.containsKey('tags')) {
      payload['tags'] = (payload['tags'] as String).split(',');
    }
    if (payload.containsKey('thematique')) {
      payload['thematiques'] = (payload['thematique'] as String).split(',');
      payload.remove('thematique');
    }
    if (payload.containsKey('family_friendly')) {
       payload['is_family_friendly'] = payload['family_friendly'] == 'true';
       payload.remove('family_friendly');
    }
    if (payload.containsKey('accessible_pmr')) {
       payload['is_accessible_pmr'] = payload['accessible_pmr'] == 'true';
       payload.remove('accessible_pmr');
    }
    if (payload.containsKey('online')) {
       payload['is_online'] = payload['online'] == 'true';
       payload.remove('online');
    }

    final response = await _dio.post('/me/alerts', data: payload);
    return AlertDto.fromJson(response.data);
  }

  Future<void> deleteAlert(String id) async {
    await _dio.delete('/me/alerts/$id');
  }
}
