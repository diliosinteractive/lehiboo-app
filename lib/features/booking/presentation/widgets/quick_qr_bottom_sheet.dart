import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/domain/entities/booking.dart';
import 'package:lehiboo/features/booking/presentation/widgets/large_qr_code.dart';
import 'package:lehiboo/features/booking/presentation/widgets/fullscreen_qr_sheet.dart';
import 'package:screen_brightness/screen_brightness.dart';

class QuickQRBottomSheet extends StatefulWidget {
  final Booking booking;
  final Ticket? ticket;

  const QuickQRBottomSheet({
    super.key,
    required this.booking,
    this.ticket,
  });

  @override
  State<QuickQRBottomSheet> createState() => _QuickQRBottomSheetState();
}

class _QuickQRBottomSheetState extends State<QuickQRBottomSheet> {
  double? _originalBrightness;

  @override
  void initState() {
    super.initState();
    _increaseBrightness();
  }

  @override
  void dispose() {
    _restoreBrightness();
    super.dispose();
  }

  Future<void> _increaseBrightness() async {
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

  void _showFullscreenQR() {
    HapticFeedback.lightImpact();
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) => FullscreenQRSheet(
          qrData: _getQRData(),
          title: widget.booking.activity?.title ?? 'Billet',
          subtitle: _getSubtitle(),
        ),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  String _getQRData() {
    // Use ticket QR data if available, otherwise use booking ID
    if (widget.ticket?.qrCodeData != null) {
      return widget.ticket!.qrCodeData!;
    }
    return widget.booking.id;
  }

  String _getSubtitle() {
    final activity = widget.booking.activity;
    final slot = widget.booking.slot;

    if (slot?.startDateTime != null) {
      final date = DateFormat('E d MMM', 'fr_FR').format(slot!.startDateTime!);
      final time = DateFormat('HH:mm').format(slot.startDateTime!);
      return '$date • $time';
    }

    return activity?.city?.name ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final activity = widget.booking.activity;
    final slot = widget.booking.slot;

    final dateStr = slot?.startDateTime != null
        ? DateFormat('EEEE d MMMM', 'fr_FR').format(slot!.startDateTime!)
        : '';
    final timeStr = slot?.startDateTime != null
        ? DateFormat('HH:mm').format(slot!.startDateTime!)
        : '';

    final ticketCount = widget.booking.quantity ?? 1;
    final ticketLabel = ticketCount > 1 ? '$ticketCount billets' : '1 billet';

    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Title
                  Text(
                    activity?.title ?? 'Réservation',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: HbColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Date and time
                  if (dateStr.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 16,
                          color: HbColors.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '$dateStr • $timeStr',
                          style: const TextStyle(
                            fontSize: 14,
                            color: HbColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 4),
                  // Tickets count
                  Text(
                    ticketLabel,
                    style: const TextStyle(
                      fontSize: 14,
                      color: HbColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // QR Code - tappable for fullscreen
                  GestureDetector(
                    onTap: _showFullscreenQR,
                    child: LargeQRCode.large(
                      data: _getQRData(),
                      codeLabel: _extractShortCode(_getQRData()),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Hint text
                  Text(
                    'Appuyez sur le QR code pour l\'afficher en plein écran',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          // Bottom button
          Padding(
            padding: EdgeInsets.fromLTRB(
              24,
              0,
              24,
              MediaQuery.of(context).padding.bottom + 16,
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: HbColors.brandPrimary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Fermer',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _extractShortCode(String data) {
    // Extract a short readable code from QR data
    if (data.length <= 12) return data.toUpperCase();

    // Try to extract last segment if URL-like
    if (data.contains('/')) {
      final segments = data.split('/');
      final last = segments.lastWhere((s) => s.isNotEmpty, orElse: () => '');
      if (last.isNotEmpty && last.length <= 12) {
        return last.toUpperCase();
      }
    }

    // Return first 10 chars
    return data.substring(0, 10).toUpperCase();
  }
}
