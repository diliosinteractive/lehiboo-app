import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../config/dio_client.dart';
import '../models/accepted_partner_dto.dart';
import '../models/admin_report_stats_dto.dart';
import '../models/conversation_dto.dart';
import '../models/conversation_report_dto.dart';
import '../models/message_dto.dart';
import '../models/vendor_stats_dto.dart';

class MessagesApiDataSource {
  final Dio _dio;
  MessagesApiDataSource(this._dio);

  // 1. GET /user/conversations
  Future<ConversationsListResponseDto> getConversations({
    String? status,
    bool? unreadOnly,
    String? search,
    String? period,
    int page = 1,
    int perPage = 15,
  }) async {
    final r = await _dio.get('/user/conversations', queryParameters: {
      if (status != null) 'status': status,
      if (unreadOnly == true) 'unread_only': 'true',
      if (search != null && search.isNotEmpty) 'search': search,
      if (period != null) 'period': period,
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

  Future<void> markConversationAsRead(String uuid) async {
    await _dio.post('/user/conversations/$uuid/read');
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
    List<XFile>? attachments,
  }) async {
    late Response<dynamic> r;
    if (attachments != null && attachments.isNotEmpty) {
      final files = <MultipartFile>[];
      for (final f in attachments) {
        files.add(await MultipartFile.fromFile(f.path, filename: f.name));
      }
      final formData = FormData.fromMap({
        'organization_uuid': organizationUuid,
        'subject': subject,
        'message': message,
        if (eventId != null) 'event_id': eventId,
        'attachments[]': files,
      });
      r = await _dio.post('/user/conversations', data: formData);
    } else {
      r = await _dio.post('/user/conversations', data: {
        'organization_uuid': organizationUuid,
        'subject': subject,
        'message': message,
        if (eventId != null) 'event_id': eventId,
      });
    }
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
    List<XFile>? attachments,
  }) async {
    late Response<dynamic> r;
    if (attachments != null && attachments.isNotEmpty) {
      final files = <MultipartFile>[];
      for (final f in attachments) {
        files.add(await MultipartFile.fromFile(f.path, filename: f.name));
      }
      final formData = FormData.fromMap({
        'subject': subject,
        'message': message,
        if (eventId != null) 'event_id': eventId,
        'attachments[]': files,
      });
      r = await _dio.post(
        '/user/conversations/from-organization/$organizationUuid',
        data: formData,
      );
    } else {
      r = await _dio.post(
        '/user/conversations/from-organization/$organizationUuid',
        data: {
          'subject': subject,
          'message': message,
          if (eventId != null) 'event_id': eventId,
        },
      );
    }
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
    final raw = r.data as Map<String, dynamic>;
    final payload = raw.containsKey('data') ? raw['data'] as Map<String, dynamic> : raw;
    return MessageDto.fromJson(payload);
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
    List<XFile>? attachments,
  }) async {
    late Response<dynamic> r;
    if (attachments != null && attachments.isNotEmpty) {
      final files = <MultipartFile>[];
      for (final f in attachments) {
        files.add(await MultipartFile.fromFile(f.path, filename: f.name));
      }
      r = await _dio.post(
        '/user/support-conversations',
        data: FormData.fromMap({
          'subject': subject,
          'message': message,
          'attachments[]': files,
        }),
      );
    } else {
      r = await _dio.post('/user/support-conversations', data: {
        'subject': subject,
        'message': message,
      });
    }
    return ConversationDto.fromJson(
        (r.data as Map<String, dynamic>)['data'] as Map<String, dynamic>);
  }

  // 17. POST /user/support-conversations/{uuid}/messages
  Future<MessageDto> sendSupportMessage({
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
        '/user/support-conversations/$conversationUuid/messages',
        data: formData,
      );
    } else {
      r = await _dio.post(
        '/user/support-conversations/$conversationUuid/messages',
        data: {'content': content},
      );
    }
    final raw = r.data as Map<String, dynamic>;
    final payload = raw.containsKey('data') ? raw['data'] as Map<String, dynamic> : raw;
    return MessageDto.fromJson(payload);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // VENDOR — conversations (participant_vendor + vendor_admin)
  // ─────────────────────────────────────────────────────────────────────────

