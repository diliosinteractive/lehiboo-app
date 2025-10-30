import 'package:flutter/material.dart';

class BookingScreen extends StatelessWidget {
  final String eventId;

  const BookingScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Réservation'),
      ),
      body: Center(
        child: Text('Réservation pour l\'événement $eventId'),
      ),
    );
  }
}