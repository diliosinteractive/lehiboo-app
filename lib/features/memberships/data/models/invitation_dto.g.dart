// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invitation_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InvitationDtoImpl _$$InvitationDtoImplFromJson(Map<String, dynamic> json) =>
    _$InvitationDtoImpl(
      id: _int(json['id']),
      type: _stringOrNull(json['type']),
      email: json['email'] == null ? '' : _string(json['email']),
      role: _stringOrNull(json['role']),
      roleLabel: _stringOrNull(json['role_label']),
      isValid: json['is_valid'] == null ? false : _bool(json['is_valid']),
      isExpired: json['is_expired'] == null ? false : _bool(json['is_expired']),
      isAccepted:
          json['is_accepted'] == null ? false : _bool(json['is_accepted']),
      hasAccount: _boolOrNull(json['has_account']),
      token: _stringOrNull(json['token']),
      organization: json['organization'] == null
          ? null
          : OrganizationSummaryDto.fromJson(
              json['organization'] as Map<String, dynamic>),
      invitedBy: json['invited_by'] == null
          ? null
          : InvitedByDto.fromJson(json['invited_by'] as Map<String, dynamic>),
      expiresAt: _stringOrNull(json['expires_at']),
      acceptedAt: _stringOrNull(json['accepted_at']),
      createdAt: _stringOrNull(json['created_at']),
      updatedAt: _stringOrNull(json['updated_at']),
    );

Map<String, dynamic> _$$InvitationDtoImplToJson(_$InvitationDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'email': instance.email,
      'role': instance.role,
      'role_label': instance.roleLabel,
      'is_valid': instance.isValid,
      'is_expired': instance.isExpired,
      'is_accepted': instance.isAccepted,
      'has_account': instance.hasAccount,
      'token': instance.token,
      'organization': instance.organization,
      'invited_by': instance.invitedBy,
      'expires_at': instance.expiresAt,
      'accepted_at': instance.acceptedAt,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

_$InvitedByDtoImpl _$$InvitedByDtoImplFromJson(Map<String, dynamic> json) =>
    _$InvitedByDtoImpl(
      uuid: _stringOrNull(json['uuid']),
      name: json['name'] == null ? '' : _string(json['name']),
      avatar: _stringOrNull(json['avatar']),
    );

Map<String, dynamic> _$$InvitedByDtoImplToJson(_$InvitedByDtoImpl instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'avatar': instance.avatar,
    };

_$InvitationPreviewDtoImpl _$$InvitationPreviewDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$InvitationPreviewDtoImpl(
      data: json['data'] == null
          ? null
          : InvitationDto.fromJson(json['data'] as Map<String, dynamic>),
      meta: json['meta'] == null
          ? null
          : InvitationPreviewMetaDto.fromJson(
              json['meta'] as Map<String, dynamic>),
      message: _stringOrNull(json['message']),
    );

Map<String, dynamic> _$$InvitationPreviewDtoImplToJson(
        _$InvitationPreviewDtoImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
      'meta': instance.meta,
      'message': instance.message,
    };

_$InvitationPreviewMetaDtoImpl _$$InvitationPreviewMetaDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$InvitationPreviewMetaDtoImpl(
      isValid: json['is_valid'] == null ? false : _bool(json['is_valid']),
      expiresInHours: _intOrNull(json['expires_in_hours']),
      organizationName: _stringOrNull(json['organization_name']),
      role: _stringOrNull(json['role']),
      roleLabel: _stringOrNull(json['role_label']),
    );

Map<String, dynamic> _$$InvitationPreviewMetaDtoImplToJson(
        _$InvitationPreviewMetaDtoImpl instance) =>
    <String, dynamic>{
      'is_valid': instance.isValid,
      'expires_in_hours': instance.expiresInHours,
      'organization_name': instance.organizationName,
      'role': instance.role,
      'role_label': instance.roleLabel,
    };
