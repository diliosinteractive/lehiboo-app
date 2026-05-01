import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/organizer_repository.dart';
import '../datasources/organizer_api_datasource.dart';
import '../models/organizer_profile_dto.dart';
import '../../../reviews/data/models/review_dto.dart';

final organizerRepositoryImplProvider = Provider<OrganizerRepository>((ref) {
  return OrganizerRepositoryImpl(ref.watch(organizerApiDataSourceProvider));
});

class OrganizerRepositoryImpl implements OrganizerRepository {
  final OrganizerApiDataSource _api;

  OrganizerRepositoryImpl(this._api);

  @override
  Future<OrganizerProfileDto> getProfile(String identifier) =>
      _api.getOrganizerProfile(identifier);

  @override
  Future<OrganizerEventsPage> getEvents(
    String identifier, {
    int page = 1,
    int perPage = 12,
  }) =>
      _api.getOrganizerEvents(identifier, page: page, perPage: perPage);

  @override
  Future<FollowStateDto> follow(String identifier) =>
      _api.followOrganizer(identifier);

  @override
  Future<FollowStateDto> unfollow(String identifier) =>
      _api.unfollowOrganizer(identifier);

  @override
  Future<FollowedOrganizersPage> getFollowing({
    String? search,
    int page = 1,
    int perPage = 20,
  }) =>
      _api.getFollowedOrganizers(
        search: search,
        page: page,
        perPage: perPage,
      );

  @override
  Future<ReviewsResponseDto> getReviews(
    String identifier, {
    int? rating,
    bool verifiedOnly = false,
    String sortBy = 'helpful',
    String sortOrder = 'desc',
    int page = 1,
    int perPage = 20,
  }) =>
      _api.getOrganizerReviews(
        identifier,
        rating: rating,
        verifiedOnly: verifiedOnly,
        sortBy: sortBy,
        sortOrder: sortOrder,
        page: page,
        perPage: perPage,
      );

  @override
  Future<ReviewStatsDto> getReviewsStats(String identifier) =>
      _api.getOrganizerReviewsStats(identifier);
}
