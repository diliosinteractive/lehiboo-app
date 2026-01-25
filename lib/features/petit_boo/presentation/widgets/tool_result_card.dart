import 'package:flutter/material.dart';

import '../../data/models/tool_result_dto.dart';
import 'results/alerts_result_card.dart';
import 'results/bookings_result_card.dart';
import 'results/event_detail_result_card.dart';
import 'results/event_search_result_card.dart';
import 'results/favorites_result_card.dart';
import 'results/notifications_result_card.dart';
import 'results/profile_result_card.dart';
import 'results/tickets_result_card.dart';

/// Routes tool results to the appropriate specialized widget
class ToolResultCard extends StatelessWidget {
  final ToolResultDto result;

  const ToolResultCard({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return switch (result.type) {
      ToolResultType.myBookings => BookingsResultCard(
          result: BookingsToolResult.fromJson(result.data),
        ),
      ToolResultType.myTickets => TicketsResultCard(
          result: TicketsToolResult.fromJson(result.data),
        ),
      ToolResultType.eventSearch => EventSearchResultCard(
          result: EventSearchToolResult.fromJson(result.data),
        ),
      ToolResultType.eventDetails => EventDetailResultCard(
          result: EventDetailsToolResult.fromJson(result.data),
        ),
      ToolResultType.myFavorites => FavoritesResultCard(
          result: FavoritesToolResult.fromJson(result.data),
        ),
      ToolResultType.myAlerts => AlertsResultCard(
          result: AlertsToolResult.fromJson(result.data),
        ),
      ToolResultType.myProfile => ProfileResultCard(
          result: ProfileToolResult.fromJson(result.data),
        ),
      ToolResultType.notifications => NotificationsResultCard(
          result: NotificationsToolResult.fromJson(result.data),
        ),
      null => _UnknownToolResultCard(toolName: result.tool),
    };
  }
}

/// Fallback widget for unknown tool results
class _UnknownToolResultCard extends StatelessWidget {
  final String toolName;

  const _UnknownToolResultCard({required this.toolName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(Icons.extension, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Text(
            'Tool: $toolName',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
