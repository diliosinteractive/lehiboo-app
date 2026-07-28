import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/features/home/presentation/widgets/event_card.dart';
import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/domain/entities/city.dart';
import 'package:lehiboo/features/blog/presentation/widgets/blog_section.dart';
import 'package:lehiboo/features/blog/presentation/providers/blog_providers.dart';
import 'package:lehiboo/features/events/presentation/providers/cities_provider.dart';
import 'package:lehiboo/features/thematiques/presentation/widgets/thematiques_section.dart';
import 'package:lehiboo/features/thematiques/presentation/widgets/categories_chips_section.dart';
import 'package:lehiboo/features/thematiques/presentation/providers/thematiques_provider.dart';
import 'package:lehiboo/features/home/presentation/providers/home_providers.dart';
import 'package:lehiboo/features/home/presentation/providers/hero_slides_provider.dart';
import 'package:lehiboo/features/alerts/presentation/providers/alerts_provider.dart';
import 'package:lehiboo/features/messages/presentation/providers/unread_count_provider.dart';
import 'package:lehiboo/features/stories/presentation/providers/stories_provider.dart';

import '../widgets/ads_banners_section.dart';
import '../../../../core/widgets/feedback/skeleton_event_card.dart';
import '../widgets/home_cities_section.dart';
import 'package:lehiboo/features/home/presentation/providers/user_location_provider.dart';
import 'package:lehiboo/features/gamification/presentation/providers/gamification_provider.dart';
import 'package:lehiboo/features/gamification/presentation/widgets/hibon_counter_widget.dart';
import 'package:lehiboo/features/booking/presentation/providers/order_cart_provider.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/core/utils/guest_guard.dart';
import 'package:lehiboo/core/utils/api_response_handler.dart';

// New components
import '../widgets/contextual_hero.dart';
import '../widgets/event_stories.dart';
import '../widgets/countdown_event_card.dart';
import '../widgets/home_section_feedback.dart';
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

class _HomeScreenState extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver {
  static const _resumeRefreshAfter = Duration(minutes: 15);

  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0;
  DateTime? _lastHomeFeedSuccessAt;
  Future<void>? _refreshInFlight;
  bool _inFlightRefreshesLocation = false;
  int _sessionExpiryGeneration = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scrollController.addListener(_onScroll);
    ref.listenManual<String?>(
      authProvider.select((state) => state.errorMessage),
      _handleAuthError,
      fireImmediately: true,
    );
    ref.listenManual(homeFeedProvider, (_, next) {
      if (next.hasValue && !next.isLoading && !next.hasError) {
        _lastHomeFeedSuccessAt = DateTime.now();
      }
    }, fireImmediately: true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed || _refreshInFlight != null) return;

    final now = DateTime.now();
    final lastSuccessAt = _lastHomeFeedSuccessAt;
    final crossedDateBoundary = lastSuccessAt == null ||
        now.year != lastSuccessAt.year ||
        now.month != lastSuccessAt.month ||
        now.day != lastSuccessAt.day;
    final isStale = lastSuccessAt == null ||
        now.difference(lastSuccessAt) >= _resumeRefreshAfter;

