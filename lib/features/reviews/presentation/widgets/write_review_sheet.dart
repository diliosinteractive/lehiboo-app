import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/themes/colors.dart';
import '../../domain/entities/can_review_result.dart';
import '../../domain/entities/review.dart';
import '../providers/reviews_actions_provider.dart';
import '../providers/reviews_providers.dart';
import 'can_review_message.dart';
import 'rating_stars.dart';

/// Modal d'écriture (ou édition) d'un avis.
///
/// Mode "création" : `WriteReviewSheet.show(context, eventSlug:..., eventTitle:...)`.
/// Mode "édition"  : `WriteReviewSheet.showEdit(context, review:..., eventSlug:..., eventTitle:...)`.
///
/// `title` est REQUIS (cf. spec REVIEWS_API_MOBILE.md §2.2).
class WriteReviewSheet extends ConsumerStatefulWidget {
  final String eventSlug;
  final String eventTitle;
  final Review? existingReview;

  const WriteReviewSheet({
    super.key,
    required this.eventSlug,
    required this.eventTitle,
    this.existingReview,
  });

  bool get isEditMode => existingReview != null;

  static Future<Review?> show(
    BuildContext context, {
    required String eventSlug,
    required String eventTitle,
  }) {
    return showModalBottomSheet<Review>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => WriteReviewSheet(
        eventSlug: eventSlug,
        eventTitle: eventTitle,
      ),
    );
  }

  static Future<Review?> showEdit(
    BuildContext context, {
    required Review review,
    required String eventSlug,
    required String eventTitle,
  }) {
    return showModalBottomSheet<Review>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => WriteReviewSheet(
        eventSlug: eventSlug,
        eventTitle: eventTitle,
        existingReview: review,
      ),
    );
  }

  @override
  ConsumerState<WriteReviewSheet> createState() => _WriteReviewSheetState();
}

class _WriteReviewSheetState extends ConsumerState<WriteReviewSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _commentController;

  late double _rating;
  bool _isSubmitting = false;
  String? _serverError;

  @override
  void initState() {
    super.initState();
    final existing = widget.existingReview;
    _titleController = TextEditingController(text: existing?.title ?? '');
    _commentController = TextEditingController(text: existing?.comment ?? '');
    _rating = existing?.rating.toDouble() ?? 0;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_rating < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner une note'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _serverError = null;
    });

    final notifier = ref.read(reviewsActionsProvider.notifier);
    final title = _titleController.text.trim();
    final comment = _commentController.text.trim();
    final rating = _rating.round();

    final result = widget.isEditMode
        ? await notifier.updateReview(
            reviewUuid: widget.existingReview!.uuid,
            eventSlug: widget.eventSlug,
            rating: rating,
            title: title,
            comment: comment,
          )
        : await notifier.createReview(
            eventSlug: widget.eventSlug,
            rating: rating,
            title: title,
            comment: comment,
          );

    if (!mounted) return;

    switch (result) {
      case ReviewActionSuccess(value: final review):
        Navigator.of(context).pop(review);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.isEditMode
                ? 'Avis mis à jour. Il sera de nouveau modéré.'
                : 'Avis envoyé. Il sera publié après validation.'),
            backgroundColor: Colors.green,
          ),
        );
      case ReviewActionFailure(message: final msg):
        setState(() {
          _isSubmitting = false;
          _serverError = msg;
        });
        _formKey.currentState?.validate();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    // En mode édition, on n'a pas besoin de canReview (on agit sur un avis
    // existant via /reviews/{uuid}). En mode création, on bloque le formulaire
    // si l'utilisateur ne peut pas laisser d'avis (organisateur, déjà reviewé,
    // pas connecté…).
    final canReviewAsync = widget.isEditMode
        ? null
        : ref.watch(canReviewProvider(widget.eventSlug));
    final denied = canReviewAsync?.maybeWhen(
      data: (r) => r is CanReviewDenied ? r : null,
      orElse: () => null,
    );
    final isFormDisabled = denied != null;

    return Container(
      margin: EdgeInsets.only(bottom: bottomInset),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.isEditMode
                                  ? 'Modifier mon avis'
                                  : 'Laisser un avis',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: HbColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.eventTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (widget.isEditMode) _buildEditNotice(),
                  if (denied != null) ...[
                    CanReviewMessage(denied: denied),
                    const SizedBox(height: 16),
                  ],
                  const Text(
                    'Votre note',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InteractiveRatingStars(
                    rating: _rating,
                    onRatingChanged: (v) => setState(() => _rating = v),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Titre *',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLength: 150,
                    onChanged: (_) {
                      if (_serverError != null) {
                        setState(() => _serverError = null);
                      }
                    },
                    validator: (value) {
                      final text = value?.trim() ?? '';
                      if (text.isEmpty) {
                        return 'Veuillez ajouter un titre';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _commentController,
                    maxLines: 5,
                    maxLength: 2000,
                    decoration: InputDecoration(
                      labelText: 'Votre avis *',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (_) {
                      if (_serverError != null) {
                        setState(() => _serverError = null);
                      }
                    },
                    validator: (value) {
                      final text = value?.trim() ?? '';
                      if (text.isEmpty) {
                        return 'Veuillez écrire votre avis';
                      }
                      if (text.length < 10) {
                        return 'Votre avis doit faire au moins 10 caractères';
                      }
                      return null;
                    },
                  ),
                  if (_serverError != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Text(
                        _serverError!,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.red.shade700,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (_isSubmitting || isFormDisabled)
                          ? null
                          : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: HbColors.brandPrimary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              widget.isEditMode
                                  ? 'Mettre à jour'
                                  : 'Envoyer mon avis',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditNotice() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.orange.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
        ),
        child: const Row(
          children: [
            Icon(Icons.info_outline, size: 18, color: Colors.orange),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Toute modification remettra votre avis en attente de modération.',
                style: TextStyle(fontSize: 13, color: Colors.orange),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
