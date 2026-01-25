import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/features/events/domain/entities/event_submodels.dart';

/// Sélecteur de dates intelligent avec 3 modes:
/// - Mode Liste (1-5 dates): Liste verticale
/// - Mode Horizontal (6-15 dates): Calendrier scrollable
/// - Mode Calendrier (>15 dates): Calendrier mensuel
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
        children: widget.slots.map((slot) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _DateSlotCard(
              slot: slot,
              isSelected: slot.id == widget.selectedSlotId,
              onTap: () => _selectSlot(slot),
            ),
          );
        }).toList(),
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
              height: 100,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: entry.value.length,
                itemBuilder: (context, index) {
                  final slot = entry.value[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: _DateChip(
                      slot: slot,
                      isSelected: slot.id == widget.selectedSlotId,
                      onTap: () => _selectSlot(slot),
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

/// Card pour un créneau (mode liste)
class _DateSlotCard extends StatelessWidget {
  final CalendarDateSlot slot;
  final bool isSelected;
  final VoidCallback onTap;
  final bool compact;

  const _DateSlotCard({
    required this.slot,
    required this.isSelected,
    required this.onTap,
    this.compact = false,
  });

  bool get _isFull => slot.spotsRemaining != null && slot.spotsRemaining! <= 0;
  bool get _isLowStock => slot.spotsRemaining != null && slot.spotsRemaining! <= 5;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isFull ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(compact ? 12 : 16),
        decoration: BoxDecoration(
          color: isSelected
              ? HbColors.brandPrimary.withValues(alpha: 0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? HbColors.brandPrimary
                : (_isFull ? Colors.grey.shade300 : Colors.grey.shade200),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: HbColors.brandPrimary.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            // Date
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatDate(slot.date),
                    style: TextStyle(
                      fontSize: compact ? 14 : 16,
                      fontWeight: FontWeight.bold,
                      color: _isFull ? Colors.grey : HbColors.textPrimary,
                    ),
                  ),
                  if (slot.startTime != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      _formatTimeRange(),
                      style: TextStyle(
                        fontSize: compact ? 12 : 13,
                        color: _isFull ? Colors.grey : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Stock indicator
            if (slot.spotsRemaining != null) ...[
              const SizedBox(width: 12),
              _buildStockBadge(),
            ],

            // Bouton
            const SizedBox(width: 12),
            if (_isFull)
              Container(
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
              )
            else if (isSelected)
              Container(
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
              )
            else
              Container(
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
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStockBadge() {
    final Color badgeColor;
    final String text;

    if (_isFull) {
      badgeColor = Colors.red;
      text = '0 place';
    } else if (_isLowStock) {
      badgeColor = Colors.orange;
      text = '${slot.spotsRemaining} places';
    } else {
      badgeColor = Colors.green;
      text = '${slot.spotsRemaining} places';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: badgeColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('EEEE d MMMM', 'fr_FR').format(date);
  }

  String _formatTimeRange() {
    if (slot.startTime == null) return '';
    if (slot.endTime != null) {
      return '${slot.startTime} – ${slot.endTime}';
    }
    return slot.startTime!;
  }
}

/// Chip pour un créneau (mode horizontal)
class _DateChip extends StatelessWidget {
  final CalendarDateSlot slot;
  final bool isSelected;
  final VoidCallback onTap;

  const _DateChip({
    required this.slot,
    required this.isSelected,
    required this.onTap,
  });

  bool get _isFull => slot.spotsRemaining != null && slot.spotsRemaining! <= 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isFull ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 72,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? HbColors.brandPrimary
              : (_isFull ? Colors.grey.shade200 : Colors.white),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? HbColors.brandPrimary
                : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: HbColors.brandPrimary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Jour
            Text(
              slot.date.day.toString(),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? Colors.white
                    : (_isFull ? Colors.grey : HbColors.textPrimary),
              ),
            ),
            // Jour de la semaine
            Text(
              DateFormat('EEE', 'fr_FR').format(slot.date),
              style: TextStyle(
                fontSize: 12,
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.8)
                    : Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 4),
            // Indicateur
            if (_isFull)
              Text(
                'COMPLET',
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.red,
                ),
              )
            else if (slot.startTime != null)
              Text(
                slot.startTime!,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : HbColors.brandPrimary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
