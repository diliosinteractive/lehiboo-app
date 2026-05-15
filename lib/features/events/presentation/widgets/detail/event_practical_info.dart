import 'package:flutter/material.dart';
import 'package:lehiboo/core/l10n/l10n.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import 'package:lehiboo/features/events/domain/entities/event_submodels.dart';
import 'package:lehiboo/features/events/presentation/utils/event_l10n.dart';
import 'package:lehiboo/features/events/presentation/widgets/detail/practical_info_card.dart';
import 'package:lehiboo/features/events/presentation/widgets/detail/practical_info_sheet.dart';

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

  bool get _hasFood => widget.locationDetails?.food?.available == true;
  bool get _hasDrinks => widget.locationDetails?.drinks?.available == true;
  bool get _hasWifi => widget.locationDetails?.wifi?.available == true;

  bool get _hasOtherServices =>
      widget.locationDetails?.otherServices.isNotEmpty == true;

  bool get _hasServices =>
      _hasFood || _hasDrinks || _hasWifi || _hasOtherServices;

  bool get _hasAnyInfo => _hasParking || _hasTransport || _hasServices;

  @override
  Widget build(BuildContext context) {
    if (!_hasAnyInfo) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            context.l10n.eventPracticalInfoTitle,
            style: const TextStyle(
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
          child: _buildMainGrid(context),
        ),

        // Service chips
        if (_hasServices) ...[
          const SizedBox(height: 16),
          _buildServiceChips(context),
        ],
      ],
    );
  }

  Widget _buildMainGrid(BuildContext context) {
    final cards = <Widget>[];

    // Card Lieu supprimée - redondante avec la section Localisation (carte)
    // qui affiche déjà l'adresse, la carte et les boutons d'action

    // Card Parking
    if (_hasParking) {
      cards.add(
        PracticalInfoCard(
          icon: Icons.local_parking_outlined,
          title: context.l10n.eventParkingTitle,
          subtitle: context.l10n.eventParkingSubtitle,
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
          title: context.l10n.eventTransportTitle,
          subtitle: context.l10n.eventTransportSubtitle,
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

  Widget _buildServiceChips(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          if (_hasFood)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CompactInfoChip(
                icon: Icons.restaurant,
                label: context.l10n.eventFoodService,
                color: Colors.orange,
                onTap: () => _showAccessibilitySheet(
                  icon: Icons.restaurant,
                  title: context.l10n.eventFoodOnSite,
                  note: widget.locationDetails?.food?.note,
                ),
              ),
            ),
          if (_hasDrinks)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CompactInfoChip(
                icon: Icons.local_bar,
                label: context.l10n.eventDrinks,
                color: Colors.purple,
                onTap: () => _showAccessibilitySheet(
                  icon: Icons.local_bar,
                  title: context.l10n.eventDrinksAvailable,
                  note: widget.locationDetails?.drinks?.note,
                ),
              ),
            ),
          if (_hasWifi)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CompactInfoChip(
                icon: Icons.wifi,
                label: context.l10n.eventWifiLabel,
                color: Colors.teal,
                onTap: () => _showAccessibilitySheet(
                  icon: Icons.wifi,
                  title: context.l10n.eventWifiAvailable,
                  note: widget.locationDetails?.wifi?.note,
                ),
              ),
            ),
          // Dynamic chips for all remaining services from the API
          if (_hasOtherServices)
            ...widget.locationDetails!.otherServices.map((key) {
              final info = _serviceInfo(context, key);
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: CompactInfoChip(
                  icon: info.icon,
                  label: info.label,
                  color: info.color,
                  onTap: () => _showAccessibilitySheet(
                    icon: info.icon,
                    title: info.label,
                    note: null,
                  ),
                ),
              );
            }),
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
      title: widget.event.venue ?? context.l10n.eventPlace,
      description: address,
      color: HbColors.brandPrimary,
      actions: [
        if (lat != null && lng != null) ...[
          PracticalInfoActions.googleMaps(context: context, lat: lat, lng: lng),
          PracticalInfoActions.walkingDirections(
            context: context,
            lat: lat,
            lng: lng,
          ),
          PracticalInfoActions.publicTransport(
            context: context,
            lat: lat,
            lng: lng,
          ),
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
      title: context.l10n.eventParkingSheetTitle,
      description: parking.description,
      imageUrl: parking.imageUrl,
      color: Colors.blue,
      actions: lat != null && lng != null
          ? [
              PracticalInfoActions.googleMaps(
                context: context,
                lat: lat,
                lng: lng,
                label: context.l10n.eventParkingDirections,
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
      title: context.l10n.eventTransportSheetTitle,
      description: transport.description,
      imageUrl: transport.imageUrl,
      color: Colors.green,
      actions: lat != null && lng != null
          ? [
              PracticalInfoActions.publicTransport(
                context: context,
                lat: lat,
                lng: lng,
              ),
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
      description: note ?? context.l10n.eventServiceDefaultDescription,
      color: HbColors.brandPrimary,
    );
  }

  _ServiceDisplay _serviceInfo(BuildContext context, String key) {
    switch (key) {
      case 'materiel':
        return _ServiceDisplay(context.eventServiceLabel(key),
            Icons.handyman_outlined, Colors.brown);
      case 'animateur':
        return _ServiceDisplay(context.eventServiceLabel(key),
            Icons.person_outline, Colors.indigo);
      case 'hebergement':
        return _ServiceDisplay(context.eventServiceLabel(key),
            Icons.hotel_outlined, Colors.deepPurple);
      case 'vestiaire':
        return _ServiceDisplay(context.eventServiceLabel(key),
            Icons.checkroom_outlined, Colors.blueGrey);
      case 'securite':
        return _ServiceDisplay(context.eventServiceLabel(key),
            Icons.security_outlined, Colors.red);
      case 'premiers_secours':
        return _ServiceDisplay(context.eventServiceLabel(key),
            Icons.medical_services_outlined, Colors.redAccent);
      case 'garderie':
        return _ServiceDisplay(context.eventServiceLabel(key),
            Icons.child_care_outlined, Colors.pink);
      case 'photobooth':
        return _ServiceDisplay(context.eventServiceLabel(key),
            Icons.camera_alt_outlined, Colors.amber);
      default:
        return _ServiceDisplay(context.eventServiceLabel(key),
            Icons.check_circle_outline, Colors.grey);
    }
  }

  String _buildFullAddress() {
    final parts = <String>[];
    if (widget.event.address != null && widget.event.address!.isNotEmpty) {
      parts.add(widget.event.address!);
    }
    if (widget.event.postalCode != null &&
        widget.event.postalCode!.isNotEmpty) {
      parts.add(widget.event.postalCode!);
    }
    if (widget.event.city != null && widget.event.city!.isNotEmpty) {
      parts.add(widget.event.city!);
    }
    return parts.join(', ');
  }
}

class _ServiceDisplay {
  final String label;
  final IconData icon;
  final Color color;

  const _ServiceDisplay(this.label, this.icon, this.color);
}
