import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/themes/colors.dart';
import '../../../../core/widgets/feedback/hb_feedback.dart';
import '../../domain/entities/user_review.dart';
import '../providers/reviews_actions_provider.dart';
import '../providers/user_reviews_provider.dart';
import '../widgets/delete_review_dialog.dart';
import '../widgets/user_review_card.dart';
import '../widgets/write_review_sheet.dart';

/// Écran "Mes Avis" — liste paginée des avis de l'utilisateur, tous statuts
/// confondus (pending / approved / rejected).
class MyReviewsScreen extends ConsumerStatefulWidget {
  /// UUID d'un avis à mettre en évidence (depuis push notification).
  final String? highlightReviewUuid;

  const MyReviewsScreen({super.key, this.highlightReviewUuid});

  @override
  ConsumerState<MyReviewsScreen> createState() => _MyReviewsScreenState();
}

class _MyReviewsScreenState extends ConsumerState<MyReviewsScreen> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _itemKeys = {};
  bool _highlightScrolled = false;

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
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(userReviewsProvider.notifier).loadMore();
    }
  }

  Future<void> _handleEdit(UserReview review) async {
    final updated = await WriteReviewSheet.showEdit(
      context,
      review: review,
      eventSlug: review.eventSlug,
      eventTitle: review.eventTitle,
    );
    if (updated != null) {
      // L'action provider invalide déjà — refresh explicite par sécurité.
      ref.read(userReviewsProvider.notifier).refresh();
    }
  }

  Future<void> _handleDelete(UserReview review) async {
    final confirmed = await DeleteReviewDialog.show(context);
    if (!confirmed || !mounted) return;

    final result = await ref.read(reviewsActionsProvider.notifier).deleteReview(
          reviewUuid: review.uuid,
          eventSlug: review.eventSlug,
        );

    if (!mounted) return;

    switch (result) {
      case ReviewActionSuccess():
        ref.read(userReviewsProvider.notifier).removeLocal(review.uuid);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Avis supprimé'),
            backgroundColor: Colors.green,
          ),
        );
      case ReviewActionFailure(message: final msg):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg),
            backgroundColor: Colors.red,
          ),
        );
    }
  }

  void _scrollToHighlightIfNeeded(List<UserReview> items) {
    if (_highlightScrolled || widget.highlightReviewUuid == null) return;
    final target = items.indexWhere((r) => r.uuid == widget.highlightReviewUuid);
    if (target == -1) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final key = _itemKeys[widget.highlightReviewUuid!];
      final ctx = key?.currentContext;
      if (ctx != null && mounted) {
        Scrollable.ensureVisible(
          ctx,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          alignment: 0.1,
        );
        _highlightScrolled = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userReviewsProvider);
    final items = state.items;

    if (items.isNotEmpty) _scrollToHighlightIfNeeded(items);

    return Scaffold(
      backgroundColor: HbColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Mes Avis'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: HbColors.textPrimary,
      ),
      body: RefreshIndicator(
        color: HbColors.brandPrimary,
        onRefresh: () => ref.read(userReviewsProvider.notifier).refresh(),
        child: _buildBody(state),
      ),
    );
  }

  Widget _buildBody(UserReviewsState state) {
    if (state.isLoading && state.items.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: HbColors.brandPrimary),
      );
    }

    if (state.error != null && state.items.isEmpty) {
      return ListView(
        children: [
          const SizedBox(height: 80),
          HbErrorView(
            message: state.error!,
            onRetry: () => ref.read(userReviewsProvider.notifier).refresh(),
          ),
        ],
      );
    }

    if (state.isEmpty) {
      return ListView(
        children: const [
          SizedBox(height: 80),
          HbEmptyState(
            icon: Icons.rate_review_outlined,
            title: 'Aucun avis',
            message:
                'Vous n\'avez encore laissé aucun avis. Une fois un événement '
                'terminé, vous pourrez partager votre expérience !',
          ),
        ],
      );
    }

    final items = state.items;
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: items.length + (state.hasMore || state.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= items.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: CircularProgressIndicator(color: HbColors.brandPrimary),
            ),
          );
        }
        final review = items[index];
        final key = _itemKeys.putIfAbsent(review.uuid, () => GlobalKey());
        final isHighlighted = widget.highlightReviewUuid == review.uuid;

        return Padding(
          key: key,
          padding: const EdgeInsets.only(bottom: 12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 800),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: isHighlighted
                  ? [
                      BoxShadow(
                        color: HbColors.brandPrimary.withValues(alpha: 0.3),
                        blurRadius: 12,
                      ),
                    ]
                  : null,
            ),
            child: UserReviewCard(
              review: review,
              onTap: review.eventSlug.isNotEmpty
                  ? () => context.push('/event/${review.eventSlug}')
                  : null,
              onEdit: () => _handleEdit(review),
              onDelete: () => _handleDelete(review),
            ),
          ),
        );
      },
    );
  }
}
