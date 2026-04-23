import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/dio_client.dart';
import '../../../../core/utils/api_response_handler.dart';
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

        // Try nested key 'plans' first, then fall back to flat list
        try {
          final list = ApiResponseHandler.extractList(response.data, key: 'plans');
          return list.map((e) => TripPlanDto.fromJson(e as Map<String, dynamic>)).toList();
        } on ApiFormatException {
          final list = ApiResponseHandler.extractList(response.data);
          return list.map((e) => TripPlanDto.fromJson(e as Map<String, dynamic>)).toList();
        }
      } on DioException catch (e) {
        if (e.response?.statusCode != null && e.response!.statusCode! >= 500) {
          if (attempt < maxRetries) {
            debugPrint('5xx Error fetching trip plans. Retrying... ($attempt/$maxRetries)');
            await Future.delayed(retryDelay * attempt);
            continue;
          }
        }
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

    final response = await _dio.put('/trip-plans/$uuid', data: payload);
    final data = ApiResponseHandler.extractObject(response.data, unwrapRoot: true);
    return TripPlanDto.fromJson(data);
  }

  /// DELETE /api/v1/trip-plans/{uuid} - Supprimer un plan
  Future<void> deleteTripPlan(String uuid) async {
    await _dio.delete('/trip-plans/$uuid');
  }
}
