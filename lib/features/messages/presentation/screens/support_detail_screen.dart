import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/api_response_handler.dart';
import '../../domain/entities/conversation_route.dart';
import '../../domain/entities/message.dart';
import '../providers/conversation_detail_provider.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_composer.dart';
import '../widgets/new_conversation_form.dart';

class SupportDetailScreen extends ConsumerStatefulWidget {
  final String? conversationUuid;
  final bool isNew;

  const SupportDetailScreen({
    super.key,
    this.conversationUuid,
    this.isNew = false,
  });

  @override
  ConsumerState<SupportDetailScreen> createState() =>
      _SupportDetailScreenState();
}

class _SupportDetailScreenState extends ConsumerState<SupportDetailScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.isNew) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final created = await NewConversationForm.show(
          context,
          conversationContext: SupportConversationContext(),
        );
        // Only navigate back if the user cancelled (form already navigates on success)
        if (mounted && created != true) {
          context.canPop() ? context.pop() : context.go('/messages');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isNew && widget.conversationUuid != null) {
      return _SupportThreadView(conversationUuid: widget.conversationUuid!);
    }
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

class _SupportThreadView extends ConsumerStatefulWidget {
  final String conversationUuid;

  const _SupportThreadView({required this.conversationUuid});

  @override
  ConsumerState<_SupportThreadView> createState() => _SupportThreadViewState();
}

class _SupportThreadViewState extends ConsumerState<_SupportThreadView> {
  ({String uuid, ConversationRoute route}) get _pk => (
        uuid: widget.conversationUuid,
        route: ConversationRoute.participantSupport,
      );

  Future<void> _handleClose(ConversationDetailNotifier notifier) async {
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
    if (confirmed == true && mounted) {
      try {
        await notifier.closeConversation();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur : ${ApiResponseHandler.extractError(e)}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(conversationDetailProvider(_pk));
    final notifier = ref.read(conversationDetailProvider(_pk).notifier);

    ref.listen(conversationDetailProvider(_pk), (prev, next) {
      if (next.sendError != null && prev?.sendError != next.sendError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.sendError!),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: notifier.clearSendError,
            ),
          ),
        );
        notifier.clearSendError();
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
              Text('Erreur : ${ApiResponseHandler.extractError(e)}',
                  style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: notifier.load,
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
        data: (conversation) {
          final isClosed = conversation.status == 'closed';
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
                    Text(
                      conversation.subject,
                      style: const TextStyle(fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Support LeHiboo',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                actions: [
                  if (!isClosed)
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'close') _handleClose(notifier);
                      },
                      itemBuilder: (_) => [
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
                onSend: (content) => notifier.sendMessage(
                  content: content,
                ),
              ),
            ],
          );
        },
      ),
    );
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