  Future<ConversationsListResponseDto> getVendorConversations({
    String? conversationType,
    String? status,
    bool? unreadOnly,
    String? search,
    String? period,
    int page = 1,
    int perPage = 15,
  }) async {
    final r = await _dio.get('/vendor/conversations', queryParameters: {
      if (conversationType != null) 'conversation_type': conversationType,
      if (status != null) 'status': status,
      if (unreadOnly == true) 'unread_only': 'true',
      if (search != null && search.isNotEmpty) 'search': search,
      if (period != null) 'period': period,
      'page': page,
      'per_page': perPage,
    });
    return ConversationsListResponseDto.fromJson(r.data as Map<String, dynamic>);
  }

  Future<int> getVendorUnreadCount() async {
    final r = await _dio.get('/vendor/conversations/unread-count');
    return (r.data as Map<String, dynamic>)['count'] as int? ?? 0;
  }

  Future<VendorStatsDto> getVendorStats() async {
    final r = await _dio.get('/vendor/conversations/stats');
    final data = (r.data as Map<String, dynamic>)['data'] as Map<String, dynamic>?
        ?? r.data as Map<String, dynamic>;
    return VendorStatsDto.fromJson(data);
  }

  Future<List<ConversationParticipantDto>> getInteractedParticipants({
    String? search,
  }) async {
    final r = await _dio.get(
      '/vendor/conversations/interacted-participants',
      queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );
    final list = ((r.data as Map<String, dynamic>)['data'] as List?) ?? [];
    return list.map((e) {
      final json = Map<String, dynamic>.from(e as Map);
      json['id'] = int.tryParse(json['id'].toString()) ?? 0;
      return ConversationParticipantDto.fromJson(json);
    }).toList();
  }

  Future<ConversationDto> createVendorConversationToParticipant({
    required int participantId,
    required String subject,
    required String message,
    int? eventId,
    List<XFile>? attachments,
  }) async {
    late Response<dynamic> r;
    if (attachments != null && attachments.isNotEmpty) {
      final files = <MultipartFile>[];
      for (final f in attachments) {
        files.add(await MultipartFile.fromFile(f.path, filename: f.name));
      }
      r = await _dio.post(
        '/vendor/conversations/to-participant',
        data: FormData.fromMap({
          'participant_id': participantId,
          'subject': subject,
          'message': message,
          if (eventId != null) 'event_id': eventId,
          'attachments[]': files,
        }),
      );
    } else {
      r = await _dio.post('/vendor/conversations/to-participant', data: {
        'participant_id': participantId,
        'subject': subject,
        'message': message,
        if (eventId != null) 'event_id': eventId,
      });
    }
    return ConversationDto.fromJson(
        (r.data as Map<String, dynamic>)['data'] as Map<String, dynamic>);
  }

  Future<ConversationDto> createVendorSupportThread({
    required String subject,
    required String message,
    List<XFile>? attachments,
  }) async {
    late Response<dynamic> r;
    if (attachments != null && attachments.isNotEmpty) {
      final files = <MultipartFile>[];
      for (final f in attachments) {
        files.add(await MultipartFile.fromFile(f.path, filename: f.name));
      }
      r = await _dio.post(
        '/vendor/conversations/support-thread',
        data: FormData.fromMap({
          'subject': subject,
          'message': message,
          'attachments[]': files,
        }),
      );
    } else {
      r = await _dio.post('/vendor/conversations/support-thread', data: {
        'subject': subject,
        'message': message,
      });
    }
    return ConversationDto.fromJson(
        (r.data as Map<String, dynamic>)['data'] as Map<String, dynamic>);
  }

  Future<ConversationDto> getVendorConversation(String uuid) async {
    final r = await _dio.get('/vendor/conversations/$uuid');
    return ConversationDto.fromJson(
        (r.data as Map<String, dynamic>)['data'] as Map<String, dynamic>);
  }

  Future<void> markVendorConversationAsRead(String uuid) async {
    await _dio.post('/vendor/conversations/$uuid/read');
  }

  Future<MessageDto> sendVendorMessage({
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
      r = await _dio.post(
        '/vendor/conversations/$conversationUuid/messages',
        data: FormData.fromMap({
          if (content != null && content.isNotEmpty) 'content': content,
          'attachments[]': files,
        }),
      );
    } else {
      r = await _dio.post(
        '/vendor/conversations/$conversationUuid/messages',
        data: {'content': content},
      );
    }
    final raw = r.data as Map<String, dynamic>;
    return MessageDto.fromJson(
        raw.containsKey('data') ? raw['data'] as Map<String, dynamic> : raw);
  }

