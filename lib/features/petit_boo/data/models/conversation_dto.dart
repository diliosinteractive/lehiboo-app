import 'package:freezed_annotation/freezed_annotation.dart';
import 'chat_message_dto.dart';

part 'conversation_dto.freezed.dart';
part 'conversation_dto.g.dart';

/// DTO for a Petit Boo conversation/session
@freezed
class ConversationDto with _$ConversationDto {
  const factory ConversationDto({
    required String uuid,
    String? title,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    @JsonKey(name: 'message_count') @Default(0) int messageCount,
    @JsonKey(name: 'last_message') String? lastMessage,
    List<ChatMessageDto>? messages,
  }) = _ConversationDto;

  factory ConversationDto.fromJson(Map<String, dynamic> json) =>
      _$ConversationDtoFromJson(json);
}

/// Response wrapper for conversations list
@freezed
class ConversationsResponseDto with _$ConversationsResponseDto {
  const factory ConversationsResponseDto({
    required bool success,
    required List<ConversationDto> data,
    ConversationMetaDto? meta,
  }) = _ConversationsResponseDto;

  factory ConversationsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ConversationsResponseDtoFromJson(json);
}

/// Pagination meta for conversations
@freezed
class ConversationMetaDto with _$ConversationMetaDto {
  const factory ConversationMetaDto({
    required int total,
    required int page,
    @JsonKey(name: 'per_page') required int perPage,
    @JsonKey(name: 'last_page') required int lastPage,
  }) = _ConversationMetaDto;

  factory ConversationMetaDto.fromJson(Map<String, dynamic> json) =>
      _$ConversationMetaDtoFromJson(json);
}
