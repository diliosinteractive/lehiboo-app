import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../config/dio_client.dart';
import '../models/conversation_dto.dart';
import '../models/message_dto.dart';

class MessagesApiDataSource {
  final Dio _dio;
  MessagesApiDataSource(this._dio);

  // 1. GET /user/conversations
  Future<ConversationsListResponseDto> getConversations({
    String? status,
    bool? unreadOnly,
    String? search,
    int page = 1,
    int perPage = 15,
  }) async {
    final r = await _dio.get('/user/conversations', queryParameters: {
      if (status != null) 'status': status,
      if (unreadOnly == true) 'unread_only': 'true',
      if (search != null && search.isNotEmpty) 'search': search,
      'page': page,
      'per_page': perPage,
    });
    return ConversationsListResponseDto.fromJson(r.data as Map<String, dynamic>);
  }

  // 2. GET /user/conversations/unread-count
  Future<int> getUnreadCount() async {
    final r = await _dio.get('/user/conversations/unread-count');
    return (r.data as Map<String, dynamic>)['count'] as int? ?? 0;
  }

  // 3. GET /user/conversations/{uuid}
  Future<ConversationDto> getConversation(String uuid) async {
    final r = await _dio.get('/user/conversations/$uuid');
    return ConversationDto.fromJson(
        (r.data as Map<String, dynamic>)['data'] as Map<String, dynamic>);
  }

