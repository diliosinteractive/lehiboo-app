import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:html_unescape/html_unescape.dart';
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
            const SizedBox(height: 24),
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
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Calculate item width for 2 columns
                  // Available width = total width - spacing (12)
                  // Item width = Available width / 2
                  final double itemWidth = (constraints.maxWidth - 12) / 2;

                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: thematiques.map((thematique) {
                      return SizedBox(
                        width: itemWidth,
                        child: CategoryChip(thematique: thematique),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        );
      },
      loading: () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: List.generate(6, (index) {
            return LayoutBuilder(
              builder: (context, constraints) {
                 final double itemWidth = (constraints.maxWidth - 12) / 2;
                 return Container(
                  width: itemWidth,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                  ),
                );
              }
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
    final unescape = HtmlUnescape();
    final displayName = unescape.convert(thematique.name);

    return GestureDetector(
      onTap: () {
        context.push(
          Uri(path: '/search', queryParameters: {'categorySlug': thematique.slug}).toString(),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFE2E8F0),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getIconData(thematique.icon ?? thematique.slug),
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                displayName,
                style: const TextStyle(
                  color: Color(0xFF2D3748),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String slug) {
    switch (slug.toLowerCase()) {
      case 'concert':
      case 'musique-concert':
        return const Color(0xFFF97316); // Orange
      case 'theatre':
      case 'spectacle':
      case 'cinema-spectacle':
        return const Color(0xFFEC4899); // Pink
      case 'sport':
      case 'sport-bien-etre':
        return const Color(0xFF10B981); // Emerald
      case 'atelier':
      case 'formation-education':
        return const Color(0xFF3B82F6); // Blue
      case 'exposition':
      case 'art-culture':
        return const Color(0xFF8B5CF6); // Violet
      case 'litterature-lecture':
        return const Color(0xFF06B6D4); // Cyan
      case 'nature-environnement':
        return const Color(0xFF84CC16); // Lime
      case 'numerique-technologie':
        return const Color(0xFF6366F1); // Indigo
      case 'patrimoine-histoire':
        return const Color(0xFFD97706); // Amber
      case 'mode-design':
        return const Color(0xFFDB2777); // Pink-700
      case 'cuisine-gastronomie':
        return const Color(0xFFEF4444); // Red
      case 'famille-enfants':
        return const Color(0xFFFF601F); // Brand
      default:
        return const Color(0xFF94A3B8); // Slate
    }
  }

  IconData _getIconData(String iconName) {
    // Basic mapping based on slug keywords
    final lower = iconName.toLowerCase();
    if (lower.contains('musique') || lower.contains('concert')) return Icons.music_note_rounded;
    if (lower.contains('theatre') || lower.contains('spectacle') || lower.contains('cinema')) return Icons.movie_filter_rounded;
    if (lower.contains('sport') || lower.contains('bien-etre')) return Icons.pool_rounded;
    if (lower.contains('cuisine') || lower.contains('gastronomie')) return Icons.restaurant_menu_rounded;
    if (lower.contains('nature') || lower.contains('environnement')) return Icons.eco_rounded;
    if (lower.contains('famille') || lower.contains('enfant')) return Icons.family_restroom_rounded;
    if (lower.contains('art') || lower.contains('culture') || lower.contains('exposition')) return Icons.palette_rounded;
    if (lower.contains('litterature') || lower.contains('lecture')) return Icons.menu_book_rounded;
    if (lower.contains('numerique') || lower.contains('technologie')) return Icons.computer_rounded;
    if (lower.contains('histoire') || lower.contains('patrimoine')) return Icons.castle_rounded;
    if (lower.contains('formation') || lower.contains('education')) return Icons.school_rounded;
    if (lower.contains('mode') || lower.contains('design')) return Icons.checkroom_rounded;
    
    return Icons.category_rounded;
  }
}
