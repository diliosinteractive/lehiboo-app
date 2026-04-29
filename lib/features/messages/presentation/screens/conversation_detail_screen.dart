import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/message.dart';
import '../providers/conversation_detail_provider.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_composer.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/auth/presentation/widgets/guest_restriction_dialog.dart';

class ConversationDetailScreen extends ConsumerStatefulWidget {
  final String conversationUuid;
  final bool isSupport;

  const ConversationDetailScreen({
    super.key,
    required this.conversationUuid,
    this.isSupport = false,
  });

  @override
  ConsumerState<ConversationDetailScreen> createState() =>
      _ConversationDetailScreenState();
}

class _ConversationDetailScreenState
    extends ConsumerState<ConversationDetailScreen> {
  static const _primaryColor = Color(0xFFFF601F);

  ProviderListenable<ConversationDetailState> get _provider =>
      conversationDetailProvider(
          (uuid: widget.conversationUuid, isSupport: widget.isSupport));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = ref.read(authProvider);
      if (authState.status == AuthStatus.unauthenticated) {
        GuestRestrictionDialog.show(context,
            featureName: 'voir cette conversation');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(_provider);

    final detailNotifier = ref.read(
        conversationDetailProvider((
          uuid: widget.conversationUuid,
          isSupport: widget.isSupport,
        )).notifier);

    ref.listen(_provider, (prev, next) {
      if (next.sendError != null && prev?.sendError != next.sendError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.sendError!),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: detailNotifier.clearSendError,
            ),
          ),
        );
        detailNotifier.clearSendError();
      }
    });

    return Scaffold(
      body: state.conversation.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 40),
              const SizedBox(height: 8),
              Text('Erreur : $e', style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref
                    .read(conversationDetailProvider((
                      uuid: widget.conversationUuid,
                      isSupport: widget.isSupport,
                    )).notifier)
                    .load(),
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
        data: (conversation) {
          final isClosed = conversation.status == 'closed';
          final notifier = ref.read(conversationDetailProvider((
            uuid: widget.conversationUuid,
            isSupport: widget.isSupport,
          )).notifier);

          final titleText = widget.isSupport
              ? conversation.subject
              : (conversation.organization?.companyName ??
                  conversation.subject);

          return Column(
            children: [
              AppBar(
                leading: BackButton(
                  onPressed: () => context.canPop()
                      ? context.pop()
                      : context.go('/messages'),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(titleText,
                        style: const TextStyle(fontSize: 16),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    if (!widget.isSupport)
                      Text(
                        conversation.subject,
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.normal),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
                actions: [
                  // Clickable event chip
                  if (conversation.event != null)
                    GestureDetector(
                      onTap: () =>
                          context.push('/event/${conversation.event!.uuid}'),
                      child: Container(
                        margin: const EdgeInsets.only(right: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.calendar_today_outlined,
                                size: 12, color: _primaryColor),
                            const SizedBox(width: 4),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 100),
                              child: Text(
                                conversation.event!.title,
                                style: const TextStyle(
                                    fontSize: 11,
                                    color: _primaryColor,
                                    fontWeight: FontWeight.w600),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (!widget.isSupport)
                    PopupMenuButton<String>(
                      onSelected: (value) => _handleMenuAction(
                          context, value, notifier, conversation.status),
                      itemBuilder: (ctx) => [
                        if (conversation.status == 'open')
                          const PopupMenuItem(
                            value: 'close',
                            child: Row(
                              children: [
                                Icon(Icons.lock_outline, size: 18),
                                SizedBox(width: 8),
                                Text('Fermer la conversation'),
                              ],
                            ),
                          ),
                        if (!conversation.userHasReported)
                          const PopupMenuItem(
                            value: 'report',
                            child: Row(
                              children: [
                                Icon(Icons.flag_outlined,
                                    size: 18, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Signaler',
                                    style: TextStyle(color: Colors.red)),
                              ],
                            ),
                          ),
                        if (conversation.userHasReported)
                          PopupMenuItem<String>(
                            enabled: false,
                            child: Row(
                              children: [
                                Icon(Icons.flag,
                                    size: 18, color: Colors.orange.shade400),
                                const SizedBox(width: 8),
                                Text('Signalé',
                                    style: TextStyle(
                                        color: Colors.orange.shade400,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                      ],
                    ),
                ],
              ),
              if (isClosed)
                MaterialBanner(
                  content: const Text('Cette conversation est fermée.'),
                  leading: const Icon(Icons.lock_outline),
                  backgroundColor: Colors.grey.shade100,
                  actions: [
                    TextButton(
                      onPressed: () => ScaffoldMessenger.of(context)
                          .hideCurrentMaterialBanner(),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              Expanded(
                child: _MessagesList(
                  messages: conversation.messages,
                  notifier: notifier,
                ),
              ),
              MessageComposer(
                conversationUuid: widget.conversationUuid,
                disabled: isClosed,
                isSupport: widget.isSupport,
                onSend: (content, attachments) => notifier.sendMessage(
                  content: content,
                  attachments: attachments,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _handleMenuAction(
    BuildContext context,
    String action,
    ConversationDetailNotifier notifier,
    String status,
  ) async {
    if (action == 'close') {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Fermer la conversation'),
          content: const Text(
              'Voulez-vous fermer cette conversation ? Vous ne pourrez plus envoyer de messages.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Fermer',
                  style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
      if (confirmed == true && context.mounted) {
        try {
          await notifier.closeConversation();
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Erreur : $e'),
                  backgroundColor: Colors.red),
            );
          }
        }
      }
    } else if (action == 'report') {
      _showReportDialog(context, notifier);
    }
  }

  void _showReportDialog(
      BuildContext context, ConversationDetailNotifier notifier) {
    String? selectedReason;
    final commentController = TextEditingController();
    bool isSubmitting = false;
    bool submitted = false;
    String? commentError;
    String? supportUuid;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          if (submitted) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.flag, size: 48, color: Colors.orange.shade400),
                  const SizedBox(height: 12),
                  const Text(
                    'Signalement transmis',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Votre signalement a bien été transmis à l\'équipe LeHiboo.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    if (supportUuid != null && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                              'Un ticket support a été créé pour le suivi.'),
                          action: SnackBarAction(
                            label: 'Voir',
                            onPressed: () => context.push(
                                '/messages/support/$supportUuid'),
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text('OK',
                      style: TextStyle(color: _primaryColor)),
                ),
              ],
            );
          }

          return AlertDialog(
            title: const Text('Signaler la conversation'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: selectedReason,
                  decoration: const InputDecoration(
                    labelText: 'Raison *',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  items: const [
                    DropdownMenuItem(
                        value: 'inappropriate',
                        child: Text('Contenu inapproprié')),
                    DropdownMenuItem(
                        value: 'harassment', child: Text('Harcèlement')),
                    DropdownMenuItem(value: 'spam', child: Text('Spam')),
                    DropdownMenuItem(value: 'other', child: Text('Autre')),
                  ],
                  onChanged: isSubmitting
                      ? null
                      : (v) => setDialogState(() => selectedReason = v),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: commentController,
                  maxLines: 4,
                  maxLength: 2000,
                  enabled: !isSubmitting,
                  decoration: InputDecoration(
                    labelText: 'Commentaire * (min. 10 caractères)',
                    border: const OutlineInputBorder(),
                    isDense: true,
                    errorText: commentError,
                  ),
                  onChanged: (_) {
                    if (commentError != null) {
                      setDialogState(() => commentError = null);
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: isSubmitting ? null : () => Navigator.pop(ctx),
                child: const Text('Annuler'),
              ),
              TextButton(
                onPressed: (selectedReason == null || isSubmitting)
                    ? null
                    : () async {
                        final comment = commentController.text.trim();
                        if (comment.length < 10) {
                          setDialogState(() => commentError =
                              'Le commentaire doit contenir au moins 10 caractères.');
                          return;
                        }
                        setDialogState(() => isSubmitting = true);
                        try {
                          final result = await notifier.reportConversation(
                              selectedReason!, comment);
                          supportUuid = result.supportConversationUuid;
                          setDialogState(() {
                            isSubmitting = false;
                            submitted = true;
                          });
                        } catch (e) {
                          setDialogState(() => isSubmitting = false);
                          if (ctx.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Erreur : $e'),
                                  backgroundColor: Colors.red),
                            );
                          }
                        }
                      },
                child: isSubmitting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Signaler',
                        style: TextStyle(color: Colors.red)),
              ),
            ],
          );
        },
      ),
    ).then((_) => commentController.dispose());
  }
}

class _MessagesList extends StatelessWidget {
  final List<Message> messages;
  final ConversationDetailNotifier notifier;

  const _MessagesList({required this.messages, required this.notifier});

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return const Center(
        child: Text('Aucun message. Soyez le premier à écrire !',
            style: TextStyle(color: Colors.grey)),
      );
    }

    final lastOwnIndex = () {
      for (int i = messages.length - 1; i >= 0; i--) {
        if (messages[i].isMine && !messages[i].isDeleted) return i;
      }
      return -1;
    }();

    final items = _buildItems(messages);

    return ListView.builder(
      reverse: true,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        if (item is _DateSeparator) {
          return _buildDateChip(item.date);
        }
        final msg = (item as _MessageItem).message;
        final originalIndex = messages.indexOf(msg);
        return MessageBubble(
          key: ValueKey(msg.uuid),
          message: msg,
          isLastOwn: originalIndex == lastOwnIndex,
          onEdit: (uuid, content) => notifier.editMessage(uuid, content),
          onDelete: (uuid) => notifier.deleteMessage(uuid),
        );
      },
    );
  }

  List<Object> _buildItems(List<Message> msgs) {
    final reversed = msgs.reversed.toList();
    final items = <Object>[];

    int i = 0;
    while (i < reversed.length) {
      final msgDate = DateTime(
        reversed[i].createdAt.year,
        reversed[i].createdAt.month,
        reversed[i].createdAt.day,
      );
      // Add all messages for this date group first (they appear at lower indices = bottom)
      while (i < reversed.length) {
        final d = DateTime(
          reversed[i].createdAt.year,
          reversed[i].createdAt.month,
          reversed[i].createdAt.day,
        );
        if (d != msgDate) break;
        items.add(_MessageItem(reversed[i]));
        i++;
      }
      // Separator added after the group — with reverse:true it renders above the group
      items.add(_DateSeparator(msgDate));
    }
    return items;
  }

  Widget _buildDateChip(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    String label;
    if (date == today) {
      label = "Aujourd'hui";
    } else if (date == yesterday) {
      label = 'Hier';
    } else {
      label = DateFormat('d MMMM yyyy', 'fr_FR').format(date);
    }

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
      ),
    );
  }
}

class _DateSeparator {
  final DateTime date;
  const _DateSeparator(this.date);
}

class _MessageItem {
  final Message message;
  const _MessageItem(this.message);
}
