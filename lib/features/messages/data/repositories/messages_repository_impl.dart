import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/messages_repository.dart';
import '../datasources/messages_api_datasource.dart';
import '../models/attachment_dto.dart';
import '../models/conversation_dto.dart';
import '../models/message_dto.dart';

class MessagesRepositoryImpl implements MessagesRepository {
  final MessagesApiDataSource _api;

  MessagesRepositoryImpl(this._api);

  // ===== Mapping helpers =====

  MessageAttachment _mapAttachment(AttachmentDto dto) => MessageAttachment(
        uuid: dto.uuid,
        url: dto.url,
        originalName: dto.originalName,
        mimeType: dto.mimeType,
        size: dto.size,
        isImage: dto.isImage,
        isPdf: dto.isPdf,
      );

  MessageSender? _mapSender(MessageSenderDto? dto) {
    if (dto == null) return null;
    return MessageSender(id: dto.id, name: dto.name, avatarUrl: dto.avatarUrl);
  }

  Message _mapMessage(MessageDto dto) => Message(
        uuid: dto.uuid ?? '',
        senderType: dto.senderType,
        isSystem: dto.isSystem,
        sender: _mapSender(dto.sender),
        content: dto.content,
        isDeleted: dto.isDeleted,
        isEdited: dto.isEdited,
        isRead: dto.isRead,
        isDelivered: dto.isDelivered,
        isMine: dto.isMine,
        attachments: dto.attachments.map(_mapAttachment).toList(),
        createdAt: DateTime.parse(dto.createdAt),
        editedAt: dto.editedAt != null ? DateTime.parse(dto.editedAt!) : null,
        readAt: dto.readAt != null ? DateTime.parse(dto.readAt!) : null,
        deliveredAt:
            dto.deliveredAt != null ? DateTime.parse(dto.deliveredAt!) : null,
      );

  ConversationOrganization? _mapOrganization(ConversationOrganizationDto? dto) {
    if (dto == null) return null;
    return ConversationOrganization(
      id: dto.id,
      uuid: dto.uuid,
      companyName: dto.companyName,
      organizationName: dto.organizationName,
      logoUrl: dto.logoUrl,
      avatarUrl: dto.avatarUrl,
    );
  }

  ConversationParticipant? _mapParticipant(ConversationParticipantDto? dto) {
    if (dto == null) return null;
    return ConversationParticipant(
      id: dto.id,
      name: dto.name,
      email: dto.email,
      avatarUrl: dto.avatarUrl,
    );
  }

  ConversationEvent? _mapEvent(ConversationEventDto? dto) {
    if (dto == null) return null;
    return ConversationEvent(uuid: dto.uuid, title: dto.title, slug: dto.slug);
  }

  Conversation _mapConversation(ConversationDto dto) => Conversation(
        uuid: dto.uuid,
        subject: dto.subject,
        status: dto.status,
        conversationType: dto.conversationType,
        closedAt: dto.closedAt != null ? DateTime.parse(dto.closedAt!) : null,
        lastMessageAt: dto.lastMessageAt != null
            ? DateTime.parse(dto.lastMessageAt!)
            : null,
        unreadCount: dto.unreadCount,
        isSignalement: dto.isSignalement,
        userHasReported: dto.userHasReported,
        organization: _mapOrganization(dto.organization),
        participant: _mapParticipant(dto.participant),
        event: _mapEvent(dto.event),
        latestMessage:
            dto.latestMessage != null ? _mapMessage(dto.latestMessage!) : null,
        messages: dto.messages.map(_mapMessage).toList(),
        createdAt: DateTime.parse(dto.createdAt),
        updatedAt: DateTime.parse(dto.updatedAt),
      );

  ConversationsListResult _mapListResult(
      ConversationsListResponseDto response, int page) {
    final conversations = response.data.map(_mapConversation).toList();
    final lastPage = response.lastPage ?? 1;
    return ConversationsListResult(
      conversations: conversations,
      hasMore: page < lastPage,
      currentPage: page,
      totalCount: response.total ?? conversations.length,
    );
  }

  // ===== MessagesRepository implementation =====

  @override
  Future<ConversationsListResult> getConversations({
    String? status,
    bool? unreadOnly,
    String? search,
    int page = 1,
    int perPage = 15,
  }) async {
    final response = await _api.getConversations(
      status: status,
      unreadOnly: unreadOnly,
      search: search,
      page: page,
      perPage: perPage,
    );
    return _mapListResult(response, page);
  }

