import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/themes/colors.dart';
import '../../../../core/utils/guest_guard.dart';
import '../../domain/entities/event_question.dart';
import '../providers/event_questions_providers.dart';
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

    return Scaffold(
      backgroundColor: HbColors.orangePastel,
      appBar: AppBar(
        backgroundColor: HbColors.white,
        elevation: 0,
        foregroundColor: HbColors.textPrimary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Questions',
              style: TextStyle(
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
        child: listAsync.when(
          loading: () => const _LoadingList(),
          error: (err, _) => _ErrorList(
            onRetry: () => ref.invalidate(
              eventQuestionsListControllerProvider(widget.eventSlug),
            ),
          ),
          data: (page) => _QuestionsList(
            scrollController: _scrollController,
            page: page,
            myQuestion: myQuestion,
            eventSlug: widget.eventSlug,
            eventTitle: widget.eventTitle,
          ),
        ),
      ),
      floatingActionButton: (myQuestion == null && listAsync.hasValue)
          ? FloatingActionButton.extended(
              onPressed: () async {
                HapticFeedback.lightImpact();
                final allowed = await GuestGuard.check(
                  context: context,
                  ref: ref,
                  featureName: 'poser une question',
                );
                if (!allowed || !context.mounted) return;
                await AskQuestionSheet.show(
                  context,
                  eventSlug: widget.eventSlug,
                  eventTitle: widget.eventTitle,
                );
              },
              backgroundColor: HbColors.brandPrimary,
              foregroundColor: HbColors.white,
              icon: const Icon(Icons.add_comment_outlined),
              label: const Text('Poser une question'),
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
    final items = page.items
        .where((q) => q.uuid != myUuid)
        .toList(growable: false);
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
                featureName: 'poser une question',
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
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Text(
                'Vous avez vu toutes les questions',
                style: TextStyle(
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
      featureName: 'voter pour cette question',
    );
    if (!allowed) return;
    final controller = ref.read(
      eventQuestionsListControllerProvider(eventSlug).notifier,
    );
    final ok = await ref
        .read(eventQuestionsActionsProvider.notifier)
        .toggleHelpful(
          eventSlug: eventSlug,
          question: q,
          listController: controller,
        );
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Impossible de voter pour le moment.'),
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
    final label = total > 1 ? 'questions' : 'question';
    return Text(
      '$total $label',
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
    final (label, color) = _statusLabel(myQuestion.status);

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
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 14,
                            color: HbColors.textPrimary,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Réponse officielle',
                            style: TextStyle(
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
          const Text(
            'Aucune question pour le moment',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: HbColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Soyez le premier à poser une question sur cet événement.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: HbColors.grey500,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: onAsk,
            icon: const Icon(Icons.add_comment_outlined, size: 18),
            label: const Text('Poser une question'),
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
                const Text(
                  'Impossible de charger les questions',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: HbColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Vérifiez votre connexion puis réessayez.',
                  style: TextStyle(
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
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
