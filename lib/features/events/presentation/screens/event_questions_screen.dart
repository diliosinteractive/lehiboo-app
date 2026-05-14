import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/utils/guest_guard.dart';
import '../../domain/entities/event_question.dart';
import '../providers/event_questions_providers.dart';
import '../utils/event_l10n.dart';
import '../widgets/detail/ask_question_sheet.dart';
import '../widgets/detail/question_card.dart';

/// Écran dédié "Toutes les questions" pour un événement donné.
///
/// Accessible via `/event/{slug}/questions`. Pagination infinie + pull-to-refresh.
class EventQuestionsScreen extends ConsumerStatefulWidget {
  final String eventSlug;
  final String eventTitle;

  const EventQuestionsScreen({
    super.key,
    required this.eventSlug,
    required this.eventTitle,
  });

  @override
  ConsumerState<EventQuestionsScreen> createState() =>
      _EventQuestionsScreenState();
}

class _EventQuestionsScreenState extends ConsumerState<EventQuestionsScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  Future<void> _onAskQuestion() async {
    HapticFeedback.lightImpact();
    final allowed = await GuestGuard.check(
      context: context,
      ref: ref,
      featureName: context.l10n.guestFeatureAskQuestion,
    );
    if (!allowed || !mounted) return;

    final outcome = await AskQuestionSheet.show(
      context,
      eventSlug: widget.eventSlug,
      eventTitle: widget.eventTitle,
    );
    if (outcome == null || !mounted) return;

    ref
        .read(eventQuestionsActionsProvider.notifier)
        .refreshAll(widget.eventSlug);

    final message = switch (outcome) {
      AskQuestionOutcome.created => context.l10n.eventQuestionSent,
      AskQuestionOutcome.alreadyExists =>
        context.l10n.eventQuestionAlreadyAsked,
    };
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: outcome == AskQuestionOutcome.created
            ? HbColors.success
            : HbColors.textSecondary,
      ),
    );
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent * 0.8) {
      ref
          .read(
            eventQuestionsListControllerProvider(widget.eventSlug).notifier,
          )
          .loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final listAsync =
        ref.watch(eventQuestionsListControllerProvider(widget.eventSlug));
    final myQuestionAsync = ref.watch(myQuestionProvider(widget.eventSlug));
    final myQuestion = myQuestionAsync.valueOrNull;

    // Si la question de l'user est déjà dans la liste publique
    // (status approved/answered), on la laisse dans la liste (avec ses
    // interactions) et on cache le bloc "Votre question" en tête de page.
    final publicItems = listAsync.valueOrNull?.items ?? const [];
    final myQuestionInPublicList =
        myQuestion != null && publicItems.any((q) => q.uuid == myQuestion.uuid);
    final myQuestionToDisplay = myQuestionInPublicList ? null : myQuestion;

    return Scaffold(
      backgroundColor: HbColors.orangePastel,
      appBar: AppBar(
        backgroundColor: HbColors.white,
        elevation: 0,
        foregroundColor: HbColors.textPrimary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.eventQuestionsTitle,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: HbColors.textPrimary,
              ),
            ),
            Text(
              widget.eventTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: HbColors.grey500,
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        color: HbColors.brandPrimary,
        onRefresh: () => ref
            .read(
              eventQuestionsListControllerProvider(widget.eventSlug).notifier,
            )
            .refresh(),
        child: Builder(
          builder: (_) {
            // Afficher le loader dès qu'une des deux sources est en cours de
            // chargement (initial OU refresh après soumission).
            final isLoading = listAsync.isLoading || myQuestionAsync.isLoading;
            if (isLoading) return const _LoadingList();
            if (listAsync.hasError) {
              return _ErrorList(
                onRetry: () => ref.invalidate(
                  eventQuestionsListControllerProvider(widget.eventSlug),
                ),
              );
            }
            final page = listAsync.valueOrNull;
            if (page == null) return const _LoadingList();
            return _QuestionsList(
              scrollController: _scrollController,
              page: page,
              // Passer null ici quand myQuestion est déjà dans la liste publique
              // → aucun dedupe, la question reste affichée avec ses boutons
              // (Utile, etc.) et pas de bloc "Votre question" en double au top.
              myQuestion: myQuestionToDisplay,
              eventSlug: widget.eventSlug,
              eventTitle: widget.eventTitle,
            );
          },
        ),
      ),
      // Le FAB reste caché dès que l'user a déjà posé une question
      // (peu importe si elle est publique ou non — il ne peut pas en reposer).
      floatingActionButton: (myQuestion == null && listAsync.hasValue)
          ? FloatingActionButton.extended(
              onPressed: () => _onAskQuestion(),
              backgroundColor: HbColors.brandPrimary,
              foregroundColor: HbColors.white,
              icon: const Icon(Icons.add_comment_outlined),
              label: Text(context.l10n.eventAskQuestion),
            )
          : null,
    );
  }
}

