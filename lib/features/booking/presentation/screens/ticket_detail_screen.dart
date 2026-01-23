import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/core/themes/hb_theme.dart';
import 'package:lehiboo/domain/entities/booking.dart';
import 'package:lehiboo/features/booking/presentation/widgets/large_qr_code.dart';
import 'package:lehiboo/features/booking/presentation/widgets/fullscreen_qr_sheet.dart';
import 'package:lehiboo/features/booking/presentation/widgets/ticket_preview_card.dart';
import 'package:screen_brightness/screen_brightness.dart';

class TicketDetailScreen extends StatefulWidget {
  final String ticketId;
  final Ticket? ticket;
  final List<Ticket>? tickets;
  final int initialIndex;
  final Booking? booking;

  const TicketDetailScreen({
    super.key,
    required this.ticketId,
    this.ticket,
    this.tickets,
    this.initialIndex = 0,
    this.booking,
  });

  @override
  State<TicketDetailScreen> createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  late PageController _pageController;
  late int _currentIndex;
  double? _originalBrightness;

  List<Ticket> get _tickets => widget.tickets ?? (widget.ticket != null ? [widget.ticket!] : []);

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
    _increaseBrightness();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _restoreBrightness();
    super.dispose();
  }

  Future<void> _increaseBrightness() async {
    try {
      _originalBrightness = await ScreenBrightness().current;
      await ScreenBrightness().setScreenBrightness(0.9);
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

  void _showFullscreenQR(Ticket ticket) {
    HapticFeedback.lightImpact();
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) => FullscreenQRSheet(
          qrData: ticket.qrCodeData ?? ticket.id,
          title: widget.booking?.activity?.title ?? 'Billet',
          subtitle: _getEventSubtitle(),
        ),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  String _getEventSubtitle() {
    final slot = widget.booking?.slot;
    if (slot?.startDateTime != null) {
      final date = DateFormat('E d MMM', 'fr_FR').format(slot!.startDateTime!);
      final time = DateFormat('HH:mm').format(slot.startDateTime!);
      return '$date • $time';
    }
    return '';
  }

  void _shareTicket(Ticket ticket) {
    final activity = widget.booking?.activity;
    String shareText = 'Mon billet Le Hiboo\n';
    if (activity != null) {
      shareText += '\n${activity.title}';
    }
    shareText += '\n\nCode: ${ticket.qrCodeData ?? ticket.id}';
    Share.share(shareText);
  }

  void _downloadTicket(Ticket ticket) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Téléchargement du billet...'),
        backgroundColor: HbColors.brandPrimary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = HbTheme.tokens(context);

    if (_tickets.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: HbColors.textPrimary),
            onPressed: () => context.pop(),
          ),
          title: const Text(
            'Billet',
            style: TextStyle(color: HbColors.textPrimary, fontWeight: FontWeight.w700),
          ),
        ),
        body: const Center(
          child: Text('Billet non trouvé'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: HbColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          _tickets.length > 1
              ? 'Billet ${_currentIndex + 1}/${_tickets.length}'
              : 'Billet',
          style: const TextStyle(
            color: HbColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: HbColors.textPrimary),
            onPressed: () => _shareTicket(_tickets[_currentIndex]),
          ),
        ],
      ),
      body: Column(
        children: [
          // Page view for tickets
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _tickets.length,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
                HapticFeedback.selectionClick();
              },
              itemBuilder: (context, index) {
                return _buildTicketPage(_tickets[index], index);
              },
            ),
          ),
          // Page indicators
          if (_tickets.length > 1)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_tickets.length, (index) {
                  return Container(
                    width: _currentIndex == index ? 24 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: _currentIndex == index
                          ? HbColors.brandPrimary
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),
          // Swipe hint
          if (_tickets.length > 1)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                '← Swipe pour voir les autres billets →',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
            ),
          // Download button
          Padding(
            padding: EdgeInsets.fromLTRB(
              tokens.spacing.m,
              0,
              tokens.spacing.m,
              MediaQuery.of(context).padding.bottom + 16,
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _downloadTicket(_tickets[_currentIndex]),
                icon: const Icon(Icons.download, size: 20),
                label: const Text('Télécharger le billet PDF'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: HbColors.brandPrimary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketPage(Ticket ticket, int index) {
    final tokens = HbTheme.tokens(context);
    final activity = widget.booking?.activity;
    final slot = widget.booking?.slot;
    final status = TicketStatusExtension.fromString(ticket.status);

    final qrData = ticket.qrCodeData ?? ticket.id;
    final ticketType = ticket.ticketType ?? 'Standard';
    final attendeeName = 'Participant ${index + 1}';

    return SingleChildScrollView(
      padding: EdgeInsets.all(tokens.spacing.m),
      child: Column(
        children: [
          const SizedBox(height: 8),
          // QR Code - tappable for fullscreen
          GestureDetector(
            onTap: () => _showFullscreenQR(ticket),
            child: LargeQRCode(
              data: qrData,
              size: QRCodeSize.medium,
              codeLabel: _extractCode(qrData),
            ),
          ),
          const SizedBox(height: 24),
          // Ticket info card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(tokens.spacing.m),
            decoration: BoxDecoration(
              color: HbColors.orangePastel,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                // Attendee info
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: HbColors.brandPrimary.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        color: HbColors.brandPrimary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            attendeeName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: HbColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(Icons.confirmation_number_outlined,
                                  size: 14, color: HbColors.textSecondary),
                              const SizedBox(width: 4),
                              Text(
                                ticketType,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: HbColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Status badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: status.color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle, size: 14, color: status.color),
                          const SizedBox(width: 4),
                          Text(
                            status.label,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: status.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Event info
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(tokens.spacing.m),
            decoration: BoxDecoration(
              color: HbColors.orangePastel,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity?.title ?? 'Événement',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: HbColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                if (slot?.startDateTime != null)
                  _buildInfoRow(
                    icon: Icons.calendar_today_outlined,
                    text: DateFormat('EEEE d MMMM yyyy', 'fr_FR')
                        .format(slot!.startDateTime!),
                  ),
                if (slot?.startDateTime != null) ...[
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    icon: Icons.access_time,
                    text: DateFormat('HH:mm').format(slot!.startDateTime!),
                  ),
                ],
                if (activity?.city?.name != null) ...[
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    icon: Icons.location_on_outlined,
                    text: [
                      activity?.partner?.name,
                      activity?.city?.name,
                    ].where((s) => s != null && s.isNotEmpty).join(', '),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Tap hint
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
    );
  }

  Widget _buildInfoRow({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: HbColors.textSecondary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: HbColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  String _extractCode(String data) {
    if (data.length <= 12) return data.toUpperCase();

    if (data.contains('/')) {
      final segments = data.split('/');
      final last = segments.lastWhere((s) => s.isNotEmpty, orElse: () => '');
      if (last.isNotEmpty && last.length <= 12) {
        return last.toUpperCase();
      }
    }

    return data.substring(0, 10).toUpperCase();
  }
}
