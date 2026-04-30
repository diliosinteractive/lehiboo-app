import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/organizer_api_datasource.dart';
import '../../data/models/organizer_profile_dto.dart';

/// Public organizer profile + follow operations.
///
/// Spec: docs/ORGANIZER_PROFILE_MOBILE_SPEC.md
abstract class OrganizerRepository {
  Future<OrganizerProfileDto> getProfile(String identifier);

  Future<OrganizerEventsPage> getEvents(
    String identifier, {
    int page,
    int perPage,
  });

  Future<FollowStateDto> follow(String identifier);

  Future<FollowStateDto> unfollow(String identifier);

  Future<FollowedOrganizersPage> getFollowing({
    String? search,
    int page,
    int perPage,
  });
}

final organizerRepositoryProvider = Provider<OrganizerRepository>((ref) {
  throw UnimplementedError('organizerRepositoryProvider not initialized');
});
