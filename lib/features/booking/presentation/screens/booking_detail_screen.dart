import 'package:add_2_calendar/add_2_calendar.dart' as cal;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/core/themes/hb_theme.dart';
import 'package:lehiboo/domain/entities/booking.dart';
import 'package:lehiboo/features/booking/presentation/controllers/booking_flow_controller.dart';
import 'package:lehiboo/features/booking/presentation/controllers/booking_list_controller.dart';
import 'package:lehiboo/features/booking/presentation/widgets/booking_hero_header.dart';
import 'package:lehiboo/features/booking/presentation/widgets/event_info_card.dart';
import 'package:lehiboo/features/booking/presentation/widgets/booking_detail_summary_card.dart';
import 'package:lehiboo/features/booking/presentation/widgets/ticket_preview_card.dart';
import 'package:lehiboo/features/booking/data/datasources/booking_api_datasource.dart';
import 'package:lehiboo/features/booking/presentation/utils/ticket_download_helper.dart';
import 'package:lehiboo/core/utils/age_utils.dart';
import 'package:lehiboo/features/memberships/presentation/providers/personalized_feed_provider.dart';

class BookingDetailScreen extends ConsumerStatefulWidget {
  final String bookingId;
  final Booking? initialBooking;

  const BookingDetailScreen({
    super.key,
    required this.bookingId,
    this.initialBooking,
  });

  @override
  ConsumerState<BookingDetailScreen> createState() =>
      _BookingDetailScreenState();
}

class _BookingDetailScreenState extends ConsumerState<BookingDetailScreen> {
  Booking? _booking;
  bool _isLoading = true; // Commence en loading
  bool _notFound = false;
  List<Ticket> _tickets = [];