class _QuestionsList extends ConsumerWidget {
  final ScrollController scrollController;
  final QuestionsPage page;
  final EventQuestion? myQuestion;
  final String eventSlug;
  final String eventTitle;

  const _QuestionsList({
    required this.scrollController,
    required this.page,
    required this.myQuestion,
    required this.eventSlug,
    required this.eventTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myUuid = myQuestion?.uuid;
    final items =
        page.items.where((q) => q.uuid != myUuid).toList(growable: false);
    if (items.isEmpty && myQuestion == null) {
      return ListView(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 80),
          _EmptyState(
            onAsk: () async {
              final allowed = await GuestGuard.check(
                context: context,
                ref: ref,
                featureName: context.l10n.guestFeatureAskQuestion,
              );
              if (!allowed || !context.mounted) return;
              await AskQuestionSheet.show(
                context,
                eventSlug: eventSlug,
                eventTitle: eventTitle,
              );
            },
          ),
        ],
      );
    }

    return ListView(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        const SizedBox(height: 16),
        _TotalRow(total: page.total),
        if (myQuestion != null) ...[
          const SizedBox(height: 12),
          _MyQuestionCard(myQuestion: myQuestion!),
        ],
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: HbColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: HbColors.grey200),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              for (var i = 0; i < items.length; i++)
                QuestionCard(
                  key: ValueKey(items[i].uuid),
                  question: items[i],
                  expanded: true,
                  onToggleHelpful: () => _handleVote(
                    context,
                    ref,
                    items[i],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (page.hasMore)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: CircularProgressIndicator(
                color: HbColors.brandPrimary,
                strokeWidth: 2,
              ),
            ),
          )
        else if (items.length >= 10)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Text(
                context.l10n.eventQuestionsEnd,
                style: const TextStyle(
                  fontSize: 12,
                  color: HbColors.grey500,
                ),
              ),
            ),
          ),
        const SizedBox(height: 80),
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
    final controller = ref.read(
      eventQuestionsListControllerProvider(eventSlug).notifier,
    );
    final ok =
        await ref.read(eventQuestionsActionsProvider.notifier).toggleHelpful(
              eventSlug: eventSlug,
              question: q,
              listController: controller,
            );
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.eventVoteUnavailable),
          backgroundColor: HbColors.error,
        ),
      );
    }
  }
}

class _TotalRow extends StatelessWidget {
  final int total;
  const _TotalRow({required this.total});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.eventQuestionsCount(total),
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: HbColors.grey500,
      ),
    );
  }
}

class _MyQuestionCard extends StatelessWidget {
  final EventQuestion myQuestion;
  const _MyQuestionCard({required this.myQuestion});

  @override
  Widget build(BuildContext context) {
    final (label, color) = _statusLabel(context, myQuestion.status);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: HbColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: HbColors.brandPrimary.withValues(alpha: 0.4),
          width: 1.5,
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
          const SizedBox(height: 10),
          Text(
            myQuestion.question,
            style: const TextStyle(
              fontSize: 15,
              height: 1.45,
              fontWeight: FontWeight.w500,
              color: HbColors.textPrimary,
            ),
          ),
          if (myQuestion.answer != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: HbColors.surfaceLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (myQuestion.answer!.isOfficial)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: HbColors.white,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: HbColors.grey200),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_circle_outline,
                            size: 14,
                            color: HbColors.textPrimary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            context.l10n.eventOfficialAnswer,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: HbColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 10),
                  Text(
                    myQuestion.answer!.text,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: HbColors.textPrimary,
                    ),
                  ),
                ],
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

class _EmptyState extends StatelessWidget {
  final VoidCallback onAsk;

  const _EmptyState({required this.onAsk});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: HbColors.brandPrimary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.help_outline_rounded,
              color: HbColors.brandPrimary,
              size: 36,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            context.l10n.eventNoQuestionsTitle,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: HbColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.eventNoQuestionsBody,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: HbColors.grey500,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: onAsk,
            icon: const Icon(Icons.add_comment_outlined, size: 18),
            label: Text(context.l10n.eventAskQuestion),
            style: FilledButton.styleFrom(
              backgroundColor: HbColors.brandPrimary,
              foregroundColor: HbColors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 14,
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

class _LoadingList extends StatelessWidget {
  const _LoadingList();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (_, __) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: HbColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: HbColors.grey200),
        ),
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
            const SizedBox(height: 12),
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
              width: 240,
              height: 14,
              decoration: BoxDecoration(
                color: HbColors.surfaceLight,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorList extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorList({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 120),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 48,
                  color: HbColors.error,
                ),
                const SizedBox(height: 16),
                Text(
                  context.l10n.eventQuestionsLoadError,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: HbColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  context.l10n.eventCheckConnectionRetry,
                  style: const TextStyle(
                    fontSize: 13,
                    color: HbColors.grey500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: onRetry,
                  style: FilledButton.styleFrom(
                    backgroundColor: HbColors.brandPrimary,
                    foregroundColor: HbColors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(context.l10n.searchRetry),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
