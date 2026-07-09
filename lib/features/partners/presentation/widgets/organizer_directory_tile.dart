import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/themes/colors.dart';
import '../../data/models/organizer_profile_dto.dart';
import 'organizer_avatar.dart';

/// One card in the public organizers directory.
///
/// Flat design (no shadows): a bordered card with the organizer identity on
/// top and a row of stat pills (events / followers / rating) below. Tapping
/// the card opens the organizer profile.
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
    final hasCity = organizer.city != null && organizer.city!.isNotEmpty;
    final rating = organizer.averageRating;
    final showRating = rating != null && organizer.reviewsCount > 0;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: () => context.push('/organizers/${organizer.uuid}'),
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFEDEFF3)),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  OrganizerAvatar(
                    logoUrl: organizer.logo,
                    fallbackName: displayName,
                    size: 48,
                    showShadow: false,
                  ),
                  const SizedBox(width: 12),
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
                                  fontWeight: FontWeight.w700,
                                  color: HbColors.textPrimary,
                                  height: 1.2,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (organizer.verified) ...[
                              const SizedBox(width: 5),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(3),
                                child: Image.asset(
                                  'assets/images/lehiboo_vendor_badge.png',
                                  width: 15,
                                  height: 15,
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (hasCity) ...[
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              Icon(Icons.location_on_outlined,
                                  size: 13, color: Colors.grey[500]),
                              const SizedBox(width: 3),
                              Flexible(
                                child: Text(
                                  organizer.city!,
                                  style: GoogleFonts.figtree(
                                    fontSize: 12.5,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(Icons.chevron_right, color: Colors.grey[400]),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _StatPill(
                    icon: Icons.event_outlined,
                    label: context.l10n.organizerEventsCount(
                      compact.format(organizer.eventsCount),
                      organizer.eventsCount,
                    ),
                  ),
                  _StatPill(
                    icon: Icons.group_outlined,
                    label: context.l10n.organizerFollowersCount(
                      compact.format(organizer.followersCount),
                      organizer.followersCount,
                    ),
                  ),
                  if (showRating)
                    _StatPill(
                      icon: Icons.star_rounded,
                      iconColor: const Color(0xFFF5A623),
                      label: context.l10n.organizerRatingWithReviews(
                        rating.toStringAsFixed(1),
                        compact.format(organizer.reviewsCount),
                        organizer.reviewsCount,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small flat stat chip (icon + label) on a light grey background.
class _StatPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? iconColor;

  const _StatPill({
    required this.icon,
    required this.label,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6F9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: iconColor ?? Colors.grey[600]),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.figtree(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: HbColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
