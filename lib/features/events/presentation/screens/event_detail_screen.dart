import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/features/favorites/presentation/widgets/favorite_button.dart';
import '../../domain/entities/event.dart';
import '../../domain/entities/event_submodels.dart';
import '../../domain/repositories/event_repository.dart';
import '../../data/datasources/events_api_datasource.dart';
import '../../data/models/event_availability_dto.dart';
import '../widgets/detail/event_gallery_grid.dart';
import '../widgets/detail/event_gallery_fullscreen.dart';
import '../widgets/detail/event_compact_header.dart';
import '../widgets/detail/event_date_selector.dart';
import '../widgets/detail/event_ticket_card.dart';
import '../widgets/detail/event_practical_info.dart';
import '../widgets/detail/event_reviews_section.dart';
import '../widgets/detail/event_qa_section.dart';
import '../widgets/detail/event_sticky_booking_bar.dart';

/// Provider to fetch event details by identifier (UUID or slug)
final eventDetailProvider = FutureProvider.family<Event, String>((ref, identifier) async {
  final repository = ref.watch(eventRepositoryProvider);
  return repository.getEvent(identifier);
});

/// Provider to fetch event availability (slots & tickets)
final eventAvailabilityProvider = FutureProvider.family<EventAvailabilityResponseDto, String>((ref, eventId) async {
  final dataSource = ref.watch(eventsApiDataSourceProvider);
  return dataSource.getEventAvailability(eventId);
});

class EventDetailScreen extends ConsumerStatefulWidget {
  final String eventId;

  const EventDetailScreen({super.key, required this.eventId});

  @override
  ConsumerState<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends ConsumerState<EventDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, int> _ticketQuantities = {};
  String? _selectedSlotId;
  bool _isDescriptionExpanded = false;

  static const int _maxDescriptionLength = 250;

  double get _totalPrice {
    final event = ref.read(eventDetailProvider(widget.eventId)).valueOrNull;
    if (event == null) return 0.0;

    double total = 0.0;
    _ticketQuantities.forEach((ticketId, qty) {
      final ticket = event.tickets.firstWhere(
        (t) => t.id == ticketId,
        orElse: () => const Ticket(id: '', name: '', price: 0),
      );
      if (ticket.id.isNotEmpty) {
        total += ticket.price * qty;
      }
    });
    return total;
  }

  int get _totalTickets {
    return _ticketQuantities.values.fold(0, (sum, q) => sum + q);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eventAsync = ref.watch(eventDetailProvider(widget.eventId));

    return Scaffold(
      backgroundColor: Colors.white,
      body: eventAsync.when(
        data: (event) => _buildContent(event),
        loading: () => const Center(
          child: CircularProgressIndicator(color: HbColors.brandPrimary),
        ),
        error: (error, stack) => _buildErrorState(error),
      ),
      bottomNavigationBar: eventAsync.valueOrNull != null
          ? EventStickyBookingBar(
              event: eventAsync.value!,
              ticketQuantities: _ticketQuantities,
              totalPrice: _totalPrice,
              onBookPressed: _totalTickets > 0 ? _onBookPressed : null,
              onViewDatesPressed: _scrollToDateSection,
            )
          : null,
    );
  }

