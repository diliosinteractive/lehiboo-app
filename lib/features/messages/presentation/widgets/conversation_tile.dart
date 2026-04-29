import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/entities/message.dart';

class ConversationTile extends StatelessWidget {
  final Conversation conversation;
  final VoidCallback onTap;

  const ConversationTile({
    super.key,
    required this.conversation,
    required this.onTap,
  });

  static const _primaryColor = Color(0xFFFF601F);

  @override
  Widget build(BuildContext context) {
    final org = conversation.organization;
    final lastMsg = conversation.latestMessage;
    final hasUnread = conversation.unreadCount > 0;
    final previewText = _buildPreviewText(lastMsg);
    final showAttachIcon = lastMsg != null &&
        lastMsg.content == null &&
        !lastMsg.isDeleted &&
        lastMsg.attachments.isNotEmpty;

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
                _buildAvatar(org),
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
                  // Row 1: org name + status badge + timestamp
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          org?.companyName ?? conversation.subject,
                          style: TextStyle(
                            fontWeight:
                                hasUnread ? FontWeight.w700 : FontWeight.w500,
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      _buildStatusBadge(),
                      if (conversation.lastMessageAt != null) ...[
                        const SizedBox(width: 6),
                        Text(
                          _formatTime(conversation.lastMessageAt!),
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey.shade500),
                        ),
                      ],
                    ],
                  ),
                  // Row 2: subject (vendor threads only, org is the name above)
                  if (org != null) ...[
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
                        if (showAttachIcon)
                          Padding(
                            padding: const EdgeInsets.only(right: 3),
                            child: Icon(Icons.attach_file,
                                size: 12, color: Colors.grey.shade500),
                          ),
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

  Widget _buildAvatar(ConversationOrganization? org) {
    final url = org?.logoUrl ?? org?.avatarUrl;
    if (url != null && url.isNotEmpty) {
      return CircleAvatar(
        radius: 24,
        backgroundColor: Colors.grey.shade100,
        backgroundImage: CachedNetworkImageProvider(url),
      );
    }
    final initials = org != null && org.companyName.isNotEmpty
        ? org.companyName[0].toUpperCase()
        : 'S';
    return CircleAvatar(
      radius: 24,
      backgroundColor: _primaryColor,
      child: Text(
        initials,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget _buildStatusBadge() {
    final isClosed = conversation.status == 'closed';
    final hasUnread = conversation.unreadCount > 0;

    if (isClosed) {
      return _statusPill(
        label: 'Fermé',
        icon: Icons.lock_outline,
        bg: Colors.grey.shade100,
        fg: Colors.grey.shade600,
      );
    }
    if (hasUnread) {
      return _statusPill(
        label: 'En attente',
        bg: Colors.orange.shade100,
        fg: Colors.orange.shade700,
      );
    }
    return _statusPill(
      label: 'Ouvert',
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
          const Icon(Icons.calendar_today_outlined, size: 10, color: _primaryColor),
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

  String? _buildPreviewText(Message? latest) {
    if (latest == null) return null;
    if (latest.isDeleted) return 'Message supprimé';
    if (latest.content != null) return latest.content;

    final attachments = latest.attachments;
    if (attachments.isEmpty) return null;

    final imageCount = attachments.where((a) => a.isImage).length;
    final fileCount = attachments.length - imageCount;

    if (fileCount == 0) {
      return imageCount == 1 ? 'Une image envoyée' : '$imageCount images envoyées';
    }
    if (imageCount == 0) {
      return fileCount == 1 ? 'Un fichier envoyé' : '$fileCount fichiers envoyés';
    }
    return '${attachments.length} pièces jointes';
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return "À l'instant";
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}j';
    return DateFormat('dd/MM').format(dt);
  }
}
