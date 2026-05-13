import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/features/home/presentation/widgets/event_card.dart';
import 'package:lehiboo/features/events/domain/entities/popular_city.dart';
import 'package:lehiboo/features/blog/presentation/widgets/blog_section.dart';
import 'package:lehiboo/features/thematiques/presentation/widgets/thematiques_section.dart';
import 'package:lehiboo/features/thematiques/presentation/widgets/categories_chips_section.dart';
import 'package:lehiboo/features/home/presentation/providers/home_providers.dart';
import 'package:lehiboo/features/home/presentation/providers/hero_slides_provider.dart';
import 'package:lehiboo/features/alerts/presentation/providers/alerts_provider.dart';
import 'package:lehiboo/features/messages/presentation/providers/unread_count_provider.dart';
import 'package:lehiboo/features/notifications/presentation/providers/in_app_notifications_provider.dart';
import 'package:lehiboo/features/stories/presentation/providers/stories_provider.dart';

import '../widgets/ads_banners_section.dart';
import '../../../../core/widgets/feedback/skeleton_event_card.dart';
import '../widgets/home_cities_section.dart';
import 'package:lehiboo/features/gamification/presentation/widgets/hibon_counter_widget.dart';
import 'package:lehiboo/features/booking/presentation/providers/order_cart_provider.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/core/utils/guest_guard.dart';
import 'package:lehiboo/core/utils/api_response_handler.dart';
import 'package:lehiboo/features/blog/presentation/providers/blog_providers.dart';

