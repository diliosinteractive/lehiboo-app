import 'package:freezed_annotation/freezed_annotation.dart';
import 'tool_result_dto.dart';

part 'chat_message_dto.freezed.dart';
part 'chat_message_dto.g.dart';

/// Message role
enum MessageRole {
  user,
  assistant,
  system,
}

/// DTO for a chat message
@freezed
class ChatMessageDto with _$ChatMessageDto {
  const ChatMessageDto._();

  const factory ChatMessageDto({
    String? id,
    required String role,
    required String content,
    @JsonKey(name: 'tool_results') List<ToolResultDto>? toolResults,
    @JsonKey(name: 'created_at') String? createdAt,
    @Default(false) bool isStreaming,
  }) = _ChatMessageDto;

  factory ChatMessageDto.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageDtoFromJson(json);

  /// Create a user message
  factory ChatMessageDto.user(String content) => ChatMessageDto(
        role: 'user',
        content: content,
        createdAt: DateTime.now().toIso8601String(),
      );

  /// Create an assistant message (potentially streaming)
  factory ChatMessageDto.assistant({
    required String content,
    List<ToolResultDto>? toolResults,
    bool isStreaming = false,
  }) =>
      ChatMessageDto(
        role: 'assistant',
        content: content,
        toolResults: toolResults,
        createdAt: DateTime.now().toIso8601String(),
        isStreaming: isStreaming,
      );

  bool get isUser => role == 'user';
  bool get isAssistant => role == 'assistant';
  bool get hasToolResults => toolResults != null && toolResults!.isNotEmpty;
}
