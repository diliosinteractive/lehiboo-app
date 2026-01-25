import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/filter_provider.dart';
import 'airbnb_search_sheet.dart';

/// Compact search pill for the home page hero section
/// Airbnb-style: shows "Où ? · Quand ? · Quoi ?" and opens full search sheet
class HomeSearchPill extends ConsumerWidget {
  const HomeSearchPill({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(eventFilterProvider);

    // Build the display text based on current filters
    final whereText = _getWhereText(filter);
    final whenText = _getWhenText(filter);
    final whatText = _getWhatText(filter);

    return GestureDetector(
      onTap: () => AirbnbSearchSheet.show(context),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha:0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Search icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFFF601F),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.search,
                color: Colors.white,
                size: 20,
              ),
            ),

            const SizedBox(width: 14),

            // Search text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Main text
                  Text(
                    _hasAnyFilter(filter) ? _getMainText(filter) : 'Rechercher',
                    style: GoogleFonts.montserrat(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF222222),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 2),

                  // Subtitle with filter hints
                  Text(
                    '$whereText · $whenText · $whatText',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Filter badge (if any filters active)
            if (filter.hasActiveFilters) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF601F).withValues(alpha:0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFFF601F).withValues(alpha:0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.tune,
                      size: 16,
                      color: Color(0xFFFF601F),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${filter.activeFilterCount}',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFFF601F),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  bool _hasAnyFilter(filter) {
    return filter.cityName != null ||
        filter.latitude != null ||
        filter.dateFilterType != null ||
        filter.categoriesSlugs.isNotEmpty ||
        filter.thematiquesSlugs.isNotEmpty;
  }

  String _getMainText(filter) {
    if (filter.cityName != null) return filter.cityName!;
    if (filter.latitude != null) return 'À proximité';
    if (filter.searchQuery.isNotEmpty) return filter.searchQuery;
    return 'Rechercher';
  }

  String _getWhereText(filter) {
    if (filter.cityName != null) return filter.cityName!;
    if (filter.latitude != null) return '📍 ${filter.radiusKm.toInt()} km';
    return 'Où ?';
  }

  String _getWhenText(filter) {
    if (filter.dateFilterLabel != null) return filter.dateFilterLabel!;
    return 'Quand ?';
  }

  String _getWhatText(filter) {
    final parts = <String>[];

    if (filter.categoriesSlugs.isNotEmpty) {
      parts.add('${filter.categoriesSlugs.length} cat.');
    }
    if (filter.familyFriendly) parts.add('Famille');
    if (filter.onlyFree) parts.add('Gratuit');

    if (parts.isNotEmpty) return parts.join(', ');
    return 'Quoi ?';
  }
}

/// Alternative compact version - just the pill without expanded info
class HomeSearchPillCompact extends ConsumerWidget {
  const HomeSearchPillCompact({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => AirbnbSearchSheet.show(context),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.08),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.search,
              color: Color(0xFFFF601F),
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              'Où ? · Quand ? · Quoi ?',
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
