import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/api_response_handler.dart';
import '../../data/repositories/messages_repository_impl.dart';

const _primaryColor = Color(0xFFFF601F);
const _reasons = [
  ('inappropriate', 'Contenu inapproprié'),
  ('harassment', 'Harcèlement'),
  ('spam', 'Spam'),
  ('other', 'Autre'),
];

Future<void> showConversationReportSheet(
  BuildContext context, {
  required String conversationUuid,
  required WidgetRef ref,
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
          padding:
              EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(ctx).bottom),
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
                            const Text(
                              'Signaler la conversation',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Aidez-nous à maintenir un environnement sûr en signalant les contenus inappropriés.',
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Text('Raison',
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
                            child: Text('Veuillez sélectionner une raison.',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.red.shade600)),
                          ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Text('Commentaire',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade700)),
                            const Text(' *',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600)),
                            Text('  (min. 10 caractères)',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade500)),
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
                              Text('$currentLength / $maxLength',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade500)),
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
                            padding: const EdgeInsets.only(top: 4, left: 4),
                            child: Text(commentError!,
                                style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.red.shade600)),
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
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14),
                                  side: BorderSide(
                                      color: Colors.grey.shade300),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)),
                                ),
                                child: const Text('Annuler',
                                    style:
                                        TextStyle(color: Colors.black87)),
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
                                          setSheetState(() => commentError =
                                              'Minimum 10 caractères.');
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
                                          supportUuid = result
                                              .supportConversationUuid;
                                          setSheetState(() {
                                            isSubmitting = false;
                                            submitted = true;
                                          });
                                        } catch (e) {
                                          setSheetState(
                                              () => isSubmitting = false);
                                          if (ctx.mounted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Erreur : ${ApiResponseHandler.extractError(e)}'),
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
                                          BorderRadius.circular(10)),
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
              if (supportUuid != null && rootContext.mounted) {
                ScaffoldMessenger.of(rootContext).showSnackBar(
                  SnackBar(
                    content: const Text(
                        'Un ticket support a été créé pour le suivi.'),
                    action: SnackBarAction(
                      label: 'Voir',
                      onPressed: () => rootContext
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
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ),
      ],
    ),
  );
}
