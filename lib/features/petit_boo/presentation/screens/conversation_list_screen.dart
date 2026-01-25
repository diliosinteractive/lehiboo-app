import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/themes/petit_boo_theme.dart';
import '../../data/models/conversation_dto.dart';
import '../providers/conversation_list_provider.dart';

/// Screen showing list of past conversations with Petit Boo
class ConversationListScreen extends ConsumerWidget {
  const ConversationListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(conversationListProvider);

    return Scaffold(
      backgroundColor: PetitBooTheme.background,
      appBar: _buildAppBar(context),
      body: _buildBody(context, ref, state),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: PetitBooTheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: PetitBooTheme.iconMd,
        ),
        color: PetitBooTheme.textPrimary,
        onPressed: () => context.pop(),
      ),
      title: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: PetitBooTheme.primaryLight,
            ),
            child: ClipOval(
              child: Image.asset(
                PetitBooTheme.owlLogoPath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.history_rounded,
                  color: PetitBooTheme.primary,
                  size: 18,
                ),
              ),
            ),
          ),
          SizedBox(width: PetitBooTheme.spacing12),
          Text(
            'Historique',
            style: PetitBooTheme.headingSm,
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, ConversationListState state) {
    if (state.isLoading && state.conversations.isEmpty) {
      return Center(
        child: CircularProgressIndicator(
          color: PetitBooTheme.primary,
          strokeWidth: 2,
        ),
      );
    }

    if (state.error != null && state.conversations.isEmpty) {
      return _buildErrorState(context, ref, state.error!);
    }

    if (state.conversations.isEmpty) {
      return _buildEmptyState(context);
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(conversationListProvider.notifier).refresh(),
      color: PetitBooTheme.primary,
      child: ListView.builder(
        padding: EdgeInsets.all(PetitBooTheme.spacing16),
        itemCount: state.conversations.length + (state.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == state.conversations.length) {
            if (state.isLoadingMore) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(PetitBooTheme.spacing16),
                  child: CircularProgressIndicator(
                    color: PetitBooTheme.primary,
                    strokeWidth: 2,
                  ),
                ),
              );
            }
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
        padding: EdgeInsets.all(PetitBooTheme.spacing32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: PetitBooTheme.errorLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.cloud_off_rounded,
                size: 40,
                color: PetitBooTheme.error,
              ),
            ),
            SizedBox(height: PetitBooTheme.spacing24),
            Text(
              'Oups !',
              style: PetitBooTheme.headingMd,
            ),
            SizedBox(height: PetitBooTheme.spacing8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: PetitBooTheme.bodyMd.copyWith(
                color: PetitBooTheme.textSecondary,
              ),
            ),
            SizedBox(height: PetitBooTheme.spacing24),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(conversationListProvider.notifier).loadConversations();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: PetitBooTheme.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: PetitBooTheme.spacing24,
                  vertical: PetitBooTheme.spacing12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              icon: const Icon(Icons.refresh_rounded, size: 20),
              label: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(PetitBooTheme.spacing32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: PetitBooTheme.primaryLight,
                shape: BoxShape.circle,
                boxShadow: PetitBooTheme.shadowMd,
              ),
              child: ClipOval(
                child: Image.asset(
                  PetitBooTheme.owlLogoPath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.chat_bubble_outline_rounded,
                    color: PetitBooTheme.primary,
                    size: 48,
                  ),
                ),
              ),
            ),
            SizedBox(height: PetitBooTheme.spacing24),
            Text(
              'Aucune conversation',
              style: PetitBooTheme.headingMd,
            ),
            SizedBox(height: PetitBooTheme.spacing8),
            Text(
              'Démarrez une conversation avec Petit Boo\npour obtenir de l\'aide personnalisée',
              textAlign: TextAlign.center,
              style: PetitBooTheme.bodyMd.copyWith(
                color: PetitBooTheme.textSecondary,
                height: 1.4,
              ),
            ),
            SizedBox(height: PetitBooTheme.spacing32),
            ElevatedButton.icon(
              onPressed: () => context.go('/petit-boo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: PetitBooTheme.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: PetitBooTheme.spacing24,
                  vertical: PetitBooTheme.spacing14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                elevation: 2,
                shadowColor: PetitBooTheme.primary.withValues(alpha: 0.3),
              ),
              icon: const Icon(Icons.chat_rounded, size: 20),
              label: const Text(
                'Nouvelle conversation',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
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
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: PetitBooTheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.all(PetitBooTheme.spacing24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: PetitBooTheme.grey300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: PetitBooTheme.spacing24),
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: PetitBooTheme.errorLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.delete_outline_rounded,
                color: PetitBooTheme.error,
                size: 28,
              ),
            ),
            SizedBox(height: PetitBooTheme.spacing16),
            Text(
              'Supprimer cette conversation ?',
              style: PetitBooTheme.headingSm,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: PetitBooTheme.spacing8),
            Text(
              'Cette action est irréversible.',
              style: PetitBooTheme.bodySm.copyWith(
                color: PetitBooTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: PetitBooTheme.spacing24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: PetitBooTheme.textPrimary,
                      padding: EdgeInsets.symmetric(vertical: PetitBooTheme.spacing14),
                      side: BorderSide(color: PetitBooTheme.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Annuler'),
                  ),
                ),
                SizedBox(width: PetitBooTheme.spacing12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PetitBooTheme.error,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: PetitBooTheme.spacing14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Supprimer'),
                  ),
                ),
              ],
            ),
            SizedBox(height: PetitBooTheme.spacing8),
          ],
        ),
      ),
    );

    if (confirmed == true && context.mounted) {
      final success = await ref
          .read(conversationListProvider.notifier)
          .deleteConversation(conversation.uuid);

      if (context.mounted && success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Conversation supprimée'),
            backgroundColor: PetitBooTheme.grey700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
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
      padding: EdgeInsets.only(bottom: PetitBooTheme.spacing12),
      child: Dismissible(
        key: Key(conversation.uuid),
        direction: DismissDirection.endToStart,
        confirmDismiss: (_) async {
          onDelete();
          return false;
        },
        background: Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: PetitBooTheme.spacing20),
          decoration: BoxDecoration(
            color: PetitBooTheme.error,
            borderRadius: PetitBooTheme.borderRadiusXl,
          ),
          child: const Icon(Icons.delete_rounded, color: Colors.white),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: PetitBooTheme.surface,
            borderRadius: PetitBooTheme.borderRadiusXl,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: PetitBooTheme.borderRadiusXl,
              child: Padding(
                padding: EdgeInsets.all(PetitBooTheme.spacing16),
                child: Row(
                  children: [
                    // Avatar
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: PetitBooTheme.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          PetitBooTheme.owlLogoPath,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.chat_bubble_rounded,
                            color: PetitBooTheme.primary,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: PetitBooTheme.spacing14),

                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            conversation.title ?? 'Conversation',
                            style: PetitBooTheme.bodyMd.copyWith(
                              fontWeight: FontWeight.w600,
                              color: PetitBooTheme.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (conversation.lastMessage != null) ...[
                            SizedBox(height: PetitBooTheme.spacing4),
                            Text(
                              conversation.lastMessage!,
                              style: PetitBooTheme.bodySm.copyWith(
                                color: PetitBooTheme.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                          SizedBox(height: PetitBooTheme.spacing6),
                          Row(
                            children: [
                              Icon(
                                Icons.schedule_rounded,
                                size: 12,
                                color: PetitBooTheme.textTertiary,
                              ),
                              SizedBox(width: PetitBooTheme.spacing4),
                              Text(
                                _formatDate(conversation.createdAt),
                                style: PetitBooTheme.caption.copyWith(
                                  color: PetitBooTheme.textTertiary,
                                ),
                              ),
                              if (conversation.messageCount > 0) ...[
                                SizedBox(width: PetitBooTheme.spacing8),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: PetitBooTheme.spacing8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: PetitBooTheme.primaryLight,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Text(
                                    '${conversation.messageCount} msg',
                                    style: PetitBooTheme.caption.copyWith(
                                      color: PetitBooTheme.primary,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                    ),
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
                      Icons.chevron_right_rounded,
                      color: PetitBooTheme.grey400,
                      size: 24,
                    ),
                  ],
                ),
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
        // Show time for today
        return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
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
