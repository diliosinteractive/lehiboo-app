import 'package:freezed_annotation/freezed_annotation.dart';

part 'membership_dto.freezed.dart';
part 'membership_dto.g.dart';

/// Status values exposed on the customer-facing memberships endpoint.
/// `suspended` exists in the backend enum but is **never** in customer
/// responses (controller filter excludes it) — see spec §18.
enum MembershipStatus { pending, active, rejected }

/// Role of the user inside an organization. Customer memberships are always
/// `viewer`; vendor staff carry `owner`, `staff`, or `admin`. The ticket
/// check-in feature filters on this — see MOBILE_CHECKIN_SPEC.md §12.2.
enum MembershipRole { owner, staff, admin, viewer }

extension MembershipRoleX on MembershipRole {
  /// Roles that grant vendor capabilities (managing events, scanning
  /// tickets) — the `viewer` role is read-only customer-side.
  bool get isVendorRole =>
      this == MembershipRole.owner ||
      this == MembershipRole.staff ||
      this == MembershipRole.admin;
}

/// One membership row from `GET /me/memberships` or the response body of
/// `POST /organizations/{slug}/membership-request`.
///
/// Spec: docs/MEMBERSHIPS_MOBILE_SPEC.md §3.4 / §5.2 (customer view) and
/// docs/MOBILE_CHECKIN_SPEC.md §12.2 (vendor view). The same endpoint
/// returns both shapes; vendor rows omit `id`/`status`/`status_label` and
/// add `role`/`is_active`.
@freezed
class MembershipDto with _$MembershipDto {
  const factory MembershipDto({
    @JsonKey(fromJson: _int) @Default(0) int id,
    @JsonKey(fromJson: _membershipStatus) @Default(MembershipStatus.active) MembershipStatus status,
    @JsonKey(name: 'status_label', fromJson: _string) @Default('') String statusLabel,
    OrganizationSummaryDto? organization,
    @JsonKey(name: 'requested_at', fromJson: _stringOrNull) String? requestedAt,
    @JsonKey(name: 'approved_at', fromJson: _stringOrNull) String? approvedAt,
    @JsonKey(name: 'rejected_at', fromJson: _stringOrNull) String? rejectedAt,
    @JsonKey(name: 'created_at', fromJson: _stringOrNull) String? createdAt,
    // Vendor view (MOBILE_CHECKIN_SPEC §12.2). Null on customer rows.
    @JsonKey(fromJson: _membershipRoleOrNull) MembershipRole? role,
    @JsonKey(name: 'is_active', fromJson: _boolOrNull) bool? isActive,
  }) = _MembershipDto;

  factory MembershipDto.fromJson(Map<String, dynamic> json) =>
      _$MembershipDtoFromJson(json);
}

/// Compact organization payload embedded in membership rows and invitations.
///
/// **Key drift handled** (spec §3.4 vs §6.2): membership rows expose
/// `logo_url`/`cover_url`; invitations expose `logo` (no `_url`). The dual
/// fields below let json_serializable populate whichever the backend sends;
/// [logoOrUrl] / [coverOrUrl] getters return the first non-empty value.
@freezed
class OrganizationSummaryDto with _$OrganizationSummaryDto {
  const factory OrganizationSummaryDto({
    @JsonKey(fromJson: _intOrNull) int? id,
    @JsonKey(fromJson: _stringOrNull) String? uuid,
    @JsonKey(fromJson: _stringOrNull) String? slug,
    @JsonKey(fromJson: _string) @Default('') String name,
    // Vendor /me/memberships shape (MOBILE_CHECKIN_SPEC §12.2) sends
    // `organization_name` instead of `name`. Kept as a separate field so
    // both shapes parse cleanly; [displayName] returns the first non-empty.
    @JsonKey(name: 'organization_name', fromJson: _stringOrNull) String? organizationName,
    @JsonKey(name: 'logo_url', fromJson: _stringOrNull) String? logoUrl,
    @JsonKey(fromJson: _stringOrNull) String? logo,
    @JsonKey(name: 'cover_url', fromJson: _stringOrNull) String? coverUrl,
    @JsonKey(fromJson: _stringOrNull) String? cover,
    @JsonKey(fromJson: _stringOrNull) String? address,
    @JsonKey(fromJson: _stringOrNull) String? city,
    @JsonKey(fromJson: _bool) @Default(false) bool verified,
    // members_count exposes count(active) on OrganizationMember for this
    // org. Excludes pending/rejected/suspended and the owner. Null when
    // the backend response predates the addition (defensive).
    @JsonKey(name: 'members_count', fromJson: _intOrNull) int? membersCount,
    @JsonKey(name: 'membersCount', fromJson: _intOrNull) int? membersCountCamel,
  }) = _OrganizationSummaryDto;

