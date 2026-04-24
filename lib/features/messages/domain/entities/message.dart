import 'package:equatable/equatable.dart';

class MessageAttachment extends Equatable {
  final String uuid;
  final String url;
  final String originalName;
  final String mimeType;
  final int size; // bytes
  final bool isImage;
  final bool isPdf;

  const MessageAttachment({
    required this.uuid,
    required this.url,
    required this.originalName,
    required this.mimeType,
    required this.size,
    required this.isImage,
    required this.isPdf,
  });

  @override
  List<Object?> get props => [uuid, url, originalName, mimeType, size, isImage, isPdf];
}

class MessageSender extends Equatable {
  final int id;
  final String name;
  final String? avatarUrl;

  const MessageSender({
    required this.id,
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
  final String? content; // null when deleted or attachment-only
  final bool isDeleted;
  final bool isEdited;
  final bool isRead;
  final bool isDelivered;
  final bool isMine;
  final List<MessageAttachment> attachments;
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
    required this.attachments,
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
    List<MessageAttachment>? attachments,
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
      attachments: attachments ?? this.attachments,
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
        attachments,
        createdAt,
        editedAt,
        readAt,
        deliveredAt,
      ];
}
