import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/core/utils/api_response_handler.dart';
import 'package:lehiboo/core/utils/guest_guard.dart';
import 'package:lehiboo/features/favorites/presentation/widgets/favorite_button.dart';
import '../../domain/entities/event.dart';
import '../../domain/entities/event_submodels.dart';
import '../../domain/repositories/event_repository.dart';
import '../../data/datasources/events_api_datasource.dart';
import '../../data/models/event_availability_dto.dart';
import '../widgets/detail/event_hero_gallery.dart';
import '../widgets/detail/event_gallery_fullscreen.dart';
import '../widgets/detail/event_compact_header.dart';
import '../widgets/detail/event_social_proof.dart';
import '../widgets/detail/event_organizer_card.dart';
import '../widgets/detail/event_date_selector.dart';
import '../widgets/detail/event_ticket_card.dart';
import '../widgets/detail/event_indicative_prices.dart';
import '../widgets/detail/event_practical_info.dart';
import '../widgets/detail/event_accessibility_section.dart';
import '../widgets/detail/event_location_map.dart';
import '../widgets/detail/event_qa_section.dart';
import '../widgets/detail/event_similar_carousel.dart';
import '../widgets/detail/event_share_sheet.dart';
import '../widgets/detail/event_sticky_booking_bar.dart';
import '../../../reviews/presentation/widgets/event_reviews_section.dart';
import '../../../reviews/presentation/widgets/write_review_sheet.dart';
import '../../../reminders/presentation/providers/reminders_provider.dart';
import '../../../reminders/data/datasources/reminders_api_datasource.dart';

/// Provider to fetch event details by identifier (UUID or slug)
final eventDetailProvider =
    FutureProvider.family<Event, String>((ref, identifier) async {
  final repository = ref.watch(eventRepositoryProvider);
  return repository.getEvent(identifier);
});

/// Provider to fetch event availability (slots & tickets)
final eventAvailabilityProvider =
    FutureProvider.family<EventAvailabilityResponseDto, String>(
        (ref, eventId) async {
  final dataSource = ref.watch(eventsApiDataSourceProvider);
  return dataSource.getEventAvailability(eventId);
});

/// Provider for similar events (could be from API or cached)
final similarEventsProvider =
    FutureProvider.family<List<Event>, String>((ref, eventId) async {
  // TODO: Implement API call for similar events
  // For now, return empty list
  return [];
});

class EventDetailScreen extends ConsumerStatefulWidget {
  final String eventId;

  const EventDetailScreen({super.key, required this.eventId});

  @override
  ConsumerState<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends ConsumerState<EventDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _dateSectionKey = GlobalKey();
  final Map<String, int> _ticketQuantities = {};
  String? _selectedSlotId;
  bool _isDescriptionExpanded = false;
  double _scrollOffset = 0;

  /// Cache des slots disponibles pour l'événement (pour obtenir le label de date)
  List<CalendarDateSlot> _availableSlots = [];

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

  /// Retourne le label formaté de la date sélectionnée (ex: "Sam 15 Mars à 14:00")
  String? _getSelectedDateLabel() {
    if (_selectedSlotId == null || _availableSlots.isEmpty) return null;

    final slot = _availableSlots.firstWhere(
      (s) => s.id == _selectedSlotId,
      orElse: () => _availableSlots.first,
    );

    if (slot.id != _selectedSlotId) return null;

    final months = [
      'Jan',
      'Fév',
      'Mars',
      'Avr',
      'Mai',
      'Juin',
      'Juil',
      'Août',
      'Sep',
      'Oct',
      'Nov',
      'Déc'
    ];
    final days = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];

    final dayName = days[slot.date.weekday - 1];
    final monthName = months[slot.date.month - 1];
    final dateStr = '$dayName ${slot.date.day} $monthName';

