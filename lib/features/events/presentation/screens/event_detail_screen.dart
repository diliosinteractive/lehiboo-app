import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lehiboo/config/env_config.dart';
import 'package:lehiboo/core/analytics/analytics_event.dart';
import 'package:lehiboo/core/analytics/analytics_provider.dart';
import 'package:lehiboo/core/l10n/l10n.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/core/utils/api_response_handler.dart';
import 'package:lehiboo/core/utils/guest_guard.dart';
import 'package:lehiboo/features/favorites/presentation/widgets/favorite_button.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_session_key_provider.dart';
import 'package:lehiboo/features/auth/presentation/widgets/account_bound_route_guard.dart';
import '../../domain/entities/event.dart';
import '../../domain/entities/event_detail_state.dart';
import '../../domain/entities/event_submodels.dart';
import '../../domain/exceptions/event_password_exceptions.dart';
import '../../domain/repositories/event_repository.dart';
import '../../data/datasources/events_api_datasource.dart';
import '../../data/models/event_availability_dto.dart';
import '../widgets/detail/event_hero_gallery.dart';
import '../widgets/detail/event_locked_view.dart';
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
import '../utils/event_l10n.dart';
import '../../../memberships/domain/exceptions/members_only_exception.dart';
import '../../../memberships/presentation/widgets/members_only_gate.dart';
import '../../../reviews/presentation/widgets/event_reviews_section.dart';
import '../../../reviews/presentation/widgets/write_review_sheet.dart';
import '../../../memberships/presentation/providers/personalized_feed_provider.dart';
import '../../../reminders/presentation/providers/reminders_provider.dart';
import '../../../reminders/data/datasources/reminders_api_datasource.dart';
import '../../../booking/domain/models/refund_policy.dart';
import '../../../booking/domain/utils/booking_age_eligibility.dart';
import '../../../booking/presentation/providers/order_cart_provider.dart';

/// Provider to fetch event details by identifier (UUID or slug).
///
/// Wraps the repository fetch in an [EventDetailState] sealed union so the
/// screen can distinguish a fully loaded [Event] from a locked-shell preview
/// (`403 password_required`). The controller exposes [seed] for callers that
/// already have a verified [Event] (list-side unlock path) and [unlock] for
/// the password sheet to submit a password and transition into `.loaded`.
typedef EventDetailRequest = ({AuthSessionKey owner, String identifier});

EventDetailRequest eventDetailRequest(
  AuthSessionKey owner,
  String identifier,
) =>
    (owner: owner, identifier: identifier);

final eventDetailControllerProvider = AsyncNotifierProvider.autoDispose
    .family<EventDetailController, EventDetailState, EventDetailRequest>(
  EventDetailController.new,
);

class EventDetailController extends AutoDisposeFamilyAsyncNotifier<
    EventDetailState, EventDetailRequest> {
  int _stateGeneration = 0;
  bool _disposed = false;

  @override
  Future<EventDetailState> build(EventDetailRequest request) async {
    _disposed = false;
    ref.onDispose(() {
      _disposed = true;
      _stateGeneration++;
    });
    final generation = ++_stateGeneration;
    final activeOwner = ref.watch(authSessionKeyProvider);
    if (!identical(activeOwner, request.owner)) {
      throw const EventDetailSessionChangedException();
    }

    try {
      final event =
          await ref.read(eventRepositoryProvider).getEvent(request.identifier);
      _ensureOwned(request.owner, generation);
      return EventDetailState.loaded(event);
    } on EventPasswordRequiredException catch (e) {
      _ensureOwned(request.owner, generation);
      return EventDetailState.locked(e.shell);
    }
  }

  /// Pre-seed the cache with an already-unlocked event (list-side unlock).
  bool seed(Event event, {required AuthSessionKey owner}) {
    if (!_owns(owner)) return false;
    _stateGeneration++;
    state = AsyncData(EventDetailState.loaded(event));
    return true;
  }

  /// Submit a password to the verify endpoint. On success the state flips to
  /// `loaded(event)` and the returned event is handed back to the sheet.
  /// Typed exceptions propagate so the sheet can surface them (shake,
  /// countdown, members-only swap).
  Future<Event> unlock(
    String password, {
    required AuthSessionKey owner,
  }) async {
    if (!_owns(owner)) throw const EventDetailSessionChangedException();
    final event = await ref
        .read(eventRepositoryProvider)
        .verifyEventPassword(arg.identifier, password);
    if (!_owns(owner)) throw const EventDetailSessionChangedException();
    _stateGeneration++;
    state = AsyncData(EventDetailState.loaded(event));
    return event;
  }

  bool _owns(AuthSessionKey owner) {
    return !_disposed &&
        identical(owner, arg.owner) &&
        identical(ref.read(authSessionKeyProvider), owner);
  }

  void _ensureOwned(AuthSessionKey owner, int generation) {
    if (!_owns(owner) || generation != _stateGeneration) {
      throw const EventDetailSessionChangedException();
    }
  }
}

