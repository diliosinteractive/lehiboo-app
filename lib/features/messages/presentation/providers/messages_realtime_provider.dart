import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:lehiboo/config/env_config.dart';
import 'package:lehiboo/core/constants/app_constants.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';

// ── Event model ───────────────────────────────────────────────────────────────

enum RealtimeEventType {
  messageReceived,
  messageDelivered,
  messageEdited,
  messageDeleted,
  conversationRead,
  conversationCreated,
  conversationClosed,
  conversationReopened,
}

class RealtimeEvent {
  final RealtimeEventType type;
  final String? conversationUuid;
  final String? messageUuid;
  final String? content;
  final DateTime? editedAt;

  const RealtimeEvent({
    required this.type,
    this.conversationUuid,
    this.messageUuid,
    this.content,
    this.editedAt,
  });
}

// ── Notifier ──────────────────────────────────────────────────────────────────

/// Manages the Pusher WebSocket connection for real-time message updates.
/// State = isConnected.
class MessagesRealtimeNotifier extends StateNotifier<bool> {
  final Ref _ref;
  PusherChannelsFlutter? _pusher;
  String? _subscribedUserId;
  final _storage = const FlutterSecureStorage();
  final _eventsController = StreamController<RealtimeEvent>.broadcast();

  Stream<RealtimeEvent> get events => _eventsController.stream;

  MessagesRealtimeNotifier(this._ref) : super(false) {
    // Connect if already authenticated
    final authState = _ref.read(authProvider);
    if (authState.status == AuthStatus.authenticated &&
        authState.user != null) {
      _connect(authState.user!.id);
    }
    // React to future auth state changes
    _ref.listen<AuthState>(authProvider, (prev, next) {
      if (next.status == AuthStatus.authenticated && next.user != null) {
        if (prev?.user?.id != next.user!.id) {
          _connect(next.user!.id);
        }
      } else if (next.status == AuthStatus.unauthenticated) {
        _disconnect();
      }
    });
  }

  Future<void> _connect(String userId) async {
    await _disconnect();
    if (EnvConfig.pusherKey.isEmpty) {
      debugPrint('Pusher: PUSHER_APP_KEY not configured — skipping WS');
      return;
    }
    try {
      _pusher = PusherChannelsFlutter.getInstance();
      await _pusher!.init(
        apiKey: EnvConfig.pusherKey,
        cluster: EnvConfig.pusherCluster,
        onConnectionStateChange: (currentState, previousState) {
          if (mounted) state = currentState == 'CONNECTED';
        },
        onError: (message, code, error) {
          debugPrint('Pusher error [$code]: $message');
        },
        onAuthorizer: (channelName, socketId, options) =>
            _authorizer(channelName, socketId),
      );
      await _pusher!.subscribe(
        channelName: 'private-user.$userId',
        onEvent: _handleEvent,
      );
      await _pusher!.connect();
      _subscribedUserId = userId;
    } catch (e) {
      debugPrint('Pusher connect failed: $e');
    }
  }

  Future<void> _disconnect() async {
    if (_pusher == null) return;
    try {
      if (_subscribedUserId != null) {
        await _pusher!
            .unsubscribe(channelName: 'private-user.$_subscribedUserId');
      }
      await _pusher!.disconnect();
    } catch (_) {}
    _pusher = null;
    _subscribedUserId = null;
    if (mounted) state = false;
  }

  Future<dynamic> _authorizer(String channelName, String socketId) async {
    try {
      final token = await _storage.read(key: AppConstants.keyAuthToken);
      if (token == null) return null;
      final response = await http.post(
        Uri.parse(EnvConfig.pusherAuthEndpoint),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'socket_id': socketId,
          'channel_name': channelName,
        }),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      debugPrint('Pusher auth failed: $e');
    }
    return null;
  }

  void _handleEvent(PusherEvent event) {
    if (_eventsController.isClosed) return;
    final rawData = event.data ?? '{}';
    Map<String, dynamic> data;
    try {
      data = jsonDecode(rawData) as Map<String, dynamic>;
    } catch (_) {
      return;
    }
    final convUuid = data['conversation_uuid'] as String?;
    final msgUuid = data['message_uuid'] as String?;

    switch (event.eventName) {
      case 'message.received':
        if (convUuid == null) return;
        _emit(RealtimeEvent(
          type: RealtimeEventType.messageReceived,
          conversationUuid: convUuid,
          messageUuid: msgUuid,
        ));
      case 'message.delivered':
        if (convUuid == null || msgUuid == null) return;
        _emit(RealtimeEvent(
          type: RealtimeEventType.messageDelivered,
          conversationUuid: convUuid,
          messageUuid: msgUuid,
        ));
      case 'message.edited':
        if (convUuid == null || msgUuid == null) return;
        _emit(RealtimeEvent(
          type: RealtimeEventType.messageEdited,
          conversationUuid: convUuid,
          messageUuid: msgUuid,
          content: data['content'] as String?,
          editedAt: DateTime.tryParse(data['edited_at'] as String? ?? ''),
        ));
      case 'message.deleted':
        if (convUuid == null || msgUuid == null) return;
        _emit(RealtimeEvent(
          type: RealtimeEventType.messageDeleted,
          conversationUuid: convUuid,
          messageUuid: msgUuid,
        ));
      case 'conversation.read':
        if (convUuid == null) return;
        _emit(RealtimeEvent(
          type: RealtimeEventType.conversationRead,
          conversationUuid: convUuid,
        ));
      case 'conversation.created':
        _emit(const RealtimeEvent(type: RealtimeEventType.conversationCreated));
      case 'conversation.closed':
        if (convUuid == null) return;
        _emit(RealtimeEvent(
          type: RealtimeEventType.conversationClosed,
          conversationUuid: convUuid,
        ));
      case 'conversation.reopened':
        if (convUuid == null) return;
        _emit(RealtimeEvent(
          type: RealtimeEventType.conversationReopened,
          conversationUuid: convUuid,
        ));
    }
  }

  void _emit(RealtimeEvent event) {
    if (!_eventsController.isClosed) _eventsController.add(event);
  }

  @override
  void dispose() {
    _disconnect();
    _eventsController.close();
    super.dispose();
  }
}

final messagesRealtimeProvider =
    StateNotifierProvider<MessagesRealtimeNotifier, bool>((ref) {
  return MessagesRealtimeNotifier(ref);
});
