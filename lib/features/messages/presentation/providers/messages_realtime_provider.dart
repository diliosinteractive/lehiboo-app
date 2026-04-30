import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:dart_pusher_channels/dart_pusher_channels.dart';
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

// ── Auth delegate ─────────────────────────────────────────────────────────────

/// Reads the Bearer token from secure storage on each auth request so it's
/// always fresh (no need to recreate the channel when the token rotates).
class _StorageTokenAuthDelegate
    implements
        EndpointAuthorizableChannelAuthorizationDelegate<
            PrivateChannelAuthorizationData> {
  final FlutterSecureStorage _storage;

  const _StorageTokenAuthDelegate(this._storage);

  @override
  EndpointAuthFailedCallback? get onAuthFailed => null;

  @override
  Future<PrivateChannelAuthorizationData> authorizationData(
    String socketId,
    String channelName,
  ) async {
    final token = await _storage.read(key: AppConstants.keyAuthToken);
    if (token == null) throw Exception('No auth token available');
    final response = await http.post(
      Uri.parse(EnvConfig.pusherAuthEndpoint),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
      },
      body: {
        'socket_id': socketId,
        'channel_name': channelName,
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Pusher auth failed: ${response.statusCode}');
    }
    final decoded = jsonDecode(response.body) as Map;
    return PrivateChannelAuthorizationData(authKey: decoded['auth'] as String);
  }
}

// ── Notifier ──────────────────────────────────────────────────────────────────

/// Manages the WebSocket connection for real-time message updates via
/// dart_pusher_channels (pure Dart, supports custom Reverb host/port/TLS).
/// State = isConnected.
class MessagesRealtimeNotifier extends StateNotifier<bool> {
  final Ref _ref;
  PusherChannelsClient? _client;
  StreamSubscription<PusherChannelsClientLifeCycleState>? _lifecycleSub;
  StreamSubscription<ChannelReadEvent>? _eventSub;
  StreamSubscription<void>? _connectedSub;
  final _storage = const FlutterSecureStorage();
  final _eventsController = StreamController<RealtimeEvent>.broadcast();

  Stream<RealtimeEvent> get events => _eventsController.stream;

  MessagesRealtimeNotifier(this._ref) : super(false) {
    final authState = _ref.read(authProvider);
    if (authState.status == AuthStatus.authenticated &&
        authState.user != null) {
      _connect(authState.user!.id);
    }
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
    if (EnvConfig.pusherHost.isEmpty) {
      debugPrint('Pusher: PUSHER_HOST not configured — skipping WS');
      return;
    }
    try {
      final options = PusherChannelsOptions.fromHost(
        scheme: EnvConfig.pusherUseTLS ? 'wss' : 'ws',
        host: EnvConfig.pusherHost,
        key: EnvConfig.pusherKey,
        port: EnvConfig.pusherPort,
      );

      _client = PusherChannelsClient.websocket(
        options: options,
        connectionErrorHandler: (error, trace, refresh) {
          debugPrint('Pusher connection error: $error');
          refresh();
        },
        minimumReconnectDelayDuration: const Duration(seconds: 2),
      );

      _lifecycleSub = _client!.lifecycleStream.listen((lifecycleState) {
        if (mounted) {
          state = lifecycleState ==
              PusherChannelsClientLifeCycleState.establishedConnection;
        }
      });

      final channel = _client!.privateChannel(
        'private-user.$userId',
        authorizationDelegate: _StorageTokenAuthDelegate(_storage),
      );

      _eventSub = channel.bindToAll().listen(_handleEvent);

      _connectedSub = _client!.onConnectionEstablished.listen((_) {
        channel.subscribeIfNotUnsubscribed();
      });

      await _client!.connect();
    } catch (e) {
      debugPrint('Pusher connect failed: $e');
    }
  }

  Future<void> _disconnect() async {
    _lifecycleSub?.cancel();
    _eventSub?.cancel();
    _connectedSub?.cancel();
    _lifecycleSub = null;
    _eventSub = null;
    _connectedSub = null;
    try {
      await _client?.disconnect();
      _client?.dispose();
    } catch (_) {}
    _client = null;
    if (mounted) state = false;
  }

  void _handleEvent(ChannelReadEvent event) {
    if (_eventsController.isClosed) return;
    final data = event.tryGetDataAsMap() ?? {};
    final convUuid = data['conversation_uuid'] as String?;
    final msgUuid = data['message_uuid'] as String?;

    switch (event.name) {
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
