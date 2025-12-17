
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/wheel_models.dart';
import '../providers/gamification_provider.dart';

class LuckyWheelScreen extends ConsumerStatefulWidget {
  const LuckyWheelScreen({super.key});

  @override
  ConsumerState<LuckyWheelScreen> createState() => _LuckyWheelScreenState();
}

class _LuckyWheelScreenState extends ConsumerState<LuckyWheelScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  // late Animation<double> _animation; // Dynamic
  double _currentRotation = 0.0;
  bool _isSpinning = false;
  WheelSpinResult? _lastResult;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(seconds: 4));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _spin(WheelConfig config, WidgetRef ref) async {
    if (_isSpinning) return;
    
    // Check cost (mock check)
    // In real app, we check wallet balance vs cost
    
    setState(() {
      _isSpinning = true;
      _lastResult = null;
    });

    try {
      final repository = ref.read(gamificationRepositoryProvider);
      // API Call - Result is determined by backend (or mock) instantly
      // We just need to animate to it.
      // But for better UX, we start animation THEN call API, or call API then calculate angle. 
      // Let's call API first to know where to stop.
      final result = await repository.spinWheel();
       
      // Calculate destination angle
      final segmentIndex = config.segments.indexOf(result.segment);
      final segmentAngle = (2 * pi) / config.segments.length;
      
      // Random extra rotations (5 to 10)
      final extraRotations = (5 + Random().nextInt(5)) * 2 * pi;
      
      // Target angle to center the segment at the top (indicator usually at top = -pi/2 or 0 depending on draw)
      // Assuming 0 is Right (Standard Canvas). Segment 0 starts at 0.
      // We want result segment to end up under the pointer.
      // Let's say pointer is at TOP (-pi/2).
      // Center of segment i is at: i * segmentAngle + segmentAngle/2
      // We want: EndRotation + (i * segmentAngle + segmentAngle/2) = -pi/2 + 2k*pi
      // ... A bit complex math for a mock. 
      // Simplified: We spin to a random total angle that falls inside the segment arc.
      
      // For visual simplicity in this task, let's just spin randomly long enough and show result in dialog
      // REAL IMPLEMENTATION needs precise math.
      // Let's try to match:
      
      // Angle to stop at (random within segment)
      final segmentStart = segmentIndex * segmentAngle;
      final segmentEnd = (segmentIndex + 1) * segmentAngle;
      final targetAngleInCircle = segmentStart + (Random().nextDouble() * (segmentEnd - segmentStart));
      
      // Standard Flutter rotation: 0 is right. We usually want pointer at top.
      // Let's assume pointer is Top.
      // To land 'targetAngleInCircle' at Top (-PI/2), we need to rotate the wheel such that:
      // CurrentRotation + Delta = -PI/2 - targetAngleInCircle + K*2PI
      
      final targetRotation = _currentRotation + extraRotations + (2*pi); // Just spin a lot
      
      _controller.reset();
      final animation = Tween<double>(begin: _currentRotation, end: targetRotation).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic)
      );
      
      animation.addListener(() {
        setState(() {
          _currentRotation = animation.value;
        });
      });
      
      await _controller.forward();
      
      // Refresh wallet
      ref.invalidate(gamificationNotifierProvider);

      setState(() {
        _isSpinning = false;
        _currentRotation = targetRotation % (2 * pi); // Keep it normalized
        _lastResult = result;
      });

      if (mounted) {
        _showResultDialog(result);
      }
      
    } catch (e) {
      setState(() => _isSpinning = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e')));
    }
  }

  void _showResultDialog(WheelSpinResult result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(result.earnedHibons > 0 ? "Félicitations !" : "Dommage !"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (result.earnedHibons > 0) 
              const Icon(Icons.emoji_events, size: 50, color: Colors.amber),
            const SizedBox(height: 16),
            Text(result.message, textAlign: TextAlign.center),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Super !'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final configAsync = ref.watch(wheelConfigProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Roue de la Fortune')),
      body: configAsync.when(
        data: (config) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildWheel(config),
                const SizedBox(height: 40),
                 ElevatedButton(
                  onPressed: _isSpinning ? null : () => _spin(config, ref),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    backgroundColor: const Color(0xFFFF601F)
                  ),
                  child: Text(
                    _isSpinning ? 'Bonne chance...' : (config.isFreeSpinAvailable ? 'Tour Gratuit' : 'Lancer (100 H)'),
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                if (!config.isFreeSpinAvailable)
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text('Prochain tour gratuit dans 24h', style: TextStyle(color: Colors.grey)),
                  )
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Erreur: $e')),
      ),
    );
  }

  Widget _buildWheel(WheelConfig config) {
    return SizedBox(
      height: 300,
      width: 300,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Wheel
          Transform.rotate(
            angle: _currentRotation,
            child: CustomPaint(
              size: const Size(300, 300),
              painter: WheelPainter(config.segments),
            ),
          ),
          // Pointer (Triangle at top)
          Positioned(
            top: 0,
            child: Icon(Icons.arrow_drop_down, size: 40, color: Colors.black),
          ),
          // Center decorator
          Container(
            width: 40, 
            height: 40, 
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(blurRadius: 5)]),
            child: const Center(child: Icon(Icons.star, size: 20, color: Colors.orange)),
          )
        ],
      ),
    );
  }
}

class WheelPainter extends CustomPainter {
  final List<WheelSegment> segments;

  WheelPainter(this.segments);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);
    
    final paint = Paint()..style = PaintingStyle.fill;
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    final segmentAngle = (2 * pi) / segments.length;

    for (int i = 0; i < segments.length; i++) {
      final segment = segments[i];
      paint.color = Color(segment.colorInt); // Assuming int color is ARGB
      
      // Draw slice
      // Start at i * angle.
      // Note: Arc starts at 0 (Right).
      canvas.drawArc(rect, i * segmentAngle, segmentAngle, true, paint);
      
      // Draw Text
      // Calculate angle for text: center of wedge
      final textAngle = (i * segmentAngle) + (segmentAngle / 2);
      // Position: radius * 0.7 from center
      final textRadius = radius * 0.7;
      final x = center.dx + textRadius * cos(textAngle);
      final y = center.dy + textRadius * sin(textAngle);
      
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(textAngle + pi/2); // Text radial
      
      textPainter.text = TextSpan(
        text: segment.label,
        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));
      
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
