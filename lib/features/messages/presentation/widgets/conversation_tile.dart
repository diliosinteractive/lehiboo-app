import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/conversation.dart';

class ConversationTile extends StatelessWidget {
  final Conversation conversation;
  final VoidCallback onTap;

  const ConversationTile({
    super.key,
    required this.conversation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final org = conversation.organization;
    final lastMsg = conversation.latestMessage;
    final colorScheme = Theme.of(context).colorScheme;
    const primaryColor = Color(0xFFFF601F);

    return ListTile(
      onTap: onTap,
      leading: _buildAvatar(org),
      title: Row(
        children: [
          Expanded(
            child: Text(
              org?.companyName ?? conversation.subject,
              style: const TextStyle(fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (conversation.unreadCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${conversation.unreadCount}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (lastMsg != null)
            Text(
              lastMsg.isDeleted
                  ? 'Message supprimé'
                  : (lastMsg.content ?? ''),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: conversation.unreadCount > 0
                    ? colorScheme.onSurface
                    : colorScheme.onSurface.withValues(alpha: 0.6),
                fontWeight: conversation.unreadCount > 0
                    ? FontWeight.w500
                    : FontWeight.normal,
              ),
            ),
          const SizedBox(height: 4),
          _buildChips(context),
        ],
      ),
      trailing: conversation.lastMessageAt != null
          ? Text(
              _formatTime(conversation.lastMessageAt!),
              style: TextStyle(
                  fontSize: 11, color: colorScheme.onSurface.withValues(alpha: 0.5)),
            )
          : null,
    );
  }

  Widget _buildAvatar(ConversationOrganization? org) {
    final url = org?.logoUrl ?? org?.avatarUrl;
    if (url != null && url.isNotEmpty) {
      return CircleAvatar(
        radius: 24,
        backgroundImage: CachedNetworkImageProvider(url),
      );
    }
    final initials = org != null
        ? org.companyName.isNotEmpty
            ? org.companyName[0].toUpperCase()
            : '?'
        : 'S'; // S for Support
    return CircleAvatar(
      radius: 24,
      backgroundColor: const Color(0xFFFF601F),
      child: Text(initials,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildChips(BuildContext context) {
    final chips = <Widget>[];
    if (conversation.status == 'closed') {
      chips.add(_chip('Fermé', Colors.grey));
    }
    if (conversation.isSignalement) {
      chips.add(_chip('Signalement', Colors.red));
    }
    if (conversation.event != null) {
      chips.add(_chip(conversation.event!.title, const Color(0xFFFF601F),
          isOutlined: true));
    }
    if (chips.isEmpty) return const SizedBox.shrink();
    return Wrap(spacing: 4, children: chips);
  }

  Widget _chip(String label, Color color, {bool isOutlined = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isOutlined ? Colors.transparent : color.withValues(alpha: 0.15),
        border: isOutlined ? Border.all(color: color, width: 1) : null,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 10, color: color, fontWeight: FontWeight.w500)),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}j';
    return DateFormat('dd/MM').format(dt);
  }
}