class EventDetailSessionChangedException implements Exception {
  const EventDetailSessionChangedException();
}

/// Provider to fetch event availability (slots & tickets)
typedef EventAvailabilityRequest = ({
  AuthSessionKey owner,
  String eventId,
});

EventAvailabilityRequest eventAvailabilityRequest(
  AuthSessionKey owner,
  String eventId,
) =>
    (owner: owner, eventId: eventId);

final eventAvailabilityProvider = FutureProvider.autoDispose
    .family<EventAvailabilityResponseDto, EventAvailabilityRequest>(
        (ref, request) async {
  final activeOwner = ref.watch(authSessionKeyProvider);
  if (!identical(activeOwner, request.owner)) {
    throw const EventDetailSessionChangedException();
  }
  final dataSource = ref.watch(eventsApiDataSourceProvider);
  final availability = await dataSource.getEventAvailability(request.eventId);
  if (!identical(ref.read(authSessionKeyProvider), request.owner)) {
    throw const EventDetailSessionChangedException();
  }
  return availability;
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
  late AuthSessionKey _sessionOwner;
  ProviderSubscription<AuthSessionKey>? _sessionSubscription;
  int _sessionGeneration = 0;
  String? _selectedSlotId;
  bool _isDescriptionExpanded = false;
  double _scrollOffset = 0;

  /// Garde-fou pour ne pas re-logger `event_viewed` à chaque rebuild quand
  /// l'AsyncValue passe à `data` à plusieurs reprises (refetch, invalidation).
  bool _loggedView = false;

  /// Cache des slots disponibles pour l'événement (pour obtenir le label de date)
  List<CalendarDateSlot> _availableSlots = [];

  static const int _maxDescriptionLength = 250;

  /// Read the currently-loaded [Event] from cache, or null if the state is
  /// loading, errored, or still in the `locked(shell)` branch.
  Event? _currentEvent() {
    final owner = ref.read(authSessionKeyProvider);
    final async = ref.read(
      eventDetailControllerProvider(eventDetailRequest(owner, widget.eventId)),
    );
    final state = async.valueOrNull;
    if (state is EventDetailLoaded) return state.event;
    return null;
  }

  double get _totalPrice {
    final event = _currentEvent();
    if (event == null) return 0.0;

    double total = 0.0;
    _ticketQuantities.forEach((ticketId, qty) {
      final ticket = event.tickets.firstWhere(
        (t) => t.id == ticketId,
        orElse: () => const Ticket(id: '', name: '', price: 0),
      );
      if (ticket.id.isNotEmpty) {
        total += ticket.buyerPrice * qty;
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

    final dateStr = context
        .appDateFormat('EEE d MMM', enPattern: 'EEE, MMM d')
        .format(slot.date);

    if (slot.startTime != null) {
      return context.eventDateAtTime(dateStr, slot.startTime!);
    }
    return dateStr;
  }

  /// Whether the booking bar should be hidden entirely
  bool _shouldHideBookingBar(Event event) {
    // Sold-out check only applies to vendor events with real inventory.
    // Platform events report spots_remaining: 0 because they don't
    // manage bookable inventory — the bar should still show for them.
    if (event.hasDirectBooking &&
        !event.organizerIsPlatform &&
        event.availableSeats != null &&
        event.availableSeats! <= 0) {
      return true;
    }

    // No bookable date → no point showing the bar's "select a date" CTA.
    return !_hasSelectableSlot(event);
  }

  /// Whether the event has at least one slot the customer could book
  /// today or later. While availability is still loading, returns true
  /// (optimistic) so the booking bar and ticket selectors stay live on
  /// first paint. Once availability resolves and reveals zero future
  /// slots, returns false — the screen then disables ticket selectors
  /// and hides the sticky booking bar.
  bool _hasSelectableSlot(Event event) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final id = _looksLikeUuid(event.id) ? event.id : widget.eventId;
    final owner = ref.watch(authSessionKeyProvider);
    final asyncAvail = ref.watch(
      eventAvailabilityProvider(eventAvailabilityRequest(owner, id)),
    );

    // Once availability has resolved (success or error), `_availableSlots`
    // is the authoritative cache: the success branch fills it from the
    // API and the error branch fills it from `event.calendar`.
    if (asyncAvail.hasValue || asyncAvail.hasError) {
      if (_availableSlots.isEmpty) return false;
      return _availableSlots.any((s) => !s.date.isBefore(today));
    }

    // Still loading — keep the optimistic UI; fall back to the event's
    // own end date so a clearly-past event stays disabled.
    return !event.endDate.isBefore(today);
  }

  /// Retourne le slot sélectionné
  CalendarDateSlot? get _selectedSlot {
    if (_selectedSlotId == null || _availableSlots.isEmpty) return null;
    final matches = _availableSlots.where((slot) => slot.id == _selectedSlotId);
    return matches.isEmpty ? null : matches.first;
  }

  bool _sameSlots(
    List<CalendarDateSlot> current,
    List<CalendarDateSlot> incoming,
  ) {
    if (current.length != incoming.length) return false;
    for (var index = 0; index < current.length; index++) {
      final left = current[index];
      final right = incoming[index];
      if (left.id != right.id ||
          left.date != right.date ||
          left.startTime != right.startTime ||
          left.endTime != right.endTime ||
          left.spotsRemaining != right.spotsRemaining ||
          left.totalCapacity != right.totalCapacity) {
        return false;
      }
    }
    return true;
  }

  void _replaceAvailableSlots(List<CalendarDateSlot> slots) {
    _availableSlots = slots;
    final selectedStillExists = slots.any((slot) => slot.id == _selectedSlotId);
    if (_selectedSlotId != null && !selectedStillExists) {
      _selectedSlotId = null;
      _ticketQuantities.clear();
    }
    if (slots.length == 1 && _selectedSlotId == null) {
      _selectedSlotId = slots.first.id;
    }
  }

  void _scheduleAvailableSlotsReplacement(
    List<CalendarDateSlot> slots,
    AuthSessionKey owner,
  ) {
    final generation = _sessionGeneration;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_ownsSession(owner, generation) ||
          _sameSlots(_availableSlots, slots)) {
        return;
      }
      setState(() => _replaceAvailableSlots(slots));
    });
  }

  @override
  void initState() {
    super.initState();
    _sessionOwner = ref.read(authSessionKeyProvider);
    _sessionSubscription = ref.listenManual<AuthSessionKey>(
      authSessionKeyProvider,
      (_, next) => _replaceSessionOwner(next),
    );
    _scrollController.addListener(_onScroll);
  }

  void _replaceSessionOwner(AuthSessionKey next, {bool notify = true}) {
    if (identical(next, _sessionOwner)) return;
    _sessionOwner = next;
    _sessionGeneration++;
    _selectedSlotId = null;
    _ticketQuantities.clear();
    _availableSlots = [];
    _loggedView = false;
    if (notify && mounted) setState(() {});
  }

  bool _ownsSession(AuthSessionKey owner, int generation) {
    return mounted &&
        generation == _sessionGeneration &&
        identical(owner, _sessionOwner) &&
        identical(ref.read(authSessionKeyProvider), owner);
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
  }

  @override
  void dispose() {
    _sessionGeneration++;
    _sessionSubscription?.close();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final owner = ref.watch(authSessionKeyProvider);
    if (!identical(owner, _sessionOwner)) {
      // The dependency can become dirty before the manual listener is
      // delivered. Clear all event-local booking state synchronously so no
      // previous-session selection survives this build.
      _replaceSessionOwner(owner, notify: false);
    }
    final renderGeneration = _sessionGeneration;
    final detailRequest = eventDetailRequest(owner, widget.eventId);
    final stateAsync = ref.watch(eventDetailControllerProvider(detailRequest));

    // Sticky booking bar is only meaningful when an Event is loaded — never
    // show it on top of the locked shell, the loading spinner, or an error.
    final loadedEvent = stateAsync.valueOrNull is EventDetailLoaded
        ? (stateAsync.value as EventDetailLoaded).event
        : null;

    // event_viewed — fire-once dès que l'event est chargé. `_loggedView`
    // empêche le re-fire sur invalidation/refetch.
    if (!_loggedView && loadedEvent != null) {
      _loggedView = true;
      final event = loadedEvent;
      debugPrint("event name test");
      ref.read(analyticsServiceProvider).logEvent(
        AnalyticsEvent.eventViewed,
        params: {
          AnalyticsParam.eventUuid: event.id,
          AnalyticsParam.category: event.category.name,
          AnalyticsParam.citySlug: event.city,
          AnalyticsParam.isFree: event.priceType == PriceType.free,
        },
      );
    }

    return Scaffold(
      // Flat design : fond gris clair pour créer hiérarchie avec cards blanches
      backgroundColor: HbColors.backgroundLight,
      body: stateAsync.when(
        data: (state) {
          switch (state) {
            case EventDetailLoaded(:final event):
              return _buildContent(event, owner, renderGeneration);
            case EventDetailLocked(:final shell):
              return EventLockedView(
                shell: shell,
                identifier: widget.eventId,
              );
          }
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: HbColors.brandPrimary),
        ),
        error: (error, stack) {
          // Spec MEMBERSHIPS §20: 403 with body { error: members_only }
          // is a non-fatal "you're not a member" gate, not an error.
          if (error is MembersOnlyException) {
            return MembersOnlyGate(
              organization: error.organization,
              ownerSession: owner,
            );
          }
          return _buildErrorState(error);
        },
      ),
      bottomNavigationBar:
          loadedEvent != null && !_shouldHideBookingBar(loadedEvent)
              ? _buildStickyBar(loadedEvent, owner, renderGeneration)
              : null,
    );
  }

  Widget _buildStickyBar(
    Event event,
    AuthSessionKey owner,
    int generation,
  ) {
    int reminderCount = 0;
    bool isSelectedSlotReminded = false;
    if (!event.hasDirectBooking) {
      final eventUuid = _looksLikeUuid(event.id) ? event.id : widget.eventId;
      final remindersAsync = ref.watch(
        eventRemindersProvider(
          (ownerSession: owner, eventUuid: eventUuid),
        ),
      );
      final remindedIds = remindersAsync.maybeWhen(
        data: (ids) => ids,
        orElse: () => <String>{},
      );
      reminderCount = remindedIds.length;
      if (_selectedSlotId != null) {
        isSelectedSlotReminded = remindedIds.contains(_selectedSlotId);
      }
    }

    return EventStickyBookingBar(
      event: event,
      ticketQuantities: _ticketQuantities,
      totalPrice: _totalPrice,
      selectedSlotId: _selectedSlotId,
      selectedDateLabel: _getSelectedDateLabel(),
      selectedSlot: _selectedSlot,
      onBookPressed: _onBookPressed,
      onViewDatesPressed: _scrollToDateSection,
      reminderCount: reminderCount,
      isSelectedSlotReminded: isSelectedSlotReminded,
      onReminderToggled: _selectedSlot != null
          ? () => _toggleReminder(
                event,
                _selectedSlot!,
                owner,
                generation,
              )
          : null,
    );
  }

  Widget _buildErrorState(Object error) {
    final message = ApiResponseHandler.extractError(
      error,
      fallback: context.l10n.eventLoadError,
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
                  onPressed: () =>
                      context.canPop() ? context.pop() : context.go('/'),
                  icon: const Icon(Icons.arrow_back, size: 18),
                  label: Text(context.l10n.commonBack),
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
                  onPressed: () {
                    final activeOwner = ref.read(authSessionKeyProvider);
                    ref.invalidate(
                      eventDetailControllerProvider(
                        eventDetailRequest(activeOwner, widget.eventId),
                      ),
                    );
                  },
                  icon: const Icon(Icons.refresh, size: 18),
                  label: Text(context.l10n.searchRetry),
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

  Widget _buildContent(
    Event event,
    AuthSessionKey owner,
    int sessionGeneration,
  ) {
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
                ownerSession: owner,
                videoUrl: event.socialMedia?.videoUrl,
                onViewAll: () => _openFullscreenGallery(
                  event,
                  0,
                  owner,
                  sessionGeneration,
                ),
                onImageTap: (index) => _openFullscreenGallery(
                  event,
                  index,
                  owner,
                  sessionGeneration,
                ),
              ),

              // AppBar overlay
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _buildOverlayAppBar(event, owner),
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
                ownerSession: owner,
                onOrganizerTap: () =>
                    context.push('/partner/${event.organizerId}'),
              ),

              const SizedBox(height: 24),

              // 5. Description (À propos)
              _buildDescriptionSection(event),

              const SizedBox(height: 24),

              // 5b. Tarification (discovery events only)
              if (!event.hasDirectBooking) ...[
                _buildPricingSection(event),
                const SizedBox(height: 24),
              ],

              if (!event.hasDirectBooking &&
                  event.indicativePrices.isNotEmpty) ...[
                EventIndicativePrices(prices: event.indicativePrices),
                const SizedBox(height: 24),
              ],

              // For booking events: dates + tickets right after pricing
              if (event.hasDirectBooking) ...[
                KeyedSubtree(
                  key: _dateSectionKey,
                  child: _buildDateSection(
                    event,
                    owner,
                    sessionGeneration,
                  ),
                ),
                const SizedBox(height: 24),
                if (event.tickets.isNotEmpty) ...[
                  EventTicketsSection(
                    tickets: event.tickets,
                    quantities: _ticketQuantities,
                    enabled: _hasSelectableSlot(event),
                    onQuantityChanged: (entry) {
                      if (!_ownsSession(owner, sessionGeneration)) return;
                      setState(() {
                        _ticketQuantities[entry.key] = entry.value;
                      });
                    },
                  ),
                  _buildRefundPolicyLink(event, owner, sessionGeneration),
                  const SizedBox(height: 24),
                ],
                // Services additionnels indicatifs (parking, restauration…)
                if (event.indicativePrices.isNotEmpty) ...[
                  EventIndicativePrices(prices: event.indicativePrices),
                  const SizedBox(height: 24),
                ],
              ],

              // 5c. Tags & caractéristiques
              _buildTagsSection(event),

              const SizedBox(height: 24),

              // 5d. Carte localisation
              EventLocationMap(
                event: event,
                ownerSession: owner,
                userLatitude: null, // TODO: get from location provider
                userLongitude: null,
              ),

              const SizedBox(height: 24),

              // For discovery events: dates + tickets in original position
              if (!event.hasDirectBooking) ...[
                KeyedSubtree(
                  key: _dateSectionKey,
                  child: _buildDateSection(
                    event,
                    owner,
                    sessionGeneration,
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // 7. Billets (only for discovery — booking already rendered above)
              if (!event.hasDirectBooking && event.tickets.isNotEmpty) ...[
                EventTicketsSection(
                  tickets: event.tickets,
                  quantities: _ticketQuantities,
                  enabled: _hasSelectableSlot(event),
                  onQuantityChanged: (entry) {
                    if (!_ownsSession(owner, sessionGeneration)) return;
                    setState(() {
                      _ticketQuantities[entry.key] = entry.value;
                    });
                  },
                ),
                _buildRefundPolicyLink(event, owner, sessionGeneration),
                const SizedBox(height: 24),
              ],

              // 8. Infos pratiques (grille 2x2)
              EventPracticalInfo(
                event: event,
                locationDetails: event.locationDetails,
                ownerSession: owner,
              ),

              const SizedBox(height: 24),

              // 9b. Accessibilité
              EventAccessibilitySection(
                locationDetails: event.locationDetails,
                ownerSession: owner,
              ),

              const SizedBox(height: 24),

              // 10. Avis (connecté à l'API)
              EventReviewsSection(
                eventSlug: event.slug,
                eventTitle: event.title,
                onWriteReview: () => _showWriteReviewDialog(
                  event,
                  owner,
                  sessionGeneration,
                ),
                onViewAll: () => _showAllReviews(
                  event,
                  owner,
                  sessionGeneration,
                ),
              ),

              const SizedBox(height: 24),

              // 11. Questions/Réponses — masqué pour les events dont
              // l'organisation est une plateforme (pas d'organisateur humain
              // pour répondre aux questions).
              if (!event.organizerIsPlatform) ...[
                EventQASection(
                  eventSlug: event.slug,
                  eventTitle: event.title,
                  ownerSession: owner,
                ),
                const SizedBox(height: 24),
              ],

              // 12. Activités associées (curated by organizer/backend)
              if (event.relatedEvents.isNotEmpty) ...[
                EventSimilarCarousel(
                  events: event.relatedEvents,
                  ownerSession: owner,
                  currentEventId: event.id,
                  title: context.l10n.eventRelatedActivities,
                  showPriceBadge: false,
                ),
                const SizedBox(height: 24),
              ],

              // 13. Événements similaires
              similarEventsAsync.when(
                data: (similarEvents) => similarEvents.isNotEmpty
                    ? EventSimilarCarousel(
                        events: similarEvents,
                        ownerSession: owner,
                        currentEventId: event.id,
                      )
                    : const SizedBox.shrink(),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),

              // 14. Espace pour la sticky bar
              SizedBox(height: MediaQuery.of(context).padding.bottom + 100),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRefundPolicyLink(
    Event event,
    AuthSessionKey owner,
    int generation,
  ) {
    final policy = event.vendorCancellationPolicy?.trim();
    if (policy == null || policy.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: TextButton(
          onPressed: () => _openRefundPolicy(
            event,
            owner,
            generation,
          ),
          style: TextButton.styleFrom(
            foregroundColor: HbColors.brandPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            context.l10n.eventRefundPolicyOpenLink,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverlayAppBar(Event event, AuthSessionKey owner) {
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
            // Deeplink/cold start : router.go() remplace la pile, donc rien à
            // pop. On retombe sur la home plutôt que de crasher ("nothing to pop").
            onTap: () => context.canPop() ? context.pop() : context.go('/'),
            darkMode: opacity < 0.5,
          ),
          const Spacer(),
          // Bouton partage (ouvre le nouveau sheet)
          ShareButton(
            event: event,
            ownerSession: owner,
            shareUrl: EnvConfig.eventShareUrl(event.slug),
            backgroundColor:
                opacity < 0.5 ? Colors.white : Colors.grey.shade100,
            iconColor: HbColors.textPrimary,
          ),
          const SizedBox(width: 8),
          FavoriteButton(
            event: event,
            ownerSession: owner,
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

  Widget _buildDateSection(
    Event event,
    AuthSessionKey owner,
    int generation,
  ) {
    final availabilityId = _looksLikeUuid(event.id) ? event.id : widget.eventId;
    final request = eventAvailabilityRequest(owner, availabilityId);
    final availabilityAsync = ref.watch(eventAvailabilityProvider(request));

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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: HbColors.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: HbColors.error.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.eventAvailabilityLoadError,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: HbColors.error,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ApiResponseHandler.extractError(
                      error,
                      fallback: context.l10n.eventAvailabilityLoadError,
                    ),
                    style: const TextStyle(
                      fontSize: 13,
                      color: HbColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () {
                      if (identical(ref.read(authSessionKeyProvider), owner)) {
                        ref.invalidate(eventAvailabilityProvider(request));
                      }
                    },
                    icon: const Icon(Icons.refresh, size: 18),
                    label: Text(context.l10n.commonRetry),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildDateSelectorFromEvent(event, owner, generation),
          ],
        );
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
            totalCapacity: slot.spotsTotal,
          );
        }).toList();

        // Stocker les slots pour pouvoir obtenir le label de date
        if (!_sameSlots(_availableSlots, slots)) {
          _scheduleAvailableSlotsReplacement(slots, owner);
        }

        if (slots.isEmpty) {
          return const SizedBox.shrink();
        }

        return _buildDateSelectorWidget(event, slots, owner, generation);
      },
    );
  }

  Widget _buildDateSelectorFromEvent(
    Event event,
    AuthSessionKey owner,
    int generation,
  ) {
    final slots = event.calendar?.dateSlots ?? [];

    // The fallback is authoritative while live availability is unavailable.
    // Clear stale API slots as well when the event payload has no fallback.
    if (!_sameSlots(_availableSlots, slots)) {
      _scheduleAvailableSlotsReplacement(slots, owner);
    }

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
                  context.l10n.eventDatesSoonAvailable,
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

    return _buildDateSelectorWidget(event, slots, owner, generation);
  }

  Widget _buildDateSelectorWidget(
    Event event,
    List<CalendarDateSlot> slots,
    AuthSessionKey owner,
    int generation,
  ) {
    return EventDateSelector(
      slots: slots,
      selectedSlotId: _selectedSlotId,
      onSlotSelected: (slot) {
        if (!_ownsSession(owner, generation)) return;
        HapticFeedback.selectionClick();
        setState(() => _selectedSlotId = slot.id);
      },
      onViewAllDates: () => _showAllDatesModal(slots, owner, generation),
    );
  }

  Future<void> _toggleReminder(
    Event event,
    CalendarDateSlot slot,
    AuthSessionKey owner,
    int generation,
  ) async {
    if (!_ownsSession(owner, generation)) return;
    final allowed = await GuestGuard.check(
      context: context,
      ref: ref,
      featureName: context.l10n.guestFeatureEnableReminder,
    );
    if (!allowed || !mounted || !_ownsSession(owner, generation)) return;

    final eventUuid = _looksLikeUuid(event.id) ? event.id : widget.eventId;
    final dataSource = ref.read(remindersApiDataSourceProvider);

    final remindersQuery = (ownerSession: owner, eventUuid: eventUuid);
    final remindersAsync = ref.read(eventRemindersProvider(remindersQuery));
    final currentIds = remindersAsync.maybeWhen(
      data: (ids) => ids,
      orElse: () => <String>{},
    );
    final isCurrentlyReminded = currentIds.contains(slot.id);
    final failureMessage = isCurrentlyReminded
        ? context.l10n.eventReminderRemoveFailed
        : context.l10n.eventReminderCreateFailed;

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
      if (!mounted || !_ownsSession(owner, generation)) return;
      // Refresh the provider to reflect the change
      ref.invalidate(eventRemindersProvider(remindersQuery));
      // Reminder signal changed — drop the personalized feed (spec §7).
      ref.invalidate(personalizedFeedProvider);
    } catch (e) {
      if (mounted && _ownsSession(owner, generation)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              ApiResponseHandler.extractError(e, fallback: failureMessage),
            ),
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
          Text(
            context.l10n.eventAboutTitle,
            style: const TextStyle(
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
                      _isDescriptionExpanded
                          ? context.l10n.searchShowLess
                          : context.l10n.eventReadMore,
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
          Text(
            context.l10n.eventPricingTitle,
            style: const TextStyle(
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
    switch (event.discoveryPricingType) {
      case 'free':
        return Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: HbColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                context.l10n.commonFree,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: HbColors.success,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                context.l10n.eventNoEntryFee,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ),
          ],
        );
      case 'paid':
        return Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: HbColors.brandPrimary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                context.l10n.searchPricePaid,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: HbColors.brandPrimary,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                event.discoveryPaidPriceLabel ?? context.l10n.eventUndefined,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: HbColors.textPrimary,
                ),
              ),
            ),
          ],
        );
      default:
        return Row(
          children: [
            Icon(Icons.info_outline, size: 16, color: Colors.grey.shade400),
            const SizedBox(width: 8),
            Text(
              context.l10n.eventUndefined,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        );
    }
  }

  Widget _buildTagsSection(Event event) {
    final chips = <_ChipEntry>[];
    final seen = <String>{};

    void addChip(String label, IconData icon, Color color) {
      final trimmed = label.trim();
      if (trimmed.isEmpty) return;
      final key = trimmed.toLowerCase();
      if (!seen.add(key)) return;
      chips.add(_ChipEntry(label: trimmed, icon: icon, color: color));
    }

    // Categories (all category names from API)
    for (final name in event.allCategoryNames) {
      addChip(name, Icons.category_outlined, HbColors.brandPrimary);
    }

    // Themes (plural API field, with legacy singular as fallback)
    for (final name in event.themeNames) {
      addChip(name, Icons.palette_outlined, Colors.indigo);
    }
    if (event.thematiqueName != null) {
      addChip(event.thematiqueName!, Icons.palette_outlined, Colors.indigo);
    }

    // Target audiences
    for (final term in event.targetAudienceTerms) {
      addChip(term.name, Icons.people_outline, Colors.blue);
    }

    // Emotions
    for (final name in event.emotionNames) {
      addChip(name, Icons.mood_outlined, Colors.orange);
    }

    if (chips.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.eventCharacteristicsTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: HbColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: chips
                .map((chip) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
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
                    ))
                .toList(),
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

  void _openFullscreenGallery(
    Event event,
    int initialIndex,
    AuthSessionKey owner,
    int generation,
  ) {
    if (!_ownsSession(owner, generation)) return;
    EventGalleryFullscreen.show(
      context,
      images: event.images,
      initialIndex: initialIndex,
      eventTitle: event.title,
      shareUrl: EnvConfig.eventShareUrl(event.slug),
      ownerSession: owner,
    );
  }

  void _openRefundPolicy(
    Event event,
    AuthSessionKey owner,
    int generation,
  ) {
    final policy = event.vendorCancellationPolicy?.trim();
    if (policy == null || policy.isEmpty) return;
    if (!_ownsSession(owner, generation)) return;

    context.push(
      '/refund-policy',
      extra: RefundPolicyRouteArgs(
        title: context.l10n.refundPolicyTitle,
        ownerAccountId: owner.accountId,
        policies: [
          RefundPolicyEntry(
            eventTitle: event.title,
            policy: policy,
          ),
        ],
      ),
    );
  }

  void _scrollToDateSection() {
    HapticFeedback.lightImpact();

    final keyContext = _dateSectionKey.currentContext;
    if (keyContext != null) {
      final box = keyContext.findRenderObject() as RenderBox;
      final scrollableBox = _scrollController.position.context.storageContext
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
      featureName: context.l10n.guestFeatureBookActivity,
    );
    if (!allowed) return;
    if (!mounted) return;

    final birthDate = ref.read(currentUserProvider)?.birthDate;
    if (!meetsMinimumBookingAge(birthDate)) {
      final messenger = ScaffoldMessenger.of(context);
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            context.l10n.eventBookingMinimumAgeRequired(
              minimumBookingAgeYears,
            ),
          ),
          backgroundColor: HbColors.error,
          duration: const Duration(seconds: 4),
        ),
      );
      return;
    }

    HapticFeedback.mediumImpact();
    final event = _currentEvent();
    if (event == null) return;

    final externalUrl = event.externalBooking?.url;
    if (externalUrl != null && externalUrl.isNotEmpty) {
      final uri = Uri.tryParse(externalUrl);
      if (uri != null) {
        try {
          final opened = await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
          if (opened) return;
        } catch (error) {
          debugPrint('Unable to open external booking link: $error');
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.eventOpenBookingLinkError),
              backgroundColor: HbColors.error,
            ),
          );
        }
        return;
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.eventInvalidBookingLink),
            duration: const Duration(seconds: 2),
          ),
        );
      }
      return;
    }

    // Vérification: date obligatoire
    if (_selectedSlotId == null) {
      _scrollToDateSection();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.eventChooseDateFirst),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    // Vérification: au moins un billet sélectionné
    if (_totalTickets == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.eventSelectAtLeastOneTicket),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    final selectionError = _selectionValidationMessage(event);
    if (selectionError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(selectionError),
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    _showBookingChoiceSheet(event);
  }

  String? _selectionValidationMessage(Event event) {
    for (final entry in _ticketQuantities.entries) {
      if (entry.value <= 0) continue;

      final matches = event.tickets.where((ticket) => ticket.id == entry.key);
      if (matches.isEmpty) {
        return context.l10n.bookingTicketAvailabilityChanged;
      }

      final ticket = matches.first;
      if (!ticket.isBookable) {
        return context.l10n.bookingTicketAvailabilityChanged;
      }
      if (entry.value < ticket.effectiveMinPerBooking) {
        return context.l10n
            .bookingTicketMinimumRequired(ticket.effectiveMinPerBooking);
      }
      if (entry.value > ticket.effectiveMaxPerBooking) {
        return context.l10n
            .bookingTicketMaximumAllowed(ticket.effectiveMaxPerBooking);
      }
    }

    final remainingForSlot = _selectedSlot?.spotsRemaining;
    if (remainingForSlot != null && _totalTickets > remainingForSlot) {
      return context.l10n.bookingTicketAvailabilityChanged;
    }
    return null;
  }

  bool _addSelectionToOwnedCart({
    required Event event,
    required String slotId,
    required CalendarDateSlot selectedSlot,
    required Map<String, int> ticketQuantities,
    required AuthSessionKey owner,
    required int generation,
    required OrderCartNotifier cartNotifier,
  }) {
    if (!_ownsSession(owner, generation) ||
        !identical(ref.read(orderCartProvider.notifier), cartNotifier)) {
      return false;
    }

    return cartNotifier.addSelection(
      event: event,
      slotId: slotId,
      selectedSlot: selectedSlot,
      ticketQuantities: ticketQuantities,
    );
  }

  void _showBookingChoiceSheet(Event event) {
    final owner = ref.read(authSessionKeyProvider);
    final ownerAccountId = owner.accountId;
    final generation = _sessionGeneration;
    final slotId = _selectedSlotId;
    final selectedSlot = _selectedSlot;
    if (ownerAccountId == null ||
        slotId == null ||
        selectedSlot == null ||
        !_ownsSession(owner, generation)) {
      return;
    }
    final ticketQuantities = Map<String, int>.unmodifiable(
      Map<String, int>.from(_ticketQuantities),
    );
    final cartNotifier = ref.read(orderCartProvider.notifier);

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return AccountBoundRouteGuard<void>(
          ownerAccountId: ownerAccountId,
          ownerSession: owner,
          builder: (guardedContext) => SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 44,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 18),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    alignment: Alignment.center,
                  ),
                  Text(
                    context.l10n.eventBookingChoiceTitle,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: HbColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.eventBookingChoiceBody,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 18),
                  OutlinedButton.icon(
                    onPressed: () {
                      final added = _addSelectionToOwnedCart(
                        event: event,
                        slotId: slotId,
                        selectedSlot: selectedSlot,
                        ticketQuantities: ticketQuantities,
                        owner: owner,
                        generation: generation,
                        cartNotifier: cartNotifier,
                      );
                      if (!added && !_ownsSession(owner, generation)) return;

                      // Capture the router + messenger before popping the sheet
                      // so the SnackBar action keeps a valid reference even after
                      // the sheet's BuildContext is gone.
                      final router = GoRouter.of(context);
                      final messenger = ScaffoldMessenger.of(context);
                      Navigator.of(sheetContext).pop();
                      if (!added) {
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text(
                              context.l10n.bookingTicketAvailabilityChanged,
                            ),
                          ),
                        );
                        return;
                      }
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(context.l10n.eventTicketsAddedToCart),
                          duration: const Duration(seconds: 6),
                          action: SnackBarAction(
                            label: context.l10n.eventView,
                            onPressed: () => router.push('/cart'),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add_shopping_cart),
                    label: Text(context.l10n.eventAddToCart),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      final added = _addSelectionToOwnedCart(
                        event: event,
                        slotId: slotId,
                        selectedSlot: selectedSlot,
                        ticketQuantities: ticketQuantities,
                        owner: owner,
                        generation: generation,
                        cartNotifier: cartNotifier,
                      );
                      if (!added && !_ownsSession(owner, generation)) return;

                      // Capture router before pop — sheetContext is disposed by
                      // Navigator.pop() and the navigation call would otherwise
                      // dereference a dead context (same trap as the
                      // "Ajouter au panier" button above).
                      final router = GoRouter.of(context);
                      final messenger = ScaffoldMessenger.of(context);
                      Navigator.of(sheetContext).pop();
                      if (!added) {
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text(
                              context.l10n.bookingTicketAvailabilityChanged,
                            ),
                          ),
                        );
                        return;
                      }
                      router.push('/cart');
                    },
                    icon: const Icon(Icons.lock),
                    label: Text(context.l10n.eventBookNow),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: HbColors.brandPrimary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAllDatesModal(
    List<CalendarDateSlot> slots,
    AuthSessionKey owner,
    int generation,
  ) {
    if (!_ownsSession(owner, generation)) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => AccountBoundRouteGuard<void>(
        ownerAccountId: owner.accountId,
        ownerSession: owner,
        builder: (_) => DraggableScrollableSheet(
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
                        context.eventAllDatesCount(slots.length),
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
                            if (!_ownsSession(owner, generation)) return;
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
      ),
    );
  }

  // --- Actions pour reviews et Q&A ---

  Future<void> _showWriteReviewDialog(
    Event event,
    AuthSessionKey owner,
    int generation,
  ) async {
    if (!_ownsSession(owner, generation)) return;
    final allowed = await GuestGuard.check(
      context: context,
      ref: ref,
      featureName: context.l10n.guestFeatureWriteReview,
    );
    if (!allowed || !mounted || !_ownsSession(owner, generation)) return;
    final ownerAccountId = owner.accountId;
    if (ownerAccountId == null) return;
    await WriteReviewSheet.show(
      context,
      eventSlug: event.slug,
      eventTitle: event.title,
      ownerSession: owner,
    );
  }

  void _showAllReviews(
    Event event,
    AuthSessionKey owner,
    int generation,
  ) {
    if (!_ownsSession(owner, generation)) return;
    context.push(
      '/event/${event.slug}/reviews',
      extra: {
        'title': event.title,
        'ownerSession': owner,
      },
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
                    _formatDate(context, slot.date),
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
                child: Text(
                  context.l10n.eventFull,
                  style: const TextStyle(
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
                child: Text(
                  context.l10n.eventChoose,
                  style: const TextStyle(
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

  String _formatDate(BuildContext context, DateTime date) {
    final formatted = context
        .appDateFormat('EEEE d MMMM', enPattern: 'EEEE, MMMM d')
        .format(date);
    if (formatted.isEmpty) return formatted;
    return formatted[0].toUpperCase() + formatted.substring(1);
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
