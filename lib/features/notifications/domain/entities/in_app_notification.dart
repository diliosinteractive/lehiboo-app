import 'package:equatable/equatable.dart';

class InAppNotification extends Equatable {
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

  const InAppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    this.actionUrl,
    this.data = const {},
    this.readAt,
    required this.isRead,
    this.createdAt,
    this.updatedAt,
  });

  InAppNotification copyWith({
    String? id,
    String? type,
    String? title,
    String? message,
    String? actionUrl,
    Map<String, dynamic>? data,
    DateTime? readAt,
    bool clearReadAt = false,
    bool? isRead,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return InAppNotification(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      actionUrl: actionUrl ?? this.actionUrl,
      data: data ?? this.data,
      readAt: clearReadAt ? null : (readAt ?? this.readAt),
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        type,
        title,
        message,
        actionUrl,
        data,
        readAt,
        isRead,
        createdAt,
        updatedAt,
      ];
}

class InAppNotificationsPage extends Equatable {
  final List<InAppNotification> notifications;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  const InAppNotificationsPage({
    required this.notifications,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  bool get hasMore => currentPage < lastPage;

  @override
  List<Object?> get props => [
        notifications,
        currentPage,
        lastPage,
        perPage,
        total,
      ];
}
