import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/models/organizer_profile_dto.dart';

/// Typed social-link row using the typed [SocialLinksDto] from the new
/// profile endpoint (facebook, instagram, twitter, linkedin, youtube).
class OrganizerSocialLinkRow extends StatelessWidget {
  final SocialLinksDto links;

  const OrganizerSocialLinkRow({super.key, required this.links});

  @override
  Widget build(BuildContext context) {
    final entries = <(IconData, String)>[
      if (_nonEmpty(links.facebook)) (FontAwesomeIcons.facebook, links.facebook!),
      if (_nonEmpty(links.instagram))
        (FontAwesomeIcons.instagram, links.instagram!),
      if (_nonEmpty(links.twitter))
        (FontAwesomeIcons.xTwitter, links.twitter!),
      if (_nonEmpty(links.linkedin))
        (FontAwesomeIcons.linkedin, links.linkedin!),
      if (_nonEmpty(links.youtube))
        (FontAwesomeIcons.youtube, links.youtube!),
    ];

    if (entries.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        for (final (icon, url) in entries)
          InkWell(
            onTap: () => _launch(url),
            customBorder: const CircleBorder(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: FaIcon(icon, size: 18, color: const Color(0xFF1A1A2E)),
            ),
          ),
      ],
    );
  }

  static bool _nonEmpty(String? s) => s != null && s.isNotEmpty;

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
