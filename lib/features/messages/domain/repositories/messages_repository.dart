import 'package:equatable/equatable.dart';
import '../entities/accepted_partner.dart';
import '../entities/admin_report_stats.dart';
import '../entities/broadcast.dart';
import '../entities/conversation.dart';
import '../entities/conversation_report.dart';
import '../entities/message.dart';
import '../entities/vendor_stats.dart';

abstract class MessagesRepository {
  // Conversations (participant_vendor)

  Future<ConversationsListResult> getConversations({
    String? status,
    bool? unreadOnly,
    String? search,
    String? period,
    int page = 1,
    int perPage = 15,
  });

  Future<int> getUnreadCount();

  Future<Conversation> getConversation(String uuid);

  Future<void> markConversationAsRead(String uuid);

  Future<Conversation> createConversation({
    required String organizationUuid,
    required String subject,
    required String message,
    String? eventId,
  });

  Future<CreateFromBookingResult> createFromBooking(String bookingUuid);

  Future<Conversation> createFromOrganization({
    required String organizationUuid,
    required String subject,
    required String message,
    String? eventId,
  });

  Future<Conversation> closeConversation(String uuid);

  Future<Message> sendMessage({
    required String conversationUuid,
    String? content,
  });

  Future<Message> editMessage({
    required String conversationUuid,
    required String messageUuid,
    required String content,
  });

  Future<void> deleteMessage({
    required String conversationUuid,
    required String messageUuid,
  });

  Future<ReportConversationResult> reportConversation({
    required String conversationUuid,
    required String reason,
    String? comment,
  });

  // Support conversations

  Future<ConversationsListResult> getSupportConversations({
    int page = 1,
    int perPage = 15,
    String? status,
    bool? unreadOnly,
    String? search,
    String? period,
  });

  Future<int> getSupportUnreadCount();

  Future<Conversation> getSupportConversation(String uuid);

  Future<Conversation> createSupportConversation({
    required String subject,
    required String message,
  });

  Future<Conversation> closeSupportConversation(String uuid);

  Future<Message> sendSupportMessage({
    required String conversationUuid,
    String? content,
  });

  // Helpers

  Future<List<ConversationOrganization>> getContactableOrganizations();

  // ── Vendor — conversations ────────────────────────────────────────────────

  Future<ConversationsListResult> getVendorConversations({
    String? conversationType,
    String? status,
    bool? unreadOnly,
    String? search,
    String? period,
    int page = 1,
    int perPage = 15,
  });

  Future<int> getVendorUnreadCount();

  Future<VendorStats> getVendorStats();

  Future<List<ConversationParticipant>> getInteractedParticipants({
    String? search,
  });

  Future<Conversation> createVendorConversationToParticipant({
    required int participantId,
    required String subject,
    required String message,
    int? eventId,
  });

  Future<Conversation> createVendorSupportThread({
    required String subject,
    required String message,
  });

  Future<Conversation> getVendorConversation(String uuid);

  Future<void> markVendorConversationAsRead(String uuid);

  Future<Message> sendVendorMessage({
    required String conversationUuid,
    String? content,
  });

  Future<Message> editVendorMessage({
    required String conversationUuid,
    required String messageUuid,
    required String content,
  });

  Future<void> deleteVendorMessage({
    required String conversationUuid,
    required String messageUuid,
  });

  Future<Conversation> closeVendorConversation(String uuid);

  // ── Vendor — org-conversations ────────────────────────────────────────────

  Future<List<AcceptedPartner>> getAcceptedPartners();

  Future<ConversationsListResult> getOrgConversations({
    String? status,
    bool? unreadOnly,
    String? search,
    String? period,
    int page = 1,
    int perPage = 15,
  });

  Future<Conversation> createOrgConversation({
    required int partnerOrganizationId,
    required String subject,
    required String message,
  });

  Future<Conversation> getOrgConversation(String uuid);

  Future<void> markOrgConversationAsRead(String uuid);