    if (crossedDateBoundary || isStale) {
      // UserLocationNotifier owns its resume recovery. Avoid a duplicate
      // permission/location request while still refreshing other sections.
      unawaited(
        _refreshData(
          refreshLocation: true,
          showFailureFeedback: false,
        ),
      );
    }
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
  }

  void _handleAuthError(String? previous, String? next) {
    if (next != authSessionExpiredMessage || previous == next) return;
    _sessionExpiryGeneration++;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(authSessionExpiredMessage),
            behavior: SnackBarBehavior.floating,
          ),
        );
      ref.read(authProvider.notifier).clearError();
    });
  }

  /// Refresh all home screen data
  Future<void> _refreshData({
    bool refreshLocation = true,
    bool showFailureFeedback = true,
  }) {
    final inFlight = _refreshInFlight;
    if (inFlight != null) {
      if (!refreshLocation || _inFlightRefreshesLocation) return inFlight;

      // A pull-to-refresh arrived during a refresh that does not cover
      // location. Run the explicit refresh after it so the gesture still
      // covers every visible dependency and awaits the real work.
      return inFlight.then((_) => _refreshData());
    }

    _inFlightRefreshesLocation = refreshLocation;
    late final Future<void> refresh;
    refresh = _performRefresh(
      refreshLocation: refreshLocation,
      showFailureFeedback: showFailureFeedback,
    ).whenComplete(() {
      if (identical(_refreshInFlight, refresh)) {
        _refreshInFlight = null;
        _inFlightRefreshesLocation = false;
      }
    });
    _refreshInFlight = refresh;
    return refresh;
  }

  Future<void> _performRefresh({
    required bool refreshLocation,
    required bool showFailureFeedback,
  }) async {
    var didAnyRefreshFail = false;
    final sessionExpiryGeneration = _sessionExpiryGeneration;

    // Resolve location first so the home feed refresh uses current coordinates.
    // UserLocationNotifier deduplicates its own lifecycle refresh, so this also
    // joins a resume-triggered request instead of racing it.
    if (refreshLocation) {
      final locationSucceeded = await _safeRefresh(
        'location',
        () => ref.read(userLocationProvider.notifier).refresh(),
      );
      didAnyRefreshFail = !locationSucceeded;
      if (!mounted) return;
    }

    // Derived activity providers watch homeFeedProvider.future and rebuild
    // automatically. Every other provider below directly feeds a visible
    // home section, so each refresh is started and awaited explicitly.
    final results = await Future.wait([
      _safeRefresh(
        'home feed',
        () => ref.read(homeFeedProvider.notifier).refresh(),
      ),
      _safeRefresh(
        'stories',
        () => ref.read(activeStoriesProvider.notifier).refresh(),
      ),
      _safeRefresh(
        'categories',
        () => ref.read(categoriesProvider.notifier).refresh(),
      ),
      _safeRefresh(
        'city chips',
        () => ref.refresh(citiesProvider.future).then<void>((_) {}),
      ),
      _safeRefresh(
        'popular cities',
        () => ref.read(homeCitiesProvider.notifier).refresh(),
      ),
      _safeRefresh(
        'mobile config',
        () => ref.read(mobileAppConfigProvider.notifier).refresh(),
      ),
      _safeRefresh(
        'hero slides',
        () => ref.read(heroSlidesProvider.notifier).refresh(),
      ),
      _safeRefresh(
        'blog',
        () => ref.refresh(latestBlogPostsProvider.future).then<void>((_) {}),
      ),
      _safeRefresh(
        'thematiques',
        () => ref.refresh(thematiquesProvider.future).then<void>((_) {}),
      ),
      _safeRefresh(
        'personalized feed',
        () => ref.refresh(personalizedFeedProvider.future).then<void>((_) {}),
      ),
      _safeRefresh(
        'alerts',
        () => ref.read(alertsProvider.notifier).loadAlerts(),
      ),
      _safeRefresh(
        'Hibons',
        () async {
          await Future.wait<void>([
            ref.read(gamificationNotifierProvider.notifier).refresh(),
            ref
                .refresh(hibonsBalanceProvider.future)
                .then<void>((_) {}),
          ]);
        },
      ),
      _safeRefresh(
        'unread messages',
        () => ref.read(unreadCountProvider.notifier).refresh(),
      ),
    ]);
    didAnyRefreshFail =
        didAnyRefreshFail || results.any((succeeded) => !succeeded);

    if (!mounted) return;
    if (didAnyRefreshFail &&
        showFailureFeedback &&
        sessionExpiryGeneration == _sessionExpiryGeneration) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              'Certaines données n’ont pas pu être actualisées. '
              'Veuillez réessayer.',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
    }
  }

  Future<bool> _safeRefresh(
    String label,
    Future<void> Function() refresh,
  ) async {
    try {
      await refresh();
      return true;
    } catch (error, stackTrace) {
      debugPrint('Home refresh failed for $label: $error');
      debugPrintStack(stackTrace: stackTrace);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final activitiesAsyncValue = ref.watch(homeActivitiesProvider);

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

            // 7. Sections activités (Today, Tomorrow, Recommended)
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Urgency FOMO — événements qui commencent bientôt.
                  const UrgencySection(),
                  _buildActivitySection(
                    context,
                    ref,
                    provider: homeTodayActivitiesProvider,
                    baseTitle: 'Activités disponibles aujourd\'hui',
                    emptyMessage: 'Aucune activité pour aujourd\'hui',
                    viewAllPath: '/search?date=today',
                    isToday: true,
                  ),
                  _buildActivitySection(
                    context,
                    ref,
                    provider: homeTomorrowActivitiesProvider,
                    baseTitle: 'Activités disponibles demain',
                    emptyMessage: 'Aucune activité pour demain',
                    viewAllPath: '/search?date=tomorrow',
                    isTomorrow: true,
                  ),
                  _buildSectionTitle('Les recommandations', '/recommended'),
                  const SizedBox(height: 16),
                  _buildActivityState(
                    activitiesAsyncValue,
                    emptyMessage:
                        'Aucune recommandation disponible pour le moment.',
                    heroTagPrefix: 'home_main',
                    onRetry: () =>
                        ref.read(homeFeedProvider.notifier).refresh(),
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

            // 13. Section Web/Retrouvez-nous (CTA)
            SliverToBoxAdapter(
              child: _buildWebCTASection(),
            ),

            // 14. Section Villes populaires
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

    return AppBar(
      backgroundColor: Color.lerp(
        Colors.transparent,
        HbColors.brandPrimary,
        opacity,
      ),
      elevation: 0,
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
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
          icon: const Icon(Icons.notifications_none, color: Colors.white),
          onPressed: () {},
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

  Widget _buildActivitySection(
    BuildContext context,
    WidgetRef ref, {
    required ProviderListenable<AsyncValue<List<Activity>>> provider,
    required String baseTitle,
    required String emptyMessage,
    required String viewAllPath,
    bool isToday = false,
    bool isTomorrow = false,
  }) {
    final activitiesAsyncValue = ref.watch(provider);
    final userLocationAsync = ref.watch(userLocationProvider);
    final cityName = userLocationAsync.valueOrNull?.cityName;

    // Construct dynamic title: "Title • City >"
    final title = cityName != null ? '$baseTitle • $cityName' : baseTitle;

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
                onPressed: () => context.push(viewAllPath),
              )
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildActivityState(
          activitiesAsyncValue,
          emptyMessage: emptyMessage,
          heroTagPrefix: isTomorrow ? 'tomorrow' : 'today',
          isToday: isToday,
          isTomorrow: isTomorrow,
          onRetry: () => ref.read(homeFeedProvider.notifier).refresh(),
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  Widget _buildActivityState(
    AsyncValue<List<Activity>> activitiesAsyncValue, {
    required String emptyMessage,
    required String heroTagPrefix,
    required Future<void> Function() onRetry,
    bool isToday = false,
    bool isTomorrow = false,
  }) {
    return activitiesAsyncValue.when(
      skipError: true,
      data: (activities) {
        if (activities.isEmpty) {
          return HomeSectionFeedback(message: emptyMessage);
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
                  isCompact: true,
                  isToday: isToday,
                  isTomorrow: isTomorrow,
                  heroTagPrefix: heroTagPrefix,
                ),
              );
            },
          ),
        );
      },
      loading: _buildCarouselSkeleton,
      error: (error, _) => HomeSectionFeedback(
        message: ApiResponseHandler.extractError(error),
        isError: true,
        onRetry: onRetry,
      ),
    );
  }

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
    final citiesAsyncValue = ref.watch(homeCitiesProvider);

    return citiesAsyncValue.when(
      skipError: true,
      data: (cities) {
        // Masquer la section si aucune ville disponible
        if (cities.isEmpty) return const SizedBox.shrink();

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
                  Text(
                    'Villes populaires',
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: HbColors.textSlate,
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
                itemCount: cities.length,
                itemBuilder: (context, index) {
                  final city = cities[index];
                  return _buildCityCard(city);
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

  Widget _buildCityCard(City city) {
    return GestureDetector(
      onTap: () => context.push('/city/${city.slug}'),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: NetworkImage(city.imageUrl ?? 'https://placehold.co/200'),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Container(
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
              if (city.eventCount != null && city.eventCount! > 0)
                Text(
                  '${city.eventCount} événements',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 11,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
