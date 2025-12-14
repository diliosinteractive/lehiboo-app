import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:html_unescape/html_unescape.dart';
import '../providers/thematiques_provider.dart';
import '../../../home/presentation/providers/home_providers.dart';
import '../../data/models/thematique_dto.dart';

class ThematiquesSection extends ConsumerWidget {
  const ThematiquesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Switch to categoriesProvider for "Types d'événement"
    final categoriesAsync = ref.watch(categoriesProvider);

    return categoriesAsync.when(
      data: (categories) {
        if (categories.isEmpty) {
          return const SizedBox.shrink();
        }

        // Sort by event count descending
        final sortedCategories = List<EventCategoryInfo>.from(categories)
          ..sort((a, b) => (b.eventCount).compareTo(a.eventCount));

        // Limit to 4 for the homepage
        final displayCategories = sortedCategories.take(4).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Explorer par type d'événement",
                    style: TextStyle(
                      fontSize: 19, // Slightly smaller to fit "type d'événement"
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  TextButton(
                    onPressed: () => _showAllCategoriesBottomSheet(context, sortedCategories),
                    child: const Text(
                      'Voir tout',
                      style: TextStyle(
                        color: Color(0xFFFF601F),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
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
                itemCount: displayCategories.length,
                itemBuilder: (context, index) {
                  return CategoryTypeCard(category: displayCategories[index]);
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
                  color: Color(0xFFFF601F),
                ),
              ),
            );
          },
        ),
      ),
      error: (error, _) => const SizedBox.shrink(),
    );
  }

  void _showAllCategoriesBottomSheet(BuildContext context, List<EventCategoryInfo> allCategories) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AllCategoriesBottomSheet(categories: allCategories),
    );
  }
}

class _AllCategoriesBottomSheet extends StatefulWidget {
  final List<EventCategoryInfo> categories;

  const _AllCategoriesBottomSheet({required this.categories});

  @override
  State<_AllCategoriesBottomSheet> createState() => _AllCategoriesBottomSheetState();
}

class _AllCategoriesBottomSheetState extends State<_AllCategoriesBottomSheet> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final unescape = HtmlUnescape();
    final filteredCategories = widget.categories.where((c) {
      final name = unescape.convert(c.name).toLowerCase();
      return name.contains(_searchQuery.toLowerCase());
    }).toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tous les types (${widget.categories.length})',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: "Rechercher un type d'événement...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.3,
              ),
              itemCount: filteredCategories.length,
              itemBuilder: (context, index) {
                return CategoryTypeCard(category: filteredCategories[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryTypeCard extends StatelessWidget {
  final EventCategoryInfo category;

  const CategoryTypeCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final unescape = HtmlUnescape();
    
    // Check for local asset based on slug
    final localAsset = _getLocalAsset(category.slug);

    return GestureDetector(
      onTap: () {
        context.push(
          Uri(path: '/search', queryParameters: {'categorySlug': category.slug}).toString(),
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
            // Background image (Priority: Local Asset -> Color)
             if (localAsset != null)
              Image.asset(
                localAsset,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
              )
            else
              _buildPlaceholder(),
              
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
                  if (category.icon != null)
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getIconData(category.icon!),
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  const Spacer(),
                  // Name
                  Text(
                    unescape.convert(category.name),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                   if (category.eventCount > 0)
                    Text(
                      '${category.eventCount} événement${category.eventCount > 1 ? 's' : ''}',
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

  Widget _buildPlaceholder() {
    return Container(
      color: _getCategoryColor(category.slug),
    );
  }

  String? _getLocalAsset(String slug) {
    const assets = {
      'concert': 'assets/images/thematiques/concert.png',
      'spectacle': 'assets/images/thematiques/spectacle.png',
      'sport': 'assets/images/thematiques/sport.png',
      'atelier': 'assets/images/thematiques/atelier.png',
      'exposition': 'assets/images/thematiques/exposition.png',
      'festival': 'assets/images/thematiques/festival.png',
      'automobile': 'assets/images/thematiques/automobile.png',
      'couture': 'assets/images/thematiques/couture.png',
      'cuisine': 'assets/images/thematiques/cuisine.png',
      'informatique': 'assets/images/thematiques/informatique.png',
      'cinema': 'assets/images/thematiques/cinema.png',
      'conference': 'assets/images/thematiques/conference.png',
      
      // Category specific mappings
      'theatre': 'assets/images/thematiques/spectacle.png',
      'musique': 'assets/images/thematiques/concert.png',
      'marche': 'assets/images/thematiques/cuisine.png', // Fallback for market
      'formation': 'assets/images/thematiques/conference.png',
      'loisirs': 'assets/images/thematiques/atelier.png',
      'culture': 'assets/images/thematiques/exposition.png',
      'autre': 'assets/images/thematiques/atelier.png',
    };
    return assets[slug.toLowerCase()];
  }

  Color _getCategoryColor(String slug) {
    switch (slug.toLowerCase()) {
      case 'concert':
      case 'musique':
        return const Color(0xFF6366F1);
      case 'theatre':
      case 'spectacle':
        return const Color(0xFFEC4899);
      case 'sport':
        return const Color(0xFF10B981);
      case 'atelier':
      case 'loisirs':
        return const Color(0xFFF59E0B);
      case 'exposition':
      case 'culture':
      case 'mediatheque':
        return const Color(0xFF8B5CF6);
      case 'festival':
        return const Color(0xFFEF4444);
      case 'marche':
        return const Color(0xFF14B8A6);
      default:
        return const Color(0xFFFF601F);
    }
  }

  IconData _getIconData(String iconName) {
    // Basic mapping or just default
    // Since icon might be from API (Material icon name), we could try to map it
    // But for now, simple switch
    switch (iconName.toLowerCase()) {
      case 'music_note':
      case 'music':
      case 'concert':
        return Icons.music_note;
      case 'theater_comedy':
      case 'theater':
      case 'spectacle':
        return Icons.theater_comedy;
      case 'sports_soccer':
      case 'sport':
        return Icons.sports_soccer;
      case 'build':
      case 'atelier':
        return Icons.build;
      case 'museum':
      case 'exposition':
        return Icons.museum;
      case 'local_library':
      case 'mediatheque':
        return Icons.local_library;
      case 'celebration':
      case 'festival':
        return Icons.celebration;
       case 'shopping_basket':
      case 'marche':
        return Icons.shopping_basket;
      default:
        return Icons.event;
    }
  }
}
