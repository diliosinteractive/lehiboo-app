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
  late Booking? _booking;
  bool _isLoading = false;
  List<Ticket> _tickets = [];

  @override
  void initState() {
    super.initState();
    _booking = widget.initialBooking;
    _loadBookingDetails();
  }

  Future<void> _loadBookingDetails() async {
    if (_booking == null) {
      setState(() => _isLoading = true);
      // TODO: Load booking from repository by ID
      // For now we'll use the initial booking if provided
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

    if (_isLoading || booking == null) {
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
