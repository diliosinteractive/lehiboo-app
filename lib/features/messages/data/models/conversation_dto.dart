import 'package:freezed_annotation/freezed_annotation.dart';
import 'message_dto.dart';

part 'conversation_dto.freezed.dart';
part 'conversation_dto.g.dart';

@freezed
class ConversationOrganizationDto with _$ConversationOrganizationDto {
  const factory ConversationOrganizationDto({
    required int id,
    required String uuid,
    @JsonKey(name: 'company_name') required String companyName,
    @JsonKey(name: 'organization_name') required String organizationName,
    @JsonKey(name: 'organization_display_name') String? organizationDisplayName,
    @JsonKey(name: 'logo_url') String? logoUrl,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
  }) = _ConversationOrganizationDto;

  factory ConversationOrganizationDto.fromJson(Map<String, dynamic> json) =>
      _$ConversationOrganizationDtoFromJson(json);
}

@freezed
class ConversationParticipantDto with _$ConversationParticipantDto {
  const factory ConversationParticipantDto({
    required int id,
    required String name,
    required String email,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
  }) = _ConversationParticipantDto;

  factory ConversationParticipantDto.fromJson(Map<String, dynamic> json) =>
      _$ConversationParticipantDtoFromJson(json);
}

@freezed
class ConversationEventDto with _$ConversationEventDto {
  const factory ConversationEventDto({
    required int id,
    required String uuid,
    required String title,
    required String slug,
  }) = _ConversationEventDto;

  factory ConversationEventDto.fromJson(Map<String, dynamic> json) =>
      _$ConversationEventDtoFromJson(json);
}

@freezed
class ConversationDto with _$ConversationDto {
  const factory ConversationDto({
    required int id,
    required String uuid,
    required String subject,
    required String status,
    @JsonKey(name: 'status_label') String? statusLabel,
    @JsonKey(name: 'conversation_type') required String conversationType,
    @JsonKey(name: 'closed_at') String? closedAt,
    @JsonKey(name: 'last_message_at') String? lastMessageAt,
    @JsonKey(name: 'unread_count') @Default(0) int unreadCount,
    @JsonKey(name: 'is_signalement') @Default(false) bool isSignalement,
    ConversationOrganizationDto? organization,
    ConversationParticipantDto? participant,
    ConversationEventDto? event,
    @JsonKey(name: 'latest_message') MessageDto? latestMessage,
    @Default([]) List<MessageDto> messages,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
  }) = _ConversationDto;

  factory ConversationDto.fromJson(Map<String, dynamic> json) =>
      _$ConversationDtoFromJson(json);
}

// Paginated list response
class ConversationsListResponseDto {
  final List<ConversationDto> data;
  final int? total;
  final int? lastPage;
  final int? currentPage;

  const ConversationsListResponseDto({
    required this.data,
    this.total,
    this.lastPage,
    this.currentPage,
  });

  factory ConversationsListResponseDto.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List? ?? [];
    final meta = json['meta'] as Map<String, dynamic>?;
    return ConversationsListResponseDto(
      data: dataList
          .map((e) => ConversationDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: meta?['total'] as int?,
      lastPage: meta?['last_page'] as int?,
      currentPage: meta?['current_page'] as int?,
    );
  }
}
