import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/features/events/domain/entities/event_submodels.dart';
import 'package:lehiboo/shared/widgets/animations/pulse_animation.dart';

/// Sélecteur de dates intelligent avec 3 modes:
/// - Mode Liste (1-5 dates): Liste verticale
/// - Mode Horizontal (6-15 dates): Calendrier scrollable
/// - Mode Calendrier (>15 dates): Calendrier mensuel
///
/// Features Material Expressive:
/// - Spring bounce animations sur sélection
/// - Pulse animation sur stock faible
/// - Staggered entrance animations
class EventDateSelector extends StatefulWidget {
  final List<CalendarDateSlot> slots;
  final String? selectedSlotId;
  final ValueChanged<CalendarDateSlot> onSlotSelected;
  final VoidCallback? onViewAllDates;

  /// Seuils pour changer de mode
  static const int listModeThreshold = 5;
  static const int horizontalModeThreshold = 15;

  const EventDateSelector({
    super.key,
    required this.slots,
    this.selectedSlotId,
    required this.onSlotSelected,
    this.onViewAllDates,
  });

  @override
  State<EventDateSelector> createState() => _EventDateSelectorState();
}

class _EventDateSelectorState extends State<EventDateSelector> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  DateSelectorMode get _mode {
    if (widget.slots.length <= EventDateSelector.listModeThreshold) {
      return DateSelectorMode.list;
    } else if (widget.slots.length <= EventDateSelector.horizontalModeThreshold) {
      return DateSelectorMode.horizontal;
    }
    return DateSelectorMode.calendar;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.slots.isEmpty) {
      return _buildEmptyState();
    }

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
              if (widget.slots.length > EventDateSelector.listModeThreshold)
                TextButton(
                  onPressed: widget.onViewAllDates,
                  child: Text(
                    'Voir tout (${widget.slots.length})',
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

        // Contenu selon le mode
        switch (_mode) {
          DateSelectorMode.list => _buildListMode(),
          DateSelectorMode.horizontal => _buildHorizontalMode(),
          DateSelectorMode.calendar => _buildCalendarMode(),
        },
      ],
    );
  }

  /// Mode Liste: Affiche toutes les dates en liste verticale
  Widget _buildListMode() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: List.generate(widget.slots.length, (index) {
          final slot = widget.slots[index];
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 300 + (index * 50)),
            curve: Curves.easeOutBack,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: Opacity(
                  opacity: value.clamp(0.0, 1.0),
                  child: child,
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _DateSlotCard(
                key: ValueKey('slot_${slot.id}_${slot.id == widget.selectedSlotId}'),
                slot: slot,
                isSelected: slot.id == widget.selectedSlotId,
                onTap: () => _selectSlot(slot),
              ),
            ),
          );
        }),
      ),
    );
  }

  /// Mode Horizontal: Calendrier scrollable
  Widget _buildHorizontalMode() {
    // Grouper les slots par mois
    final groupedSlots = _groupSlotsByMonth(widget.slots);

    return Column(
      children: groupedSlots.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mois header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                entry.key,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            // Slots horizontaux
            SizedBox(
              height: 110,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: entry.value.length,
                itemBuilder: (context, index) {
                  final slot = entry.value[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: _AnimatedDateChip(
                      key: ValueKey('chip_${slot.id}_${slot.id == widget.selectedSlotId}'),
                      slot: slot,
                      isSelected: slot.id == widget.selectedSlotId,
                      onTap: () => _selectSlot(slot),
                      index: index,
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  /// Mode Calendrier: Calendrier mensuel complet
  Widget _buildCalendarMode() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Message pour ouvrir le calendrier complet
          GestureDetector(
            onTap: widget.onViewAllDates,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: HbColors.brandPrimary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: HbColors.brandPrimary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: HbColors.brandPrimary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.calendar_month,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Plusieurs dates disponibles',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: HbColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.slots.length} créneaux disponibles',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: HbColors.brandPrimary,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Aperçu des prochaines dates
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Prochaines dates',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: HbColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 8),
          ...widget.slots.take(3).map((slot) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _DateSlotCard(
                key: ValueKey('slot_${slot.id}_${slot.id == widget.selectedSlotId}'),
                slot: slot,
                isSelected: slot.id == widget.selectedSlotId,
                onTap: () => _selectSlot(slot),
                compact: true,
              ),
            );
          }),
        ],
      ),
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
            Icon(
              Icons.event_busy_outlined,
              size: 48,
              color: Colors.grey,
            ),
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
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _selectSlot(CalendarDateSlot slot) {
    HapticFeedback.selectionClick();
    widget.onSlotSelected(slot);
  }

  Map<String, List<CalendarDateSlot>> _groupSlotsByMonth(List<CalendarDateSlot> slots) {
    final grouped = <String, List<CalendarDateSlot>>{};
    for (final slot in slots) {
      final monthKey = DateFormat('MMMM yyyy', 'fr_FR').format(slot.date);
      grouped.putIfAbsent(monthKey, () => []);
      grouped[monthKey]!.add(slot);
    }
    return grouped;
  }
}

enum DateSelectorMode { list, horizontal, calendar }

/// Card pour un créneau (mode liste) avec animation spring
class _DateSlotCard extends StatefulWidget {
  final CalendarDateSlot slot;
  final bool isSelected;
  final VoidCallback onTap;
  final bool compact;

  const _DateSlotCard({
    super.key,
    required this.slot,
    required this.isSelected,
    required this.onTap,
    this.compact = false,
  });

  @override
  State<_DateSlotCard> createState() => _DateSlotCardState();
}

class _DateSlotCardState extends State<_DateSlotCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  bool get _isFull => widget.slot.spotsRemaining != null && widget.slot.spotsRemaining! <= 0;
  bool get _isLowStock => widget.slot.spotsRemaining != null && widget.slot.spotsRemaining! <= 5;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.05),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.05, end: 1.0),
        weight: 50,
      ),
    ]).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.easeOutBack,
    ));
  }

  @override
  void didUpdateWidget(_DateSlotCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _bounceController.forward(from: 0);
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
      builder: (context, child) {
        return Transform.scale(
          scale: _bounceAnimation.value,
          child: child,
        );
      },
      child: GestureDetector(
        onTap: _isFull ? null : widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.all(widget.compact ? 12 : 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.isSelected
                  ? HbColors.brandPrimary
                  : (_isFull ? Colors.grey.shade300 : Colors.grey.shade200),
              width: widget.isSelected ? 2.5 : 1,
            ),
          ),
          child: Row(
            children: [
              // Date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatDate(widget.slot.date),
                      style: TextStyle(
                        fontSize: widget.compact ? 14 : 16,
                        fontWeight: FontWeight.bold,
                        color: _isFull ? Colors.grey : HbColors.textPrimary,
                      ),
                    ),
                    if (widget.slot.startTime != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        _formatTimeRange(),
                        style: TextStyle(
                          fontSize: widget.compact ? 12 : 13,
                          color: _isFull ? Colors.grey : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Stock indicator with urgency animation
              if (widget.slot.spotsRemaining != null) ...[
                const SizedBox(width: 12),
                _buildStockBadge(),
              ],

              // Bouton
              const SizedBox(width: 12),
              _buildActionButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStockBadge() {
    final Color badgeColor;
    final String text;
    final bool showPulse;

    if (_isFull) {
      badgeColor = Colors.red;
      text = '0 place';
      showPulse = false;
    } else if (_isLowStock) {
      badgeColor = Colors.orange;
      text = 'Plus que ${widget.slot.spotsRemaining}!';
      showPulse = true;
    } else {
      badgeColor = Colors.green;
      text = '${widget.slot.spotsRemaining} places';
      showPulse = false;
    }

    final badge = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isLowStock && !_isFull)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Icon(
                Icons.local_fire_department,
                size: 12,
                color: badgeColor,
              ),
            ),
          Text(
            text,
            style: TextStyle(
              color: badgeColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );

    if (showPulse) {
      return OpacityPulse(
        duration: const Duration(milliseconds: 1000),
        minOpacity: 0.7,
        maxOpacity: 1.0,
        child: badge,
      );
    }

    return badge;
  }

  Widget _buildActionButton() {
    if (_isFull) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'Complet',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      );
    }

    if (widget.isSelected) {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: HbColors.brandPrimary,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.check,
          color: Colors.white,
          size: 16,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: HbColors.brandPrimary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'Choisir',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('EEEE d MMMM', 'fr_FR').format(date);
  }

  String _formatTimeRange() {
    if (widget.slot.startTime == null) return '';
    if (widget.slot.endTime != null) {
      return '${widget.slot.startTime} – ${widget.slot.endTime}';
    }
    return widget.slot.startTime!;
  }
}

/// Chip animé pour un créneau (mode horizontal) avec spring bounce
class _AnimatedDateChip extends StatefulWidget {
  final CalendarDateSlot slot;
  final bool isSelected;
  final VoidCallback onTap;
  final int index;

  const _AnimatedDateChip({
    super.key,
    required this.slot,
    required this.isSelected,
    required this.onTap,
    required this.index,
  });

  @override
  State<_AnimatedDateChip> createState() => _AnimatedDateChipState();
}

class _AnimatedDateChipState extends State<_AnimatedDateChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  bool get _isFull => widget.slot.spotsRemaining != null && widget.slot.spotsRemaining! <= 0;
  bool get _isLowStock => widget.slot.spotsRemaining != null && widget.slot.spotsRemaining! <= 5;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.08),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.08, end: 1.0),
        weight: 50,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));
  }

  @override
  void didUpdateWidget(_AnimatedDateChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 200 + (widget.index * 30)),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: GestureDetector(
          onTap: _isFull ? null : widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 76,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: widget.isSelected
                  ? HbColors.brandPrimary
                  : (_isFull ? Colors.grey.shade200 : Colors.white),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: widget.isSelected
                    ? HbColors.brandPrimary
                    : (_isLowStock ? Colors.orange.shade300 : Colors.grey.shade300),
                width: widget.isSelected ? 2 : (_isLowStock ? 2 : 1),
              ),
              boxShadow: widget.isSelected
                  ? [
                      BoxShadow(
                        color: HbColors.brandPrimary.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Jour
                Text(
                  widget.slot.date.day.toString(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: widget.isSelected
                        ? Colors.white
                        : (_isFull ? Colors.grey : HbColors.textPrimary),
                  ),
                ),
                // Jour de la semaine
                Text(
                  DateFormat('EEE', 'fr_FR').format(widget.slot.date),
                  style: TextStyle(
                    fontSize: 12,
                    color: widget.isSelected
                        ? Colors.white.withValues(alpha: 0.8)
                        : Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                // Indicateur
                _buildIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator() {
    if (_isFull) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: widget.isSelected
              ? Colors.white.withValues(alpha: 0.2)
              : Colors.red.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          'COMPLET',
          style: TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.bold,
            color: widget.isSelected ? Colors.white : Colors.red,
          ),
        ),
      );
    }

    if (_isLowStock) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_fire_department,
            size: 10,
            color: widget.isSelected ? Colors.white : Colors.orange,
          ),
          const SizedBox(width: 2),
          Text(
            '${widget.slot.spotsRemaining}',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: widget.isSelected ? Colors.white : Colors.orange,
            ),
          ),
        ],
      );
    }

    if (widget.slot.startTime != null) {
      return Text(
        widget.slot.startTime!,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: widget.isSelected ? Colors.white : HbColors.brandPrimary,
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
