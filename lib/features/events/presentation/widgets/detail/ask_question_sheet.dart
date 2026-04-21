import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/themes/colors.dart';
import '../../providers/event_questions_providers.dart';

/// Bottom sheet pour poser une question sur un événement.
///
/// Gère la validation 10-1000 caractères (spec §2.1) et les erreurs 422.
class AskQuestionSheet extends ConsumerStatefulWidget {
  final String eventSlug;
  final String eventTitle;

  const AskQuestionSheet({
    super.key,
    required this.eventSlug,
    required this.eventTitle,
  });

  /// Renvoie `true` si la question a été créée avec succès.
  static Future<bool?> show(
    BuildContext context, {
    required String eventSlug,
    required String eventTitle,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AskQuestionSheet(
        eventSlug: eventSlug,
        eventTitle: eventTitle,
      ),
    );
  }

  @override
  ConsumerState<AskQuestionSheet> createState() => _AskQuestionSheetState();
}

class _AskQuestionSheetState extends ConsumerState<AskQuestionSheet> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _serverError;
  bool _submitting = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _serverError = null);
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);

    final result = await ref
        .read(eventQuestionsActionsProvider.notifier)
        .createQuestion(
          eventSlug: widget.eventSlug,
          text: _controller.text,
        );

    if (!mounted) return;

    // Capturer Navigator et ScaffoldMessenger AVANT le pop pour pouvoir
    // afficher le snackbar même après fermeture du sheet (le context du sheet
    // devient invalide après Navigator.pop).
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    switch (result) {
      case CreateQuestionSuccess():
        navigator.pop(true);
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Votre question a été envoyée !'),
            backgroundColor: HbColors.success,
          ),
        );
      case CreateQuestionAlreadyExists():
        navigator.pop(false);
        messenger.showSnackBar(
          const SnackBar(
            content: Text(
              'Vous avez déjà posé une question sur cet événement.',
            ),
          ),
        );
      case CreateQuestionValidationFailure(errorMessage: final msg):
        setState(() {
          _submitting = false;
          _serverError = msg;
        });
        _formKey.currentState?.validate();
      case CreateQuestionFailure(errorMessage: final msg):
        setState(() => _submitting = false);
        messenger.showSnackBar(
          SnackBar(
            content: Text(msg),
            backgroundColor: HbColors.error,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        decoration: const BoxDecoration(
          color: HbColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: HbColors.grey200,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 12, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Poser une question',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: HbColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.eventTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                color: HbColors.grey500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: _submitting
                            ? null
                            : () => Navigator.of(context).pop(false),
                        icon: const Icon(Icons.close),
                        color: HbColors.grey500,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: _controller,
                    maxLines: 5,
                    maxLength: 1000,
                    autofocus: true,
                    textInputAction: TextInputAction.newline,
                    onChanged: (_) {
                      if (_serverError != null) {
                        setState(() => _serverError = null);
                      }
                    },
                    decoration: InputDecoration(
                      hintText:
                          'Ex: À quelle heure ouvrent les portes ?',
                      hintStyle: const TextStyle(color: HbColors.grey400),
                      filled: true,
                      fillColor: HbColors.surfaceInput,
                      contentPadding: const EdgeInsets.all(14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: HbColors.brandPrimary,
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: HbColors.error),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: HbColors.error,
                          width: 2,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (_serverError != null) return _serverError;
                      final trimmed = (value ?? '').trim();
                      if (trimmed.isEmpty) {
                        return 'Veuillez saisir votre question.';
                      }
                      if (trimmed.length < 10) {
                        return 'Votre question doit contenir au moins 10 caractères.';
                      }
                      if (trimmed.length > 1000) {
                        return 'Votre question est trop longue (1000 max).';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: HbColors.backgroundLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 16,
                          color: HbColors.textSecondary,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'L\'organisateur recevra votre question et vous répondra bientôt.',
                            style: TextStyle(
                              fontSize: 12,
                              color: HbColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitting ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: HbColors.brandPrimary,
                        foregroundColor: HbColors.white,
                        disabledBackgroundColor: HbColors.grey200,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: _submitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: HbColors.white,
                              ),
                            )
                          : const Text(
                              'Envoyer ma question',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
