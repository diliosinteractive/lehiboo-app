import 'package:freezed_annotation/freezed_annotation.dart';

part 'membership_dto.freezed.dart';
part 'membership_dto.g.dart';

/// Status values exposed on the customer-facing memberships endpoint.
/// `suspended` exists in the backend enum but is **never** in customer
/// responses (controller filter excludes it) — see spec §18.
enum MembershipStatus { pending, active, rejected }

/// One membership row from `GET /me/memberships` or the response body of
/// `POST /organizations/{slug}/membership-request`.
///
/// Spec: docs/MEMBERSHIPS_MOBILE_SPEC.md §3.4 / §5.2
@freezed
class MembershipDto with _$MembershipDto {
  const factory MembershipDto({
    @JsonKey(fromJson: _int) required int id,
    @JsonKey(fromJson: _membershipStatus) required MembershipStatus status,
    @JsonKey(name: 'status_label', fromJson: _string) required String statusLabel,
    OrganizationSummaryDto? organization,
    @JsonKey(name: 'requested_at', fromJson: _stringOrNull) String? requestedAt,
    @JsonKey(name: 'approved_at', fromJson: _stringOrNull) String? approvedAt,
    @JsonKey(name: 'rejected_at', fromJson: _stringOrNull) String? rejectedAt,
    @JsonKey(name: 'created_at', fromJson: _stringOrNull) String? createdAt,
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

MembershipStatus _membershipStatus(dynamic v) {
  final s = v?.toString() ?? '';
  return MembershipStatus.values.firstWhere(
    (e) => e.name == s,
    orElse: () => MembershipStatus.pending,
  );
}
