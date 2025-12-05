import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lehiboo/domain/repositories/activity_repository.dart';
import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/features/home/presentation/widgets/event_card.dart';
import 'package:lehiboo/features/favorites/presentation/providers/favorites_provider.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteIds = ref.watch(favoritesProvider);
    final activityRepository = ref.watch(activityRepositoryProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: const Text('Mes favoris'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: favoriteIds.isEmpty
          ? _buildEmptyState()
          : FutureBuilder<List<Activity>>(
              // Optimally we'd have a getActivitiesByIds method, but for now filtering search results is okay for MVP/Mock
              future: activityRepository.searchActivities(query: ''),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFFFF6B35)));
                }
                
                final allActivities = snapshot.data ?? [];
                final favoriteActivities = allActivities.where((a) => favoriteIds.contains(a.id)).toList();

                if (favoriteActivities.isEmpty) {
                   return _buildEmptyState();
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: favoriteActivities.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    return EventCard(activity: favoriteActivities[index]);
                  },
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'Aucun favori pour le moment',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}