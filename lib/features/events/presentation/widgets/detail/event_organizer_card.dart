import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import 'package:lehiboo/features/events/domain/entities/event_submodels.dart';
import 'package:lehiboo/shared/widgets/animations/staggered_animation.dart';
import 'package:url_launcher/url_launcher.dart';

/// Card organisateur compact avec expansion
///
/// Compact (par défaut):
/// - Logo + Nom + Badge vérifié
/// - Note + Nombre d'events
/// - 3 icônes réseaux sociaux
///
/// Expanded:
/// - Description complète
/// - Contact (téléphone, email)
/// - Co-organisateurs
class EventOrganizerCard extends StatefulWidget {
  final Event event;
  final VoidCallback? onOrganizerTap;

  const EventOrganizerCard({
    super.key,
    required this.event,
    this.onOrganizerTap,
  });

  @override
  State<EventOrganizerCard> createState() => _EventOrganizerCardState();
}

class _EventOrganizerCardState extends State<EventOrganizerCard> {
  bool _isExpanded = false;

  bool get _hasDescription =>
      widget.event.organizerDescription != null &&
      widget.event.organizerDescription!.isNotEmpty;

  bool get _hasContact =>
      (widget.event.contactPhone != null &&
          widget.event.contactPhone!.isNotEmpty) ||
      (widget.event.contactEmail != null &&
          widget.event.contactEmail!.isNotEmpty);

  bool get _hasSocialLinks => widget.event.socialMedia != null;

  bool get _hasCoOrganizers => widget.event.coOrganizers.isNotEmpty;

  bool get _canExpand =>
      _hasDescription || _hasContact || _hasCoOrganizers;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Organisateur',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: HbColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Header compact (toujours visible)
                _buildCompactHeader(),

