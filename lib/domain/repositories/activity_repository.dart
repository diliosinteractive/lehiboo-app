import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lehiboo/domain/entities/activity.dart';

abstract class ActivityRepository {
  Future<List<Activity>> searchActivities({
    required String query,
    Map<String, dynamic>? filters,
    int page = 1,
  });

  Future<Activity?> getActivity(String id);
}

final activityRepositoryProvider = Provider<ActivityRepository>((ref) {
  throw UnimplementedError('activityRepositoryProvider not initialized');
});
