import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/themes/colors.dart';
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
    final whereText = _getWhereText(context, filter);
    final whenText = _getWhenText(context, filter);
    final whatText = _getWhatText(context, filter);

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
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
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
                color: HbColors.brandPrimary,
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
                    _hasAnyFilter(filter)
                        ? _getMainText(context, filter)
                        : context.l10n.homeSearchTitle,
                    style: GoogleFonts.montserrat(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: HbColors.textDark,
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
                  color: HbColors.brandPrimary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: HbColors.brandPrimary.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.tune,
                      size: 16,
                      color: HbColors.brandPrimary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${filter.activeFilterCount}',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: HbColors.brandPrimary,
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

  String _getMainText(BuildContext context, filter) {
    if (filter.cityName != null) return filter.cityName!;
    if (filter.latitude != null) return context.l10n.homeSearchNearby;
    if (filter.searchQuery.isNotEmpty) return filter.searchQuery;
    return context.l10n.homeSearchTitle;
  }

  String _getWhereText(BuildContext context, filter) {
    if (filter.cityName != null) return filter.cityName!;
    if (filter.latitude != null) return '📍 ${filter.radiusKm.toInt()} km';
    return context.l10n.homeSearchWhere;
  }

  String _getWhenText(BuildContext context, filter) {
    if (filter.dateFilterLabel != null) return filter.dateFilterLabel!;
    return context.l10n.homeSearchWhen;
  }

  String _getWhatText(BuildContext context, filter) {
    final parts = <String>[];

    if (filter.categoriesSlugs.isNotEmpty) {
      parts.add(context.l10n.homeSearchCategoryCount(
        filter.categoriesSlugs.length,
      ));
    }
    if (filter.familyFriendly) parts.add(context.l10n.homeSearchFamily);
    if (filter.onlyFree) parts.add(context.l10n.commonFree);

    if (parts.isNotEmpty) return parts.join(', ');
    return context.l10n.homeSearchWhat;
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
              color: Colors.black.withValues(alpha: 0.08),
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
              color: HbColors.brandPrimary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              '${context.l10n.homeSearchWhere} · ${context.l10n.homeSearchWhen} · ${context.l10n.homeSearchWhat}',
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
