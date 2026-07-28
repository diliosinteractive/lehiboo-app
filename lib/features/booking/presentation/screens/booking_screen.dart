import 'package:flutter/material.dart';
import 'package:lehiboo/core/l10n/l10n.dart';

class BookingScreen extends StatelessWidget {
  final String eventId;

  const BookingScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.bookingReservationFallback),
      ),
      body: Center(
        child: Text(context.l10n.bookingLegacyReservationForEvent(eventId)),
      ),
    );
  }
}
