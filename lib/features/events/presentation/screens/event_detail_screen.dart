import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:lehiboo/core/utils/guest_guard.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../../domain/entities/event.dart';
import '../../domain/entities/event_submodels.dart';
import '../../domain/repositories/event_repository.dart';
import '../../data/datasources/events_api_datasource.dart';
import '../../data/models/event_availability_dto.dart';

/// Provider to fetch event details by ID
final eventDetailProvider = FutureProvider.family<Event, int>((ref, eventId) async {
  final repository = ref.watch(eventRepositoryProvider);
  return repository.getEventById(eventId);
});

/// Provider to fetch event availability (slots & tickets)
final eventAvailabilityProvider = FutureProvider.family<EventAvailabilityResponseDto, int>((ref, eventId) async {
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
  bool _showStickyTitle = false;
  int _currentImageIndex = 0;
  final Map<String, int> _ticketQuantities = {};
  bool _isFavorite = false;
  bool _isDescriptionExpanded = false;
  static const int _maxDescriptionLength = 250;

  // Simple getter for total price
  double get _totalPrice {
    final event = ref.read(eventDetailProvider(int.parse(widget.eventId))).valueOrNull;
    if (event == null) return 0.0;
    
    double total = 0.0;
    _ticketQuantities.forEach((ticketId, qty) {
      final ticket = event.tickets.firstWhere((t) => t.id == ticketId, orElse: () => const Ticket(id: '', name: '', price: 0));
      if (ticket.id.isNotEmpty) {
        total += ticket.price * qty;
      }
    });
    return total;
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Show sticky title > 300 offset
    if (_scrollController.hasClients) {
      final show = _scrollController.offset > 300;
      if (show != _showStickyTitle) {
        setState(() => _showStickyTitle = show);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventAsync = ref.watch(eventDetailProvider(int.parse(widget.eventId)));

    return Scaffold(
      backgroundColor: Colors.white,
      body: eventAsync.when(
        data: (event) => _buildContent(event),
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFFFF601F)),
        ),
        error: (error, stack) => _buildErrorState(error),
      ),
      bottomNavigationBar: eventAsync.valueOrNull != null
          ? _buildStickyBookingBar(eventAsync.value!)
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
            const Icon(Icons.error_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Impossible de charger l\'activité',
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(), // Debug info
              style: const TextStyle(fontSize: 12, color: Colors.red),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Retour'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF601F),
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
        // 1. Premium Hero Header
        SliverAppBar(
          expandedHeight: 380,
          pinned: true,
          stretch: true,
          backgroundColor: Colors.white,
          leading: _buildCircularButton(
            icon: Icons.arrow_back,
            onTap: () => context.pop(),
          ),
          actions: [
          _buildCircularButton(
            icon: Icons.share_outlined,
            onTap: () async {
              await Share.share(
                'Découvre cette activité : ${event.title}\nhttps://lehiboo.com/events/${event.id}',
                subject: event.title,
              );
            },
          ),
          const SizedBox(width: 8),
          _buildCircularButton(
            icon: _isFavorite ? Icons.favorite : Icons.favorite_border,
            color: _isFavorite ? Colors.red : null,
            onTap: () async {
               final canProceed = await GuestGuard.check(
                  context: context,
                  ref: ref,
                  featureName: 'fav',
                );
                if (canProceed) {
                  setState(() => _isFavorite = !_isFavorite);
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_isFavorite ? 'Ajouté aux favoris' : 'Retiré des favoris'),
                      duration: const Duration(seconds: 1),
                    )
                  );
                }
            },
          ),
          const SizedBox(width: 12),
        ],
        flexibleSpace: FlexibleSpaceBar(
          stretchModes: const [StretchMode.zoomBackground],
          titlePadding: const EdgeInsets.only(left: 56, right: 80, bottom: 16),
          title: _showStickyTitle
              ? Text(
                  event.title,
                  style: const TextStyle(
                    color: Color(0xFF1A1A2E),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )
              : null,
          background: _buildHeroGallery(event),
        ),
      ),

        // 2. Main Content Body
        SliverToBoxAdapter(
          child: Transform.translate(
            offset: const Offset(0, -20),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 16,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // A. Header Section (Title, Organizer, Tags)
                    _buildHeaderSection(event),
                    
                    const SizedBox(height: 32),
                    
                    // B. Key Info Grid (Date, Location with Map Preview)
                    _buildInfoGrid(event),
                    
                    const SizedBox(height: 32),

                    // C. Description with Read More
                    _buildDescriptionSection(event),

                    // D. Services Icons
                    if (event.extraServices.isNotEmpty)
                      _buildServicesSection(event.extraServices),

                    // E. Rich Location Details (Parking, Transport, PMR)
                    if (event.locationDetails != null)
                      _buildLocationDetailsSection(event.locationDetails!),
                    
                    const SizedBox(height: 32),

                    // F. Upcoming Dates
                    _buildDateList(event),

                    const SizedBox(height: 32),

                    // G. Tickets Selection
                    if (event.tickets.isNotEmpty) ...[
                       Text(
                        'Billets',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                       const SizedBox(height: 16),
                       ...event.tickets.map((t) => _buildTicketCard(t)),
                    ],

                    const SizedBox(height: 32),

                    // H. Organizer & Co-organizers
                    _buildOrganizerSection(event),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- Components ---

  Widget _buildHeroGallery(Event event) {
    if (event.images.isEmpty) {
       return Container(
         color: Colors.grey[200],
         child: const Center(child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey)),
       );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 400,
            viewportFraction: 1.0,
            enableInfiniteScroll: event.images.length > 1,
            autoPlay: false,
            onPageChanged: (index, reason) {
              setState(() => _currentImageIndex = index);
            },
          ),
          items: event.images.map((url) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => Scaffold(
                    backgroundColor: Colors.black,
                    appBar: AppBar(backgroundColor: Colors.black, iconTheme: const IconThemeData(color: Colors.white)),
                    body: InteractiveViewer(
                      child: Center(
                        child: CachedNetworkImage(imageUrl: url),
                      ),
                    ),
                  ),
                ));
              },
              child: CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                width: double.infinity,
                placeholder: (context, url) => Container(color: Colors.grey[100]),
                errorWidget: (context, url, err) => Container(color: Colors.grey[200]),
              ),
            );
          }).toList(),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.transparent,
                    Colors.black.withOpacity(0.0),
                  ],
                  stops: const [0.0, 0.4, 1.0],
                ),
              ),
            ),
          ),
        ),
        if (event.images.length > 1)
          Positioned(
            bottom: 40,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${_currentImageIndex + 1} / ${event.images.length}',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ),
        // Video button if URL exists (generic place for now)
        if (event.socialMedia?.videoUrl != null)
           Positioned(
             bottom: 40,
             left: 20,
             child: InkWell(
               onTap: () => launchUrl(Uri.parse(event.socialMedia!.videoUrl!)),
               child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.play_circle_fill, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text('Voir la vidéo', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
               ),
             )
           )
      ],
    );
  }

  Widget _buildHeaderSection(Event event) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            InkWell(
              onTap: () => context.push('/partner/${event.organizerId}'),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF601F).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  event.organizerName.toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xFFFF601F),
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          event.title,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1A2E),
            height: 1.1,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
             if (event.categoryLabel.isNotEmpty)
               _buildTag(Icons.local_activity_outlined, event.categoryLabel),
             if (event.audienceLabel.isNotEmpty)
                _buildTag(Icons.people_outline, event.audienceLabel),
             _buildTag(Icons.schedule, event.durationLabel),
          ],
        ),
      ],
    );
  }

  Widget _buildTag(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoGrid(Event event) {
    return Column(
      children: [
        Row(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Container(
               padding: const EdgeInsets.all(12),
               decoration: BoxDecoration(
                 color: const Color(0xFFF3F4F6),
                 borderRadius: BorderRadius.circular(12),
               ),
               child: const Icon(Icons.calendar_month, color: Color(0xFF1A1A2E)),
             ),
             const SizedBox(width: 16),
             Expanded(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   const Text(
                     'Date et heure',
                     style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E)),
                   ),
                   const SizedBox(height: 4),
                   Text(
                     DateFormat('EEEE d MMMM yyyy, HH:mm', 'fr_FR').format(event.startDate),
                     style: TextStyle(color: Colors.grey[600], fontSize: 14),
                   ),
                 ],
               ),
             ),
           ],
        ),
        const SizedBox(height: 24),
        Row(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Container(
               padding: const EdgeInsets.all(12),
               decoration: BoxDecoration(
                 color: const Color(0xFFF3F4F6),
                 borderRadius: BorderRadius.circular(12),
               ),
               child: const Icon(Icons.location_on_outlined, color: Color(0xFF1A1A2E)),
             ),
             const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Lieu',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E)),
                    ),
                    const SizedBox(height: 4),
                    if (event.venue.isNotEmpty)
                      Text(
                        event.venue,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    if (event.address.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          '${event.address}${event.city.isNotEmpty ? ', ${event.city}' : ''}',
                          style: TextStyle(color: Colors.grey[500], fontSize: 13),
                        ),
                      ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final query = event.address.isNotEmpty 
                              ? Uri.encodeComponent('${event.address}, ${event.city}') 
                              : '${event.latitude},${event.longitude}';
                          final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url, mode: LaunchMode.externalApplication);
                          }
                        },
                        icon: const Icon(Icons.directions, size: 18),
                        label: const Text('Se rendre sur le lieu'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFFF601F),
                          side: const BorderSide(color: Color(0xFFFF601F)),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
           ],
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(Event event) {
    final description = event.description;
    final isLongText = description.length > _maxDescriptionLength;
    final displayText = _isDescriptionExpanded || !isLongText
        ? description
        : '${description.substring(0, _maxDescriptionLength)}...';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Détails de l\'activité',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          displayText,
          style: TextStyle(
            fontSize: 16,
            height: 1.6,
            color: Colors.grey[800],
          ),
        ),
        if (isLongText || (event.fullDescription != null && event.fullDescription!.isNotEmpty))
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: GestureDetector(
              onTap: () {
                if (event.fullDescription != null && event.fullDescription!.isNotEmpty) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => FullDescriptionScreen(htmlContent: event.fullDescription!, title: event.title),
                  ));
                } else {
                  setState(() => _isDescriptionExpanded = !_isDescriptionExpanded);
                }
              },
              child: Text(
                event.fullDescription != null && event.fullDescription!.isNotEmpty
                    ? 'Lire la suite'
                    : (_isDescriptionExpanded ? 'Voir moins' : 'Lire la suite'),
                style: const TextStyle(
                  color: Color(0xFFFF601F),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          )
      ],
    );
  }

  Widget _buildServicesSection(List<ExtraService> services) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Services & Accessibilité',
             style: Theme.of(context).textTheme.titleLarge?.copyWith(
               fontWeight: FontWeight.bold,
               color: const Color(0xFF1A1A2E),
             ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: services.map((s) => _buildServiceChip(s)).toList(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildServiceChip(ExtraService service) {
    // Basic icon mapping based on name keywords since we might not have dynamic icons yet
    IconData icon = Icons.info_outline;
    final nameLower = service.name.toLowerCase();
    
    if (nameLower.contains('handicap') || nameLower.contains('pmr')) icon = Icons.accessible;
    else if (nameLower.contains('animaux')) icon = Icons.pets;
    else if (nameLower.contains('bébé') || nameLower.contains('enfant')) icon = Icons.child_friendly;
    else if (nameLower.contains('wifi')) icon = Icons.wifi;
    else if (nameLower.contains('parking')) icon = Icons.local_parking;
    else if (nameLower.contains('restauration') || nameLower.contains('manger')) icon = Icons.restaurant;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF1A1A2E)),
          const SizedBox(width: 8),
          Text(service.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E))),
        ],
      ),
    );
  }

  Widget _buildLocationDetailsSection(LocationDetails details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         const SizedBox(height: 32),
         Text(
            'Infos Pratiques',
             style: Theme.of(context).textTheme.titleLarge?.copyWith(
               fontWeight: FontWeight.bold,
               color: const Color(0xFF1A1A2E),
             ),
          ),
          const SizedBox(height: 16),
          if (details.parking != null && details.parking!.description.isNotEmpty)
             _buildRichInfoRow(Icons.local_parking, 'Stationnement', details.parking!),
          
          if (details.transport != null && details.transport!.description.isNotEmpty)
             _buildRichInfoRow(Icons.directions_bus, 'Accès & Transports', details.transport!),

          if (details.pmr != null && details.pmr!.available)
             _buildAccessRow(Icons.accessible, 'Accessible PMR', details.pmr!.note),
             
          if (details.food != null && details.food!.available)
             _buildAccessRow(Icons.restaurant, 'Restauration sur place', details.food!.note),
             
          if (details.drinks != null && details.drinks!.available)
             _buildAccessRow(Icons.local_bar, 'Boissons sur place', details.drinks!.note),
      ],
    );
  }

  Widget _buildRichInfoRow(IconData icon, String title, RichInfoConfig config) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: const Color(0xFFFF601F)),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 8),
          Text(config.description, style: TextStyle(color: Colors.grey[700], height: 1.5)),
          if (config.imageUrl != null && config.imageUrl!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: config.imageUrl!,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAccessRow(IconData icon, String title, String? note) {
     return Padding(
       padding: const EdgeInsets.only(bottom: 12),
       child: Row(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Icon(icon, size: 20, color: Colors.green),
           const SizedBox(width: 12),
           Expanded(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                 if (note != null && note.isNotEmpty)
                   Padding(
                     padding: const EdgeInsets.only(top: 4),
                     child: Text(note, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                   ),
               ],
             ),
           ),
         ],
       ),
     );
  }

  Widget _buildDateList(Event event) {
    final eventId = int.tryParse(event.id) ?? 0;
    final availabilityAsync = ref.watch(eventAvailabilityProvider(eventId));

    return availabilityAsync.when(
      loading: () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choisissez une date',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Center(child: CircularProgressIndicator(color: Color(0xFFFF601F))),
        ],
      ),
      error: (error, stack) {
        // Fall back to calendar data from main event response
        return _buildDateListFromEvent(event);
      },
      data: (availability) {
        final slots = availability.slots;
        final recurrence = availability.recurrence;
        
        // If no slots and no recurrence, hide section
        if (slots.isEmpty && recurrence == null) {
          return const SizedBox.shrink();
        }

        const int maxVisibleSlots = 5;
        final hasMore = slots.length > maxVisibleSlots;
        final visibleSlots = hasMore ? slots.take(maxVisibleSlots).toList() : slots;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choisissez une date',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            if (slots.isNotEmpty)
              ...visibleSlots.map((slot) => _buildAvailabilitySlotCard(slot))
            else if (recurrence != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.replay, color: Color(0xFF4F46E5)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Cet événement est récurrent (${recurrence.frequency}). Vérifiez les disponibilités lors de la réservation.',
                        style: const TextStyle(color: Color(0xFF3730A3), fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            
            if (hasMore)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Center(
                  child: OutlinedButton.icon(
                    onPressed: () => _showAllAvailabilitySlotsModal(slots),
                    icon: const Icon(Icons.calendar_month),
                    label: Text('Voir toutes les dates (${slots.length})'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFFF601F),
                      side: const BorderSide(color: Color(0xFFFF601F)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  /// Fallback to calendar data from main event if availability endpoint fails
  Widget _buildDateListFromEvent(Event event) {
    final slots = event.calendar?.dateSlots ?? [];
    
    if (slots.isEmpty && event.recurrence == null) {
      return const SizedBox.shrink();
    }

    const int maxVisibleSlots = 5;
    final hasMore = slots.length > maxVisibleSlots;
    final visibleSlots = hasMore ? slots.take(maxVisibleSlots).toList() : slots;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choisissez une date',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        if (slots.isNotEmpty)
          ...visibleSlots.map((slot) => _buildDateSlotCard(slot, event))
        else if (event.recurrence != null)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.replay, color: Color(0xFF4F46E5)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Cet événement est récurrent (${event.recurrence!.frequency}). Vérifiez les disponibilités lors de la réservation.',
                    style: const TextStyle(color: Color(0xFF3730A3), fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        
        if (hasMore)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Center(
              child: OutlinedButton.icon(
                onPressed: () => _showAllDatesModal(slots, event),
                icon: const Icon(Icons.calendar_month),
                label: Text('Voir toutes les dates (${slots.length})'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFFF601F),
                  side: const BorderSide(color: Color(0xFFFF601F)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDateSlotCard(CalendarDateSlot slot, Event event) {
    final dateFormat = DateFormat('EEEE d MMMM', 'fr');
    final formattedDate = dateFormat.format(slot.date);
    final capitalizedDate = formattedDate[0].toUpperCase() + formattedDate.substring(1);
    
    // Build time string
    String timeString = '';
    if (slot.startTime != null) {
      timeString = slot.startTime!;
      if (slot.endTime != null) {
        timeString += ' – ${slot.endTime}';
      }
    }

    // Availability text
    String availabilityText = '';
    if (slot.spotsRemaining != null) {
      availabilityText = '${slot.spotsRemaining} places disponibles';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  capitalizedDate,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                if (timeString.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    timeString,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
                if (availabilityText.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    availabilityText,
                    style: TextStyle(
                      fontSize: 13,
                      color: slot.spotsRemaining == 0 ? Colors.red : Colors.grey[500],
                    ),
                  ),
                ],
              ],
            ),
          ),
          OutlinedButton(
            onPressed: slot.spotsRemaining == 0 ? null : () {
              // Scroll to tickets section or trigger booking flow
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sélectionnez vos billets ci-dessous'), duration: Duration(seconds: 2)),
              );
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFFF601F),
              side: BorderSide(color: slot.spotsRemaining == 0 ? Colors.grey[300]! : const Color(0xFFFF601F)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text('Réserver'),
          ),
        ],
      ),
    );
  }

  void _showAllDatesModal(List<CalendarDateSlot> slots, Event event) {
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
                  color: Colors.grey[300],
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
                  itemBuilder: (context, index) => _buildDateSlotCard(slots[index], event),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }  

  Widget _buildAvailabilitySlotCard(AvailabilitySlotDto slot) {
    // Parse date
    DateTime date;
    try {
      date = DateTime.parse(slot.date);
    } catch (_) {
      // Try dd-MM-yyyy format
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

    final dateFormat = DateFormat('EEEE d MMMM', 'fr');
    final formattedDate = dateFormat.format(date);
    final capitalizedDate = formattedDate[0].toUpperCase() + formattedDate.substring(1);
    
    // Build time string
    String timeString = '';
    if (slot.startTime != null) {
      timeString = slot.startTime!;
      if (slot.endTime != null) {
        timeString += ' – ${slot.endTime}';
      }
    }

    // Availability text
    String availabilityText = '';
    if (slot.spotsRemaining != null) {
      availabilityText = '${slot.spotsRemaining} places disponibles';
    }

    final isDisabled = !slot.isAvailable || slot.spotsRemaining == 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDisabled ? Colors.grey[300]! : Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  capitalizedDate,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDisabled ? Colors.grey : const Color(0xFF1A1A2E),
                  ),
                ),
                if (timeString.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    timeString,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDisabled ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
                if (availabilityText.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    availabilityText,
                    style: TextStyle(
                      fontSize: 13,
                      color: slot.spotsRemaining == 0 ? Colors.red : Colors.grey[500],
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (slot.isAvailable && (slot.spotsRemaining == null || slot.spotsRemaining! > 0))
            OutlinedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sélectionnez vos billets ci-dessous'), duration: Duration(seconds: 2)),
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFFF601F),
                side: const BorderSide(color: Color(0xFFFF601F)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text('Réserver'),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('Complet', style: TextStyle(color: Colors.grey)),
            ),
        ],
      ),
    );
  }

  void _showAllAvailabilitySlotsModal(List<AvailabilitySlotDto> slots) {
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
                  color: Colors.grey[300],
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
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  itemBuilder: (context, index) => _buildAvailabilitySlotCard(slots[index]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTicketCard(Ticket ticket) {
    int qty = _ticketQuantities[ticket.id] ?? 0;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: qty > 0 ? const Color(0xFFFF601F) : Colors.grey[200]!, 
          width: qty > 0 ? 2 : 1
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ticket.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                if (ticket.description != null && ticket.description!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                     ticket.description!,
                     style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
                 const SizedBox(height: 8),
                 Text(
                   ticket.price > 0 ? '${ticket.price.toStringAsFixed(2)} €' : 'Gratuit',
                   style: const TextStyle(
                     fontSize: 16,
                     fontWeight: FontWeight.w600,
                     color: Color(0xFFFF601F),
                   ),
                 ),
              ],
            ),
          ),
          Container(
             height: 40,
             decoration: BoxDecoration(
               color: Colors.grey[50],
               borderRadius: BorderRadius.circular(12),
               border: Border.all(color: Colors.grey[300]!),
             ),
             child: Row(
               mainAxisSize: MainAxisSize.min,
               children: [
                 IconButton(
                   icon: const Icon(Icons.remove),
                   padding: EdgeInsets.zero,
                   iconSize: 18,
                   constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                   color: qty > 0 ? Colors.black : Colors.grey,
                   onPressed: qty > 0 ? () => setState(() => _ticketQuantities[ticket.id] = qty - 1) : null,
                 ),
                 Text(
                   '$qty',
                   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                 ),
                 IconButton(
                   icon: const Icon(Icons.add),
                   padding: EdgeInsets.zero,
                   iconSize: 18,
                   constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                   onPressed: () => setState(() => _ticketQuantities[ticket.id] = qty + 1),
                 ),
               ],
             ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildOrganizerSection(Event event) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildOrganizerProfile(event.organizerId, event.organizerName, event.organizerLogo, true),
        
        if (event.coOrganizers.isNotEmpty) ...[
          const SizedBox(height: 24),
          const Text(
             'Co-organisateurs',
             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E)),
          ),
          const SizedBox(height: 12),
          ...event.coOrganizers.map((co) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildOrganizerProfile(co.id, co.name, co.imageUrl, false, role: co.role),
          )),
        ]
      ],
    );
  }

  Widget _buildOrganizerProfile(String id, String name, String? image, bool isMain, {String? role}) {
    return InkWell(
      onTap: () => context.push('/partner/$id'),
      child: Row(
        children: [
          CircleAvatar(
            radius: isMain ? 24 : 20,
             backgroundColor: Colors.grey[200],
             backgroundImage: image != null ? NetworkImage(image) : null,
             child: image == null 
                ? Text(name.isNotEmpty ? name[0] : '?', style: TextStyle(color: const Color(0xFFFF601F), fontWeight: FontWeight.bold, fontSize: isMain ? 20 : 16))
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isMain ? 'Organisé par' : (role ?? 'Co-organisateur'),
                  style: TextStyle(fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.w500),
                ),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: isMain ? 15 : 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
              ],
            ),
          ),
          if (isMain)
            TextButton(
              onPressed: () => context.push('/partner/$id'),
              style: TextButton.styleFrom(foregroundColor: const Color(0xFFFF601F)),
              child: const Text('Voir le profil'),
            )
        ],
      ),
    );
  }

  Widget _buildCircularButton({required IconData icon, required VoidCallback onTap, Color? color}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
           BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: 20, color: color ?? const Color(0xFF1A1A2E)),
        onPressed: onTap,
        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
        style: IconButton.styleFrom(padding: EdgeInsets.zero),
      ),
    );
  }

  Widget _buildStickyBookingBar(Event event) {
    // Basic null check for safety
    final hasSelection = _ticketQuantities.values.fold(0, (sum, q) => sum + q) > 0;
    final totalPrice = _totalPrice;
    final isExternal = event.externalBooking != null;

    return Container(
      padding: EdgeInsets.fromLTRB(24, 16, 24, MediaQuery.of(context).padding.bottom + 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea( 
        top: false,
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasSelection ? 'Total' : 'À partir de',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.w500),
                ),
                Text(
                   hasSelection ? '${totalPrice.toStringAsFixed(2)} €' : event.formattedPrice,
                   style: const TextStyle(
                     fontSize: 20,
                     fontWeight: FontWeight.w800,
                     color: Color(0xFFFF601F),
                   ),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: !hasSelection && !isExternal ? null : () {
                 if (isExternal) {
                   // Open external link
                 } else {
                   // Proceed to booking
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Réservation implémentée prochainement')));
                 }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF601F),
                disabledBackgroundColor: Colors.grey[300],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: Text(
                isExternal ? 'Voir le site' : (hasSelection ? 'Réserver' : 'Choisir'),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Simple screen to show full HTML description
class FullDescriptionScreen extends StatelessWidget {
  final String htmlContent;
  final String title;

  const FullDescriptionScreen({super.key, required this.htmlContent, required this.title});

  String _stripHtml(String html) {
    // Basic stripping (Replace this with html package if needed later)
    return html.replaceAll(RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true), '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontSize: 16)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Text(
          _stripHtml(htmlContent), // For safety without html renderer
          style: const TextStyle(fontSize: 16, height: 1.6, color: Color(0xFF1A1A2E)),
        ),
      ),
    );
  }
}