import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/l10n/l10n.dart';
import '../../../../../core/themes/colors.dart';
import '../../../../../core/utils/guest_guard.dart';
import '../../../../auth/presentation/providers/auth_provider.dart';
import '../../../domain/entities/event_question.dart';
import '../../providers/event_questions_providers.dart';
import '../../utils/event_l10n.dart';
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
    final myQuestion = myQuestionAsync.valueOrNull;

    // Si la question de l'user est déjà présente dans la liste publique
    // (status approved/answered), on la laisse dans la liste (avec toutes
    // ses interactions) et on cache le bloc "Votre question". Le bloc ne
    // s'affiche que pour les status pending/rejected non visibles publiquement.
    final publicItems = previewAsync.valueOrNull?.items ?? const [];
    final myQuestionInPublicList =
        myQuestion != null && publicItems.any((q) => q.uuid == myQuestion.uuid);
    final myQuestionToDisplay = myQuestionInPublicList ? null : myQuestion;

    // Afficher le loader dès qu'une des deux sources est en cours de chargement
    // (initial OU refresh après soumission d'une question). Évite de montrer
    // les anciennes data pendant que la liste se met à jour.
    final isLoading = previewAsync.isLoading || myQuestionAsync.isLoading;

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
            // Le CTA "Poser" reste caché dès que l'user a déjà une question
            // (peu importe son status) — il ne peut pas en poser une autre.
            // Pendant le chargement, on masque aussi le bouton pour éviter
            // qu'il flashe entre deux états.
            showAsk: !isLoading &&
                myQuestionAsync.maybeWhen(
                  data: (q) => q == null,
                  orElse: () => false,
                ),
            onAsk: () => _handleAsk(context, ref),
          ),
          const SizedBox(height: 12),
          if (isLoading)
            const _LoadingPlaceholder()
          else ...[
            _MyQuestionBlock(myQuestion: myQuestionToDisplay),
            previewAsync.when(
              // isLoading est déjà traité au-dessus
              loading: () => const SizedBox.shrink(),
              error: (_, __) => _ErrorBlock(
                onRetry: () =>
                    ref.invalidate(eventQuestionsPreviewProvider(eventSlug)),
              ),
              data: (page) => _Content(
                eventSlug: eventSlug,
                eventTitle: eventTitle,
                page: page,
                // Passer null ici quand myQuestion est dans la liste publique,
                // comme ça le dedupe ne retire rien → la question reste visible
                // avec ses boutons (Utile, etc.) dans la liste.
                myQuestion: myQuestionToDisplay,
                onAsk: () => _handleAsk(context, ref),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _handleAsk(BuildContext context, WidgetRef ref) async {
    HapticFeedback.lightImpact();
    final allowed = await GuestGuard.check(
      context: context,
      ref: ref,
      featureName: context.l10n.guestFeatureAskQuestion,
    );
    if (!allowed || !context.mounted) return;

    final outcome = await AskQuestionSheet.show(
      context,
      eventSlug: eventSlug,
      eventTitle: eventTitle,
    );
    if (outcome == null || !context.mounted) return;

    // Refresh les vues Q&A maintenant que le sheet est fermé — le loader
    // de la section s'affiche pendant le refetch.
    ref.read(eventQuestionsActionsProvider.notifier).refreshAll(eventSlug);

    final message = switch (outcome) {
      AskQuestionOutcome.created => context.l10n.eventQuestionSent,
      AskQuestionOutcome.alreadyExists =>
        context.l10n.eventQuestionAlreadyAsked,
    };
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: outcome == AskQuestionOutcome.created
            ? HbColors.success
            : HbColors.textSecondary,
      ),
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
        Text(
          context.l10n.eventQuestionsTitle,
          style: const TextStyle(
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
            label: Text(context.l10n.eventAsk),
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

    final (label, color) = _statusLabel(context, q.status);

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
              Text(
                context.l10n.eventYourQuestion,
                style: const TextStyle(
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

  static (String, Color) _statusLabel(
    BuildContext context,
    QuestionStatus status,
  ) {
    switch (status) {
      case QuestionStatus.pending:
        return (context.eventQuestionStatusLabel(status), HbColors.warning);
      case QuestionStatus.approved:
        return (context.eventQuestionStatusLabel(status), HbColors.success);
      case QuestionStatus.answered:
        return (context.eventQuestionStatusLabel(status), HbColors.success);
      case QuestionStatus.rejected:
        return (context.eventQuestionStatusLabel(status), HbColors.error);
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
                  Text(context.l10n.eventViewAllQuestionsCount(page.total)),
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
      featureName: context.l10n.guestFeatureVoteQuestion,
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
          Text(
            context.l10n.eventNoQuestionsTitle,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: HbColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            context.l10n.eventNoQuestionsBody,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: HbColors.grey500,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onAsk,
            icon: const Icon(Icons.add_comment_outlined, size: 18),
            label: Text(context.l10n.eventAskQuestion),
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
          Text(
            context.l10n.eventQuestionsLoadError,
            style: const TextStyle(
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
            child: Text(context.l10n.searchRetry),
          ),
        ],
      ),
    );
  }
}
