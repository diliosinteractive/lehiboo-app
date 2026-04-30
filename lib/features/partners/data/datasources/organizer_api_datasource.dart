import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/dio_client.dart';
import '../../../events/data/models/event_dto.dart';
import '../models/organizer_profile_dto.dart';

final organizerApiDataSourceProvider = Provider<OrganizerApiDataSource>((ref) {
  return OrganizerApiDataSource(ref.watch(dioProvider));
});

/// Page of organizer events, aligned with spec §4.3.
///
/// `meta.last_page` lets the caller stop pagination cleanly.
class OrganizerEventsPage {
  final List<EventDto> events;
  final int page;
  final int perPage;
  final int total;
  final int lastPage;

  const OrganizerEventsPage({
    required this.events,
    required this.page,
    required this.perPage,
    required this.total,
    required this.lastPage,
  });

  bool get hasMore => page < lastPage;
}

/// Page of the user's followed organizers — spec §6bis.5.
class FollowedOrganizersPage {
  final List<OrganizerProfileDto> items;
  final int page;
  final int perPage;
  final int total;
  final int lastPage;

  const FollowedOrganizersPage({
    required this.items,
    required this.page,
    required this.perPage,
    required this.total,
    required this.lastPage,
  });

  bool get hasMore => page < lastPage;
}

/// Single entry-point for the four organizer endpoints.
///
/// Spec: docs/ORGANIZER_PROFILE_MOBILE_SPEC.md §2
class OrganizerApiDataSource {
  final Dio _dio;

  OrganizerApiDataSource(this._dio);

  /// `GET /organizers/{slug_or_uuid}` — spec §3
  Future<OrganizerProfileDto> getOrganizerProfile(String identifier) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/organizers/$identifier',
    );
    final body = response.data ?? const {};
    final data = body['data'];
    if (data is! Map<String, dynamic>) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        message: 'Unexpected organizer profile shape',
      );
    }
    return OrganizerProfileDto.fromJson(data);
  }

  /// `GET /organizers/{slug_or_uuid}/events` — spec §4
  ///
  /// The spec defines a flat `data: [events]` + `meta` envelope. The earlier
  /// service shape (`data.data.events`) is still accepted as a fallback so
  /// in-flight backend rollouts don't break the screen.
  Future<OrganizerEventsPage> getOrganizerEvents(
    String identifier, {
    int page = 1,
    int perPage = 12,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/organizers/$identifier/events',
        queryParameters: {'page': page, 'per_page': perPage},
      );
      return _parseEventsPage(response.data ?? const {}, page, perPage);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return OrganizerEventsPage(
          events: const [],
          page: page,
          perPage: perPage,
          total: 0,
          lastPage: 1,
        );
      }
      rethrow;
    }
  }

  /// `POST /me/organizers/{slug_or_uuid}/follow` — spec §5
  Future<FollowStateDto> followOrganizer(String identifier) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/me/organizers/$identifier/follow',
    );
    return _parseFollowState(response.data ?? const {});
  }

  /// `DELETE /me/organizers/{slug_or_uuid}/follow` — spec §5
  Future<FollowStateDto> unfollowOrganizer(String identifier) async {
    final response = await _dio.delete<Map<String, dynamic>>(
      '/me/organizers/$identifier/follow',
    );
    return _parseFollowState(response.data ?? const {});
  }

  /// `GET /me/organizers/following` — spec §6bis
  ///
  /// Paginated list of the authed user's followed organizers, optionally
  /// filtered by [search] (full-text on org name fields). Each item is a
  /// full [OrganizerProfileDto] with `is_followed = true`.
  Future<FollowedOrganizersPage> getFollowedOrganizers({
    String? search,
    int page = 1,
    int perPage = 20,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/me/organizers/following',
      queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
        'page': page,
        'per_page': perPage,
      },
    );
    final body = response.data ?? const {};
    final data = body['data'];
    final meta = body['meta'];

    final items = data is List
        ? data
            .whereType<Map<String, dynamic>>()
            .map(OrganizerProfileDto.fromJson)
            .toList()
        : <OrganizerProfileDto>[];

    int resolvedPage = page;
    int resolvedPerPage = perPage;
    int resolvedTotal = items.length;
    int resolvedLastPage = 1;
    if (meta is Map<String, dynamic>) {
      resolvedPage = _asInt(meta['page']) ?? resolvedPage;
      resolvedPerPage = _asInt(meta['per_page']) ?? resolvedPerPage;
      resolvedTotal = _asInt(meta['total']) ?? resolvedTotal;
      resolvedLastPage = _asInt(meta['last_page']) ?? resolvedLastPage;
    }

    return FollowedOrganizersPage(
      items: items,
      page: resolvedPage,
      perPage: resolvedPerPage,
      total: resolvedTotal,
      lastPage: resolvedLastPage == 0 ? 1 : resolvedLastPage,
    );
  }

  // ─── helpers ───────────────────────────────────────────────────────────

  OrganizerEventsPage _parseEventsPage(
    Map<String, dynamic> body,
    int requestedPage,
    int requestedPerPage,
  ) {
    final dynamic data = body['data'];
    final dynamic meta = body['meta'];

    List<EventDto> events;
    int page = requestedPage;
    int perPage = requestedPerPage;
    int total = 0;
    int lastPage = 1;

    if (data is List) {
      events = data
          .whereType<Map<String, dynamic>>()
          .map(EventDto.fromJson)
          .toList();
    } else if (data is Map<String, dynamic> && data['events'] is List) {
      events = (data['events'] as List)
          .whereType<Map<String, dynamic>>()
          .map(EventDto.fromJson)
          .toList();
      final pagination = data['pagination'];
      if (pagination is Map<String, dynamic>) {
        page = _asInt(pagination['current_page']) ?? page;
        perPage = _asInt(pagination['per_page']) ?? perPage;
        total = _asInt(pagination['total_items']) ?? 0;
        lastPage = _asInt(pagination['total_pages']) ?? 1;
      }
    } else {
      events = const [];
    }

    if (meta is Map<String, dynamic>) {
      page = _asInt(meta['page']) ?? page;
      perPage = _asInt(meta['per_page']) ?? perPage;
      total = _asInt(meta['total']) ?? total;
      lastPage = _asInt(meta['last_page']) ?? lastPage;
    }

    return OrganizerEventsPage(
      events: events,
      page: page,
      perPage: perPage,
      total: total,
      lastPage: lastPage == 0 ? 1 : lastPage,
    );
  }

  FollowStateDto _parseFollowState(Map<String, dynamic> body) {
    final data = body['data'];
    if (data is Map<String, dynamic>) {
      return FollowStateDto.fromJson(data);
    }
    if (kDebugMode) {
      debugPrint('OrganizerApiDataSource: unexpected follow response: $body');
    }
    throw const FormatException('Missing follow state payload');
  }

  int? _asInt(Object? v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v);
    return null;
  }
}