  @override
  Future<int> getUnreadCount() => _api.getUnreadCount();

  @override
  Future<Conversation> getConversation(String uuid) async {
    return _mapConversation(await _api.getConversation(uuid));
  }

  @override
  Future<Conversation> createConversation({
    required String organizationUuid,
    required String subject,
    required String message,
    String? eventId,
    List<XFile>? attachments,
  }) async {
    return _mapConversation(await _api.createConversation(
      organizationUuid: organizationUuid,
      subject: subject,
      message: message,
      eventId: eventId,
      attachments: attachments,
    ));
  }

  @override
  Future<CreateFromBookingResult> createFromBooking(String bookingUuid) async {
    final result = await _api.createFromBooking(bookingUuid);
    return CreateFromBookingResult(
      conversation: _mapConversation(result.conversation),
      created: result.created,
    );
  }

  @override
  Future<Conversation> createFromOrganization({
    required String organizationUuid,
    required String subject,
    required String message,
    String? eventId,
    List<XFile>? attachments,
  }) async {
    return _mapConversation(await _api.createFromOrganization(
      organizationUuid: organizationUuid,
      subject: subject,
      message: message,
      eventId: eventId,
      attachments: attachments,
    ));
  }

  @override
  Future<Conversation> closeConversation(String uuid) async {
    return _mapConversation(await _api.closeConversation(uuid));
  }

  @override
  Future<Message> sendMessage({
    required String conversationUuid,
    String? content,
    List<XFile>? attachments,
  }) async {
    return _mapMessage(await _api.sendMessage(
      conversationUuid: conversationUuid,
      content: content,
      attachments: attachments,
    ));
  }

  @override
  Future<Message> editMessage({
    required String conversationUuid,
    required String messageUuid,
    required String content,
  }) async {
    return _mapMessage(await _api.editMessage(
      conversationUuid: conversationUuid,
      messageUuid: messageUuid,
      content: content,
    ));
  }

  @override
  Future<void> deleteMessage({
    required String conversationUuid,
    required String messageUuid,
  }) {
    return _api.deleteMessage(
      conversationUuid: conversationUuid,
      messageUuid: messageUuid,
    );
  }

  @override
  Future<ReportConversationResult> reportConversation({
    required String conversationUuid,
    required String reason,
    String? comment,
  }) async {
    final result = await _api.reportConversation(
      conversationUuid: conversationUuid,
      reason: reason,
      comment: comment,
    );
    return ReportConversationResult(
      reportUuid: result.reportUuid,
      supportConversationUuid: result.supportConversationUuid,
    );
  }

  @override
  Future<ConversationsListResult> getSupportConversations({
    int page = 1,
    int perPage = 15,
  }) async {
    final response =
        await _api.getSupportConversations(page: page, perPage: perPage);
    return _mapListResult(response, page);
  }

  @override
  Future<int> getSupportUnreadCount() => _api.getSupportUnreadCount();

  @override
  Future<Conversation> getSupportConversation(String uuid) async {
    return _mapConversation(await _api.getSupportConversation(uuid));
  }

  @override
  Future<Conversation> createSupportConversation({
    required String subject,
    required String message,
  }) async {
    return _mapConversation(await _api.createSupportConversation(
      subject: subject,
      message: message,
    ));
  }

  @override
  Future<Message> sendSupportMessage({
    required String conversationUuid,
    required String content,
  }) async {
    return _mapMessage(await _api.sendSupportMessage(
      conversationUuid: conversationUuid,
      content: content,
    ));
  }

  @override
  Future<List<ConversationOrganization>> getContactableOrganizations() async {
    final dtos = await _api.getContactableOrganizations();
    return dtos.map((dto) => _mapOrganization(dto)!).toList();
  }
}

// Providers
final messagesRepositoryProvider = Provider<MessagesRepository>((ref) {
  throw UnimplementedError(
      'messagesRepositoryProvider must be overridden in main.dart');
});

final messagesRepositoryImplProvider = Provider<MessagesRepository>((ref) {
  return MessagesRepositoryImpl(
    ref.read(messagesApiDataSourceProvider),
  );
});
