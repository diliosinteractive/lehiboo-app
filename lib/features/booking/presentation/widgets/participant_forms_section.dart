import 'package:flutter/material.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/features/booking/domain/models/booking_flow_state.dart';
import 'package:lehiboo/features/events/domain/entities/event_submodels.dart'
    as event_models;

import 'participant_form_card.dart';

/// Groups participant forms by ticket type.
///
/// For each ticket type with quantity > 0, renders N [ParticipantFormCard]
/// widgets where N = quantity. The first participant globally gets the
/// "Same as buyer" toggle.
class ParticipantFormsSection extends StatelessWidget {
  /// Ticket type ID → quantity mapping (same as CheckoutParams.ticketQuantities).
  final Map<String, int> ticketQuantities;

  /// Full ticket list from the event, used to look up names.
  final List<event_models.Ticket> eventTickets;

  /// Current buyer info for the "Same as buyer" toggle pre-fill.
  final BuyerInfo? buyerInfo;

  /// Current attendees map: ticketTypeId → List<ParticipantInfo>.
  final Map<String, List<ParticipantInfo>> attendeesMap;

  /// Called when an attendee is updated.
  /// Parameters: ticketTypeId, attendeeIndex, updatedInfo.
  final void Function(String ticketTypeId, int index, ParticipantInfo info)
      onAttendeeChanged;

  const ParticipantFormsSection({
    super.key,
    required this.ticketQuantities,
    required this.eventTickets,
    this.buyerInfo,
    required this.attendeesMap,
    required this.onAttendeeChanged,
  });

  String _ticketName(String ticketTypeId) {
    final match = eventTickets.where((t) => t.id == ticketTypeId);
    if (match.isNotEmpty) return match.first.name;
    return 'Billet';
  }

  @override
  Widget build(BuildContext context) {
    final activeEntries = ticketQuantities.entries
        .where((e) => e.value > 0)
        .toList();

    if (activeEntries.isEmpty) return const SizedBox.shrink();

    bool isFirstGlobal = true;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Participants',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: HbColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Un formulaire par billet — renseignez chaque participant',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          for (final entry in activeEntries) ...[
            for (int i = 0; i < entry.value; i++) ...[
              Builder(builder: (context) {
                final showToggle = isFirstGlobal;
                if (isFirstGlobal) isFirstGlobal = false;

                final attendees = attendeesMap[entry.key] ?? [];
                final initial = i < attendees.length
                    ? attendees[i]
                    : const ParticipantInfo();

                return ParticipantFormCard(
                  ticketTypeName: _ticketName(entry.key),
                  participantIndex: i + 1,
                  totalForType: entry.value,
                  showSameAsBuyer: showToggle,
                  buyerInfo: buyerInfo,
                  initialValue: initial,
                  onChanged: (info) =>
                      onAttendeeChanged(entry.key, i, info),
                );
              }),
            ],
          ],
        ],
      ),
    );
  }
}
