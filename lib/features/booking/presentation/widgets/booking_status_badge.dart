import 'package:flutter/material.dart';
import 'package:lehiboo/core/themes/colors.dart';

enum BookingStatus {
  pending,
  confirmed,
  cancelled,
  completed,
  refunded,
}

extension BookingStatusExtension on BookingStatus {
  String get label {
    switch (this) {
      case BookingStatus.pending:
        return 'En attente';
      case BookingStatus.confirmed:
        return 'Confirmé';
      case BookingStatus.cancelled:
        return 'Annulé';
      case BookingStatus.completed:
        return 'Terminé';
      case BookingStatus.refunded:
        return 'Remboursé';
    }
  }

  Color get color {
    switch (this) {
      case BookingStatus.pending:
        return HbColors.warning;
      case BookingStatus.confirmed:
        return HbColors.success;
      case BookingStatus.cancelled:
        return HbColors.error;
      case BookingStatus.completed:
        return HbColors.brandSecondary;
      case BookingStatus.refunded:
        return Colors.grey;
    }
  }

  Color get backgroundColor {
    return color.withOpacity(0.12);
  }

  IconData get icon {
    switch (this) {
      case BookingStatus.pending:
        return Icons.schedule;
      case BookingStatus.confirmed:
        return Icons.check_circle;
      case BookingStatus.cancelled:
        return Icons.cancel;
      case BookingStatus.completed:
        return Icons.done_all;
      case BookingStatus.refunded:
        return Icons.replay;
    }
  }

  static BookingStatus fromString(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return BookingStatus.pending;
      case 'confirmed':
        return BookingStatus.confirmed;
      case 'cancelled':
        return BookingStatus.cancelled;
      case 'completed':
        return BookingStatus.completed;
      case 'refunded':
        return BookingStatus.refunded;
      default:
        return BookingStatus.pending;
    }
  }
}

class BookingStatusBadge extends StatelessWidget {
  final BookingStatus status;
  final bool showIcon;
  final bool compact;

  const BookingStatusBadge({
    super.key,
    required this.status,
    this.showIcon = true,
    this.compact = false,
  });

  factory BookingStatusBadge.fromString(String? statusString, {bool showIcon = true, bool compact = false}) {
    return BookingStatusBadge(
      status: BookingStatusExtension.fromString(statusString),
      showIcon: showIcon,
      compact: compact,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: status.backgroundColor,
        borderRadius: BorderRadius.circular(compact ? 4 : 6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(
              status.icon,
              size: compact ? 12 : 14,
              color: status.color,
            ),
            SizedBox(width: compact ? 4 : 6),
          ],
          Text(
            status.label,
            style: TextStyle(
              fontSize: compact ? 11 : 12,
              fontWeight: FontWeight.w600,
              color: status.color,
            ),
          ),
        ],
      ),
    );
  }
}
