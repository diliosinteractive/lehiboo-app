import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/auth/presentation/widgets/guest_restriction_dialog.dart';

class ConversationDetailScreen extends ConsumerStatefulWidget {
  final String conversationUuid;
  final ConversationRoute route;

  const ConversationDetailScreen({
    super.key,
    required this.conversationUuid,
    this.route = ConversationRoute.participant,
  });

  @override
  ConsumerState<ConversationDetailScreen> createState() =>
      _ConversationDetailScreenState();
}

class _ConversationDetailScreenState
    extends ConsumerState<ConversationDetailScreen> {
  static const _primaryColor = Color(0xFFFF601F);

  bool get _isReadonly => widget.route == ConversationRoute.adminReadonly;

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
    final pk = (uuid: widget.conversationUuid, route: widget.route);
    final state = ref.watch(conversationDetailProvider(pk));
    final detailNotifier =
        ref.read(conversationDetailProvider(pk).notifier);

    ref.listen<ConversationDetailState>(
      conversationDetailProvider(pk),
      (ConversationDetailState? prev, ConversationDetailState next) {
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
      },
    );

    return Scaffold(
      body: state.conversation.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 40),
              const SizedBox(height: 8),
              Text('Erreur : ${ApiResponseHandler.extractError(e)}', style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    ref.read(conversationDetailProvider(pk).notifier).load(),
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
        data: (conversation) {
          final isClosed = conversation.status == 'closed';
          final notifier =
              ref.read(conversationDetailProvider(pk).notifier);
          final route = widget.route;

          final titleText = switch (route) {
            ConversationRoute.participantSupport => conversation.subject,
            ConversationRoute.vendorOrgOrg =>
              conversation.partnerOrganization?.companyName ??
                  conversation.subject,
            ConversationRoute.vendor =>
              conversation.organization?.companyName ??
                  conversation.participant?.name ??
                  conversation.subject,
            ConversationRoute.admin ||
            ConversationRoute.adminReadonly =>
              conversation.participant?.name ??
                  conversation.organization?.companyName ??
                  conversation.subject,
            _ =>
              conversation.organization?.companyName ?? conversation.subject,
          };

          final titleAvatarUrl = switch (route) {
            ConversationRoute.participant =>
              conversation.organization?.logoUrl,
            ConversationRoute.vendor =>
              conversation.participant?.avatarUrl,
            ConversationRoute.vendorOrgOrg =>
              conversation.partnerOrganization?.logoUrl,
            ConversationRoute.admin ||
            ConversationRoute.adminReadonly =>
              conversation.participant?.avatarUrl ??
                  conversation.organization?.logoUrl,
            ConversationRoute.participantSupport =>
              conversation.participant?.avatarUrl ??
                  conversation.organization?.logoUrl,
          };
          final titleInitial = titleText.isNotEmpty
              ? titleText[0].toUpperCase()
              : '?';

          final showSubjectSubtitle = route != ConversationRoute.participantSupport;
          final showOverflowMenu = !_isReadonly;
          final canReport = route == ConversationRoute.participant ||
              route == ConversationRoute.vendor ||
              route == ConversationRoute.vendorOrgOrg;
          final canClose = !_isReadonly && conversation.status == 'open';
          final canReopen = route == ConversationRoute.admin && isClosed;

          return Column(
            children: [
              AppBar(
                leading: BackButton(
                  onPressed: () =>
                      context.canPop() ? context.pop() : context.go('/messages'),
                ),
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: _primaryColor.withValues(alpha: 0.15),
                      child: titleAvatarUrl != null && titleAvatarUrl.isNotEmpty
                          ? ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: titleAvatarUrl,
                                width: 36,
                                height: 36,
                                fit: BoxFit.cover,
                                errorWidget: (_, __, ___) => Text(
                                  titleInitial,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: _primaryColor,
                                  ),
                                ),
                              ),
                            )
                          : Text(
                              titleInitial,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: _primaryColor,
                              ),
                            ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(titleText,
                              style: const TextStyle(fontSize: 16),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                          if (showSubjectSubtitle)
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
                    ),
                  ],
                ),
                actions: [
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
                              constraints:
                                  const BoxConstraints(maxWidth: 100),
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
                  if (canReopen)
                    IconButton(
                      icon: const Icon(Icons.lock_open),
                      tooltip: 'Rouvrir',
                      onPressed: () async {
                        try {
                          await notifier.reopenConversation();
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Erreur : ${ApiResponseHandler.extractError(e)}'),
                                  backgroundColor: Colors.red),
                            );
                          }
                        }
                      },
                    ),
                  if (showOverflowMenu && (canClose || canReport))
                    PopupMenuButton<String>(
                      onSelected: (value) => _handleMenuAction(
                          context, value, notifier, conversation.status),
                      itemBuilder: (ctx) => [
                        if (canClose)
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
                        if (canReport && !conversation.userHasReported)
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
                        if (canReport && conversation.userHasReported)
                          PopupMenuItem<String>(
                            enabled: false,
                            child: Row(
                              children: [
                                Icon(Icons.flag,
                                    size: 18,
                                    color: Colors.orange.shade400),
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
              if (_isReadonly)
                MaterialBanner(
                  content: const Text(
                    'Mode lecture seule — conversation liée à un signalement. '
                    'Vous observez les échanges entre les deux parties.',
                  ),
                  leading: const Icon(Icons.visibility_outlined,
                      color: Colors.amber),
                  backgroundColor: Colors.amber.shade50,
                  actions: [
                    TextButton(
                      onPressed: () => ScaffoldMessenger.of(context)
                          .hideCurrentMaterialBanner(),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              if (!_isReadonly && isClosed)
                Container(
                  width: double.infinity,
                  color: Colors.grey.shade100,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      Icon(Icons.lock_outline, size: 18, color: Colors.grey.shade600),
                      const SizedBox(width: 8),
                      Text(
                        'Cette conversation est fermée.',
                        style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: _MessagesList(
                  messages: conversation.messages,
                  notifier: notifier,
                  readonly: _isReadonly,
                  organizationLogoUrl: conversation.organization?.logoUrl
                      ?? conversation.organization?.avatarUrl,
                ),
              ),
              MessageComposer(
                conversationUuid: widget.conversationUuid,
                disabled: isClosed || _isReadonly,
                isSupport:
                    widget.route == ConversationRoute.participantSupport,
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
                  content: Text('Erreur : ${ApiResponseHandler.extractError(e)}'),
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
    const _reasons = [
      ('inappropriate', 'Contenu inapproprié'),
      ('harassment', 'Harcèlement'),
      ('spam', 'Spam'),
      ('other', 'Autre'),
    ];

    String? selectedReason;
    final commentController = TextEditingController();
    bool isSubmitting = false;
    bool submitted = false;
    bool reasonError = false;
    String? commentError;
    String? supportUuid;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          return AnimatedPadding(
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOut,
            padding: EdgeInsets.only(
                bottom: MediaQuery.viewInsetsOf(ctx).bottom),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: submitted
                  ? _buildReportSuccess(
                      ctx: ctx,
                      supportUuid: supportUuid,
                      context: context,
                    )
                  : SingleChildScrollView(
                      padding:
                          const EdgeInsets.fromLTRB(20, 0, 20, 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Drag handle
                          Center(
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 12),
                              width: 36,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                          // Header
                          Row(
                            children: [
                              Icon(Icons.flag_outlined,
                                  color: Colors.red.shade400, size: 22),
                              const SizedBox(width: 8),
                              const Text(
                                'Signaler la conversation',
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Aidez-nous à maintenir un environnement sûr en signalant les contenus inappropriés.',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600),
                          ),
                          const SizedBox(height: 20),
                          // Reason chips
                          Row(
                            children: [
                              Text(
                                'Raison',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade700),
                              ),
                              const Text(
                                ' *',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: _reasons.map((r) {
                              final selected = selectedReason == r.$1;
                              return ChoiceChip(
                                label: Text(
                                  r.$2,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: selected
                                          ? _primaryColor
                                          : Colors.black87),
                                ),
                                selected: selected,
                                onSelected: isSubmitting
                                    ? null
                                    : (_) => setSheetState(() {
                                          selectedReason = r.$1;
                                          reasonError = false;
                                        }),
                                selectedColor: _primaryColor
                                    .withValues(alpha: 0.12),
                                checkmarkColor: _primaryColor,
                                side: BorderSide(
                                    color: selected
                                        ? _primaryColor
                                        : reasonError
                                            ? Colors.red.shade300
                                            : Colors.grey.shade300),
                                backgroundColor: Colors.white,
                              );
                            }).toList(),
                          ),
                          if (reasonError)
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 4, left: 4),
                              child: Text(
                                'Veuillez sélectionner une raison.',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.red.shade600),
                              ),
                            ),
                          const SizedBox(height: 20),
                          // Comment field
                          Row(
                            children: [
                              Text(
                                'Commentaire',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade700),
                              ),
                              const Text(
                                ' *',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                '  (min. 10 caractères)',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade500),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            controller: commentController,
                            maxLines: 4,
                            maxLength: 2000,
                            enabled: !isSubmitting,
                            buildCounter: (_, {required currentLength,
                                  required isFocused,
                                  maxLength}) =>
                                Text(
                                  '$currentLength / $maxLength',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade500),
                                ),
                            decoration: InputDecoration(
                              hintText: 'Décrivez le problème…',
                              border: const OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: commentError != null
                                        ? Colors.red
                                        : Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: commentError != null
                                        ? Colors.red
                                        : _primaryColor,
                                    width: 1.5),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 12),
                            ),
                            onChanged: (_) {
                              if (commentError != null) {
                                setSheetState(() => commentError = null);
                              }
                            },
                          ),
                          if (commentError != null)
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 4, left: 4),
                              child: Text(
                                commentError!,
                                style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.red.shade600),
                              ),
                            ),
                          const SizedBox(height: 24),
                          // Actions
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: isSubmitting
                                      ? null
                                      : () => Navigator.pop(ctx),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    side: BorderSide(
                                        color: Colors.grey.shade300),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text('Annuler',
                                      style: TextStyle(
                                          color: Colors.black87)),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: isSubmitting
                                      ? null
                                      : () async {
                                          final comment =
                                              commentController.text
                                                  .trim();
                                          bool hasError = false;
                                          if (selectedReason == null) {
                                            setSheetState(() =>
                                                reasonError = true);
                                            hasError = true;
                                          }
                                          if (comment.length < 10) {
                                            setSheetState(() =>
                                                commentError =
                                                    'Minimum 10 caractères.');
                                            hasError = true;
                                          }
                                          if (hasError) return;
                                          setSheetState(
                                              () => isSubmitting = true);
                                          try {
                                            final result = await notifier
                                                .reportConversation(
                                                    selectedReason!,
                                                    comment);
                                            supportUuid = result
                                                .supportConversationUuid;
                                            setSheetState(() {
                                              isSubmitting = false;
                                              submitted = true;
                                            });
                                          } catch (e) {
                                            setSheetState(() =>
                                                isSubmitting = false);
                                            if (ctx.mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        'Erreur : ${ApiResponseHandler.extractError(e)}'),
                                                    backgroundColor:
                                                        Colors.red),
                                              );
                                            }
                                          }
                                        },
                                  icon: isSubmitting
                                      ? const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white))
                                      : const Icon(Icons.flag,
                                          size: 16,
                                          color: Colors.white),
                                  label: const Text('Signaler',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red.shade600,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10),
                                    ),
                                    elevation: 0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
            ),
          );
        },
      ),
    ).then((_) => commentController.dispose());
  }

  Widget _buildReportSuccess({
    required BuildContext ctx,
    required String? supportUuid,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              shape: BoxShape.circle,
            ),
            child:
                Icon(Icons.flag, size: 36, color: Colors.orange.shade400),
          ),
          const SizedBox(height: 16),
          const Text(
            'Signalement transmis',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "Votre signalement a bien été transmis à l'équipe LeHiboo.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                if (supportUuid != null && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                          'Un ticket support a été créé pour le suivi.'),
                      action: SnackBarAction(
                        label: 'Voir',
                        onPressed: () => context
                            .push('/messages/support/$supportUuid'),
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              child: const Text('Fermer',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessagesList extends StatefulWidget {
  final List<Message> messages;
  final ConversationDetailNotifier notifier;
  final bool readonly;
  final String? organizationLogoUrl;

  const _MessagesList({
    required this.messages,
    required this.notifier,
    this.readonly = false,
    this.organizationLogoUrl,
  });

  @override
  State<_MessagesList> createState() => _MessagesListState();
}

class _MessagesListState extends State<_MessagesList> {
  final _scrollController = ScrollController();
  int _prevCount = 0;

  @override
  void initState() {
    super.initState();
    _prevCount = widget.messages.length;
  }

  @override
  void didUpdateWidget(_MessagesList old) {
    super.didUpdateWidget(old);
    final newCount = widget.messages.length;
    if (newCount > _prevCount) {
      _prevCount = newCount;
      // Auto-scroll to newest message when user is near the bottom.
      // With reverse:true, offset 0.0 = bottom (newest).
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_scrollController.hasClients) return;
        if (_scrollController.offset <= 120) {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      });
    } else {
      _prevCount = newCount;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messages = widget.messages;

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
      controller: _scrollController,
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
          organizationLogoUrl: widget.organizationLogoUrl,
          onEdit: widget.readonly
              ? null
              : (uuid, content) => widget.notifier.editMessage(uuid, content),
          onDelete: widget.readonly
              ? null
              : (uuid) => widget.notifier.deleteMessage(uuid),
        );
      },
    );
  }

  List<Object> _buildItems(List<Message> msgs) {
    // System messages sort before non-system ones so they always appear
    // at the top of their day group, regardless of the backend timestamp.
    final sorted = [...msgs]..sort((a, b) {
      if (a.isSystem && !b.isSystem) return -1;
      if (!a.isSystem && b.isSystem) return 1;
      return a.createdAt.compareTo(b.createdAt);
    });
    final reversed = sorted.reversed.toList();
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
