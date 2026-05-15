import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lehiboo/core/l10n/l10n.dart';
import 'package:share_plus/share_plus.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/core/themes/hb_theme.dart';
import 'package:lehiboo/domain/entities/booking.dart';
import 'package:lehiboo/features/booking/data/datasources/booking_api_datasource.dart';
import 'package:lehiboo/features/booking/presentation/utils/booking_l10n.dart';
import 'package:lehiboo/features/booking/presentation/utils/ticket_download_helper.dart';
import 'package:lehiboo/features/booking/presentation/widgets/large_qr_code.dart';
import 'package:lehiboo/features/booking/presentation/widgets/fullscreen_qr_sheet.dart';
import 'package:lehiboo/features/booking/presentation/widgets/ticket_preview_card.dart';
import 'package:screen_brightness/screen_brightness.dart';

class TicketDetailScreen extends ConsumerStatefulWidget {
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
  ConsumerState<TicketDetailScreen> createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends ConsumerState<TicketDetailScreen> {
  late PageController _pageController;
  late int _currentIndex;
  double? _originalBrightness;

  List<Ticket> get _tickets =>
      widget.tickets ?? (widget.ticket != null ? [widget.ticket!] : []);

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
    // Tear down any in-flight snackbar so its animation listener can't
    // fire on a deactivated tree (crashes in findAncestorStateOfType).
    final messenger = ScaffoldMessenger.maybeOf(context);
    messenger?.removeCurrentSnackBar(reason: SnackBarClosedReason.remove);
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
          title: widget.booking?.activity?.title ??
              context.l10n.bookingTicketTitle,
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
    final startDateTime = slot?.startDateTime;
    if (startDateTime != null) {
      final date = context
          .appDateFormat('E d MMM', enPattern: 'EEE, MMM d')
          .format(startDateTime);
      final time = DateFormat('HH:mm').format(startDateTime);
      return '$date • $time';
    }
    return '';
  }

  Future<void> _shareTicket(Ticket ticket) async {
    final activity = widget.booking?.activity;
    String shareText = '${context.l10n.bookingShareTicketTitle}\n';
    if (activity != null) {
      shareText += '\n${activity.title}';
    }
    shareText +=
        '\n\n${context.l10n.bookingShareTicketCode(ticket.qrCodeData ?? ticket.id)}';
    await SharePlus.instance.share(ShareParams(text: shareText));
  }

  Future<void> _downloadTicket(Ticket ticket) async {
    HapticFeedback.lightImpact();
    final l10n = context.l10n;
    final androidDisplayLocation = l10n.bookingAndroidDownloadsLocation;
    final documentsDisplayLocation = l10n.bookingDocumentsTicketsLocation;

    _showInfoSnack(l10n.bookingPreparingPdf);

    try {
      final pdf = await ref
          .read(bookingApiDataSourceProvider)
          .downloadSingleTicket(ticket.id);
      _hideSnack();
      final saved = await shareTicketPdf(
        pdf,
        androidDisplayLocation: androidDisplayLocation,
        documentsDisplayLocation: documentsDisplayLocation,
      );
      if (!mounted) return;
      _showInfoSnack(l10n.bookingTicketSaved(saved.displayLocation));
    } on TicketsNotReadyException {
      if (!mounted) return;
      _showDownloadError(context.l10n.bookingTicketNotReady);
    } on NotAuthorizedToDownloadException {
      if (!mounted) return;
      _showDownloadError(context.l10n.bookingTicketNotDownloadable);
    } catch (_) {
      if (!mounted) return;
      _showDownloadError(context.l10n.bookingDownloadError);
    }
  }

