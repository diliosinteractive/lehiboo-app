/// Subset of `TicketResource` the gate UI needs. The full resource is large
/// (booking, payment, customer, etc.); the gate only needs identity +
/// status fields. Unknown keys are ignored — see MOBILE_CHECKIN_SPEC.md
/// §18 ("clients MUST ignore unknown keys").
class TicketSummaryDto {
  final String uuid;
  final String? status;
  final String? attendeeFirstName;
  final String? attendeeLastName;
  final String? ticketTypeName;
  final String? eventTitle;
  final String? slotStartDatetime;
  final int checkInCount;

  const TicketSummaryDto({
    required this.uuid,
    this.status,
    this.attendeeFirstName,
    this.attendeeLastName,
    this.ticketTypeName,
    this.eventTitle,
    this.slotStartDatetime,
    this.checkInCount = 0,
  });

  String get attendeeFullName {
    final parts = [attendeeFirstName, attendeeLastName]
        .where((p) => p != null && p.isNotEmpty)
        .cast<String>();
    return parts.join(' ').trim();
  }

  factory TicketSummaryDto.fromJson(Map<String, dynamic> json) {
    final ticketType = json['ticket_type'];
    final event = json['event'];
    final slot = json['slot'];

    String? ticketTypeName;
    if (ticketType is Map<String, dynamic>) {
      ticketTypeName = ticketType['name']?.toString();
    }

    String? eventTitle;
    if (event is Map<String, dynamic>) {
      eventTitle = event['title']?.toString();
    }

    String? slotStart;
    if (slot is Map<String, dynamic>) {
      slotStart = slot['start_datetime']?.toString();
    }

    int parseCount(dynamic v) {
      if (v is int) return v;
      if (v is num) return v.toInt();
      if (v is String) return int.tryParse(v) ?? 0;
      return 0;
    }

    return TicketSummaryDto(
      uuid: json['uuid']?.toString() ?? '',
      status: json['status']?.toString(),
      attendeeFirstName: json['attendee_first_name']?.toString(),
      attendeeLastName: json['attendee_last_name']?.toString(),
      ticketTypeName: ticketTypeName,
      eventTitle: eventTitle,
      slotStartDatetime: slotStart,
      checkInCount: parseCount(json['check_in_count']),
    );
  }
}

class SlotCheckDto {
  final String? slotStart;
  final int toleranceMinutes;
  final bool isWithinWindow;

  const SlotCheckDto({
    this.slotStart,
    this.toleranceMinutes = 60,
    this.isWithinWindow = true,
  });

  factory SlotCheckDto.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const SlotCheckDto();
    int parseInt(dynamic v) {
      if (v is int) return v;
      if (v is num) return v.toInt();
      if (v is String) return int.tryParse(v) ?? 60;
      return 60;
    }

    return SlotCheckDto(
      slotStart: json['slot_start']?.toString(),
      toleranceMinutes: parseInt(json['tolerance_minutes']),
      isWithinWindow: json['is_within_window'] == true,
    );
  }
}
