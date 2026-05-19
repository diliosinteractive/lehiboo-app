import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/themes/colors.dart';
import '../../data/models/organizer_profile_dto.dart';
import 'organizer_social_link_row.dart';

/// "À propos" section — description, establishment types, social links.
/// Renders inline below the identity card (used to be a tab).
///
/// Spec §1, §3.3 (`description`, `establishment_types`, `social_links`)
class OrganizerAboutSection extends StatefulWidget {
  final OrganizerProfileDto organizer;

  const OrganizerAboutSection({super.key, required this.organizer});

  @override
  State<OrganizerAboutSection> createState() => _OrganizerAboutSectionState();
}

class _OrganizerAboutSectionState extends State<OrganizerAboutSection> {
  static const int _maxDescriptionLength = 250;

  bool _isDescriptionExpanded = false;

  @override
  Widget build(BuildContext context) {
    final organizer = widget.organizer;
    final description = organizer.description;
    final hasDescription = description != null && description.isNotEmpty;
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
          _SectionTitle(context.l10n.organizerAboutTitle),
          const SizedBox(height: 8),
          if (hasDescription) ...[
            _ExpandableDescription(
              description: description,
              maxLength: _maxDescriptionLength,
              isExpanded: _isDescriptionExpanded,
              onToggle: () {
                HapticFeedback.lightImpact();
                setState(
                    () => _isDescriptionExpanded = !_isDescriptionExpanded);
              },
            ),
            const SizedBox(height: 16),
          ],
          if (hasTypes) ...[
            _SectionTitle(context.l10n.organizerEstablishmentTypesTitle),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final type in types)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
            _SectionTitle(context.l10n.organizerSocialLinksTitle),
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

class _ExpandableDescription extends StatelessWidget {
  final String description;
  final int maxLength;
  final bool isExpanded;
  final VoidCallback onToggle;

  const _ExpandableDescription({
    required this.description,
    required this.maxLength,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isLongText = description.length > maxLength;
    final textStyle = TextStyle(
      fontSize: 14,
      height: 1.5,
      color: Colors.grey[800],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedCrossFade(
          firstChild: Text(
            isLongText
                ? '${description.substring(0, maxLength)}...'
                : description,
            style: textStyle,
          ),
          secondChild: Text(description, style: textStyle),
          crossFadeState:
              isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
        if (isLongText)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: GestureDetector(
              onTap: onToggle,
              child: Row(
                children: [
                  Text(
                    isExpanded
                        ? context.l10n.searchShowLess
                        : context.l10n.eventReadMore,
                    style: const TextStyle(
                      color: HbColors.brandPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 4),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      size: 18,
                      color: HbColors.brandPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
