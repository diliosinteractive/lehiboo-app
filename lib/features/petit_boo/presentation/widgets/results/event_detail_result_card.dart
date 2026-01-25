import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../../core/themes/colors.dart';
import '../../../data/models/tool_result_dto.dart';

/// Card displaying event details from getEventDetails tool
class EventDetailResultCard extends StatelessWidget {
  final EventDetailsToolResult result;

  const EventDetailResultCard({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/event/${result.slug}'),
      child: Container(
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
            // Image header
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: SizedBox(
                height: 150,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    result.imageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: result.imageUrl!,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(
                              color: HbColors.orangePastel,
                            ),
                            errorWidget: (_, __, ___) => Container(
                              color: HbColors.orangePastel,
                              child: const Center(
                                child: Icon(Icons.event, size: 48),
                              ),
                            ),
                          )
                        : Container(
                            color: HbColors.orangePastel,
                            child: const Center(
                              child: Icon(Icons.event, size: 48, color: HbColors.brandPrimary),
                            ),
                          ),
                    // Gradient overlay
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 60,
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
                    // Favorite icon
                    if (result.isFavorite)
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.favorite,
                            color: HbColors.error,
                            size: 18,
                          ),
                        ),
                      ),
                    // Category badge
                    if (result.category != null)
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: HbColors.brandPrimary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            result.category!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    result.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: HbColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Venue
                  if (result.venue != null) ...[
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: HbColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${result.venue!.name}${result.venue!.city != null ? ' • ${result.venue!.city}' : ''}',
                            style: TextStyle(
                              fontSize: 13,
                              color: HbColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                  ],

                  // Next slot
                  if (result.nextSlot != null) ...[
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 16,
                          color: HbColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${result.nextSlot!.slotDate} at ${result.nextSlot!.startTime}',
                          style: TextStyle(
                            fontSize: 13,
                            color: HbColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Ticket types preview
                  if (result.ticketTypes != null && result.ticketTypes!.isNotEmpty) ...[
                    _buildTicketTypesPreview(),
                    const SizedBox(height: 12),
                  ],

                  // Action button
                  if (result.canBook)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => context.push('/booking/${result.uuid}'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: HbColors.brandPrimary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Book Now',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketTypesPreview() {
    final tickets = result.ticketTypes!.take(3).toList();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: HbColors.orangePastel,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: tickets.map((ticket) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: ticket != tickets.last ? 8 : 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    ticket.name,
                    style: const TextStyle(
                      fontSize: 13,
                      color: HbColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  ticket.price == 0 ? 'Free' : '${ticket.price.toStringAsFixed(2)}€',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: ticket.price == 0 ? HbColors.success : HbColors.brandPrimary,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
