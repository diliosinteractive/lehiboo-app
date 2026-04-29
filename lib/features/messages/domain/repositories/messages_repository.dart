import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import '../entities/conversation.dart';
import '../entities/message.dart';

abstract class MessagesRepository {
  // Conversations (participant_vendor)

  Future<ConversationsListResult> getConversations({
    String? status,
    bool? unreadOnly,
    String? search,
    int page = 1,
    int perPage = 15,
  });

  Future<int> getUnreadCount();

  Future<Conversation> getConversation(String uuid);

  Future<Conversation> createConversation({
    required String organizationUuid,
    required String subject,
    required String message,
    String? eventId,
    List<XFile>? attachments,
  });

  Future<CreateFromBookingResult> createFromBooking(String bookingUuid);

  Future<Conversation> createFromOrganization({
    required String organizationUuid,
    required String subject,
    required String message,
    String? eventId,
    List<XFile>? attachments,
  });

  Future<Conversation> closeConversation(String uuid);

  Future<Message> sendMessage({
    required String conversationUuid,
    String? content,
    List<XFile>? attachments,
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
  });

  Future<int> getSupportUnreadCount();

  Future<Conversation> getSupportConversation(String uuid);

  Future<Conversation> createSupportConversation({
    required String subject,
    required String message,
  });

  Future<Message> sendSupportMessage({
    required String conversationUuid,
    required String content,
  });

  // Helpers

  Future<List<ConversationOrganization>> getContactableOrganizations();
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
