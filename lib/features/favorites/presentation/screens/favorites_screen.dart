import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/features/home/presentation/widgets/event_card.dart';
import 'package:lehiboo/features/favorites/presentation/providers/favorites_provider.dart';
import 'package:lehiboo/features/favorites/presentation/providers/favorite_lists_provider.dart';
import 'package:lehiboo/features/events/data/mappers/event_to_activity_mapper.dart';
import '../widgets/favorite_lists_sidebar.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  /// Seuil de largeur pour afficher la sidebar (tablette)
  static const double _tabletBreakpoint = 600;

  @override
  void initState() {
    super.initState();
    // Refresh les listes ET les favoris à l'arrivée sur la page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(favoriteListsProvider.notifier).refresh();
      ref.read(favoritesProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= _tabletBreakpoint;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Mes favoris'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
      ),
      body: isTablet ? _buildTabletLayout() : _buildMobileLayout(),
    );
  }

  /// Layout tablette avec sidebar
  Widget _buildTabletLayout() {
    return Row(
      children: [
        const FavoriteListsSidebar(),
        const VerticalDivider(width: 1),
        Expanded(
          child: _FavoritesContent(showChips: false),
        ),
      ],
    );
  }

  /// Layout mobile avec chips horizontaux
  Widget _buildMobileLayout() {
    return Column(
      children: [
        const FavoriteListsChips(),
        const Divider(height: 1),
        Expanded(
          child: _FavoritesContent(showChips: false),
        ),
      ],
    );
  }
}

/// Contenu principal de l'écran des favoris (grille d'événements)
class _FavoritesContent extends ConsumerWidget {
  final bool showChips;

  const _FavoritesContent({this.showChips = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Écoute les favoris filtrés par liste sélectionnée
    final favoritesAsync = ref.watch(filteredFavoritesProvider);
    final selectedListId = ref.watch(selectedFavoriteListProvider);

    return favoritesAsync.when(
      data: (favorites) {
        if (favorites.isEmpty) {
          return _buildEmptyState(selectedListId);
        }

        final activities = EventToActivityMapper.toActivities(favorites);

        return RefreshIndicator(
          onRefresh: () async {
            ref.read(favoritesProvider.notifier).refresh();
            ref.read(favoriteListsProvider.notifier).refresh();
          },
          color: const Color(0xFFFF601F),
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.48,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: activities.length,
            itemBuilder: (context, index) {
              return EventCard(
                activity: activities[index],
                isCompact: true,
                fillContainer: true,
              );
            },
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: Color(0xFFFF601F)),
      ),
      error: (error, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'Erreur de chargement',
              style: TextStyle(color: Colors.grey[500]),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.invalidate(favoritesProvider);
                ref.invalidate(favoriteListsProvider);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF601F),
              ),
              child: const Text('Réessayer', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String? selectedListId) {
    final String title;
    final String subtitle;
    final bool showExploreCta;

    if (selectedListId == null) {
      title = 'Aucun favori';
      subtitle =
          'Ajoutez des événements à vos favoris en cliquant sur le cœur pour les retrouver facilement.';
      showExploreCta = true;
    } else if (selectedListId == 'uncategorized') {
      title = 'Aucun favori non classé';
      subtitle = 'Tous vos favoris sont organisés dans des listes.';
      showExploreCta = false;
    } else {
      title = 'Cette liste est vide';
      subtitle =
          'Ajoutez des favoris à cette liste depuis le détail d\'un événement.';
      showExploreCta = false;
    }

    return Builder(
      builder: (context) => Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: HbColors.brandPrimary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.favorite_rounded,
                  size: 56,
                  color: HbColors.brandPrimary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  color: HbColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  color: HbColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              if (showExploreCta) ...[
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.go('/explore'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HbColors.brandPrimary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'Explorer les événements',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
