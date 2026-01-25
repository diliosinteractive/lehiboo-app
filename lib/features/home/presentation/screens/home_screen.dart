import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lehiboo/features/home/presentation/widgets/event_card.dart';
import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/domain/entities/city.dart';
import 'package:lehiboo/features/blog/presentation/widgets/blog_section.dart';
import 'package:lehiboo/features/thematiques/presentation/widgets/thematiques_section.dart';
import 'package:lehiboo/features/thematiques/presentation/widgets/categories_chips_section.dart';
import 'package:lehiboo/features/home/presentation/providers/home_providers.dart';
import 'package:lehiboo/features/alerts/presentation/providers/alerts_provider.dart';

import '../widgets/ads_banners_section.dart';
import '../../../../core/widgets/feedback/skeleton_event_card.dart';
import '../widgets/home_cities_section.dart';
import 'package:lehiboo/features/home/presentation/providers/user_location_provider.dart';
import 'package:lehiboo/features/gamification/presentation/widgets/hibon_counter_widget.dart';

// New components
import '../widgets/contextual_hero.dart';
import '../widgets/event_stories.dart';
import '../widgets/countdown_event_card.dart';
import '../widgets/personalized_section.dart';
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
    // Invalidate all providers to force refresh
    ref.invalidate(homeActivitiesProvider);
    ref.invalidate(featuredActivitiesProvider);
    ref.invalidate(categoriesProvider);
    ref.invalidate(homeCitiesProvider);
    ref.invalidate(alertsProvider);
    ref.invalidate(mobileAppConfigProvider);
    ref.invalidate(viewedStoriesProvider);

    // Wait a bit for the providers to start refreshing
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    final activitiesAsyncValue = ref.watch(homeActivitiesProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: const Color(0xFFFF601F),
        edgeOffset: 100, // Account for app bar
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // 1. Hero contextuel avec parallax + alertes sauvegardées
            SliverToBoxAdapter(
              child: ContextualHero(
                scrollOffset: _scrollOffset,
                height: 420,
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

            // 5. Section Urgency FOMO (événements qui commencent bientôt)
            const SliverToBoxAdapter(
              child: UrgencySection(),
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
                  _buildActivitySection(
                    context,
                    ref,
                    provider: homeTodayActivitiesProvider,
                    baseTitle: 'Activités disponibles aujourd\'hui',
                    emptyMessage: 'Aucune activité pour aujourd\'hui',
                    viewAllPath: '/search?date=today',
                  ),
                  _buildActivitySection(
                    context,
                    ref,
                    provider: homeTomorrowActivitiesProvider,
                    baseTitle: 'Activités disponibles demain',
                    emptyMessage: 'Aucune activité pour demain',
                    viewAllPath: '/search?date=tomorrow',
                  ),
                  _buildSectionTitle('Les recommandations', '/events'),
                  const SizedBox(height: 16),
                  activitiesAsyncValue.when(
                    data: (activities) {
                      if (activities.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text('Aucune activité trouvée.'),
                        );
                      }
                      return SizedBox(
                        height: 420,
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
                                heroTagPrefix: 'home_main',
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
                      child: Text('Erreur: $err', style: const TextStyle(color: Colors.red)),
                    ),
                  ),
                ],
              ),
            ),

            // 8. Section "Pour vous" (personnalisée)
            const SliverToBoxAdapter(
              child: PersonalizedSection(),
            ),

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
            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // 16. Section Newsletter
            SliverToBoxAdapter(
              child: _buildNewsletterSection(),
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

    return AppBar(
      backgroundColor: Color.lerp(
        Colors.transparent,
        const Color(0xFFFF601F),
        opacity,
      ),
      elevation: 0,
      toolbarHeight: 60,
      title: AnimatedOpacity(
        opacity: opacity,
        duration: const Duration(milliseconds: 150),
        child: Image.asset(
          'assets/images/logo_lehiboo_blanc_x3_2.png',
          width: 120,
          height: 32,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => const Text(
            'Le Hiboo',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.favorite_border,
            color: opacity > 0.5 ? Colors.white : Colors.white,
          ),
          onPressed: () => context.push('/favorites'),
        ),
        IconButton(
          icon: Icon(
            Icons.notifications_none,
            color: opacity > 0.5 ? Colors.white : Colors.white,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(
            Icons.person_outline,
            color: opacity > 0.5 ? Colors.white : Colors.white,
          ),
          onPressed: () => context.push('/profile'),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
          child: GestureDetector(
            onTap: () => context.push('/hibons-dashboard'),
            child: const HibonCounterWidget(compact: true),
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
              color: const Color(0xFF2D3748),
            ),
          ),
          if (viewAllPath != null)
            TextButton(
              onPressed: () => context.push(viewAllPath),
              child: const Text(
                'Voir plus',
                style: TextStyle(
                  color: Color(0xFFFF601F),
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
    required FutureProvider<List<Activity>> provider,
    required String baseTitle,
    required String emptyMessage,
    required String viewAllPath,
  }) {
    final activitiesAsyncValue = ref.watch(provider);
    final userLocationAsync = ref.watch(userLocationProvider);
    final cityName = userLocationAsync.value?.cityName;

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
                    color: const Color(0xFF2D3748),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF2D3748)),
                onPressed: () => context.push(viewAllPath),
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
              height: 420,
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
                      showTimeBadge: true,
                      heroTagPrefix: baseTitle.toLowerCase().contains('demain') ? 'tomorrow' : 'today',
                    ),
                  );
                },
              ),
            );
          },
          loading: () => _buildCarouselSkeleton(),
          error: (err, stack) => const SizedBox.shrink(),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildCarouselSkeleton() {
    return SizedBox(
      height: 420,
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
          colors: [Color(0xFFFF601F), Color(0xFFFF8B5A)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF601F).withOpacity(0.3),
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
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFFFF601F),
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
                      color: const Color(0xFFFF601F).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.location_city,
                      color: Color(0xFFFF601F),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Villes populaires',
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D3748),
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
              color: Colors.black.withOpacity(0.15),
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
                Colors.black.withOpacity(0.7),
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
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 11,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNewsletterSection() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFF601F).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.mail_outline,
              size: 32,
              color: Color(0xFFFF601F),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Nos meilleures découvertes dans votre boîte mail',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Recevez chaque semaine une sélection d\'activités adaptées à vos envies',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            decoration: InputDecoration(
              hintText: 'Votre adresse email',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFFF601F)),
              ),
              prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF601F),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'S\'inscrire',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
