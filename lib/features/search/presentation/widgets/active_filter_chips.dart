import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/themes/colors.dart';
import '../providers/filter_provider.dart';
import '../../domain/models/event_filter.dart';

/// Displays active filter chips with remove functionality
class ActiveFilterChips extends ConsumerWidget {
  final bool showClearAll;
  final EdgeInsets? padding;

  const ActiveFilterChips({
    super.key,
    this.showClearAll = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeChips = ref.watch(activeFilterChipsProvider);
    final filterNotifier = ref.read(eventFilterProvider.notifier);

    if (activeChips.isEmpty) {
      return const SizedBox.shrink();
    }

    // Single-row horizontal scroll. Bounded height so the chips no longer
    // eat vertical space as more filters accumulate; users swipe sideways
    // to reach the ones that overflow. "Tout effacer" sits as a trailing
    // pinned pill so it's discoverable but won't be tapped by accident.
    final itemCount = activeChips.length + (showClearAll ? 1 : 0);
    // Caller's padding may mix horizontal (gutter) and vertical (breathing
    // room above/below the row). Apply vertical to the outer Padding and
    // horizontal to the ListView so chips never get clipped.
    final p = padding ?? const EdgeInsets.symmetric(horizontal: 20);

    return Padding(
      padding: EdgeInsets.only(top: p.top, bottom: p.bottom),
      child: SizedBox(
        height: 44,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: p.horizontal / 2),
          itemCount: itemCount,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            if (index < activeChips.length) {
              final chip = activeChips[index];
              return Center(
                child: _ActiveChip(
                  chip: chip,
                  onRemove: () {
                    filterNotifier.removeFilterByType(chip.type,
                        value: chip.value);
                  },
                ),
              );
            }
            return Center(
              child: _ClearAllPill(
                count: activeChips.length,
                onTap: () => filterNotifier.resetAll(),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ClearAllPill extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const _ClearAllPill({required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: HbColors.brandPrimary.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.delete_sweep_outlined,
                size: 14, color: HbColors.brandPrimary),
            const SizedBox(width: 6),
            Text(
              'Tout effacer ($count)',
              style: const TextStyle(
                fontSize: 13,
                color: HbColors.brandPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActiveChip extends StatelessWidget {
  final ActiveFilterChip chip;
  final VoidCallback onRemove;

  const _ActiveChip({
    required this.chip,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getChipColor(chip.type);

    return Container(
      padding: const EdgeInsets.only(left: 12, right: 4, top: 6, bottom: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.28),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getChipIcon(chip.type),
            size: 14,
            color: color,
          ),
          const SizedBox(width: 6),
          ConstrainedBox(
            // Cap so a single long label can't dominate the horizontal scroll.
            // ~15-20 chars depending on letterforms before ellipsis kicks in.
            constraints: const BoxConstraints(maxWidth: 180),
            child: Text(
              _formatLabel(chip),
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: TextStyle(
                fontSize: 13,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.16),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                size: 12,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getChipColor(FilterChipType type) {
    switch (type) {
      case FilterChipType.search:
        return HbColors.brandPrimary;
      case FilterChipType.date:
        return HbColors.brandPrimary;
      case FilterChipType.price:
        return const Color(0xFF10B981);
      case FilterChipType.city:
        return HbColors.brandPrimary;
      case FilterChipType.location:
        return HbColors.brandPrimary;
      case FilterChipType.thematique:
        return HbColors.brandPrimary;
      case FilterChipType.category:
        return HbColors.brandPrimary;
      case FilterChipType.organizer:
        return HbColors.brandPrimary;
      case FilterChipType.tag:
        return HbColors.brandPrimary;
      case FilterChipType.eventTag:
        return HbColors.brandPrimary;
      case FilterChipType.targetAudience:
        return HbColors.brandPrimary;
      case FilterChipType.specialEvent:
        return HbColors.brandPrimary;
      case FilterChipType.emotion:
        return HbColors.brandPrimary;
      case FilterChipType.availability:
        return const Color(0xFF10B981);
      case FilterChipType.locationType:
        return HbColors.brandPrimary;
      case FilterChipType.audience:
        return HbColors.brandPrimary;
      case FilterChipType.format:
        return HbColors.brandPrimary;
    }
  }

  IconData _getChipIcon(FilterChipType type) {
    switch (type) {
      case FilterChipType.search:
        return Icons.search;
      case FilterChipType.date:
        return Icons.calendar_today;
      case FilterChipType.price:
        return Icons.euro;
      case FilterChipType.city:
        return Icons.location_on;
      case FilterChipType.location:
        return Icons.my_location;
      case FilterChipType.thematique:
        return Icons.category;
      case FilterChipType.category:
        return Icons.folder;
      case FilterChipType.organizer:
        return Icons.business;
      case FilterChipType.tag:
        return Icons.label;
      case FilterChipType.eventTag:
        return Icons.local_activity;
      case FilterChipType.targetAudience:
        return Icons.groups;
      case FilterChipType.specialEvent:
        return Icons.celebration;
      case FilterChipType.emotion:
        return Icons.mood;
      case FilterChipType.availability:
        return Icons.event_available;
      case FilterChipType.locationType:
        return Icons.place;
      case FilterChipType.audience:
        return Icons.people;
      case FilterChipType.format:
        return Icons.videocam;
    }
  }

  String _formatLabel(ActiveFilterChip chip) {
    // Format thematique/category slugs to readable names
    if (chip.type == FilterChipType.thematique ||
        chip.type == FilterChipType.category ||
        chip.type == FilterChipType.eventTag ||
        chip.type == FilterChipType.targetAudience ||
        chip.type == FilterChipType.specialEvent ||
        chip.type == FilterChipType.emotion) {
      return _slugToName(chip.label);
    }
    return chip.label;
  }

  String _slugToName(String slug) {
    // Convert slug to readable name
    final words = slug.split('-').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    });
    return words.join(' ');
  }
}

/// Horizontal scrollable active filter chips
class HorizontalActiveFilterChips extends ConsumerWidget {
  const HorizontalActiveFilterChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeChips = ref.watch(activeFilterChipsProvider);
    final filterNotifier = ref.read(eventFilterProvider.notifier);

    if (activeChips.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: activeChips.length + 1, // +1 for clear all button
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            // Clear all button
            return GestureDetector(
              onTap: () => filterNotifier.resetAll(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.clear_all, size: 16, color: Colors.grey[700]),
                    const SizedBox(width: 4),
                    Text(
                      'Effacer',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final chip = activeChips[index - 1];
          return _CompactActiveChip(
            chip: chip,
            onRemove: () {
              filterNotifier.removeFilterByType(chip.type, value: chip.value);
            },
          );
        },
      ),
    );
  }
}

class _CompactActiveChip extends StatelessWidget {
  final ActiveFilterChip chip;
  final VoidCallback onRemove;

  const _CompactActiveChip({
    required this.chip,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 2, top: 2, bottom: 2),
      decoration: BoxDecoration(
        color: HbColors.brandPrimary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: HbColors.brandPrimary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _formatLabel(chip),
            style: const TextStyle(
              fontSize: 13,
              color: HbColors.brandPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: HbColors.brandPrimary.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 12,
                color: HbColors.brandPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatLabel(ActiveFilterChip chip) {
    if (chip.type == FilterChipType.thematique ||
        chip.type == FilterChipType.category ||
        chip.type == FilterChipType.eventTag ||
        chip.type == FilterChipType.targetAudience ||
        chip.type == FilterChipType.specialEvent ||
        chip.type == FilterChipType.emotion) {
      return _slugToName(chip.label);
    }
    return chip.label;
  }

  String _slugToName(String slug) {
    final words = slug.split('-').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    });
    return words.join(' ');
  }
}
