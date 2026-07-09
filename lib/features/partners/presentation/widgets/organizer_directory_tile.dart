import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/themes/colors.dart';
import '../../data/models/organizer_profile_dto.dart';
import 'organizer_avatar.dart';

/// One row in the public organizers directory.
///
/// Tap row → org profile. Unlike [FollowedOrganizerTile] there is no inline
/// follow/unfollow action (the directory endpoint is public and does not
/// carry the authed follow state), so the trailing slot shows a chevron.
class OrganizerDirectoryTile extends StatelessWidget {
  final OrganizerProfileDto organizer;

  const OrganizerDirectoryTile({
    super.key,
    required this.organizer,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = organizer.displayName?.isNotEmpty ?? false
        ? organizer.displayName!
        : organizer.name;
    final compact = context.appCompactNumberFormat;

    final subtitle = [
      if (organizer.city != null && organizer.city!.isNotEmpty) organizer.city,
      context.l10n.organizerEventsCount(
        compact.format(organizer.eventsCount),
        organizer.eventsCount,
      ),
    ].whereType<String>().join(' • ');

    final rating = organizer.averageRating;
    final showRating = rating != null && organizer.reviewsCount > 0;

    return InkWell(
      onTap: () => context.push('/organizers/${organizer.uuid}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            OrganizerAvatar(
              logoUrl: organizer.logo,
              fallbackName: displayName,
              size: 52,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          displayName,
                          style: GoogleFonts.montserrat(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: HbColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (organizer.verified) ...[
                        const SizedBox(width: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: Image.asset(
                            'assets/images/lehiboo_vendor_badge.png',
                            width: 16,
                            height: 16,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.figtree(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (showRating) ...[
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star_rounded,
                            size: 15, color: Color(0xFFF5A623)),
                        const SizedBox(width: 3),
                        Text(
                          context.l10n.organizerRatingWithReviews(
                            rating.toStringAsFixed(1),
                            compact.format(organizer.reviewsCount),
                            organizer.reviewsCount,
                          ),
                          style: GoogleFonts.figtree(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
