import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/themes/colors.dart';
import '../../../../domain/entities/activity.dart';
import '../../../events/data/mappers/event_to_activity_mapper.dart';
import '../../../events/data/mappers/event_mapper.dart';
import '../../../events/domain/entities/event.dart';
import '../../../events/domain/entities/event_submodels.dart';
import '../../../home/presentation/widgets/event_card.dart';
import '../../../home/presentation/widgets/home_section_title.dart';
import '../../data/models/personalized_feed_dto.dart';
import '../providers/personalized_feed_provider.dart';

class _PersonalizedCardItem {
  final EventWithSections entry;
  final Activity activity;
  final Slot displaySlot;
  final bool isAvailable;

  const _PersonalizedCardItem({
    required this.entry,
    required this.activity,
    required this.displaySlot,
    required this.isAvailable,
  });
}

_PersonalizedCardItem _buildCardItem(EventWithSections entry, DateTime now) {
  final event = EventMapper.toEvent(entry.event);
  final displaySlot = _closestDisplaySlot(event, now);
  final activity = EventToActivityMapper.toActivity(
    event.copyWith(
      startDate: displaySlot.startDateTime,
      endDate: displaySlot.endDateTime,
    ),
  ).copyWith(nextSlot: displaySlot);

  return _PersonalizedCardItem(
    entry: entry,
    activity: activity,
    displaySlot: displaySlot,
    isAvailable: !_isSlotPast(displaySlot, now),
  );
}

Slot _closestDisplaySlot(Event event, DateTime now) {
  final calendarSlots = event.calendar?.dateSlots ?? const <CalendarDateSlot>[];
  if (calendarSlots.isEmpty) return _fallbackSlot(event);

  final slots = calendarSlots
      .map((slot) => _activitySlotFromCalendarSlot(event, slot))
      .toList();
  final available = slots.where((slot) => !_isSlotPast(slot, now)).toList()
    ..sort((a, b) => a.startDateTime.compareTo(b.startDateTime));

  if (available.isNotEmpty) return available.first;

  slots.sort((a, b) {
    final aDistance = a.startDateTime.difference(now).abs();
    final bDistance = b.startDateTime.difference(now).abs();
    return aDistance.compareTo(bDistance);
  });
  return slots.first;
}

Slot _fallbackSlot(Event event) {
  return Slot(
    id: '${event.id}_slot',
    activityId: event.id,
    startDateTime: event.startDate,
    endDateTime: event.endDate,
    capacityTotal: event.totalSeats,
    capacityRemaining: event.availableSeats,
    priceMin: event.minPrice ?? event.price,
    priceMax: event.maxPrice ?? event.price,
    currency: 'EUR',
    indoorOutdoor: event.isIndoor && event.isOutdoor
        ? IndoorOutdoor.both
        : event.isIndoor
            ? IndoorOutdoor.indoor
            : IndoorOutdoor.outdoor,
    status: _eventStatusToSlotStatus(event.status),
  );
}

Slot _activitySlotFromCalendarSlot(Event event, CalendarDateSlot slot) {
  final start = _slotDateTime(
    slot.date,
    slot.startTime,
    fallbackDateTime: event.startDate,
  );
  final end = _slotDateTime(
    slot.date,
    slot.endTime,
    fallbackDateTime: event.endDate,
  );
  final normalizedEnd = end.isAfter(start)
      ? end
      : event.duration != null
          ? start.add(event.duration!)
          : start.add(event.endDate.difference(event.startDate));

  return Slot(
    id: slot.id.isNotEmpty ? slot.id : '${event.id}_${start.toIso8601String()}',
    activityId: event.id,
    startDateTime: start,
    endDateTime: normalizedEnd.isAfter(start) ? normalizedEnd : start,
    capacityTotal: slot.totalCapacity ?? event.totalSeats,
    capacityRemaining: slot.spotsRemaining ?? event.availableSeats,
    priceMin: event.minPrice ?? event.price,
    priceMax: event.maxPrice ?? event.price,
    currency: 'EUR',
    indoorOutdoor: event.isIndoor && event.isOutdoor
        ? IndoorOutdoor.both
        : event.isIndoor
            ? IndoorOutdoor.indoor
            : IndoorOutdoor.outdoor,
    status: 'scheduled',
  );
}

