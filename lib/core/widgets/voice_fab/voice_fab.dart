import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../../features/petit_boo/presentation/providers/engagement_provider.dart';
import 'animated_ring.dart';
import 'pulse_waves.dart';
import 'voice_fab_sounds.dart';

/// Voice FAB - Assistant Vocal Petit Boo
///
/// Comportements :
/// - Tap court (1er) : Affiche tooltip "Maintiens pour parler"
/// - Tap court (2e rapide) : Ouvre le chat classique
/// - Appui prolongé (>=300ms) : Mode écoute vocale avec animations
/// - Relâchement : Envoie la transcription au chat
class VoiceFab extends ConsumerStatefulWidget {
  const VoiceFab({super.key});

  @override
  ConsumerState<VoiceFab> createState() => _VoiceFabState();
}

class _VoiceFabState extends ConsumerState<VoiceFab>
    with TickerProviderStateMixin {
  // Animations
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  // Speech-to-text
  late stt.SpeechToText _speech;
  bool _speechEnabled = false;
  bool _isListening = false;
  String _transcription = '';

  // Tooltip management
  Timer? _tooltipTimer;
  bool _showTooltip = false;
  String _tooltipMessage = '';

  // Bulle tooltip animation
  late AnimationController _bubbleController;
  late Animation<double> _bubbleAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _initSpeech();
    VoiceFabSounds.init();
  }

  void _initAnimations() {
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutBack),
    );

    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _bubbleAnimation = CurvedAnimation(
      parent: _bubbleController,
      curve: Curves.elasticOut,
      reverseCurve: Curves.easeIn,
    );
  }

  Future<void> _initSpeech() async {
    _speech = stt.SpeechToText();
    try {
      _speechEnabled = await _speech.initialize(
        onStatus: (status) {
          if (status == 'notListening' || status == 'done') {
            if (mounted && _isListening) {
              _stopListening(sendMessage: true);
            }
          }
        },
        onError: (error) {
          if (mounted) {
            _showError('Erreur micro: ${error.errorMsg}');
            _stopListening(sendMessage: false);
          }
        },
      );
    } catch (e) {
      debugPrint('VoiceFab: Speech init error: $e');
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _bubbleController.dispose();
    _tooltipTimer?.cancel();
    _speech.stop();
    VoiceFabSounds.dispose();
    super.dispose();
  }

  /// Gestion du tap court
  void _onTap() {
    // Si le tooltip est déjà visible → ouvrir le chat
    if (_showTooltip) {
      _hideTooltip();
      _openChat();
      return;
    }

    // Sinon → afficher le tooltip d'aide
    _showHintTooltip();
  }

  /// Affiche le tooltip d'aide
  void _showHintTooltip() {
    setState(() {
      _showTooltip = true;
      _tooltipMessage = 'Maintiens pour parler';
    });
    _bubbleController.forward();

    _tooltipTimer?.cancel();
    _tooltipTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        _hideTooltip();
      }
    });
  }

  /// Cache le tooltip
  void _hideTooltip() {
    _bubbleController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _showTooltip = false;
          _tooltipMessage = '';
        });
      }
    });
  }

  /// Affiche un tooltip d'erreur
  void _showError(String message) {
    _tooltipTimer?.cancel();
    setState(() {
      _showTooltip = true;
      _tooltipMessage = message;
    });
    _bubbleController.forward();

    _tooltipTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        _hideTooltip();
      }
    });
  }

  /// Ouvre le chat classique
  void _openChat() {
    ref.read(petitBooEngagementProvider.notifier).onUserClickChat();
    context.push('/petit-boo');
  }

  /// Démarre l'écoute (appui prolongé)
  Future<void> _startListening() async {
    // Vérifier les permissions
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      status = await Permission.microphone.request();
      if (!status.isGranted) {
        _showError('Autorise le micro dans Réglages');
        return;
      }
    }

    if (!_speechEnabled) {
      await _initSpeech();
      if (!_speechEnabled) {
        _showError('Le micro n\'est pas disponible');
        return;
      }
    }

    // Cacher le tooltip si visible
    if (_showTooltip) {
      _hideTooltip();
    }

    // Feedback haptique
    HapticFeedback.mediumImpact();

    // Son de début
    VoiceFabSounds.playStartListening();

    // Animation du bouton
    _scaleController.forward();

    setState(() {
      _isListening = true;
      _transcription = '';
    });

    // Démarrer l'écoute
    await _speech.listen(
      onResult: (result) {
        if (mounted && _isListening) {
          setState(() {
            _transcription = result.recognizedWords;
          });
        }
      },
      localeId: 'fr_FR',
      listenOptions: stt.SpeechListenOptions(
        listenMode: stt.ListenMode.dictation,
        cancelOnError: false,
        partialResults: true,
      ),
    );
  }

  /// Arrête l'écoute (relâchement)
  Future<void> _stopListening({required bool sendMessage}) async {
    await _speech.stop();

    // Son de fin
    VoiceFabSounds.playStopListening();

    // Animation retour
    _scaleController.reverse();

    final transcriptionText = _transcription.trim();

    setState(() {
      _isListening = false;
    });

    if (sendMessage && mounted) {
      if (transcriptionText.isEmpty) {
        _showError('Je n\'ai rien entendu');
      } else {
        // Naviguer vers le chat avec le message
        ref.read(petitBooEngagementProvider.notifier).onUserClickChat();
        if (context.mounted) {
          context.push('/petit-boo?message=${Uri.encodeComponent(transcriptionText)}');
        }
      }
    }

    _transcription = '';
  }

  @override
  Widget build(BuildContext context) {
    // Récupérer l'état d'engagement pour les bulles
    final engagement = ref.watch(petitBooEngagementProvider);

    return Transform.translate(
      offset: const Offset(0, 10),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // ONDES PULSANTES (derrière tout)
          Positioned(
            child: PulseWaves(
              size: 75,
              isAnimating: _isListening,
            ),
          ),

          // ANNEAU GRADIENT TOURNANT
          AnimatedGradientRing(
            size: 95,
            strokeWidth: 4,
            gap: 6,
            isAnimating: _isListening,
            child: const SizedBox.shrink(),
          ),

          // BOUTON FAB PRINCIPAL
          ScaleTransition(
            scale: _scaleAnimation,
            child: GestureDetector(
              onTap: _onTap,
              onLongPressStart: (_) => _startListening(),
              onLongPressEnd: (_) {
                if (_isListening) {
                  _stopListening(sendMessage: true);
                }
              },
              onLongPressCancel: () {
                if (_isListening) {
                  _stopListening(sendMessage: false);
                }
              },
              child: Container(
                height: 75,
                width: 75,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isListening
                      ? const Color(0xFFFF601F).withValues(alpha: 0.9)
                      : const Color(0xFFFF601F),
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF601F).withValues(alpha:
                        _isListening ? 0.6 : 0.4
                      ),
                      blurRadius: _isListening ? 20 : 15,
                      spreadRadius: _isListening ? 4 : 2,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: _isListening
                      ? const Icon(
                          Icons.mic,
                          color: Colors.white,
                          size: 32,
                        )
                      : Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Image.asset(
                            'assets/images/petit_boo.png',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.search, color: Colors.white, size: 30),
                          ),
                        ),
                ),
              ),
            ),
          ),

          // TOOLTIP / BULLE avec triangle (AU-DESSUS du FAB)
          if (_showTooltip || engagement.currentBubbleMessage != null)
            Positioned(
              bottom: 70,
              child: ScaleTransition(
                scale: _showTooltip ? _bubbleAnimation : const AlwaysStoppedAnimation(1.0),
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Bulle
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      constraints: const BoxConstraints(maxWidth: 200),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF601F),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        _showTooltip
                            ? _tooltipMessage
                            : (engagement.currentBubbleMessage ?? ''),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    // Triangle (pointe vers le bas vers le FAB)
                    Transform.translate(
                      offset: const Offset(0, -1),
                      child: CustomPaint(
                        painter: _TrianglePainter(const Color(0xFFFF601F)),
                        size: const Size(12, 8),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Transcription en temps réel (pendant l'écoute)
          if (_isListening && _transcription.isNotEmpty)
            Positioned(
              bottom: 100,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                constraints: const BoxConstraints(maxWidth: 250),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  _transcription,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF2D3748),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Painter pour le triangle de la bulle
class _TrianglePainter extends CustomPainter {
  final Color color;
  _TrianglePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
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
