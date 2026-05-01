import 'package:freezed_annotation/freezed_annotation.dart';

import 'membership_dto.dart';

part 'invitation_dto.freezed.dart';
part 'invitation_dto.g.dart';

/// One pending invitation — spec §6.2.
///
/// Returned by `GET /me/invitations` (list) and `GET /(me/)invitations/{token}`
/// (peek, public + auth). The same DTO covers both with [hasAccount] only
/// populated on the public token view.
@freezed
class InvitationDto with _$InvitationDto {
  const factory InvitationDto({
    @JsonKey(fromJson: _int) required int id,
    @JsonKey(fromJson: _stringOrNull) String? type,
    @JsonKey(fromJson: _string) @Default('') String email,
    @JsonKey(fromJson: _stringOrNull) String? role,
    @JsonKey(name: 'role_label', fromJson: _stringOrNull) String? roleLabel,
    @JsonKey(name: 'is_valid', fromJson: _bool) @Default(false) bool isValid,
    @JsonKey(name: 'is_expired', fromJson: _bool) @Default(false) bool isExpired,
    @JsonKey(name: 'is_accepted', fromJson: _bool) @Default(false)
    bool isAccepted,
    @JsonKey(name: 'has_account', fromJson: _boolOrNull) bool? hasAccount,
    @JsonKey(fromJson: _stringOrNull) String? token,
    OrganizationSummaryDto? organization,
    @JsonKey(name: 'invited_by') InvitedByDto? invitedBy,
    @JsonKey(name: 'expires_at', fromJson: _stringOrNull) String? expiresAt,
    @JsonKey(name: 'accepted_at', fromJson: _stringOrNull) String? acceptedAt,
    @JsonKey(name: 'created_at', fromJson: _stringOrNull) String? createdAt,
    @JsonKey(name: 'updated_at', fromJson: _stringOrNull) String? updatedAt,
  }) = _InvitationDto;

  factory InvitationDto.fromJson(Map<String, dynamic> json) =>
      _$InvitationDtoFromJson(json);
}

@freezed
class InvitedByDto with _$InvitedByDto {
  const factory InvitedByDto({
    @JsonKey(fromJson: _stringOrNull) String? uuid,
    @JsonKey(fromJson: _string) @Default('') String name,
    @JsonKey(fromJson: _stringOrNull) String? avatar,
  }) = _InvitedByDto;

  factory InvitedByDto.fromJson(Map<String, dynamic> json) =>
      _$InvitedByDtoFromJson(json);
}

/// Wrapper for `GET /(me/)invitations/{token}` — spec §7.1.
///
/// Renders even on `410 Gone` because the body still carries `data` with
/// `is_expired: true` / `is_accepted: true` for context (spec §7.2). The
/// datasource must use `validateStatus: (s) => s == 200 || s == 410`.
@freezed
class InvitationPreviewDto with _$InvitationPreviewDto {
  const factory InvitationPreviewDto({
    InvitationDto? data,
    InvitationPreviewMetaDto? meta,
    @JsonKey(fromJson: _stringOrNull) String? message,
  }) = _InvitationPreviewDto;

  factory InvitationPreviewDto.fromJson(Map<String, dynamic> json) =>
      _$InvitationPreviewDtoFromJson(json);
}

@freezed
class InvitationPreviewMetaDto with _$InvitationPreviewMetaDto {
  const factory InvitationPreviewMetaDto({
    @JsonKey(name: 'is_valid', fromJson: _bool) @Default(false) bool isValid,
    @JsonKey(name: 'expires_in_hours', fromJson: _intOrNull) int? expiresInHours,
    @JsonKey(name: 'organization_name', fromJson: _stringOrNull)
    String? organizationName,
    @JsonKey(fromJson: _stringOrNull) String? role,
    @JsonKey(name: 'role_label', fromJson: _stringOrNull) String? roleLabel,
  }) = _InvitationPreviewMetaDto;

  factory InvitationPreviewMetaDto.fromJson(Map<String, dynamic> json) =>
      _$InvitationPreviewMetaDtoFromJson(json);
}

// ─── parsers (mirror of membership_dto.dart's helpers) ─────────────────────

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
