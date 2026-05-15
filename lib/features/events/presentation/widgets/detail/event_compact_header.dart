import 'package:flutter/material.dart';
import 'package:lehiboo/core/l10n/l10n.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import 'package:lehiboo/features/events/presentation/utils/event_l10n.dart';

/// Header compact avec titre, type, adresse, tags et rating
///
/// Layout:
/// ┌────────────────────────────────────┐
/// │  Titre Événement                   │
/// │  [Billetterie] ou [Découverte]     │
/// │  📍 Adresse                         │
/// │  [Cat] [Gratuit/Payant] [Durée] …  │
/// │  ★ 4.8 (120)                       │
/// └────────────────────────────────────┘
class EventCompactHeader extends StatelessWidget {
  final Event event;

  const EventCompactHeader({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre + Type chip
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 16,
            runSpacing: 8,
            children: [
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
              _buildEventTypeChip(context),
            ],
          ),
          const SizedBox(height: 10),

          // Adresse
          _buildLocation(context),
          const SizedBox(height: 12),

          // Tags
          _buildTags(context),
          const SizedBox(height: 12),

          // Rating
          _buildRating(),
        ],
      ),
    );
  }

  Widget _buildEventTypeChip(BuildContext context) {
    final isBilletterie = event.hasDirectBooking;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isBilletterie
            ? HbColors.brandPrimary.withValues(alpha: 0.1)
            : Colors.teal.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isBilletterie
                ? Icons.confirmation_number_outlined
                : Icons.explore_outlined,
            size: 14,
            color: isBilletterie ? HbColors.brandPrimary : Colors.teal,
          ),
          const SizedBox(width: 4),
          Text(
            isBilletterie
                ? context.l10n.eventTicketing
                : context.l10n.eventDiscovery,
            style: TextStyle(
              color: isBilletterie ? HbColors.brandPrimary : Colors.teal,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTags(BuildContext context) {
    final tags = <_TagData>[];

    // 1. Primary category — prefer event_tag from API, fallback to enum
    if (event.eventTypeTerm != null) {
      tags.add(_TagData(
        label: event.eventTypeTerm!.name,
        icon: _getCategoryIcon(event.category),
        color: HbColors.brandPrimary,
      ));
    } else if (event.category != EventCategory.other) {
      tags.add(_TagData(
        label: context.eventCategoryLabel(event.category),
        icon: _getCategoryIcon(event.category),
        color: HbColors.brandPrimary,
      ));
    }

    // 2. Duration
    if (event.duration != null && event.duration!.inMinutes > 0) {
      tags.add(_TagData(
        label: _formatDuration(event.duration!),
        icon: Icons.schedule,
        color: Colors.purple,
      ));
    }

    // 4. Public-facing tags: audience (prefer API terms, fallback to enum)
    if (event.targetAudienceTerms.isNotEmpty) {
      for (final term in event.targetAudienceTerms) {
        tags.add(_TagData(
          label: term.name,
          icon: Icons.people_outline,
          color: Colors.blue,
        ));
      }
    } else if (event.targetAudiences.isNotEmpty) {
      for (final audience in event.targetAudiences) {
        tags.add(_TagData(
          label: context.eventAudienceLabel(audience),
          icon: Icons.people_outline,
          color: Colors.blue,
        ));
      }
    }

    // 5. Indoor/Outdoor — skipped: currently hardcoded in mapper,
    // will add back when the API provides real data

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags.map((tag) => _buildTag(tag)).toList(),
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

  Widget _buildLocation(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.location_on_outlined,
          size: 16,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            _getLocationText(context),
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildRating() {
    if (event.rating == null || event.rating! <= 0) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        const Icon(Icons.star, color: Colors.amber, size: 18),
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
      ],
    );
  }

  String _getLocationText(BuildContext context) {
    final parts = <String>[];
    if (event.venue.isNotEmpty) parts.add(event.venue);
    if (event.city.isNotEmpty) parts.add(event.city);
    if (parts.isEmpty) return context.l10n.eventPlaceNotSpecified;
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
