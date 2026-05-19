import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/services/deep_link_service.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/utils/api_response_handler.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../booking/presentation/widgets/filter_tabs_row.dart';
import '../../domain/entities/in_app_notification.dart';
import '../providers/in_app_notifications_provider.dart';

class NotificationsInboxScreen extends ConsumerStatefulWidget {
  const NotificationsInboxScreen({super.key});

  @override
  ConsumerState<NotificationsInboxScreen> createState() =>
      _NotificationsInboxScreenState();
}

class _NotificationsInboxScreenState
    extends ConsumerState<NotificationsInboxScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(inAppNotificationsProvider.notifier).load(refresh: true);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 360) {
      ref.read(inAppNotificationsProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final state = ref.watch(inAppNotificationsProvider);
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: HbColors.orangePastel,
      appBar: AppBar(
        title: Text(
          l10n.notificationsTitle,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        foregroundColor: HbColors.textSlate,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: l10n.notificationsMarkAllRead,
            onPressed: state.unreadCount > 0 ? _markAllAsRead : null,
            icon: Badge(
              isLabelVisible: state.unreadCount > 0,
              label: Text('${state.unreadCount}'),
              child: const Icon(Icons.done_all_rounded),
            ),
          ),
        ],
      ),
      body: authState.isAuthenticated
          ? _buildAuthenticatedBody(state)
          : _buildGuestState(context),
    );
  }

  Widget _buildAuthenticatedBody(InAppNotificationsState state) {
    final tabs = [
      FilterTab(
        id: 'all',
        label: context.l10n.notificationsFilterAll,
        icon: Icons.notifications_none_rounded,
        color: HbColors.brandPrimary,
      ),
      FilterTab(
        id: 'unread',
        label: context.l10n.notificationsFilterUnread,
        icon: Icons.mark_email_unread_outlined,
        count: state.unreadCount,
        color: HbColors.accentBlue,
      ),
    ];

    return Column(
      children: [
        Container(
          color: Colors.white,
          child: FilterTabsRow(
            tabs: tabs,
            selectedTabId: state.unreadOnly ? 'unread' : 'all',
            onTabSelected: (id) {
              HapticFeedback.selectionClick();
              ref
                  .read(inAppNotificationsProvider.notifier)
                  .setUnreadOnly(id == 'unread');
            },
          ),
        ),
        Container(height: 1, color: Colors.grey.shade200),
        Expanded(
          child: state.notifications.when(
            data: (notifications) {
              if (!state.hasLoadedInbox) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: HbColors.brandPrimary,
                  ),
                );
              }
              if (notifications.isEmpty) {
                return RefreshIndicator(
                  onRefresh: _refresh,
                  color: HbColors.brandPrimary,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.18),
                      _EmptyNotificationsState(unreadOnly: state.unreadOnly),
                    ],
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: _refresh,
                color: HbColors.brandPrimary,
                child: ListView.separated(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount:
                      notifications.length + (state.isLoadingMore ? 1 : 0),
                  separatorBuilder: (_, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    if (index >= notifications.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: HbColors.brandPrimary,
                          ),
                        ),
                      );
                    }
                    return _NotificationTile(
                      notification: notifications[index],
                      onTap: () => _openNotification(notifications[index]),
                      onDelete: () => _deleteNotification(notifications[index]),
                      onMarkRead: notifications[index].isRead
                          ? null
                          : () => _markAsRead(notifications[index]),
                    );
                  },
                ),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(color: HbColors.brandPrimary),
            ),
            error: (error, stackTrace) => _ErrorState(
              message: ApiResponseHandler.extractError(error),
              onRetry: () => ref
                  .read(inAppNotificationsProvider.notifier)
                  .load(refresh: true),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGuestState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: HbColors.brandPrimary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                size: 48,
                color: HbColors.brandPrimary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              context.l10n.notificationsGuestTitle,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: HbColors.textSlate,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.notificationsGuestBody,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.push(
                '/login?redirect=${Uri.encodeComponent('/notifications')}',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: HbColors.brandPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: Text(context.l10n.authLoginSubmit),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refresh() {
    return ref.read(inAppNotificationsProvider.notifier).refresh();
  }

  Future<void> _openNotification(InAppNotification notification) async {
    try {
      if (!notification.isRead) {
        await ref
            .read(inAppNotificationsProvider.notifier)
            .markAsRead(notification.id);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.notificationsReadSyncError)),
        );
      }
    }

    if (!mounted) return;
    ref.read(deepLinkServiceProvider).navigateFromNotification(
          actionUrl: notification.actionUrl,
          type: notification.type,
          data: notification.data,
        );
  }

  Future<void> _markAsRead(InAppNotification notification) async {
    try {
      await ref
          .read(inAppNotificationsProvider.notifier)
          .markAsRead(notification.id);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.notificationsMarkReadError)),
      );
    }
  }

  Future<void> _markAllAsRead() async {
    try {
      await ref.read(inAppNotificationsProvider.notifier).markAllAsRead();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.notificationsMarkedAllRead)),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.notificationsActionError)),
      );
    }
  }

  Future<void> _deleteNotification(InAppNotification notification) async {
    try {
      await ref
          .read(inAppNotificationsProvider.notifier)
          .deleteNotification(notification.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.notificationsDeleted)),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.notificationsDeleteError)),
      );
    }
  }
}

