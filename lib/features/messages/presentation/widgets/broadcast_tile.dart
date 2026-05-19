import 'package:flutter/material.dart';
import 'package:lehiboo/core/l10n/l10n.dart';
import '../../domain/entities/broadcast.dart';

class BroadcastTile extends StatelessWidget {
  final Broadcast broadcast;
  final VoidCallback onTap;

  const BroadcastTile({
    super.key,
    required this.broadcast,
    required this.onTap,
  });

  static const _primaryColor = Color(0xFFFF601F);

  String _formatDate(BuildContext context, DateTime? dt) {
    if (dt == null) return '';
    return context
        .appDateFormat('d MMM yyyy', enPattern: 'MMM d, yyyy')
        .format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final isSent = broadcast.isSent;
    final sentDate = broadcast.sentAt ?? broadcast.createdAt;
    final formattedDate = _formatDate(context, sentDate);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _primaryColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.campaign_outlined,
                color: _primaryColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          broadcast.subject,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (!isSent)
                    Row(
                      children: [
                        SizedBox(
                          width: 10,
                          height: 10,
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                            color: Colors.orange.shade600,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          context.l10n.messagesBroadcastSending,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange.shade700,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        _StatBadge(
                          icon: Icons.people_outline,
                          count: broadcast.recipientsCount,
                          color: Colors.blue.shade700,
                        ),
                        const SizedBox(width: 8),
                        _StatBadge(
                          icon: Icons.visibility_outlined,
                          count: broadcast.readCount,
                          color: Colors.green.shade700,
                        ),
                        const SizedBox(width: 8),
                        _StatBadge(
                          icon: Icons.chat_bubble_outline,
                          count: broadcast.conversationsCreated,
                          color: Colors.purple.shade700,
                        ),
                      ],
                    ),
                  if (broadcast.events.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    _EventChips(events: broadcast.events),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 18),
          ],
        ),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final IconData icon;
  final int count;
  final Color color;

  const _StatBadge({
    required this.icon,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 3),
        Text(
          '$count',
          style: TextStyle(
              fontSize: 11, color: color, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _EventChips extends StatelessWidget {
  final List<BroadcastEvent> events;

  const _EventChips({required this.events});

  @override
  Widget build(BuildContext context) {
    final shown = events.take(2).toList();
    final extra = events.length - shown.length;

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        ...shown.map(
          (e) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              e.title,
              style: TextStyle(fontSize: 10, color: Colors.grey.shade700),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        if (extra > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '+$extra',
              style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
            ),
          ),
      ],
    );
  }
}
