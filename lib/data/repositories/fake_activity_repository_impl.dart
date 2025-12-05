import 'dart:convert';
import 'package:lehiboo/core/mock/mock_data.dart';
import 'package:lehiboo/data/mappers/activity_mapper.dart';
import 'package:lehiboo/data/models/activity_dto.dart';
import 'package:lehiboo/domain/entities/activity.dart';
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
}
