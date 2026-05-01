import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/themes/colors.dart';
import '../../data/models/organizer_profile_dto.dart';
import '../providers/organizer_profile_providers.dart';
import '../widgets/organizer_about_section.dart';
import '../widgets/organizer_action_bar.dart';
import '../widgets/organizer_activities_tab.dart';
import '../widgets/organizer_avatar.dart';
import '../widgets/organizer_coordinates_panel.dart';
import '../widgets/organizer_identity_card.dart';
import '../widgets/organizer_reviews_tab.dart';

/// Public organizer profile screen — implements
/// `docs/ORGANIZER_PROFILE_MOBILE_SPEC.md`.
///
/// [identifier] is the organizer slug or UUID. The four organizer endpoints
/// accept either; mobile sends the UUID for stability.
class OrganizerProfileScreen extends ConsumerStatefulWidget {
  final String identifier;

  const OrganizerProfileScreen({super.key, required this.identifier});

  @override
  ConsumerState<OrganizerProfileScreen> createState() =>
      _OrganizerProfileScreenState();
}

class _OrganizerProfileScreenState
    extends ConsumerState<OrganizerProfileScreen> {
  bool _coordinatesOpen = false;

  @override
  Widget build(BuildContext context) {
    if (widget.identifier.trim().isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Identifiant organisateur invalide')),
      );
    }

    final profileAsync =
        ref.watch(organizerProfileFutureProvider(widget.identifier));

    return Scaffold(
      backgroundColor: Colors.white,
      body: profileAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: HbColors.brandPrimary),
        ),
        error: (e, _) => _ErrorState(onBack: () => context.pop()),
        data: (organizer) => _Content(
          organizer: organizer,
          coordinatesOpen: _coordinatesOpen,
          onCoordinatesToggle: (open) =>
              setState(() => _coordinatesOpen = open),
          onRefresh: () async {
            ref.invalidate(
                organizerProfileFutureProvider(widget.identifier));
            ref.invalidate(
                organizerEventsControllerProvider(widget.identifier));
            await ref.read(
                organizerProfileFutureProvider(widget.identifier).future);
          },
        ),
      ),
    );
  }
}

class _Content extends ConsumerWidget {
  final OrganizerProfileDto organizer;
  final bool coordinatesOpen;
  final ValueChanged<bool> onCoordinatesToggle;
  final Future<void> Function() onRefresh;

  const _Content({
    required this.organizer,
    required this.coordinatesOpen,
    required this.onCoordinatesToggle,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final followAsync =
        ref.watch(followStateControllerProvider(organizer.uuid));
    final liveFollowers =
        followAsync.valueOrNull?.followersCount ?? organizer.followersCount;

    final displayName = organizer.displayName?.isNotEmpty ?? false
        ? organizer.displayName!
        : organizer.name;

    return DefaultTabController(
      length: 2,
      child: RefreshIndicator(
        color: HbColors.brandPrimary,
        onRefresh: onRefresh,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: _CoverHeader(
                coverImage: organizer.coverImage,
                avatarLogoUrl: organizer.logo,
                avatarFallbackName: displayName,
              ),
            ),
            SliverToBoxAdapter(
              child: OrganizerIdentityCard(
                organizer: organizer,
                liveFollowersCount: liveFollowers,
              ),
            ),
            SliverToBoxAdapter(
              child: OrganizerAboutSection(organizer: organizer),
            ),
            SliverToBoxAdapter(
              child: OrganizerActionBar(
                organizer: organizer,
                coordinatesOpen: coordinatesOpen,
                onCoordinatesToggle: onCoordinatesToggle,
              ),
            ),
            if (coordinatesOpen)
              SliverToBoxAdapter(
                child: OrganizerCoordinatesPanel(organizer: organizer),
              ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _TabBarDelegate(
                const TabBar(
                  isScrollable: false,
                  indicatorColor: HbColors.brandPrimary,
                  indicatorWeight: 3,
                  labelColor: HbColors.brandPrimary,
                  unselectedLabelColor: Colors.grey,
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  tabs: [
                    Tab(text: 'Activités'),
                    Tab(text: 'Avis'),
                  ],
                ),
              ),
            ),
          ],
          body: TabBarView(
            children: [
              OrganizerActivitiesTab(organizerIdentifier: organizer.uuid),
              OrganizerReviewsTab(organizerIdentifier: organizer.uuid),
            ],
          ),
        ),
      ),
    );
  }
}

/// Cover image header with a fade-to-white gradient at the bottom and a
/// circular avatar overlapping its bottom edge by half — the classic
/// social-profile composition.
class _CoverHeader extends StatelessWidget {
  static const double _coverHeight = 200;
  static const double _avatarSize = 96;
  static const double _avatarOverlap = _avatarSize / 2;

  final String? coverImage;
  final String? avatarLogoUrl;
  final String avatarFallbackName;

  const _CoverHeader({
    required this.coverImage,
    required this.avatarLogoUrl,
    required this.avatarFallbackName,
  });

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    return SizedBox(
      height: _coverHeight + _avatarOverlap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Cover image (or brand gradient when missing).
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: _coverHeight,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (coverImage != null && coverImage!.isNotEmpty)
                  CachedNetworkImage(
                    imageUrl: coverImage!,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => _gradientFallback(),
                  )
                else
                  _gradientFallback(),
                // Bottom fade-to-white gradient — softens the cover edge and
                // keeps the avatar/identity boundary readable.
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0, 0.6, 1.0],
                      colors: [
                        Colors.transparent,
                        Colors.white.withValues(alpha: 0.0),
                        Colors.white,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Back button — sits over the cover, not pinned.
          Positioned(
            top: topInset + 8,
            left: 8,
            child: Material(
              color: Colors.white,
              shape: const CircleBorder(),
              elevation: 2,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => context.pop(),
              ),
            ),
          ),
          // Avatar overlapping the cover bottom by 50%.
          Positioned(
            left: 20,
            top: _coverHeight - _avatarOverlap,
            child: OrganizerAvatar(
              logoUrl: avatarLogoUrl,
              fallbackName: avatarFallbackName,
              size: _avatarSize,
            ),
          ),
        ],
      ),
    );
  }

  Widget _gradientFallback() => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              HbColors.brandPrimary,
              HbColors.brandPrimaryDark,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      );
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _TabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_TabBarDelegate oldDelegate) =>
      oldDelegate.tabBar != tabBar;
}

class _ErrorState extends StatelessWidget {
  final VoidCallback onBack;
  const _ErrorState({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 56, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Impossible de charger ce profil.',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back),
              label: const Text('Retour'),
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
