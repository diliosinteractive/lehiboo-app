import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lehiboo/core/themes/colors.dart';
import '../../../data/models/event_question_dto.dart';
import '../../providers/event_social_providers.dart';

/// Section complète des questions/réponses - Version connectée à l'API
class EventQASection extends ConsumerWidget {
  final String eventSlug;
  final String eventTitle;
  final VoidCallback? onViewAll;

  const EventQASection({
    super.key,
    required this.eventSlug,
    required this.eventTitle,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questionsAsync = ref.watch(
      eventQuestionsProvider(EventQuestionsParams(eventSlug: eventSlug, perPage: 10)),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        _buildHeader(context, ref, questionsAsync),
        const SizedBox(height: 16),

        // Contenu
        questionsAsync.when(
          loading: () => _buildLoading(),
          error: (error, _) => _buildError(error.toString()),
          data: (response) {
            if (response.data.isEmpty) {
              return _buildEmpty(context, ref);
            }
            return _buildContent(context, ref, response.data, response.meta?.total ?? response.data.length);
          },
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, AsyncValue<EventQuestionsResponseDto> questionsAsync) {
    // Déterminer si on a des questions (pour masquer le bouton header si empty state)
    final hasQuestions = questionsAsync.maybeWhen(
      data: (response) => response.data.isNotEmpty,
      orElse: () => true, // Afficher le bouton pendant le chargement
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text(
                'Questions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: HbColors.textPrimary,
                ),
              ),
              questionsAsync.maybeWhen(
                data: (response) {
                  final total = response.meta?.total ?? response.data.length;
                  if (total > 0) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: HbColors.brandPrimary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$total',
                          style: const TextStyle(
                            color: HbColors.brandPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
                orElse: () => const SizedBox.shrink(),
              ),
            ],
          ),
          // Masquer le bouton "Poser" si empty state (le CTA est dans l'empty state)
          if (hasQuestions)
            TextButton.icon(
              onPressed: () {
                HapticFeedback.lightImpact();
                _showAskQuestionDialog(context, ref);
              },
              icon: const Icon(Icons.add_comment_outlined, size: 18),
              label: const Text('Poser'),
              style: TextButton.styleFrom(
                foregroundColor: HbColors.brandPrimary,
              ),
            ),
        ],
      ),
    );
  }

  void _showAskQuestionDialog(BuildContext context, WidgetRef ref) {
    AskQuestionDialog.show(
      context,
      eventTitle: eventTitle,
      onSubmit: (question, {guestName, guestEmail}) async {
        final notifier = ref.read(eventQuestionsNotifierProvider.notifier);
        final result = await notifier.createQuestion(
          eventSlug: eventSlug,
          question: question,
          guestName: guestName,
          guestEmail: guestEmail,
        );
        return result != null;
      },
    );
  }

  Widget _buildLoading() {
    return const Padding(
      padding: EdgeInsets.all(32),
      child: Center(
        child: CircularProgressIndicator(
          color: HbColors.brandPrimary,
        ),
      ),
    );
  }

