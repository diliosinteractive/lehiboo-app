import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/features/booking/presentation/widgets/booking_status_badge.dart';

class BookingHeroHeader extends StatelessWidget {
  final String? imageUrl;
  final String status;
  final String? reference;

  const BookingHeroHeader({
    super.key,
    this.imageUrl,
    required this.status,
    this.reference,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Hero image
        AspectRatio(
          aspectRatio: 16 / 9,
          child: imageUrl != null && imageUrl!.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: imageUrl!,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (_, __, ___) => _buildPlaceholder(),
                )
              : _buildPlaceholder(),
        ),
        // Gradient overlay at bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.5),
                ],
              ),
            ),
          ),
        ),
        // Status badge positioned at bottom right
        Positioned(
          bottom: 16,
          right: 16,
          child: BookingStatusBadge.fromString(status),
        ),
        // Reference badge at top left
        if (reference != null)
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '#$reference',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: HbColors.orangePastel,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event,
              size: 64,
              color: HbColors.brandPrimary.withOpacity(0.5),
            ),
            const SizedBox(height: 8),
            Text(
              'Événement',
              style: TextStyle(
                color: HbColors.brandPrimary.withOpacity(0.5),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
