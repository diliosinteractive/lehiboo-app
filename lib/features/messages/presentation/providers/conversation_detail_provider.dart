import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/utils/api_response_handler.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/entities/conversation_route.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/messages_repository.dart';
import '../../data/repositories/messages_repository_impl.dart';
import 'unread_count_provider.dart';
import 'conversations_provider.dart';
import 'support_conversations_provider.dart';
import 'vendor_conversations_provider.dart';
import 'vendor_org_conversations_provider.dart';
import 'admin_conversations_provider.dart';
import 'messages_realtime_provider.dart';

class ConversationDetailState {
  final AsyncValue<Conversation> conversation;
  final bool isSending;
  final String? sendError;
  final ConversationRoute route;

  const ConversationDetailState({
    this.conversation = const AsyncValue.loading(),
    this.isSending = false,
    this.sendError,
    this.route = ConversationRoute.participant,
  });

  ConversationDetailState copyWith({
    AsyncValue<Conversation>? conversation,
    bool? isSending,
    String? sendError,
    bool clearSendError = false,
    ConversationRoute? route,
  }) {
    return ConversationDetailState(
      conversation: conversation ?? this.conversation,
      isSending: isSending ?? this.isSending,
      sendError: clearSendError ? null : (sendError ?? this.sendError),
      route: route ?? this.route,
    );
  }
}

