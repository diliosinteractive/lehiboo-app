import 'package:dio/dio.dart';
import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/domain/entities/paginated.dart';
import 'package:lehiboo/domain/entities/search_filters.dart';
import 'package:lehiboo/domain/repositories/activity_repository.dart';
import 'package:lehiboo/data/models/activity_dto.dart';
import 'package:lehiboo/data/mappers/activity_mapper.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  ActivityRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<Paginated<Activity>> searchActivities(SearchFilters filters) async {
    // Note: In a real implementation, filters would be mapped to query parameters.
    // For now we assume the map is constructed correctly here.
    final queryParams = <String, dynamic>{
      'q': filters.query,
      'city_id': filters.cityId,
      'category_id': filters.categoryId,
      'page': 1, // Default to page 1 for simple signature
      // Add other filters...
    };
    queryParams.removeWhere((key, value) => value == null);

    final response = await _dio.get('/lehiboo/v1/activities', queryParameters: queryParams);
    final data = response.data as Map<String, dynamic>;
    final items = (data['items'] as List)
        .map((e) => ActivityDto.fromJson(e as Map<String, dynamic>).toDomain())
        .toList();
    
    return Paginated<Activity>(
      items: items,
      page: data['page'] as int? ?? 1,
      totalPages: data['total_pages'] as int? ?? 1,
      totalItems: data['total_items'] as int? ?? items.length,
    );
  }

  @override
  Future<Activity> getActivity(String id) async {
    final response = await _dio.get('/lehiboo/v1/activities/$id');
    final data = response.data as Map<String, dynamic>;
    return ActivityDto.fromJson(data).toDomain();
  }
}
