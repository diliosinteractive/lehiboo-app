import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';

/// Header compact avec titre, organisateur, tags et rating
///
/// Layout:
/// ┌────────────────────────────────────┐
/// │  [ORGANISATEUR]                    │
/// │  Titre Événement                   │
/// │  [Cat] [Public] [Durée]            │
/// │  ★ 4.8 (120) • Paris               │
/// └────────────────────────────────────┘
class EventCompactHeader extends StatelessWidget {
  final Event event;
  final VoidCallback? onOrganizerTap;

  const EventCompactHeader({
    super.key,
    required this.event,
    this.onOrganizerTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chip organisateur
          _buildOrganizerChip(context),
          const SizedBox(height: 12),

          // Titre
          Text(
            event.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: HbColors.textPrimary,
              height: 1.2,
              letterSpacing: -0.5,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),

          // Tags
          _buildTags(),
          const SizedBox(height: 12),

          // Rating + Lieu
          _buildRatingAndLocation(context),
        ],
      ),
    );
  }

  Widget _buildOrganizerChip(BuildContext context) {
    if (event.organizerName == null || event.organizerName!.isEmpty) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        if (onOrganizerTap != null) {
          onOrganizerTap!();
        } else if (event.organizerId != null) {
          context.push('/partner/${event.organizerId}');
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: HbColors.brandPrimary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: HbColors.brandPrimary.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Avatar organisateur
            if (event.organizerLogo != null && event.organizerLogo!.isNotEmpty)
              CircleAvatar(
                radius: 10,
                backgroundImage: NetworkImage(event.organizerLogo!),
                backgroundColor: Colors.grey.shade200,
              )
            else
              CircleAvatar(
                radius: 10,
                backgroundColor: HbColors.brandPrimary,
                child: Text(
                  event.organizerName![0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(width: 8),
            // Nom avec ellipsis si trop long
            Flexible(
              child: Text(
                event.organizerName!,
                style: const TextStyle(
                  color: HbColors.brandPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.chevron_right,
              color: HbColors.brandPrimary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTags() {
    final tags = <_TagData>[];

    // Catégorie
    if (event.category != null) {
      tags.add(_TagData(
        label: _getCategoryLabel(event.category!),
        icon: _getCategoryIcon(event.category!),
        color: HbColors.brandPrimary,
      ));
    }

    // Public cible
    if (event.targetAudiences != null && event.targetAudiences!.isNotEmpty) {
      final audience = event.targetAudiences!.first;
      tags.add(_TagData(
        label: _getAudienceLabel(audience),
        icon: Icons.people_outline,
        color: Colors.blue,
      ));
    }

    // Durée
    if (event.duration != null && event.duration!.inMinutes > 0) {
      tags.add(_TagData(
        label: _formatDuration(event.duration!),
        icon: Icons.schedule,
        color: Colors.purple,
      ));
    }

    // Indoor/Outdoor
    if (event.isIndoor == true) {
      tags.add(_TagData(
        label: 'Intérieur',
        icon: Icons.home_outlined,
        color: Colors.teal,
      ));
    } else if (event.isOutdoor == true) {
      tags.add(_TagData(
        label: 'Extérieur',
        icon: Icons.park_outlined,
        color: Colors.green,
      ));
    }

    if (tags.isEmpty) return const SizedBox.shrink();

    // Limiter à 3 tags visibles max + badge "+N" si plus
    final visibleTags = tags.take(3).toList();
    final extraCount = tags.length - 3;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...visibleTags.map((tag) => _buildTag(tag)),
        if (extraCount > 0) _buildMoreChip(extraCount),
      ],
    );
  }

  Widget _buildMoreChip(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: HbColors.grey200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        '+$count',
        style: TextStyle(
          color: HbColors.grey500,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTag(_TagData tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: tag.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            tag.icon,
            size: 14,
            color: tag.color,
          ),
          const SizedBox(width: 4),
          Text(
            tag.label,
            style: TextStyle(
              color: tag.color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingAndLocation(BuildContext context) {
    return Row(
      children: [
        // Rating
        if (event.rating != null && event.rating! > 0) ...[
          const Icon(
            Icons.star,
            color: Colors.amber,
            size: 18,
          ),
          const SizedBox(width: 4),
          Text(
            event.rating!.toStringAsFixed(1),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: HbColors.textPrimary,
            ),
          ),
          if (event.reviewsCount != null && event.reviewsCount! > 0) ...[
            const SizedBox(width: 4),
            Text(
              '(${event.reviewsCount})',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),
          ],
          _buildDot(),
        ],

        // Lieu
        Expanded(
          child: Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 16,
                color: Colors.grey.shade600,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  _getLocationText(),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDot() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        '•',
        style: TextStyle(
          color: Colors.grey.shade400,
          fontSize: 14,
        ),
      ),
    );
  }

  String _getLocationText() {
    final parts = <String>[];
    if (event.venue != null && event.venue!.isNotEmpty) {
      parts.add(event.venue!);
    }
    if (event.city != null && event.city!.isNotEmpty) {
      parts.add(event.city!);
    }
    if (parts.isEmpty) return 'Lieu non précisé';
    return parts.join(', ');
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0 && minutes > 0) {
      return '${hours}h${minutes.toString().padLeft(2, '0')}';
    } else if (hours > 0) {
      return '${hours}h';
    } else {
      return '${minutes}min';
    }
  }

  String _getCategoryLabel(EventCategory category) {
    switch (category) {
      case EventCategory.workshop:
        return 'Atelier';
      case EventCategory.show:
        return 'Spectacle';
      case EventCategory.festival:
        return 'Festival';
      case EventCategory.concert:
        return 'Concert';
      case EventCategory.exhibition:
        return 'Exposition';
      case EventCategory.sport:
        return 'Sport';
      case EventCategory.culture:
        return 'Culture';
      case EventCategory.market:
        return 'Marché';
      case EventCategory.leisure:
        return 'Loisirs';
      case EventCategory.outdoor:
        return 'Plein air';
      case EventCategory.indoor:
        return 'Intérieur';
      case EventCategory.theater:
        return 'Théâtre';
      case EventCategory.cinema:
        return 'Cinéma';
      case EventCategory.other:
        return 'Événement';
    }
  }

  IconData _getCategoryIcon(EventCategory category) {
    switch (category) {
      case EventCategory.workshop:
        return Icons.build_outlined;
      case EventCategory.show:
        return Icons.theater_comedy_outlined;
      case EventCategory.festival:
        return Icons.celebration_outlined;
      case EventCategory.concert:
        return Icons.music_note_outlined;
      case EventCategory.exhibition:
        return Icons.museum_outlined;
      case EventCategory.sport:
        return Icons.sports_soccer_outlined;
      case EventCategory.culture:
        return Icons.account_balance_outlined;
      case EventCategory.market:
        return Icons.storefront_outlined;
      case EventCategory.leisure:
        return Icons.attractions_outlined;
      case EventCategory.outdoor:
        return Icons.park_outlined;
      case EventCategory.indoor:
        return Icons.home_outlined;
      case EventCategory.theater:
        return Icons.theater_comedy_outlined;
      case EventCategory.cinema:
        return Icons.movie_outlined;
      case EventCategory.other:
        return Icons.event_outlined;
    }
  }

  String _getAudienceLabel(EventAudience audience) {
    switch (audience) {
      case EventAudience.all:
        return 'Tout public';
      case EventAudience.family:
        return 'Famille';
      case EventAudience.children:
        return 'Enfants';
      case EventAudience.teenagers:
        return 'Ados';
      case EventAudience.adults:
        return 'Adultes';
      case EventAudience.seniors:
        return 'Seniors';
    }
  }
}

class _TagData {
  final String label;
  final IconData icon;
  final Color color;

  _TagData({
    required this.label,
    required this.icon,
    required this.color,
  });
}