  Future<Message> sendOrgMessage({
    required String conversationUuid,
    String? content,
  });

  Future<Message> editOrgMessage({
    required String conversationUuid,
    required String messageUuid,
    required String content,
  });

  Future<void> deleteOrgMessage({
    required String conversationUuid,
    required String messageUuid,
  });

  Future<Conversation> closeOrgConversation(String uuid);

  // ── Vendor — broadcasts ───────────────────────────────────────────────────

  Future<List<VendorEvent>> getVendorEvents();

  Future<List<SlotOption>> getEventSlots(String eventUuid);

  Future<BroadcastsListResult> getBroadcasts({
    String? search,
    String? period,
    int page = 1,
    int perPage = 15,
  });

  Future<Broadcast> getBroadcast(String uuid);

  Future<int> previewBroadcastRecipients({
    required List<String> eventIds,
    List<String>? slotIds,
  });

  Future<Broadcast> createBroadcast({
    required String subject,
    required String message,
    required List<String> eventIds,
    List<String>? slotIds,
  });

  // ── Admin — conversations ─────────────────────────────────────────────────

  Future<ConversationsListResult> getAdminConversations({
    String? conversationType,
    String? status,
    bool? unreadOnly,
    String? search,
    String? period,
    int page = 1,
    int perPage = 15,
  });

  Future<int> getAdminUnreadCount();

  Future<Conversation> createAdminUserThread({
    int? userId,
    String? userUuid,
    String? subject,
    String? message,
  });

  Future<Conversation> createAdminSupportThread({
    required String organizationUuid,
    String? subject,
    String? message,
  });

  Future<Conversation> getAdminConversation(String uuid);

  Future<void> markAdminConversationAsRead(String uuid);

  Future<Message> sendAdminMessage({
    required String conversationUuid,
    String? content,
  });

  Future<Message> editAdminMessage({
    required String conversationUuid,
    required String messageUuid,
    required String content,
  });

  Future<void> deleteAdminMessage({
    required String conversationUuid,
    required String messageUuid,
  });

  Future<Conversation> closeAdminConversation(String uuid);

  Future<Conversation> reopenAdminConversation(String uuid);

  // ── Admin — reports (signalements) ────────────────────────────────────────

  Future<ConversationReportsListResult> getAdminConversationReports({
    String? search,
    String? reason,
    int page = 1,
    int perPage = 20,
  });

  Future<AdminReportStats> getAdminConversationReportStats();

  Future<void> reviewAdminConversationReport({
    required String reportUuid,
    required String action, // 'dismiss' | 'reviewed'
    String? adminNote,
  });

  Future<void> updateAdminConversationReportNote({
    required String reportUuid,
    String? adminNote,
  });
}

class ConversationsListResult extends Equatable {
  final List<Conversation> conversations;
  final bool hasMore;
  final int currentPage;
  final int totalCount;

  const ConversationsListResult({
    required this.conversations,
    required this.hasMore,
    required this.currentPage,
    required this.totalCount,
  });

  @override
  List<Object?> get props => [conversations, hasMore, currentPage, totalCount];
}

class CreateFromBookingResult extends Equatable {
  final Conversation conversation;
  final bool created;

  const CreateFromBookingResult({
    required this.conversation,
    required this.created,
  });

  @override
  List<Object?> get props => [conversation, created];
}

class ConversationReportsListResult extends Equatable {
  final List<ConversationReport> reports;
  final bool hasMore;
  final int currentPage;
  final int totalCount;

  const ConversationReportsListResult({
    required this.reports,
    required this.hasMore,
    required this.currentPage,
    required this.totalCount,
  });

  @override
  List<Object?> get props => [reports, hasMore, currentPage, totalCount];
}

class ReportConversationResult extends Equatable {
  final String reportUuid;
  final String? supportConversationUuid;

  const ReportConversationResult({
    required this.reportUuid,
    this.supportConversationUuid,
  });

  @override
  List<Object?> get props => [reportUuid, supportConversationUuid];
}
