import 'package:add_2_calendar/add_2_calendar.dart' as cal;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:lehiboo/core/analytics/analytics_event.dart';
// import 'package:lehiboo/core/analytics/analytics_provider.dart';
import 'package:lehiboo/core/l10n/l10n.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/core/themes/hb_theme.dart';
import 'package:lehiboo/core/utils/api_response_handler.dart';
import 'package:lehiboo/domain/entities/booking.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/booking/presentation/controllers/booking_flow_controller.dart';
import 'package:lehiboo/features/booking/presentation/widgets/booking_hero_header.dart';
import 'package:lehiboo/features/booking/presentation/widgets/event_info_card.dart';
import 'package:lehiboo/features/booking/presentation/widgets/booking_detail_summary_card.dart';
import 'package:lehiboo/features/booking/presentation/widgets/ticket_preview_card.dart';
import 'package:lehiboo/features/booking/data/datasources/booking_api_datasource.dart';
import 'package:lehiboo/features/booking/presentation/utils/ticket_download_helper.dart';
import 'package:lehiboo/core/utils/age_utils.dart';
// import 'package:lehiboo/features/memberships/presentation/providers/personalized_feed_provider.dart';

enum _TicketsLoadState {
  idle,
  loading,
  ready,
  generating,
  failure,
}

class BookingDetailScreen extends ConsumerStatefulWidget {
  final String bookingId;
  final Booking? initialBooking;
  final String? initialBookingOwnerAccountId;

  const BookingDetailScreen({
    super.key,
    required this.bookingId,
    this.initialBooking,
    this.initialBookingOwnerAccountId,
  });

  @override
  ConsumerState<BookingDetailScreen> createState() =>
      _BookingDetailScreenState();
}

class _BookingDetailScreenState extends ConsumerState<BookingDetailScreen> {
  Booking? _booking;
  bool _isLoading = true; // Commence en loading
  bool _notFound = false;
  String? _loadError;
  List<Ticket> _tickets = [];
  _TicketsLoadState _ticketsLoadState = _TicketsLoadState.idle;
  String? _ticketsLoadError;
  String? _sessionUserId;
  int _sessionGeneration = 0;
  int _detailRequestGeneration = 0;
  int _ticketRequestGeneration = 0;
  ScaffoldMessengerState? _scaffoldMessenger;

