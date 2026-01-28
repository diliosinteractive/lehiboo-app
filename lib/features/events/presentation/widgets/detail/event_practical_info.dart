import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import 'package:lehiboo/features/events/domain/entities/event_submodels.dart';
import 'package:lehiboo/features/events/presentation/widgets/detail/practical_info_card.dart';
import 'package:lehiboo/features/events/presentation/widgets/detail/practical_info_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

/// Section informations pratiques avec grille 2x2
///
/// Features Material Expressive:
/// - Grille 2x2 de cards avec animations staggered
/// - Tap card → Bottom sheet avec détails
/// - Section parking et transports avec liens Google Maps
/// - Chips accessibilité (PMR, Food, Drinks)
class EventPracticalInfo extends StatefulWidget {
  final Event event;
  final LocationDetails? locationDetails;

  const EventPracticalInfo({
    super.key,
    required this.event,
    this.locationDetails,
  });

  @override
  State<EventPracticalInfo> createState() => _EventPracticalInfoState();
}

class _EventPracticalInfoState extends State<EventPracticalInfo> {
  bool get _hasLocation =>
      (widget.event.venue != null && widget.event.venue!.isNotEmpty) ||
      (widget.event.address != null && widget.event.address!.isNotEmpty);

  bool get _hasParking =>
      widget.locationDetails?.parking != null &&
      widget.locationDetails!.parking!.description != null;

  bool get _hasTransport =>
      widget.locationDetails?.transport != null &&
      widget.locationDetails!.transport!.description != null;

  bool get _hasPmr => widget.locationDetails?.pmr?.available == true;
  bool get _hasFood => widget.locationDetails?.food?.available == true;
  bool get _hasDrinks => widget.locationDetails?.drinks?.available == true;

  bool get _hasAccessibility => _hasPmr || _hasFood || _hasDrinks;

  // _hasLocation retiré car géré par la section Localisation (carte)
  bool get _hasAnyInfo =>
      _hasParking || _hasTransport || _hasAccessibility;

  @override
  Widget build(BuildContext context) {
    if (!_hasAnyInfo) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Infos pratiques',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: HbColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Grille 2x2 principale
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildMainGrid(),
        ),

        // Chips accessibilité
        if (_hasAccessibility) ...[
          const SizedBox(height: 16),
          _buildAccessibilityChips(),
        ],
      ],
    );
  }

  Widget _buildMainGrid() {
    final cards = <Widget>[];

    // Card Lieu supprimée - redondante avec la section Localisation (carte)
    // qui affiche déjà l'adresse, la carte et les boutons d'action

    // Card Parking
    if (_hasParking) {
      cards.add(
        PracticalInfoCard(
          icon: Icons.local_parking_outlined,
          title: 'Parking',
          subtitle: 'Places disponibles',
          color: Colors.blue,
          onTap: () => _showParkingSheet(),
        ),
      );
    }

    // Card Transport
    if (_hasTransport) {
      cards.add(
        PracticalInfoCard(
          icon: Icons.directions_bus_outlined,
          title: 'Transports',
          subtitle: 'Bus, métro, tram',
          color: Colors.green,
          onTap: () => _showTransportSheet(),
        ),
      );
    }

    // Si on n'a pas assez de cards, on ajoute des placeholders
    if (cards.isEmpty) return const SizedBox.shrink();

    // Grille 2 colonnes
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 300 + (index * 100)),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Opacity(
                // Clamp pour éviter les valeurs > 1 avec easeOutBack
                opacity: value.clamp(0.0, 1.0),
                child: child,
              ),
            );
          },
          child: cards[index],
        );
      },
    );
  }

  Widget _buildAccessibilityChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          if (_hasPmr)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CompactInfoChip(
                icon: Icons.accessible,
                label: 'Accessible PMR',
                color: Colors.blue,
                onTap: () => _showAccessibilitySheet(
                  icon: Icons.accessible,
                  title: 'Accessibilité PMR',
                  note: widget.locationDetails?.pmr?.note,
                ),
              ),
            ),
          if (_hasFood)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CompactInfoChip(
                icon: Icons.restaurant,
                label: 'Restauration',
                color: Colors.orange,
                onTap: () => _showAccessibilitySheet(
                  icon: Icons.restaurant,
                  title: 'Restauration sur place',
                  note: widget.locationDetails?.food?.note,
                ),
              ),
            ),
          if (_hasDrinks)
            CompactInfoChip(
              icon: Icons.local_bar,
              label: 'Boissons',
              color: Colors.purple,
              onTap: () => _showAccessibilitySheet(
                icon: Icons.local_bar,
                title: 'Boissons disponibles',
                note: widget.locationDetails?.drinks?.note,
              ),
            ),
        ],
      ),
    );
  }

  void _showLocationSheet() {
    final lat = widget.event.latitude;
    final lng = widget.event.longitude;
    final address = _buildFullAddress();

    PracticalInfoSheet.show(
      context,
      icon: Icons.location_on,
      title: widget.event.venue ?? 'Lieu',
      description: address,
      color: HbColors.brandPrimary,
      actions: [
        if (lat != null && lng != null) ...[
          PracticalInfoActions.googleMaps(lat: lat, lng: lng),
          PracticalInfoActions.walkingDirections(lat: lat, lng: lng),
          PracticalInfoActions.publicTransport(lat: lat, lng: lng),
        ],
        if (address.isNotEmpty)
          PracticalInfoActions.copyAddress(address: address, context: context),
      ],
    );
  }

  void _showParkingSheet() {
    final parking = widget.locationDetails?.parking;
    if (parking == null) return;

    final lat = widget.event.latitude;
    final lng = widget.event.longitude;

    PracticalInfoSheet.show(
      context,
      icon: Icons.local_parking,
      title: 'Stationnement',
      description: parking.description,
      imageUrl: parking.imageUrl,
      color: Colors.blue,
      actions: lat != null && lng != null
          ? [
              PracticalInfoActions.googleMaps(
                lat: lat,
                lng: lng,
                label: 'Naviguer vers le parking',
              ),
            ]
          : null,
    );
  }

  void _showTransportSheet() {
    final transport = widget.locationDetails?.transport;
    if (transport == null) return;

    final lat = widget.event.latitude;
    final lng = widget.event.longitude;

    PracticalInfoSheet.show(
      context,
      icon: Icons.directions_bus,
      title: 'Transports en commun',
      description: transport.description,
      imageUrl: transport.imageUrl,
      color: Colors.green,
      actions: lat != null && lng != null
          ? [
              PracticalInfoActions.publicTransport(lat: lat, lng: lng),
            ]
          : null,
    );
  }

  void _showAccessibilitySheet({
    required IconData icon,
    required String title,
    String? note,
  }) {
    PracticalInfoSheet.show(
      context,
      icon: icon,
      title: title,
      description: note ?? 'Ce service est disponible sur place.',
      color: HbColors.brandPrimary,
    );
  }

  String _buildFullAddress() {
    final parts = <String>[];
    if (widget.event.address != null && widget.event.address!.isNotEmpty) {
      parts.add(widget.event.address!);
    }
    if (widget.event.postalCode != null && widget.event.postalCode!.isNotEmpty) {
      parts.add(widget.event.postalCode!);
    }
    if (widget.event.city != null && widget.event.city!.isNotEmpty) {
      parts.add(widget.event.city!);
    }
    return parts.join(', ');
  }
}
