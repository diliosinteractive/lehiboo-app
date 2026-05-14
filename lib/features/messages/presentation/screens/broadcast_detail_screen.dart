import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lehiboo/core/l10n/l10n.dart';
import '../../domain/entities/broadcast.dart';
import '../../data/repositories/messages_repository_impl.dart';

final _broadcastDetailProvider =
    FutureProvider.family<Broadcast, String>((ref, uuid) async {
  return ref.read(messagesRepositoryProvider).getBroadcast(uuid);
});

class BroadcastDetailScreen extends ConsumerStatefulWidget {
  final String broadcastUuid;

  const BroadcastDetailScreen({super.key, required this.broadcastUuid});

  @override
  ConsumerState<BroadcastDetailScreen> createState() =>
      _BroadcastDetailScreenState();
}

class _BroadcastDetailScreenState extends ConsumerState<BroadcastDetailScreen> {
  Timer? _pollTimer;

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  void _startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted) return;
      ref.invalidate(_broadcastDetailProvider(widget.broadcastUuid));
    });
  }

  void _stopPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(_broadcastDetailProvider(widget.broadcastUuid));

    // Manage polling based on isSent state
    async.whenData((broadcast) {
      if (!broadcast.isSent && _pollTimer == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _startPolling());
      } else if (broadcast.isSent && _pollTimer != null) {
        _stopPolling();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diffusion'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.invalidate(_broadcastDetailProvider(widget.broadcastUuid)),
          ),
        ],
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 40),
              const SizedBox(height: 8),
              Text('Erreur : $e',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref
                    .invalidate(_broadcastDetailProvider(widget.broadcastUuid)),
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
        data: (broadcast) => _BroadcastDetail(broadcast: broadcast),
      ),
    );
  }
}

class _BroadcastDetail extends StatelessWidget {
  final Broadcast broadcast;

  const _BroadcastDetail({required this.broadcast});

  static const _primaryColor = Color(0xFFFF601F);

  String _formatDate(BuildContext context, DateTime? dt) {
    if (dt == null) return '–';
    return context
        .appDateFormat(
          "d MMMM yyyy 'à' HH:mm",
          enPattern: 'MMMM d, yyyy, HH:mm',
        )
        .format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status banner
          if (!broadcast.isSent)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.orange.shade700,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'L\'envoi est en cours de traitement par le serveur.',
                    style:
                        TextStyle(color: Colors.orange.shade800, fontSize: 13),
                  ),
                ],
              ),
            ),

          // Header card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _primaryColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.campaign_outlined,
                          color: _primaryColor, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        broadcast.subject,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: broadcast.isSent
                            ? Colors.green.shade50
                            : Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: broadcast.isSent
                              ? Colors.green.shade300
                              : Colors.orange.shade300,
                        ),
                      ),
                      child: Text(
                        broadcast.isSent ? 'Envoyée' : 'En cours',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: broadcast.isSent
                              ? Colors.green.shade700
                              : Colors.orange.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  broadcast.isSent
                      ? context.l10n.broadcastSentOn(
                          _formatDate(context, broadcast.sentAt))
                      : context.l10n.broadcastCreatedOn(
                          _formatDate(context, broadcast.createdAt),
                        ),
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Stats row
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.people_outline,
                  label: 'Destinataires',
                  value: '${broadcast.recipientsCount}',
                  color: Colors.blue.shade700,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StatCard(
                  icon: Icons.visibility_outlined,
                  label: 'Lus',
                  value: '${broadcast.readCount}',
                  color: Colors.green.shade700,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StatCard(
                  icon: Icons.chat_bubble_outline,
                  label: 'Conversations',
                  value: '${broadcast.conversationsCreated}',
                  color: Colors.purple.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Events targeted
          if (broadcast.events.isNotEmpty) ...[
            const Text(
              'Événements ciblés',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: broadcast.events
                  .map((e) => Chip(
                        label:
                            Text(e.title, style: const TextStyle(fontSize: 12)),
                        backgroundColor: Colors.grey.shade100,
                        side: BorderSide(color: Colors.grey.shade300),
                        padding: EdgeInsets.zero,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
          ],

          // Message body
          const Text(
            'Message',
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Text(
              broadcast.body,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
