import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_dto.freezed.dart';
part 'message_dto.g.dart';

@freezed
class MessageSenderDto with _$MessageSenderDto {
  const factory MessageSenderDto({
    int? id,
    required String name,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
  }) = _MessageSenderDto;

  factory MessageSenderDto.fromJson(Map<String, dynamic> json) =>
      _$MessageSenderDtoFromJson(json);
}

@freezed
class MessageDto with _$MessageDto {
  const factory MessageDto({
    @Default(0) int id,
    String? uuid,
    @JsonKey(name: 'conversation_id') @Default(0) int conversationId,
    @JsonKey(name: 'sender_type') required String senderType,
    @JsonKey(name: 'sender_type_label') String? senderTypeLabel,
    @JsonKey(name: 'is_system') @Default(false) bool isSystem,
    MessageSenderDto? sender,
    String? content,
    @JsonKey(name: 'is_deleted') @Default(false) bool isDeleted,
    @JsonKey(name: 'is_edited') @Default(false) bool isEdited,
    @JsonKey(name: 'is_read') @Default(false) bool isRead,
    @JsonKey(name: 'is_delivered') @Default(false) bool isDelivered,
    @JsonKey(name: 'is_mine') @Default(false) bool isMine,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'edited_at') String? editedAt,
    @JsonKey(name: 'read_at') String? readAt,
    @JsonKey(name: 'delivered_at') String? deliveredAt,
  }) = _MessageDto;

  factory MessageDto.fromJson(Map<String, dynamic> json) =>
      _$MessageDtoFromJson(json);
}
