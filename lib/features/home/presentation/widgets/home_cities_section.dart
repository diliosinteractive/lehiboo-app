import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lehiboo/features/events/presentation/providers/cities_provider.dart';
import '../../../../domain/entities/city.dart';

class HomeCitiesSection extends ConsumerWidget {
  const HomeCitiesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final citiesAsync = ref.watch(citiesProvider);

    return citiesAsync.when(
      data: (cities) {
        if (cities.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Row(
                    children: [
                       const Text(
                        'Parcourir par ville',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF222222),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Map icon next to title as requested to understand it leads to map
                      GestureDetector(
                        onTap: () => context.push('/map'),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF601F).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.map_outlined, size: 16, color: Color(0xFFFF601F)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: cities.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final city = cities[index];
                  return _CityChip(
                    city: city,
                    onTap: () {
                      context.pushNamed(
                        'map', 
                        queryParameters: {
                          'lat': city.lat.toString(),
                          'lng': city.lng.toString(),
                          'zoom': '13',
                        }
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(), // Or skeleton
      error: (err, stack) => const SizedBox.shrink(),
    );
  }
}

class _CityChip extends StatelessWidget {
  final City city;
  final VoidCallback onTap;

  const _CityChip({required this.city, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.grey.shade200),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.place, size: 16, color: Color(0xFFFF601F)),
            const SizedBox(width: 8),
            Text(
              city.name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF222222),
              ),
            ),
            if ((city.eventCount ?? 0) > 0) ...[
              const SizedBox(width: 4),
              Text(
                '(${city.eventCount})',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