  @override
  void initState() {
    super.initState();
    _booking = widget.initialBooking;

    // Si on a déjà le booking, pas besoin de charger
    if (_booking != null) {
      _isLoading = false;
      _generateMockTickets();
      // Fetch real tickets (with proper UUIDs) so the per-ticket download
      // button can hit /me/tickets/{uuid}/download.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadRealTickets();
      });
    } else {
      // Différer le chargement après le build pour éviter l'erreur Riverpod
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadBookingDetails();
      });
    }
  }

  @override
  void dispose() {
    // Tear down any in-flight snackbar BEFORE the widget tree is gone so
    // the snackbar's animation status listener doesn't fire on a
    // deactivated tree and crash via findAncestorStateOfType.
    final messenger = ScaffoldMessenger.maybeOf(context);
    messenger?.removeCurrentSnackBar(reason: SnackBarClosedReason.remove);
    super.dispose();
  }

  Future<void> _loadBookingDetails() async {
    debugPrint(
        '📖 BookingDetailScreen: Loading details for bookingId=${widget.bookingId}');

    if (_booking == null) {
      setState(() => _isLoading = true);

      // Charger les bookings si pas encore fait
      final controller = ref.read(bookingsListControllerProvider.notifier);
      final state = ref.read(bookingsListControllerProvider);

      debugPrint(
          '📖 BookingDetailScreen: Current bookings count=${state.allBookings.length}');

      if (state.allBookings.isEmpty) {
        debugPrint('📖 BookingDetailScreen: Loading bookings from API...');
        await controller.loadBookings();
      }

      // Chercher le booking par ID (essayer plusieurs formats)
      final updatedState = ref.read(bookingsListControllerProvider);
      debugPrint(
          '📖 BookingDetailScreen: Searching in ${updatedState.allBookings.length} bookings');

      // Debug: afficher les IDs disponibles
      for (final b in updatedState.allBookings) {
        debugPrint(
            '📖 BookingDetailScreen: Available booking id=${b.id}, numericId=${b.numericId}');
      }

      // Chercher par UUID (id) ou par ID numérique
      final searchId = widget.bookingId;
      final foundBooking = updatedState.allBookings
          .where(
            (b) => b.id == searchId || b.numericId?.toString() == searchId,
          )
          .firstOrNull;

      if (foundBooking != null) {
        debugPrint(
            '📖 BookingDetailScreen: Found booking! id=${foundBooking.id}, activity=${foundBooking.activity?.title}');
        _booking = foundBooking;
      } else {
        debugPrint(
            '📖 BookingDetailScreen: Booking NOT FOUND for id=$searchId');
        _notFound = true;
      }

      setState(() => _isLoading = false);
    }

    // Generate mock tickets based on quantity
    _generateMockTickets();
    // Then upgrade to real tickets (with backend UUIDs) for per-ticket
    // downloads.
    _loadRealTickets();
  }

  /// Fetch real tickets from `/bookings/{uuid}/tickets`, merge with the
  /// attendee data already on the booking, and replace [_tickets] so the
  /// per-ticket download button has a real UUID to hit.
  Future<void> _loadRealTickets() async {
    final booking = _booking;
    if (booking == null) return;
    try {
      final dtos = await ref
          .read(bookingApiDataSourceProvider)
          .getBookingTickets(bookingUuid: booking.id);
      if (!mounted || dtos.isEmpty) return;

      // BookingTicketDto.id is a UUID string — use it directly for the
      // per-ticket /me/tickets/{uuid}/download endpoint. Look up the ticket
      // type name from Booking.attendees[index] (populated from
      // items[].ticketTypeName in the mapper) so the preview card can show
      // "Standard Entry" / "VIP" instead of a generic label.
      final attendees = booking.attendees;
      final merged = List<Ticket>.generate(dtos.length, (index) {
        final dto = dtos[index];
        final attendee = (attendees != null && index < attendees.length)
            ? attendees[index]
            : null;
        return Ticket(
          id: dto.id,
          bookingId: booking.id,
          userId: booking.userId,
          slotId: booking.slotId,
          ticketType: attendee?.ticketTypeName ?? 'Standard',
          qrCodeData: dto.qrCode,
          status: dto.status,
          attendeeFirstName: dto.attendeeFirstName ?? attendee?.firstName,
          attendeeLastName: dto.attendeeLastName ?? attendee?.lastName,
          attendeeEmail: dto.attendeeEmail ?? attendee?.email,
        );
      });

      setState(() {
        _tickets = merged;
      });
    } catch (e) {
      debugPrint('🎫 _loadRealTickets failed (keeping mock tickets): $e');
    }
  }

  void _generateMockTickets() {
    final realTickets = _booking?.tickets;
    if (realTickets != null && realTickets.isNotEmpty) {
      // Use the real tickets built from items[].attendee_details[] in the
      // mapper. They already carry attendeeFirstName / LastName / Email.
      _tickets = realTickets;
      setState(() {});
      return;
    }

    final quantity = _booking?.quantity ?? 1;
    _tickets = List.generate(
      quantity,
      (index) => Ticket(
        id: '${_booking?.id}_ticket_$index',
        bookingId: _booking?.id ?? '',
        userId: _booking?.userId ?? '',
        slotId: _booking?.slotId ?? '',
        ticketType: 'Standard',
        qrCodeData:
            '${_booking?.id}_${index}_${DateTime.now().millisecondsSinceEpoch}',
        status: 'active',
      ),
    );
    setState(() {});
  }

  void _shareBooking() {
    final booking = _booking;
    if (booking == null) return;

    final activity = booking.activity;
    final slot = booking.slot;

    String shareText = 'Ma réservation Le Hiboo\n';
    if (activity != null) {
      shareText += '\n${activity.title}';
    }
    final slotStart = slot?.startDateTime;
    if (slotStart != null) {
      shareText += '\nLe ${_formatDate(slotStart)}';
    }
    shareText += '\n\n${_tickets.length} billet(s)';

    Share.share(shareText);
  }

  /// Hands off to the system calendar's "create event" flow with the booking
  /// pre-filled. Uses [add_2_calendar] which dispatches a native intent —
  /// no calendar permissions required, the user manually saves the entry
  /// from the calendar app.
  Future<void> _addToCalendar() async {
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
      'Réservation Le Hiboo : $reference',
    ];

    final event = cal.Event(
      title: activity.title,
      description: descriptionParts.join('\n\n'),
      location: location.isEmpty ? null : location,
      startDate: start,
      endDate: end,
      iosParams: const cal.IOSParams(reminder: Duration(hours: 1)),
      androidParams: const cal.AndroidParams(emailInvites: []),
    );

    final added = await cal.Add2Calendar.addEvent2Cal(event);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          added
              ? 'Événement ajouté au calendrier'
              : "Impossible d'ajouter au calendrier",
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'janvier',
      'février',
      'mars',
      'avril',
      'mai',
      'juin',
      'juillet',
      'août',
      'septembre',
      'octobre',
      'novembre',
      'décembre'
    ];
    final weekdays = [
      'lundi',
      'mardi',
      'mercredi',
      'jeudi',
      'vendredi',
      'samedi',
      'dimanche'
    ];

    final weekday = weekdays[date.weekday - 1];
    final day = date.day;
    final month = months[date.month - 1];
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$weekday $day $month $year à $hour:$minute';
  }

  Future<void> _showCancelConfirmation() async {
    final reasonController = TextEditingController();
    final deadline = _booking?.cancellation?.deadlineFormatted;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Annuler la réservation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Êtes-vous sûr de vouloir annuler cette réservation ? '
              'Cette action est irréversible.',
            ),
            if (deadline != null) ...[
              const SizedBox(height: 8),
              Text(
                'Date limite : $deadline',
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
              decoration: const InputDecoration(
                labelText: 'Raison (optionnel)',
                hintText: 'Empêchement personnel…',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Attention : aucun remboursement ne sera effectué après l'annulation.",
              style: TextStyle(
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
            child: const Text('Non, garder'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: HbColors.error),
            child: const Text('Oui, annuler'),
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
        const SnackBar(
          content: Text(
              'Réservation annulée. Aucun remboursement ne sera effectué.'),
          backgroundColor: HbColors.error,
          duration: Duration(seconds: 4),
        ),
      );
    } on BookingCancellationForbiddenException {
      // Spec §4: deadline likely passed — re-fetch booking detail so the
      // button visibility updates and the user sees the right state.
      debugPrint('🚫 403 Forbidden — refreshing booking');
      ref.read(bookingsListControllerProvider.notifier).refresh();
      _showCancelError(
        "L'annulation n'est plus possible "
        "(délai dépassé ou non autorisé par l'organisateur).",
      );
    } on BookingCancellationNotFoundException {
      _showCancelError('Cette réservation est introuvable.');
    } on BookingCancellationValidationException {
      _showCancelError(
          'La raison saisie est trop longue (1000 caractères max).');
    } catch (e) {
      debugPrint('🚫 Erreur annulation: $e');
      _showCancelError("Impossible d'annuler la réservation. Réessayez.");
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

  Future<void> _downloadAllTickets() async {
    if (_booking == null) return;
    HapticFeedback.lightImpact();

    _showInfoSnack('Préparation du PDF…');

    try {
      final pdf = await ref
          .read(bookingApiDataSourceProvider)
          .downloadBookingTicketsBundle(_booking!.id);
      _hideSnack();
      final saved = await shareTicketPdf(pdf);
      _showInfoSnack('Billets enregistrés dans ${saved.displayLocation}');
    } on TicketsNotReadyException {
      _showDownloadError(
        'Vos billets sont en cours de génération, réessayez dans un instant.',
      );
    } on NotAuthorizedToDownloadException {
      _showDownloadError(
        "Vous n'êtes pas autorisé à télécharger ces billets.",
      );
    } catch (_) {
      _showDownloadError('Téléchargement impossible. Réessayez plus tard.');
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
    context.push(
      '/ticket/${ticket.id}',
      extra: {
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

    if (_notFound || booking == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Réservation',
            style: TextStyle(color: HbColors.textPrimary),
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
                const Text(
                  'Réservation introuvable',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: HbColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Cette réservation n\'existe pas ou a été supprimée.',
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
                  child: const Text('Voir mes réservations'),
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

    // Per spec §4: drive the cancel button purely from cancellation.canCancel
    // (which the backend computes from status, event.allow_cancellation, and
    // the deadline). Falls back to status-only when the API didn't include
    // the cancellation block — old/cached bookings.
    final canCancel = booking.cancellation?.canCancel ??
        (booking.status == 'confirmed' || booking.status == 'pending');

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
                // Tickets section — only for confirmed bookings with generated
                // tickets (spec §4). Hidden for pending/cancelled to avoid the
                // bundle endpoint returning 404/403 from the download button.
                if (_tickets.isNotEmpty && _booking?.status == 'confirmed')
                  TicketsSection(
                    tickets: _tickets,
                    onTicketTap: (ticket) {
                      final index = _tickets.indexOf(ticket);
                      _navigateToTicket(ticket, index);
                    },
                    onDownloadAll: _downloadAllTickets,
                  ),
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
                      label: const Text('Ajouter au calendrier'),
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
                      label: const Text("Contacter l'organisateur"),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: tokens.spacing.xs),
                // Cancel button (if applicable)
                if (canCancel)
                  Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: tokens.spacing.xs),
                    child: OutlinedButton.icon(
                      onPressed: _showCancelConfirmation,
                      icon: const Icon(Icons.cancel_outlined, size: 18),
                      label: const Text('Annuler la réservation'),
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
          const Text(
            'Informations complémentaires',
            style: TextStyle(
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
                    '$age ans',
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
}
