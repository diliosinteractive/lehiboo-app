import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/dio_client.dart';
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

        if (response.statusCode == 200) {
          final data = response.data;

          // Handle standard API response structure {success: true, data: [...]}
          if (data is Map<String, dynamic> && data.containsKey('data')) {
            final dataContent = data['data'];

            // Case 1: data is directly a list (standard API response)
            if (dataContent is List) {
              try {
                return dataContent.map((e) => AlertDto.fromJson(e as Map<String, dynamic>)).toList();
              } catch (parseError) {
                print('❌ AlertDto parsing error: $parseError');
                print('📦 Raw item data: ${dataContent.isNotEmpty ? dataContent.first : "empty"}');
                rethrow;
              }
            }

            // Case 2: data is an object with alerts key {data: {alerts: [...]}}
            if (dataContent is Map<String, dynamic> && dataContent.containsKey('alerts')) {
              final List<dynamic> alertsData = dataContent['alerts'];
              try {
                return alertsData.map((e) => AlertDto.fromJson(e as Map<String, dynamic>)).toList();
              } catch (parseError) {
                print('❌ AlertDto parsing error: $parseError');
                print('📦 Raw item data: ${alertsData.isNotEmpty ? alertsData.first : "empty"}');
                rethrow;
              }
            }
          }

          // Fallback if structure is different (e.g. direct list at root)
          if (data is List) {
            try {
              return data.map((e) => AlertDto.fromJson(e as Map<String, dynamic>)).toList();
            } catch (parseError) {
              print('❌ AlertDto parsing error: $parseError');
              rethrow;
            }
          }

          // Log the data to debug why it failed
          print('❌ Alerts API: Parsing Failed. Response structure unexpected: $data');
        }
      } on DioException catch (e) {
        // Only retry on server errors (5xx) or connection timeouts
        if (e.response != null && e.response!.statusCode != null && e.response!.statusCode! >= 500) {
           if (attempt < maxRetries) {
             print('⚠️ 5xx Error fetching alerts. Retrying... ($attempt/$maxRetries)');
             await Future.delayed(retryDelay * attempt); // Exponential-ish backoff
             continue;
           }
        }
        // If it's a 4xx error or we ran out of retries, rethrow
        rethrow;
      } catch (e) {
        // For non-dio errors, rethrow immediately
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
    // toQueryParams uses 'search' but API expects 'search_query'
    if (payload.containsKey('search')) {
      payload['search_query'] = payload['search'];
      payload.remove('search');
    }
    // toQueryParams uses 'location' for citySlug, API expects 'city_slug'
    if (payload.containsKey('location')) {
      payload['city_slug'] = payload['location'];
      payload.remove('location');
    }
    // toQueryParams uses 'category' string join, API expects 'categories' array
    if (payload.containsKey('category')) {
      payload['categories'] = (payload['category'] as String).split(',');
      payload.remove('category');
    }
    // API expects 'tags' as array
    if (payload.containsKey('tags')) {
      payload['tags'] = (payload['tags'] as String).split(',');
    }
    // API expects 'thematiques' as array if provided (toQueryParams puts it in thematique)
    if (payload.containsKey('thematique')) {
      payload['thematiques'] = (payload['thematique'] as String).split(',');
      payload.remove('thematique');
    }

    // Explicitly map audience booleans if toQueryParams keys differ
    // toQueryParams: family_friendly, accessible_pmr, online, in_person
    // API Spec (Backend): is_family_friendly, is_accessible_pmr, is_online
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

    final response = await _dio.post(
      '/me/alerts',
      data: payload,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return AlertDto.fromJson(response.data);
    }
    throw Exception('Failed to create alert');
  }

  Future<void> deleteAlert(String id) async {
    await _dio.delete('/me/alerts/$id');
  }
}
