import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:html_unescape/html_unescape.dart';
import '../providers/thematiques_provider.dart';
import '../../data/models/thematique_dto.dart';

class ThematiquesSection extends ConsumerWidget {
  const ThematiquesSection({super.key});

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
                'Explorer par thématique',
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
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.3,
                ),
                itemCount: thematiques.length > 4 ? 4 : thematiques.length,
                itemBuilder: (context, index) {
                  return ThematiqueCard(thematique: thematiques[index]);
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        );
      },
      loading: () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFFF6B35),
                ),
              ),
            );
          },
        ),
      ),
      error: (error, _) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.red),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Erreur de chargement',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => ref.refresh(thematiquesProvider),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ThematiqueCard extends StatelessWidget {
  final ThematiqueDto thematique;

  const ThematiqueCard({super.key, required this.thematique});

  @override
  Widget build(BuildContext context) {
    final imageUrl = thematique.image?.medium ?? thematique.image?.large;
    final unescape = HtmlUnescape();

    return GestureDetector(
      onTap: () {
        // Navigate to search screen with pre-filled category
        context.push(
          Uri(path: '/search', queryParameters: {'categorySlug': thematique.slug}).toString(),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            if (imageUrl != null)
              CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: _getThematiqueColor(thematique.slug),
                ),
                errorWidget: (context, url, error) => Container(
                  color: _getThematiqueColor(thematique.slug),
                ),
              )
            else
              Container(
                color: _getThematiqueColor(thematique.slug),
              ),
            // Gradient overlay
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
            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Icon
                  if (thematique.icon != null)
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getIconData(thematique.icon!),
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  const Spacer(),
                  // Name
                  Text(
                    unescape.convert(thematique.name),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (thematique.eventCount != null && thematique.eventCount! > 0)
                    Text(
                      '${thematique.eventCount} événement${thematique.eventCount! > 1 ? 's' : ''}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getThematiqueColor(String slug) {
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
      default:
        return Icons.event;
    }
  }
}
