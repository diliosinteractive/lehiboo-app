import 'package:flutter/material.dart';

import '../../data/models/organizer_profile_dto.dart';
import 'organizer_social_link_row.dart';

/// "À propos" section — description, establishment types, social links.
/// Renders inline below the identity card (used to be a tab).
///
/// Spec §1, §3.3 (`description`, `establishment_types`, `social_links`)
class OrganizerAboutSection extends StatelessWidget {
  final OrganizerProfileDto organizer;

  const OrganizerAboutSection({super.key, required this.organizer});

  @override
  Widget build(BuildContext context) {
    final hasDescription =
        organizer.description != null && organizer.description!.isNotEmpty;
    final types = organizer.establishmentTypes ?? const [];
    final hasTypes = types.isNotEmpty;
    final hasSocials = organizer.socialLinks != null &&
        _atLeastOneNonEmpty(organizer.socialLinks!);

    if (!hasDescription && !hasTypes && !hasSocials) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle('À propos'),
          const SizedBox(height: 8),
          if (hasDescription) ...[
            Text(
              organizer.description!,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),
          ],
          if (hasTypes) ...[
            const _SectionTitle('Types d\'établissement'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final type in types)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      type.name,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
          ],
          if (hasSocials) ...[
            const _SectionTitle('Réseaux sociaux'),
            const SizedBox(height: 12),
            OrganizerSocialLinkRow(links: organizer.socialLinks!),
          ],
        ],
      ),
    );
  }

  static bool _atLeastOneNonEmpty(SocialLinksDto links) {
    bool nonEmpty(String? s) => s != null && s.isNotEmpty;
    return nonEmpty(links.facebook) ||
        nonEmpty(links.instagram) ||
        nonEmpty(links.twitter) ||
        nonEmpty(links.linkedin) ||
        nonEmpty(links.youtube);
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1A1A2E),
      ),
    );
  }
}
