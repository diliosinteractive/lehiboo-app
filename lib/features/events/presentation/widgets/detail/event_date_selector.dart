import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/features/events/domain/entities/event_submodels.dart';

/// Date selector with compact chips grouped by month.
///
/// Each chip shows: day number + abbreviated day name, time range (HH:mm),
/// and remaining places. Chips scroll horizontally within each month group.
class EventDateSelector extends StatelessWidget {
  final List<CalendarDateSlot> slots;
  final String? selectedSlotId;
  final ValueChanged<CalendarDateSlot> onSlotSelected;
  final VoidCallback? onViewAllDates;

  const EventDateSelector({
    super.key,
    required this.slots,
    this.selectedSlotId,
    required this.onSlotSelected,
    this.onViewAllDates,
  });

  @override
  Widget build(BuildContext context) {
    if (slots.isEmpty) return _buildEmptyState();

    final grouped = _groupSlotsByMonth(slots);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Choisissez une date',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: HbColors.textPrimary,
                ),
              ),
              if (slots.length > 8)
                TextButton(
                  onPressed: onViewAllDates,
                  child: Text(
                    'Voir tout (${slots.length})',
                    style: const TextStyle(
                      color: HbColors.brandPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Month groups — always show month/year header
        ...grouped.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: Text(
                  _capitalise(entry.key),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              SizedBox(
                height: 120,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: entry.value.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final slot = entry.value[index];
                    return _DateChip(
                      key: ValueKey('chip_${slot.id}'),
                      slot: slot,
                      isSelected: slot.id == selectedSlotId,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        onSlotSelected(slot);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 4),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Column(
          children: [
            Icon(Icons.event_busy_outlined, size: 48, color: Colors.grey),
            SizedBox(height: 12),
            Text(
              'Aucune date disponible',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: HbColors.textPrimary,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Cet événement n\'a pas de créneaux ouverts',
              style: TextStyle(fontSize: 13, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Map<String, List<CalendarDateSlot>> _groupSlotsByMonth(
      List<CalendarDateSlot> slots) {
    final grouped = <String, List<CalendarDateSlot>>{};
    for (final slot in slots) {
      final monthKey = DateFormat('MMMM yyyy', 'fr_FR').format(slot.date);
      grouped.putIfAbsent(monthKey, () => []);
      grouped[monthKey]!.add(slot);
    }
    return grouped;
  }

  String _capitalise(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
}

// ─────────────────────────────────────────────────────────────────────────────
// Compact date chip
// ─────────────────────────────────────────────────────────────────────────────

class _DateChip extends StatefulWidget {
  final CalendarDateSlot slot;
  final bool isSelected;
  final VoidCallback onTap;

  const _DateChip({
    super.key,
    required this.slot,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_DateChip> createState() => _DateChipState();
}

class _DateChipState extends State<_DateChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  bool get _isFull =>
      widget.slot.spotsRemaining != null && widget.slot.spotsRemaining! <= 0;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(
        parent: _bounceController,
        curve: Curves.easeOutBack,
        reverseCurve: Curves.easeIn,
      ),
    );
  }

  @override
  void didUpdateWidget(_DateChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _bounceController.forward(from: 0).then((_) {
        if (mounted) _bounceController.reverse();
      });
    }
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bounceAnimation,
      builder: (context, child) =>
          Transform.scale(scale: _bounceAnimation.value, child: child),
      child: GestureDetector(
        onTap: _isFull ? null : widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 108,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            color: _isFull
                ? Colors.grey.shade100
                : widget.isSelected
                    ? HbColors.brandPrimary
                    : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _isFull
                  ? Colors.grey.shade200
                  : widget.isSelected
                      ? HbColors.brandPrimary
                      : Colors.grey.shade200,
              width: widget.isSelected ? 2 : 1,
            ),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: HbColors.brandPrimary.withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Day number + abbreviated day name
              _buildDayRow(),
              const SizedBox(height: 6),
              // Time range
              _buildTimeRange(),
              // Spots remaining
              if (widget.slot.spotsRemaining != null) ...[
                const SizedBox(height: 4),
                _buildSpots(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDayRow() {
    final dayNumber = widget.slot.date.day.toString();
    final dayAbbrev =
        '${DateFormat('E', 'fr_FR').format(widget.slot.date)}.';

    final color = _isFull
        ? Colors.grey
        : widget.isSelected
            ? Colors.white
            : HbColors.textPrimary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          dayNumber,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: color,
            height: 1,
          ),
        ),
        const SizedBox(width: 3),
        Text(
          dayAbbrev,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeRange() {
    final start = _formatTime(widget.slot.startTime);
    final end = _formatTime(widget.slot.endTime);
    if (start.isEmpty) return const SizedBox.shrink();

    final text = end.isNotEmpty ? '$start - $end' : start;
    return Text(
      text,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: _isFull
            ? Colors.grey
            : widget.isSelected
                ? Colors.white.withValues(alpha: 0.9)
                : HbColors.brandPrimary,
      ),
    );
  }

  Widget _buildSpots() {
    final spots = widget.slot.spotsRemaining!;

    if (_isFull) {
      return Text(
        'Complet',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade500,
        ),
      );
    }

    return Text(
      '$spots place${spots > 1 ? 's' : ''} restante${spots > 1 ? 's' : ''}',
      style: TextStyle(
        fontSize: 11,
        color: widget.isSelected
            ? Colors.white.withValues(alpha: 0.85)
            : spots <= 5
                ? Colors.orange.shade700
                : Colors.grey.shade500,
        fontWeight: spots <= 5 ? FontWeight.w600 : FontWeight.w400,
      ),
      textAlign: TextAlign.center,
    );
  }

  /// Strips seconds: "14:00:00" → "14:00"
  static String _formatTime(String? time) {
    if (time == null || time.isEmpty) return '';
    final parts = time.split(':');
    if (parts.length >= 2) return '${parts[0]}:${parts[1]}';
    return time;
  }
}
