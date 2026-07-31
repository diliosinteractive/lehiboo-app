import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lehiboo/core/l10n/l10n.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/domain/entities/booking.dart';
import 'package:lehiboo/features/booking/presentation/widgets/large_qr_code.dart';
import 'package:lehiboo/features/booking/presentation/widgets/fullscreen_qr_sheet.dart';
import 'package:screen_brightness/screen_brightness.dart';

class QuickQRBottomSheet extends StatefulWidget {
  final Booking booking;
  final Ticket ticket;

  const QuickQRBottomSheet({
    super.key,
    required this.booking,
    required this.ticket,
  });

  @override
  State<QuickQRBottomSheet> createState() => _QuickQRBottomSheetState();
}

class _QuickQRBottomSheetState extends State<QuickQRBottomSheet> {
  double? _originalBrightness;

  @override
  void initState() {
    super.initState();
    if (_getQRData() != null) _increaseBrightness();
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
    final qrData = _getQRData();
    if (qrData == null) return;
    HapticFeedback.lightImpact();
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) => FullscreenQRSheet(
          qrData: qrData,
          title:
              widget.booking.activity?.title ?? context.l10n.bookingTicketTitle,
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

  String? _getQRData() {
    final qrData = widget.ticket.qrCodeData?.trim();
    return qrData == null || qrData.isEmpty ? null : qrData;
  }

  String _getSubtitle() {
    final activity = widget.booking.activity;
    final slot = widget.booking.slot;
    final startDateTime = slot?.startDateTime;

    if (startDateTime != null) {
      final date = context
          .appDateFormat('E d MMM', enPattern: 'EEE, MMM d')
          .format(startDateTime);
      final time = DateFormat('HH:mm').format(startDateTime);
      return '$date • $time';
    }

    return activity?.city?.name ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final activity = widget.booking.activity;
    final slot = widget.booking.slot;
    final startDateTime = slot?.startDateTime;

    final dateStr = startDateTime != null
        ? context
            .appDateFormat('EEEE d MMMM', enPattern: 'EEEE, MMMM d')
            .format(startDateTime)
        : '';
    final timeStr =
        startDateTime != null ? DateFormat('HH:mm').format(startDateTime) : '';

    final ticketCount = widget.booking.quantity ?? 1;
    final ticketLabel = ticketCount > 1
        ? context.l10n.bookingTicketPlural(ticketCount)
        : context.l10n.bookingTicketSingular;
    final qrData = _getQRData();

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
                    activity?.title ?? context.l10n.bookingReservationFallback,
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
                  if (qrData != null)
                    GestureDetector(
                      onTap: _showFullscreenQR,
                      child: LargeQRCode.large(
                        data: qrData,
                        codeLabel: _extractShortCode(qrData),
                      ),
                    )
                  else
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.qr_code_2,
                            size: 48,
                            color: HbColors.textSecondary,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            context.l10n.bookingTicketNotReady,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: HbColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),
                  // Hint text
                  if (qrData != null)
                    Text(
                      context.l10n.bookingQrTapFullscreenHint,
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
                child: Text(
                  context.l10n.commonClose,
                  style: const TextStyle(
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