DateTime _slotDateTime(
  DateTime date,
  String? time, {
  required DateTime fallbackDateTime,
}) {
  final parsedTime = _parseTimeOfDay(time);
  if (parsedTime != null) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      parsedTime.$1,
      parsedTime.$2,
    );
  }

  if (_isSameDate(date, fallbackDateTime)) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      fallbackDateTime.hour,
      fallbackDateTime.minute,
      fallbackDateTime.second,
    );
  }

  return date;
}

(int, int)? _parseTimeOfDay(String? value) {
  if (value == null || value.trim().isEmpty) return null;
  final parts = value.trim().split(':');
  if (parts.length < 2) return null;
  final hour = int.tryParse(parts[0]);
  final minute = int.tryParse(parts[1]);
  if (hour == null || minute == null) return null;
  if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;
  return (hour, minute);
}

bool _isSlotPast(Slot slot, DateTime now) =>
    _effectiveSlotEnd(slot).isBefore(now);

DateTime _effectiveSlotEnd(Slot slot) {
  final start = slot.startDateTime;
  final end = slot.endDateTime;
  final isDateOnly = _isMidnight(start) && _isMidnight(end);
  if (isDateOnly && _isSameDate(start, end)) {
    return DateTime(start.year, start.month, start.day, 23, 59, 59, 999);
  }
  return end;
}

bool _isMidnight(DateTime value) =>
    value.hour == 0 &&
    value.minute == 0 &&
    value.second == 0 &&
    value.millisecond == 0 &&
    value.microsecond == 0;

bool _isSameDate(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

int _compareCardItems(_PersonalizedCardItem a, _PersonalizedCardItem b) {
  if (a.isAvailable != b.isAvailable) return a.isAvailable ? -1 : 1;
  return a.displaySlot.startDateTime.compareTo(b.displaySlot.startDateTime);
}

String _eventStatusToSlotStatus(EventStatus status) {
  switch (status) {
    case EventStatus.cancelled:
      return 'cancelled';
    case EventStatus.soldOut:
      return 'sold_out';
    case EventStatus.completed:
      return 'completed';
    default:
      return 'scheduled';
  }
}

/// "Pour vous" carousel — spec §11.
///
/// Hidden when the user is logged out or the server returns an empty list
/// (cold-start users with no signal). When data is available, surfaces
/// horizontally above the daily activity sections on the home screen.
class PersonalizedFeedSection extends ConsumerWidget {
  const PersonalizedFeedSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(personalizedFeedProvider);

    return feedAsync.when(
      // Loading state is silent — the home screen has plenty of other
      // content to show, no need to flash a spinner here.
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (view) {
        if (view.isEmpty) return const SizedBox.shrink();

        final now = DateTime.now();
        final items = view.ordered
            .map((entry) => _buildCardItem(entry, now))
            .toList()
          ..sort(_compareCardItems);

        // Thread each entry's section attribution into the card's badges.
        // Section membership is the source of truth for "this event is
        // in favourites/private" — the per-event flags are unreliable
        // (see docs/PERSONALIZED_FEED_MOBILE_SPEC.md §3.3 / §4.3).
        return Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: HomeSectionTitle(
                  title: context.l10n.personalizedFeedTitle,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: HbColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 360,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final entry = item.entry;
                    final isFavorite =
                        entry.sections.contains(PersonalizedSection.favorites);
                    final isPrivate =
                        entry.sections.contains(PersonalizedSection.private);
                    return SizedBox(
                      width: 200,
                      child: EventCard(
                        activity: item.activity,
                        isCompact: true,
                        isToday:
                            _isSameDate(item.displaySlot.startDateTime, now),
                        isTomorrow: _isSameDate(
                          item.displaySlot.startDateTime,
                          now.add(const Duration(days: 1)),
                        ),
                        heroTagPrefix: 'pour-vous-$index',
                        forceFavoriteFilled: isFavorite,
                        forcePrivateBadge: isPrivate,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
