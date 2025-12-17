import 'package:flutter/material.dart';

class TypingBubble extends StatefulWidget {
  const TypingBubble({super.key});

  @override
  State<TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<TypingBubble> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16, left: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
           // AI Avatar
            Container(
              margin: const EdgeInsets.only(right: 8, bottom: 0),
              child: CircleAvatar(
                backgroundColor: const Color(0xFFFF601F),
                radius: 16,
                child: ClipOval(
                  child: Image.asset('assets/images/petit_boo_logo.png', fit: BoxFit.cover),
                ),
              ),
            ),
            
           // Bubble
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.zero,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (index) => _buildDot(index)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        // Staggered sine wave effect
        final double bounce =  _animation.value * 2 * 3.14159; 
        // Offset each dot by phase
        final double phase = index * 0.5; 
        final double offset = (bounce + phase) % (2 * 3.14159);
        // We want a jump effect: sin(x) but clamped or adjusted
        
        // Simpler approach:
        // Use a staggered opacity or translation
        
        // Let's do simple translation Y
        // We want them to wave up and down
        // 0 -> 0, 0.5 -> -5, 1.0 -> 0
        
        // Calculate a value 0..1 that loops for this specific dot based on controller
        double value = _controller.value + (index * 0.2); 
        if (value > 1.0) value -= 1.0;
        
        // Convert 0..1 to a jump curve (0 -> 1 -> 0)
        double jump = 0;
        if (value < 0.5) {
           jump = -4.0 * value * (value - 0.5) * 4; // Parabola-ish? No, simpler: sin
           jump = -6.0 * (value < 0.25 ? value * 4 : (0.5 - value) * 4); // Up and Down quick
           // Actually let's use sin
           jump = -5.0 * (1.0 - (2*value - 1.0).abs()); // Linear Triangle wave?
        }
        
        // Let's use sin for smoothness
        final double shift = index * 0.4;
        final double t = (_controller.value + shift) * 2 * 3.14159;
        final double y = 3 * (0.5 + 0.5 * -1 *  (t).abs()); // Not quite
        
        // Best looking "typing" is usually opacity or slight jump.
        // Let's stick to standard Flutter LoadingIndicator logic simplified:
        // Or just explicit intervals.
        
        double yOffset = 0;
        double opacity = 0.6;
        
        // Create a wave passing through
        double wave = (_controller.value * 3) - index;
        if (wave > 0 && wave < 1) {
             yOffset = -5 * (0.5 - (wave - 0.5).abs()) * 2; // Jump up
             opacity = 1.0;
        } else {
          opacity = 0.4;
        }

        return Transform.translate(
          offset: Offset(0, yOffset),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: const Color(0xFFFF601F).withOpacity(opacity),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}
