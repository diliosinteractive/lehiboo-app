import 'package:flutter/material.dart';

class MapViewScreen extends StatelessWidget {
  const MapViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carte des événements'),
      ),
      body: const Center(
        child: Text('Carte des événements'),
      ),
    );
  }
}