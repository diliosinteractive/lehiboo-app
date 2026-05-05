// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MembershipDtoImpl _$$MembershipDtoImplFromJson(Map<String, dynamic> json) =>
    _$MembershipDtoImpl(
      id: json['id'] == null ? 0 : _int(json['id']),
      status: json['status'] == null
          ? MembershipStatus.active
          : _membershipStatus(json['status']),
      statusLabel:
          json['status_label'] == null ? '' : _string(json['status_label']),
      organization: json['organization'] == null
          ? null
          : OrganizationSummaryDto.fromJson(
              json['organization'] as Map<String, dynamic>),
      requestedAt: _stringOrNull(json['requested_at']),
      approvedAt: _stringOrNull(json['approved_at']),
      rejectedAt: _stringOrNull(json['rejected_at']),
      createdAt: _stringOrNull(json['created_at']),
      role: _membershipRoleOrNull(json['role']),
      isActive: _boolOrNull(json['is_active']),
    );

Map<String, dynamic> _$$MembershipDtoImplToJson(_$MembershipDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': _$MembershipStatusEnumMap[instance.status]!,
      'status_label': instance.statusLabel,
      'organization': instance.organization,
      'requested_at': instance.requestedAt,
      'approved_at': instance.approvedAt,
      'rejected_at': instance.rejectedAt,
      'created_at': instance.createdAt,
      'role': _$MembershipRoleEnumMap[instance.role],
      'is_active': instance.isActive,
    };

const _$MembershipStatusEnumMap = {
  MembershipStatus.pending: 'pending',
  MembershipStatus.active: 'active',
  MembershipStatus.rejected: 'rejected',
};

const _$MembershipRoleEnumMap = {
  MembershipRole.owner: 'owner',
  MembershipRole.staff: 'staff',
  MembershipRole.admin: 'admin',
  MembershipRole.viewer: 'viewer',
};

_$OrganizationSummaryDtoImpl _$$OrganizationSummaryDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$OrganizationSummaryDtoImpl(
      id: _intOrNull(json['id']),
      uuid: _stringOrNull(json['uuid']),
      slug: _stringOrNull(json['slug']),
      name: json['name'] == null ? '' : _string(json['name']),
      organizationName: _stringOrNull(json['organization_name']),
      logoUrl: _stringOrNull(json['logo_url']),
      logo: _stringOrNull(json['logo']),
      coverUrl: _stringOrNull(json['cover_url']),
      cover: _stringOrNull(json['cover']),
      address: _stringOrNull(json['address']),
      city: _stringOrNull(json['city']),
      verified: json['verified'] == null ? false : _bool(json['verified']),
      membersCount: _intOrNull(json['members_count']),
      membersCountCamel: _intOrNull(json['membersCount']),
    );

Map<String, dynamic> _$$OrganizationSummaryDtoImplToJson(
        _$OrganizationSummaryDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uuid': instance.uuid,
      'slug': instance.slug,
      'name': instance.name,
      'organization_name': instance.organizationName,
      'logo_url': instance.logoUrl,
      'logo': instance.logo,
      'cover_url': instance.coverUrl,
      'cover': instance.cover,
      'address': instance.address,
      'city': instance.city,
      'verified': instance.verified,
      'members_count': instance.membersCount,
      'membersCount': instance.membersCountCamel,
    };

_$MembershipsPageImpl _$$MembershipsPageImplFromJson(
        Map<String, dynamic> json) =>
    _$MembershipsPageImpl(
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => MembershipDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      meta: json['meta'] == null
          ? null
          : MembershipsMetaDto.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$MembershipsPageImplToJson(
        _$MembershipsPageImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
      'meta': instance.meta,
    };

_$MembershipsMetaDtoImpl _$$MembershipsMetaDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$MembershipsMetaDtoImpl(
      total: json['total'] == null ? 0 : _int(json['total']),
      page: json['page'] == null ? 1 : _int(json['page']),
      perPage: json['per_page'] == null ? 15 : _int(json['per_page']),
      lastPage: json['last_page'] == null ? 1 : _int(json['last_page']),
    );

Map<String, dynamic> _$$MembershipsMetaDtoImplToJson(
        _$MembershipsMetaDtoImpl instance) =>
    <String, dynamic>{
      'total': instance.total,
      'page': instance.page,
      'per_page': instance.perPage,
      'last_page': instance.lastPage,
    };
