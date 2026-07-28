import 'package:equatable/equatable.dart';

class MessageSender extends Equatable {
  final int? id;
  final String name;
  final String? avatarUrl;

  const MessageSender({
    this.id,
    required this.name,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [id, name, avatarUrl];
}

class Message extends Equatable {
  final String uuid;
  final String senderType; // 'participant' | 'organization' | 'admin' | 'system'
  final bool isSystem;
  final MessageSender? sender;
  final String? content; // null when deleted
  final bool isDeleted;
  final bool isEdited;
  final bool isRead;
  final bool isDelivered;
  final bool isMine;
  final DateTime createdAt;
  final DateTime? editedAt;
  final DateTime? readAt;
  final DateTime? deliveredAt;

  const Message({
    required this.uuid,
    required this.senderType,
    required this.isSystem,
    this.sender,
    this.content,
    required this.isDeleted,
    required this.isEdited,
    required this.isRead,
    required this.isDelivered,
    required this.isMine,
    required this.createdAt,
    this.editedAt,
    this.readAt,
    this.deliveredAt,
  });

  Message copyWith({
    String? uuid,
    String? senderType,
    bool? isSystem,
    MessageSender? sender,
    String? content,
    bool? isDeleted,
    bool? isEdited,
    bool? isRead,
    bool? isDelivered,
    bool? isMine,
    DateTime? createdAt,
    DateTime? editedAt,
    DateTime? readAt,
    DateTime? deliveredAt,
  }) {
    return Message(
      uuid: uuid ?? this.uuid,
      senderType: senderType ?? this.senderType,
      isSystem: isSystem ?? this.isSystem,
      sender: sender ?? this.sender,
      content: content ?? this.content,
      isDeleted: isDeleted ?? this.isDeleted,
      isEdited: isEdited ?? this.isEdited,
      isRead: isRead ?? this.isRead,
      isDelivered: isDelivered ?? this.isDelivered,
      isMine: isMine ?? this.isMine,
      createdAt: createdAt ?? this.createdAt,
      editedAt: editedAt ?? this.editedAt,
      readAt: readAt ?? this.readAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
    );
  }

  @override
  List<Object?> get props => [
        uuid,
        senderType,
        isSystem,
        sender,
        content,
        isDeleted,
        isEdited,
        isRead,
        isDelivered,
        isMine,
        createdAt,
        editedAt,
        readAt,
        deliveredAt,
      ];
}