  // Snackbar helpers — re-resolve [ScaffoldMessenger] each call and guard
  // with [mounted] / try-catch. Holding a [ScaffoldMessengerState] across
  // awaits goes stale when the share sheet causes a rebuild and crashes
  // with "Looking up a deactivated widget's ancestor is unsafe".
  void _showInfoSnack(String message) {
    if (!mounted) return;
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: HbColors.brandPrimary,
          duration: const Duration(seconds: 6),
        ),
      );
    } catch (e) {
      debugPrint('🍞 info snack failed: $e');
    }
  }

  void _hideSnack() {
    if (!mounted) return;
    try {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    } catch (_) {}
  }

  void _showDownloadError(String message) {
    _hideSnack();
    if (!mounted) return;
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: HbColors.error,
        ),
      );
    } catch (e) {
      debugPrint('🍞 error snack failed: $e');
    }
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
          title: Text(
            context.l10n.bookingTicketTitle,
            style: const TextStyle(
                color: HbColors.textPrimary, fontWeight: FontWeight.w700),
          ),
        ),
        body: Center(
          child: Text(context.l10n.bookingTicketNotFound),
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
              ? context.l10n
                  .bookingTicketPosition(_currentIndex + 1, _tickets.length)
              : context.l10n.bookingTicketTitle,
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
                context.l10n.bookingTicketSwipeHint,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
            ),
          // Download button — hidden for cancelled tickets (spec §2.4: backend
          // returns 403 for cancelled tickets even to the owner).
          if (_tickets[_currentIndex].status != 'cancelled')
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
                  label: Text(context.l10n.bookingDownloadSingleTicket),
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
    final slotStartDateTime = slot?.startDateTime;
    final slotEndDateTime = slot?.endDateTime;
    final status = TicketStatusExtension.fromString(ticket.status);

    final qrData = ticket.qrCodeData ?? ticket.id;
    final ticketType = ticket.ticketType ?? context.l10n.bookingStandardTicket;
    final participantLabel = context.l10n.bookingParticipantNumber(index + 1);

    // Pull the matching attendee from the booking. Attendees are flattened in
    // the same order tickets are generated in the mapper, so index lines up.
    final attendees = widget.booking?.attendees;
    final attendee = (attendees != null && index < attendees.length)
        ? attendees[index]
        : null;
    final fullName = [
      attendee?.firstName?.trim() ?? ticket.attendeeFirstName?.trim(),
      attendee?.lastName?.trim() ?? ticket.attendeeLastName?.trim(),
    ].where((s) => s != null && s.isNotEmpty).join(' ');
    final email = attendee?.email ?? ticket.attendeeEmail;
    final phone = attendee?.phone;
    final city = attendee?.city;
    final age = attendee?.age;

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
              codeLabel: qrData,
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
                        color: HbColors.brandPrimary.withValues(alpha: 0.15),
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
                            participantLabel,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: HbColors.textPrimary,
                            ),
                          ),
                          if (fullName.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              fullName,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: HbColors.textPrimary,
                              ),
                            ),
                          ],
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: status.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle,
                              size: 14, color: status.color),
                          const SizedBox(width: 4),
                          Text(
                            context.bookingTicketStatusLabel(ticket.status),
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
                // Extra attendee info: email, phone, age, city.
                if ((email != null && email.isNotEmpty) ||
                    (phone != null && phone.isNotEmpty) ||
                    age != null ||
                    (city != null && city.isNotEmpty)) ...[
                  const SizedBox(height: 12),
                  Divider(
                    height: 1,
                    color: Colors.black.withValues(alpha: 0.08),
                  ),
                  const SizedBox(height: 12),
                  if (email != null && email.isNotEmpty)
                    _buildInfoRow(icon: Icons.email_outlined, text: email),
                  if (phone != null && phone.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    _buildInfoRow(icon: Icons.phone_outlined, text: phone),
                  ],
                  if (age != null) ...[
                    const SizedBox(height: 6),
                    _buildInfoRow(
                      icon: Icons.cake_outlined,
                      text: context.l10n.bookingAgeYears(age),
                    ),
                  ],
                  if (city != null && city.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    _buildInfoRow(
                        icon: Icons.location_city_outlined, text: city),
                  ],
                ],
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
                  activity?.title ?? context.l10n.bookingEventFallback,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: HbColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                if (slotStartDateTime != null)
                  _buildInfoRow(
                    icon: Icons.calendar_today_outlined,
                    text: context
                        .appDateFormat(
                          'EEEE d MMMM yyyy',
                          enPattern: 'EEEE, MMMM d, yyyy',
                        )
                        .format(slotStartDateTime),
                  ),
                if (slotStartDateTime != null && slotEndDateTime != null) ...[
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    icon: Icons.access_time,
                    text: '${DateFormat('HH:mm').format(slotStartDateTime)} - '
                        '${DateFormat('HH:mm').format(slotEndDateTime)}',
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
            context.l10n.bookingQrTapFullscreenHint,
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
}
