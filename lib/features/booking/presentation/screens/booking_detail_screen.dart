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

class BookingDetailScreen extends ConsumerStatefulWidget {
  final String bookingId;
  final Booking? initialBooking;

  const BookingDetailScreen({
    super.key,
    required this.bookingId,
    this.initialBooking,
  });

  @override
  ConsumerState<BookingDetailScreen> createState() => _BookingDetailScreenState();
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
    } else {
      // Différer le chargement après le build pour éviter l'erreur Riverpod
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadBookingDetails();
      });
    }
  }

  Future<void> _loadBookingDetails() async {
    debugPrint('📖 BookingDetailScreen: Loading details for bookingId=${widget.bookingId}');

    if (_booking == null) {
      setState(() => _isLoading = true);

      // Charger les bookings si pas encore fait
      final controller = ref.read(bookingsListControllerProvider.notifier);
      final state = ref.read(bookingsListControllerProvider);

      debugPrint('📖 BookingDetailScreen: Current bookings count=${state.allBookings.length}');

      if (state.allBookings.isEmpty) {
        debugPrint('📖 BookingDetailScreen: Loading bookings from API...');
        await controller.loadBookings();
      }

      // Chercher le booking par ID (essayer plusieurs formats)
      final updatedState = ref.read(bookingsListControllerProvider);
      debugPrint('📖 BookingDetailScreen: Searching in ${updatedState.allBookings.length} bookings');

      // Debug: afficher les IDs disponibles
      for (final b in updatedState.allBookings) {
        debugPrint('📖 BookingDetailScreen: Available booking id=${b.id}, numericId=${b.numericId}');
      }

      // Chercher par UUID (id) ou par ID numérique
      final searchId = widget.bookingId;
      final foundBooking = updatedState.allBookings.where(
        (b) => b.id == searchId || b.numericId?.toString() == searchId,
      ).firstOrNull;

      if (foundBooking != null) {
        debugPrint('📖 BookingDetailScreen: Found booking! id=${foundBooking.id}, activity=${foundBooking.activity?.title}');
        _booking = foundBooking;
      } else {
        debugPrint('📖 BookingDetailScreen: Booking NOT FOUND for id=$searchId');
        _notFound = true;
      }

      setState(() => _isLoading = false);
    }

    // Generate mock tickets based on quantity
    _generateMockTickets();
  }

  void _generateMockTickets() {
    final quantity = _booking?.quantity ?? 1;
    _tickets = List.generate(
      quantity,
      (index) => Ticket(
        id: '${_booking?.id}_ticket_$index',
        bookingId: _booking?.id ?? '',
        userId: _booking?.userId ?? '',
        slotId: _booking?.slotId ?? '',
        ticketType: 'Standard',
        qrCodeData: '${_booking?.id}_${index}_${DateTime.now().millisecondsSinceEpoch}',
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
    if (slot?.startDateTime != null) {
      shareText += '\nLe ${_formatDate(slot!.startDateTime!)}';
    }
    shareText += '\n\n${_tickets.length} billet(s)';

    Share.share(shareText);
  }

  String _formatDate(DateTime date) {
    final months = [
      'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
      'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'
    ];
    final weekdays = [
      'lundi', 'mardi', 'mercredi', 'jeudi', 'vendredi', 'samedi', 'dimanche'
    ];

    final weekday = weekdays[date.weekday - 1];
    final day = date.day;
    final month = months[date.month - 1];
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$weekday $day $month $year à $hour:$minute';
  }

  void _showCancelConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Annuler la réservation'),
        content: const Text(
          'Êtes-vous sûr de vouloir annuler cette réservation ? '
          'Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Non, garder'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _cancelBooking();
            },
            style: TextButton.styleFrom(foregroundColor: HbColors.error),
            child: const Text('Oui, annuler'),
          ),
        ],
      ),
    );
  }

  Future<void> _cancelBooking() async {
    final booking = _booking;
    if (booking == null) return;

    // L'API utilise l'UUID (comme pour les favoris)
    final bookingUuid = booking.id;

    debugPrint('🚫 Annulation booking: uuid=$bookingUuid, numericId=${booking.numericId}');

    setState(() => _isLoading = true);

    try {
      final repository = ref.read(bookingRepositoryProvider);
      await repository.cancelBooking(bookingUuid);

      debugPrint('🚫 Annulation réussie');
      HapticFeedback.heavyImpact();

      // Rafraîchir la liste des réservations
      ref.read(bookingsListControllerProvider.notifier).refresh();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Réservation annulée avec succès'),
            backgroundColor: HbColors.error,
          ),
        );
        context.pop();
      }
    } catch (e) {
      debugPrint('🚫 Erreur annulation: $e');
      setState(() => _isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'annulation: $e'),
            backgroundColor: HbColors.error,
          ),
        );
      }
    }
  }

  void _downloadAllTickets() {
    // TODO: Implement PDF download
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Téléchargement des billets...'),
        backgroundColor: HbColors.brandPrimary,
      ),
    );
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
            onPressed: () => context.pop(),
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
            onPressed: () => context.pop(),
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
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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

    final canCancel = booking.status == 'confirmed' || booking.status == 'pending';

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
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: HbColors.textPrimary, size: 20),
              ),
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.share, color: HbColors.textPrimary, size: 20),
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
                SizedBox(height: tokens.spacing.m),
                // Tickets section
                if (_tickets.isNotEmpty)
                  TicketsSection(
                    tickets: _tickets,
                    onTicketTap: (ticket) {
                      final index = _tickets.indexOf(ticket);
                      _navigateToTicket(ticket, index);
                    },
                    onDownloadAll: _downloadAllTickets,
                  ),
                SizedBox(height: tokens.spacing.m),
                // Cancel button (if applicable)
                if (canCancel)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: tokens.spacing.xs),
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
}
