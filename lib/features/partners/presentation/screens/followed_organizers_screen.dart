import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/themes/colors.dart';
import '../providers/followed_organizers_providers.dart';
import '../widgets/followed_organizer_tile.dart';

/// "Organisateurs suivis" screen — paginated list of the authed user's
/// followed organizers (spec §6bis). Each row exposes an inline unfollow
/// action; tapping the row navigates to the organizer's profile.
class FollowedOrganizersScreen extends ConsumerStatefulWidget {
  const FollowedOrganizersScreen({super.key});

  @override
  ConsumerState<FollowedOrganizersScreen> createState() =>
      _FollowedOrganizersScreenState();
}

class _FollowedOrganizersScreenState
    extends ConsumerState<FollowedOrganizersScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 240) {
      ref.read(followedOrganizersControllerProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(followedOrganizersControllerProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // Style on the Text widget (not on AppBar.titleTextStyle) so it
        // *merges* with the theme's Montserrat instead of replacing it.
        title: const Text(
          'Organisateurs suivis',
          style: TextStyle(
            color: HbColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        iconTheme: const IconThemeData(color: HbColors.textPrimary),
      ),
      body: asyncState.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: HbColors.brandPrimary),
        ),
        error: (e, _) => _ErrorState(
          onRetry: () =>
              ref.read(followedOrganizersControllerProvider.notifier).refresh(),
        ),
        data: (state) {
          if (state.items.isEmpty) {
            return const _EmptyState();
          }
          return RefreshIndicator(
            color: HbColors.brandPrimary,
            onRefresh: () =>
                ref.read(followedOrganizersControllerProvider.notifier).refresh(),
            child: ListView.separated(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(top: 4, bottom: 24),
              itemCount: state.items.length + (state.isLoadingMore ? 1 : 0),
              separatorBuilder: (_, __) => Divider(
                height: 1,
                thickness: 1,
                color: Colors.grey[100],
                indent: 20,
                endIndent: 20,
              ),
              itemBuilder: (context, index) {
                if (index == state.items.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: HbColors.brandPrimary,
                      ),
                    ),
                  );
                }
                final org = state.items[index];
                return FollowedOrganizerTile(
                  organizer: org,
                  onUnfollowTap: () => ref
                      .read(followedOrganizersControllerProvider.notifier)
                      .unfollow(org.uuid),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite_outline, size: 56, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Vous ne suivez aucun organisateur',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: HbColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Suivez un organisateur depuis sa page pour le retrouver ici.',
              textAlign: TextAlign.center,
              style: GoogleFonts.figtree(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final VoidCallback onRetry;

  const _ErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 56, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Impossible de charger la liste.',
              style: GoogleFonts.figtree(
                fontSize: 16,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: HbColors.brandPrimary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