  Widget _buildErrorState(Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Impossible de charger l\'activité',
              style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Retour'),
              style: ElevatedButton.styleFrom(
                backgroundColor: HbColors.brandPrimary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(Event event) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        // AppBar transparent
        SliverAppBar(
          pinned: true,
          backgroundColor: Colors.white.withValues(alpha: 0.95),
          elevation: 0,
          leading: _buildCircularButton(
            icon: Icons.arrow_back,
            onTap: () => context.pop(),
          ),
          actions: [
            _buildCircularButton(
              icon: Icons.share_outlined,
              onTap: () => _shareEvent(event),
            ),
            const SizedBox(width: 8),
            FavoriteButton(
              event: event,
              internalId: int.tryParse(widget.eventId),
              iconSize: 20,
              containerSize: 40,
              showBackground: true,
            ),
            const SizedBox(width: 12),
          ],
        ),

        // Contenu principal
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Galerie Airbnb
              EventGalleryGrid(
                images: event.images,
                onViewAll: () => _openFullscreenGallery(event, 0),
                onImageTap: (index) => _openFullscreenGallery(event, index),
              ),

              const SizedBox(height: 20),

              // 2. Header Compact
              EventCompactHeader(
                event: event,
                onOrganizerTap: () => context.push('/partner/${event.organizerId}'),
              ),

              const SizedBox(height: 24),

              // 3. Sélection de dates
              _buildDateSection(event),

              const SizedBox(height: 24),

              // 4. Billets
              if (event.tickets.isNotEmpty) ...[
                EventTicketsSection(
                  tickets: event.tickets,
                  quantities: _ticketQuantities,
                  onQuantityChanged: (entry) {
                    setState(() {
                      _ticketQuantities[entry.key] = entry.value;
                    });
                  },
                ),
                const SizedBox(height: 24),
              ],

              // 5. Description
              _buildDescriptionSection(event),

              const SizedBox(height: 24),

              // 6. Infos pratiques
              EventPracticalInfo(
                event: event,
                locationDetails: event.locationDetails,
              ),

              const SizedBox(height: 24),

              // 7. Organisateur
              _buildOrganizerSection(event),

              const SizedBox(height: 24),

              // 8. Avis (connecté à l'API)
              EventReviewsSection(
                eventSlug: event.slug ?? event.id,
                onWriteReview: () => _showWriteReviewDialog(event),
                onViewAll: () => _showAllReviews(event),
              ),

              const SizedBox(height: 24),

              // 9. Questions/Réponses (connecté à l'API)
              EventQASection(
                eventSlug: event.slug ?? event.id,
                eventTitle: event.title,
                onViewAll: () => _showAllQuestions(event),
              ),

              // 10. Espace pour la sticky bar
              SizedBox(height: MediaQuery.of(context).padding.bottom + 100),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateSection(Event event) {
    final availabilityAsync = ref.watch(eventAvailabilityProvider(event.id));

    return availabilityAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: CircularProgressIndicator(color: HbColors.brandPrimary),
        ),
      ),
      error: (_, __) => _buildDateSelectorFromEvent(event),
      data: (availability) {
        // Convertir les slots API en CalendarDateSlot
        final slots = availability.slots.map((slot) {
          DateTime date;
          try {
            date = DateTime.parse(slot.date);
          } catch (_) {
            final parts = slot.date.split('-');
            if (parts.length == 3) {
              date = DateTime(
                int.tryParse(parts[2]) ?? 2024,
                int.tryParse(parts[1]) ?? 1,
                int.tryParse(parts[0]) ?? 1,
              );
            } else {
              date = DateTime.now();
            }
          }

          return CalendarDateSlot(
            id: slot.id,
            date: date,
            startTime: slot.startTime,
            endTime: slot.endTime,
            spotsRemaining: slot.spotsRemaining,
          );
        }).toList();

        if (slots.isEmpty) {
          return const SizedBox.shrink();
        }

        return EventDateSelector(
          slots: slots,
          selectedSlotId: _selectedSlotId,
          onSlotSelected: (slot) {
            HapticFeedback.selectionClick();
            setState(() => _selectedSlotId = slot.id);
          },
          onViewAllDates: () => _showAllDatesModal(slots),
        );
      },
    );
  }

  Widget _buildDateSelectorFromEvent(Event event) {
    final slots = event.calendar?.dateSlots ?? [];

    if (slots.isEmpty && event.recurrence == null) {
      return const SizedBox.shrink();
    }

    return EventDateSelector(
      slots: slots,
      selectedSlotId: _selectedSlotId,
      onSlotSelected: (slot) {
        HapticFeedback.selectionClick();
        setState(() => _selectedSlotId = slot.id);
      },
      onViewAllDates: () => _showAllDatesModal(slots),
    );
  }

  Widget _buildDescriptionSection(Event event) {
    final description = event.description;
    final isLongText = description.length > _maxDescriptionLength;
    final displayText = _isDescriptionExpanded || !isLongText
        ? description
        : '${description.substring(0, _maxDescriptionLength)}...';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'À propos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: HbColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            displayText,
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Colors.grey.shade700,
            ),
          ),
          if (isLongText)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() => _isDescriptionExpanded = !_isDescriptionExpanded);
                },
                child: Text(
                  _isDescriptionExpanded ? 'Voir moins' : 'Lire la suite',
                  style: const TextStyle(
                    color: HbColors.brandPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOrganizerSection(Event event) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Organisateur',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: HbColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () => context.push('/partner/${event.organizerId}'),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: HbColors.brandPrimary.withValues(alpha: 0.1),
                    backgroundImage: event.organizerLogo != null
                        ? NetworkImage(event.organizerLogo!)
                        : null,
                    child: event.organizerLogo == null
                        ? Text(
                            event.organizerName.isNotEmpty
                                ? event.organizerName[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              color: HbColors.brandPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.organizerName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: HbColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.verified,
                              size: 14,
                              color: Colors.blue.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Organisateur vérifié',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: HbColors.brandPrimary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: 20, color: HbColors.textPrimary),
        onPressed: onTap,
        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
        style: IconButton.styleFrom(padding: EdgeInsets.zero),
      ),
    );
  }

  // --- Actions ---

  void _shareEvent(Event event) async {
    await Share.share(
      'Découvre cette activité : ${event.title}\nhttps://lehiboo.com/events/${event.slug ?? event.id}',
      subject: event.title,
    );
  }

  void _openFullscreenGallery(Event event, int initialIndex) {
    EventGalleryFullscreen.show(
      context,
      images: event.images,
      initialIndex: initialIndex,
      eventTitle: event.title,
      shareUrl: 'https://lehiboo.com/events/${event.slug ?? event.id}',
    );
  }

  void _scrollToDateSection() {
    HapticFeedback.lightImpact();
    // Scroll approximatif vers la section dates
    _scrollController.animateTo(
      300,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _onBookPressed() {
    HapticFeedback.mediumImpact();
    final event = ref.read(eventDetailProvider(widget.eventId)).valueOrNull;
    if (event == null) return;

    // TODO: Naviguer vers le flow de réservation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Réservation en cours d\'implémentation'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showAllDatesModal(List<CalendarDateSlot> slots) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Toutes les dates (${slots.length})',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: slots.length,
                  itemBuilder: (context, index) {
                    final slot = slots[index];
                    final isSelected = slot.id == _selectedSlotId;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _DateSlotModalCard(
                        slot: slot,
                        isSelected: isSelected,
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() => _selectedSlotId = slot.id);
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Actions pour reviews et Q&A ---

  void _showWriteReviewDialog(Event event) {
    // TODO: Ouvrir le dialog d'écriture d'avis (nécessite vérification auth)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Écrire un avis - authentification requise')),
    );
  }

  void _showAllReviews(Event event) {
    // TODO: Naviguer vers la page de tous les avis
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Voir tous les avis')),
    );
  }

  void _showAllQuestions(Event event) {
    // TODO: Naviguer vers la page de toutes les questions
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Voir toutes les questions')),
    );
  }
}

/// Card pour un créneau dans le modal
class _DateSlotModalCard extends StatelessWidget {
  final CalendarDateSlot slot;
  final bool isSelected;
  final VoidCallback onTap;

  const _DateSlotModalCard({
    required this.slot,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isFull = slot.spotsRemaining != null && slot.spotsRemaining! <= 0;

    return GestureDetector(
      onTap: isFull ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? HbColors.brandPrimary.withValues(alpha: 0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? HbColors.brandPrimary : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatDate(slot.date),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isFull ? Colors.grey : HbColors.textPrimary,
                    ),
                  ),
                  if (slot.startTime != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      _formatTimeRange(),
                      style: TextStyle(
                        fontSize: 14,
                        color: isFull ? Colors.grey : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (isFull)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Complet',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            else if (isSelected)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: HbColors.brandPrimary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 16,
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: HbColors.brandPrimary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Choisir',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
      'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'
    ];
    final days = ['lundi', 'mardi', 'mercredi', 'jeudi', 'vendredi', 'samedi', 'dimanche'];
    final dayName = days[date.weekday - 1];
    final monthName = months[date.month - 1];
    return '${dayName[0].toUpperCase()}${dayName.substring(1)} ${date.day} $monthName';
  }

  String _formatTimeRange() {
    if (slot.startTime == null) return '';
    if (slot.endTime != null) {
      return '${slot.startTime} – ${slot.endTime}';
    }
    return slot.startTime!;
  }
}