  @override
  void initState() {
    super.initState();
    _sessionUserId = ref.read(authSessionUserIdProvider);
    final ownsInitialBooking = _sessionUserId != null &&
        widget.initialBookingOwnerAccountId == _sessionUserId;
    _booking = ownsInitialBooking ? widget.initialBooking : null;

    ref.listenManual<String?>(authSessionUserIdProvider, (_, next) {
      if (!mounted || next == _sessionUserId) return;

      _sessionUserId = next;
      _sessionGeneration++;
      _detailRequestGeneration++;
      _ticketRequestGeneration++;
      setState(() {
        // Never keep account-scoped booking or ticket data on screen after
        // logout or an account switch.
        _booking = null;
        _tickets = [];
        _ticketsLoadState = _TicketsLoadState.idle;
        _ticketsLoadError = null;
        _notFound = false;
        _loadError = null;
        _isLoading = true;
      });

      // The router normally removes this authenticated route on logout. If a
      // different account becomes active while it remains mounted, reload the
      // booking under that account instead of reusing the old response.
      if (next != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && ref.read(authSessionUserIdProvider) == next) {
            _loadBookingDetails();
          }
        });
      }
    });

    // Si on a déjà le booking, pas besoin de charger
    if (_booking != null) {
      _isLoading = false;
      if (_booking!.status == 'confirmed') {
        _ticketsLoadState = _TicketsLoadState.loading;
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadRealTickets();
      });
    } else if (_sessionUserId != null) {
      // Différer le chargement après le build pour éviter l'erreur Riverpod
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadBookingDetails();
      });
    } else {
      // The router will redirect anonymous users. Until then, never render or
      // request account-scoped booking data supplied through route extras.
      _isLoading = false;
      _notFound = true;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
  }

  @override
  void dispose() {
    // Tear down any in-flight snackbar BEFORE the widget tree is gone so
    // the snackbar's animation status listener doesn't fire on a
    // deactivated tree and crash via findAncestorStateOfType.
    _scaffoldMessenger?.removeCurrentSnackBar(
      reason: SnackBarClosedReason.remove,
    );
    super.dispose();
  }

  Future<void> _loadBookingDetails() async {
    if (!mounted) return;
    if (_sessionUserId == null ||
        ref.read(authSessionUserIdProvider) != _sessionUserId) {
      setState(() {
        _booking = null;
        _tickets = [];
        _isLoading = false;
        _notFound = true;
      });
      return;
    }
    debugPrint(
        '📖 BookingDetailScreen: Loading details for bookingId=${widget.bookingId}');

    if (_booking == null) {
      final requestGeneration = _sessionGeneration;
      final requestSessionUserId = _sessionUserId;
      final requestId = ++_detailRequestGeneration;
      setState(() {
        _isLoading = true;
        _notFound = false;
        _loadError = null;
      });

      try {
        // Detail routes must not depend on the first page of the booking list:
        // the backend exposes this user-scoped endpoint specifically for UUID
        // lookups and returns a real 404 when the booking is absent.
        final foundBooking = await ref
            .read(bookingRepositoryProvider)
            .getBookingById(widget.bookingId);
        if (!_isDetailRequestCurrent(
          requestId,
          requestGeneration,
          requestSessionUserId,
        )) {
          return;
        }

        if (foundBooking != null) {
          debugPrint(
              '📖 BookingDetailScreen: Found booking! id=${foundBooking.id}, activity=${foundBooking.activity?.title}');
          _booking = foundBooking;
        } else {
          debugPrint(
              '📖 BookingDetailScreen: Booking NOT FOUND for id=${widget.bookingId}');
          _notFound = true;
        }
      } catch (error) {
        debugPrint('📖 BookingDetailScreen: Detail load failed: $error');
        if (!_isDetailRequestCurrent(
          requestId,
          requestGeneration,
          requestSessionUserId,
        )) {
          return;
        }
        setState(() {
          _loadError = ApiResponseHandler.extractError(
            error,
            fallback: context.l10n.bookingDetailLoadFallback,
            localizations: context.l10n,
          );
          _isLoading = false;
        });
        return;
      }

      setState(() => _isLoading = false);
    }

    _loadRealTickets();
  }

  bool _isDetailRequestCurrent(
    int requestId,
    int sessionGeneration,
    String? sessionUserId,
  ) {
    return mounted &&
        sessionUserId != null &&
        requestId == _detailRequestGeneration &&
        sessionGeneration == _sessionGeneration &&
        sessionUserId == _sessionUserId &&
        sessionUserId == ref.read(authSessionUserIdProvider);
  }

  bool _isSessionCurrent(int sessionGeneration, String? sessionUserId) {
    return mounted &&
        sessionUserId != null &&
        sessionGeneration == _sessionGeneration &&
        sessionUserId == _sessionUserId &&
        sessionUserId == ref.read(authSessionUserIdProvider);
  }

  bool _isTicketRequestCurrent(
    int requestId,
    int sessionGeneration,
    String? sessionUserId,
  ) {
    return mounted &&
        sessionUserId != null &&
        requestId == _ticketRequestGeneration &&
        sessionGeneration == _sessionGeneration &&
        sessionUserId == _sessionUserId &&
        sessionUserId == ref.read(authSessionUserIdProvider);
  }

  /// Fetch tickets from the authoritative booking-ticket endpoint. Booking
  /// attendees are used only to enrich labels; they never create ticket IDs,
  /// statuses, or QR payloads on the client.
  Future<void> _loadRealTickets() async {
    if (!mounted) return;
    if (_sessionUserId == null ||
        ref.read(authSessionUserIdProvider) != _sessionUserId) {
      return;
    }
    final booking = _booking;
    if (booking == null) return;
    if (booking.status != 'confirmed') {
      setState(() {
        _tickets = [];
        _ticketsLoadState = _TicketsLoadState.idle;
        _ticketsLoadError = null;
      });
      return;
    }

    final requestGeneration = _sessionGeneration;
    final requestSessionUserId = _sessionUserId;
    final requestId = ++_ticketRequestGeneration;
    final l10n = context.l10n;
    setState(() {
      _tickets = [];
      _ticketsLoadState = _TicketsLoadState.loading;
      _ticketsLoadError = null;
    });

    try {
      final dtos = await ref
          .read(bookingApiDataSourceProvider)
          .getBookingTickets(bookingUuid: booking.id);
      if (!_isTicketRequestCurrent(
        requestId,
        requestGeneration,
        requestSessionUserId,
      )) {
        return;
      }

      if (dtos.isEmpty) {
        setState(() {
          _tickets = [];
          _ticketsLoadState = _TicketsLoadState.generating;
        });
        return;
      }

      final attendees = booking.attendees;
      final merged = List<Ticket>.generate(dtos.length, (index) {
        final dto = dtos[index];
        final attendee = (attendees != null && index < attendees.length)
            ? attendees[index]
            : null;
        final dtoUuid = dto.uuid?.trim();
        return Ticket(
          id: dtoUuid != null && dtoUuid.isNotEmpty ? dtoUuid : dto.id,
          bookingId: booking.id,
          userId: booking.userId,
          slotId: booking.slotId,
          ticketType: attendee?.ticketTypeName,
          qrCodeData: dto.qrCode,
          status: dto.status,
          attendeeFirstName: dto.attendeeFirstName ?? attendee?.firstName,
          attendeeLastName: dto.attendeeLastName ?? attendee?.lastName,
          attendeeEmail: dto.attendeeEmail ?? attendee?.email,
          price: dto.price,
        );
      });

      setState(() {
        _tickets = merged;
        _ticketsLoadState = _TicketsLoadState.ready;
      });
    } on TicketsNotReadyException {
      if (!_isTicketRequestCurrent(
        requestId,
        requestGeneration,
        requestSessionUserId,
      )) {
        return;
      }
      setState(() {
        _tickets = [];
        _ticketsLoadState = _TicketsLoadState.generating;
      });
    } catch (error) {
      debugPrint('🎫 _loadRealTickets failed: $error');
      if (!_isTicketRequestCurrent(
        requestId,
        requestGeneration,
        requestSessionUserId,
      )) {
        return;
      }
      setState(() {
        _tickets = [];
        _ticketsLoadState = _TicketsLoadState.failure;
        _ticketsLoadError = ApiResponseHandler.extractError(
          error,
          fallback: l10n.bookingTicketsLoadError,
          localizations: l10n,
        );
      });
    }
  }

  Future<void> _shareBooking() async {
    final sessionGeneration = _sessionGeneration;
    final sessionUserId = _sessionUserId;
    if (!_isSessionCurrent(sessionGeneration, sessionUserId)) return;
    final booking = _booking;
    if (booking == null) return;

    final activity = booking.activity;
    final slot = booking.slot;

    String shareText = '${context.l10n.bookingShareBookingTitle}\n';
    if (activity != null) {
      shareText += '\n${activity.title}';
    }
    final slotStart = slot?.startDateTime;
    if (slotStart != null) {
      shareText += '\n${_formatDate(slotStart)}';
    }
    final bookedTicketCount = booking.quantity ?? _tickets.length;
    shareText +=
        '\n\n${context.l10n.bookingShareTicketsCount(bookedTicketCount)}';
    final shareFailedMessage = context.l10n.commonShareFailed;

    try {
      if (!_isSessionCurrent(sessionGeneration, sessionUserId)) return;
      await SharePlus.instance.share(ShareParams(text: shareText));
    } catch (_) {
      if (!mounted || !_isSessionCurrent(sessionGeneration, sessionUserId)) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(shareFailedMessage)),
      );
    }
  }

  /// Hands off to the system calendar's "create event" flow with the booking
  /// pre-filled. Uses [add_2_calendar] which dispatches a native intent —
  /// no calendar permissions required, the user manually saves the entry
  /// from the calendar app.
  Future<void> _addToCalendar() async {
    final sessionGeneration = _sessionGeneration;
    final sessionUserId = _sessionUserId;
    if (!_isSessionCurrent(sessionGeneration, sessionUserId)) return;
    final booking = _booking;
    final activity = booking?.activity;
    final slot = booking?.slot;
    if (booking == null || activity == null || slot == null) return;

    // Build a sensible end time. Most slots have endDateTime set; fall back
    // to a 2-hour window if the API didn't send one (or sent the same value
    // for both, which we treat as "unknown duration").
    final start = slot.startDateTime;
    DateTime end = slot.endDateTime;
    if (!end.isAfter(start)) {
      end = start.add(const Duration(hours: 2));
    }

    final location = [
      activity.city?.name,
    ].whereType<String>().where((s) => s.isNotEmpty).join(', ');

    final reference = booking.id.length > 8
        ? booking.id.substring(0, 8).toUpperCase()
        : booking.id.toUpperCase();
    final descriptionParts = <String>[
      if (activity.excerpt != null && activity.excerpt!.isNotEmpty)
        activity.excerpt!
      else if (activity.description.isNotEmpty)
        activity.description,
      context.l10n.bookingCalendarReference(reference),
    ];
    final calendarAddedMessage = context.l10n.bookingCalendarAdded;
    final calendarFailedMessage = context.l10n.bookingCalendarAddFailed;

    final event = cal.Event(
      title: activity.title,
      description: descriptionParts.join('\n\n'),
      location: location.isEmpty ? null : location,
      startDate: start,
      endDate: end,
      iosParams: const cal.IOSParams(reminder: Duration(hours: 1)),
      androidParams: const cal.AndroidParams(emailInvites: []),
    );

    try {
      if (!_isSessionCurrent(sessionGeneration, sessionUserId)) return;
      final added = await cal.Add2Calendar.addEvent2Cal(event);
      if (!mounted || !_isSessionCurrent(sessionGeneration, sessionUserId)) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            added ? calendarAddedMessage : calendarFailedMessage,
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (_) {
      if (!mounted || !_isSessionCurrent(sessionGeneration, sessionUserId)) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(calendarFailedMessage),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  String _formatDate(DateTime date) {
    return context
        .appDateFormat(
          "EEEE d MMMM yyyy 'à' HH:mm",
          enPattern: 'EEEE, MMMM d, yyyy HH:mm',
        )
        .format(date);
  }

  /*
  Future<void> _showCancelConfirmation() async {
    final reasonController = TextEditingController();
    final deadline = _booking?.cancellation?.deadlineFormatted;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.bookingCancelDialogTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.bookingCancelDialogBody),
            if (deadline != null) ...[
              const SizedBox(height: 8),
              Text(
                context.l10n.bookingCancelDeadline(deadline),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              maxLength: 1000,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: context.l10n.bookingCancelReasonLabel,
                hintText: context.l10n.bookingCancelReasonHint,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              context.l10n.bookingCancelWarning,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: HbColors.error,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.bookingCancelKeep),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: HbColors.error),
            child: Text(context.l10n.bookingCancelConfirm),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _cancelBooking(reason: reasonController.text.trim());
    }
    reasonController.dispose();
  }

  Future<void> _cancelBooking({String? reason}) async {
    final booking = _booking;
    if (booking == null) return;

    final bookingUuid = booking.id;
    debugPrint(
        '🚫 Annulation booking: uuid=$bookingUuid reason=${reason?.isNotEmpty == true ? "<${reason!.length} chars>" : "<empty>"}');

    setState(() => _isLoading = true);

    try {
      final repository = ref.read(bookingRepositoryProvider);
      final updated =
          await repository.cancelBooking(bookingUuid, reason: reason);

      debugPrint('🚫 Annulation réussie, status=${updated.status}');
      HapticFeedback.heavyImpact();

      // refund (standard GA4) — pair avec le `purchase` initial via le même
      // transaction_id = booking.id. Alimente les rapports Monetization.
      ref.read(analyticsServiceProvider).logEvent(
        AnalyticsEvent.refund,
        params: {
          AnalyticsParam.transactionId: bookingUuid,
          AnalyticsParam.value: updated.totalPrice ?? booking.totalPrice ?? 0,
          AnalyticsParam.currency: 'EUR',
        },
      );

      // Spec §3.6: replace local booking with the response — no re-fetch.
      // Refresh the list so the home/bookings tab reflects the new status.
      ref.read(bookingsListControllerProvider.notifier).refresh();
      // Booking signal changed — drop the personalized feed (spec §7).
      ref.invalidate(personalizedFeedProvider);

      if (!mounted) return;
      setState(() {
        _booking = updated;
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.bookingCancelSuccess),
          backgroundColor: HbColors.error,
          duration: const Duration(seconds: 4),
        ),
      );
    } on BookingCancellationForbiddenException {
      // Spec §4: deadline likely passed — re-fetch booking detail so the
      // button visibility updates and the user sees the right state.
      debugPrint('🚫 403 Forbidden — refreshing booking');
      ref.read(bookingsListControllerProvider.notifier).refresh();
      if (!mounted) return;
      _showCancelError(context.l10n.bookingCancelForbidden);
    } on BookingCancellationNotFoundException {
      if (!mounted) return;
      _showCancelError(context.l10n.bookingCancelNotFound);
    } on BookingCancellationValidationException {
      if (!mounted) return;
      _showCancelError(context.l10n.bookingCancelValidationTooLong);
    } catch (e) {
      debugPrint('🚫 Erreur annulation: $e');
      if (!mounted) return;
      _showCancelError(
        ApiResponseHandler.extractError(
          e,
          fallback: context.l10n.bookingCancelGenericError,
        ),
      );
    }
  }

  void _showCancelError(String message) {
    if (!mounted) return;
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: HbColors.error,
      ),
    );
  }
  */

  Future<void> _downloadAllTickets() async {
    final sessionGeneration = _sessionGeneration;
    final sessionUserId = _sessionUserId;
    if (!_isSessionCurrent(sessionGeneration, sessionUserId)) return;
    final booking = _booking;
    if (booking == null) return;
    HapticFeedback.lightImpact();
    final l10n = context.l10n;
    final androidDisplayLocation = l10n.bookingAndroidDownloadsLocation;
    final documentsDisplayLocation = l10n.bookingDocumentsTicketsLocation;

    _showInfoSnack(l10n.bookingPreparingPdf);

    try {
      final pdf = await ref
          .read(bookingApiDataSourceProvider)
          .downloadBookingTicketsBundle(booking.id);
      if (!_isSessionCurrent(sessionGeneration, sessionUserId)) return;
      _hideSnack();
      final saved = await shareTicketPdf(
        pdf,
        androidDisplayLocation: androidDisplayLocation,
        documentsDisplayLocation: documentsDisplayLocation,
      );
      if (!_isSessionCurrent(sessionGeneration, sessionUserId)) return;
      _showInfoSnack(l10n.bookingTicketsSaved(saved.displayLocation));
    } on TicketsNotReadyException {
      if (!_isSessionCurrent(sessionGeneration, sessionUserId)) return;
      _showDownloadError(l10n.bookingTicketsNotReady);
    } on NotAuthorizedToDownloadException {
      if (!_isSessionCurrent(sessionGeneration, sessionUserId)) return;
      _showDownloadError(l10n.bookingTicketsNotAuthorized);
    } catch (_) {
      if (!_isSessionCurrent(sessionGeneration, sessionUserId)) return;
      _showDownloadError(l10n.bookingDownloadError);
    }
  }

  /// Snackbar helpers that re-resolve [ScaffoldMessenger] each call and
  /// guard with [mounted] / try-catch. Holding a [ScaffoldMessengerState]
  /// across awaits goes stale when the share sheet causes a rebuild and
  /// crashes with "Looking up a deactivated widget's ancestor is unsafe".
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
    } catch (_) {
      // Tree mutated mid-flight; safe to ignore.
    }
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

  void _navigateToTicket(Ticket ticket, int index) {
    if (!_isSessionCurrent(_sessionGeneration, _sessionUserId)) return;
    context.push(
      '/ticket/${ticket.id}',
      extra: {
        'ownerAccountId': _sessionUserId,
        'ticket': ticket,
        'tickets': _tickets,
        'initialIndex': index,
        'booking': _booking,
      },
    );
  }

  void _goBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/my-bookings');
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = HbTheme.tokens(context);
    final booking = _booking;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: HbColors.textPrimary),
            onPressed: _goBack,
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(color: HbColors.brandPrimary),
        ),
      );
    }

    if (_loadError != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            context.l10n.bookingReservationFallback,
            style: const TextStyle(color: HbColors.textPrimary),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: HbColors.textPrimary),
            onPressed: _goBack,
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cloud_off_outlined,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  context.l10n.bookingLoadError(_loadError!),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: HbColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _loadBookingDetails,
                  icon: const Icon(Icons.refresh),
                  label: Text(context.l10n.commonRetry),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HbColors.brandPrimary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_notFound || booking == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            context.l10n.bookingReservationFallback,
            style: const TextStyle(color: HbColors.textPrimary),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: HbColors.textPrimary),
            onPressed: _goBack,
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  context.l10n.bookingNotFoundTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: HbColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  context.l10n.bookingNotFoundBody,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.go('/my-bookings'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HbColors.brandPrimary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(context.l10n.bookingViewMyBookings),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final activity = booking.activity;
    final slot = booking.slot;
    final reference = booking.id.length > 8
        ? booking.id.substring(0, 8).toUpperCase()
        : booking.id.toUpperCase();

    /*
    // Per spec §4: drive the cancel button purely from cancellation.canCancel
    // (which the backend computes from status, event.allow_cancellation, and
    // the deadline). Falls back to status-only when the API didn't include
    // the cancellation block — old/cached bookings.
    final canCancel = booking.cancellation?.canCancel ??
        (booking.status == 'confirmed' || booking.status == 'pending');
    */

    return Scaffold(
      backgroundColor: HbColors.orangePastel,
      body: CustomScrollView(
        slivers: [
          // App bar with hero image
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back,
                    color: HbColors.textPrimary, size: 20),
              ),
              onPressed: _goBack,
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.share,
                      color: HbColors.textPrimary, size: 20),
                ),
                onPressed: _shareBooking,
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: BookingHeroHeader(
                imageUrl: activity?.imageUrl,
                status: booking.status ?? 'pending',
                reference: reference,
              ),
            ),
          ),
          // Content
          SliverPadding(
            padding: EdgeInsets.all(tokens.spacing.m),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Event info card
                if (activity != null)
                  EventInfoCard(
                    activity: activity,
                    slotDateTime: slot?.startDateTime,
                    endDateTime: slot?.endDateTime,
                  ),
                SizedBox(height: tokens.spacing.m),
                // Summary card
                BookingDetailSummaryCard.fromBooking(booking),
                // Customer additional info (age / town)
                if (booking.customerBirthDate != null ||
                    booking.customerTown != null) ...[
                  SizedBox(height: tokens.spacing.m),
                  _buildCustomerInfoCard(booking),
                ],
                SizedBox(height: tokens.spacing.m),
                // Ticket cards are rendered only after the authoritative
                // endpoint has returned real ticket UUIDs and QR payloads.
                if (_booking?.status == 'confirmed') _buildTicketsContent(),
                SizedBox(height: tokens.spacing.m),
                // Add to calendar button — only when we have a slot date.
                if (_booking != null && _booking!.slot?.startDateTime != null)
                  Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: tokens.spacing.xs),
                    child: OutlinedButton.icon(
                      onPressed: _addToCalendar,
                      icon:
                          const Icon(Icons.event_available_outlined, size: 18),
                      label: Text(context.l10n.bookingAddToCalendar),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: tokens.spacing.xs),
                // Contact organizer button
                if (_booking != null)
                  Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: tokens.spacing.xs),
                    child: OutlinedButton.icon(
                      onPressed: () => context.push(
                        '/messages/new/from-booking/${_booking!.id}',
                      ),
                      icon: const Icon(Icons.chat_bubble_outline, size: 18),
                      label: Text(context.l10n.bookingContactOrganizer),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: tokens.spacing.xs),
                /*
                // Cancel button (if applicable)
                if (canCancel)
                  Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: tokens.spacing.xs),
                    child: OutlinedButton.icon(
                      onPressed: _showCancelConfirmation,
                      icon: const Icon(Icons.cancel_outlined, size: 18),
                      label: Text(context.l10n.bookingCancelDialogTitle),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: HbColors.error,
                        side: const BorderSide(color: HbColors.error),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                */
                // Bottom spacing for safe area
                SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerInfoCard(Booking booking) {
    final age = computeAge(booking.customerBirthDate);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.bookingAdditionalInfoTitle,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: HbColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          if (age != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(Icons.person_outline,
                      size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 8),
                  Text(
                    context.l10n.bookingAgeYears(age),
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
          if (booking.customerTown != null)
            Row(
              children: [
                Icon(Icons.location_on_outlined,
                    size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 8),
                Text(
                  booking.customerTown!,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildTicketsContent() {
    if (_ticketsLoadState == _TicketsLoadState.ready && _tickets.isNotEmpty) {
      return TicketsSection(
        tickets: _tickets,
        onTicketTap: (ticket) {
          final index = _tickets.indexOf(ticket);
          _navigateToTicket(ticket, index);
        },
        onDownloadAll: _downloadAllTickets,
      );
    }

    final isLoading = _ticketsLoadState == _TicketsLoadState.loading;
    final isGenerating = _ticketsLoadState == _TicketsLoadState.generating ||
        _ticketsLoadState == _TicketsLoadState.idle;
    final message = isLoading
        ? context.l10n.bookingTicketsGenerating
        : isGenerating
            ? context.l10n.bookingTicketsNotReady
            : (_ticketsLoadError ?? context.l10n.bookingTicketsLoadError);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.bookingYourTickets,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: HbColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isLoading)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: HbColors.brandPrimary,
                  ),
                )
              else
                Icon(
                  isGenerating
                      ? Icons.hourglass_empty_rounded
                      : Icons.cloud_off_outlined,
                  size: 20,
                  color: isGenerating ? HbColors.brandPrimary : HbColors.error,
                ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    fontSize: 14,
                    color: HbColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          if (!isLoading) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                key: const Key('booking-tickets-retry'),
                onPressed: _loadRealTickets,
                icon: const Icon(Icons.refresh, size: 18),
                label: Text(context.l10n.commonRetry),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
