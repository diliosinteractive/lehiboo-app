import 'package:freezed_annotation/freezed_annotation.dart';

part 'organizer_profile_dto.freezed.dart';
part 'organizer_profile_dto.g.dart';

/// Public organizer profile response from `GET /organizers/{slug_or_uuid}`.
///
/// Spec: docs/ORGANIZER_PROFILE_MOBILE_SPEC.md §3
@freezed
class OrganizerProfileDto with _$OrganizerProfileDto {
  const factory OrganizerProfileDto({
    required String uuid,
    required String slug,
    @JsonKey(fromJson: _string) required String name,
    @JsonKey(name: 'display_name', fromJson: _stringOrNull) String? displayName,
    @JsonKey(fromJson: _stringOrNull) String? description,
    @JsonKey(fromJson: _stringOrNull) String? logo,
    @JsonKey(name: 'cover_image', fromJson: _stringOrNull) String? coverImage,
    @JsonKey(fromJson: _stringOrNull) String? website,
    @JsonKey(fromJson: _stringOrNull) String? email,
    @JsonKey(fromJson: _stringOrNull) String? phone,
    @JsonKey(fromJson: _stringOrNull) String? address,
    @JsonKey(fromJson: _stringOrNull) String? city,
    @JsonKey(name: 'zipCode', fromJson: _stringOrNull) String? zipCode,
    @JsonKey(fromJson: _stringOrNull) String? country,
    @JsonKey(fromJson: _bool) @Default(false) bool verified,
    @JsonKey(name: 'allow_public_contact', fromJson: _bool) @Default(false)
    bool allowPublicContact,
    @JsonKey(name: 'events_count', fromJson: _int) @Default(0) int eventsCount,
    @JsonKey(name: 'followers_count', fromJson: _int) @Default(0)
    int followersCount,
    // members_count: count(active) on OrganizationMember for this org.
    // Excludes pending/rejected/suspended and the owner. Defaults to 0
    // when the backend response predates the addition.
    @JsonKey(name: 'members_count', fromJson: _int) @Default(0)
    int membersCount,
    @JsonKey(name: 'reviews_count', fromJson: _int) @Default(0)
    int reviewsCount,
    @JsonKey(name: 'average_rating', fromJson: _doubleOrNull)
    double? averageRating,
    @JsonKey(name: 'is_followed') bool? isFollowed,
    // Tri-state per spec MEMBERSHIPS_MOBILE_SPEC.md §18: null when
    // unauthenticated, false for non-owner, true when the authed user owns
    // this org. Hides the Rejoindre button on the user's own org.
    @JsonKey(name: 'is_owner') bool? isOwner,
    @JsonKey(name: 'social_links') SocialLinksDto? socialLinks,
    @JsonKey(name: 'establishment_types')
    List<EstablishmentTypeDto>? establishmentTypes,
    @JsonKey(name: 'created_at', fromJson: _stringOrNull) String? createdAt,
  }) = _OrganizerProfileDto;

  factory OrganizerProfileDto.fromJson(Map<String, dynamic> json) =>
      _$OrganizerProfileDtoFromJson(json);
}

@freezed
class SocialLinksDto with _$SocialLinksDto {
  const factory SocialLinksDto({
    @JsonKey(fromJson: _stringOrNull) String? facebook,
    @JsonKey(fromJson: _stringOrNull) String? instagram,
    @JsonKey(fromJson: _stringOrNull) String? twitter,
    @JsonKey(fromJson: _stringOrNull) String? linkedin,
    @JsonKey(fromJson: _stringOrNull) String? youtube,
  }) = _SocialLinksDto;

  factory SocialLinksDto.fromJson(Map<String, dynamic> json) =>
      _$SocialLinksDtoFromJson(json);
}

@freezed
class EstablishmentTypeDto with _$EstablishmentTypeDto {
  const factory EstablishmentTypeDto({
    required String uuid,
    @JsonKey(fromJson: _string) required String name,
    @JsonKey(fromJson: _string) required String slug,
  }) = _EstablishmentTypeDto;

  factory EstablishmentTypeDto.fromJson(Map<String, dynamic> json) =>
      _$EstablishmentTypeDtoFromJson(json);
}

/// Response payload for follow/unfollow endpoints.
///
/// Spec §5.1
@freezed
class FollowStateDto with _$FollowStateDto {
  const factory FollowStateDto({
    @JsonKey(name: 'is_followed', fromJson: _bool) required bool isFollowed,
    @JsonKey(name: 'followers_count', fromJson: _int) required int followersCount,
  }) = _FollowStateDto;

  factory FollowStateDto.fromJson(Map<String, dynamic> json) =>
      _$FollowStateDtoFromJson(json);
}

// ─── Lenient parsers ────────────────────────────────────────────────────────
// Backend occasionally sends ints as strings (or vice-versa). These keep the
// fromJson tolerant without crashing the whole profile when one field drifts.

String _string(dynamic value) => value?.toString() ?? '';

String? _stringOrNull(dynamic value) {
  if (value == null) return null;
  final s = value.toString();
  return s.isEmpty ? null : s;
}

bool _bool(dynamic value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) return value == 'true' || value == '1';
  return false;
}

int _int(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

double? _doubleOrNull(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

