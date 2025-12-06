import 'dart:convert';
import 'package:lehiboo/core/mock/mock_data.dart';
import 'package:lehiboo/data/mappers/activity_mapper.dart';
import 'package:lehiboo/data/models/activity_dto.dart';
import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/domain/entities/city.dart';
import 'package:lehiboo/domain/repositories/activity_repository.dart';

class FakeActivityRepositoryImpl implements ActivityRepository {
  @override
  Future<List<Activity>> searchActivities({
    required String query,
    Map<String, dynamic>? filters,
    int page = 1,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));
    
    final List<dynamic> jsonList = jsonDecode(MockData.activities);
    final dtos = jsonList.map((j) => ActivityDto.fromJson(j)).toList();
    
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<Activity?> getActivity(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    final List<dynamic> jsonList = jsonDecode(MockData.activities);
    final jsonItem = jsonList.firstWhere(
      (element) => element['id'].toString() == id,
      orElse: () => null,
    );
    
    if (jsonItem == null) return null;
    return ActivityDto.fromJson(jsonItem).toDomain();
  }
  @override
  Future<List<City>> getTopCities() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final List<dynamic> jsonList = json.decode(MockData.cities);
    // Take first 6 as top cities
    return jsonList.take(6).map((json) => City.fromJson(json)).toList();
  }

  @override
  Future<City> getCityBySlug(String slug) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final List<dynamic> jsonList = json.decode(MockData.cities);
    final cityJson = jsonList.firstWhere(
      (c) => c['slug'] == slug,
      orElse: () => throw Exception('City not found'),
    );
    return City.fromJson(cityJson);
  }
}
