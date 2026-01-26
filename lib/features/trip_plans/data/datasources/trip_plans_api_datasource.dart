import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/dio_client.dart';
import '../models/trip_plan_dto.dart';

final tripPlansApiDataSourceProvider = Provider<TripPlansApiDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return TripPlansApiDataSource(dio);
});

class TripPlansApiDataSource {
  final Dio _dio;

  TripPlansApiDataSource(this._dio);

  /// GET /api/v1/trip-plans - Liste des plans sauvegardés
  Future<List<TripPlanDto>> getTripPlans() async {
    const int maxRetries = 3;
    const Duration retryDelay = Duration(milliseconds: 500);

    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        final response = await _dio.get('/trip-plans');

        if (response.statusCode == 200) {
          final data = response.data;

          // Handle standard API response structure {success: true, data: {...}}
          if (data is Map<String, dynamic> && data.containsKey('data')) {
            final dataContent = data['data'];

            // Case 1: data.plans is a list
            if (dataContent is Map<String, dynamic> && dataContent.containsKey('plans')) {
              final List<dynamic> plansData = dataContent['plans'];
              try {
                return plansData.map((e) => TripPlanDto.fromJson(e as Map<String, dynamic>)).toList();
              } catch (parseError) {
                if (kDebugMode) {
                  debugPrint('TripPlanDto parsing error: $parseError');
                  debugPrint('Raw item data: ${plansData.isNotEmpty ? plansData.first : "empty"}');
                }
                rethrow;
              }
            }

            // Case 2: data is directly a list
            if (dataContent is List) {
              try {
                return dataContent.map((e) => TripPlanDto.fromJson(e as Map<String, dynamic>)).toList();
              } catch (parseError) {
                if (kDebugMode) {
                  debugPrint('TripPlanDto parsing error: $parseError');
                }
                rethrow;
              }
            }
          }

          // Fallback if structure is different (e.g. direct list at root)
          if (data is List) {
            try {
              return data.map((e) => TripPlanDto.fromJson(e as Map<String, dynamic>)).toList();
            } catch (parseError) {
              if (kDebugMode) {
                debugPrint('TripPlanDto parsing error: $parseError');
              }
              rethrow;
            }
          }

          if (kDebugMode) {
            debugPrint('TripPlans API: Parsing Failed. Response structure unexpected: $data');
          }
        }
      } on DioException catch (e) {
        // Only retry on server errors (5xx) or connection timeouts
        if (e.response != null && e.response!.statusCode != null && e.response!.statusCode! >= 500) {
          if (attempt < maxRetries) {
            if (kDebugMode) {
              debugPrint('5xx Error fetching trip plans. Retrying... ($attempt/$maxRetries)');
            }
            await Future.delayed(retryDelay * attempt);
            continue;
          }
        }
        rethrow;
      } catch (e) {
        rethrow;
      }
    }
    throw Exception('Failed to fetch trip plans after $maxRetries attempts');
  }

  /// PUT /api/v1/trip-plans/{uuid} - Modifier un plan
  Future<TripPlanDto> updateTripPlan({
    required String uuid,
    String? title,
    String? plannedDate,
    List<String>? stopsOrder,
  }) async {
    final Map<String, dynamic> payload = {};

    if (title != null) payload['title'] = title;
    if (plannedDate != null) payload['planned_date'] = plannedDate;
    if (stopsOrder != null) payload['stops_order'] = stopsOrder;

    final response = await _dio.put(
      '/trip-plans/$uuid',
      data: payload,
    );

    if (response.statusCode == 200) {
      final data = response.data;
      if (data is Map<String, dynamic>) {
        // Handle {success: true, data: {...}}
        if (data.containsKey('data') && data['data'] is Map<String, dynamic>) {
          return TripPlanDto.fromJson(data['data'] as Map<String, dynamic>);
        }
        return TripPlanDto.fromJson(data);
      }
    }
    throw Exception('Failed to update trip plan');
  }

  /// DELETE /api/v1/trip-plans/{uuid} - Supprimer un plan
  Future<void> deleteTripPlan(String uuid) async {
    await _dio.delete('/trip-plans/$uuid');
  }
}
