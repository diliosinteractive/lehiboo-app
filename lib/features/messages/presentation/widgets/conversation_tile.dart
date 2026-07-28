import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/l10n/l10n.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/entities/message.dart';

class ConversationTile extends StatelessWidget {
  final Conversation conversation;
  final VoidCallback onTap;
  final bool showLehibooAvatar;
  final VoidCallback? onReport;

  const ConversationTile({
    super.key,
    required this.conversation,
    required this.onTap,
    this.showLehibooAvatar = false,
    this.onReport,
  });

  static const _primaryColor = Color(0xFFFF601F);

  @override
  Widget build(BuildContext context) {
    final lastMsg = conversation.latestMessage;
    final hasUnread = conversation.unreadCount > 0;
    final previewText = _buildPreviewText(context, lastMsg);
    final displayName = _displayName(context);
    final hasNameEntity = conversation.participant != null ||
        conversation.organization != null ||
        conversation.partnerOrganization != null;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: hasUnread ? Colors.orange.shade50 : null,
          border: hasUnread
              ? Border(
                  left: BorderSide(color: Colors.orange.shade200, width: 3))
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar with unread dot
            Stack(
              clipBehavior: Clip.none,
              children: [
                _buildAvatar(),
                if (hasUnread)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 11,
                      height: 11,
                      decoration: BoxDecoration(
                        color: _primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row 1: name + status | timestamp + report
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Left: name + status badge tight together
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                displayName,
                                style: TextStyle(
                                  fontWeight: hasUnread
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 5),
                            if (conversation.isSignalement) ...[
                              _signalementBadge(context),
                              const SizedBox(width: 4),
                            ],
                            _buildStatusBadge(context),
                          ],
                        ),
                      ),
                      // Right: timestamp + report widget (far end)
                      if (conversation.lastMessageAt != null) ...[
                        const SizedBox(width: 6),
                        Text(
                          _formatTime(context, conversation.lastMessageAt!),
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey.shade500),
                        ),
                      ],
                      if (onReport != null || conversation.userHasReported) ...[
                        const SizedBox(width: 6),
                        _buildReportWidget(context),
                      ],
                    ],
                  ),
                  // Row 2: subject subtitle (when there's a name entity)
                  if (hasNameEntity) ...[
                    const SizedBox(height: 2),
                    Text(
                      conversation.subject,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        fontWeight:
                            hasUnread ? FontWeight.w500 : FontWeight.normal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  // Row 3: preview + unread counter
                  if (previewText != null) ...[
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            previewText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              color: hasUnread
                                  ? Colors.grey.shade700
                                  : Colors.grey.shade500,
                              fontWeight: hasUnread
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                              fontStyle: lastMsg?.isDeleted == true
                                  ? FontStyle.italic
                                  : FontStyle.normal,
                            ),
                          ),
                        ),
                        if (hasUnread) ...[
                          const SizedBox(width: 8),
                          _buildUnreadBadge(),
                        ],
                      ],
                    ),
                  ],
                  // Row 4: event chip
                  if (conversation.event != null) ...[
                    const SizedBox(height: 5),
                    _buildEventChip(),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _displayName(BuildContext context) {
    if (showLehibooAvatar) return context.l10n.messagesTabSupportLeHiboo;
    switch (conversation.conversationType) {
      case 'organization_organization':
        return conversation.partnerOrganization?.companyName ??
            conversation.subject;
      case 'vendor_admin':
        if (conversation.organization != null) {
          return conversation.organization!.companyName;
        }
        return context.l10n.messagesTabSupportLeHiboo;
      case 'participant_vendor':
      case 'user_support':
        if (conversation.participant != null) {
          return conversation.participant!.name;
        }
        return conversation.organization?.companyName ?? conversation.subject;
      default:
        return conversation.organization?.companyName ?? conversation.subject;
    }
  }

  Widget _buildAvatar() {
    if (showLehibooAvatar) return _lehibooAvatar();
    switch (conversation.conversationType) {
      case 'organization_organization':
        return _orgAvatar(conversation.partnerOrganization);
      case 'vendor_admin':
        if (conversation.organization != null) {
          return _orgAvatar(conversation.organization);
        }
        return _lehibooAvatar();
      case 'participant_vendor':
      case 'user_support':
        if (conversation.participant != null) {
          return _participantAvatar(conversation.participant!);
        }
        return _orgAvatar(conversation.organization);
      default:
        return _orgAvatar(conversation.organization);
    }
  }

  Widget _orgAvatar(ConversationOrganization? org) {
    final url = org?.logoUrl ?? org?.avatarUrl;
    if (url != null && url.isNotEmpty) {
      return CircleAvatar(
        radius: 24,
        backgroundColor: Colors.grey.shade100,
        backgroundImage: CachedNetworkImageProvider(url),
      );
    }
    final initial = org != null && org.companyName.isNotEmpty
        ? org.companyName[0].toUpperCase()
        : 'S';
    return CircleAvatar(
      radius: 24,
      backgroundColor: _primaryColor,
      child: Text(
        initial,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget _participantAvatar(ConversationParticipant participant) {
    final url = participant.avatarUrl;
    if (url != null && url.isNotEmpty) {
      return CircleAvatar(
        radius: 24,
        backgroundColor: Colors.grey.shade100,
        backgroundImage: CachedNetworkImageProvider(url),
      );
    }
    final initial =
        participant.name.isNotEmpty ? participant.name[0].toUpperCase() : '?';
    return CircleAvatar(
      radius: 24,
      backgroundColor: _primaryColor,
      child: Text(
        initial,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget _lehibooAvatar() {
    return CircleAvatar(
      radius: 24,
      backgroundColor: _primaryColor.withValues(alpha: 0.12),
      child: const Icon(Icons.support_agent, color: _primaryColor, size: 24),
    );
  }

  Widget _buildReportWidget(BuildContext context) {
    if (conversation.userHasReported) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.orange.shade100,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.flag, size: 10, color: Colors.orange.shade700),
            const SizedBox(width: 3),
            Text(
              context.l10n.messagesReportedLabel,
              style: TextStyle(
                  fontSize: 10,
                  color: Colors.orange.shade700,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    }
    return GestureDetector(
      onTap: onReport,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.flag_outlined, size: 10, color: Colors.grey.shade600),
            const SizedBox(width: 3),
            Text(
              context.l10n.messagesReportLabel,
              style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _signalementBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: Colors.red.shade100,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        context.l10n.messagesReportBadge,
        style: TextStyle(
            fontSize: 9,
            color: Colors.red.shade700,
            fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final isClosed = conversation.status == 'closed';
    final hasUnread = conversation.unreadCount > 0;

    if (isClosed) {
      return _statusPill(
        label: context.l10n.messagesStatusClosed,
        icon: Icons.lock_outline,
        bg: Colors.grey.shade100,
        fg: Colors.grey.shade600,
      );
    }
    if (hasUnread) {
      return _statusPill(
        label: context.l10n.messagesStatusPending,
        bg: Colors.orange.shade100,
        fg: Colors.orange.shade700,
      );
    }
    return _statusPill(
      label: context.l10n.messagesStatusOpen,
      bg: Colors.green.shade100,
      fg: Colors.green.shade700,
    );
  }

  Widget _statusPill({
    required String label,
    required Color bg,
    required Color fg,
    IconData? icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(4)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 10, color: fg),
            const SizedBox(width: 3),
          ],
          Text(label,
              style: TextStyle(
                  fontSize: 10, color: fg, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildUnreadBadge() {
    final count = conversation.unreadCount;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
          color: _primaryColor, borderRadius: BorderRadius.circular(10)),
      child: Text(
        count > 99 ? '99+' : '$count',
        style: const TextStyle(
            color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildEventChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: _primaryColor.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.calendar_today_outlined,
              size: 10, color: _primaryColor),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              conversation.event!.title,
              style: const TextStyle(
                  fontSize: 10,
                  color: _primaryColor,
                  fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String? _buildPreviewText(BuildContext context, Message? latest) {
    if (latest == null) return null;
    if (latest.isDeleted) return context.l10n.messagesDeletedPreview;
    return latest.content;
  }

  String _formatTime(BuildContext context, DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return context.l10n.messagesRelativeJustNow;
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) {
      return context.l10n.messagesRelativeDaysShort(diff.inDays);
    }
    return context.appDateFormat('dd/MM', enPattern: 'MM/dd').format(dt);
  }
}