class _NotificationTile extends StatelessWidget {
  final InAppNotification notification;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback? onMarkRead;

  const _NotificationTile({
    required this.notification,
    required this.onTap,
    required this.onDelete,
    this.onMarkRead,
  });

  @override
  Widget build(BuildContext context) {
    final style = _NotificationVisuals.forType(notification.type);

    return Dismissible(
      key: ValueKey(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: HbColors.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.delete_outline, color: HbColors.error),
      ),
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) => onDelete(),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: notification.isRead
                    ? Colors.grey.shade200
                    : style.color.withValues(alpha: 0.35),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: style.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(style.icon, color: style.color, size: 23),
                    ),
                    if (!notification.isRead)
                      Positioned(
                        top: -2,
                        right: -2,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: HbColors.brandPrimary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                color: HbColors.textSlate,
                                fontSize: 15.5,
                                fontWeight: notification.isRead
                                    ? FontWeight.w600
                                    : FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatTime(context, notification.createdAt),
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      if (notification.message.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          notification.message,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: notification.isRead
                                ? Colors.grey[600]
                                : HbColors.textSecondary,
                            height: 1.35,
                            fontSize: 13.5,
                          ),
                        ),
                      ],
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _TypePill(
                              type: notification.type, color: style.color),
                          const Spacer(),
                          PopupMenuButton<_NotificationAction>(
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              Icons.more_horiz,
                              color: Colors.grey[500],
                            ),
                            onSelected: (action) {
                              switch (action) {
                                case _NotificationAction.markRead:
                                  onMarkRead?.call();
                                case _NotificationAction.delete:
                                  onDelete();
                              }
                            },
                            itemBuilder: (context) => [
                              if (onMarkRead != null)
                                PopupMenuItem(
                                  value: _NotificationAction.markRead,
                                  child:
                                      Text(context.l10n.notificationsMarkRead),
                                ),
                              PopupMenuItem(
                                value: _NotificationAction.delete,
                                child: Text(context.l10n.messagesDeleteAction),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(context.l10n.notificationsDeleteTitle),
          content: Text(context.l10n.notificationsDeleteBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(context.l10n.commonCancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: TextButton.styleFrom(foregroundColor: HbColors.error),
              child: Text(context.l10n.messagesDeleteAction),
            ),
          ],
        );
      },
    );
  }

  static String _formatTime(BuildContext context, DateTime? createdAt) {
    if (createdAt == null) return '';
    final local = createdAt.toLocal();
    final now = DateTime.now();
    final diff = now.difference(local);

    if (diff.inMinutes < 1) return context.l10n.notificationsJustNow;
    if (diff.inHours < 1) {
      return context.l10n.notificationsMinutesAgoShort(diff.inMinutes);
    }
    if (diff.inDays < 1) {
      return context.l10n.notificationsHoursAgoShort(diff.inHours);
    }
    if (diff.inDays == 1) return context.l10n.commonYesterday;
    if (diff.inDays < 7) {
      return context.l10n.notificationsDaysAgoShort(diff.inDays);
    }
    return DateFormat('dd/MM/yy').format(local);
  }
}

