import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/themes/colors.dart';
import '../../data/models/organizer_profile_dto.dart';
import 'organizer_avatar.dart';

/// One row in the "Organisateurs suivis" list.
///
/// Tap row → org profile. The trailing pill is the inline unfollow action;
/// the parent controls its loading state.
class FollowedOrganizerTile extends StatelessWidget {
  final OrganizerProfileDto organizer;
  final VoidCallback onUnfollowTap;

  const FollowedOrganizerTile({
    super.key,
    required this.organizer,
    required this.onUnfollowTap,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = organizer.displayName?.isNotEmpty ?? false
        ? organizer.displayName!
        : organizer.name;
    final compact = context.appCompactNumberFormat;

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
                    [
                      if (organizer.city != null && organizer.city!.isNotEmpty)
                        organizer.city,
                      '${compact.format(organizer.eventsCount)} '
                          '${organizer.eventsCount > 1 ? "événements" : "événement"}',
                    ].whereType<String>().join(' • '),
                    style: GoogleFonts.figtree(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            _UnfollowButton(onTap: onUnfollowTap),
          ],
        ),
      ),
    );
  }
}

class _UnfollowButton extends StatelessWidget {
  final VoidCallback onTap;

  const _UnfollowButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: HbColors.brandPrimary),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.person_remove_outlined,
                size: 14, color: HbColors.brandPrimary),
            const SizedBox(width: 4),
            Text(
              'Ne plus suivre',
              style: GoogleFonts.figtree(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: HbColors.brandPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
