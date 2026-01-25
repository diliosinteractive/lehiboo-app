import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/themes/colors.dart';
import '../../data/models/conversation_dto.dart';
import '../providers/conversation_list_provider.dart';

/// Screen showing list of past conversations with Petit Boo
class ConversationListScreen extends ConsumerWidget {
  const ConversationListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(conversationListProvider);

    return Scaffold(
      backgroundColor: HbColors.orangePastel,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: HbColors.textPrimary,
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Historique des conversations',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: HbColors.textPrimary,
          ),
        ),
      ),
      body: _buildBody(context, ref, state),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, ConversationListState state) {
    if (state.isLoading && state.conversations.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.conversations.isEmpty) {
      return _buildErrorState(context, ref, state.error!);
    }

    if (state.conversations.isEmpty) {
      return _buildEmptyState(context);
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(conversationListProvider.notifier).refresh(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.conversations.length + (state.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == state.conversations.length) {
            // Load more indicator
            if (state.isLoadingMore) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            // Load more trigger
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref.read(conversationListProvider.notifier).loadMore();
            });
            return const SizedBox.shrink();
          }

          final conversation = state.conversations[index];
          return _ConversationCard(
            conversation: conversation,
            onTap: () => context.push('/petit-boo?session=${conversation.uuid}'),
            onDelete: () => _confirmDelete(context, ref, conversation),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: HbColors.error.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: HbColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ref.read(conversationListProvider.notifier).loadConversations();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: HbColors.brandPrimary,
              ),
              child: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: HbColors.brandPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Center(
                child: Text('🦉', style: TextStyle(fontSize: 40)),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Aucune conversation',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: HbColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Démarrez une conversation avec Petit Boo pour obtenir de l\'aide sur les événements et réservations.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: HbColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.go('/petit-boo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: HbColors.brandPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              icon: const Icon(Icons.chat_bubble_outline),
              label: const Text('Démarrer'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    ConversationDto conversation,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer la conversation'),
        content: const Text(
          'Êtes-vous sûr de vouloir supprimer cette conversation ? Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: HbColors.error),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final success = await ref
          .read(conversationListProvider.notifier)
          .deleteConversation(conversation.uuid);

      if (context.mounted && success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Conversation supprimée')),
        );
      }
    }
  }
}

class _ConversationCard extends StatelessWidget {
  final ConversationDto conversation;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ConversationCard({
    required this.conversation,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Dismissible(
        key: Key(conversation.uuid),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => onDelete(),
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: HbColors.error,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Owl icon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: HbColors.brandPrimary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Center(
                      child: Text('🦉', style: TextStyle(fontSize: 24)),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          conversation.title ?? 'Conversation',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: HbColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        if (conversation.lastMessage != null)
                          Text(
                            conversation.lastMessage!,
                            style: TextStyle(
                              fontSize: 13,
                              color: HbColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              _formatDate(conversation.createdAt),
                              style: TextStyle(
                                fontSize: 12,
                                color: HbColors.textSecondary,
                              ),
                            ),
                            if (conversation.messageCount > 0) ...[
                              const Text(' • '),
                              Text(
                                '${conversation.messageCount} message${conversation.messageCount > 1 ? 's' : ''}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: HbColors.textSecondary,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Arrow
                  Icon(
                    Icons.chevron_right,
                    color: HbColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inDays == 0) {
        return 'Aujourd\'hui';
      } else if (diff.inDays == 1) {
        return 'Hier';
      } else if (diff.inDays < 7) {
        return 'Il y a ${diff.inDays} jours';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return isoDate;
    }
  }
}
