import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/widgets/feedback/hb_feedback.dart';
import '../providers/user_questions_provider.dart';
import '../widgets/user_question_card.dart';

class UserQuestionsScreen extends ConsumerStatefulWidget {
  const UserQuestionsScreen({super.key});

  @override
  ConsumerState<UserQuestionsScreen> createState() =>
      _UserQuestionsScreenState();
}

class _UserQuestionsScreenState extends ConsumerState<UserQuestionsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent * 0.8) {
      ref.read(userQuestionsListControllerProvider.notifier).loadMore();
    }
  }

  Future<void> _onRefresh() {
    return ref.read(userQuestionsListControllerProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final asyncPage = ref.watch(userQuestionsListControllerProvider);

    return Scaffold(
      backgroundColor: HbColors.backgroundLight,
      appBar: AppBar(
        title: Text(l10n.userQuestionsTitle),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: asyncPage.when(
        loading: () => const _LoadingList(),
        error: (_, __) => HbErrorView(
          title: l10n.commonErrorTitle,
          message: l10n.userQuestionsLoadError,
          onRetry: _onRefresh,
        ),
        data: (page) {
          if (page.items.isEmpty) {
            return RefreshIndicator(
              color: HbColors.brandPrimary,
              onRefresh: _onRefresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: HbEmptyState(
                      icon: Icons.question_answer_outlined,
                      title: l10n.userQuestionsEmptyTitle,
                      message: l10n.userQuestionsEmptyBody,
                      actionLabel: l10n.userQuestionsExploreEvents,
                      onAction: () => context.go('/'),
                    ),
                  ),
                ],
              ),
            );
          }

          final controller =
              ref.read(userQuestionsListControllerProvider.notifier);
          final showFooterLoader = page.hasMore;

          return RefreshIndicator(
            color: HbColors.brandPrimary,
            onRefresh: _onRefresh,
            child: ListView.separated(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              itemCount: page.items.length + (showFooterLoader ? 1 : 0),
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                if (index == page.items.length) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: controller.isLoadingMore
                              ? HbColors.brandPrimary
                              : Colors.grey[300],
                        ),
                      ),
                    ),
                  );
                }
                return UserQuestionCard(question: page.items[index]);
              },
            ),
          );
        },
      ),
    );
  }
}

class _LoadingList extends StatelessWidget {
  const _LoadingList();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => const _SkeletonCard(),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: HbShimmer(width: double.infinity, height: 14)),
              SizedBox(width: 8),
              HbShimmer(width: 70, height: 22, radius: 6),
            ],
          ),
          SizedBox(height: 14),
          HbShimmer(width: double.infinity, height: 12),
          SizedBox(height: 6),
          HbShimmer(width: double.infinity, height: 12),
          SizedBox(height: 6),
          HbShimmer(width: 200, height: 12),
        ],
      ),
    );
  }
}
