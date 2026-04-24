import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/messages_repository.dart';
import '../../data/repositories/messages_repository_impl.dart';
import 'unread_count_provider.dart';
import 'conversations_provider.dart';

class ConversationDetailState {
  final AsyncValue<Conversation> conversation;
  final bool isSending;
  final String? sendError;
  final bool isSupport; // true → use support endpoints

  const ConversationDetailState({
    this.conversation = const AsyncValue.loading(),
    this.isSending = false,
    this.sendError,
    this.isSupport = false,
  });

  ConversationDetailState copyWith({
    AsyncValue<Conversation>? conversation,
    bool? isSending,
    String? sendError,
    bool clearSendError = false,
    bool? isSupport,
  }) {
    return ConversationDetailState(
      conversation: conversation ?? this.conversation,
      isSending: isSending ?? this.isSending,
      sendError: clearSendError ? null : (sendError ?? this.sendError),
      isSupport: isSupport ?? this.isSupport,
    );
  }
}

class ConversationDetailNotifier
    extends StateNotifier<ConversationDetailState> {
  final String _uuid;
  final bool _isSupport;
  final MessagesRepository _repo;
  final Ref _ref;
  Timer? _pollTimer;

  ConversationDetailNotifier(
    this._uuid,
    this._isSupport,
    this._repo,
    this._ref,
  ) : super(ConversationDetailState(isSupport: _isSupport)) {
    load();
    _startPolling();
  }

  void _startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 10), (_) => _silentRefresh());
  }

  Future<void> _silentRefresh() async {
    try {
      final conversation = _isSupport
          ? await _repo.getSupportConversation(_uuid)
          : await _repo.getConversation(_uuid);
      if (!mounted) return;
      state = state.copyWith(conversation: AsyncValue.data(conversation));
      // Decrement global unread badge by this conversation's unread count
      final unread = conversation.unreadCount;
      if (unread > 0) {
        final current = _ref.read(unreadCountProvider);
        _ref.read(unreadCountProvider.notifier).state =
            (current - unread).clamp(0, current);
      }
    } catch (_) {
      // Silent — don't change state on poll failure
    }
  }

  Future<void> load() async {
    state = state.copyWith(conversation: const AsyncValue.loading());
    try {
      final conversation = _isSupport
          ? await _repo.getSupportConversation(_uuid)
          : await _repo.getConversation(_uuid);
      state = state.copyWith(conversation: AsyncValue.data(conversation));
      // Decrement global badge
      final unread = conversation.unreadCount;
      if (unread > 0) {
        final current = _ref.read(unreadCountProvider);
        _ref.read(unreadCountProvider.notifier).state =
            (current - unread).clamp(0, current);
      }
    } catch (e, st) {
      state = state.copyWith(conversation: AsyncValue.error(e, st));
    }
  }

  Future<void> sendMessage({String? content, List<XFile>? attachments}) async {
    final conversation = state.conversation.valueOrNull;
    if (conversation == null) return;

    // Optimistic: create a temp message
    final tempUuid = 'temp-${DateTime.now().millisecondsSinceEpoch}';
    final tempMessage = Message(
      uuid: tempUuid,
      senderType: 'participant',
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
      final sentMessage = _isSupport
          ? await _repo.sendSupportMessage(
              conversationUuid: _uuid,
              content: content ?? '',
            )
          : await _repo.sendMessage(
              conversationUuid: _uuid,
              content: content,
              attachments: attachments,
            );

      if (!mounted) return;
      // Replace temp message with real one
      final updated = optimisticMessages
          .map((m) => m.uuid == tempUuid ? sentMessage : m)
          .toList();
      state = state.copyWith(
        conversation: AsyncValue.data(conversation.copyWith(messages: updated)),
        isSending: false,
      );
      // Refresh list to update latest_message preview
      _ref.read(conversationsProvider.notifier).refresh();
    } catch (e) {
      if (!mounted) return;
      // Mark optimistic message as failed — remove it and show error
      final reverted = optimisticMessages
          .where((m) => m.uuid != tempUuid)
          .toList();
      state = state.copyWith(
        conversation: AsyncValue.data(conversation.copyWith(messages: reverted)),
        isSending: false,
        sendError: e.toString(),
      );
    }
  }

  Future<void> editMessage(String messageUuid, String content) async {
    final conversation = state.conversation.valueOrNull;
    if (conversation == null) return;
    try {
      final updated = await _repo.editMessage(
        conversationUuid: _uuid,
        messageUuid: messageUuid,
        content: content,
      );
      final messages = conversation.messages
          .map((m) => m.uuid == messageUuid ? updated : m)
          .toList();
      state = state.copyWith(
          conversation:
              AsyncValue.data(conversation.copyWith(messages: messages)));
    } catch (_) {
      rethrow;
    }
  }

  Future<void> deleteMessage(String messageUuid) async {
    final conversation = state.conversation.valueOrNull;
    if (conversation == null) return;
    await _repo.deleteMessage(
        conversationUuid: _uuid, messageUuid: messageUuid);
    // Replace with soft-deleted placeholder
    final messages = conversation.messages.map((m) {
      if (m.uuid == messageUuid) {
        return m.copyWith(isDeleted: true);
      }
      return m;
    }).toList();
    state = state.copyWith(
        conversation:
            AsyncValue.data(conversation.copyWith(messages: messages)));
  }

  Future<void> closeConversation() async {
    final closed = await _repo.closeConversation(_uuid);
    state = state.copyWith(conversation: AsyncValue.data(closed));
    _ref.read(conversationsProvider.notifier).refresh();
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
    _pollTimer?.cancel();
    super.dispose();
  }
}

// Family provider keyed by (uuid, isSupport)
final conversationDetailProvider = StateNotifierProvider.family<
    ConversationDetailNotifier,
    ConversationDetailState,
    ({String uuid, bool isSupport})>((ref, params) {
  return ConversationDetailNotifier(
    params.uuid,
    params.isSupport,
    ref.read(messagesRepositoryProvider),
    ref,
  );
});