enum _NotificationAction { markRead, delete }

class _TypePill extends StatelessWidget {
  final String type;
  final Color color;

  const _TypePill({
    required this.type,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        _labelForType(context, type),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  String _labelForType(BuildContext context, String type) {
    final l10n = context.l10n;
    if (type == 'new_message') return l10n.notificationsTypeMessage;
    if (type.startsWith('booking_')) return l10n.notificationsTypeBooking;
    if (type.startsWith('ticket_') || type == 'tickets_ready') {
      return l10n.notificationsTypeTicket;
    }
    if (type.startsWith('event_') ||
        type.startsWith('new_event_') ||
        type.startsWith('new_slots_')) {
      return l10n.notificationsTypeEvent;
    }
    if (type.startsWith('review_')) return l10n.notificationsTypeReview;
    if (type.startsWith('question_')) return l10n.notificationsTypeQuestion;
    if (type.startsWith('organization_') || type.startsWith('vendor_')) {
      return l10n.notificationsTypeOrganization;
    }
    return l10n.notificationsTypeInfo;
  }
}

class _NotificationVisuals {
  final IconData icon;
  final Color color;

  const _NotificationVisuals({
    required this.icon,
    required this.color,
  });

  factory _NotificationVisuals.forType(String type) {
    final normalized = type.toLowerCase();
    final tone = _toneForType(normalized);
    final color = switch (tone) {
      _NotificationTone.success => HbColors.success,
      _NotificationTone.warning => HbColors.warning,
      _NotificationTone.destructive => HbColors.error,
      _NotificationTone.standard => HbColors.accentBlue,
    };

    return _NotificationVisuals(
      icon: _iconForType(normalized),
      color: color,
    );
  }

  static _NotificationTone _toneForType(String type) {
    if (type.contains('cancel') ||
        type.contains('rejected') ||
        type.contains('failed')) {
      return _NotificationTone.destructive;
    }
    if (type.contains('reminder') ||
        type.contains('pending') ||
        type.contains('requested') ||
        type.contains('payout')) {
      return _NotificationTone.warning;
    }
    if (type.contains('confirmed') ||
        type.contains('approved') ||
        type.contains('payment_received') ||
        type.contains('paid')) {
      return _NotificationTone.success;
    }
    return _NotificationTone.standard;
  }

  static IconData _iconForType(String type) {
    if (type == 'new_message') return Icons.chat_bubble_outline_rounded;
    if (type.startsWith('booking_')) return Icons.confirmation_number_outlined;
    if (type.startsWith('ticket_') || type == 'tickets_ready') {
      return Icons.local_activity_outlined;
    }
    if (type.startsWith('event_') ||
        type.startsWith('new_event_') ||
        type.startsWith('new_slots_') ||
        type.startsWith('discovery_')) {
      return Icons.event_outlined;
    }
    if (type.startsWith('review_')) return Icons.rate_review_outlined;
    if (type.startsWith('question_')) return Icons.question_answer_outlined;
    if (type.startsWith('organization_') || type.startsWith('vendor_')) {
      return Icons.groups_outlined;
    }
    if (type.startsWith('payment_') ||
        type.startsWith('payout_') ||
        type == 'refund') {
      return Icons.payments_outlined;
    }
    return Icons.notifications_none_rounded;
  }
}

enum _NotificationTone { success, warning, destructive, standard }

class _EmptyNotificationsState extends StatelessWidget {
  final bool unreadOnly;

  const _EmptyNotificationsState({required this.unreadOnly});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: HbColors.brandPrimary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                unreadOnly
                    ? Icons.mark_email_read_outlined
                    : Icons.notifications_none_rounded,
                color: HbColors.brandPrimary,
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              unreadOnly
                  ? context.l10n.notificationsEmptyUnreadTitle
                  : context.l10n.notificationsEmptyTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: HbColors.textSlate,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              unreadOnly
                  ? context.l10n.notificationsEmptyUnreadBody
                  : context.l10n.notificationsEmptyBody,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              context.l10n.notificationsLoadError,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: HbColors.textSlate,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: onRetry,
              child: Text(context.l10n.commonRetry),
            ),
          ],
        ),
      ),
    );
  }
}
