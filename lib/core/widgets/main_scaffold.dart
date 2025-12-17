import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/ai_chat/presentation/providers/chat_engagement_provider.dart';

class MainScaffold extends ConsumerStatefulWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  @override
  ConsumerState<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends ConsumerState<MainScaffold> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _bubbleController;
  late Animation<double> _bubbleAnimation;
  Timer? _idleCheckTimer;

  @override
  void initState() {
    super.initState();
    _bubbleController = AnimationController(
       vsync: this,
       duration: const Duration(milliseconds: 600),
    );
    
    _bubbleAnimation = CurvedAnimation(
      parent: _bubbleController,
      curve: Curves.elasticOut,
      reverseCurve: Curves.easeIn,
    );

    // Initial Trigger
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatEngagementProvider.notifier).onAppStart();
    });

    // Idle Checker Loop
    _idleCheckTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        ref.read(chatEngagementProvider.notifier).checkIdle();
      }
    });
  }

  @override
  void dispose() {
    _bubbleController.dispose();
    _idleCheckTimer?.cancel();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      context.push('/map');
      return;
    }
    
    // Track navigation
    ref.read(chatEngagementProvider.notifier).onNavigation();

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

  void _onFabTapped() {
    // Notify provider
    ref.read(chatEngagementProvider.notifier).onUserClickChat();
    context.push('/ai-welcome'); 
  }

  @override
  Widget build(BuildContext context) {
    // Watch Engagement State
    final engagement = ref.watch(chatEngagementProvider);
    
    // React to visibility changes
    ref.listen(chatEngagementProvider, (previous, next) {
      if (next.isVisible && !_bubbleController.isCompleted) {
        _bubbleController.forward();
      } else if (!next.isVisible && (_bubbleController.isCompleted || _bubbleController.isAnimating)) {
        _bubbleController.reverse();
      }
    });

    return Scaffold(
      body: widget.child,
      floatingActionButton: Transform.translate(
        offset: const Offset(0, 10), 
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // BUBBLE TOOLTIP
            // Only build if we have a message (even if animating out)
            if (engagement.currentBubbleMessage != null)
            Positioned(
              top: -50, 
              child: ScaleTransition(
                scale: _bubbleAnimation,
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  constraints: const BoxConstraints(maxWidth: 200),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF601F), 
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: Text(
                    engagement.currentBubbleMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            
            // Triangle
             if (engagement.currentBubbleMessage != null)
             Positioned(
              top: -16, 
              child: ScaleTransition(
                scale: _bubbleAnimation,
                 alignment: Alignment.bottomCenter,
                child: CustomPaint(
                  painter: _TrianglePainter(const Color(0xFFFF601F)),
                  size: const Size(12, 8),
                ),
              ),
            ),

            // MAIN FAB (Unchanged)
            Container(
              height: 75,
              width: 75,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFF601F), // Fond orange uni
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF601F).withOpacity(0.4),
                    blurRadius: 15,
                    spreadRadius: 2,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: FloatingActionButton(
                onPressed: _onFabTapped,
                backgroundColor: Colors.transparent,
                elevation: 0,
                shape: const CircleBorder(),
                child: Padding(
                  padding: const EdgeInsets.all(14.0), // Icone un peu plus petite/centrée
                  child: Image.asset(
                    'assets/images/petit_boo.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.search, color: Colors.white, size: 30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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

class _TrianglePainter extends CustomPainter {
  final Color color;
  _TrianglePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..style = PaintingStyle.fill;
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}