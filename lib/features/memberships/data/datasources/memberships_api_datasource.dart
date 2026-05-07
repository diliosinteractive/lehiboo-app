import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/dio_client.dart';
import '../../../events/data/models/event_dto.dart';
import '../models/invitation_dto.dart';
import '../models/membership_dto.dart';
import '../models/personalized_feed_dto.dart';

final membershipsApiDataSourceProvider =
    Provider<MembershipsApiDataSource>((ref) {
  return MembershipsApiDataSource(ref.watch(dioProvider));
});

/// Page of private events returned by `GET /me/private-events` — spec §10.2.
class PrivateEventsPage {
  final List<EventDto> events;
  final int page;
  final int perPage;
  final int total;
  final int lastPage;

  const PrivateEventsPage({
    required this.events,
    required this.page,
    required this.perPage,
    required this.total,
    required this.lastPage,
  });

  bool get hasMore => page < lastPage;
}

/// Data layer for the membership workflow — spec §2 endpoints 1-8.
///
/// All routes require `Authorization: Bearer <token>` (handled globally
/// by the JWT interceptor) except endpoint 5 (public invitation peek).
/// `X-Platform: mobile` is also injected globally by [DioClient].
class MembershipsApiDataSource {
  final Dio _dio;

  MembershipsApiDataSource(this._dio);

  /// `POST /organizations/{slug_or_uuid}/membership-request` — spec §3.
  ///
  /// 201 → returns the new pending [MembershipDto].
  /// 422 → caller should re-fetch the list and reconcile (spec §3.5 note).
  Future<MembershipDto> requestMembership(String identifier) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/organizations/$identifier/membership-request',
    );
    final body = response.data ?? const {};
    final data = body['data'];
    if (data is! Map<String, dynamic>) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        message: 'Unexpected membership-request payload',
      );
    }
    return MembershipDto.fromJson(data);
  }

  /// `DELETE /organizations/{slug_or_uuid}/membership-request` — spec §4.
  ///
  /// Single endpoint covers both "cancel pending" and "leave active". Server
  /// detects current state and applies the right transition; mobile gets a
  /// localized success message we don't need to interpret.
  Future<void> cancelOrLeaveMembership(String identifier) async {
    await _dio.delete<Map<String, dynamic>>(
      '/organizations/$identifier/membership-request',
    );
  }

  /// `GET /me/memberships` — spec §5.
  Future<MembershipsPage> getMyMemberships({
    MembershipStatus? status,
    String? search,
    int page = 1,
    int perPage = 20,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/me/memberships',
      queryParameters: {
        if (status != null) 'status': status.name,
        if (search != null && search.isNotEmpty) 'search': search,
        'page': page,
        'per_page': perPage,
      },
    );
    return MembershipsPage.fromJson(response.data ?? const {});
  }

  /// `GET /me/invitations` — spec §6. Not paginated.
  Future<List<InvitationDto>> getMyInvitations() async {
    final response = await _dio.get<Map<String, dynamic>>('/me/invitations');
    final body = response.data ?? const {};
    final list = body['data'];
    if (list is! List) return const [];
    return list
        .whereType<Map<String, dynamic>>()
        .map(InvitationDto.fromJson)
        .toList();
  }

  /// `GET /invitations/{token}` (public) — spec §7. No auth required.
  ///
  /// Accepts `200` and `410 Gone` as success — `410` still carries `data`
  /// with `is_expired`/`is_accepted` flags so the UI can render the card.
  Future<InvitationPreviewDto> peekInvitationPublic(String token) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/invitations/$token',
      options: Options(
        validateStatus: (s) => s != null && (s == 200 || s == 410),
      ),
    );
    return InvitationPreviewDto.fromJson(response.data ?? const {});
  }

  /// `GET /me/invitations/{token}` — spec §7, authenticated alias.
  Future<InvitationPreviewDto> peekInvitationAuthed(String token) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/me/invitations/$token',
      options: Options(
        validateStatus: (s) => s != null && (s == 200 || s == 410),
      ),
    );
    return InvitationPreviewDto.fromJson(response.data ?? const {});
  }

  /// `POST /me/invitations/{token}/accept` — spec §8.
  ///
  /// Returns `OrganizationMemberResource` (vendor-shaped, NOT
  /// [MembershipDto] which is `OrganizationMembershipResource`). Per spec
  /// §8.1, the caller must invalidate the memberships cache and re-fetch
  /// rather than merging this payload — so this method intentionally
  /// returns nothing useful, just resolves on success.
  Future<void> acceptInvitation(String token) async {
    await _dio.post<Map<String, dynamic>>(
      '/me/invitations/$token/accept',
    );
  }

  /// `POST /me/invitations/{token}/decline` — spec §9.
  Future<void> declineInvitation(String token) async {
    await _dio.post<Map<String, dynamic>>(
      '/me/invitations/$token/decline',
    );
  }

  /// `GET /me/personalized-feed` — spec
  /// `docs/PERSONALIZED_FEED_MOBILE_SPEC.md` §3.1 (rev 2026-05).
  ///
  /// Aggregated "Pour vous" feed. Not paginated. The `data` body is now a
  /// **grouped map** keyed by section (`favorites`, `reminders`, `private`,
  /// `booked`, `upcoming`, `ongoing`, `followed`) — no legacy flat-list
  /// fallback is supported. Cross-section overlap is intentional and is
  /// the caller's job to dedup (see [PersonalizedFeedDto] +
  /// `buildOrdered`).
  Future<PersonalizedFeedDto> getPersonalizedFeed({int limit = 8}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/me/personalized-feed',
      queryParameters: {'limit': limit},
    );
    final body = response.data ?? const {};
    final data = body['data'];
    if (data is Map<String, dynamic>) {
      return PersonalizedFeedDto.fromJson(data);
    }
    return PersonalizedFeedDto.empty();
  }

  /// `GET /me/private-events` — spec §10. Paginated event list filtered to
  /// orgs where the user is an active member.
  Future<PrivateEventsPage> getPrivateEvents({
    String? search,
    String? organizationId,
    int page = 1,
    int perPage = 15,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/me/private-events',
      queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
        if (organizationId != null && organizationId.isNotEmpty)
          'organization_id': organizationId,
        'page': page,
        'per_page': perPage,
      },
    );
    final body = response.data ?? const {};
    final data = body['data'];
    final meta = body['meta'];

    final events = data is List
        ? data
            .whereType<Map<String, dynamic>>()
            .map(EventDto.fromJson)
            .toList()
        : <EventDto>[];

    int resolvedPage = page;
    int resolvedPerPage = perPage;
    int resolvedTotal = events.length;
    int resolvedLastPage = 1;
    if (meta is Map<String, dynamic>) {
      resolvedPage = _asInt(meta['page']) ?? resolvedPage;
      resolvedPerPage = _asInt(meta['per_page']) ?? resolvedPerPage;
      resolvedTotal = _asInt(meta['total']) ?? resolvedTotal;
      resolvedLastPage = _asInt(meta['last_page']) ?? resolvedLastPage;
    }

    return PrivateEventsPage(
      events: events,
      page: resolvedPage,
      perPage: resolvedPerPage,
      total: resolvedTotal,
      lastPage: resolvedLastPage == 0 ? 1 : resolvedLastPage,
    );
  }

  int? _asInt(Object? v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v);
    return null;
  }
}
