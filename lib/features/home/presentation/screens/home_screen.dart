import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import '../../../../config/dio_client.dart';
import '../../data/models/mobile_app_config.dart';
import 'package:lehiboo/features/home/presentation/providers/home_providers.dart';
import 'package:lehiboo/features/alerts/presentation/providers/alerts_provider.dart';
import '../providers/home_providers.dart';
import '../widgets/ads_banners_section.dart';
import '../../../../core/widgets/feedback/skeleton_event_card.dart';
import '../widgets/home_cities_section.dart';

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
      backgroundColor: const Color(0xFFF8F8F8),
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

          // Section thématiques (Dynamic from API)
          const SliverToBoxAdapter(
            child: ThematiquesSection(),
          ),

          // Section Activités recommandées (Dynamic from Repository)
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Les recommandations',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
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
                      height: 340, // Reduced from 400
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: activities.length,
                        itemBuilder: (context, index) {
                          final activity = activities[index];
                          return Container(
                            width: 200, // Reduced from 260
                            margin: const EdgeInsets.only(right: 16),
                            child: EventCard(activity: activity, isCompact: true),
                          );
                        },
                      ),
                    );
                  },
                  loading: () => SizedBox(
                    height: 400,
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
                      const Text(
                        'Retrouvez vos événements en toute simplicité',
                        style: TextStyle(
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
                      const Text(
                        'Nos meilleures découvertes dans votre boîte mail',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
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
    final filterNotifier = ref.read(eventFilterProvider.notifier);
    final filterState = ref.watch(eventFilterProvider);
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

    return Container(
      decoration: BoxDecoration(
        // Use image if available, otherwise gradient
        image: hasImage
            ? DecorationImage(
                image: CachedNetworkImageProvider(heroConfig.image),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.4),
                  BlendMode.darken,
                ),
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
      child: Column(
        children: [
          // Texte d'accroche - Dynamic from config
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Message de bienvenue personnalisé pour les utilisateurs connectés
                if (greetingMessage != null) ...[
                  Text(
                    greetingMessage,
                    style: const TextStyle(
                      color: Color(0xFFFF601F), // Orange Le Hiboo
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 3,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                Text(
                  heroConfig.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 3,
                        color: Colors.black45,
                      ),
                    ],
                  ),
                ),
                if (heroConfig.subtitle.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    heroConfig.subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      shadows: const [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 2,
                          color: Colors.black38,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Bloc de recherche
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                // Barre de recherche
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFF601F).withOpacity(0.3)),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: const Icon(Icons.search, color: Color(0xFFFF601F), size: 22),
                      hintText: 'Rechercher une activité...',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 15,
                      ),
                    ),
                    textInputAction: TextInputAction.search,
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        ref.read(eventFilterProvider.notifier).setSearchQuery(value.trim());
                        context.push('/search');
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16),
                // Filtres rapides
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildQuickFilterChip(
                        label: "Aujourd'hui",
                        icon: Icons.today,
                        isSelected: filterState.dateFilterType == DateFilterType.today,
                        onTap: () {
                          if (filterState.dateFilterType == DateFilterType.today) {
                            filterNotifier.clearDateFilter();
                          } else {
                            filterNotifier.setDateFilter(DateFilterType.today);
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildQuickFilterChip(
                        label: 'Demain',
                        icon: Icons.event,
                        isSelected: filterState.dateFilterType == DateFilterType.tomorrow,
                        onTap: () {
                          if (filterState.dateFilterType == DateFilterType.tomorrow) {
                             filterNotifier.clearDateFilter();
                          } else {
                             filterNotifier.setDateFilter(DateFilterType.tomorrow);
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildQuickFilterChip(
                        label: 'Ce week-end',
                        icon: Icons.weekend,
                        isSelected: filterState.dateFilterType == DateFilterType.thisWeekend,
                        onTap: () {
                          if (filterState.dateFilterType == DateFilterType.thisWeekend) {
                            filterNotifier.clearDateFilter();
                          } else {
                            filterNotifier.setDateFilter(DateFilterType.thisWeekend);
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildQuickFilterChip(
                        label: 'Gratuit',
                        icon: Icons.local_offer,
                        isSelected: filterState.onlyFree,
                        onTap: () {
                          filterNotifier.setOnlyFree(!filterState.onlyFree);
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildQuickFilterChip(
                        label: 'Famille',
                        icon: Icons.family_restroom,
                        isSelected: filterState.familyFriendly,
                        onTap: () {
                          filterNotifier.setFamilyFriendly(!filterState.familyFriendly);
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildQuickFilterChip(
                        label: 'En ligne',
                        icon: Icons.computer,
                        isSelected: filterState.onlineOnly,
                        onTap: () {
                          filterNotifier.setOnlineOnly(!filterState.onlineOnly);
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildQuickFilterChip(
                        label: 'Accessible PMR',
                        icon: Icons.accessible,
                        isSelected: filterState.accessiblePMR,
                        onTap: () {
                          filterNotifier.setAccessiblePMR(!filterState.accessiblePMR);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Bouton Rechercher - Dynamic text from config
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_searchController.text.trim().isNotEmpty) {
                        ref.read(eventFilterProvider.notifier).setSearchQuery(_searchController.text.trim());
                        context.push('/search');
                      } else {
                        context.push('/search?openFilter=true');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF601F),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          config.texts.exploreButtonText,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
                   const Text(
                    'Vos recherches',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
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

  Widget _buildQuickFilterChip({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF601F) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? const Color(0xFFFF601F) : const Color(0xFFE5E5E5),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFFF601F).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF2D3748),
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
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
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
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

  Widget _buildCategoryCard(String title, String imageUrl, IconData icon) {
    return GestureDetector(
      onTap: () => context.push('/events?category=$title'),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
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
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



}