  factory OrganizationSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$OrganizationSummaryDtoFromJson(json);
}

extension OrganizationSummaryDtoX on OrganizationSummaryDto {
  String? get logoOrUrl =>
      (logoUrl != null && logoUrl!.isNotEmpty) ? logoUrl : logo;
  String? get coverOrUrl =>
      (coverUrl != null && coverUrl!.isNotEmpty) ? coverUrl : cover;
  /// Either snake or camelCase variant of members_count, whichever the
  /// backend sent. Null when the field is absent from the response.
  int? get membersCountOrNull => membersCount ?? membersCountCamel;
  /// Customer rows expose `name`; vendor rows expose `organization_name`.
  /// Returns the first non-empty value, or the empty string.
  String get displayName {
    if (name.isNotEmpty) return name;
    return organizationName ?? '';
  }
}

/// Page envelope for `GET /me/memberships` — spec §5.2.
@freezed
class MembershipsPage with _$MembershipsPage {
  const factory MembershipsPage({
    @Default([]) List<MembershipDto> data,
    MembershipsMetaDto? meta,
  }) = _MembershipsPage;

  factory MembershipsPage.fromJson(Map<String, dynamic> json) =>
      _$MembershipsPageFromJson(json);
}

@freezed
class MembershipsMetaDto with _$MembershipsMetaDto {
  const factory MembershipsMetaDto({
    @JsonKey(fromJson: _int) @Default(0) int total,
    @JsonKey(fromJson: _int) @Default(1) int page,
    @JsonKey(name: 'per_page', fromJson: _int) @Default(15) int perPage,
    @JsonKey(name: 'last_page', fromJson: _int) @Default(1) int lastPage,
  }) = _MembershipsMetaDto;

  factory MembershipsMetaDto.fromJson(Map<String, dynamic> json) =>
      _$MembershipsMetaDtoFromJson(json);
}

// ─── parsers ───────────────────────────────────────────────────────────────

String _string(dynamic v) => v?.toString() ?? '';

String? _stringOrNull(dynamic v) {
  if (v == null) return null;
  final s = v.toString();
  return s.isEmpty ? null : s;
}

int _int(dynamic v) {
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is String) return int.tryParse(v) ?? 0;
  return 0;
}

int? _intOrNull(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is String) return int.tryParse(v);
  return null;
}

bool _bool(dynamic v) {
  if (v is bool) return v;
  if (v is num) return v != 0;
  if (v is String) return v == 'true' || v == '1';
  return false;
}

bool? _boolOrNull(dynamic v) {
  if (v == null) return null;
  if (v is bool) return v;
  if (v is num) return v != 0;
  if (v is String) return v == 'true' || v == '1';
  return null;
}

MembershipStatus _membershipStatus(dynamic v) {
  final s = v?.toString() ?? '';
  return MembershipStatus.values.firstWhere(
    (e) => e.name == s,
    orElse: () => MembershipStatus.pending,
  );
}

/// Tolerant parser for the vendor `role` field. Unknown strings (or any
/// future role we haven't shipped support for) collapse to `null` so the
/// vendor filter excludes them. We deliberately don't fall back to
/// `viewer` because that would silently treat an unknown role as a
/// customer membership.
MembershipRole? _membershipRoleOrNull(dynamic v) {
  if (v == null) return null;
  final s = v.toString().toLowerCase();
  if (s.isEmpty) return null;
  for (final r in MembershipRole.values) {
    if (r.name == s) return r;
  }
  return null;
}
