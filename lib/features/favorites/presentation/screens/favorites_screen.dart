import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lehiboo/features/home/presentation/widgets/event_card.dart';
import 'package:lehiboo/features/favorites/presentation/providers/favorites_provider.dart';
import 'package:lehiboo/features/favorites/presentation/providers/favorite_lists_provider.dart';
import 'package:lehiboo/features/events/data/mappers/event_to_activity_mapper.dart';
import '../widgets/favorite_lists_sidebar.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  /// Seuil de largeur pour afficher la sidebar (tablette)
  static const double _tabletBreakpoint = 600;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      body: isTablet ? _buildTabletLayout(ref) : _buildMobileLayout(ref),
    );
  }

  /// Layout tablette avec sidebar
  Widget _buildTabletLayout(WidgetRef ref) {
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
  Widget _buildMobileLayout(WidgetRef ref) {
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
              childAspectRatio: 0.50,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: activities.length,
            itemBuilder: (context, index) {
              return EventCard(
                activity: activities[index],
                isCompact: true,
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
    String title;
    String subtitle;
    IconData icon;

    if (selectedListId == null) {
      // Tous les favoris
      title = 'Aucun favori pour le moment';
      subtitle = 'Ajoutez des événements à vos favoris\npour les retrouver ici';
      icon = Icons.favorite_border;
    } else if (selectedListId == 'uncategorized') {
      // Non classés
      title = 'Aucun favori non classé';
      subtitle = 'Tous vos favoris sont organisés\ndans des listes';
      icon = Icons.folder_off_outlined;
    } else {
      // Liste spécifique
      title = 'Cette liste est vide';
      subtitle = 'Ajoutez des favoris à cette liste\ndepuis le détail d\'un événement';
      icon = Icons.playlist_remove;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: Colors.grey[400]),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
