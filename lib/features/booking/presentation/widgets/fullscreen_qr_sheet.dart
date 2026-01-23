import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/features/booking/presentation/widgets/large_qr_code.dart';
import 'package:screen_brightness/screen_brightness.dart';

class FullscreenQRSheet extends StatefulWidget {
  final String qrData;
  final String title;
  final String? subtitle;

  const FullscreenQRSheet({
    super.key,
    required this.qrData,
    required this.title,
    this.subtitle,
  });

  @override
  State<FullscreenQRSheet> createState() => _FullscreenQRSheetState();
}

class _FullscreenQRSheetState extends State<FullscreenQRSheet>
    with SingleTickerProviderStateMixin {
  double? _originalBrightness;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setMaxBrightness();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _restoreBrightness();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _setMaxBrightness() async {
    try {
      _originalBrightness = await ScreenBrightness().current;
      await ScreenBrightness().setScreenBrightness(1.0);
    } catch (e) {
      debugPrint('Error setting brightness: $e');
    }
  }

  Future<void> _restoreBrightness() async {
    try {
      if (_originalBrightness != null) {
        await ScreenBrightness().setScreenBrightness(_originalBrightness!);
      } else {
        await ScreenBrightness().resetScreenBrightness();
      }
    } catch (e) {
      debugPrint('Error restoring brightness: $e');
    }
  }

  void _close() {
    HapticFeedback.lightImpact();
    _animationController.reverse().then((_) {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: _close,
          behavior: HitTestBehavior.opaque,
          child: SafeArea(
            child: Stack(
              children: [
                // Main content
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Title
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: HbColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (widget.subtitle != null &&
                            widget.subtitle!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            widget.subtitle!,
                            style: const TextStyle(
                              fontSize: 15,
                              color: HbColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                        const SizedBox(height: 32),
                        // Large QR Code
                        LargeQRCode.fullscreen(
                          data: widget.qrData,
                          codeLabel: _extractCode(widget.qrData),
                        ),
                        const SizedBox(height: 40),
                        // Hint
                        Text(
                          'Appuyez n\'importe où pour fermer',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Close button at top right
                Positioned(
                  top: 16,
                  right: 16,
                  child: IconButton(
                    onPressed: _close,
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey.shade100,
                      padding: const EdgeInsets.all(12),
                    ),
                    icon: const Icon(
                      Icons.close,
                      color: HbColors.textPrimary,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _extractCode(String data) {
    if (data.length <= 16) return data.toUpperCase();

    if (data.contains('/')) {
      final segments = data.split('/');
      final last = segments.lastWhere((s) => s.isNotEmpty, orElse: () => '');
      if (last.isNotEmpty && last.length <= 16) {
        return last.toUpperCase();
      }
    }

    return data.substring(0, 12).toUpperCase();
  }
}
