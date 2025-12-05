import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lehiboo/domain/repositories/activity_repository.dart';
import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/features/home/presentation/widgets/event_card.dart';

class EventListScreen extends ConsumerWidget {
  final String? title;
  final String? filterType;

  const EventListScreen({
    super.key,
    this.title,
    this.filterType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activityRepository = ref.watch(activityRepositoryProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: Text(title ?? 'Explorer les événements'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: FutureBuilder<List<Activity>>(
        future: activityRepository.searchActivities(query: ''), // Fetch all for now
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFFF6B35)));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }
          final activities = snapshot.data ?? [];
          if (activities.isEmpty) {
            return const Center(child: Text('Aucun événement trouvé.'));
          }
          return RefreshIndicator(
            onRefresh: () async {
              // Trigger reload if we were using a provider with state, 
              // but since we call the repository directly here, strictly speaking 
              // we might want to invalidate a provider if we cached it.
              // For now, this is sufficient for the MVP.
              return; 
            },
            color: const Color(0xFFFF6B35),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: activities.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return EventCard(activity: activities[index]);
              },
            ),
          );
        },
      ),
    );
  }
}