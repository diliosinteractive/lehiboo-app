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
    final response = await _dio.get('/me/alerts');
    
    if (response.statusCode == 200) {
      final data = response.data;
      // Handle the wrapped response structure {success: true, data: {alerts: [...]}}
      if (data is Map<String, dynamic> && 
          data.containsKey('data') && 
          data['data'] is Map<String, dynamic> &&
          data['data'].containsKey('alerts')) {
        
        final List<dynamic> alertsData = data['data']['alerts'];
        return alertsData.map((e) => AlertDto.fromJson(e)).toList();
      }
      
      // Fallback if structure is different (e.g. direct list)
      if (data is List) {
        return data.map((e) => AlertDto.fromJson(e)).toList();
      }
    }
    throw Exception('Failed to fetch alerts: Invalid response format');
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
