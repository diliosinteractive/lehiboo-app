import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/memberships_repository.dart';
import '../datasources/memberships_api_datasource.dart';
import '../models/invitation_dto.dart';
import '../models/membership_dto.dart';
import '../models/personalized_feed_dto.dart';

final membershipsRepositoryImplProvider = Provider<MembershipsRepository>((ref) {
  return MembershipsRepositoryImpl(ref.watch(membershipsApiDataSourceProvider));
});

class MembershipsRepositoryImpl implements MembershipsRepository {
  final MembershipsApiDataSource _api;

  MembershipsRepositoryImpl(this._api);

  @override
  Future<MembershipDto> requestMembership(String organizationIdentifier) =>
      _api.requestMembership(organizationIdentifier);

  @override
  Future<void> cancelOrLeaveMembership(String organizationIdentifier) =>
      _api.cancelOrLeaveMembership(organizationIdentifier);

  @override
  Future<MembershipsPage> getMyMemberships({
    MembershipStatus? status,
    String? search,
    int page = 1,
    int perPage = 20,
  }) =>
      _api.getMyMemberships(
        status: status,
        search: search,
        page: page,
        perPage: perPage,
      );

  @override
  Future<List<InvitationDto>> getMyInvitations() => _api.getMyInvitations();

  @override
  Future<InvitationPreviewDto> peekInvitationPublic(String token) =>
      _api.peekInvitationPublic(token);

  @override
  Future<InvitationPreviewDto> peekInvitationAuthed(String token) =>
      _api.peekInvitationAuthed(token);

  @override
  Future<void> acceptInvitation(String token) => _api.acceptInvitation(token);

  @override
  Future<void> declineInvitation(String token) =>
      _api.declineInvitation(token);

  @override
  Future<PrivateEventsPage> getPrivateEvents({
    String? search,
    String? organizationId,
    int page = 1,
    int perPage = 15,
  }) =>
      _api.getPrivateEvents(
        search: search,
        organizationId: organizationId,
        page: page,
        perPage: perPage,
      );

  @override
  Future<PersonalizedFeedDto> getPersonalizedFeed({int limit = 8}) =>
      _api.getPersonalizedFeed(limit: limit);
}
