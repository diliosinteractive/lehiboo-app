import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/themes/colors.dart';
import '../../../memberships/presentation/widgets/organizer_join_button.dart';
import '../../data/models/organizer_profile_dto.dart';
import 'organizer_follow_button.dart';

/// Display name (with verified badge + follow button), city chip, stats row.
///
/// The avatar lives in the cover header (overlapping the cover bottom).
///
/// Spec §1, §7
class OrganizerIdentityCard extends StatelessWidget {
  final OrganizerProfileDto organizer;
  final int liveFollowersCount;

  const OrganizerIdentityCard({
    super.key,
    required this.organizer,
    required this.liveFollowersCount,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = (organizer.displayName?.isNotEmpty ?? false)
        ? organizer.displayName!
        : organizer.name;
    // is_owner is tri-state per MEMBERSHIPS spec §18 — null/false both keep
    // the join button visible; only `true` hides it.
    final showJoin = organizer.isOwner != true;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Wrap (rather than Row) so two pills next to the name flow to a
          // second line on narrow screens or with long names instead of
          // squeezing the title.
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              Text(
                displayName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (organizer.verified)
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.asset(
                    'assets/images/lehiboo_vendor_badge.png',
                    width: 22,
                    height: 22,
                  ),
                ),
              OrganizerFollowButton(organizerUuid: organizer.uuid),
              if (showJoin)
                OrganizerJoinButton(
                  organizerUuid: organizer.uuid,
                  organizerName: displayName,
                ),
            ],
          ),
          if (organizer.city != null && organizer.city!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: _CityChip(city: organizer.city!),
            ),
          const SizedBox(height: 14),
          _StatsRow(
            eventsCount: organizer.eventsCount,
            followersCount: liveFollowersCount,
            membersCount: organizer.membersCount,
            reviewsCount: organizer.reviewsCount,
            averageRating: organizer.averageRating,
          ),
        ],
      ),
    );
  }
}

class _CityChip extends StatelessWidget {
  final String city;
  const _CityChip({required this.city});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.place_outlined, size: 14, color: Colors.grey[700]),
          const SizedBox(width: 4),
          Text(
            city,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final int eventsCount;
  final int followersCount;
  final int membersCount;
  final int reviewsCount;
  final double? averageRating;

  const _StatsRow({
    required this.eventsCount,
    required this.followersCount,
    required this.membersCount,
    required this.reviewsCount,
    required this.averageRating,
  });

  @override
  Widget build(BuildContext context) {
    final compact = context.appCompactNumberFormat;
    final showRating = (averageRating ?? 0) > 0;

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        _stat(
          icon: Icons.local_activity_outlined,
          label: '${compact.format(eventsCount)} '
              '${eventsCount > 1 ? 'événements' : 'événement'}',
        ),
        _stat(
          icon: Icons.favorite_outline,
          iconColor: Colors.red.shade400,
          label: '${compact.format(followersCount)} '
              '${followersCount > 1 ? 'abonnés' : 'abonné'}',
        ),
        _stat(
          icon: Icons.groups_outlined,
          label: '${compact.format(membersCount)} '
              '${membersCount > 1 ? 'membres' : 'membre'}',
        ),
        if (showRating)
          _stat(
            icon: Icons.star_rounded,
            iconColor: HbColors.brandPrimary,
            label: '${averageRating!.toStringAsFixed(1)}'
                ' (${compact.format(reviewsCount)} '
                '${reviewsCount > 1 ? 'avis' : 'avis'})',
          ),
      ],
    );
  }

  Widget _stat({
    required IconData icon,
    required String label,
    Color? iconColor,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: iconColor ?? Colors.grey[700]),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[800],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