  // 4. GET /user/conversations/contactable-organizations
  Future<List<ConversationOrganizationDto>> getContactableOrganizations() async {
    final r = await _dio.get('/user/conversations/contactable-organizations');
    final list = (r.data as Map<String, dynamic>)['data'] as List;
    return list
        .map((e) =>
            ConversationOrganizationDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // 5. POST /user/conversations
  Future<ConversationDto> createConversation({
    required String organizationUuid,
    required String subject,
    required String message,
    String? eventId,
  }) async {
    final r = await _dio.post('/user/conversations', data: {
      'organization_uuid': organizationUuid,
      'subject': subject,
      'message': message,
      if (eventId != null) 'event_id': eventId,
    });
    return ConversationDto.fromJson(
        (r.data as Map<String, dynamic>)['data'] as Map<String, dynamic>);
  }

  // 6. POST /user/conversations/from-booking/{bookingUuid}
  Future<({ConversationDto conversation, bool created})> createFromBooking(
      String bookingUuid) async {
    final r =
        await _dio.post('/user/conversations/from-booking/$bookingUuid');
    final data = r.data as Map<String, dynamic>;
    return (
      conversation: ConversationDto.fromJson(
          data['data'] as Map<String, dynamic>),
      created: data['created'] as bool? ?? true,
    );
  }

  // 7. POST /user/conversations/from-organization/{orgUuid}
  Future<ConversationDto> createFromOrganization({
    required String organizationUuid,
    required String subject,
    required String message,
    String? eventId,
  }) async {
    final r = await _dio.post(
      '/user/conversations/from-organization/$organizationUuid',
      data: {
        'subject': subject,
        'message': message,
        if (eventId != null) 'event_id': eventId,
      },
    );
    return ConversationDto.fromJson(
        (r.data as Map<String, dynamic>)['data'] as Map<String, dynamic>);
  }

  // 8. POST /user/conversations/{uuid}/close
  Future<ConversationDto> closeConversation(String uuid) async {
    final r = await _dio.post('/user/conversations/$uuid/close');
    return ConversationDto.fromJson(
        (r.data as Map<String, dynamic>)['data'] as Map<String, dynamic>);
  }

  // 9. POST /user/conversations/{uuid}/messages
  Future<MessageDto> sendMessage({
    required String conversationUuid,
    String? content,
    List<XFile>? attachments,
  }) async {
    late Response<dynamic> r;
    if (attachments != null && attachments.isNotEmpty) {
      final files = <MultipartFile>[];
      for (final f in attachments) {
        files.add(await MultipartFile.fromFile(f.path, filename: f.name));
      }
      final formData = FormData.fromMap({
        if (content != null && content.isNotEmpty) 'content': content,
        'attachments[]': files,
      });
      r = await _dio.post(
        '/user/conversations/$conversationUuid/messages',
        data: formData,
      );
    } else {
      r = await _dio.post(
        '/user/conversations/$conversationUuid/messages',
        data: {'content': content},
      );
    }
    // Response is a direct MessageResource (no wrapper)
    return MessageDto.fromJson(r.data as Map<String, dynamic>);
  }

  // 10. PATCH /user/conversations/{uuid}/messages/{msgUuid}
  Future<MessageDto> editMessage({
    required String conversationUuid,
    required String messageUuid,
    required String content,
  }) async {
    final r = await _dio.patch(
      '/user/conversations/$conversationUuid/messages/$messageUuid',
      data: {'content': content},
    );
    return MessageDto.fromJson(
        (r.data as Map<String, dynamic>)['data'] as Map<String, dynamic>);
  }

  // 11. DELETE /user/conversations/{uuid}/messages/{msgUuid}
  Future<void> deleteMessage({
    required String conversationUuid,
    required String messageUuid,
  }) async {
    await _dio.delete(
      '/user/conversations/$conversationUuid/messages/$messageUuid',
    );
  }

  // 12. POST /user/conversations/{uuid}/report
  Future<({String reportUuid, String? supportConversationUuid})>
      reportConversation({
    required String conversationUuid,
    required String reason,
    String? comment,
  }) async {
    final r = await _dio.post(
      '/user/conversations/$conversationUuid/report',
      data: {
        'reason': reason,
        if (comment != null && comment.isNotEmpty) 'comment': comment,
      },
    );
    final data =
        (r.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
    return (
      reportUuid: data['uuid'] as String,
      supportConversationUuid: data['support_conversation_uuid'] as String?,
    );
  }

  // 13. GET /user/support-conversations
  Future<ConversationsListResponseDto> getSupportConversations({
    int page = 1,
    int perPage = 15,
  }) async {
    final r = await _dio.get('/user/support-conversations', queryParameters: {
      'page': page,
      'per_page': perPage,
    });
    return ConversationsListResponseDto.fromJson(
        r.data as Map<String, dynamic>);
  }

  // 14. No dedicated endpoint — sum unread from the getSupportConversations list response
  Future<int> getSupportUnreadCount() async {
    final result = await getSupportConversations(page: 1, perPage: 50);
    return result.data.fold<int>(0, (sum, c) => sum + c.unreadCount);
  }

  // 15. GET /user/support-conversations/{uuid}
  Future<ConversationDto> getSupportConversation(String uuid) async {
    final r = await _dio.get('/user/support-conversations/$uuid');
    return ConversationDto.fromJson(
        (r.data as Map<String, dynamic>)['data'] as Map<String, dynamic>);
  }

  // 16. POST /user/support-conversations
  Future<ConversationDto> createSupportConversation({
    required String subject,
    required String message,
  }) async {
    final r = await _dio.post('/user/support-conversations', data: {
      'subject': subject,
      'message': message,
    });
    return ConversationDto.fromJson(
        (r.data as Map<String, dynamic>)['data'] as Map<String, dynamic>);
  }

  // 17. POST /user/support-conversations/{uuid}/messages
  Future<MessageDto> sendSupportMessage({
    required String conversationUuid,
    required String content,
  }) async {
    final r = await _dio.post(
      '/user/support-conversations/$conversationUuid/messages',
      data: {'content': content},
    );
    return MessageDto.fromJson(r.data as Map<String, dynamic>);
  }
}

final messagesApiDataSourceProvider = Provider<MessagesApiDataSource>((ref) {
  return MessagesApiDataSource(ref.read(dioProvider));
});
