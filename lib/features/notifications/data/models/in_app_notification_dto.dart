import '../../domain/entities/in_app_notification.dart';

class InAppNotificationDto {
  final String id;
  final String type;
  final String title;
  final String message;
  final String? actionUrl;
  final Map<String, dynamic> data;
  final DateTime? readAt;
  final bool isRead;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const InAppNotificationDto({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    this.actionUrl,
    required this.data,
    this.readAt,
    required this.isRead,
    this.createdAt,
    this.updatedAt,
  });

  factory InAppNotificationDto.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];

    return InAppNotificationDto(
      id: _string(json['id']) ?? '',
      type: _string(json['type']) ??
          _string(_asMap(rawData)?['type']) ??
          'generic',
      title: _string(json['title']) ?? 'Notification',
      message: _string(json['message']) ?? '',
      actionUrl: _blankToNull(_string(json['action_url'])),
      data: _asMap(rawData) ?? const {},
      readAt: _date(json['read_at']),
      isRead: _bool(json['is_read']) ?? json['read_at'] != null,
      createdAt: _date(json['created_at']),
      updatedAt: _date(json['updated_at']),
    );
  }

  InAppNotification toDomain() {
    return InAppNotification(
      id: id,
      type: type,
      title: title,
      message: message,
      actionUrl: actionUrl,
      data: data,
      readAt: readAt,
      isRead: isRead,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static String? _string(dynamic value) {
    if (value == null) return null;
    final result = value.toString();
    return result.isEmpty ? null : result;
  }

  static String? _blankToNull(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return value;
  }

  static bool? _bool(dynamic value) {
    if (value is bool) return value;
    if (value is int) return value != 0;
    if (value is String) {
      final normalized = value.toLowerCase();
      if (normalized == 'true' || normalized == '1') return true;
      if (normalized == 'false' || normalized == '0') return false;
    }
    return null;
  }

  static DateTime? _date(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }

  static Map<String, dynamic>? _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map((key, value) => MapEntry(key.toString(), value));
    }
    return null;
  }
}
