import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/themes/colors.dart';
import '../../data/models/organizer_profile_dto.dart';

/// Reveals email / phone / website in a compact row of action chips.
/// Hidden until the user expands it via the Coordinates button.
///
/// Spec §1, §10
class OrganizerCoordinatesPanel extends StatelessWidget {
  final OrganizerProfileDto organizer;

  const OrganizerCoordinatesPanel({super.key, required this.organizer});

  @override
  Widget build(BuildContext context) {
    final entries = <_Entry>[
      if (organizer.email != null && organizer.email!.isNotEmpty)
        _Entry(
          icon: Icons.mail_outline,
          label: organizer.email!,
          onTap: () => _open('mailto:${organizer.email}'),
        ),
      if (organizer.phone != null && organizer.phone!.isNotEmpty)
        _Entry(
          icon: Icons.phone_outlined,
          label: organizer.phone!,
          onTap: () => _open('tel:${organizer.phone}'),
        ),
      if (organizer.website != null && organizer.website!.isNotEmpty)
        _Entry(
          icon: Icons.language,
          label: organizer.website!,
          onTap: () => _open(organizer.website!),
        ),
    ];

    if (entries.isEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
        child: Text(
          context.l10n.organizerNoCoordinates,
          style: TextStyle(color: Colors.grey[600], fontSize: 13),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [for (final e in entries) _Chip(entry: e)],
      ),
    );
  }

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _Entry {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  _Entry({required this.icon, required this.label, required this.onTap});
}

class _Chip extends StatelessWidget {
  final _Entry entry;
  const _Chip({required this.entry});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: entry.onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: HbColors.brandPrimary.withValues(alpha: 0.08),
          border: Border.all(
            color: HbColors.brandPrimary.withValues(alpha: 0.4),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(entry.icon, size: 16, color: HbColors.brandPrimary),
            const SizedBox(width: 6),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 220),
              child: Text(
                entry.label,
                style: const TextStyle(
                  fontSize: 13,
                  color: HbColors.brandPrimary,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
