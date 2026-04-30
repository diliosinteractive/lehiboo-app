import 'package:flutter/material.dart';

import '../../../../core/themes/colors.dart';
import '../../data/models/organizer_profile_dto.dart';

/// "Avis" tab placeholder — backend doesn't expose per-review fetching yet,
/// so we render an empty state and surface the aggregates from the profile
/// when they exist.
///
/// Spec §10, §14
class OrganizerReviewsTabPlaceholder extends StatelessWidget {
  final OrganizerProfileDto organizer;

  const OrganizerReviewsTabPlaceholder({super.key, required this.organizer});

  @override
  Widget build(BuildContext context) {
    final rating = organizer.averageRating ?? 0;
    final count = organizer.reviewsCount;
    final hasAggregate = rating > 0 || count > 0;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.reviews_outlined,
                size: 56, color: HbColors.brandPrimary),
            const SizedBox(height: 16),
            if (hasAggregate) ...[
              Text(
                rating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$count ${count > 1 ? "avis" : "avis"}',
                style: TextStyle(color: Colors.grey[700]),
              ),
              const SizedBox(height: 16),
            ],
            Text(
              "Le détail des avis arrive bientôt.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
