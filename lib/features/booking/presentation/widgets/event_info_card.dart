import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/core/themes/hb_theme.dart';
import 'package:lehiboo/domain/entities/activity.dart';

class EventInfoCard extends StatelessWidget {
  final Activity activity;
  final DateTime? slotDateTime;
  final DateTime? endDateTime;
  final bool showNavigateButton;

  const EventInfoCard({
    super.key,
    required this.activity,
    this.slotDateTime,
    this.endDateTime,
    this.showNavigateButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = HbTheme.tokens(context);

    final formattedDate = slotDateTime != null
        ? DateFormat('EEEE d MMMM yyyy', 'fr_FR').format(slotDateTime!)
        : 'Date non définie';

    final formattedTime = slotDateTime != null
        ? DateFormat('HH:mm').format(slotDateTime!)
        : '';

    final formattedEndTime = endDateTime != null
        ? DateFormat('HH:mm').format(endDateTime!)
        : '';

    final timeRange = formattedEndTime.isNotEmpty
        ? '$formattedTime - $formattedEndTime'
        : formattedTime;

    final venueName = activity.partner?.name ?? '';
    final cityName = activity.city?.name ?? '';
    final address = [venueName, cityName].where((s) => s.isNotEmpty).join(', ');

    return Container(
      padding: EdgeInsets.all(tokens.spacing.m),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: HbColors.brandPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.event,
                  size: 18,
                  color: HbColors.brandPrimary,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'ÉVÉNEMENT',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: HbColors.textSecondary,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Title
          Text(
            activity.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: HbColors.textPrimary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),
          // Date
          _buildInfoRow(
            icon: Icons.calendar_today_outlined,
            label: formattedDate,
            isCapitalized: true,
          ),
          const SizedBox(height: 10),
          // Time
          if (timeRange.isNotEmpty)
            _buildInfoRow(
              icon: Icons.access_time,
              label: timeRange,
            ),
          const SizedBox(height: 10),
          // Location
          if (address.isNotEmpty)
            _buildInfoRow(
              icon: Icons.location_on_outlined,
              label: address,
            ),
          // Navigate to event button
          if (showNavigateButton) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => context.push('/event/${activity.id}'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: HbColors.brandPrimary,
                  side: const BorderSide(color: HbColors.brandPrimary),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.open_in_new, size: 16),
                    SizedBox(width: 8),
                    Text(
                      'Voir l\'événement',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    bool isCapitalized = false,
  }) {
    String displayLabel = label;
    if (isCapitalized && label.isNotEmpty) {
      displayLabel = label[0].toUpperCase() + label.substring(1);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: HbColors.textSecondary,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            displayLabel,
            style: const TextStyle(
              fontSize: 14,
              color: HbColors.textPrimary,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
