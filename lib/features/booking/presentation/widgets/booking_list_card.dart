import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/core/themes/hb_theme.dart';
import 'package:lehiboo/domain/entities/booking.dart';
import 'package:lehiboo/features/booking/presentation/widgets/booking_status_badge.dart';

class BookingListCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback onTap;
  final VoidCallback? onQRTap;
  final VoidCallback? onLongPress;

  const BookingListCard({
    super.key,
    required this.booking,
    required this.onTap,
    this.onQRTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = HbTheme.tokens(context);
    final activity = booking.activity;

    final dateTime = booking.slot?.startDateTime;
    final formattedDate = dateTime != null
        ? _formatDate(dateTime)
        : 'Date non définie';
    final formattedTime = dateTime != null
        ? DateFormat('HH:mm').format(dateTime)
        : '';

    final totalPrice = booking.totalPrice ?? 0;
    final priceText = totalPrice > 0
        ? '${totalPrice.toStringAsFixed(0)}€'
        : 'Gratuit';

    final ticketCount = booking.quantity ?? 1;
    final ticketText = ticketCount > 1 ? '$ticketCount billets' : '1 billet';

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image - prend toute la hauteur
                _buildImage(activity?.imageUrl),
                // Content
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(tokens.spacing.m),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Top section
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              activity?.title ?? 'Événement',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: HbColors.textPrimary,
                                height: 1.2,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            // Date & time
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today_outlined,
                                  size: 14,
                                  color: HbColors.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    '$formattedDate${formattedTime.isNotEmpty ? ' • $formattedTime' : ''}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: HbColors.textSecondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Bottom row: status, tickets, QR, price
                        Row(
                          children: [
                            BookingStatusBadge.fromString(
                              booking.status,
                              showIcon: false,
                              compact: true,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              ticketText,
                              style: const TextStyle(
                                fontSize: 12,
                                color: HbColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            // QR Button
                            if (booking.status == 'confirmed' && onQRTap != null)
                              GestureDetector(
                                onTap: onQRTap,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: HbColors.brandPrimary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Icon(
                                    Icons.qr_code_2,
                                    size: 18,
                                    color: HbColors.brandPrimary,
                                  ),
                                ),
                              ),
                            const SizedBox(width: 10),
                            // Price
                            Text(
                              priceText,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: HbColors.brandPrimary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String? imageUrl) {
    return SizedBox(
      width: 100,
      child: imageUrl != null && imageUrl.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                color: Colors.grey.shade200,
                child: const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
              errorWidget: (_, __, ___) => _buildPlaceholder(),
            )
          : _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: HbColors.orangePastel,
      child: const Center(
        child: Icon(
          Icons.event,
          size: 32,
          color: HbColors.brandPrimary,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return "Aujourd'hui";
    } else if (dateOnly == tomorrow) {
      return 'Demain';
    } else {
      // mer. 14 janv. 2026
      return DateFormat('E d MMM yyyy', 'fr_FR').format(date);
    }
  }
}
