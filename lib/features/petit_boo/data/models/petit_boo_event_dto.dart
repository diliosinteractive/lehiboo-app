import 'package:freezed_annotation/freezed_annotation.dart';

part 'petit_boo_event_dto.freezed.dart';
part 'petit_boo_event_dto.g.dart';

/// SSE Event types from Petit Boo backend
enum PetitBooEventType {
  session,
  token,
  @JsonValue('tool_call')
  toolCall,
  @JsonValue('tool_result')
  toolResult,
  error,
  done,
}

/// DTO for SSE events from Petit Boo chat API
@freezed
class PetitBooEventDto with _$PetitBooEventDto {
  const factory PetitBooEventDto({
    /// Event type: session, token, tool_call, tool_result, error, done
    required String type,

    /// Token content (for type=token)
    String? content,

    /// Session UUID (for type=session)
    @JsonKey(name: 'session_uuid') String? sessionUuid,

    /// Tool name (for type=tool_call, tool_result)
    String? tool,

    /// Tool arguments (for type=tool_call)
    Map<String, dynamic>? arguments,

    /// Tool result data (for type=tool_result)
    Map<String, dynamic>? result,

    /// Error message (for type=error)
    String? error,

    /// Error code (for type=error)
    String? code,
  }) = _PetitBooEventDto;

  factory PetitBooEventDto.fromJson(Map<String, dynamic> json) =>
      _$PetitBooEventDtoFromJson(json);
}
