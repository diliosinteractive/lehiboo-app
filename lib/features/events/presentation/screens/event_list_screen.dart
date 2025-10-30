import 'package:flutter/material.dart';

class EventListScreen extends StatelessWidget {
  final String? title;
  final String? filterType;

  const EventListScreen({
    super.key,
    this.title,
    this.filterType,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? 'Explorer les événements'),
      ),
      body: const Center(
        child: Text('Liste des événements'),
      ),
    );
  }
}