    if (slot.startTime != null) {
      return '$dateStr à ${slot.startTime}';
    }
    return dateStr;
  }

  /// Whether the booking bar should be hidden entirely
  bool _shouldHideBookingBar(Event event) {
    // Sold-out check only applies to vendor events with real inventory.
    // Platform events report spots_remaining: 0 because they don't
    // manage bookable inventory — the bar should still show for them.
    if (!event.organizerIsPlatform &&
        event.availableSeats != null &&
        event.availableSeats! <= 0) {
      return true;
    }

    // Hide if all slots are in the past
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (_availableSlots.isNotEmpty) {
      final allPassed = _availableSlots.every((slot) => slot.date.isBefore(today));
      if (allPassed) return true;
    } else if (event.endDate.isBefore(today)) {
      // No slots loaded yet, fall back to event end date
      return true;
    }

    return false;
  }

  /// Retourne le slot sélectionné
  CalendarDateSlot? get _selectedSlot {
    if (_selectedSlotId == null || _availableSlots.isEmpty) return null;
    return _availableSlots.firstWhere(
      (s) => s.id == _selectedSlotId,
      orElse: () => _availableSlots.first,
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eventAsync = ref.watch(eventDetailProvider(widget.eventId));

    return Scaffold(
      // Flat design : fond gris clair pour créer hiérarchie avec cards blanches
      backgroundColor: HbColors.backgroundLight,
      body: eventAsync.when(
        data: (event) => _buildContent(event),
        loading: () => const Center(
          child: CircularProgressIndicator(color: HbColors.brandPrimary),
        ),
        error: (error, stack) => _buildErrorState(error),
      ),
      bottomNavigationBar: eventAsync.valueOrNull != null &&
              !_shouldHideBookingBar(eventAsync.value!)
          ? _buildStickyBar(eventAsync.value!)
          : null,
    );
  }

  Widget _buildStickyBar(Event event) {
    int reminderCount = 0;
    if (!event.hasDirectBooking) {
      final eventUuid = _looksLikeUuid(event.id) ? event.id : widget.eventId;
      final remindersAsync = ref.watch(eventRemindersProvider(eventUuid));
      reminderCount = remindersAsync.maybeWhen(
        data: (ids) => ids.length,
        orElse: () => 0,
      );
    }

    return EventStickyBookingBar(
      event: event,
      ticketQuantities: _ticketQuantities,
      totalPrice: _totalPrice,
      selectedSlotId: _selectedSlotId,
      selectedDateLabel: _getSelectedDateLabel(),
      selectedSlot: _selectedSlot,
      onBookPressed: !event.hasDirectBooking && reminderCount > 0
          ? () => context.push('/my-reminders')
          : _onBookPressed,
      onViewDatesPressed: _scrollToDateSection,
      reminderCount: reminderCount,
    );
  }

  Widget _buildErrorState(Object error) {
    final message = ApiResponseHandler.extractError(
      error,
      fallback: 'Impossible de charger l\'activité.',
    );

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back, size: 18),
                  label: const Text('Retour'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey.shade700,
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () =>
                      ref.invalidate(eventDetailProvider(widget.eventId)),
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Réessayer'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HbColors.brandPrimary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(Event event) {
    final similarEventsAsync = ref.watch(similarEventsProvider(widget.eventId));

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        // 1. Hero Gallery avec AppBar intégrée
        SliverToBoxAdapter(
          child: Stack(
            children: [
              // Galerie hero
              EventHeroGallery(
                images: event.images,
                videoUrl: event.socialMedia?.videoUrl,
                onViewAll: () => _openFullscreenGallery(event, 0),
                onImageTap: (index) => _openFullscreenGallery(event, index),
              ),

              // AppBar overlay
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _buildOverlayAppBar(event),
              ),

            ],
          ),
        ),

        // Contenu principal
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // 2. Badges (sans le prix qui va sous le titre)
              if (event.isFeatured || event.isRecommended)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: EventBadges(
                    isFeatured: event.isFeatured,
                    isRecommended: event.isRecommended,
                  ),
                ),

              if (event.isFeatured || event.isRecommended)
                const SizedBox(height: 12),

              // 3. Header Compact (titre, adresse, tags, rating)
              EventCompactHeader(event: event),

              // Excerpt
              if (event.description.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Text(
                    event.description,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

              const SizedBox(height: 16),

              // 4. Organisateur (below excerpt)
              EventOrganizerCard(
                event: event,
                onOrganizerTap: () =>
                    context.push('/partner/${event.organizerId}'),
              ),

              const SizedBox(height: 24),

              // 5. Description (À propos)
              _buildDescriptionSection(event),

              const SizedBox(height: 24),

              // 5b. Tarifs
              _buildPricingSection(event),

              const SizedBox(height: 24),

              // For booking events: dates + tickets right after pricing
              if (event.hasDirectBooking) ...[
                KeyedSubtree(
                  key: _dateSectionKey,
                  child: _buildDateSection(event),
                ),
                const SizedBox(height: 24),
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
              ],

              // 5c. Tags & caractéristiques
              _buildTagsSection(event),

              const SizedBox(height: 24),

              // 5d. Carte localisation
              EventLocationMap(
                event: event,
                userLatitude: null, // TODO: get from location provider
                userLongitude: null,
              ),

              const SizedBox(height: 24),

              // For discovery events: dates + tickets in original position
              if (!event.hasDirectBooking) ...[
                KeyedSubtree(
                  key: _dateSectionKey,
                  child: _buildDateSection(event),
                ),
                const SizedBox(height: 24),
              ],

              // 7. Billets (only for discovery — booking already rendered above)
              if (!event.hasDirectBooking && event.tickets.isNotEmpty) ...[
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

              // 7b. Indicative prices
              EventIndicativePrices(prices: event.indicativePrices),
              if (event.indicativePrices.isNotEmpty)
                const SizedBox(height: 24),

              // 8. Infos pratiques (grille 2x2)
              EventPracticalInfo(
                event: event,
                locationDetails: event.locationDetails,
              ),

              const SizedBox(height: 24),

              // 9b. Accessibilité
              EventAccessibilitySection(
                locationDetails: event.locationDetails,
              ),

              const SizedBox(height: 24),

              // 10. Avis (connecté à l'API)
              EventReviewsSection(
                eventSlug: event.slug,
                onWriteReview: () => _showWriteReviewDialog(event),
                onViewAll: () => _showAllReviews(event),
              ),

              const SizedBox(height: 24),

              // 11. Questions/Réponses — masqué pour les events dont
              // l'organisation est une plateforme (pas d'organisateur humain
              // pour répondre aux questions).
              if (!event.organizerIsPlatform) ...[
                EventQASection(
                  eventSlug: event.slug,
                  eventTitle: event.title,
                ),
                const SizedBox(height: 24),
              ],

              // 12. Événements similaires
              similarEventsAsync.when(
                data: (similarEvents) => similarEvents.isNotEmpty
                    ? EventSimilarCarousel(
                        events: similarEvents,
                        currentEventId: event.id,
                      )
                    : const SizedBox.shrink(),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),

              // 13. Espace pour la sticky bar
              SizedBox(height: MediaQuery.of(context).padding.bottom + 100),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOverlayAppBar(Event event) {
    // Calculer l'opacité du fond en fonction du scroll
    final opacity = (_scrollOffset / 200).clamp(0.0, 1.0);

    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: BoxDecoration(
        gradient: opacity < 1
            ? LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.5 * (1 - opacity)),
                  Colors.transparent,
                ],
              )
            : null,
        color: opacity >= 1 ? Colors.white : null,
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          _buildCircularButton(
            icon: Icons.arrow_back,
            onTap: () => context.pop(),
            darkMode: opacity < 0.5,
          ),
          const Spacer(),
          // Bouton partage (ouvre le nouveau sheet)
          ShareButton(
            event: event,
            shareUrl: 'https://lehiboo.com/events/${event.slug}',
            backgroundColor:
                opacity < 0.5 ? Colors.white : Colors.grey.shade100,
            iconColor: HbColors.textPrimary,
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
    );
  }

  Widget _buildDateSection(Event event) {
    final availabilityId = _looksLikeUuid(event.id) ? event.id : widget.eventId;
    final availabilityAsync =
        ref.watch(eventAvailabilityProvider(availabilityId));

    return availabilityAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: CircularProgressIndicator(color: HbColors.brandPrimary),
        ),
      ),
      error: (error, stack) {
        debugPrint(
          '⚠️ eventAvailabilityProvider error: '
          '${ApiResponseHandler.extractError(error)}',
        );
        return _buildDateSelectorFromEvent(event);
      },
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

        // Stocker les slots pour pouvoir obtenir le label de date
        if (_availableSlots.isEmpty || _availableSlots.length != slots.length) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _availableSlots = slots;
                // Auto-sélection si une seule date disponible
                if (slots.length == 1 && _selectedSlotId == null) {
                  _selectedSlotId = slots.first.id;
                }
              });
            }
          });
        }

        if (slots.isEmpty) {
          return const SizedBox.shrink();
        }

        return _buildDateSelectorWidget(event, slots);
      },
    );
  }

  Widget _buildDateSelectorFromEvent(Event event) {
    final slots = event.calendar?.dateSlots ?? [];

    // Si pas de slots ET pas de récurrence, afficher un message d'aide
    if (slots.isEmpty && event.recurrence == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.orange),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Dates bientôt disponibles. Contactez l\'organisateur pour plus d\'infos.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Stocker les slots pour pouvoir obtenir le label de date
    if (_availableSlots.isEmpty || _availableSlots.length != slots.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _availableSlots = slots;
            // Auto-sélection si une seule date disponible
            if (slots.length == 1 && _selectedSlotId == null) {
              _selectedSlotId = slots.first.id;
            }
          });
        }
      });
    }

    return _buildDateSelectorWidget(event, slots);
  }

  Widget _buildDateSelectorWidget(Event event, List<CalendarDateSlot> slots) {
    final isDiscovery = !event.hasDirectBooking;

    if (isDiscovery) {
      final eventUuid = _looksLikeUuid(event.id) ? event.id : widget.eventId;
      final remindersAsync = ref.watch(eventRemindersProvider(eventUuid));
      final remindedIds = remindersAsync.maybeWhen(
        data: (ids) => ids,
        orElse: () => <String>{},
      );

      return EventDateSelector(
        slots: slots,
        selectedSlotId: _selectedSlotId,
        onSlotSelected: (slot) {
          HapticFeedback.selectionClick();
          setState(() => _selectedSlotId = slot.id);
        },
        onViewAllDates: () => _showAllDatesModal(slots),
        remindedSlotIds: remindedIds,
        onReminderToggled: (slot) => _toggleReminder(event, slot),
      );
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

  Future<void> _toggleReminder(Event event, CalendarDateSlot slot) async {
    final allowed = await GuestGuard.check(
      context: context,
      ref: ref,
      featureName: 'activer un rappel',
    );
    if (!allowed || !mounted) return;

    final eventUuid = _looksLikeUuid(event.id) ? event.id : widget.eventId;
    final dataSource = ref.read(remindersApiDataSourceProvider);

    final remindersAsync = ref.read(eventRemindersProvider(eventUuid));
    final currentIds = remindersAsync.maybeWhen(
      data: (ids) => ids,
      orElse: () => <String>{},
    );
    final isCurrentlyReminded = currentIds.contains(slot.id);

    try {
      if (isCurrentlyReminded) {
        await dataSource.deleteReminder(
          eventUuid: eventUuid,
          slotUuid: slot.id,
        );
      } else {
        await dataSource.createReminder(
          eventUuid: eventUuid,
          slotUuid: slot.id,
        );
      }
      // Refresh the provider to reflect the change
      ref.invalidate(eventRemindersProvider(eventUuid));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ApiResponseHandler.extractError(e)),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildDescriptionSection(Event event) {
    final description = event.fullDescription ?? event.description;
    final isLongText = description.length > _maxDescriptionLength;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'À propos de l\'événement',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: HbColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          AnimatedCrossFade(
            firstChild: Text(
              '${description.substring(0, description.length.clamp(0, _maxDescriptionLength))}${description.length > _maxDescriptionLength ? '...' : ''}',
              style: TextStyle(
                fontSize: 15,
                height: 1.6,
                color: Colors.grey.shade700,
              ),
            ),
            secondChild: Text(
              description,
              style: TextStyle(
                fontSize: 15,
                height: 1.6,
                color: Colors.grey.shade700,
              ),
            ),
            crossFadeState: _isDescriptionExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
          if (isLongText)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(
                      () => _isDescriptionExpanded = !_isDescriptionExpanded);
                },
                child: Row(
                  children: [
                    Text(
                      _isDescriptionExpanded ? 'Voir moins' : 'Lire la suite',
                      style: const TextStyle(
                        color: HbColors.brandPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 4),
                    AnimatedRotation(
                      turns: _isDescriptionExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: const Icon(
                        Icons.keyboard_arrow_down,
                        size: 18,
                        color: HbColors.brandPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPricingSection(Event event) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tarifs',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: HbColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: _buildPriceContent(event),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceContent(Event event) {
    switch (event.priceType) {
      case PriceType.free:
        return Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: HbColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Gratuit',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: HbColors.success,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Aucun frais d\'entrée',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
          ],
        );

      case PriceType.donation:
        return Row(
          children: [
            const Icon(Icons.favorite_outline, size: 18, color: HbColors.brandPrimary),
            const SizedBox(width: 8),
            const Text(
              'Participation libre',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: HbColors.textPrimary,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '— montant au choix',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
          ],
        );

      case PriceType.paid:
      case PriceType.variable:
        // Effective price is zero → display as free
        final effectivePrice = event.price ?? event.minPrice ?? 0;
        if (effectivePrice == 0 && (event.maxPrice ?? 0) == 0) {
          return Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: HbColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Gratuit',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: HbColors.success,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Aucun frais d\'entrée',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ],
          );
        }

        final hasRange = event.minPrice != null &&
            event.maxPrice != null &&
            event.minPrice != event.maxPrice;

        if (hasRange) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'À partir de',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    '${event.minPrice!.toStringAsFixed(0)} €',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: HbColors.textPrimary,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Container(
                        height: 1,
                        color: Colors.grey.shade200,
                      ),
                    ),
                  ),
                  Text(
                    '${event.maxPrice!.toStringAsFixed(0)} €',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Min',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                  Text(
                    'Max',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ],
          );
        }

        // Single price or fallback
        final priceText = event.price != null
            ? '${event.price!.toStringAsFixed(2)} €'
            : event.formattedPrice;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              priceText,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: HbColors.textPrimary,
              ),
            ),
            if (event.price != null) ...[
              const SizedBox(width: 6),
              Text(
                'par personne',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ],
          ],
        );
    }
  }

  Widget _buildTagsSection(Event event) {
    final chips = <_ChipEntry>[];

    // Primary category
    chips.add(_ChipEntry(
      label: event.categoryLabel,
      icon: Icons.category_outlined,
      color: HbColors.brandPrimary,
    ));

    // Other categories (skip if same name as primary label)
    for (final name in event.allCategoryNames) {
      if (name.toLowerCase() != event.categoryLabel.toLowerCase() &&
          !chips.any((c) => c.label.toLowerCase() == name.toLowerCase())) {
        chips.add(_ChipEntry(
          label: name,
          icon: Icons.label_outlined,
          color: HbColors.brandSecondary,
        ));
      }
    }

    // Event type
    if (event.eventTypeTerm != null &&
        !chips.any((c) => c.label.toLowerCase() == event.eventTypeTerm!.name.toLowerCase())) {
      chips.add(_ChipEntry(
        label: event.eventTypeTerm!.name,
        icon: Icons.style_outlined,
        color: Colors.deepPurple,
      ));
    }

    // Place type
    final placeLabel = event.locationTypeLabel;
    if (placeLabel.isNotEmpty) {
      chips.add(_ChipEntry(
        label: placeLabel,
        icon: event.isOutdoor && !event.isIndoor
            ? Icons.park_outlined
            : Icons.home_outlined,
        color: Colors.teal,
      ));
    }

    // Theme
    if (event.thematiqueName != null) {
      chips.add(_ChipEntry(
        label: event.thematiqueName!,
        icon: Icons.palette_outlined,
        color: Colors.indigo,
      ));
    }

    // Audience
    for (final term in event.targetAudienceTerms) {
      chips.add(_ChipEntry(
        label: term.name,
        icon: Icons.people_outline,
        color: Colors.blue,
      ));
    }

    // Free-form tags
    for (final tag in event.tags) {
      if (!chips.any((c) => c.label.toLowerCase() == tag.toLowerCase())) {
        chips.add(_ChipEntry(
          label: tag,
          icon: Icons.tag,
          color: Colors.grey.shade600,
        ));
      }
    }

    if (chips.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Caractéristiques',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: HbColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: chips.map((chip) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: chip.color.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: chip.color.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(chip.icon, size: 14, color: chip.color),
                  const SizedBox(width: 5),
                  Text(
                    chip.label,
                    style: TextStyle(
                      color: chip.color,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularButton({
    required IconData icon,
    required VoidCallback onTap,
    bool darkMode = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: darkMode ? Colors.black.withValues(alpha: 0.3) : Colors.white,
        shape: BoxShape.circle,
        boxShadow: darkMode
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                ),
              ],
      ),
      child: IconButton(
        icon: Icon(
          icon,
          size: 20,
          color: darkMode ? Colors.white : HbColors.textPrimary,
        ),
        onPressed: onTap,
        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
        style: IconButton.styleFrom(padding: EdgeInsets.zero),
      ),
    );
  }

  // --- Actions ---

  void _openFullscreenGallery(Event event, int initialIndex) {
    EventGalleryFullscreen.show(
      context,
      images: event.images,
      initialIndex: initialIndex,
      eventTitle: event.title,
      shareUrl: 'https://lehiboo.com/events/${event.slug}',
    );
  }

  void _scrollToDateSection() {
    HapticFeedback.lightImpact();

    final keyContext = _dateSectionKey.currentContext;
    if (keyContext != null) {
      final box = keyContext.findRenderObject() as RenderBox;
      final scrollableBox =
          _scrollController.position.context.storageContext
              .findRenderObject() as RenderBox;
      final offset = box.localToGlobal(Offset.zero, ancestor: scrollableBox);
      final target = _scrollController.offset + offset.dy - 16;

      _scrollController.animateTo(
        target.clamp(0, _scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onBookPressed() async {
    final allowed = await GuestGuard.check(
      context: context,
      ref: ref,
      featureName: 'réserver une activité',
    );
    if (!allowed) return;
    if (!mounted) return;

    HapticFeedback.mediumImpact();
    final event = ref.read(eventDetailProvider(widget.eventId)).valueOrNull;
    if (event == null) return;

    final externalUrl = event.externalBooking?.url;
    if (externalUrl != null && externalUrl.isNotEmpty) {
      final uri = Uri.tryParse(externalUrl);
      if (uri != null) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return;
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lien de réservation invalide'),
            duration: Duration(seconds: 2),
          ),
        );
      }
      return;
    }

    // Vérification: date obligatoire
    if (_selectedSlotId == null) {
      _scrollToDateSection();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez d\'abord choisir une date'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Vérification: au moins un billet sélectionné
    if (_totalTickets == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner au moins un billet'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Naviguer vers le checkout avec toutes les données
    context.push('/checkout', extra: {
      'event': event,
      'slotId': _selectedSlotId,
      'selectedSlot': _selectedSlot,
      'ticketQuantities': Map<String, int>.from(_ticketQuantities),
      'totalPrice': _totalPrice,
    });
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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

  Future<void> _showWriteReviewDialog(Event event) async {
    final allowed = await GuestGuard.check(
      context: context,
      ref: ref,
      featureName: 'laisser un avis',
    );
    if (!allowed || !mounted) return;
    await WriteReviewSheet.show(
      context,
      eventSlug: event.slug,
      eventTitle: event.title,
    );
  }

  void _showAllReviews(Event event) {
    context.push(
      '/event/${event.slug}/reviews',
      extra: {'title': event.title},
    );
  }

  bool _looksLikeUuid(String value) {
    final uuidPattern = RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
    );
    return uuidPattern.hasMatch(value);
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
    final days = [
      'lundi',
      'mardi',
      'mercredi',
      'jeudi',
      'vendredi',
      'samedi',
      'dimanche'
    ];
    final dayName = days[date.weekday - 1];
    final monthName = months[date.month - 1];
    return '${dayName[0].toUpperCase()}${dayName.substring(1)} ${date.day} $monthName';
  }

  String _formatTimeRange() {
    if (slot.startTime == null) return '';
    final start = _stripSeconds(slot.startTime!);
    if (slot.endTime != null) {
      return '$start – ${_stripSeconds(slot.endTime!)}';
    }
    return start;
  }

  /// "14:00:00" → "14:00"
  static String _stripSeconds(String time) {
    final parts = time.split(':');
    if (parts.length >= 2) return '${parts[0]}:${parts[1]}';
    return time;
  }
}

class _ChipEntry {
  final String label;
  final IconData icon;
  final Color color;

  const _ChipEntry({
    required this.label,
    required this.icon,
    required this.color,
  });
}
