import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with clear all button
          if (showClearAll)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${activeChips.length} filtre${activeChips.length > 1 ? 's' : ''} actif${activeChips.length > 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                GestureDetector(
                  onTap: () => filterNotifier.resetAll(),
                  child: const Text(
                    'Tout effacer',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFFFF6B35),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          if (showClearAll) const SizedBox(height: 12),
          // Filter chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: activeChips.map((chip) {
              return _ActiveChip(
                chip: chip,
                onRemove: () {
                  filterNotifier.removeFilterByType(chip.type, value: chip.value);
                },
              );
            }).toList(),
          ),
        ],
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
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 4, top: 6, bottom: 6),
      decoration: BoxDecoration(
        color: _getChipColor(chip.type).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getChipColor(chip.type).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getChipIcon(chip.type),
            size: 14,
            color: _getChipColor(chip.type),
          ),
          const SizedBox(width: 6),
          Text(
            _formatLabel(chip),
            style: TextStyle(
              fontSize: 13,
              color: _getChipColor(chip.type),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: _getChipColor(chip.type).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                size: 12,
                color: _getChipColor(chip.type),
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
        return const Color(0xFF6366F1);
      case FilterChipType.date:
        return const Color(0xFFFF6B35);
      case FilterChipType.price:
        return const Color(0xFF10B981);
      case FilterChipType.city:
        return const Color(0xFF0EA5E9);
      case FilterChipType.thematique:
        return const Color(0xFFEC4899);
      case FilterChipType.category:
        return const Color(0xFF8B5CF6);
      case FilterChipType.organizer:
        return const Color(0xFFF59E0B);
      case FilterChipType.tag:
        return const Color(0xFF14B8A6);
      case FilterChipType.audience:
        return const Color(0xFFEF4444);
      case FilterChipType.format:
        return const Color(0xFF64748B);
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
      case FilterChipType.thematique:
        return Icons.category;
      case FilterChipType.category:
        return Icons.folder;
      case FilterChipType.organizer:
        return Icons.business;
      case FilterChipType.tag:
        return Icons.label;
      case FilterChipType.audience:
        return Icons.people;
      case FilterChipType.format:
        return Icons.videocam;
    }
  }

  String _formatLabel(ActiveFilterChip chip) {
    // Format thematique/category slugs to readable names
    if (chip.type == FilterChipType.thematique || chip.type == FilterChipType.category) {
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
        color: const Color(0xFFFF6B35).withOpacity(0.1),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFFF6B35).withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _formatLabel(chip),
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFFFF6B35),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B35).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 12,
                color: Color(0xFFFF6B35),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatLabel(ActiveFilterChip chip) {
    if (chip.type == FilterChipType.thematique || chip.type == FilterChipType.category) {
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
