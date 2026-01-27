import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:confetti/confetti.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/features/booking/data/models/booking_api_dto.dart';
import 'package:lehiboo/features/booking/data/datasources/booking_api_datasource.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import 'package:lehiboo/features/events/domain/entities/event_submodels.dart';

/// Écran de succès après une réservation avec confettis
class BookingSuccessScreen extends ConsumerStatefulWidget {
  final String bookingId;
  final CreateBookingResponseDto? bookingResponse;
  final Event? event;
  final CalendarDateSlot? selectedSlot;

  const BookingSuccessScreen({
    super.key,
    required this.bookingId,
    this.bookingResponse,
    this.event,
    this.selectedSlot,
  });

  @override
  ConsumerState<BookingSuccessScreen> createState() => _BookingSuccessScreenState();
}

class _BookingSuccessScreenState extends ConsumerState<BookingSuccessScreen>
    with TickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  List<TicketDetailDto>? _tickets;
  bool _isLoadingTickets = false;
  // ignore: unused_field - Préservé pour usage futur
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    // Confetti controller
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));

    // Scale animation for the success icon
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    // Démarrer les animations
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _confettiController.play();
      _scaleController.forward();
      HapticFeedback.heavyImpact();
    });

    // Charger les tickets
    _loadTickets();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  /// Charge les tickets avec polling (génération asynchrone côté backend)
  Future<void> _loadTickets() async {
    setState(() => _isLoadingTickets = true);

    try {
      final bookingDataSource = ref.read(bookingApiDataSourceProvider);

      // Polling: les tickets sont générés de manière asynchrone
      // Délai progressif: 1s, 1s, 2s, 2s, 3s... pour réduire l'attente initiale
      const maxAttempts = 8;
      final delays = [1, 1, 2, 2, 3, 3, 4, 4];

      for (var attempt = 0; attempt < maxAttempts; attempt++) {
        debugPrint('🎫 Polling tickets attempt ${attempt + 1}/$maxAttempts for booking: ${widget.bookingId}');
        try {
          final tickets = await bookingDataSource.getBookingTickets(
            bookingUuid: widget.bookingId,
          );

          debugPrint('🎫 Polling result: ${tickets.length} tickets');
          if (tickets.isNotEmpty) {
            if (mounted) {
              setState(() {
                _tickets = tickets;
                _isLoadingTickets = false;
              });
            }
            return;
          }
        } catch (e) {
          debugPrint('🎫 Polling error: $e');
          // Ignorer les erreurs pendant le polling
        }

        // Attendre avant la prochaine tentative (délai progressif)
        if (attempt < maxAttempts - 1) {
          await Future.delayed(Duration(seconds: delays[attempt]));
        }
      }

      // Timeout: les tickets ne sont pas encore disponibles
      if (mounted) {
        setState(() {
          _tickets = [];
          _isLoadingTickets = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Impossible de charger les billets';
          _isLoadingTickets = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Contenu principal
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  // Animation de succès
                  _buildSuccessHeader(),

                  const SizedBox(height: 32),

                  // Référence de réservation
                  _buildBookingReference(),

                  const SizedBox(height: 32),

                  // Résumé de l'événement
                  if (widget.event != null) _buildEventSummary(),

                  const SizedBox(height: 24),

                  // Section billets
                  _buildTicketsSection(),

                  const SizedBox(height: 32),

                  // Info email
                  _buildEmailInfo(),

                  const SizedBox(height: 32),

                  // Boutons d'action
                  _buildActionButtons(),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          // Confetti overlay
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              numberOfParticles: 30,
              maxBlastForce: 20,
              minBlastForce: 8,
              emissionFrequency: 0.05,
              gravity: 0.2,
              colors: const [
                HbColors.brandPrimary,
                Colors.blue,
                Colors.green,
                Colors.purple,
                Colors.pink,
                Colors.orange,
                Colors.yellow,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessHeader() {
    return Column(
      children: [
        // Icône de succès avec animation
        ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              size: 64,
              color: Colors.green,
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Réservation confirmée !',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: HbColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Merci pour votre confiance',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildBookingReference() {
    final reference = widget.bookingResponse?.reference ?? 'HB-${widget.bookingId}';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: HbColors.brandPrimary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: HbColors.brandPrimary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.confirmation_number, color: HbColors.brandPrimary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Référence',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  reference,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: HbColors.textPrimary,
                    fontFamily: 'monospace',
                    letterSpacing: 0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.copy, size: 20),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: reference));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Référence copiée')),
              );
            },
            color: HbColors.brandPrimary,
            tooltip: 'Copier',
          ),
        ],
      ),
    );
  }

  Widget _buildEventSummary() {
    final event = widget.event!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: event.images.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: event.images.first,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.event),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: HbColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (widget.selectedSlot != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(widget.selectedSlot!),
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Vos billets',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: HbColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),

        if (_isLoadingTickets)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const CircularProgressIndicator(color: HbColors.brandPrimary),
                  const SizedBox(height: 12),
                  Text(
                    'Génération de vos billets...',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          )
        else if (_tickets != null && _tickets!.isNotEmpty)
          ..._tickets!.map((ticket) => _buildTicketCard(ticket))
        else
          _buildPlaceholderTicket(),
      ],
    );
  }

  Widget _buildTicketCard(TicketDetailDto ticket) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // QR Code
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: QrImageView(
              data: ticket.qrCode,
              version: QrVersions.auto,
              size: 150,
              backgroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 12),

          // Infos billet
          Text(
            ticket.ticketType,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: HbColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            ticket.ticketNumber,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              fontFamily: 'monospace',
            ),
          ),
          if (ticket.attendee != null) ...[
            const SizedBox(height: 4),
            Text(
              ticket.attendee!.name,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPlaceholderTicket() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(Icons.qr_code_2, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            'Vos billets seront disponibles\ndans votre espace "Mes réservations"',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmailInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.email_outlined, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Un email de confirmation avec vos billets vous a été envoyé.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Bouton principal
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => context.go('/my-bookings'),
            icon: const Icon(Icons.receipt_long),
            label: const Text('Voir mes réservations'),
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
        const SizedBox(height: 12),

        // Bouton secondaire
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => context.go('/'),
            icon: const Icon(Icons.home_outlined),
            label: const Text('Retour à l\'accueil'),
            style: OutlinedButton.styleFrom(
              foregroundColor: HbColors.textPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(CalendarDateSlot slot) {
    final months = [
      'Jan', 'Fév', 'Mars', 'Avr', 'Mai', 'Juin',
      'Juil', 'Août', 'Sep', 'Oct', 'Nov', 'Déc'
    ];
    final days = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];

    final dayName = days[slot.date.weekday - 1];
    final monthName = months[slot.date.month - 1];
    var dateStr = '$dayName ${slot.date.day} $monthName';

    if (slot.startTime != null) {
      dateStr += ' à ${slot.startTime}';
    }

    return dateStr;
  }
}
