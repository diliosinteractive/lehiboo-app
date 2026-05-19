import 'package:flutter/material.dart';
import 'package:lehiboo/core/l10n/l10n.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/features/events/domain/entities/event_submodels.dart';
import 'package:lehiboo/features/events/presentation/utils/event_l10n.dart';
import 'package:lehiboo/features/events/presentation/widgets/detail/practical_info_card.dart';
import 'package:lehiboo/features/events/presentation/widgets/detail/practical_info_sheet.dart';

/// Accessibility section — displays all accessibility features from the API.
/// Hidden entirely when no accessibility data is available.
class EventAccessibilitySection extends StatelessWidget {
  final LocationDetails? locationDetails;

  const EventAccessibilitySection({
    super.key,
    this.locationDetails,
  });

  bool get _hasPmr => locationDetails?.pmr?.available == true;

  bool get _hasAccessibilityFeatures =>
      locationDetails?.accessibilityFeatures.isNotEmpty == true;

  bool get _hasAny => _hasPmr || _hasAccessibilityFeatures;

  @override
  Widget build(BuildContext context) {
    if (!_hasAny) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            context.l10n.eventAccessibilityTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: HbColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              // Legacy PMR field (from organizer.practicalInfo)
              if (_hasPmr && !_hasAccessibilityFeatures)
                CompactInfoChip(
                  icon: Icons.accessible,
                  label: context.l10n.eventAccessibilityPmr,
                  color: Colors.blue,
                  onTap: () => _showDetail(
                    context,
                    icon: Icons.accessible,
                    title: context.l10n.eventAccessibilityPmrTitle,
                    note: locationDetails?.pmr?.note,
                  ),
                ),
              // Individual accessibility features from the API
              if (_hasAccessibilityFeatures)
                ...locationDetails!.accessibilityFeatures.map((key) {
                  final info = _accessibilityInfo(context, key);
                  return CompactInfoChip(
                    icon: info.icon,
                    label: info.label,
                    color: info.color,
                    onTap: () => _showDetail(
                      context,
                      icon: info.icon,
                      title: info.label,
                      note: null,
                    ),
                  );
                }),
            ],
          ),
        ),
      ],
    );
  }

  void _showDetail(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? note,
  }) {
    PracticalInfoSheet.show(
      context,
      icon: icon,
      title: title,
      description: note ?? context.l10n.eventServiceDefaultDescription,
      color: HbColors.brandPrimary,
    );
  }

  static _AccessibilityDisplay _accessibilityInfo(
    BuildContext context,
    String key,
  ) {
    switch (key) {
      case 'pmr':
        return _AccessibilityDisplay(
            context.eventAccessibilityFeatureLabel(key),
            Icons.accessible,
            Colors.blue);
      case 'lsf':
        return _AccessibilityDisplay(
            context.eventAccessibilityFeatureLabel(key),
            Icons.sign_language,
            Colors.indigo);
      case 'ascenseur':
        return _AccessibilityDisplay(
            context.eventAccessibilityFeatureLabel(key),
            Icons.elevator_outlined,
            Colors.blueGrey);
      case 'stationnement_handicap':
        return _AccessibilityDisplay(
            context.eventAccessibilityFeatureLabel(key),
            Icons.local_parking,
            Colors.blue);
      case 'places_handicap':
        return _AccessibilityDisplay(
            context.eventAccessibilityFeatureLabel(key),
            Icons.event_seat_outlined,
            Colors.blue);
      case 'chien_guide':
        return _AccessibilityDisplay(
            context.eventAccessibilityFeatureLabel(key),
            Icons.pets_outlined,
            Colors.brown);
      case 'boucle_magnetique':
        return _AccessibilityDisplay(
            context.eventAccessibilityFeatureLabel(key),
            Icons.hearing_outlined,
            Colors.teal);
      case 'audiodescription':
        return _AccessibilityDisplay(
            context.eventAccessibilityFeatureLabel(key),
            Icons.headphones_outlined,
            Colors.deepPurple);
      case 'braille':
        return _AccessibilityDisplay(
            context.eventAccessibilityFeatureLabel(key),
            Icons.touch_app_outlined,
            Colors.orange);
      default:
        return _AccessibilityDisplay(
          context.eventAccessibilityFeatureLabel(key),
          Icons.accessible_forward,
          Colors.blue,
        );
    }
  }
}

class _AccessibilityDisplay {
  final String label;
  final IconData icon;
  final Color color;

  const _AccessibilityDisplay(this.label, this.icon, this.color);
}