                // Contenu expandable
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: _buildExpandedContent(),
                  crossFadeState: _isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                ),

                // Bouton expand/collapse
                if (_canExpand) _buildExpandButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactHeader() {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        if (widget.onOrganizerTap != null) {
          widget.onOrganizerTap!();
        } else {
          context.push('/partner/${widget.event.organizerId}');
        }
      },
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Avatar
            _buildAvatar(),
            const SizedBox(width: 16),

            // Infos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nom + Badge vérifié
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          widget.event.organizerName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: HbColors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildVerifiedBadge(),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Stats (rating + events count)
                  _buildStats(),
                ],
              ),
            ),

            // Icônes réseaux sociaux
            if (_hasSocialLinks) ...[
              const SizedBox(width: 8),
              _buildSocialIcons(),
            ],

            // Chevron
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right,
              color: Colors.grey.shade400,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: HbColors.brandPrimary.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: ClipOval(
        child: widget.event.organizerLogo != null
            ? CachedNetworkImage(
                imageUrl: widget.event.organizerLogo!,
                fit: BoxFit.cover,
                placeholder: (_, __) => _buildAvatarPlaceholder(),
                errorWidget: (_, __, ___) => _buildAvatarPlaceholder(),
              )
            : _buildAvatarPlaceholder(),
      ),
    );
  }

  Widget _buildAvatarPlaceholder() {
    return Container(
      color: HbColors.brandPrimary.withValues(alpha: 0.1),
      child: Center(
        child: Text(
          widget.event.organizerName.isNotEmpty
              ? widget.event.organizerName[0].toUpperCase()
              : '?',
          style: const TextStyle(
            color: HbColors.brandPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildVerifiedBadge() {
    return ShineAnimation(
      duration: const Duration(milliseconds: 2000),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.verified,
          size: 16,
          color: Colors.blue.shade600,
        ),
      ),
    );
  }

  Widget _buildStats() {
    return Row(
      children: [
        // Rating
        if (widget.event.rating != null && widget.event.rating! > 0) ...[
          const Icon(Icons.star, color: Colors.amber, size: 14),
          const SizedBox(width: 2),
          Text(
            widget.event.rating!.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: HbColors.textPrimary,
            ),
          ),
          if (widget.event.reviewsCount != null) ...[
            Text(
              ' (${widget.event.reviewsCount})',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
          ],
          _buildDot(),
        ],

        // Nombre d'événements (simulé pour l'instant)
        Text(
          'Organisateur vérifié',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildDot() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Container(
        width: 3,
        height: 3,
        decoration: BoxDecoration(
          color: Colors.grey.shade400,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildSocialIcons() {
    final socialMedia = widget.event.socialMedia;
    if (socialMedia == null) return const SizedBox.shrink();

    final links = <_SocialLink>[];

    if (socialMedia.facebook != null && socialMedia.facebook!.isNotEmpty) {
      links.add(_SocialLink(
        icon: FontAwesomeIcons.facebook,
        url: socialMedia.facebook!,
        color: const Color(0xFF1877F2),
      ));
    }

    if (socialMedia.instagram != null && socialMedia.instagram!.isNotEmpty) {
      links.add(_SocialLink(
        icon: FontAwesomeIcons.instagram,
        url: socialMedia.instagram!,
        color: const Color(0xFFE4405F),
      ));
    }

    if (socialMedia.linkedin != null && socialMedia.linkedin!.isNotEmpty) {
      links.add(_SocialLink(
        icon: FontAwesomeIcons.linkedin,
        url: socialMedia.linkedin!,
        color: const Color(0xFF0A66C2),
      ));
    }

    if (links.isEmpty) return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: links.take(3).map((link) {
        return GestureDetector(
          onTap: () => _openUrl(link.url),
          child: Container(
            margin: const EdgeInsets.only(left: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: link.color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: FaIcon(
              link.icon,
              size: 14,
              color: link.color,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildExpandedContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 24),

          // Description
          if (_hasDescription) ...[
            Text(
              widget.event.organizerDescription!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Contact
          if (_hasContact) ...[
            _buildContactSection(),
            const SizedBox(height: 16),
          ],

          // Co-organisateurs
          if (_hasCoOrganizers) _buildCoOrganizers(),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (widget.event.contactPhone != null &&
                widget.event.contactPhone!.isNotEmpty)
              _buildContactChip(
                icon: Icons.phone_outlined,
                label: widget.event.contactPhone!,
                onTap: () => _openUrl('tel:${widget.event.contactPhone}'),
              ),
            if (widget.event.contactEmail != null &&
                widget.event.contactEmail!.isNotEmpty)
              _buildContactChip(
                icon: Icons.email_outlined,
                label: widget.event.contactEmail!,
                onTap: () => _openUrl('mailto:${widget.event.contactEmail}'),
              ),
            if (widget.event.website != null &&
                widget.event.website!.isNotEmpty)
              _buildContactChip(
                icon: Icons.language,
                label: 'Site web',
                onTap: () => _openUrl(widget.event.website!),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildContactChip({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: HbColors.brandPrimary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: HbColors.brandPrimary),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: HbColors.brandPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoOrganizers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Partenaires',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: widget.event.coOrganizers.map((coOrg) {
            return _buildCoOrganizerChip(coOrg);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCoOrganizerChip(CoOrganizer coOrg) {
    return GestureDetector(
      onTap: coOrg.url != null ? () => _openUrl(coOrg.url!) : null,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade200,
              ),
              child: coOrg.imageUrl != null
                  ? ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: coOrg.imageUrl!,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => Center(
                          child: Text(
                            coOrg.name.isNotEmpty
                                ? coOrg.name[0].toUpperCase()
                                : '?',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Text(
                        coOrg.name.isNotEmpty
                            ? coOrg.name[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  coOrg.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: HbColors.textPrimary,
                  ),
                ),
                if (coOrg.role != null && coOrg.role!.isNotEmpty)
                  Text(
                    coOrg.role!,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandButton() {
    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _isExpanded = !_isExpanded);
      },
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(15)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isExpanded ? 'Voir moins' : 'En savoir plus',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            AnimatedRotation(
              turns: _isExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey.shade600,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openUrl(String url) async {
    HapticFeedback.lightImpact();
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _SocialLink {
  final IconData icon;
  final String url;
  final Color color;

  _SocialLink({
    required this.icon,
    required this.url,
    required this.color,
  });
}
