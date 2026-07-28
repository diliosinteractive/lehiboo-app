import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lehiboo/core/l10n/l10n.dart';
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

  /// Reminder mode: set of slot UUIDs the user has reminders for.
  /// When non-null, chips show a bell toggle instead of selection state.
  final Set<String>? remindedSlotIds;

  /// Called when the user toggles a reminder on a slot.
  final ValueChanged<CalendarDateSlot>? onReminderToggled;

  const EventDateSelector({
    super.key,
    required this.slots,
    this.selectedSlotId,
    required this.onSlotSelected,
    this.onViewAllDates,
    this.remindedSlotIds,
    this.onReminderToggled,
  });

  bool get _isReminderMode => remindedSlotIds != null;

  @override
  Widget build(BuildContext context) {
    if (slots.isEmpty) return _buildEmptyState(context);

    final grouped = _groupSlotsByMonth(context, slots);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _isReminderMode
                    ? context.l10n.eventDatesAvailable
                    : context.l10n.eventChooseDate,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: HbColors.textPrimary,
                ),
              ),
              if (slots.length > 8)
                TextButton(
                  onPressed: onViewAllDates,
                  child: Text(
                    context.l10n.eventViewAllCount(slots.length),
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
                      isReminded: remindedSlotIds?.contains(slot.id) ?? false,
                      isReminderMode: _isReminderMode,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        if (_isReminderMode) {
                          onReminderToggled?.call(slot);
                        } else {
                          onSlotSelected(slot);
                        }
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

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            const Icon(Icons.event_busy_outlined, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            Text(
              context.l10n.eventNoDateAvailable,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: HbColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              context.l10n.eventNoOpenSlots,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Map<String, List<CalendarDateSlot>> _groupSlotsByMonth(
      BuildContext context, List<CalendarDateSlot> slots) {
    final grouped = <String, List<CalendarDateSlot>>{};
    for (final slot in slots) {
      final monthKey = context
          .appDateFormat('MMMM yyyy', enPattern: 'MMMM yyyy')
          .format(slot.date);
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
  final bool isReminded;
  final bool isReminderMode;
  final VoidCallback onTap;

  const _DateChip({
    super.key,
    required this.slot,
    required this.isSelected,
    this.isReminded = false,
    this.isReminderMode = false,
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
    final becameHighlighted = (widget.isSelected && !oldWidget.isSelected) ||
        (widget.isReminded && !oldWidget.isReminded);
    if (becameHighlighted) {
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

  bool get _isHighlighted =>
      widget.isReminderMode ? widget.isReminded : widget.isSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bounceAnimation,
      builder: (context, child) =>
          Transform.scale(scale: _bounceAnimation.value, child: child),
      child: GestureDetector(
        onTap: _isFull && !widget.isReminderMode ? null : widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 108,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            color: _isFull && !widget.isReminderMode
                ? Colors.grey.shade100
                : _isHighlighted
                    ? HbColors.brandPrimary
                    : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _isFull && !widget.isReminderMode
                  ? Colors.grey.shade200
                  : _isHighlighted
                      ? HbColors.brandPrimary
                      : Colors.grey.shade200,
              width: _isHighlighted ? 2 : 1,
            ),
            boxShadow: _isHighlighted
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
              _buildDayRow(context),
              const SizedBox(height: 6),
              // Time range
              _buildTimeRange(),
              // Reminder bell or spots remaining
              if (widget.isReminderMode) ...[
                const SizedBox(height: 4),
                Icon(
                  widget.isReminded
                      ? Icons.notifications_active
                      : Icons.notifications_none,
                  size: 18,
                  color: _isHighlighted ? Colors.white : HbColors.brandPrimary,
                ),
              ] else if (widget.slot.spotsRemaining != null) ...[
                const SizedBox(height: 4),
                _buildSpots(context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDayRow(BuildContext context) {
    final dayNumber = widget.slot.date.day.toString();
    final dayAbbrev =
        '${context.appDateFormat('E', enPattern: 'E').format(widget.slot.date)}.';

    final color = _isFull && !widget.isReminderMode
        ? Colors.grey
        : _isHighlighted
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
        color: _isFull && !widget.isReminderMode
            ? Colors.grey
            : _isHighlighted
                ? Colors.white.withValues(alpha: 0.9)
                : HbColors.brandPrimary,
      ),
    );
  }

  Widget _buildSpots(BuildContext context) {
    final spots = widget.slot.spotsRemaining!;

    if (_isFull) {
      return Text(
        context.l10n.eventFull,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade500,
        ),
      );
    }

    return Text(
      context.l10n.eventSpotsRemaining(spots),
      style: TextStyle(
        fontSize: 11,
        color: _isHighlighted
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
