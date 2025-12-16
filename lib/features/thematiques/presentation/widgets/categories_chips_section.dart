import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:html_unescape/html_unescape.dart';
import '../providers/thematiques_provider.dart';
import '../../../home/presentation/providers/home_providers.dart';

class CategoriesChipsSection extends ConsumerWidget {
  const CategoriesChipsSection({super.key});

  @override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final thematiquesAsync = ref.watch(thematiquesProvider);

    return categoriesAsync.when(
      data: (categories) {
        if (categories.isEmpty) {
          return const SizedBox.shrink();
        }

        // Sort by event count descending
        final sortedCategories = List.of(categories)
          ..sort((a, b) => b.eventCount.compareTo(a.eventCount));

        // Take top 6
        final displayedCategories = sortedCategories.take(6).toList();

        // Create a map of slug/icon -> imageUrl from thematiques for fallback
        final Map<String, String> thematiqueImages = {};
        if (thematiquesAsync.hasValue) {
          for (final t in thematiquesAsync.value!) {
             final imageUrl = t.image?.thumbnail ?? t.image?.medium ?? t.image?.large;
             if (imageUrl != null) {
               thematiqueImages[t.slug] = imageUrl;
             }
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Toutes les catégories',
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D3748),
                    ),
                  ),
                  TextButton(
                    onPressed: () => _showAllCategoriesBottomSheet(context, sortedCategories, thematiqueImages),
                    child: const Text(
                      'Voir tout',
                      style: TextStyle(
                        color: Color(0xFFFF601F),
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
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Calculate item width for 2 columns
                  // Available width = total width - spacing (12)
                  // Item width = Available width / 2
                  final double itemWidth = (constraints.maxWidth - 12) / 2;

                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: displayedCategories.map((category) {
                      // Try to find an image from thematiques with same slug
                      final fallbackImage = thematiqueImages[category.slug];

                      return SizedBox(
                        width: itemWidth,
                        child: CategoryCard(
                          name: category.name,
                          slug: category.slug,
                          iconName: category.icon,
                          eventCount: category.eventCount,
                          imageUrl: fallbackImage,
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => _showAllCategoriesBottomSheet(context, sortedCategories, thematiqueImages),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF2D3748),
                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.white,
                  ),
                  child: const Text('Voir toutes les catégories'),
                ),
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

  void _showAllCategoriesBottomSheet(
      BuildContext context,
      List<EventCategoryInfo> allCategories,
      Map<String, String> thematiqueImages,
      ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return _AllCategoriesSheet(
            categories: allCategories,
            scrollController: scrollController,
            thematiqueImages: thematiqueImages,
          );
        },
      ),
    );
  }
}

class _AllCategoriesSheet extends StatefulWidget {
  final List<EventCategoryInfo> categories;
  final ScrollController scrollController;
  final Map<String, String> thematiqueImages;

  const _AllCategoriesSheet({
    required this.categories,
    required this.scrollController,
    required this.thematiqueImages,
  });

  @override
  State<_AllCategoriesSheet> createState() => _AllCategoriesSheetState();
}

class _AllCategoriesSheetState extends State<_AllCategoriesSheet> {
  late List<EventCategoryInfo> _filteredCategories;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredCategories = widget.categories;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCategories(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCategories = widget.categories;
      } else {
        final lowerQuery = query.toLowerCase();
        final unescape = HtmlUnescape();
        _filteredCategories = widget.categories.where((category) {
          return unescape.convert(category.name).toLowerCase().contains(lowerQuery);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF8F8F8),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 20),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header & Search
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Toutes les catégories (${widget.categories.length})',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                      color: Colors.grey[600],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _searchController,
                  onChanged: _filterCategories,
                  decoration: InputDecoration(
                    hintText: 'Rechercher une catégorie...',
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF9CA3AF)),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFFF601F)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // List
          Expanded(
            child: _filteredCategories.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'Aucune catégorie trouvée',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: widget.scrollController,
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                    itemCount: _filteredCategories.length,
                    itemBuilder: (context, index) {
                      final category = _filteredCategories[index];
                      // Try to find an image from thematiques with same slug
                      final fallbackImage = widget.thematiqueImages[category.slug];
                      
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: CategoryCard(
                          name: category.name,
                          slug: category.slug,
                          iconName: category.icon,
                          eventCount: category.eventCount,
                          imageUrl: fallbackImage,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}


class CategoryCard extends StatelessWidget {
  final String name;
  final String slug;
  final String? iconName;
  final String? imageUrl;
  final int? eventCount;

  const CategoryCard({
    super.key,
    required this.name,
    required this.slug,
    this.iconName,
    this.imageUrl,
    this.eventCount,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getCategoryColor(slug);
    final unescape = HtmlUnescape();
    final displayName = unescape.convert(name);

    return GestureDetector(
      onTap: () {
        context.push(
          Uri(path: '/search', queryParameters: {'categorySlug': slug}).toString(),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image or Icon container
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: imageUrl != null ? Colors.grey[100] : color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                image: imageUrl != null
                    ? DecorationImage(
                        image: CachedNetworkImageProvider(
                          imageUrl!,
                          errorListener: (Object exception) {
                            // This callback is for image loading errors.
                            // If the intention is to refresh the categoriesProvider
                            // when an image fails to load, this is where it would go.
                            // However, directly calling ref.refresh here might not be
                            // the best UX as it would refresh all categories for one image error.
                            // For now, we'll just log or handle the image error.
                            // If the user explicitly wants to refresh the whole provider on image error,
                            // uncomment the line below.
                            // ref.refresh(categoriesProvider);
                          },
                        ),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: imageUrl == null
                  ? Icon(
                      _getIconData(iconName ?? slug),
                      color: color,
                      size: 24,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            
            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    displayName,
                    style: const TextStyle(
                      color: Color(0xFF2D3748),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (eventCount != null && eventCount! > 0) ...[
                    const SizedBox(height: 2),
                    Text(
                      '$eventCount événement${eventCount! > 1 ? 's' : ''}',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            // Chevron
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey[400],
              size: 20,
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
