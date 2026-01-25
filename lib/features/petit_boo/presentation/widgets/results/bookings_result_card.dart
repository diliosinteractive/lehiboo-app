import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/themes/colors.dart';
import '../../../data/models/tool_result_dto.dart';

/// Card displaying booking results from getMyBookings tool
class BookingsResultCard extends StatelessWidget {
  final BookingsToolResult result;

  const BookingsResultCard({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    if (result.bookings.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: HbColors.brandPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.confirmation_number_outlined,
                    color: HbColors.brandPrimary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Bookings',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: HbColors.textPrimary,
                        ),
                      ),
                      Text(
                        '${result.total} booking${result.total != 1 ? 's' : ''}'
                        '${result.upcomingCount > 0 ? ' • ${result.upcomingCount} upcoming' : ''}',
                        style: TextStyle(
                          fontSize: 13,
                          color: HbColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Booking items (show max 3)
          ...result.bookings.take(3).map((booking) => _BookingItem(booking: booking)),

          // Show more button if needed
          if (result.bookings.length > 3)
            InkWell(
              onTap: () => context.push('/my-bookings'),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'View all ${result.total} bookings',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: HbColors.brandPrimary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: HbColors.brandPrimary,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: HbColors.orangePastel,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            Icons.confirmation_number_outlined,
            color: HbColors.brandPrimary.withOpacity(0.5),
            size: 24,
          ),
          const SizedBox(width: 12),
          const Text(
            'No bookings yet',
            style: TextStyle(
              fontSize: 14,
              color: HbColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _BookingItem extends StatelessWidget {
  final BookingResultItem booking;

  const _BookingItem({required this.booking});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/booking/${booking.uuid}'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Event image or placeholder
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: HbColors.orangePastel,
                image: booking.eventImage != null
                    ? DecorationImage(
                        image: NetworkImage(booking.eventImage!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: booking.eventImage == null
                  ? const Icon(
                      Icons.event,
                      color: HbColors.brandPrimary,
                    )
                  : null,
            ),
            const SizedBox(width: 12),

            // Booking details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.eventTitle,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: HbColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (booking.slotDate != null) ...[
                        Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: HbColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          booking.slotDate!,
                          style: TextStyle(
                            fontSize: 12,
                            color: HbColors.textSecondary,
                          ),
                        ),
                      ],
                      if (booking.ticketsCount > 0) ...[
                        const SizedBox(width: 8),
                        Icon(
                          Icons.person_outline,
                          size: 12,
                          color: HbColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${booking.ticketsCount}',
                          style: TextStyle(
                            fontSize: 12,
                            color: HbColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Status badge
            _StatusBadge(status: booking.status),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (color, bgColor, label) = _getStatusStyle();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  (Color, Color, String) _getStatusStyle() {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return (HbColors.success, HbColors.success.withOpacity(0.1), 'Confirmed');
      case 'pending':
        return (HbColors.warning, HbColors.warning.withOpacity(0.1), 'Pending');
      case 'cancelled':
        return (HbColors.error, HbColors.error.withOpacity(0.1), 'Cancelled');
      default:
        return (HbColors.textSecondary, Colors.grey.shade100, status);
    }
  }
}
