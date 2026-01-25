import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/themes/colors.dart';
import '../../../data/models/tool_result_dto.dart';

/// Card displaying notifications from getNotifications tool
class NotificationsResultCard extends StatelessWidget {
  final NotificationsToolResult result;

  const NotificationsResultCard({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    if (result.notifications.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: HbColors.brandSecondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Stack(
                    children: [
                      const Icon(
                        Icons.notifications_outlined,
                        color: HbColors.brandSecondary,
                        size: 20,
                      ),
                      if (result.unreadCount > 0)
                        Positioned(
                          right: -2,
                          top: -2,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: HbColors.error,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: HbColors.textPrimary,
                        ),
                      ),
                      Text(
                        '${result.total} notification${result.total != 1 ? 's' : ''}'
                        '${result.unreadCount > 0 ? ' • ${result.unreadCount} unread' : ''}',
                        style: TextStyle(
                          fontSize: 13,
                          color: HbColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Notification items
          ...result.notifications.take(4).map((notification) =>
            _NotificationItem(notification: notification)),

          // Show more
          if (result.notifications.length > 4)
            InkWell(
              onTap: () => context.push('/notifications'),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'View all notifications',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: HbColors.brandPrimary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: HbColors.brandPrimary,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: HbColors.orangePastel,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            Icons.notifications_none,
            color: HbColors.brandSecondary.withOpacity(0.5),
            size: 24,
          ),
          const SizedBox(width: 12),
          const Text(
            'No notifications',
            style: TextStyle(
              fontSize: 14,
              color: HbColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final NotificationResultItem notification;

  const _NotificationItem({required this.notification});

  @override
  Widget build(BuildContext context) {
    final (icon, iconColor) = _getTypeIcon();

    return InkWell(
      onTap: () {
        // Navigate based on notification data
        final data = notification.data;
        if (data != null) {
          if (data['booking_uuid'] != null) {
            context.push('/booking/${data['booking_uuid']}');
          } else if (data['event_slug'] != null) {
            context.push('/event/${data['event_slug']}');
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notification.isRead ? Colors.transparent : HbColors.orangePastel.withOpacity(0.5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.w600,
                      color: HbColors.textPrimary,
                    ),
                  ),
                  if (notification.body != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      notification.body!,
                      style: TextStyle(
                        fontSize: 13,
                        color: HbColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(notification.createdAt),
                    style: TextStyle(
                      fontSize: 11,
                      color: HbColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Unread indicator
            if (!notification.isRead)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: HbColors.brandPrimary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  (IconData, Color) _getTypeIcon() {
    switch (notification.type.toLowerCase()) {
      case 'booking_confirmed':
        return (Icons.check_circle_outline, HbColors.success);
      case 'booking_cancelled':
        return (Icons.cancel_outlined, HbColors.error);
      case 'new_event':
        return (Icons.event, HbColors.brandPrimary);
      case 'alert_triggered':
        return (Icons.notifications_active, HbColors.warning);
      case 'reminder':
        return (Icons.schedule, HbColors.brandSecondary);
      default:
        return (Icons.notifications_outlined, HbColors.textSecondary);
    }
  }

  String _formatTime(String isoTime) {
    try {
      final time = DateTime.parse(isoTime);
      final now = DateTime.now();
      final diff = now.difference(time);

      if (diff.inMinutes < 60) {
        return '${diff.inMinutes}m ago';
      } else if (diff.inHours < 24) {
        return '${diff.inHours}h ago';
      } else if (diff.inDays < 7) {
        return '${diff.inDays}d ago';
      } else {
        return '${time.day}/${time.month}/${time.year}';
      }
    } catch (e) {
      return isoTime;
    }
  }
}
