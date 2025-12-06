import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lehiboo/domain/entities/city.dart';
import 'package:lehiboo/domain/repositories/activity_repository.dart';
import 'package:lehiboo/features/home/presentation/widgets/event_card.dart';

final cityDetailProvider = FutureProvider.family<City, String>((ref, slug) async {
  final repository = ref.watch(activityRepositoryProvider);
  return repository.getCityBySlug(slug);
});

class CityDetailScreen extends ConsumerWidget {
  final String citySlug;

  const CityDetailScreen({super.key, required this.citySlug});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cityAsyncValue = ref.watch(cityDetailProvider(citySlug));

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: cityAsyncValue.when(
        data: (city) => CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 250.0,
              floating: false,
              pinned: true,
              backgroundColor: const Color(0xFFFF6B35),
              flexibleSpace: FlexibleSpaceBar(
                title: Text(city.name),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (city.imageUrl != null)
                      Image.network(
                        city.imageUrl!,
                        fit: BoxFit.cover,
                      ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => context.pop(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: col(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      city.description ?? 'Découvrez les activités à ${city.name}.',
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Color(0xFF4A5568),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Activités populaires',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            // TODO: Filter activities by city ID/Slug here (mock data doesn't fully support filtering yet, using all for demo)
            // Ideally: ref.watch(activitiesByCityProvider(city.id))
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    // Placeholder: We need a provider for city activities.
                    // For now, let's fetch default recommendations as a placeholder
                    // In a real app, we'd pass cityId to the search.
                    return const SizedBox.shrink(); // Replaced by dynamic list below
                  },
                  childCount: 0,
                ),
              ),
            ),
            // Temporary Fake List for UI Demo until provider is linked
             Consumer(builder: (context, ref, child) {
               final activitiesAsync = ref.watch(activityRepositoryProvider).searchActivities(query: '');
               return FutureBuilder(
                 future: activitiesAsync,
                 builder: (context, snapshot) {
                   if (!snapshot.hasData) return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
                   final activities = snapshot.data!;
                   return SliverPadding(
                     padding: const EdgeInsets.symmetric(horizontal: 20),
                     sliver: SliverGrid(
                       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                         crossAxisCount: 2,
                         childAspectRatio: 0.65,
                         crossAxisSpacing: 16,
                         mainAxisSpacing: 16,
                       ),
                       delegate: SliverChildBuilderDelegate(
                         (context, index) => EventCard(activity: activities[index], isCompact: true),
                         childCount: activities.length,
                       ),
                     ),
                   );
                 }
               );
             }),
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFFFF6B35))),
        error: (err, stack) => Center(child: Text('Erreur: $err')),
      ),
    );
  }
  
  Widget col({required CrossAxisAlignment crossAxisAlignment, required List<Widget> children}) {
     return Column(crossAxisAlignment: crossAxisAlignment, children: children);
  }
}