  Future<MessageDto> editVendorMessage({
    required String conversationUuid,
    required String messageUuid,
    required String content,
  }) async {
    final r = await _dio.patch(
      '/vendor/conversations/$conversationUuid/messages/$messageUuid',
      data: {'content': content},
    );
    return MessageDto.fromJson(
        (r.data as Map<String, dynamic>)['data'] as Map<String, dynamic>);
  }

  Future<void> deleteVendorMessage({
    required String conversationUuid,
    required String messageUuid,
  }) async {
    await _dio.delete(
        '/vendor/conversations/$conversationUuid/messages/$messageUuid');
  }

  Future<ConversationDto> closeVendorConversation(String uuid) async {
    final r = await _dio.post('/vendor/conversations/$uuid/close');
    return ConversationDto.fromJson(
        (r.data as Map<String, dynamic>)['data'] as Map<String, dynamic>);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // VENDOR — org-conversations (organization_organization)
  // ─────────────────────────────────────────────────────────────────────────

  Future<List<AcceptedPartnerDto>> getAcceptedPartners() async {
    final r = await _dio.get('/vendor/org-conversations/accepted-partners');
    final list = ((r.data as Map<String, dynamic>)['data'] as List?) ?? [];
    return list.map((e) {
      final json = Map<String, dynamic>.from(e as Map);
      json['id'] = int.tryParse(json['id'].toString()) ?? 0;
      return AcceptedPartnerDto.fromJson(json);
    }).toList();
  }

  Future<ConversationsListResponseDto> getOrgConversations({
    String? status,
    bool? unreadOnly,
    String? search,
    String? period,
    int page = 1,
    int perPage = 15,
  }) async {
    final r = await _dio.get('/vendor/org-conversations', queryParameters: {
      if (status != null) 'status': status,
      if (unreadOnly == true) 'unread_only': 'true',
      if (search != null && search.isNotEmpty) 'search': search,
      if (period != null) 'period': period,
      'page': page,
      'per_page': perPage,
    });
    return ConversationsListResponseDto.fromJson(r.data as Map<String, dynamic>);
  }

  Future<ConversationDto> createOrgConversation({
    required int partnerOrganizationId,
    required String subject,
    required String message,
    List<XFile>? attachments,
  }) async {
    late Response<dynamic> r;
    if (attachments != null && attachments.isNotEmpty) {
      final files = <MultipartFile>[];
      for (final f in attachments) {
        files.add(await MultipartFile.fromFile(f.path, filename: f.name));
      }
      r = await _dio.post(
        '/vendor/org-conversations',
        data: FormData.fromMap({
          'partner_organization_id': partnerOrganizationId,
          'subject': subject,
          'message': message,
          'attachments[]': files,
        }),
      );
    } else {
      r = await _dio.post('/vendor/org-conversations', data: {
        'partner_organization_id': partnerOrganizationId,
        'subject': subject,
        'message': message,
      });
    }
    return ConversationDto.fromJson(
        (r.data as Map<String, dynamic>)['data'] as Map<String, dynamic>);
  }

  Future<ConversationDto> getOrgConversation(String uuid) async {
    final r = await _dio.get('/vendor/org-conversations/$uuid');
    return ConversationDto.fromJson(
        (r.data as Map<String, dynamic>)['data'] as Map<String, dynamic>);
  }

  Future<void> markOrgConversationAsRead(String uuid) async {
    await _dio.post('/vendor/org-conversations/$uuid/read');
  }

  Future<MessageDto> sendOrgMessage({
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
      r = await _dio.post(
        '/vendor/org-conversations/$conversationUuid/messages',
        data: FormData.fromMap({
          if (content != null && content.isNotEmpty) 'content': content,
          'attachments[]': files,
        }),
      );
    } else {
      r = await _dio.post(
        '/vendor/org-conversations/$conversationUuid/messages',
        data: {'content': content},
      );
    }
    final raw = r.data as Map<String, dynamic>;
    return MessageDto.fromJson(
        raw.containsKey('data') ? raw['data'] as Map<String, dynamic> : raw);
  }

  Future<MessageDto> editOrgMessage({
    required String conversationUuid,
    required String messageUuid,
    required String content,
  }) async {
    final r = await _dio.patch(
      '/vendor/org-conversations/$conversationUuid/messages/$messageUuid',
      data: {'content': content},
    );
    return MessageDto.fromJson(
        (r.data as Map<String, dynamic>)['data'] as Map<String, dynamic>);
  }

  Future<void> deleteOrgMessage({
    required String conversationUuid,
    required String messageUuid,
  }) async {
    await _dio.delete(
        '/vendor/org-conversations/$conversationUuid/messages/$messageUuid');
  }

  Future<ConversationDto> closeOrgConversation(String uuid) async {
    final r = await _dio.post('/vendor/org-conversations/$uuid/close');
    return ConversationDto.fromJson(
        (r.data as Map<String, dynamic>)['data'] as Map<String, dynamic>);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // ADMIN — conversations
  // ─────────────────────────────────────────────────────────────────────────

  Future<ConversationsListResponseDto> getAdminConversations({
    String? conversationType,
    String? status,
    bool? unreadOnly,
    String? search,
    String? period,
    int page = 1,
    int perPage = 15,
  }) async {
    final r = await _dio.get('/admin/conversations', queryParameters: {
      if (conversationType != null) 'conversation_type': conversationType,
      if (status != null) 'status': status,
      if (unreadOnly == true) 'unread_only': 'true',
      if (search != null && search.isNotEmpty) 'search': search,
      if (period != null) 'period': period,
      'page': page,
      'per_page': perPage,
    });
    return ConversationsListResponseDto.fromJson(r.data as Map<String, dynamic>);
  }

  Future<int> getAdminUnreadCount() async {
    final r = await _dio.get('/admin/conversations/unread-count');
    return (r.data as Map<String, dynamic>)['count'] as int? ?? 0;
  }

  Future<ConversationDto> createAdminUserThread({
    int? userId,
    String? userUuid,
    String? subject,
    String? message,
    List<XFile>? attachments,
  }) async {
    late Response<dynamic> r;
    if (attachments != null && attachments.isNotEmpty) {
      final files = <MultipartFile>[];
      for (final f in attachments) {
        files.add(await MultipartFile.fromFile(f.path, filename: f.name));
      }
      r = await _dio.post(
        '/admin/conversations/user-thread',
        data: FormData.fromMap({
          if (userId != null) 'user_id': userId,
          if (userUuid != null) 'user_uuid': userUuid,
          if (subject != null) 'subject': subject,
          if (message != null) 'message': message,
          'attachments[]': files,
        }),
      );
    } else {
      r = await _dio.post('/admin/conversations/user-thread', data: {
        if (userId != null) 'user_id': userId,
        if (userUuid != null) 'user_uuid': userUuid,
        if (subject != null) 'subject': subject,
        if (message != null) 'message': message,
      });
    }
    return ConversationDto.fromJson(
        (r.data as Map<String, dynamic>)['data'] as Map<String, dynamic>);
  }

  Future<ConversationDto> createAdminSupportThread({
    required String organizationUuid,
    String? subject,
    String? message,
    List<XFile>? attachments,
  }) async {
    late Response<dynamic> r;
    if (attachments != null && attachments.isNotEmpty) {
      final files = <MultipartFile>[];
      for (final f in attachments) {
        files.add(await MultipartFile.fromFile(f.path, filename: f.name));
      }
      r = await _dio.post(
        '/admin/conversations/support-thread',
        data: FormData.fromMap({
          'organization_uuid': organizationUuid,
          if (subject != null) 'subject': subject,
          if (message != null) 'message': message,
          'attachments[]': files,
        }),
      );
    } else {
      r = await _dio.post('/admin/conversations/support-thread', data: {
        'organization_uuid': organizationUuid,
        if (subject != null) 'subject': subject,
        if (message != null) 'message': message,
      });
    }
    return ConversationDto.fromJson(
        (r.data as Map<String, dynamic>)['data'] as Map<String, dynamic>);
  }

  Future<ConversationDto> getAdminConversation(String uuid) async {
    final r = await _dio.get('/admin/conversations/$uuid');
    return ConversationDto.fromJson(
        (r.data as Map<String, dynamic>)['data'] as Map<String, dynamic>);
  }

  Future<void> markAdminConversationAsRead(String uuid) async {
    await _dio.post('/admin/conversations/$uuid/read');
  }

  Future<MessageDto> sendAdminMessage({
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
      r = await _dio.post(
        '/admin/conversations/$conversationUuid/messages',
        data: FormData.fromMap({
          if (content != null && content.isNotEmpty) 'content': content,
          'attachments[]': files,
        }),
      );
    } else {
      r = await _dio.post(
        '/admin/conversations/$conversationUuid/messages',
        data: {'content': content},
      );
    }
    final raw = r.data as Map<String, dynamic>;
    return MessageDto.fromJson(
        raw.containsKey('data') ? raw['data'] as Map<String, dynamic> : raw);
  }

  Future<MessageDto> editAdminMessage({
    required String conversationUuid,
    required String messageUuid,
    required String content,
  }) async {
    final r = await _dio.patch(
      '/admin/conversations/$conversationUuid/messages/$messageUuid',
      data: {'content': content},
    );
    return MessageDto.fromJson(
        (r.data as Map<String, dynamic>)['data'] as Map<String, dynamic>);
  }

  Future<void> deleteAdminMessage({
    required String conversationUuid,
    required String messageUuid,
  }) async {
    await _dio.delete(
        '/admin/conversations/$conversationUuid/messages/$messageUuid');
  }

  Future<ConversationDto> closeAdminConversation(String uuid) async {
    final r = await _dio.post('/admin/conversations/$uuid/close');
    return ConversationDto.fromJson(
        (r.data as Map<String, dynamic>)['data'] as Map<String, dynamic>);
  }

  Future<ConversationDto> reopenAdminConversation(String uuid) async {
    final r = await _dio.post('/admin/conversations/$uuid/reopen');
    return ConversationDto.fromJson(
        (r.data as Map<String, dynamic>)['data'] as Map<String, dynamic>);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // ADMIN — conversation-reports (signalements)
  // ─────────────────────────────────────────────────────────────────────────

  Future<ConversationReportListResponseDto> getAdminConversationReports({
    String? search,
    String? reason,
    int page = 1,
    int perPage = 20,
  }) async {
    final r = await _dio.get('/admin/conversation-reports', queryParameters: {
      if (search != null && search.isNotEmpty) 'search': search,
      if (reason != null) 'reason': reason,
      'page': page,
      'per_page': perPage,
    });
    return ConversationReportListResponseDto.fromJson(
        r.data as Map<String, dynamic>);
  }

  Future<AdminReportStatsDto> getAdminConversationReportStats() async {
    final r = await _dio.get('/admin/conversation-reports/stats');
    final data = (r.data as Map<String, dynamic>)['data'] as Map<String, dynamic>?
        ?? r.data as Map<String, dynamic>;
    return AdminReportStatsDto.fromJson(data);
  }

  Future<void> reviewAdminConversationReport({
    required String reportUuid,
    required String action, // 'dismiss' | 'reviewed'
    String? adminNote,
  }) async {
    await _dio.post(
      '/admin/conversation-reports/$reportUuid/review',
      data: {
        'action': action,
        if (adminNote != null) 'admin_note': adminNote,
      },
    );
  }

  Future<void> updateAdminConversationReportNote({
    required String reportUuid,
    String? adminNote,
  }) async {
    await _dio.patch(
      '/admin/conversation-reports/$reportUuid/note',
      data: {'admin_note': adminNote},
    );
  }

  // GET /admin/users?search=xxx  (user search for admin new conversation)
  Future<List<Map<String, dynamic>>> searchAdminUsers({
    String? search,
    int perPage = 20,
  }) async {
    final r = await _dio.get('/admin/users', queryParameters: {
      if (search != null && search.isNotEmpty) 'search': search,
      'per_page': perPage,
    });
    final data = r.data;
    if (data is List) return data.cast<Map<String, dynamic>>();
    final list = (data as Map<String, dynamic>)['data'] as List? ?? [];
    return list.cast<Map<String, dynamic>>();
  }

  // GET /admin/organizations?search=xxx
  Future<List<Map<String, dynamic>>> searchAdminOrganizations({
    String? search,
    int perPage = 20,
  }) async {
    final r = await _dio.get('/admin/organizations', queryParameters: {
      if (search != null && search.isNotEmpty) 'search': search,
      'per_page': perPage,
    });
    final data = r.data;
    if (data is List) return data.cast<Map<String, dynamic>>();
    final list = (data as Map<String, dynamic>)['data'] as List? ?? [];
    return list.cast<Map<String, dynamic>>();
  }
}

final messagesApiDataSourceProvider = Provider<MessagesApiDataSource>((ref) {
  return MessagesApiDataSource(ref.read(dioProvider));
});
