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
import '../../data/models/mobile_app_config.dart';
import '../providers/home_providers.dart';
import '../widgets/ads_banners_section.dart';

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
  int _selectedTimeFilter = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Refresh all home screen data
  Future<void> _refreshData() async {
    // Invalidate all providers to force refresh
    ref.invalidate(homeActivitiesProvider);
    ref.invalidate(featuredActivitiesProvider);
    ref.invalidate(categoriesProvider);
    ref.invalidate(homeCitiesProvider);
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
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 60,
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo-header.png',
              width: 120,
              height: 32,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Text('Le Hiboo', style: TextStyle(color: Color(0xFFFF6B35), fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Color(0xFF1E3A8A)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: Color(0xFF1E3A8A)),
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: const Color(0xFFFF6B35),
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
                            color: Color(0xFFFF6B35),
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
                      height: 400,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: activities.length,
                        itemBuilder: (context, index) {
                          final activity = activities[index];
                          return Container(
                            width: 260,
                            margin: const EdgeInsets.only(right: 16),
                            child: EventCard(activity: activity),
                          );
                        },
                      ),
                    );
                  },
                  loading: () => const SizedBox(
                    height: 280,
                    child: Center(child: CircularProgressIndicator(color: Color(0xFFFF6B35))),
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
                      colors: [Color(0xFFFF6B35), Color(0xFFFF8B5A)],
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
                          foregroundColor: const Color(0xFFFF6B35),
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
                        color: Color(0xFFFF6B35),
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
                            backgroundColor: const Color(0xFFFF6B35),
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
                  Row(
                    children: [
                      Text(
                        greetingMessage,
                        style: const TextStyle(
                          color: Color(0xFFFF6B35), // Orange Le Hiboo
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
                      const SizedBox(width: 8),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/petit_boo_logo.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const Icon(
                              Icons.face,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
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
                // Barre de recherche cliquable
                GestureDetector(
                  onTap: () => context.push('/search'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFF6B35).withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Color(0xFFFF6B35), size: 22),
                        const SizedBox(width: 12),
                        Text(
                          'Rechercher une activité...',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
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
                        isSelected: _selectedTimeFilter == 0,
                        onTap: () {
                          setState(() => _selectedTimeFilter = 0);
                          filterNotifier.setDateFilter(DateFilterType.today);
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildQuickFilterChip(
                        label: 'Demain',
                        icon: Icons.event,
                        isSelected: _selectedTimeFilter == 1,
                        onTap: () {
                          setState(() => _selectedTimeFilter = 1);
                          filterNotifier.setDateFilter(DateFilterType.tomorrow);
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildQuickFilterChip(
                        label: 'Ce week-end',
                        icon: Icons.weekend,
                        isSelected: _selectedTimeFilter == 2,
                        onTap: () {
                          setState(() => _selectedTimeFilter = 2);
                          filterNotifier.setDateFilter(DateFilterType.thisWeekend);
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildQuickFilterChip(
                        label: 'Gratuit',
                        icon: Icons.local_offer,
                        isSelected: _selectedTimeFilter == 3,
                        onTap: () {
                          setState(() => _selectedTimeFilter = 3);
                          filterNotifier.setOnlyFree(true);
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
                    onPressed: () => context.push('/search'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B35),
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

  /// Section des recherches enregistrées - ne s'affiche que si des recherches existent
  Widget _buildSavedSearchesSection() {
    final savedSearches = ref.watch(savedSearchesProvider);
    final filterNotifier = ref.read(eventFilterProvider.notifier);

    // Ne rien afficher si pas de recherches enregistrées
    if (savedSearches.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Vos recherches',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                ),
              ),
              TextButton(
                onPressed: () {
                  ref.read(savedSearchesProvider.notifier).clearAll();
                },
                child: Text(
                  'Effacer',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: savedSearches.take(5).map((search) {
              return GestureDetector(
                onTap: () {
                  // Appliquer les filtres de la recherche sauvegardée
                  if (search.query.isNotEmpty) {
                    filterNotifier.setSearchQuery(search.query);
                  }
                  if (search.citySlug != null && search.cityName != null) {
                    filterNotifier.setCity(search.citySlug!, search.cityName!);
                  }
                  if (search.thematiqueSlug != null) {
                    filterNotifier.addThematique(search.thematiqueSlug!);
                  }
                  context.push('/events');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE5E5E5)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.history,
                        size: 14,
                        color: Color(0xFFFF6B35),
                      ),
                      const SizedBox(width: 6),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 150),
                        child: Text(
                          search.displayLabel,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF2D3748),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          ref.read(savedSearchesProvider.notifier).removeSearch(search);
                        },
                        child: Icon(
                          Icons.close,
                          size: 14,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
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
          color: isSelected ? const Color(0xFFFF6B35) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? const Color(0xFFFF6B35) : const Color(0xFFE5E5E5),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFFF6B35).withOpacity(0.3),
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

  Widget _buildTimeFilterChip(String label, int index) {
    final isSelected = _selectedTimeFilter == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTimeFilter = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF6B35) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFFF6B35) : const Color(0xFFE5E5E5),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF2D3748),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
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
            loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFFFF6B35))),
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
