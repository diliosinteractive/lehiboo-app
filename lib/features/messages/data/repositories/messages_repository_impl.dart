import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/accepted_partner.dart';
import '../../domain/entities/admin_report_stats.dart';
import '../../domain/entities/broadcast.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/entities/conversation_report.dart';
import '../../domain/entities/message.dart';
import '../../domain/entities/vendor_stats.dart';
import '../../domain/repositories/messages_repository.dart';
import '../datasources/messages_api_datasource.dart';
import '../models/accepted_partner_dto.dart';
import '../models/admin_report_stats_dto.dart';
import '../models/broadcast_dto.dart';
import '../models/conversation_dto.dart';
import '../models/conversation_report_dto.dart';
import '../models/message_dto.dart';
import '../models/vendor_stats_dto.dart';

class MessagesRepositoryImpl implements MessagesRepository {
  final MessagesApiDataSource _api;

  MessagesRepositoryImpl(this._api);

  // ===== Mapping helpers =====

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
        partnerOrganization: _mapOrganization(dto.partnerOrganization),
        participant: _mapParticipant(dto.participant),
        event: _mapEvent(dto.event),
        latestMessage:
            dto.latestMessage != null ? _mapMessage(dto.latestMessage!) : null,
        messages: dto.messages.map(_mapMessage).toList(),
        createdAt: DateTime.parse(dto.createdAt),
        updatedAt: DateTime.parse(dto.updatedAt),
      );

  AcceptedPartner _mapAcceptedPartner(AcceptedPartnerDto dto) => AcceptedPartner(
        id: dto.id,
        companyName: dto.companyName,
        organizationName: dto.organizationName,
        logoUrl: dto.logoUrl,
        avatarUrl: dto.avatarUrl,
      );

  VendorStats _mapVendorStats(VendorStatsDto dto) => VendorStats(
        clientTotal: dto.clientTotal,
        clientUnread: dto.clientUnread,
        supportTotal: dto.supportTotal,
        supportUnread: dto.supportUnread,
      );

  AdminReportStats _mapAdminReportStats(AdminReportStatsDto dto) =>
      AdminReportStats(
        pending: dto.pending,
        reviewed: dto.reviewed,
        dismissed: dto.dismissed,
        total: dto.total,
      );

  ConversationReportParty? _mapReportParty(Map<String, dynamic>? map) {
    if (map == null) return null;
    return ConversationReportParty(
      id: (map['id'] as num).toInt(),
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      avatarUrl: map['avatar_url'] as String?,
      organizationUuid: map['organization_uuid'] as String?,
      organizationName: map['organization_name'] as String?,
    );
  }

  ConversationReport _mapConversationReport(ConversationReportDto dto) {
    final conv = dto.conversation;
    return ConversationReport(
      uuid: dto.uuid,
      reason: dto.reason,
      comment: dto.comment,
      status: dto.status,
      createdAt: DateTime.parse(dto.createdAt),
      reviewedAt:
          dto.reviewedAt != null ? DateTime.parse(dto.reviewedAt!) : null,
      adminNote: dto.adminNote,
      conversationUuid: conv?['uuid'] as String?,
      conversationSubject: conv?['subject'] as String?,
      reporter: _mapReportParty(dto.reporter),
      againstWhom: _mapReportParty(dto.againstWhom),
      againstWhomType: dto.againstWhom?['type'] as String?,
      reviewedByName: (dto.reviewedBy)?['name'] as String?,
    );
  }

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
    String? period,
    int page = 1,
    int perPage = 15,
  }) async {
    final response = await _api.getConversations(
      status: status,
      unreadOnly: unreadOnly,
      search: search,
      period: period,
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
  Future<void> markConversationAsRead(String uuid) {
    return _api.markConversationAsRead(uuid);
  }

  @override
  Future<Conversation> createConversation({
    required String organizationUuid,
    required String subject,
    required String message,
    String? eventId,
  }) async {
    return _mapConversation(await _api.createConversation(
      organizationUuid: organizationUuid,
      subject: subject,
      message: message,
      eventId: eventId,
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
  }) async {
    return _mapConversation(await _api.createFromOrganization(
      organizationUuid: organizationUuid,
      subject: subject,
      message: message,
      eventId: eventId,
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
  }) async {
    return _mapMessage(await _api.sendMessage(
      conversationUuid: conversationUuid,
      content: content,
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
    String? status,
    bool? unreadOnly,
    String? search,
    String? period,
  }) async {
    final response = await _api.getSupportConversations(
      page: page,
      perPage: perPage,
      status: status,
      unreadOnly: unreadOnly,
      search: search,
      period: period,
    );
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
  Future<Conversation> closeSupportConversation(String uuid) async {
    return _mapConversation(await _api.closeSupportConversation(uuid));
  }

  @override
  Future<Message> sendSupportMessage({
    required String conversationUuid,
    String? content,
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

  // ===== Vendor — conversations =====

  @override
  Future<ConversationsListResult> getVendorConversations({
    String? conversationType,
    String? status,
    bool? unreadOnly,
    String? search,
    String? period,
    int page = 1,
    int perPage = 15,
  }) async {
    final response = await _api.getVendorConversations(
      conversationType: conversationType,
      status: status,
      unreadOnly: unreadOnly,
      search: search,
      period: period,
      page: page,
      perPage: perPage,
    );
    return _mapListResult(response, page);
  }

  @override
  Future<int> getVendorUnreadCount() => _api.getVendorUnreadCount();

  @override
  Future<VendorStats> getVendorStats() async {
    return _mapVendorStats(await _api.getVendorStats());
  }

  @override
  Future<List<ConversationParticipant>> getInteractedParticipants({
    String? search,
  }) async {
    final dtos = await _api.getInteractedParticipants(search: search);
    return dtos.map((dto) => _mapParticipant(dto)!).toList();
  }

  @override
  Future<Conversation> createVendorConversationToParticipant({
    required int participantId,
    required String subject,
    required String message,
    int? eventId,
  }) async {
    return _mapConversation(await _api.createVendorConversationToParticipant(
      participantId: participantId,
      subject: subject,
      message: message,
      eventId: eventId,
    ));
  }

  @override
  Future<Conversation> createVendorSupportThread({
    required String subject,
    required String message,
  }) async {
    return _mapConversation(await _api.createVendorSupportThread(
      subject: subject,
      message: message,
    ));
  }

  @override
  Future<Conversation> getVendorConversation(String uuid) async {
    return _mapConversation(await _api.getVendorConversation(uuid));
  }

  @override
  Future<void> markVendorConversationAsRead(String uuid) {
    return _api.markVendorConversationAsRead(uuid);
  }

  @override
  Future<Message> sendVendorMessage({
    required String conversationUuid,
    String? content,
  }) async {
    return _mapMessage(await _api.sendVendorMessage(
      conversationUuid: conversationUuid,
      content: content,
    ));
  }

  @override
  Future<Message> editVendorMessage({
    required String conversationUuid,
    required String messageUuid,
    required String content,
  }) async {
    return _mapMessage(await _api.editVendorMessage(
      conversationUuid: conversationUuid,
      messageUuid: messageUuid,
      content: content,
    ));
  }

  @override
  Future<void> deleteVendorMessage({
    required String conversationUuid,
    required String messageUuid,
  }) {
    return _api.deleteVendorMessage(
      conversationUuid: conversationUuid,
      messageUuid: messageUuid,
    );
  }

  @override
  Future<Conversation> closeVendorConversation(String uuid) async {
    return _mapConversation(await _api.closeVendorConversation(uuid));
  }

  // ===== Vendor — org-conversations =====

  @override
  Future<List<AcceptedPartner>> getAcceptedPartners() async {
    final dtos = await _api.getAcceptedPartners();
    return dtos.map(_mapAcceptedPartner).toList();
  }

  @override
  Future<ConversationsListResult> getOrgConversations({
    String? status,
    bool? unreadOnly,
    String? search,
    String? period,
    int page = 1,
    int perPage = 15,
  }) async {
    final response = await _api.getOrgConversations(
      status: status,
      unreadOnly: unreadOnly,
      search: search,
      period: period,
      page: page,
      perPage: perPage,
    );
    return _mapListResult(response, page);
  }

  @override
  Future<Conversation> createOrgConversation({
    required int partnerOrganizationId,
    required String subject,
    required String message,
  }) async {
    return _mapConversation(await _api.createOrgConversation(
      partnerOrganizationId: partnerOrganizationId,
      subject: subject,
      message: message,
    ));
  }

  @override
  Future<Conversation> getOrgConversation(String uuid) async {
    return _mapConversation(await _api.getOrgConversation(uuid));
  }

  @override
  Future<void> markOrgConversationAsRead(String uuid) {
    return _api.markOrgConversationAsRead(uuid);
  }

  @override
  Future<Message> sendOrgMessage({
    required String conversationUuid,
    String? content,
  }) async {
    return _mapMessage(await _api.sendOrgMessage(
      conversationUuid: conversationUuid,
      content: content,
    ));
  }

  @override
  Future<Message> editOrgMessage({
    required String conversationUuid,
    required String messageUuid,
    required String content,
  }) async {
    return _mapMessage(await _api.editOrgMessage(
      conversationUuid: conversationUuid,
      messageUuid: messageUuid,
      content: content,
    ));
  }

  @override
  Future<void> deleteOrgMessage({
    required String conversationUuid,
    required String messageUuid,
  }) {
    return _api.deleteOrgMessage(
      conversationUuid: conversationUuid,
      messageUuid: messageUuid,
    );
  }

  @override
  Future<Conversation> closeOrgConversation(String uuid) async {
    return _mapConversation(await _api.closeOrgConversation(uuid));
  }

  // ===== Admin — conversations =====

  @override
  Future<ConversationsListResult> getAdminConversations({
    String? conversationType,
    String? status,
    bool? unreadOnly,
    String? search,
    String? period,
    int page = 1,
    int perPage = 15,
  }) async {
    final response = await _api.getAdminConversations(
      conversationType: conversationType,
      status: status,
      unreadOnly: unreadOnly,
      search: search,
      period: period,
      page: page,
      perPage: perPage,
    );
    return _mapListResult(response, page);
  }

  @override
  Future<int> getAdminUnreadCount() => _api.getAdminUnreadCount();

  @override
  Future<Conversation> createAdminUserThread({
    int? userId,
    String? userUuid,
    String? subject,
    String? message,
  }) async {
    return _mapConversation(await _api.createAdminUserThread(
      userId: userId,
      userUuid: userUuid,
      subject: subject,
      message: message,
    ));
  }

  @override
  Future<Conversation> createAdminSupportThread({
    required String organizationUuid,
    String? subject,
    String? message,
  }) async {
    return _mapConversation(await _api.createAdminSupportThread(
      organizationUuid: organizationUuid,
      subject: subject,
      message: message,
    ));
  }

  @override
  Future<Conversation> getAdminConversation(String uuid) async {
    return _mapConversation(await _api.getAdminConversation(uuid));
  }

  @override
  Future<void> markAdminConversationAsRead(String uuid) {
    return _api.markAdminConversationAsRead(uuid);
  }

  @override
  Future<Message> sendAdminMessage({
    required String conversationUuid,
    String? content,
  }) async {
    return _mapMessage(await _api.sendAdminMessage(
      conversationUuid: conversationUuid,
      content: content,
    ));
  }

  @override
  Future<Message> editAdminMessage({
    required String conversationUuid,
    required String messageUuid,
    required String content,
  }) async {
    return _mapMessage(await _api.editAdminMessage(
      conversationUuid: conversationUuid,
      messageUuid: messageUuid,
      content: content,
    ));
  }

  @override
  Future<void> deleteAdminMessage({
    required String conversationUuid,
    required String messageUuid,
  }) {
    return _api.deleteAdminMessage(
      conversationUuid: conversationUuid,
      messageUuid: messageUuid,
    );
  }

  @override
  Future<Conversation> closeAdminConversation(String uuid) async {
    return _mapConversation(await _api.closeAdminConversation(uuid));
  }

  @override
  Future<Conversation> reopenAdminConversation(String uuid) async {
    return _mapConversation(await _api.reopenAdminConversation(uuid));
  }

  // ===== Admin — reports =====

  @override
  Future<ConversationReportsListResult> getAdminConversationReports({
    String? search,
    String? reason,
    int page = 1,
    int perPage = 20,
  }) async {
    final response = await _api.getAdminConversationReports(
      search: search,
      reason: reason,
      page: page,
      perPage: perPage,
    );
    final reports = response.data.map(_mapConversationReport).toList();
    final lastPage = response.lastPage ?? 1;
    return ConversationReportsListResult(
      reports: reports,
      hasMore: page < lastPage,
      currentPage: page,
      totalCount: response.total ?? reports.length,
    );
  }

  @override
  Future<AdminReportStats> getAdminConversationReportStats() async {
    return _mapAdminReportStats(await _api.getAdminConversationReportStats());
  }

  @override
  Future<void> reviewAdminConversationReport({
    required String reportUuid,
    required String action,
    String? adminNote,
  }) {
    return _api.reviewAdminConversationReport(
      reportUuid: reportUuid,
      action: action,
      adminNote: adminNote,
    );
  }

  @override
  Future<void> updateAdminConversationReportNote({
    required String reportUuid,
    String? adminNote,
  }) {
    return _api.updateAdminConversationReportNote(
      reportUuid: reportUuid,
      adminNote: adminNote,
    );
  }

  // ── Vendor — broadcasts ───────────────────────────────────────────────────

  VendorEvent _mapVendorEvent(VendorEventDto dto) =>
      VendorEvent(id: dto.id, uuid: dto.uuid, title: dto.title, slug: dto.slug);

  SlotOption _mapSlotOption(SlotOptionDto dto) => SlotOption(
        id: dto.id,
        uuid: dto.uuid,
        slotDate: dto.slotDate,
        startTime: dto.startTime,
        endTime: dto.endTime,
      );

  BroadcastEvent _mapBroadcastEvent(BroadcastEventDto dto) =>
      BroadcastEvent(uuid: dto.uuid, title: dto.title);

  Broadcast _mapBroadcast(BroadcastDto dto) => Broadcast(
        uuid: dto.uuid,
        subject: dto.subject,
        body: dto.body,
        recipientsCount: dto.recipientsCount,
        readCount: dto.readCount,
        conversationsCreated: dto.conversationsCreated,
        isSent: dto.isSent,
        sentAt: dto.sentAt != null ? DateTime.tryParse(dto.sentAt!) : null,
        events: dto.events.map(_mapBroadcastEvent).toList(),
        createdAt: DateTime.tryParse(dto.createdAt) ?? DateTime.now(),
      );

  @override
  Future<List<VendorEvent>> getVendorEvents() async {
    final dtos = await _api.getVendorEvents();
    return dtos.map(_mapVendorEvent).toList();
  }

  @override
  Future<List<SlotOption>> getEventSlots(String eventUuid) async {
    final dtos = await _api.getEventSlots(eventUuid);
    return dtos.map(_mapSlotOption).toList();
  }

  @override
  Future<BroadcastsListResult> getBroadcasts({
    String? search,
    String? period,
    int page = 1,
    int perPage = 15,
  }) async {
    final response = await _api.getBroadcasts(
      search: search,
      period: period,
      page: page,
      perPage: perPage,
    );
    return BroadcastsListResult(
      broadcasts: response.data.map(_mapBroadcast).toList(),
      hasMore: response.hasMore,
      currentPage: response.currentPage,
      totalCount: response.total,
    );
  }

  @override
  Future<Broadcast> getBroadcast(String uuid) async {
    final dto = await _api.getBroadcast(uuid);
    return _mapBroadcast(dto);
  }

  @override
  Future<int> previewBroadcastRecipients({
    required List<String> eventIds,
    List<String>? slotIds,
  }) {
    return _api.previewBroadcastRecipients(
      eventIds: eventIds,
      slotIds: slotIds,
    );
  }

  @override
  Future<Broadcast> createBroadcast({
    required String subject,
    required String message,
    required List<String> eventIds,
    List<String>? slotIds,
  }) async {
    final dto = await _api.createBroadcast(
      subject: subject,
      message: message,
      eventIds: eventIds,
      slotIds: slotIds,
    );
    return _mapBroadcast(dto);
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
