import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lehiboo/features/events/data/models/event_dto.dart';
import '../../data/datasources/organizer_service.dart';

final organizerProfileProvider = FutureProvider.family<EventOrganizerDto, int>((ref, id) async {
  final service = ref.watch(organizerServiceProvider);
  return service.getOrganizer(id);
});

final organizerEventsProvider = FutureProvider.family<EventsResponseDto, int>((ref, id) async {
  final service = ref.watch(organizerServiceProvider);
  // Default to upcoming, page 1, perPage 10 for now. 
  // We can add parameters to the provider family if needed later for pagination/filtering.
  return service.getOrganizerEvents(id);
});
