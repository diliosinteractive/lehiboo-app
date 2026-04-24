import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../data/repositories/messages_repository_impl.dart';
import '../../domain/entities/message.dart';
import '../providers/conversation_detail_provider.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_composer.dart';

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
  static const _primaryColor = Color(0xFFFF601F);

  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  String? _errorMessage;

  static const _subjectOptions = [
    'Problème de réservation',
    'Question sur un événement',
    'Problème de paiement',
    'Demande de remboursement',
    'Problème de compte',
    'Signalement d\'un contenu',
    'Autre',
  ];

  String? _selectedSubjectOption;

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _onSubjectOptionSelected(String? option) {
    setState(() {
      _selectedSubjectOption = option;
      if (option != null && option != 'Autre') {
        _subjectController.text = option;
      } else if (option == 'Autre') {
        _subjectController.clear();
      }
    });
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final repo = ref.read(messagesRepositoryProvider);
      final conversation = await repo.createSupportConversation(
        subject: _subjectController.text.trim(),
        message: _messageController.text.trim(),
      );
      if (!mounted) return;
      context.go('/messages/support/${conversation.uuid}');
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isNew && widget.conversationUuid != null) {
      return _SupportThreadView(conversationUuid: widget.conversationUuid!);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacter le support'),
        leading: BackButton(
          onPressed: () =>
              context.canPop() ? context.pop() : context.go('/messages'),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _primaryColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: _primaryColor.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: _primaryColor,
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: const Icon(Icons.support_agent,
                                color: Colors.white, size: 22),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Support Le Hiboo',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Notre équipe vous répond généralement sous 24h.',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Subject quick-pick chips
                    const Text(
                      'Quel est le sujet de votre demande ?',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: _subjectOptions.map((option) {
                        final isSelected = _selectedSubjectOption == option;
                        return ChoiceChip(
                          label: Text(option,
                              style: TextStyle(
                                fontSize: 12,
                                color: isSelected
                                    ? _primaryColor
                                    : Colors.black87,
                              )),
                          selected: isSelected,
                          onSelected: (_) =>
                              _onSubjectOptionSelected(option),
                          selectedColor:
                              _primaryColor.withValues(alpha: 0.15),
                          checkmarkColor: _primaryColor,
                          side: BorderSide(
                            color: isSelected
                                ? _primaryColor
                                : Colors.grey.shade300,
                          ),
                          backgroundColor: Colors.white,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // Subject text field
                    TextFormField(
                      controller: _subjectController,
                      decoration: const InputDecoration(
                        labelText: 'Sujet',
                        border: OutlineInputBorder(),
                        hintText: 'Décrivez brièvement votre demande…',
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Veuillez saisir un sujet.'
                          : null,
                      textInputAction: TextInputAction.next,
                      onChanged: (_) {
                        // If user types manually, deselect quick-pick
                        if (_selectedSubjectOption != null &&
                            _subjectController.text !=
                                _selectedSubjectOption) {
                          setState(() => _selectedSubjectOption = null);
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // Message field
                    TextFormField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        labelText: 'Message',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                        hintText:
                            'Décrivez votre problème en détail. Plus vous donnez d\'informations, mieux nous pourrons vous aider.',
                      ),
                      maxLines: 6,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Veuillez saisir un message.'
                          : null,
                    ),

                    if (_errorMessage != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ],

                    const SizedBox(height: 24),

                    ElevatedButton.icon(
                      onPressed: _submit,
                      icon: const Icon(Icons.send_rounded,
                          color: Colors.white, size: 18),
                      label: const Text(
                        'Envoyer au support',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Privacy note
                    Center(
                      child: Text(
                        'Vos messages sont traités de manière confidentielle.',
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey.shade500),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _SupportThreadView extends ConsumerWidget {
  final String conversationUuid;

  const _SupportThreadView({required this.conversationUuid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final providerKey = (uuid: conversationUuid, isSupport: true);
    final state = ref.watch(conversationDetailProvider(providerKey));
    final notifier = ref.read(conversationDetailProvider(providerKey).notifier);

    ref.listen(conversationDetailProvider(providerKey), (prev, next) {
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
              Text('Erreur : $e', style: const TextStyle(color: Colors.red)),
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
                conversationUuid: conversationUuid,
                disabled: isClosed,
                isSupport: true,
                onSend: (content, _) =>
                    notifier.sendMessage(content: content),
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
    DateTime? lastDate;

    for (final msg in reversed) {
      final msgDate =
          DateTime(msg.createdAt.year, msg.createdAt.month, msg.createdAt.day);
      if (lastDate == null || msgDate != lastDate) {
        items.add(_DateSeparator(msgDate));
        lastDate = msgDate;
      }
      items.add(_MessageItem(msg));
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
