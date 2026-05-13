import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:dart_pusher_channels/dart_pusher_channels.dart';
import 'package:lehiboo/config/dio_client.dart';
import 'package:lehiboo/config/env_config.dart';
import 'package:lehiboo/core/constants/app_constants.dart';
import 'package:lehiboo/core/services/deep_link_service.dart';
import 'dart:developer' as dev;
import 'package:lehiboo/features/notifications/data/models/in_app_notification_dto.dart';
import 'package:lehiboo/features/notifications/domain/entities/in_app_notification.dart';
import 'package:lehiboo/features/notifications/presentation/providers/in_app_notifications_provider.dart';
import 'package:lehiboo/routes/app_router.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'conversations_provider.dart';
import 'support_conversations_provider.dart';
import 'vendor_broadcasts_provider.dart';
import 'vendor_conversations_provider.dart';
import 'vendor_org_conversations_provider.dart';
import 'admin_conversations_provider.dart';
import 'unread_count_provider.dart';

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
  broadcastSent,
}

class RealtimeEvent {
  final RealtimeEventType type;
  final String? conversationUuid;
  final String? conversationType;
  final String? messageUuid;
  final String? content;
  final DateTime? editedAt;

  const RealtimeEvent({
    required this.type,
    this.conversationUuid,
    this.conversationType,
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
    final endpoint = EnvConfig.pusherAuthEndpoint;
    final token = await _storage.read(key: AppConstants.keyAuthToken);
    if (token == null || token.isEmpty) {
      dev.log(
        '[Pusher][auth] ✗ No auth token in secure storage — channel=$channelName endpoint=$endpoint',
      );
      throw Exception('No auth token available');
    }
    dev.log(
      '[Pusher][auth] → POST $endpoint channel=$channelName socket=$socketId tokenLen=${token.length}',
    );
    final http.Response response;
    try {
      response = await http.post(
        Uri.parse(endpoint),
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
    } catch (e, st) {
      dev.log('[Pusher][auth] ✗ Network error calling $endpoint: $e\n$st');
      rethrow;
    }
    if (response.statusCode != 200) {
      dev.log(
        '[Pusher][auth] ✗ HTTP ${response.statusCode} from $endpoint — body=${response.body}',
      );
      throw Exception(
        'Pusher auth failed: ${response.statusCode} ${response.body}',
      );
    }
    final Map decoded;
    try {
      decoded = jsonDecode(response.body) as Map;
    } catch (e) {
      dev.log(
        '[Pusher][auth] ✗ Could not decode auth response: $e — body=${response.body}',
      );
      rethrow;
    }
    final authKey = decoded['auth'];
    if (authKey is! String) {
      dev.log(
        '[Pusher][auth] ✗ Response missing "auth" string field — body=${response.body}',
      );
      throw Exception('Pusher auth response missing "auth" key');
    }
    dev.log('[Pusher][auth] ✓ OK channel=$channelName');
    return PrivateChannelAuthorizationData(authKey: authKey);
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
  StreamSubscription<ChannelReadEvent>? _orgEventSub;
  StreamSubscription<void>? _connectedSub;
  final _storage = SharedSecureStorage.instance;
  final _eventsController = StreamController<RealtimeEvent>.broadcast();
  int? _orgId; // numeric org ID currently subscribed to

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
          _invalidateMessageProviders();
        }
      } else if (next.status == AuthStatus.unauthenticated) {
        _disconnect();
        _invalidateMessageProviders();
      }
    });
  }

  Future<void> _connect(String userId) async {
    await _disconnect();
    if (EnvConfig.pusherKey.isEmpty) {
      dev.log('[Pusher] PUSHER_APP_KEY not configured — skipping WS');
      return;
    }
    if (EnvConfig.pusherHost.isEmpty) {
      dev.log('[Pusher] PUSHER_HOST not configured — skipping WS');
      return;
    }
    dev.log(
      '[Pusher] Connecting → ${EnvConfig.pusherUseTLS ? "wss" : "ws"}://${EnvConfig.pusherHost}:${EnvConfig.pusherPort} key=${EnvConfig.pusherKey} channel=private-user.$userId',
    );
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
          dev.log('[Pusher] Connection error: $error');
          refresh();
        },
        minimumReconnectDelayDuration: const Duration(seconds: 2),
      );

      _lifecycleSub = _client!.lifecycleStream.listen((lifecycleState) {
        dev.log('[Pusher] Lifecycle → $lifecycleState');
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
        dev.log('[Pusher] Connected — subscribing to private-user.$userId');
        channel.subscribeIfNotUnsubscribed();
        // Re-subscribe to org channel on every (re)connect
        if (_orgId != null) _subscribeOrgChannel(_orgId!);
      });

      await _client!.connect();
    } catch (e, st) {
      dev.log('[Pusher] connect() failed: $e\n$st');
    }
  }

  void _invalidateMessageProviders() {
    _ref.invalidate(conversationsProvider);
    _ref.invalidate(supportConversationsProvider);
    _ref.invalidate(vendorConversationsProvider);
    _ref.invalidate(vendorSupportProvider);
    _ref.invalidate(vendorOrgConversationsProvider);
    _ref.invalidate(vendorBroadcastsProvider);
    _ref.invalidate(adminConversationsProvider);
    _ref.invalidate(adminReportsProvider);
    _ref.read(unreadCountProvider.notifier).state = 0;
  }

  Future<void> _disconnect() async {
    _lifecycleSub?.cancel();
    _eventSub?.cancel();
    _orgEventSub?.cancel();
    _connectedSub?.cancel();
    _lifecycleSub = null;
    _eventSub = null;
    _orgEventSub = null;
    _connectedSub = null;
    _orgId = null;
    try {
      await _client?.disconnect();
      _client?.dispose();
    } catch (_) {}
    _client = null;
    if (mounted) state = false;
  }

  /// Subscribe to the vendor's organisation channel (`private-organization.{orgId}`).
  /// Safe to call multiple times — skips if already subscribed to the same org.
  void subscribeToOrganization(int orgId) {
    if (_orgId == orgId) return;
    _orgId = orgId;
    if (_client == null) {
      // Client not yet created; _orgId is stored and will be used in
      // onConnectionEstablished once _connect() runs.
      dev.log(
          '[Pusher] subscribeToOrganization: client not ready, queued orgId=$orgId');
      return;
    }
    _subscribeOrgChannel(orgId);
  }

  void _subscribeOrgChannel(int orgId) {
    _orgEventSub?.cancel();
    final channelName = 'private-organization.$orgId';
    dev.log('[Pusher] Subscribing to $channelName');
    final orgChannel = _client!.privateChannel(
      channelName,
      authorizationDelegate: _StorageTokenAuthDelegate(_storage),
    );
    _orgEventSub = orgChannel.bindToAll().listen(_handleEvent);
    orgChannel.subscribeIfNotUnsubscribed();
  }

  void _handleEvent(ChannelReadEvent event) {
    if (_eventsController.isClosed) return;
    final data = event.tryGetDataAsMap() ?? {};
    final convUuid = data['conversation_uuid'] as String?;
    final convType = data['conversation_type'] as String?;
    final msgUuid = data['message_uuid'] as String?;

    dev.log(
      '[Pusher] ▶ event="${event.name}" conv_uuid=$convUuid conv_type=$convType msg_uuid=$msgUuid raw=$data',
    );

    switch (event.name) {
      case 'message.received':
        if (convUuid == null) {
          dev.log('[Pusher] message.received dropped — no conversation_uuid');
          return;
        }
        // Increment badge immediately — no API round-trip needed.
        // Each notifier's _refreshUnreadCount() / 30s poll will re-sync the exact value.
        _ref.read(unreadCountProvider.notifier).update((n) => n + 1);
        _emit(RealtimeEvent(
          type: RealtimeEventType.messageReceived,
          conversationUuid: convUuid,
          conversationType: convType,
          messageUuid: msgUuid,
        ));
      case 'message.delivered':
        if (convUuid == null || msgUuid == null) {
          dev.log('[Pusher] message.delivered dropped — missing uuid(s)');
          return;
        }
        _emit(RealtimeEvent(
          type: RealtimeEventType.messageDelivered,
          conversationUuid: convUuid,
          conversationType: convType,
          messageUuid: msgUuid,
        ));
      case 'message.edited':
        if (convUuid == null || msgUuid == null) {
          dev.log('[Pusher] message.edited dropped — missing uuid(s)');
          return;
        }
        _emit(RealtimeEvent(
          type: RealtimeEventType.messageEdited,
          conversationUuid: convUuid,
          conversationType: convType,
          messageUuid: msgUuid,
          content: data['content'] as String?,
          editedAt: DateTime.tryParse(data['edited_at'] as String? ?? ''),
        ));
      case 'message.deleted':
        if (convUuid == null || msgUuid == null) {
          dev.log('[Pusher] message.deleted dropped — missing uuid(s)');
          return;
        }
        _emit(RealtimeEvent(
          type: RealtimeEventType.messageDeleted,
          conversationUuid: convUuid,
          conversationType: convType,
          messageUuid: msgUuid,
        ));
      case 'conversation.read':
        if (convUuid == null) {
          dev.log('[Pusher] conversation.read dropped — no conversation_uuid');
          return;
        }
        _emit(RealtimeEvent(
          type: RealtimeEventType.conversationRead,
          conversationUuid: convUuid,
          conversationType: convType,
        ));
      case 'conversation.created':
        _emit(RealtimeEvent(
          type: RealtimeEventType.conversationCreated,
          conversationType: convType,
        ));
      case 'conversation.closed':
        if (convUuid == null) {
          dev.log(
              '[Pusher] conversation.closed dropped — no conversation_uuid');
          return;
        }
        _emit(RealtimeEvent(
          type: RealtimeEventType.conversationClosed,
          conversationUuid: convUuid,
          conversationType: convType,
        ));
      case 'conversation.reopened':
        if (convUuid == null) {
          dev.log(
              '[Pusher] conversation.reopened dropped — no conversation_uuid');
          return;
        }
        _emit(RealtimeEvent(
          type: RealtimeEventType.conversationReopened,
          conversationUuid: convUuid,
          conversationType: convType,
        ));
      case 'broadcast.sent':
        final broadcastUuid = data['broadcast_uuid'] as String?;
        _emit(RealtimeEvent(
          type: RealtimeEventType.broadcastSent,
          conversationUuid: broadcastUuid,
        ));
        // Broadcast creates new conversations — refresh the clients list
        _ref.invalidate(vendorConversationsProvider);
      case 'notification.created':
        _handleNotificationCreated(data);
      default:
        dev.log('[Pusher] ⚠ unhandled event="${event.name}" data=$data');
    }
  }

  void _handleNotificationCreated(Map<String, dynamic> data) {
    final rawNotification = data['notification'];
    if (rawNotification is! Map) {
      dev.log('[Pusher] notification.created dropped — missing notification');
      return;
    }

    final json = rawNotification.map(
      (key, value) => MapEntry(key.toString(), value),
    );
    final notification = InAppNotificationDto.fromJson(json).toDomain();
    final unreadCount = _int(data['unread_count']);

    _ref.read(inAppNotificationsProvider.notifier).handleRealtimeNotification(
          notification,
          unreadCount: unreadCount,
        );
    _showForegroundNotification(notification);
  }

  void _showForegroundNotification(InAppNotification notification) {
    final messenger = scaffoldMessengerKey.currentState;
    if (messenger == null) return;

    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: _NotificationSnackContent(notification: notification),
        action: SnackBarAction(
          label: 'Ouvrir',
          onPressed: () {
            _ref.read(deepLinkServiceProvider).navigateFromNotification(
                  actionUrl: notification.actionUrl,
                  type: notification.type,
                  data: notification.data,
                );
          },
        ),
      ),
    );
  }

  int? _int(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  void _emit(RealtimeEvent event) {
    dev.log(
      '[Pusher] ✔ emit type=${event.type.name} conv=${event.conversationUuid} convType=${event.conversationType}',
    );
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

class _NotificationSnackContent extends StatelessWidget {
  final InAppNotification notification;

  const _NotificationSnackContent({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          notification.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        if (notification.message.isNotEmpty)
          Text(
            notification.message,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }
}
