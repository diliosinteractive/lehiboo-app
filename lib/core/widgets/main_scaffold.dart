import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/petit_boo/presentation/providers/engagement_provider.dart';
import 'voice_fab/voice_fab.dart';

class MainScaffold extends ConsumerStatefulWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  @override
  ConsumerState<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends ConsumerState<MainScaffold> {
  int _selectedIndex = 0;
  Timer? _idleCheckTimer;

  @override
  void initState() {
    super.initState();

    // Initial Trigger
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(petitBooEngagementProvider.notifier).onAppStart();
    });

    // Idle Checker Loop
    _idleCheckTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        ref.read(petitBooEngagementProvider.notifier).checkIdle();
      }
    });
  }

  @override
  void dispose() {
    _idleCheckTimer?.cancel();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      context.push('/map');
      return;
    }
    
    // Track navigation
    ref.read(petitBooEngagementProvider.notifier).onNavigation();

    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/explore');
        break;
      case 3:
        context.go('/my-bookings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      // Nouveau VoiceFab avec appui prolongé pour parler
      floatingActionButton: const VoiceFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.white,
        elevation: 10,
        height: 70,
        padding: EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: _buildNavItem(Icons.home_rounded, 'Accueil', 0),
            ),
            _buildNavItem(Icons.explore_outlined, 'Explorer', 1),
            const SizedBox(width: 64), // Space for FAB
            _buildNavItem(Icons.map_outlined, 'Carte', 2),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: _buildNavItem(Icons.confirmation_number_outlined, 'Réservations', 3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isActive = _selectedIndex == index;

    return InkWell(
      onTap: () => _onItemTapped(index),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? const Color(0xFFFF601F) : Colors.grey,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? const Color(0xFFFF601F) : Colors.grey,
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}