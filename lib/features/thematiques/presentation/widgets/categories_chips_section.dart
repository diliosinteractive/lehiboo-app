import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/thematiques_provider.dart';
import '../../data/models/thematique_dto.dart';

class CategoriesChipsSection extends ConsumerWidget {
  const CategoriesChipsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final thematiquesAsync = ref.watch(thematiquesProvider);

    return thematiquesAsync.when(
      data: (thematiques) {
        if (thematiques.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Toutes les catégories',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: thematiques.map((thematique) {
                  return CategoryChip(thematique: thematique);
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
          ],
        );
      },
      loading: () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(6, (index) {
            return Container(
              width: 100,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
            );
          }),
        ),
      ),
      error: (error, _) => const SizedBox.shrink(),
    );
  }
}

class CategoryChip extends StatelessWidget {
  final ThematiqueDto thematique;

  const CategoryChip({super.key, required this.thematique});

  @override
  Widget build(BuildContext context) {
    final color = _getCategoryColor(thematique.slug);

    return GestureDetector(
      onTap: () {
        context.push('/events?thematique=${thematique.slug}');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getIconData(thematique.icon ?? thematique.slug),
              color: color,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              thematique.name,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (thematique.eventCount != null && thematique.eventCount! > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${thematique.eventCount}',
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String slug) {
    switch (slug.toLowerCase()) {
      case 'concert':
        return const Color(0xFF6366F1);
      case 'theatre':
      case 'spectacle':
        return const Color(0xFFEC4899);
      case 'sport':
        return const Color(0xFF10B981);
      case 'atelier':
        return const Color(0xFFF59E0B);
      case 'exposition':
      case 'mediatheque':
        return const Color(0xFF8B5CF6);
      case 'festival':
        return const Color(0xFFEF4444);
      case 'cinema':
        return const Color(0xFF06B6D4);
      case 'conference':
        return const Color(0xFF0891B2);
      case 'enfants':
      case 'famille':
        return const Color(0xFFF472B6);
      case 'gastronomie':
        return const Color(0xFFEA580C);
      default:
        return const Color(0xFFFF6B35);
    }
  }

  IconData _getIconData(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'music':
      case 'concert':
        return Icons.music_note;
      case 'theater':
      case 'theatre':
      case 'spectacle':
        return Icons.theater_comedy;
      case 'sport':
        return Icons.sports;
      case 'atelier':
        return Icons.build;
      case 'exposition':
        return Icons.museum;
      case 'mediatheque':
        return Icons.library_books;
      case 'festival':
        return Icons.celebration;
      case 'cinema':
        return Icons.movie;
      case 'conference':
        return Icons.mic;
      case 'enfants':
      case 'famille':
        return Icons.family_restroom;
      case 'gastronomie':
        return Icons.restaurant;
      default:
        return Icons.event;
    }
  }
}
