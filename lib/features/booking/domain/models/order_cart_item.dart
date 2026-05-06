import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import 'package:lehiboo/features/events/domain/entities/event_submodels.dart';

class OrderCartItem extends Equatable {
  final Event event;
  final String slotId;
  final CalendarDateSlot? selectedSlot;
  final Ticket ticket;
  final int quantity;

  const OrderCartItem({
    required this.event,
    required this.slotId,
    required this.ticket,
    required this.quantity,
    this.selectedSlot,
  });

  String get id => '${event.id}:$slotId:${ticket.id}';

  double get lineTotal => ticket.price * quantity;

  OrderCartItem copyWith({
    Event? event,
    String? slotId,
    CalendarDateSlot? selectedSlot,
    Ticket? ticket,
    int? quantity,
  }) {
    return OrderCartItem(
      event: event ?? this.event,
      slotId: slotId ?? this.slotId,
      selectedSlot: selectedSlot ?? this.selectedSlot,
      ticket: ticket ?? this.ticket,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toCacheJson() => {
        'event': {
          'id': event.id,
          'slug': event.slug,
          'title': event.title,
          'venue': event.venue,
          'city': event.city,
          'images': event.images,
          'organizer_id': event.organizerId,
          'organizer_name': event.organizerName,
        },
        'slot': selectedSlot == null
            ? {
                'id': slotId,
              }
            : {
                'id': selectedSlot!.id,
                'date': selectedSlot!.date.toIso8601String(),
                'start_time': selectedSlot!.startTime,
                'end_time': selectedSlot!.endTime,
                'spots_remaining': selectedSlot!.spotsRemaining,
                'total_capacity': selectedSlot!.totalCapacity,
              },
        'ticket': {
          'id': ticket.id,
          'name': ticket.name,
          'price': ticket.price,
          'description': ticket.description,
        },
        'quantity': quantity,
      };

  static OrderCartItem? fromCacheJson(Map<String, dynamic> json) {
    try {
      final eventJson = Map<String, dynamic>.from(json['event'] as Map);
      final slotJson = Map<String, dynamic>.from(json['slot'] as Map);
      final ticketJson = Map<String, dynamic>.from(json['ticket'] as Map);
      final slotDate = DateTime.tryParse(slotJson['date']?.toString() ?? '');

      final event = Event.minimal(
        id: eventJson['id']?.toString() ?? '',
        slug: eventJson['slug']?.toString() ?? '',
        title: eventJson['title']?.toString() ?? '',
        venue: eventJson['venue']?.toString() ?? '',
        city: eventJson['city']?.toString() ?? '',
        images: (eventJson['images'] as List?)?.cast<String>() ?? const [],
        organizerId: eventJson['organizer_id']?.toString() ?? '',
        organizerName: eventJson['organizer_name']?.toString() ?? '',
      );

      return OrderCartItem(
        event: event,
        slotId: slotJson['id']?.toString() ?? '',
        selectedSlot: slotDate == null
            ? null
            : CalendarDateSlot(
                id: slotJson['id']?.toString() ?? '',
                date: slotDate,
                startTime: slotJson['start_time']?.toString(),
                endTime: slotJson['end_time']?.toString(),
                spotsRemaining: slotJson['spots_remaining'] as int?,
                totalCapacity: slotJson['total_capacity'] as int?,
              ),
        ticket: Ticket(
          id: ticketJson['id']?.toString() ?? '',
          name: ticketJson['name']?.toString() ?? 'Billet',
          price: (ticketJson['price'] as num?)?.toDouble() ?? 0,
          description: ticketJson['description']?.toString(),
        ),
        quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      );
    } catch (_) {
      return null;
    }
  }

  static String encodeList(List<OrderCartItem> items) =>
      jsonEncode(items.map((item) => item.toCacheJson()).toList());

  static List<OrderCartItem> decodeList(String? raw) {
    if (raw == null || raw.isEmpty) return const [];

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const [];

      return decoded
          .whereType<Map>()
          .map((item) => OrderCartItem.fromCacheJson(
                Map<String, dynamic>.from(item),
              ))
          .whereType<OrderCartItem>()
          .where((item) => item.event.id.isNotEmpty && item.quantity > 0)
          .toList();
    } catch (_) {
      return const [];
    }
  }

  @override
  List<Object?> get props => [event.id, slotId, ticket.id, quantity];
}
