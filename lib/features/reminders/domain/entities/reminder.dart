import 'package:equatable/equatable.dart';

class Reminder extends Equatable {
  final String id;
  final DateTime createdAt;
  final bool notified7Days;
  final bool notified1Day;
  final String eventUuid;
  final String eventSlug;
  final String eventTitle;
  final String? eventImage;
  final String? venueName;
  final String? city;
  final DateTime slotDate;
  final String? startTime;
  final String? endTime;

  const Reminder({
    required this.id,
    required this.createdAt,
    this.notified7Days = false,
    this.notified1Day = false,
    required this.eventUuid,
    required this.eventSlug,
    required this.eventTitle,
    this.eventImage,
    this.venueName,
    this.city,
    required this.slotDate,
    this.startTime,
    this.endTime,
  });

  /// Slot UUID (same as id for this entity)
  String get slotUuid => id;

  @override
  List<Object?> get props => [
        id,
        eventUuid,
        slotDate,
      ];
}
