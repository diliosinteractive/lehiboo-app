import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/themes/colors.dart';
import '../../../../../core/utils/guest_guard.dart';
import '../../../../auth/presentation/providers/auth_provider.dart';
import '../../../domain/entities/event_question.dart';
import '../../providers/event_questions_providers.dart';
import 'ask_question_sheet.dart';
import 'question_card.dart';

/// Section Q&A intégrée à l'écran détail d'un événement.
/// Affiche max 5 questions + bouton "Voir toutes les questions".
class EventQASection extends ConsumerWidget {
  final String eventSlug;
  final String eventTitle;

  const EventQASection({
    super.key,
    required this.eventSlug,
    required this.eventTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final previewAsync = ref.watch(eventQuestionsPreviewProvider(eventSlug));
    // Observe l'état auth pour rebuild dès qu'il change, mais on re-vérifie
    // toujours via `ref.read` au moment du tap pour éviter les valeurs
    // capturées obsolètes (ex: auth state async qui se résout après le build).
    ref.watch(isAuthenticatedProvider);
    final myQuestionAsync = ref.watch(myQuestionProvider(eventSlug));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(
            total: previewAsync.maybeWhen(
              data: (page) => page.total,
              orElse: () => null,
            ),
            showAsk: myQuestionAsync.maybeWhen(
              data: (q) => q == null,
              orElse: () => false,
            ),
            onAsk: () => _handleAsk(context, ref),
          ),
          const SizedBox(height: 12),
          _MyQuestionBlock(myQuestion: myQuestionAsync.valueOrNull),
          previewAsync.when(
            loading: () => const _LoadingPlaceholder(),
            error: (_, __) => _ErrorBlock(
              onRetry: () =>
                  ref.invalidate(eventQuestionsPreviewProvider(eventSlug)),
            ),
            data: (page) => _Content(
              eventSlug: eventSlug,
              eventTitle: eventTitle,
              page: page,
              myQuestion: myQuestionAsync.valueOrNull,
              onAsk: () => _handleAsk(context, ref),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleAsk(BuildContext context, WidgetRef ref) async {
    HapticFeedback.lightImpact();
    final allowed = await GuestGuard.check(
      context: context,
      ref: ref,
      featureName: 'poser une question',
    );
    if (!allowed || !context.mounted) return;
    await AskQuestionSheet.show(
      context,
      eventSlug: eventSlug,
      eventTitle: eventTitle,
    );
  }
}

class _Header extends StatelessWidget {
  final int? total;
  final bool showAsk;
  final VoidCallback onAsk;

  const _Header({
    required this.total,
    required this.showAsk,
    required this.onAsk,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Questions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: HbColors.textPrimary,
          ),
        ),
        if (total != null && total! > 0) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: HbColors.brandPrimary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '$total',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: HbColors.brandPrimary,
              ),
            ),
          ),
        ],
        const Spacer(),
        if (showAsk)
          TextButton.icon(
            onPressed: onAsk,
            icon: const Icon(Icons.add_comment_outlined, size: 18),
            label: const Text('Poser'),
            style: TextButton.styleFrom(
              foregroundColor: HbColors.brandPrimary,
            ),
          ),
      ],
    );
  }
}

class _MyQuestionBlock extends StatelessWidget {
  final EventQuestion? myQuestion;
  const _MyQuestionBlock({required this.myQuestion});

  @override
  Widget build(BuildContext context) {
    final q = myQuestion;
    if (q == null) return const SizedBox.shrink();

    final (label, color) = _statusLabel(q.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: HbColors.orangePastel,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: HbColors.brandPrimary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Votre question',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: HbColors.brandPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            q.question,
            style: const TextStyle(
              fontSize: 14,
              height: 1.4,
              color: HbColors.textPrimary,
            ),
          ),
          if (q.answer != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: HbColors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                q.answer!.text,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: HbColors.textPrimary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  static (String, Color) _statusLabel(QuestionStatus status) {
    switch (status) {
      case QuestionStatus.pending:
        return ('En attente de modération', HbColors.warning);
      case QuestionStatus.approved:
        return ('Approuvée', HbColors.success);
      case QuestionStatus.answered:
        return ('Répondue', HbColors.success);
      case QuestionStatus.rejected:
        return ('Refusée', HbColors.error);
    }
  }
}

class _Content extends ConsumerWidget {
  final String eventSlug;
  final String eventTitle;
  final QuestionsPage page;
  final EventQuestion? myQuestion;
  final VoidCallback onAsk;

  const _Content({
    required this.eventSlug,
    required this.eventTitle,
    required this.page,
    required this.myQuestion,
    required this.onAsk,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myUuid = myQuestion?.uuid;
    final visible = page.items
        .where((q) => q.uuid != myUuid)
        .take(5)
        .toList(growable: false);

    if (visible.isEmpty && myQuestion == null) {
      return _EmptyBlock(onAsk: onAsk);
    }

    final remaining = page.total - visible.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...visible.map(
          (q) => QuestionCard(
            question: q,
            onToggleHelpful: () => _handleVote(context, ref, q),
          ),
        ),
        if (remaining > 0) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                context.push(
                  '/event/$eventSlug/questions',
                  extra: {'title': eventTitle},
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: HbColors.brandPrimary,
                side: const BorderSide(color: HbColors.brandPrimary),
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Voir toutes les questions (${page.total})'),
                  const SizedBox(width: 6),
                  const Icon(Icons.arrow_forward, size: 16),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _handleVote(
    BuildContext context,
    WidgetRef ref,
    EventQuestion q,
  ) async {
    final allowed = await GuestGuard.check(
      context: context,
      ref: ref,
      featureName: 'voter pour cette question',
    );
    if (!allowed) return;
    await ref
        .read(eventQuestionsActionsProvider.notifier)
        .toggleHelpful(eventSlug: eventSlug, question: q);
    // Preview invalidée dans le controller si aucun listController fourni.
  }
}

class _EmptyBlock extends StatelessWidget {
  final VoidCallback onAsk;
  const _EmptyBlock({required this.onAsk});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: HbColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: HbColors.grey200),
      ),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: HbColors.brandPrimary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.help_outline_rounded,
              color: HbColors.brandPrimary,
              size: 26,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Aucune question pour le moment',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: HbColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Soyez le premier à poser une question sur cet événement.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: HbColors.grey500,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onAsk,
            icon: const Icon(Icons.add_comment_outlined, size: 18),
            label: const Text('Poser une question'),
            style: FilledButton.styleFrom(
              backgroundColor: HbColors.brandPrimary,
              foregroundColor: HbColors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingPlaceholder extends StatelessWidget {
  const _LoadingPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        3,
        (i) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: HbColors.surfaceLight,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 120,
                    height: 12,
                    decoration: BoxDecoration(
                      color: HbColors.surfaceLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 14,
                decoration: BoxDecoration(
                  color: HbColors.surfaceLight,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: 200,
                height: 14,
                decoration: BoxDecoration(
                  color: HbColors.surfaceLight,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorBlock extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorBlock({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: HbColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: HbColors.grey200),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline,
            color: HbColors.error,
            size: 32,
          ),
          const SizedBox(height: 8),
          const Text(
            'Impossible de charger les questions',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: HbColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: onRetry,
            style: TextButton.styleFrom(
              foregroundColor: HbColors.brandPrimary,
            ),
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }
}
