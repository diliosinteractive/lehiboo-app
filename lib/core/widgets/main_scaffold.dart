import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/petit_boo/presentation/providers/engagement_provider.dart';
import '../analytics/analytics_consent.dart';
import '../analytics/widgets/consent_gate_modal.dart';
import '../l10n/l10n.dart';
import '../utils/guest_guard.dart';
import 'voice_fab/voice_fab.dart';

class MainScaffold extends ConsumerStatefulWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  @override
  ConsumerState<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends ConsumerState<MainScaffold> {
  Timer? _idleCheckTimer;

  @override
  void initState() {
    super.initState();

    // Initial Trigger
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(petitBooEngagementProvider.notifier).onAppStart();
      _maybeShowConsentGate();
    });

    // Idle Checker Loop
    _idleCheckTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        ref.read(petitBooEngagementProvider.notifier).checkIdle();
      }
    });
  }

  /// Affiche le consent gate RGPD si l'utilisateur n'a pas encore tranché.
  /// Premier point d'entrée dans la navigation principale → moment naturel
  /// pour demander le consentement (option A du plan : avant l'accès à la
  /// home complète).
  void _maybeShowConsentGate() {
    final consent = ref.read(analyticsConsentProvider);
    if (consent.status != AnalyticsConsentStatus.unknown) return;
    if (!mounted) return;
    ConsentGateModal.show(context);
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

    if (index == 3) {
      _navigateToBookings();
      return;
    }

    // Track navigation
    ref.read(petitBooEngagementProvider.notifier).onNavigation();

    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/explore');
        break;
    }
  }

  Future<void> _navigateToBookings() async {
    final allowed = await GuestGuard.check(
      context: context,
      ref: ref,
      featureName: context.l10n.guestFeatureBookings,
    );
    if (!allowed) return;

    // Track navigation
    ref.read(petitBooEngagementProvider.notifier).onNavigation();

    if (mounted) {
      context.go('/my-bookings');
    }
  }

  // Source of truth for the highlighted tab is the current route, so back
  // navigation, deeplinks and programmatic context.go all stay in sync.
  int _indexForLocation(String path) {
    if (path.startsWith('/explore')) return 1;
    if (path.startsWith('/my-bookings')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isKeyboardVisible = MediaQuery.viewInsetsOf(context).bottom > 0;
    final selectedIndex =
        _indexForLocation(GoRouterState.of(context).uri.path);

    return Scaffold(
      body: widget.child,
      // Nouveau VoiceFab avec appui prolongé pour parler
      floatingActionButton: isKeyboardVisible ? null : const VoiceFab(),
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
              child:
                  _buildNavItem(Icons.home_rounded, l10n.navHome, 0, selectedIndex),
            ),
            _buildNavItem(
                Icons.explore_outlined, l10n.navExplore, 1, selectedIndex),
            const SizedBox(width: 64), // Space for FAB
            _buildNavItem(Icons.map_outlined, l10n.navMap, 2, selectedIndex),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: _buildNavItem(
                Icons.confirmation_number_outlined,
                l10n.navBookings,
                3,
                selectedIndex,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
      IconData icon, String label, int index, int selectedIndex) {
    final isActive = selectedIndex == index;

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
