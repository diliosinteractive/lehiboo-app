import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/utils/api_response_handler.dart';
import '../../data/repositories/messages_repository_impl.dart';
import '../../domain/entities/conversation_route.dart';
import '../providers/admin_conversations_provider.dart';
import '../providers/conversation_detail_provider.dart';
import '../providers/conversations_provider.dart';
import '../providers/support_conversations_provider.dart';
import '../providers/vendor_conversations_provider.dart';
import '../providers/vendor_org_conversations_provider.dart';

const _primaryColor = Color(0xFFFF601F);

List<(String, String)> _reportReasons(BuildContext context) => [
      ('inappropriate', context.l10n.messagesReasonInappropriate),
      ('harassment', context.l10n.messagesReasonHarassment),
      ('spam', context.l10n.messagesReasonSpam),
      ('other', context.l10n.messagesReasonOther),
    ];

Future<void> showConversationReportSheet(
  BuildContext context, {
  required String conversationUuid,
  required WidgetRef ref,
  ConversationRoute? route,
}) async {
  String? selectedReason;
  final commentController = TextEditingController();
  bool isSubmitting = false;
  bool submitted = false;
  bool reasonError = false;
  String? commentError;
  String? supportUuid;

  await showModalBottomSheet(
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
          padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(ctx).bottom),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: submitted
                ? _buildSuccess(
                    ctx: ctx,
                    supportUuid: supportUuid,
                    rootContext: context,
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 12),
                            width: 36,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.flag_outlined,
                                color: Colors.red.shade400, size: 22),
                            const SizedBox(width: 8),
                            Text(
                              ctx.l10n.messagesReportSheetTitle,
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          ctx.l10n.messagesReportSheetSubtitle,
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Text(ctx.l10n.messagesReportReasonLabel,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade700)),
                            const Text(' *',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: _reportReasons(ctx).map((r) {
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
                              selectedColor:
                                  _primaryColor.withValues(alpha: 0.12),
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
                            padding: const EdgeInsets.only(top: 4, left: 4),
                            child: Text(ctx.l10n.messagesReportReasonRequired,
                                style: TextStyle(
                                    fontSize: 11, color: Colors.red.shade600)),
                          ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Text(ctx.l10n.messagesReportCommentLabel,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade700)),
                            const Text(' *',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600)),
                            Text('  ${ctx.l10n.messagesReportMinCharsHint}',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey.shade500)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: commentController,
                          maxLines: 4,
                          maxLength: 2000,
                          enabled: !isSubmitting,
                          buildCounter: (_,
                                  {required currentLength,
                                  required isFocused,
                                  maxLength}) =>
                              Text('$currentLength / $maxLength',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade500)),
                          decoration: InputDecoration(
                            hintText: ctx.l10n.messagesReportCommentHint,
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
                            padding: const EdgeInsets.only(top: 4, left: 4),
                            child: Text(commentError!,
                                style: TextStyle(
                                    fontSize: 11, color: Colors.red.shade600)),
                          ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: isSubmitting
                                    ? null
                                    : () => Navigator.pop(ctx),
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  side: BorderSide(color: Colors.grey.shade300),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                child: Text(
                                  ctx.l10n.commonCancel,
                                  style: const TextStyle(color: Colors.black87),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: isSubmitting
                                    ? null
                                    : () async {
                                        final comment =
                                            commentController.text.trim();
                                        bool hasError = false;
                                        if (selectedReason == null) {
                                          setSheetState(
                                              () => reasonError = true);
                                          hasError = true;
                                        }
                                        if (comment.length < 10) {
                                          setSheetState(() => commentError = ctx
                                              .l10n
                                              .messagesReportCommentMinError);
                                          hasError = true;
                                        }
                                        if (hasError) return;
                                        setSheetState(
                                            () => isSubmitting = true);
                                        try {
                                          final result = await ref
                                              .read(messagesRepositoryProvider)
                                              .reportConversation(
                                                conversationUuid:
                                                    conversationUuid,
                                                reason: selectedReason!,
                                                comment: comment,
                                              );
                                          supportUuid =
                                              result.supportConversationUuid;
                                          _applyReportedAcrossProviders(
                                              ref, conversationUuid, route);
                                          setSheetState(() {
                                            isSubmitting = false;
                                            submitted = true;
                                          });
                                        } on DioException catch (e) {
                                          // 422 « déjà signalé » → succès UI
                                          if (_isAlreadyReportedError(e)) {
                                            _applyReportedAcrossProviders(
                                                ref, conversationUuid, route);
                                            setSheetState(() {
                                              isSubmitting = false;
                                              submitted = true;
                                            });
                                            return;
                                          }
                                          setSheetState(
                                              () => isSubmitting = false);
                                          if (ctx.mounted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                ctx.l10n.messagesLoadError(
                                                  ApiResponseHandler
                                                      .extractError(e),
                                                ),
                                              ),
                                              backgroundColor: Colors.red,
                                            ));
                                          }
                                        } catch (e) {
                                          setSheetState(
                                              () => isSubmitting = false);
                                          if (ctx.mounted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                ctx.l10n.messagesLoadError(
                                                  ApiResponseHandler
                                                      .extractError(e),
                                                ),
                                              ),
                                              backgroundColor: Colors.red,
                                            ));
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
                                        size: 16, color: Colors.white),
                                label: Text(ctx.l10n.messagesReportSubmit,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red.shade600,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
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

Widget _buildSuccess({
  required BuildContext ctx,
  required String? supportUuid,
  required BuildContext rootContext,
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
          child: Icon(Icons.flag, size: 36, color: Colors.orange.shade400),
        ),
        const SizedBox(height: 16),
        Text(
          ctx.l10n.messagesReportSuccessTitle,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          ctx.l10n.messagesReportSuccessBody,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        ),
        const SizedBox(height: 28),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              if (supportUuid != null && rootContext.mounted) {
                ScaffoldMessenger.of(rootContext).showSnackBar(
                  SnackBar(
                    content: Text(ctx.l10n.messagesReportSupportCreated),
                    action: SnackBarAction(
                      label: ctx.l10n.messagesViewAction,
                      onPressed: () =>
                          rootContext.push('/messages/support/$supportUuid'),
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
            child: Text(
              ctx.l10n.commonClose,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

/// Détecte un 422 « déjà signalé » : status 422 + body sans clé `errors`
/// non vide. Les 422 de validation renvoient toujours
/// `errors: { reason: [...], comment: [...] }`, tandis que le doublon
/// renvoie uniquement `message`.
bool _isAlreadyReportedError(DioException e) {
  if (e.response?.statusCode != 422) return false;
  final data = e.response?.data;
  if (data is! Map) return false;
  final errors = data['errors'];
  if (errors is Map && errors.isNotEmpty) return false;
  if (errors != null && errors is! Map) return false;

  final message = data['message']?.toString().toLowerCase();
  if (message == null) return false;
  final normalized = message
      .replaceAll('é', 'e')
      .replaceAll('è', 'e')
      .replaceAll('ê', 'e')
      .replaceAll('à', 'a');

  return (normalized.contains('deja') && normalized.contains('signale')) ||
      (normalized.contains('already') && normalized.contains('report'));
}

/// Propage `userHasReported = true` aux providers concernés.
/// - `route` connu → met à jour la liste correspondant à ce rôle ; touche le
///   detail-provider uniquement s'il est déjà actif (sinon on réveillerait
///   un notifier autoDispose et déclencherait un fetch inutile).
/// - `route` null → broadcast no-op-safe à toutes les listes possibles.
void _applyReportedAcrossProviders(
  WidgetRef ref,
  String conversationUuid,
  ConversationRoute? route,
) {
  switch (route) {
    case ConversationRoute.participant:
      ref.read(conversationsProvider.notifier).applyReported(conversationUuid);
    case ConversationRoute.participantSupport:
      ref
          .read(supportConversationsProvider.notifier)
          .applyReported(conversationUuid);
    case ConversationRoute.vendor:
      ref
          .read(vendorConversationsProvider.notifier)
          .applyReported(conversationUuid);
      ref.read(vendorSupportProvider.notifier).applyReported(conversationUuid);
    case ConversationRoute.vendorOrgOrg:
      ref
          .read(vendorOrgConversationsProvider.notifier)
          .applyReported(conversationUuid);
    case ConversationRoute.admin:
    case ConversationRoute.adminReadonly:
      ref
          .read(adminConversationsProvider('user_support').notifier)
          .applyReported(conversationUuid);
      ref
          .read(adminConversationsProvider('vendor_admin').notifier)
          .applyReported(conversationUuid);
    case null:
      ref.read(conversationsProvider.notifier).applyReported(conversationUuid);
      ref
          .read(supportConversationsProvider.notifier)
          .applyReported(conversationUuid);
      ref
          .read(vendorConversationsProvider.notifier)
          .applyReported(conversationUuid);
      ref.read(vendorSupportProvider.notifier).applyReported(conversationUuid);
      ref
          .read(vendorOrgConversationsProvider.notifier)
          .applyReported(conversationUuid);
      ref
          .read(adminConversationsProvider('user_support').notifier)
          .applyReported(conversationUuid);
      ref
          .read(adminConversationsProvider('vendor_admin').notifier)
          .applyReported(conversationUuid);
  }

  // Detail provider : update uniquement si déjà actif (écran détail ouvert).
  if (route != null) {
    final detailKey = (uuid: conversationUuid, route: route);
    if (ref.exists(conversationDetailProvider(detailKey))) {
      ref
          .read(conversationDetailProvider(detailKey).notifier)
          .applyReportedLocally();
    }
  }
}
