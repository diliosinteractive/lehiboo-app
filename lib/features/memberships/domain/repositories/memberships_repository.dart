import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../events/data/models/event_dto.dart';
import '../../data/datasources/memberships_api_datasource.dart';
import '../../data/models/invitation_dto.dart';
import '../../data/models/membership_dto.dart';

/// Membership lifecycle (participant side) — spec §2 endpoints 1-8.
///
/// Endpoint 9 (`/me/private-events`) and 10 (`/me/personalized-feed`) live
/// outside this repository because they return event payloads, not
/// membership entities; they're wired alongside the relevant feature.
abstract class MembershipsRepository {
  Future<MembershipDto> requestMembership(String organizationIdentifier);

  Future<void> cancelOrLeaveMembership(String organizationIdentifier);

  Future<MembershipsPage> getMyMemberships({
    MembershipStatus? status,
    String? search,
    int page,
    int perPage,
  });

  Future<List<InvitationDto>> getMyInvitations();

  Future<InvitationPreviewDto> peekInvitationPublic(String token);

  Future<InvitationPreviewDto> peekInvitationAuthed(String token);

  Future<void> acceptInvitation(String token);

  Future<void> declineInvitation(String token);

  Future<PrivateEventsPage> getPrivateEvents({
    String? search,
    String? organizationId,
    int page,
    int perPage,
  });

  Future<List<EventDto>> getPersonalizedFeed({int limit});
}

final membershipsRepositoryProvider = Provider<MembershipsRepository>((ref) {
  throw UnimplementedError('membershipsRepositoryProvider not initialized');
});