  Widget _buildError(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red.shade400,
            ),
            const SizedBox(height: 12),
            Text(
              'Erreur de chargement',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.red.shade700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message,
              style: TextStyle(
                fontSize: 13,
                color: Colors.red.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: HbColors.grey200),
        ),
        child: Column(
          children: [
            // Icône stylisée dans cercle coloré (style Petit Boo)
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: HbColors.brandPrimary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.help_outline_rounded,
                color: HbColors.brandPrimary,
                size: 28,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Aucune question',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: HbColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Une question sur l\'événement ?\nL\'organisateur vous répondra.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: HbColors.grey500,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            // CTA flat avec icône
            FilledButton.icon(
              icon: const Icon(Icons.add_comment_outlined, size: 18),
              label: const Text('Poser une question'),
              style: FilledButton.styleFrom(
                backgroundColor: HbColors.brandPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                HapticFeedback.lightImpact();
                _showAskQuestionDialog(context, ref);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    List<EventQuestionDto> questions,
    int totalQuestions,
  ) {
    // Ne montrer que les questions avec réponses en preview
    final answeredQuestions = questions
        .where((q) => q.answer != null || q.hasAnswer || q.hasAnswerCamel)
        .take(5)
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Liste des questions (max 5 avec réponses)
          ...answeredQuestions.map((question) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: QACard(
                question: question,
                onVote: (questionUuid) {
                  ref.read(eventQuestionsNotifierProvider.notifier).markHelpful(questionUuid);
                },
              ),
            );
          }),

          // Message si aucune question avec réponse
          if (answeredQuestions.isEmpty && questions.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.pending_outlined,
                    color: Colors.amber.shade700,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${questions.length} question${questions.length > 1 ? 's' : ''} en attente de réponse',
                      style: TextStyle(
                        color: Colors.amber.shade800,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Bouton voir toutes les questions
          if (totalQuestions > answeredQuestions.length) ...[
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                onViewAll?.call();
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: HbColors.brandPrimary,
                side: const BorderSide(color: HbColors.brandPrimary),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Voir toutes les questions ($totalQuestions)'),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward, size: 16),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Card individuelle pour une question/réponse
class QACard extends StatefulWidget {
  final EventQuestionDto question;
  final Function(String questionUuid)? onVote;
  final bool showFull;

  const QACard({
    super.key,
    required this.question,
    this.onVote,
    this.showFull = false,
  });

  @override
  State<QACard> createState() => _QACardState();
}

class _QACardState extends State<QACard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final hasAnswer = widget.question.answer != null ||
        widget.question.hasAnswer ||
        widget.question.hasAnswerCamel;
    final helpfulCount = widget.question.helpfulCount > 0
        ? widget.question.helpfulCount
        : widget.question.helpfulCountCamel;
    final userVoted = widget.question.userVoted || widget.question.userVotedCamel;
    final createdAt = widget.question.createdAtFormatted.isNotEmpty
        ? widget.question.createdAtFormatted
        : widget.question.createdAtFormattedCamel;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question Header (toujours visible)
          InkWell(
            onTap: hasAnswer
                ? () {
                    HapticFeedback.selectionClick();
                    setState(() => _isExpanded = !_isExpanded);
                  }
                : null,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icône question
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: HbColors.brandPrimary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.help_outline,
                      color: HbColors.brandPrimary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Question text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.question.question,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: HbColors.textPrimary,
                            height: 1.4,
                          ),
                          maxLines: widget.showFull || _isExpanded ? null : 2,
                          overflow: widget.showFull || _isExpanded
                              ? null
                              : TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Text(
                              widget.question.author?.name ?? 'Anonyme',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '•',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade400,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              createdAt,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Indicateur réponse ou chevron
                  if (hasAnswer) ...[
                    const SizedBox(width: 8),
                    AnimatedRotation(
                      turns: _isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ] else ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'En attente',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.amber,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Réponse (expandable)
          if (hasAnswer && widget.question.answer != null)
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: _buildAnswer(helpfulCount, userVoted),
              crossFadeState:
                  _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 200),
            ),
        ],
      ),
    );
  }

  Widget _buildAnswer(int helpfulCount, bool userVoted) {
    final answer = widget.question.answer!;
    final isOfficial = answer.isOfficial || answer.isOfficialCamel;
    final orgName = answer.organizationName.isNotEmpty
        ? answer.organizationName
        : answer.organizationNameCamel;
    final answerCreatedAt = answer.createdAtFormatted.isNotEmpty
        ? answer.createdAtFormatted
        : answer.createdAtFormattedCamel;

    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            color: Colors.green.shade400,
            width: 3,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header réponse
          Row(
            children: [
              const Icon(
                Icons.check_circle,
                size: 16,
                color: Colors.green,
              ),
              const SizedBox(width: 6),
              if (isOfficial)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Réponse officielle',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const Spacer(),
              Text(
                answerCreatedAt,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Réponse text
          Text(
            answer.answer,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade800,
              height: 1.5,
            ),
          ),

          // Organisation qui répond
          const SizedBox(height: 10),
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: HbColors.brandPrimary.withValues(alpha: 0.1),
                child: const Icon(
                  Icons.business,
                  size: 14,
                  color: HbColors.brandPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                orgName,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),

          // Vote utile
          if (widget.onVote != null) ...[
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  'Cette réponse vous a aidé ?',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const Spacer(),
                _buildHelpfulButton(helpfulCount, userVoted),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHelpfulButton(int helpfulCount, bool isVoted) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onVote?.call(widget.question.uuid);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isVoted
              ? Colors.green.withValues(alpha: 0.15)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isVoted ? Colors.green : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isVoted ? Icons.thumb_up : Icons.thumb_up_outlined,
              size: 14,
              color: isVoted ? Colors.green : Colors.grey.shade600,
            ),
            if (helpfulCount > 0) ...[
              const SizedBox(width: 4),
              Text(
                '$helpfulCount',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isVoted ? Colors.green : Colors.grey.shade600,
                ),
              ),
            ],
            const SizedBox(width: 4),
            Text(
              'Utile',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isVoted ? Colors.green : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dialog pour poser une nouvelle question
class AskQuestionDialog extends StatefulWidget {
  final String eventTitle;
  final Future<bool> Function(String question, {String? guestName, String? guestEmail}) onSubmit;

  const AskQuestionDialog({
    super.key,
    required this.eventTitle,
    required this.onSubmit,
  });

  static Future<void> show(
    BuildContext context, {
    required String eventTitle,
    required Future<bool> Function(String question, {String? guestName, String? guestEmail}) onSubmit,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AskQuestionDialog(
        eventTitle: eventTitle,
        onSubmit: onSubmit,
      ),
    );
  }

  @override
  State<AskQuestionDialog> createState() => _AskQuestionDialogState();
}

class _AskQuestionDialogState extends State<AskQuestionDialog> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final success = await widget.onSubmit(_controller.text.trim());
      if (mounted && success) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Votre question a été envoyée !'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur lors de l\'envoi de la question'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      margin: EdgeInsets.only(bottom: bottomPadding),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: HbColors.brandPrimary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.help_outline,
                        color: HbColors.brandPrimary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Poser une question',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: HbColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.eventTitle,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                      color: Colors.grey.shade600,
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Question input
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Votre question',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: HbColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _controller,
                      maxLines: 4,
                      maxLength: 500,
                      decoration: InputDecoration(
                        hintText:
                            'Ex: Est-ce que l\'événement est adapté aux enfants ?',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: HbColors.brandPrimary,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Veuillez saisir votre question';
                        }
                        if (value.trim().length < 10) {
                          return 'Votre question est trop courte';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              // Info
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 18,
                        color: Colors.blue.shade700,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'L\'organisateur recevra votre question et pourra y répondre.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Submit button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: HbColors.brandPrimary,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey.shade300,
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
                        : const Text(
                            'Envoyer ma question',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
