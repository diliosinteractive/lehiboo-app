// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConversationOrganizationDtoImpl _$$ConversationOrganizationDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ConversationOrganizationDtoImpl(
      id: (json['id'] as num?)?.toInt() ?? 0,
      uuid: json['uuid'] as String,
      companyName: json['company_name'] as String,
      organizationName: json['organization_name'] as String,
      organizationDisplayName: json['organization_display_name'] as String?,
      logoUrl: json['logo_url'] as String?,
      avatarUrl: json['avatar_url'] as String?,
    );

Map<String, dynamic> _$$ConversationOrganizationDtoImplToJson(
        _$ConversationOrganizationDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uuid': instance.uuid,
      'company_name': instance.companyName,
      'organization_name': instance.organizationName,
      'organization_display_name': instance.organizationDisplayName,
      'logo_url': instance.logoUrl,
      'avatar_url': instance.avatarUrl,
    };

_$ConversationParticipantDtoImpl _$$ConversationParticipantDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ConversationParticipantDtoImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatar_url'] as String?,
    );

Map<String, dynamic> _$$ConversationParticipantDtoImplToJson(
        _$ConversationParticipantDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'avatar_url': instance.avatarUrl,
    };

_$ConversationEventDtoImpl _$$ConversationEventDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ConversationEventDtoImpl(
      id: (json['id'] as num).toInt(),
      uuid: json['uuid'] as String,
      title: json['title'] as String,
      slug: json['slug'] as String,
    );

Map<String, dynamic> _$$ConversationEventDtoImplToJson(
        _$ConversationEventDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uuid': instance.uuid,
      'title': instance.title,
      'slug': instance.slug,
    };

_$ConversationDtoImpl _$$ConversationDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ConversationDtoImpl(
      id: (json['id'] as num).toInt(),
      uuid: json['uuid'] as String,
      subject: json['subject'] as String,
      status: json['status'] as String,
      statusLabel: json['status_label'] as String?,
      conversationType: json['conversation_type'] as String,
      closedAt: json['closed_at'] as String?,
      lastMessageAt: json['last_message_at'] as String?,
      unreadCount: (json['unread_count'] as num?)?.toInt() ?? 0,
      isSignalement: json['is_signalement'] as bool? ?? false,
      userHasReported: json['user_has_reported'] as bool? ?? false,
      organization: json['organization'] == null
          ? null
          : ConversationOrganizationDto.fromJson(
              json['organization'] as Map<String, dynamic>),
      partnerOrganization: json['partner_organization'] == null
          ? null
          : ConversationOrganizationDto.fromJson(
              json['partner_organization'] as Map<String, dynamic>),
      participant: json['participant'] == null
          ? null
          : ConversationParticipantDto.fromJson(
              json['participant'] as Map<String, dynamic>),
      event: json['event'] == null
          ? null
          : ConversationEventDto.fromJson(
              json['event'] as Map<String, dynamic>),
      latestMessage: json['latest_message'] == null
          ? null
          : MessageDto.fromJson(json['latest_message'] as Map<String, dynamic>),
      messages: (json['messages'] as List<dynamic>?)
              ?.map((e) => MessageDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$$ConversationDtoImplToJson(
        _$ConversationDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uuid': instance.uuid,
      'subject': instance.subject,
      'status': instance.status,
      'status_label': instance.statusLabel,
      'conversation_type': instance.conversationType,
      'closed_at': instance.closedAt,
      'last_message_at': instance.lastMessageAt,
      'unread_count': instance.unreadCount,
      'is_signalement': instance.isSignalement,
      'user_has_reported': instance.userHasReported,
      'organization': instance.organization,
      'partner_organization': instance.partnerOrganization,
      'participant': instance.participant,
      'event': instance.event,
      'latest_message': instance.latestMessage,
      'messages': instance.messages,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
