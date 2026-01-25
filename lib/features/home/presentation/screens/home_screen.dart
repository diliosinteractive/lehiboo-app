import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:lehiboo/features/search/presentation/providers/filter_provider.dart';
import 'package:lehiboo/features/search/domain/models/event_filter.dart';
import 'package:lehiboo/features/search/presentation/widgets/home_search_pill.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import '../../../../config/dio_client.dart';
import '../../data/models/mobile_app_config.dart';
import 'package:lehiboo/features/home/presentation/providers/home_providers.dart';
import 'package:lehiboo/features/alerts/presentation/providers/alerts_provider.dart';

import '../widgets/ads_banners_section.dart';
import '../../../../core/widgets/feedback/skeleton_event_card.dart';
import '../widgets/home_cities_section.dart';
import 'package:lehiboo/features/home/presentation/providers/user_location_provider.dart';
import 'package:lehiboo/features/gamification/presentation/widgets/hibon_counter_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
// ... existing code ...

// Methods moved to State class
// ... rest of file
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
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

    // Wait a bit for the providers to start refreshing
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    // Watch the future provider - now using real API
    final activitiesAsyncValue = ref.watch(homeActivitiesProvider);

    return Scaffold(
      // backgroundColor removed to inherit from Theme (HbColors.orangePastel)
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF601F), // Brand Orange
        elevation: 0,
        toolbarHeight: 60,
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo_lehiboo_blanc_x3_2.png',
              width: 120,
              height: 32,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Text('Le Hiboo', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.white),
            onPressed: () => context.push('/favorites'),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.white),
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
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: const Color(0xFFFF601F),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
          // Hero section avec recherche intégrée
          SliverToBoxAdapter(
            child: _buildHeroSearchSection(),
          ),

          // Section Recherches enregistrées (seulement si des recherches existent)
          SliverToBoxAdapter(
            child: _buildSavedSearchesSection(),
          ),

          // Section Filtre par Ville
          const SliverToBoxAdapter(
            child: HomeCitiesSection(),
          ),

          // Section Publicités dynamiques depuis WordPress (au-dessus des thématiques)
          const SliverToBoxAdapter(
            child: AdsBannersSection(),
          ),



          // Section Activités recommandées (Dynamic from Repository)
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Les recommandations',
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2D3748),
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.push('/events'),
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
                ),
                const SizedBox(height: 16),
                // Use AsyncValue from Riverpod
                activitiesAsyncValue.when(
                  data: (activities) {
                    if (activities.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text('Aucune activité trouvée.'),
                      );
                    }
                    return SizedBox(
                      height: 420, // Increased from 340 to 420 to fit new EventCard design
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: activities.length,
                        itemBuilder: (context, index) {
                          final activity = activities[index];
                          return Container(
                            width: 200, // Reduced from 260
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
                  loading: () => SizedBox(
                    height: 420,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 260,
                          margin: const EdgeInsets.only(right: 16),
                          child: const SkeletonEventCard(),
                        );
                      },
                    ),
                  ),
                  error: (err, stack) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text('Erreur: $err', style: const TextStyle(color: Colors.red)),
                  ),
                ),
              ],
            ),
          ),

          // Section thématiques (Dynamic from API)
          const SliverToBoxAdapter(
            child: ThematiquesSection(),
          ),

          // Section Toutes les catégories (Chips list)
          const SliverToBoxAdapter(
            child: CategoriesChipsSection(),
          ),

          // Section Web/Retrouvez-nous
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF601F), Color(0xFFFF8B5A)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
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
                ),
              ),

              // Section Top 6 des villes
              SliverToBoxAdapter(
                child: _buildTopCitiesSection(),
              ),

              // Section Articles (Dynamic from API)
              const SliverToBoxAdapter(
                child: BlogSection(),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // Section Newsletter
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F8F8),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE5E5E5)),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.mail_outline,
                        size: 48,
                        color: Color(0xFFFF601F),
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
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
                          ),
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
                              borderRadius: BorderRadius.circular(8),
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
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSearchSection() {
    final configAsyncValue = ref.watch(mobileAppConfigProvider);
    final currentUser = ref.watch(currentUserProvider);

    // Get config or default
    final config = configAsyncValue.valueOrNull ?? MobileAppConfig.defaultConfig();
    final heroConfig = config.hero;
    final hasImage = heroConfig.image.isNotEmpty;

    // Build personalized greeting for logged-in users
    String? greetingMessage;
    if (currentUser != null && currentUser.firstName != null && currentUser.firstName!.isNotEmpty) {
      final hour = DateTime.now().hour;
      String greeting;
      if (hour < 12) {
        greeting = 'Bonjour';
      } else if (hour < 18) {
        greeting = 'Bon après-midi';
      } else {
        greeting = 'Bonsoir';
      }
      greetingMessage = '$greeting ${currentUser.firstName} !';
    }

    return Stack(
      children: [
        // Layer 1: Background Image or Gradient (Bottom)
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              image: hasImage
                  ? DecorationImage(
                      image: CachedNetworkImageProvider(heroConfig.image),
                      fit: BoxFit.cover,
                    )
                  : null,
              gradient: hasImage
                  ? null
                  : const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF1E3A8A), // Bleu foncé
                        Color(0xFF3B82F6), // Bleu clair
                      ],
                    ),
            ),
          ),
        ),

        // Layer 2: Black Gradient Overlay (Middle)
        if (hasImage)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.7), // Strong darkness at top
                    Colors.black.withOpacity(0.3),
                    Colors.transparent, // Clear at bottom
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

        // Layer 3: Content (Top)
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Texte d'accroche - Dynamic from config
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 140, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Message de bienvenue personnalisé pour les utilisateurs connectés
                  if (greetingMessage != null) ...[
                    Text(
                      greetingMessage,
                      style: GoogleFonts.montserrat(
                        color: const Color(0xFFFF601F), // Orange Le Hiboo
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        shadows: [
                          Shadow(
                            offset: const Offset(0, 1),
                            blurRadius: 4,
                            color: Colors.black.withOpacity(0.8),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  Text(
                    heroConfig.title,
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                      shadows: [
                        Shadow(
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                          color: Colors.black.withOpacity(0.9),
                        ),
                      ],
                    ),
                  ),
                  if (heroConfig.subtitle.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      heroConfig.subtitle,
                      style: GoogleFonts.montserrat(
                        color: Colors.white.withOpacity(0.95),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        shadows: [
                          Shadow(
                            offset: const Offset(0, 1),
                            blurRadius: 3,
                            color: Colors.black.withOpacity(0.8),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Airbnb-style search pill
            const HomeSearchPill(),

            const SizedBox(height: 20),
          ],
        ),
      ],
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
                    // Add Highlight effect like in screenshot? 
                    // For now, user just asked for the sections.
                    // To do "highlight" style we would need a Stack/Container behind text.
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton( // Arrow or "Voir tout"
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
              // Hide section if empty? Or show message? 
              // User said "put 10". If 0, maybe hide to avoid clutter.
              // But let's show empty message for clarity during dev.
              return SizedBox.shrink(); 
              /* return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(emptyMessage, style: TextStyle(color: Colors.grey[600])),
              ); */
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
          loading: () => SizedBox(
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
          ),
          error: (err, stack) => SizedBox.shrink(), // Silent error
        ),
        const SizedBox(height: 24), // Spacing between sections
      ],
    );
  }

  /// Section des recherches enregistrées
  Widget _buildSavedSearchesSection() {
    final alertsAsync = ref.watch(alertsProvider);
    final filterNotifier = ref.read(eventFilterProvider.notifier);

    return alertsAsync.when(
      data: (alerts) {
        if (alerts.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text(
                    'Vos recherches',
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D3748),
                    ),
                  ),
                  // "Effacer tout" feature might not be directly supported by batch delete API yet
                  // but we can imply iterate delete or hide button if not supported.
                  // For now, hiding "Effacer tout" as it's dangerous without batch API.
                ],
              ),
            ),
            SizedBox(
              height: 44, // Fixed height for chips
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: alerts.length,
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final alert = alerts[index];
                  final label = alert.name;
                  final hasAlert = alert.enablePush;
                  
                  return GestureDetector(
                    onTap: () {
                      // Apply filters from Alert
                      filterNotifier.applyFilters(alert.filter);
                      context.push('/search');
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: hasAlert
                              ? const Color(0xFFFF601F).withOpacity(0.3) 
                              : const Color(0xFFE5E5E5),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            hasAlert ? Icons.notifications_active_outlined : Icons.history,
                            size: 16,
                            color: hasAlert ? const Color(0xFFFF601F) : Colors.grey[600],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: hasAlert ? const Color(0xFFFF601F) : const Color(0xFF2D3748),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 1,
                            height: 16,
                            color: Colors.grey[300],
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                          GestureDetector(
                            onTap: () {
                              ref.read(alertsProvider.notifier).deleteAlert(alert.id);
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (err, stack) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.red.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Icon(Icons.cloud_off, size: 20, color: Colors.red[400]),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Service indisponible momentanément",
                  style: TextStyle(color: Colors.red[700], fontSize: 13),
                ),
              ),
              TextButton(
                onPressed: () => ref.refresh(alertsProvider),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  foregroundColor: Colors.red[700],
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Colors.red.withOpacity(0.2)),
                  ),
                ),
                child: const Text("Réessayer", style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopCitiesSection() {
    final citiesAsyncValue = ref.watch(homeCitiesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Top 6 des villes',
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2D3748),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 200,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: citiesAsyncValue.when(
            data: (cities) => GridView.builder(
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
            loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFFFF601F))),
            error: (err, stack) => Text('Erreur: $err', maxLines: 1),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildCityCard(City city) {
    return GestureDetector(
      onTap: () => context.push('/city/${city.slug}'),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: NetworkImage(city.imageUrl ?? 'https://placehold.co/200'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.6),
              ],
            ),
          ),
          alignment: Alignment.bottomLeft,
          padding: const EdgeInsets.all(8),
          child: Text(
            city.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

}
