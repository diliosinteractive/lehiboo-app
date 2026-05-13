import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/themes/colors.dart';
import '../../../events/data/mappers/event_to_activity_mapper.dart';
import '../../../events/data/mappers/event_mapper.dart';
import '../../../events/domain/entities/event.dart';
import '../../../home/presentation/widgets/event_card.dart';
import '../../data/models/personalized_feed_dto.dart';
import '../providers/personalized_feed_provider.dart';

/// If [event] has multiple calendar slots, rewrite its `startDate` to the
/// earliest slot whose date is today or later. Events with no future slot
/// (one-off past events a user favourited, expired reminders) keep their
/// original date so cards still render meaningful content for strata 3 & 4.
///
/// Time-of-day is preserved from the original `event.startDate`; the slot
/// model stores start/end as "HH:mm" strings and the common case (recurring
/// weekly events) has every slot at the same time of day, so reusing the
/// original avoids parsing without changing the displayed time.
Event _eventWithUpcomingSlot(Event event) {
  final slots = event.calendar?.dateSlots ?? const [];
  if (slots.isEmpty) return event;

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  final upcoming = slots.where((s) => !s.date.isBefore(today)).toList()
    ..sort((a, b) => a.date.compareTo(b.date));

  if (upcoming.isEmpty) return event;

  final pickedDate = upcoming.first.date;
  final origStart = event.startDate;
  final newStart = DateTime(
    pickedDate.year,
    pickedDate.month,
    pickedDate.day,
    origStart.hour,
    origStart.minute,
  );
  // Already showing the earliest future slot? Skip the copyWith allocation.
  if (newStart.isAtSameMomentAs(origStart)) return event;

  final newEnd = newStart.add(event.endDate.difference(origStart));
  return event.copyWith(startDate: newStart, endDate: newEnd);
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

        // Sprint 2: iterate `view.ordered` directly so we can thread
        // each entry's section attribution into the card's badges.
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
                child: Text(
                  'Pour vous',
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: HbColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 360,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: view.ordered.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final entry = view.ordered[index];
                    final isFavorite =
                        entry.sections.contains(PersonalizedSection.favorites);
                    final isPrivate =
                        entry.sections.contains(PersonalizedSection.private);
                    final activity = EventToActivityMapper.toActivity(
                      _eventWithUpcomingSlot(EventMapper.toEvent(entry.event)),
                    );
                    return SizedBox(
                      width: 200,
                      child: EventCard(
                        activity: activity,
                        isCompact: true,
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
