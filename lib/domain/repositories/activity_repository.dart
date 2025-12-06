import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/domain/entities/city.dart'; // Assuming City entity exists or needs to be imported

abstract class ActivityRepository {
  Future<List<Activity>> searchActivities({
    required String query,
    Map<String, dynamic>? filters,
    int page = 1,
  });

  Future<List<City>> getTopCities();
  Future<City> getCityBySlug(String slug);

  Future<Activity?> getActivity(String id);
}

final activityRepositoryProvider = Provider<ActivityRepository>((ref) {
  throw UnimplementedError('activityRepositoryProvider not initialized');
});
