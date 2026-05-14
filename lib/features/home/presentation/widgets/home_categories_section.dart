import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:lehiboo/features/home/presentation/providers/home_providers.dart';

const Map<String, String> _categoryImages = {
  'culture':
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=600&h=800&fit=crop&q=80',
  'decouverte':
      'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=600&h=800&fit=crop&q=80',
  'evenements':
      'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=600&h=800&fit=crop&q=80',
  'loisirs':
      'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=600&h=800&fit=crop&q=80',
  'nature-animaux':
      'https://images.unsplash.com/photo-1433086966358-54859d0ed716?w=600&h=800&fit=crop&q=80',
  'professionnel':
      'https://images.unsplash.com/photo-1515187029135-18ee286d815b?w=600&h=800&fit=crop&q=80',
  'spectacles':
      'https://images.unsplash.com/photo-1507676184212-d03ab07a01bf?w=600&h=800&fit=crop&q=80',
  'sport':
      'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?w=600&h=800&fit=crop&q=80',
  'gastronomie':
      'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=600&h=800&fit=crop&q=80',
  'enfants':
      'https://images.unsplash.com/photo-1503454537195-1dcabb73ffb9?w=600&h=800&fit=crop&q=80',
  'ateliers':
      'https://images.unsplash.com/photo-1452860606245-08befc0ff44b?w=600&h=800&fit=crop&q=80',
  'concerts':
      'https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?w=600&h=800&fit=crop&q=80',
  'theatre':
      'https://images.unsplash.com/photo-1503095396549-807759245b35?w=600&h=800&fit=crop&q=80',
  'expositions':
      'https://images.unsplash.com/photo-1531243269054-5ebf6f34081e?w=600&h=800&fit=crop&q=80',
  'conferences':
      'https://images.unsplash.com/photo-1475721027785-f74eccf877e2?w=600&h=800&fit=crop&q=80',
  'festivals':
      'https://images.unsplash.com/photo-1533174072545-7a4b6ad7a6c3?w=600&h=800&fit=crop&q=80',
};

const _defaultCategoryImage =
    'https://images.unsplash.com/photo-1501281668745-f7f57925c3b4?w=600&h=800&fit=crop&q=80';

class HomeCategoriesSection extends ConsumerWidget {
  const HomeCategoriesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return categoriesAsync.when(
      data: (allCategories) {
        final categories = allCategories.where(_hasEvents).toList();
        if (categories.isEmpty) return const SizedBox.shrink();

        return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Explorer par catégorie',
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0B1220),
                    height: 1.15,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 224,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    return _CategoryTile(category: categories[index]);
                  },
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const _HomeCategoriesSkeleton(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  static bool _hasEvents(EventCategoryInfo category) {
    return category.directEventCount > 0 ||
        category.children.any((child) => child.eventCount > 0);
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category});

  final EventCategoryInfo category;

  @override
  Widget build(BuildContext context) {
    final unescape = HtmlUnescape();
    final displayName = unescape.convert(category.name);
    final imageUrl = _imageUrlFor(category);

    return Semantics(
      button: true,
      label: 'Explorer $displayName',
      child: GestureDetector(
        onTap: () {
          context.push(
            Uri(
              path: '/search',
              queryParameters: {'categorySlug': category.slug},
            ).toString(),
          );
        },
        child: SizedBox(
          width: 168,
          height: 224,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  fadeInDuration: const Duration(milliseconds: 180),
                  placeholder: (context, url) =>
                      _CategoryImagePlaceholder(slug: category.slug),
                  errorWidget: (context, url, error) =>
                      _CategoryImagePlaceholder(slug: category.slug),
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Color(0x99000000),
                      ],
                      stops: [0.45, 1],
                    ),
                  ),
                ),
                Positioned(
                  left: 14,
                  right: 14,
                  bottom: 14,
                  child: Text(
                    displayName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      height: 1.12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _imageUrlFor(EventCategoryInfo category) {
    final apiImage = category.imageUrl?.trim();
    if (apiImage != null && apiImage.isNotEmpty) return apiImage;
    return _categoryImages[category.slug] ?? _defaultCategoryImage;
  }
}

class _CategoryImagePlaceholder extends StatelessWidget {
  const _CategoryImagePlaceholder({required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _fallbackColor(slug),
            const Color(0xFF111827),
          ],
        ),
      ),
    );
  }

  Color _fallbackColor(String slug) {
    switch (slug.toLowerCase()) {
      case 'culture':
      case 'expositions':
        return const Color(0xFF7C3AED);
      case 'decouverte':
      case 'nature-animaux':
        return const Color(0xFF059669);
      case 'evenements':
      case 'spectacles':
      case 'festivals':
        return const Color(0xFFDC2626);
      case 'loisirs':
      case 'ateliers':
        return const Color(0xFFF97316);
      case 'sport':
        return const Color(0xFF2563EB);
      case 'gastronomie':
        return const Color(0xFFB45309);
      default:
        return const Color(0xFFFF601F);
    }
  }
}

class _HomeCategoriesSkeleton extends StatelessWidget {
  const _HomeCategoriesSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: 220,
              height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 224,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: 4,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return Container(
                  width: 168,
                  height: 224,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(16),
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