class ConversationDetailNotifier
    extends StateNotifier<ConversationDetailState> {
  final String _uuid;
  final ConversationRoute _route;
  final MessagesRepository _repo;
  final Ref _ref;
  Timer? _pollTimer;
  StreamSubscription<RealtimeEvent>? _realtimeSub;

  ConversationDetailNotifier(
    this._uuid,
    this._route,
    this._repo,
    this._ref,
  ) : super(ConversationDetailState(route: _route)) {
    load();
    _startPolling();
    _subscribeToRealtime();
    _ref.listen<AuthState>(authProvider, (prev, next) {
      if (prev?.user?.id != next.user?.id) {
        _pollTimer?.cancel();
        _pollTimer = null;
        _realtimeSub?.cancel();
        _realtimeSub = null;
      }
    });
  }

  void _startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 10), (_) async {
      if (_ref.read(messagesRealtimeProvider)) return;
      await _silentRefresh();
    });
  }

  void _subscribeToRealtime() {
    _realtimeSub = _ref
        .read(messagesRealtimeProvider.notifier)
        .events
        .listen((event) {
      if (!mounted) return;
      if (event.conversationUuid != _uuid) return;
      switch (event.type) {
        case RealtimeEventType.messageReceived:
          _silentRefresh();
        case RealtimeEventType.messageDelivered:
          if (event.messageUuid != null) _applyDelivered(event.messageUuid!);
        case RealtimeEventType.messageEdited:
          if (event.messageUuid != null && event.content != null) {
            _applyEdit(event.messageUuid!, event.content!, event.editedAt);
          }
        case RealtimeEventType.messageDeleted:
          if (event.messageUuid != null) _applyDelete(event.messageUuid!);
        case RealtimeEventType.conversationRead:
          _applyAllRead();
        case RealtimeEventType.conversationClosed:
          _applyStatus('closed');
        case RealtimeEventType.conversationReopened:
          _applyStatus('open');
        default:
          break;
      }
    });
  }

  // ── Realtime local state updates ──────────────────────────────────────────

  void _applyDelivered(String messageUuid) {
    final conv = state.conversation.valueOrNull;
    if (conv == null) return;
    final messages = conv.messages
        .map((m) =>
            m.uuid == messageUuid ? m.copyWith(isDelivered: true) : m)
        .toList();
    state = state.copyWith(
        conversation: AsyncValue.data(conv.copyWith(messages: messages)));
  }

  void _applyEdit(String messageUuid, String content, DateTime? editedAt) {
    final conv = state.conversation.valueOrNull;
    if (conv == null) return;
    final messages = conv.messages.map((m) {
      if (m.uuid == messageUuid) {
        return m.copyWith(
            content: content,
            isEdited: true,
            editedAt: editedAt ?? DateTime.now());
      }
      return m;
    }).toList();
    state = state.copyWith(
        conversation: AsyncValue.data(conv.copyWith(messages: messages)));
  }

  void _applyDelete(String messageUuid) {
    final conv = state.conversation.valueOrNull;
    if (conv == null) return;
    final messages = conv.messages
        .map((m) =>
            m.uuid == messageUuid ? m.copyWith(isDeleted: true) : m)
        .toList();
    state = state.copyWith(
        conversation: AsyncValue.data(conv.copyWith(messages: messages)));
  }

  void _applyAllRead() {
    final conv = state.conversation.valueOrNull;
    if (conv == null) return;
    final now = DateTime.now();
    final messages = conv.messages.map((m) {
      if (m.isMine && !m.isRead) {
        return m.copyWith(isRead: true, readAt: now);
      }
      return m;
    }).toList();
    state = state.copyWith(
        conversation: AsyncValue.data(conv.copyWith(messages: messages)));
  }

  void _applyStatus(String status) {
    final conv = state.conversation.valueOrNull;
    if (conv == null) return;
    state = state.copyWith(
        conversation: AsyncValue.data(conv.copyWith(status: status)));
    _invalidateList();
  }

  void _invalidateList() {
    switch (_route) {
      case ConversationRoute.participant:
        _ref.read(conversationsProvider.notifier).refresh();
      case ConversationRoute.participantSupport:
        _ref.read(supportConversationsProvider.notifier).refresh();
      case ConversationRoute.vendor:
        _ref.read(vendorConversationsProvider.notifier).refresh();
      case ConversationRoute.vendorOrgOrg:
        _ref.read(vendorOrgConversationsProvider.notifier).refresh();
      case ConversationRoute.admin:
      case ConversationRoute.adminReadonly:
        _ref.read(adminConversationsProvider('user_support').notifier).refresh();
        _ref.read(adminConversationsProvider('vendor_admin').notifier).refresh();
    }
  }

  String _senderTypeForRoute() {
    return switch (_route) {
      ConversationRoute.vendor || ConversationRoute.vendorOrgOrg =>
        'organization',
      ConversationRoute.admin || ConversationRoute.adminReadonly => 'admin',
      _ => 'participant',
    };
  }

  Future<Conversation> _fetchConversation() async {
    return switch (_route) {
      ConversationRoute.participant => _repo
          .markConversationAsRead(_uuid)
          .then((_) => _repo.getConversation(_uuid)),
      ConversationRoute.participantSupport =>
        _repo.getSupportConversation(_uuid),
      ConversationRoute.vendor => _repo
          .markVendorConversationAsRead(_uuid)
          .then((_) => _repo.getVendorConversation(_uuid)),
      ConversationRoute.vendorOrgOrg => _repo
          .markOrgConversationAsRead(_uuid)
          .then((_) => _repo.getOrgConversation(_uuid)),
      ConversationRoute.admin => _repo
          .markAdminConversationAsRead(_uuid)
          .then((_) => _repo.getAdminConversation(_uuid)),
      ConversationRoute.adminReadonly => _repo.getAdminConversation(_uuid),
    };
  }

  Future<Conversation> _fetchConversationSilent() async {
    return switch (_route) {
      ConversationRoute.participant => _repo.getConversation(_uuid),
      ConversationRoute.participantSupport =>
        _repo.getSupportConversation(_uuid),
      ConversationRoute.vendor => _repo.getVendorConversation(_uuid),
      ConversationRoute.vendorOrgOrg => _repo.getOrgConversation(_uuid),
      ConversationRoute.admin => _repo.getAdminConversation(_uuid),
      ConversationRoute.adminReadonly => _repo.getAdminConversation(_uuid),
    };
  }

  Future<void> _silentRefresh() async {
    try {
      final conversation = await _fetchConversationSilent();
      if (!mounted) return;
      state = state.copyWith(conversation: AsyncValue.data(conversation));
      final unread = conversation.unreadCount;
      if (unread > 0) {
        final current = _ref.read(unreadCountProvider);
        _ref.read(unreadCountProvider.notifier).state =
            (current - unread).clamp(0, current);
      } else {
        // Re-apply zero so a list refresh that returned stale data is corrected.
        _applyReadToList();
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 403 || e.response?.statusCode == 401) {
        // Stale provider from a previous session/role — stop polling immediately.
        _pollTimer?.cancel();
        _pollTimer = null;
      }
    } catch (_) {}
  }

  Future<void> load() async {
    final prevUnread = _getListUnread();
    state = state.copyWith(conversation: const AsyncValue.loading());
    try {
      final conversation = await _fetchConversation();
      state = state.copyWith(conversation: AsyncValue.data(conversation));
      _applyReadToList();
      if (prevUnread > 0) {
        final current = _ref.read(unreadCountProvider);
        _ref.read(unreadCountProvider.notifier).state =
            (current - prevUnread).clamp(0, current);
      }
    } catch (e, st) {
      state = state.copyWith(conversation: AsyncValue.error(e, st));
    }
  }

  int _getListUnread() {
    List<Conversation>? list;
    switch (_route) {
      case ConversationRoute.participant:
        list = _ref.read(conversationsProvider).conversations.valueOrNull;
      case ConversationRoute.participantSupport:
        list = _ref.read(supportConversationsProvider).conversations.valueOrNull;
      case ConversationRoute.vendor:
        list = _ref.read(vendorConversationsProvider).conversations.valueOrNull;
        if (list == null || !list.any((c) => c.uuid == _uuid)) {
          list = _ref.read(vendorSupportProvider).conversations.valueOrNull;
        }
      case ConversationRoute.vendorOrgOrg:
        list = _ref.read(vendorOrgConversationsProvider).conversations.valueOrNull;
      case ConversationRoute.admin:
        list = _ref.read(adminConversationsProvider('user_support')).conversations.valueOrNull;
        if (list == null || !list.any((c) => c.uuid == _uuid)) {
          list = _ref.read(adminConversationsProvider('vendor_admin')).conversations.valueOrNull;
        }
      case ConversationRoute.adminReadonly:
        return 0;
    }
    if (list == null) return 0;
    try {
      return list.firstWhere((c) => c.uuid == _uuid).unreadCount;
    } catch (_) {
      return 0;
    }
  }

  void _applyReadToList() {
    switch (_route) {
      case ConversationRoute.participant:
        _ref.read(conversationsProvider.notifier).applyRead(_uuid);
      case ConversationRoute.participantSupport:
        _ref.read(supportConversationsProvider.notifier).applyRead(_uuid);
      case ConversationRoute.vendor:
        _ref.read(vendorConversationsProvider.notifier).applyRead(_uuid);
        _ref.read(vendorSupportProvider.notifier).applyRead(_uuid);
      case ConversationRoute.vendorOrgOrg:
        _ref.read(vendorOrgConversationsProvider.notifier).applyRead(_uuid);
      case ConversationRoute.admin:
        _ref.read(adminConversationsProvider('user_support').notifier).applyRead(_uuid);
        _ref.read(adminConversationsProvider('vendor_admin').notifier).applyRead(_uuid);
      case ConversationRoute.adminReadonly:
        break;
    }
  }

  Future<void> sendMessage({String? content, List<XFile>? attachments}) async {
    if (_route == ConversationRoute.adminReadonly) return;
    final conversation = state.conversation.valueOrNull;
    if (conversation == null) return;

    final tempUuid = 'temp-${DateTime.now().millisecondsSinceEpoch}';
    final tempMessage = Message(
      uuid: tempUuid,
      senderType: _senderTypeForRoute(),
      isSystem: false,
      sender: null,
      content: content,
      isDeleted: false,
      isEdited: false,
      isRead: false,
      isDelivered: false,
      isMine: true,
      attachments: const [],
      createdAt: DateTime.now(),
    );

    final optimisticMessages = [...conversation.messages, tempMessage];
    state = state.copyWith(
      conversation: AsyncValue.data(
          conversation.copyWith(messages: optimisticMessages)),
      isSending: true,
      clearSendError: true,
    );

    try {
      final sentMessage = await _sendMessageForRoute(content, attachments);
      if (!mounted) return;
      final updated = optimisticMessages
          .map((m) => m.uuid == tempUuid ? sentMessage : m)
          .toList();
      state = state.copyWith(
        conversation: AsyncValue.data(conversation.copyWith(messages: updated)),
        isSending: false,
      );
      _invalidateList();
    } catch (e, s) {
      log(e.toString(), stackTrace: s);
      if (!mounted) return;
      final reverted =
          optimisticMessages.where((m) => m.uuid != tempUuid).toList();
      state = state.copyWith(
        conversation:
            AsyncValue.data(conversation.copyWith(messages: reverted)),
        isSending: false,
        sendError: ApiResponseHandler.extractError(
          e,
          fallback: "Échec de l'envoi. Réessayez.",
        ),
      );
    }
  }

  Future<Message> _sendMessageForRoute(
      String? content, List<XFile>? attachments) {
    return switch (_route) {
      ConversationRoute.participant => _repo.sendMessage(
          conversationUuid: _uuid,
          content: content,
          attachments: attachments,
        ),
      ConversationRoute.participantSupport => _repo.sendSupportMessage(
          conversationUuid: _uuid,
          content: content,
          attachments: attachments,
        ),
      ConversationRoute.vendor => _repo.sendVendorMessage(
          conversationUuid: _uuid,
          content: content,
          attachments: attachments,
        ),
      ConversationRoute.vendorOrgOrg => _repo.sendOrgMessage(
          conversationUuid: _uuid,
          content: content,
          attachments: attachments,
        ),
      ConversationRoute.admin => _repo.sendAdminMessage(
          conversationUuid: _uuid,
          content: content,
          attachments: attachments,
        ),
      ConversationRoute.adminReadonly => throw UnsupportedError(
          'Cannot send messages in read-only mode',
        ),
    };
  }

  Future<void> editMessage(String messageUuid, String content) async {
    final conversation = state.conversation.valueOrNull;
    if (conversation == null) return;
    final updated = await _editMessageForRoute(messageUuid, content);
    final messages =
        conversation.messages.map((m) => m.uuid == messageUuid ? updated : m).toList();
    state = state.copyWith(
        conversation:
            AsyncValue.data(conversation.copyWith(messages: messages)));
  }

  Future<Message> _editMessageForRoute(String messageUuid, String content) {
    return switch (_route) {
      ConversationRoute.participant => _repo.editMessage(
          conversationUuid: _uuid,
          messageUuid: messageUuid,
          content: content,
        ),
      ConversationRoute.participantSupport => _repo.editMessage(
          conversationUuid: _uuid,
          messageUuid: messageUuid,
          content: content,
        ),
      ConversationRoute.vendor => _repo.editVendorMessage(
          conversationUuid: _uuid,
          messageUuid: messageUuid,
          content: content,
        ),
      ConversationRoute.vendorOrgOrg => _repo.editOrgMessage(
          conversationUuid: _uuid,
          messageUuid: messageUuid,
          content: content,
        ),
      ConversationRoute.admin => _repo.editAdminMessage(
          conversationUuid: _uuid,
          messageUuid: messageUuid,
          content: content,
        ),
      ConversationRoute.adminReadonly => throw UnsupportedError(
          'Cannot edit messages in read-only mode',
        ),
    };
  }

  Future<void> deleteMessage(String messageUuid) async {
    final conversation = state.conversation.valueOrNull;
    if (conversation == null) return;
    await _deleteMessageForRoute(messageUuid);
    final messages = conversation.messages.map((m) {
      if (m.uuid == messageUuid) return m.copyWith(isDeleted: true);
      return m;
    }).toList();
    state = state.copyWith(
        conversation:
            AsyncValue.data(conversation.copyWith(messages: messages)));
  }

  Future<void> _deleteMessageForRoute(String messageUuid) {
    return switch (_route) {
      ConversationRoute.participant => _repo.deleteMessage(
          conversationUuid: _uuid, messageUuid: messageUuid),
      ConversationRoute.participantSupport => _repo.deleteMessage(
          conversationUuid: _uuid, messageUuid: messageUuid),
      ConversationRoute.vendor => _repo.deleteVendorMessage(
          conversationUuid: _uuid, messageUuid: messageUuid),
      ConversationRoute.vendorOrgOrg => _repo.deleteOrgMessage(
          conversationUuid: _uuid, messageUuid: messageUuid),
      ConversationRoute.admin => _repo.deleteAdminMessage(
          conversationUuid: _uuid, messageUuid: messageUuid),
      ConversationRoute.adminReadonly => throw UnsupportedError(
          'Cannot delete messages in read-only mode',
        ),
    };
  }

  Future<void> closeConversation() async {
    final closed = await _closeConversationForRoute();
    state = state.copyWith(conversation: AsyncValue.data(closed));
    _invalidateList();
  }

  Future<Conversation> _closeConversationForRoute() {
    return switch (_route) {
      ConversationRoute.participant => _repo.closeConversation(_uuid),
      ConversationRoute.participantSupport => _repo.closeConversation(_uuid),
      ConversationRoute.vendor => _repo.closeVendorConversation(_uuid),
      ConversationRoute.vendorOrgOrg => _repo.closeOrgConversation(_uuid),
      ConversationRoute.admin => _repo.closeAdminConversation(_uuid),
      ConversationRoute.adminReadonly =>
        throw UnsupportedError('Cannot close in read-only mode'),
    };
  }

  Future<void> reopenConversation() async {
    if (_route != ConversationRoute.admin) return;
    final reopened = await _repo.reopenAdminConversation(_uuid);
    state = state.copyWith(conversation: AsyncValue.data(reopened));
    _ref.read(adminConversationsProvider('user_support').notifier).refresh();
    _ref.read(adminConversationsProvider('vendor_admin').notifier).refresh();
  }

  Future<ReportConversationResult> reportConversation(
      String reason, String? comment) async {
    return _repo.reportConversation(
      conversationUuid: _uuid,
      reason: reason,
      comment: comment,
    );
  }

  void clearSendError() {
    state = state.copyWith(clearSendError: true);
  }

  @override
  void dispose() {
    _realtimeSub?.cancel();
    _pollTimer?.cancel();
    super.dispose();
  }
}

// Family provider keyed by (uuid, route) — autoDispose so the poll timer is
// cancelled as soon as the conversation screen is popped (0 listeners).
final conversationDetailProvider = StateNotifierProvider.autoDispose.family<
    ConversationDetailNotifier,
    ConversationDetailState,
    ({String uuid, ConversationRoute route})>((ref, params) {
  return ConversationDetailNotifier(
    params.uuid,
    params.route,
    ref.read(messagesRepositoryProvider),
    ref,
  );
});
