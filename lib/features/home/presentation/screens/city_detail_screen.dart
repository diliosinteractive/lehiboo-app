import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lehiboo/domain/entities/city.dart';
import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/features/events/domain/repositories/event_repository.dart';
import 'package:lehiboo/features/events/data/mappers/event_to_activity_mapper.dart';
import 'package:lehiboo/features/home/presentation/widgets/event_card.dart';
import 'package:lehiboo/features/home/presentation/providers/home_providers.dart';

/// Provider for city detail - finds city by slug from the cities list
final cityDetailProvider = FutureProvider.family<City?, String>((ref, slug) async {
  final eventRepository = ref.watch(eventRepositoryProvider);

  try {
    final citiesDto = await eventRepository.getCities();
    // Find city by slug
    final cityDto = citiesDto.firstWhere(
      (c) => c.slug == slug,
      orElse: () => throw Exception('City not found'),
    );

    return City(
      id: cityDto.id.toString(),
      name: cityDto.name,
      slug: cityDto.slug,
      eventCount: cityDto.eventCount,
      imageUrl: _getCityImageUrl(cityDto.name),
    );
  } catch (e) {
    debugPrint('Error getting city by slug: $e');
    return null;
  }
});

/// Get a placeholder image URL for a city
String _getCityImageUrl(String cityName) {
  final cityImages = {
    'california': 'https://images.unsplash.com/photo-1449034446853-66c86144b0ad?w=400',
    'paris': 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=400',
    'lyon': 'https://images.unsplash.com/photo-1524397057410-1e775ed476f3?w=400',
    'marseille': 'https://images.unsplash.com/photo-1589394760766-91f2a2db1d6f?w=400',
    'bordeaux': 'https://images.unsplash.com/photo-1565018054866-968e244671af?w=400',
    'toulouse': 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
    'nantes': 'https://images.unsplash.com/photo-1588431379983-d4aefc8db5b0?w=400',
    'nice': 'https://images.unsplash.com/photo-1491166617655-0723a0999cfc?w=400',
    'strasbourg': 'https://images.unsplash.com/photo-1607619056574-7b8d3ee536b2?w=400',
    'montpellier': 'https://images.unsplash.com/photo-1597418680155-3c28a6a6bbef?w=400',
  };

  final lowerName = cityName.toLowerCase();
  return cityImages[lowerName] ??
         'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?w=400';
}

/// Provider for activities in a city (using location filter)
final cityActivitiesProvider = FutureProvider.family<List<Activity>, String>((ref, citySlug) async {
  final eventRepository = ref.watch(eventRepositoryProvider);

  debugPrint('Fetching activities for city: $citySlug');

  try {
    final result = await eventRepository.getEvents(
      location: citySlug, // Filter by event_loc taxonomy slug
      perPage: 20,
    );

    debugPrint('Got ${result.events.length} events for city $citySlug');
    return EventToActivityMapper.toActivities(result.events);
  } catch (e) {
    debugPrint('Error fetching city activities: $e');
    return [];
  }
});

class CityDetailScreen extends ConsumerWidget {
  final String citySlug;

  const CityDetailScreen({super.key, required this.citySlug});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cityAsyncValue = ref.watch(cityDetailProvider(citySlug));
    final activitiesAsyncValue = ref.watch(cityActivitiesProvider(citySlug));

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: cityAsyncValue.when(
        data: (city) {
          if (city == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('Ville non trouvée'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.pop(),
                    child: const Text('Retour'),
                  ),
                ],
              ),
            );
          }

          return CustomScrollView(
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
                          errorBuilder: (_, __, ___) => Container(
                            color: const Color(0xFFFF6B35).withOpacity(0.3),
                          ),
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
                  child: Column(
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
                      if (city.eventCount != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          '${city.eventCount} événement${city.eventCount! > 1 ? 's' : ''} disponible${city.eventCount! > 1 ? 's' : ''}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Activités populaires',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () => context.push(
                              Uri(path: '/search', queryParameters: {'city': city.slug}).toString(),
                            ),
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFFFF6B35),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            icon: const Icon(Icons.tune, size: 16),
                            label: const Text(
                              'Filtrer',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              // Activities list from real API
              activitiesAsyncValue.when(
                data: (activities) {
                  if (activities.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Text(
                            'Aucune activité trouvée dans cette ville',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    );
                  }
                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.50,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => EventCard(activity: activities[index], isCompact: true),
                        childCount: activities.length,
                      ),
                    ),
                  );
                },
                loading: () => const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(color: Color(0xFFFF6B35)),
                    ),
                  ),
                ),
                error: (err, _) => SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Text('Erreur: $err'),
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFFFF6B35))),
        error: (err, stack) => Center(child: Text('Erreur: $err')),
      ),
    );
  }
}
