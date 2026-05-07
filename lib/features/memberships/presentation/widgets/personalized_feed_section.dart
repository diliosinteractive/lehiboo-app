import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/themes/colors.dart';
import '../../../events/data/mappers/event_to_activity_mapper.dart';
import '../../../events/data/mappers/event_mapper.dart';
import '../../../home/presentation/widgets/event_card.dart';
import '../../data/models/personalized_feed_dto.dart';
import '../providers/personalized_feed_provider.dart';

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
                      EventMapper.toEvent(entry.event),
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
