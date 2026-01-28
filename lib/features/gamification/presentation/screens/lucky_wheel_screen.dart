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

class _LuckyWheelScreenState extends ConsumerState<LuckyWheelScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _currentRotation = 0.0;
  bool _isSpinning = false;

  // Couleurs modernes pour la roue (inspirées du web)
  static const List<Color> _wheelColors = [
    Color(0xFFFF6B6B), // Rouge coral
    Color(0xFF4ECDC4), // Turquoise
    Color(0xFFFFE66D), // Jaune
    Color(0xFF95E1D3), // Vert menthe
    Color(0xFFDDA0DD), // Violet clair
    Color(0xFFFFB347), // Orange
    Color(0xFF87CEEB), // Bleu ciel
    Color(0xFFF0E68C), // Kaki clair
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _spin(WheelConfig config, WidgetRef ref) async {
    if (_isSpinning) return;

    setState(() {
      _isSpinning = true;
    });

    try {
      // Appeler l'API pour obtenir le résultat
      final result = await ref.read(wheelSpinProvider.notifier).spin();

      if (result == null) {
        setState(() => _isSpinning = false);
        return;
      }

      // Calcul de l'angle de destination basé sur prizeIndex
      final prizeIndex = result.prizeIndex;
      final numPrizes = config.prizes.length;
      final segmentAngle = (2 * pi) / numPrizes;

      // L'angle du centre du segment gagnant (depuis la position 0 = droite)
      final prizeAngle = prizeIndex * segmentAngle + segmentAngle / 2;

      // Le pointeur est en HAUT, donc à -π/2 (ou 270°)
      // On veut que le segment gagnant soit sous le pointeur
      // Donc on doit tourner pour que: rotation + prizeAngle = -π/2 (mod 2π)
      // => rotation = -π/2 - prizeAngle

      // Calculer l'angle de destination (en ajoutant des tours complets)
      final extraRotations = (5 + Random().nextInt(4)) * 2 * pi; // 5-8 tours
      final destinationAngle = -pi / 2 - prizeAngle;

      // Normaliser pour avoir une rotation positive
      var targetRotation = _currentRotation + extraRotations;
      // Ajuster pour s'arrêter exactement sur le bon segment
      final currentMod = targetRotation % (2 * pi);
      final targetMod = destinationAngle % (2 * pi);
      var adjustment = targetMod - currentMod;
      if (adjustment < 0) adjustment += 2 * pi;
      targetRotation += adjustment;

      _controller.reset();
      final animation = Tween<double>(
        begin: _currentRotation,
        end: targetRotation,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCirc,
      ));

      animation.addListener(() {
        setState(() {
          _currentRotation = animation.value;
        });
      });

      await _controller.forward();

      setState(() {
        _isSpinning = false;
        _currentRotation = targetRotation % (2 * pi);
      });

      if (mounted) {
        _showResultDialog(result);
      }
    } catch (e) {
      setState(() => _isSpinning = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showResultDialog(WheelSpinResult result) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icône animée
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: result.prize > 0
                      ? Colors.amber.shade100
                      : Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  result.prize > 0 ? Icons.celebration : Icons.sentiment_dissatisfied,
                  size: 48,
                  color: result.prize > 0 ? Colors.amber : Colors.grey,
                ),
              ),
              const SizedBox(height: 20),

              // Titre
              Text(
                result.prize > 0 ? 'Félicitations !' : 'Pas de chance...',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Message
              Text(
                result.message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
              ),

              if (result.prize > 0) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.account_balance_wallet, color: Colors.green.shade700),
                      const SizedBox(width: 8),
                      Text(
                        'Nouveau solde : ${result.newBalance} Hibons',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF601F),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Super !',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final configAsync = ref.watch(wheelConfigProvider);
    final walletAsync = ref.watch(gamificationNotifierProvider);
    final spinState = ref.watch(wheelSpinProvider);

    // Récupérer canSpinWheel du wallet
    final canSpinWheel = walletAsync.maybeWhen(
      data: (wallet) => wallet.canSpinWheel,
      orElse: () => false,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0), // Fond crème léger
      appBar: AppBar(
        title: const Text('Roue de la Fortune'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: configAsync.when(
        data: (config) {
          return Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Roue avec bordure et ombre
                    _buildWheel(config),

                    const SizedBox(height: 40),

                    // Bouton Lancer
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: (_isSpinning || spinState.isLoading || !canSpinWheel)
                            ? null
                            : () => _spin(config, ref),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: canSpinWheel
                              ? const Color(0xFFFF601F)
                              : Colors.grey.shade400,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: canSpinWheel ? 4 : 0,
                        ),
                        child: _isSpinning
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                canSpinWheel ? 'Lancer' : 'Reviens demain !',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),

                    if (!canSpinWheel)
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Text(
                          'Tu as déjà utilisé ta chance aujourd\'hui.',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Erreur: $e'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(wheelConfigProvider),
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWheel(WheelConfig config) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Ombre de la roue
        Container(
          width: 320,
          height: 320,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
        ),

        // Bordure extérieure blanche
        Container(
          width: 320,
          height: 320,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
        ),

        // Roue principale
        Transform.rotate(
          angle: _currentRotation,
          child: SizedBox(
            width: 300,
            height: 300,
            child: CustomPaint(
              size: const Size(300, 300),
              painter: WheelPainter(
                prizes: config.prizes,
                colors: _wheelColors,
              ),
            ),
          ),
        ),

        // Pointeur (flèche en haut)
        Positioned(
          top: 5,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_drop_down,
              size: 50,
              color: Color(0xFF2D3748),
            ),
          ),
        ),

        // Centre de la roue
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
              ),
            ],
            border: Border.all(color: Colors.grey.shade200, width: 2),
          ),
          child: const Center(
            child: Icon(
              Icons.star_rounded,
              size: 30,
              color: Color(0xFFFFB347),
            ),
          ),
        ),
      ],
    );
  }
}

class WheelPainter extends CustomPainter {
  final List<WheelPrize> prizes;
  final List<Color> colors;

  WheelPainter({required this.prizes, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final paint = Paint()..style = PaintingStyle.fill;
    final segmentAngle = (2 * pi) / prizes.length;

    // Dessiner les segments
    for (int i = 0; i < prizes.length; i++) {
      // Utiliser les couleurs définies ou fallback
      paint.color = colors[i % colors.length];

      // Dessiner l'arc (segment)
      // On commence à -π/2 pour que le premier segment soit en haut
      final startAngle = -pi / 2 + i * segmentAngle;
      canvas.drawArc(rect, startAngle, segmentAngle, true, paint);
    }

    // Dessiner les textes
    for (int i = 0; i < prizes.length; i++) {
      final prize = prizes[i];
      final startAngle = -pi / 2 + i * segmentAngle;
      final textAngle = startAngle + segmentAngle / 2;
      final textRadius = radius * 0.65;
      final x = center.dx + textRadius * cos(textAngle);
      final y = center.dy + textRadius * sin(textAngle);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(textAngle + pi / 2);

      final textPainter = TextPainter(
        text: TextSpan(
          text: prize.label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13,
            shadows: [
              Shadow(
                color: Colors.black26,
                offset: Offset(1, 1),
                blurRadius: 2,
              ),
            ],
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );

      canvas.restore();
    }

    // Dessiner les lignes de séparation
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < prizes.length; i++) {
      final angle = -pi / 2 + i * segmentAngle;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      canvas.drawLine(center, Offset(x, y), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant WheelPainter oldDelegate) {
    return oldDelegate.prizes != prizes;
  }
}
