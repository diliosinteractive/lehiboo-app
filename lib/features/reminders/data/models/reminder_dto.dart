import '../../domain/entities/reminder.dart';

class ReminderDto {
  final String id;
  final String uuid;
  final String createdAt;
  final String? notified7DaysAt;
  final String? notified1DayAt;
  final ReminderEventDto? event;
  final ReminderSlotDto? slot;

  ReminderDto({
    required this.id,
    required this.uuid,
    required this.createdAt,
    this.notified7DaysAt,
    this.notified1DayAt,
    this.event,
    this.slot,
  });

  factory ReminderDto.fromJson(Map<String, dynamic> json) {
    return ReminderDto(
      id: (json['uuid'] ?? json['id'] ?? '').toString(),
      uuid: (json['uuid'] ?? json['id'] ?? '').toString(),
      createdAt: (json['created_at'] ?? json['createdAt'] ?? '').toString(),
      notified7DaysAt: json['notified_7_days_at']?.toString() ??
          json['notified7DaysAt']?.toString(),
      notified1DayAt: json['notified_1_day_at']?.toString() ??
          json['notified1DayAt']?.toString(),
      event: json['event'] is Map<String, dynamic>
          ? ReminderEventDto.fromJson(json['event'])
          : null,
      slot: json['slot'] is Map<String, dynamic>
          ? ReminderSlotDto.fromJson(json['slot'])
          : null,
    );
  }

  Reminder toEntity() {
    DateTime slotDate;
    try {
      slotDate = DateTime.parse(
          slot?.slotDate ?? DateTime.now().toIso8601String());
    } catch (_) {
      slotDate = DateTime.now();
    }

    return Reminder(
      id: uuid,
      createdAt: DateTime.tryParse(createdAt) ?? DateTime.now(),
      notified7Days: notified7DaysAt != null,
      notified1Day: notified1DayAt != null,
      eventUuid: event?.uuid ?? event?.id ?? '',
      eventSlug: event?.slug ?? '',
      eventTitle: event?.title ?? '',
      eventImage: event?.featuredImage ?? event?.coverImage,
      venueName: event?.location?['name']?.toString(),
      city: event?.location?['city']?.toString(),
      slotDate: slotDate,
      startTime: slot?.startTime,
      endTime: slot?.endTime,
    );
  }
}

class ReminderEventDto {
  final String? id;
  final String? uuid;
  final String? slug;
  final String? title;
  final String? featuredImage;
  final String? coverImage;
  final Map<String, dynamic>? location;

  ReminderEventDto({
    this.id,
    this.uuid,
    this.slug,
    this.title,
    this.featuredImage,
    this.coverImage,
    this.location,
  });

  factory ReminderEventDto.fromJson(Map<String, dynamic> json) {
    return ReminderEventDto(
      id: json['id']?.toString(),
      uuid: json['uuid']?.toString(),
      slug: json['slug']?.toString(),
      title: json['title']?.toString(),
      featuredImage: json['featured_image']?.toString(),
      coverImage: json['cover_image']?.toString(),
      location: json['location'] is Map<String, dynamic>
          ? json['location']
          : null,
    );
  }
}

class ReminderSlotDto {
  final String? id;
  final String? uuid;
  final String? slotDate;
  final String? startTime;
  final String? endTime;

  ReminderSlotDto({
    this.id,
    this.uuid,
    this.slotDate,
    this.startTime,
    this.endTime,
  });

  factory ReminderSlotDto.fromJson(Map<String, dynamic> json) {
    return ReminderSlotDto(
      id: json['id']?.toString(),
      uuid: json['uuid']?.toString(),
      slotDate: (json['slot_date'] ?? json['slotDate'])?.toString(),
      startTime: (json['start_time'] ?? json['startTime'])?.toString(),
      endTime: (json['end_time'] ?? json['endTime'])?.toString(),
    );
  }
}