// New components
import '../widgets/contextual_hero.dart';
import '../widgets/event_stories.dart';
import '../widgets/countdown_event_card.dart';
// Legacy client-side "Pour vous" — superseded by the server-driven
// PersonalizedFeedSection (PERSONALIZED_FEED_MOBILE_SPEC.md). Kept commented
// for reference only.
// import '../widgets/personalized_section.dart';
import '../../../memberships/presentation/providers/personalized_feed_provider.dart';
import '../../../memberships/presentation/widgets/personalized_feed_section.dart';
// Les imports suivants sont commentés car les sections sont désactivées en attendant l'API backend
// import '../widgets/native_ad_card.dart';
// import '../widgets/partner_highlight.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0;

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
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
  }

  /// Refresh all home screen data
  Future<void> _refreshData() async {
    // Refresh only independent providers in parallel.
    // Derived feed providers auto-rebuild via ref.watch(homeFeedProvider.future)
    // when homeFeed completes.
    await Future.wait([
      ref.read(homeFeedProvider.notifier).refresh(),
      ref.read(homeNewActivitiesProvider.notifier).refresh(),
      ref.read(activeStoriesProvider.notifier).refresh(),
      ref.read(categoriesProvider.notifier).refresh(),
      ref.read(homeCitiesProvider.notifier).refresh(),
      ref.read(popularCitiesProvider.notifier).refresh(),
      ref.read(mobileAppConfigProvider.notifier).refresh(),
      ref.read(heroSlidesProvider.notifier).refresh(),
      ref.read(inAppNotificationsProvider.notifier).refreshUnreadCount(),
    ]);
    ref.invalidate(alertsProvider);
    ref.invalidate(viewedStoriesProvider);
    ref.invalidate(latestBlogPostsProvider);
    // `personalizedFeedProvider` is a FutureProvider (not an
    // AsyncNotifierProvider), so refresh via invalidate to actually
    // re-trigger the fetch on pull-to-refresh.
    ref.invalidate(personalizedFeedProvider);
  }

  @override
  Widget build(BuildContext context) {
    final newActivitiesAsyncValue = ref.watch(homeNewActivitiesProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: HbColors.brandPrimary,
        edgeOffset: 100, // Account for app bar
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // 1. Hero contextuel avec parallax + alertes sauvegardées.
            // Editorial hero slides (when present) drive the carousel
            // background; on cold start / empty / error the static
            // city-themed image renders instead — see ContextualHero.
            SliverToBoxAdapter(
              child: ContextualHero(
                scrollOffset: _scrollOffset,
                height: 420,
                slides: ref.watch(heroSlidesProvider).valueOrNull,
              ),
            ),

            // 2. Stories (événements trending) - sur fond blanc
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                child: const EventStories(),
              ),
            ),

            // 3. Section Filtre par Ville (chips)
            const SliverToBoxAdapter(
              child: HomeCitiesSection(),
            ),

            // 5. "Pour vous" — server-driven personalized carousel.
            // Spec MEMBERSHIPS §11. Hidden when unauthenticated or empty.
            const SliverToBoxAdapter(
              child: PersonalizedFeedSection(),
            ),

            // 6. Section Publicités dynamiques
            const SliverToBoxAdapter(
              child: AdsBannersSection(),
            ),

            // 7. Sections activités (nearby availability and new events)
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Urgency FOMO — événements qui commencent bientôt.
                  const UrgencySection(),
                  _buildNearbyAvailableSection(context, ref),
                  _buildSectionTitle(
                      'Nouveautés', '/explore?sort=published_at'),
                  const SizedBox(height: 16),
                  newActivitiesAsyncValue.when(
                    data: (activities) {
                      if (activities.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text('Aucune nouveauté trouvée.'),
                        );
                      }
                      return SizedBox(
                        height: 360,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: activities.length,
                          itemBuilder: (context, index) {
                            final activity = activities[index];
                            return Container(
                              width: 200,
                              margin: const EdgeInsets.only(right: 16),
                              child: EventCard(
                                activity: activity,
                                heroTagPrefix: 'home_new',
                                isCompact: true,
                              ),
                            );
                          },
                        ),
                      );
                    },
                    loading: () => _buildCarouselSkeleton(),
                    error: (err, stack) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        ApiResponseHandler.extractError(err),
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 8. Section "Pour vous" (personnalisée) — legacy client-side
            // scoring, replaced by server-driven PersonalizedFeedSection above.
            // const SliverToBoxAdapter(
            //   child: PersonalizedSection(),
            // ),

            // 9. Section thématiques
            const SliverToBoxAdapter(
              child: ThematiquesSection(),
            ),

            // 10. Section Partenaire Premium (masquée en attendant l'API backend)
            // TODO: Réactiver quand l'API partners sera disponible
            // const SliverToBoxAdapter(
            //   child: PartnerHighlightSection(),
            // ),

            // 11. Section Toutes les catégories (Chips list)
            const SliverToBoxAdapter(
              child: CategoriesChipsSection(),
            ),

            // 12. Pub Native (masquée en attendant l'intégration backend)
            // TODO: Réactiver quand les pubs natives seront configurées via l'API
            // const SliverToBoxAdapter(
            //   child: NativeAdSection(),
            // ),

            // 13. Section Web/Retrouvez-nous (CTA) — temporarily hidden
            // SliverToBoxAdapter(
            //   child: _buildWebCTASection(),
            // ),

            // 14. Section Villes populaires
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverToBoxAdapter(
              child: _buildTopCitiesSection(),
            ),

            // 15. Section Blog
            const SliverToBoxAdapter(
              child: BlogSection(),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    // Calculate app bar opacity based on scroll
    final opacity = (_scrollOffset / 100).clamp(0.0, 1.0);
    final cartCount = ref
        .watch(orderCartProvider)
        .fold<int>(0, (sum, item) => sum + item.quantity);
    final user = ref.watch(authProvider).user;
    final avatarUrl = user?.avatarUrl;
    final notificationCount = ref.watch(
      inAppNotificationsProvider.select((state) => state.unreadCount),
    );

    return AppBar(
      backgroundColor: HbColors.brandPrimary.withValues(alpha: opacity),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      toolbarHeight: 60,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/logo_picto_lehiboo_old.png',
            width: 30,
            height: 35,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Text(
              'Le Hiboo',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => context.push('/hibons-dashboard'),
            child: const HibonCounterWidget(compact: true),
          ),
        ],
      ),
      titleSpacing: 8,
      actions: [
        IconButton(
          icon: const Icon(Icons.favorite_border, color: Colors.white),
          onPressed: () async {
            final allowed = await GuestGuard.check(
              context: context,
              ref: ref,
              featureName: 'voir vos favoris',
            );
            if (allowed && mounted) {
              context.push('/favorites');
            }
          },
        ),
        Builder(
          builder: (context) {
            final unread = ref.watch(unreadCountProvider);
            return IconButton(
              icon: Badge(
                isLabelVisible: unread > 0,
                label: Text('$unread'),
                child: const Icon(
                  PhosphorIconsRegular.chatCircleDots,
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                final allowed = await GuestGuard.check(
                  context: context,
                  ref: ref,
                  featureName: 'voir vos messages',
                );
                if (allowed && context.mounted) {
                  context.push('/messages');
                }
              },
            );
          },
        ),
        IconButton(
          tooltip: 'Notifications',
          icon: Badge(
            isLabelVisible: notificationCount > 0,
            label: Text('$notificationCount'),
            child: const Icon(Icons.notifications_none, color: Colors.white),
          ),
          onPressed: () async {
            final allowed = await GuestGuard.check(
              context: context,
              ref: ref,
              featureName: 'voir vos notifications',
            );
            if (allowed && mounted) {
              context.push('/notifications');
            }
          },
        ),
        IconButton(
          tooltip: 'Mon panier',
          icon: Badge(
            isLabelVisible: cartCount > 0,
            label: Text('$cartCount'),
            backgroundColor: HbColors.brandPrimary,
            textColor: Colors.white,
            child: const Icon(
              Icons.shopping_bag_outlined,
              color: Colors.white,
            ),
          ),
          onPressed: () => context.push('/cart'),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: IconButton(
            tooltip: 'Mon compte',
            icon: avatarUrl != null && avatarUrl.isNotEmpty
                ? CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(avatarUrl),
                  )
                : const Icon(Icons.person_outline, color: Colors.white),
            onPressed: () async {
              final allowed = await GuestGuard.check(
                context: context,
                ref: ref,
                featureName: 'accéder à votre profil',
              );
              if (allowed && mounted) {
                context.push('/profile');
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, String? viewAllPath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: HbColors.textSlate,
            ),
          ),
          if (viewAllPath != null)
            TextButton(
              onPressed: () => context.push(viewAllPath),
              child: const Text(
                'Voir plus',
                style: TextStyle(
                  color: HbColors.brandPrimary,
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNearbyAvailableSection(BuildContext context, WidgetRef ref) {
    const title = 'Activités disponibles à proximité';
    final activitiesAsyncValue =
        ref.watch(homeNearbyAvailableActivitiesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: HbColors.textSlate,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios,
                    size: 16, color: HbColors.textSlate),
                onPressed: () => context.push('/search'),
              )
            ],
          ),
        ),
        const SizedBox(height: 16),
        activitiesAsyncValue.when(
          data: (activities) {
            if (activities.isEmpty) {
              return const SizedBox.shrink();
            }
            return SizedBox(
              height: 360,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: activities.length,
                itemBuilder: (context, index) {
                  final activity = activities[index];
                  final slotStart = activity.nextSlot?.startDateTime;
                  final now = DateTime.now();
                  return Container(
                    width: 200,
                    margin: const EdgeInsets.only(right: 16),
                    child: EventCard(
                      activity: activity,
                      isCompact: true,
                      isToday: slotStart != null && _isSameDay(slotStart, now),
                      isTomorrow: slotStart != null &&
                          _isSameDay(
                            slotStart,
                            now.add(const Duration(days: 1)),
                          ),
                      heroTagPrefix: 'nearby_available',
                    ),
                  );
                },
              ),
            );
          },
          loading: () => _buildCarouselSkeleton(),
          error: (err, stack) => const SizedBox.shrink(),
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  Widget _buildCarouselSkeleton() {
    return SizedBox(
      height: 360,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            width: 200,
            margin: const EdgeInsets.only(right: 16),
            child: const SkeletonEventCard(),
          );
        },
      ),
    );
  }

  // ignore: unused_element
  Widget _buildWebCTASection() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [HbColors.brandPrimary, HbColors.brandPrimaryLight],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: HbColors.brandPrimary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Retrouvez vos événements en toute simplicité',
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Notre site web offre une expérience complète pour découvrir et réserver vos activités locales.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: HbColors.brandPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Découvrir le site'),
          ),
        ],
      ),
    );
  }

  Widget _buildTopCitiesSection() {
    final resultAsync = ref.watch(popularCitiesProvider);

    return resultAsync.when(
      data: (result) {
        if (result.cities.isEmpty) return const SizedBox.shrink();

        final title = result.isFallback
            ? 'Où ça bouge en ce moment'
            : 'Villes populaires';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: HbColors.brandPrimary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.location_city,
                      color: HbColors.brandPrimary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: HbColors.textSlate,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemCount: result.cities.length,
                itemBuilder: (context, index) {
                  return _buildCityCard(result.cities[index]);
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (err, stack) => const SizedBox.shrink(),
    );
  }

  Widget _buildCityCard(PopularCity city) {
    final imageUrl = city.thumbnailUrl ?? city.imageUrl;

    final cardChild = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: 0.7),
          ],
        ),
      ),
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            city.name,
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );

    return GestureDetector(
      onTap: () => context.push('/city/${city.slug}'),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: imageUrl != null
              ? DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                )
              : null,
          gradient: imageUrl == null
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    HbColors.brandPrimary,
                    HbColors.brandPrimary.withValues(alpha: 0.7),
                  ],
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: cardChild,
      ),
    );
  }
}
