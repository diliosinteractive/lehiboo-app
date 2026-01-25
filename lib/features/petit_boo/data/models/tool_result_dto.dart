import 'package:freezed_annotation/freezed_annotation.dart';

part 'tool_result_dto.freezed.dart';
part 'tool_result_dto.g.dart';

/// Helper to read 'data' or 'result' field (backend sends different keys)
/// - SSE events send 'data'
/// - History endpoint sends 'result'
Object? _readDataOrResult(Map<dynamic, dynamic> json, String key) {
  return json['data'] ?? json['result'] ?? <String, dynamic>{};
}

/// DTO for tool execution result from Petit Boo
///
/// This is the simplified version that stores raw data.
/// The UI rendering is handled dynamically based on tool schemas
/// fetched from the API (/api/v1/tools).
@freezed
class ToolResultDto with _$ToolResultDto {
  const ToolResultDto._();

  const factory ToolResultDto({
    /// Tool name (e.g., 'getMyFavorites', 'searchEvents')
    required String tool,

    /// Tool-specific result data (raw Map)
    /// Backend sends 'result' in history, 'data' in SSE events
    @JsonKey(readValue: _readDataOrResult)
    required Map<String, dynamic> data,

    /// Timestamp of tool execution
    @JsonKey(name: 'executed_at') String? executedAt,
  }) = _ToolResultDto;

  factory ToolResultDto.fromJson(Map<String, dynamic> json) =>
      _$ToolResultDtoFromJson(json);

  /// Check if this result has a success status
  bool get isSuccess => data['success'] != false;

  /// Get error message if present
  String? get errorMessage {
    final error = data['error'];
    if (error is String) return error;
    if (error is Map) return error['message'] as String?;
    return data['message'] as String?;
  }

  /// Get item count from common keys
  int? get itemCount {
    // Try common count keys
    for (final key in ['total', 'count', 'total_count']) {
      final value = data[key];
      if (value is int) return value;
    }

    // Try to count list items from known keys
    for (final key in [
      'events',
      'favorites',
      'bookings',
      'tickets',
      'alerts',
      'notifications',
    ]) {
      final value = data[key];
      if (value is List) return value.length;
    }

    return null;
  }
}
