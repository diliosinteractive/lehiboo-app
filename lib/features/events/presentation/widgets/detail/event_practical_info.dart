import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import 'package:lehiboo/features/events/domain/entities/event_submodels.dart';
import 'package:url_launcher/url_launcher.dart';

/// Section informations pratiques avec accordions
///
/// Sections:
/// - Lieu et accès (avec mini map)
/// - Stationnement
/// - Transports
/// - Accessibilité (PMR, Food, Drinks)
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
  final Set<String> _expandedSections = {'location'}; // Lieu ouvert par défaut

  void _toggleSection(String section) {
    HapticFeedback.selectionClick();
    setState(() {
      if (_expandedSections.contains(section)) {
        _expandedSections.remove(section);
      } else {
        _expandedSections.add(section);
      }
    });
  }

  bool get _hasLocation =>
      (widget.event.venue != null && widget.event.venue!.isNotEmpty) ||
      (widget.event.address != null && widget.event.address!.isNotEmpty);

  bool get _hasParking =>
      widget.locationDetails?.parking != null &&
      widget.locationDetails!.parking!.description != null;

  bool get _hasTransport =>
      widget.locationDetails?.transport != null &&
      widget.locationDetails!.transport!.description != null;

  bool get _hasAccessibility =>
      widget.locationDetails?.pmr?.available == true ||
      widget.locationDetails?.food?.available == true ||
      widget.locationDetails?.drinks?.available == true;

  bool get _hasAnyInfo =>
      _hasLocation || _hasParking || _hasTransport || _hasAccessibility;

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
        const SizedBox(height: 12),

        // Sections
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                if (_hasLocation)
                  _buildSection(
                    id: 'location',
                    icon: Icons.location_on_outlined,
                    title: 'Lieu et accès',
                    child: _buildLocationContent(),
                  ),
                if (_hasParking) ...[
                  _buildDivider(),
                  _buildSection(
                    id: 'parking',
                    icon: Icons.local_parking_outlined,
                    title: 'Stationnement',
                    child: _buildParkingContent(),
                  ),
                ],
                if (_hasTransport) ...[
                  _buildDivider(),
                  _buildSection(
                    id: 'transport',
                    icon: Icons.directions_bus_outlined,
                    title: 'Transports',
                    child: _buildTransportContent(),
                  ),
                ],
                if (_hasAccessibility) ...[
                  _buildDivider(),
                  _buildSection(
                    id: 'accessibility',
                    icon: Icons.accessibility_new_outlined,
                    title: 'Accessibilité et services',
                    child: _buildAccessibilityContent(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String id,
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    final isExpanded = _expandedSections.contains(id);

    return Column(
      children: [
        // Header cliquable
        InkWell(
          onTap: () => _toggleSection(id),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: HbColors.brandPrimary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: HbColors.brandPrimary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: HbColors.textPrimary,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Contenu expansible
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 16,
            ),
            child: child,
          ),
          crossFadeState:
              isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey.shade100,
      indent: 16,
      endIndent: 16,
    );
  }

  Widget _buildLocationContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Mini Map Preview (placeholder statique)
        if (widget.event.latitude != null && widget.event.longitude != null)
          Container(
            height: 120,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                // Placeholder map
                Center(
                  child: Icon(
                    Icons.map_outlined,
                    size: 48,
                    color: Colors.grey.shade400,
                  ),
                ),
                // Overlay pour clic
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _openMaps,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Nom du lieu
        if (widget.event.venue != null && widget.event.venue!.isNotEmpty)
          Text(
            widget.event.venue!,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: HbColors.textPrimary,
            ),
          ),

        // Adresse
        if (widget.event.address != null || widget.event.city != null) ...[
          const SizedBox(height: 4),
          Text(
            _buildFullAddress(),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),
        ],

        // Bouton navigation
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _openMaps,
          icon: const Icon(Icons.directions, size: 18),
          label: const Text('Se rendre sur le lieu'),
          style: OutlinedButton.styleFrom(
            foregroundColor: HbColors.brandPrimary,
            side: const BorderSide(color: HbColors.brandPrimary),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildParkingContent() {
    final parking = widget.locationDetails?.parking;
    if (parking == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (parking.description != null)
          Text(
            parking.description!,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
        if (parking.imageUrl != null && parking.imageUrl!.isNotEmpty) ...[
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              parking.imageUrl!,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTransportContent() {
    final transport = widget.locationDetails?.transport;
    if (transport == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (transport.description != null)
          Text(
            transport.description!,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
        if (transport.imageUrl != null && transport.imageUrl!.isNotEmpty) ...[
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              transport.imageUrl!,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAccessibilityContent() {
    return Column(
      children: [
        if (widget.locationDetails?.pmr?.available == true)
          _buildAccessibilityItem(
            icon: Icons.accessible,
            title: 'Accessible PMR',
            note: widget.locationDetails?.pmr?.note,
            color: Colors.blue,
          ),
        if (widget.locationDetails?.food?.available == true)
          _buildAccessibilityItem(
            icon: Icons.restaurant,
            title: 'Restauration sur place',
            note: widget.locationDetails?.food?.note,
            color: Colors.orange,
          ),
        if (widget.locationDetails?.drinks?.available == true)
          _buildAccessibilityItem(
            icon: Icons.local_bar,
            title: 'Boissons disponibles',
            note: widget.locationDetails?.drinks?.note,
            color: Colors.purple,
          ),
      ],
    );
  }

  Widget _buildAccessibilityItem({
    required IconData icon,
    required String title,
    String? note,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: HbColors.textPrimary,
                  ),
                ),
                if (note != null && note.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    note,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 20,
          ),
        ],
      ),
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

  Future<void> _openMaps() async {
    HapticFeedback.lightImpact();

    final lat = widget.event.latitude;
    final lng = widget.event.longitude;

    if (lat == null || lng == null) {
      // Fallback: recherche par adresse
      final address = _buildFullAddress();
      if (address.isNotEmpty) {
        final encodedAddress = Uri.encodeComponent(address);
        final url = Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=$encodedAddress',
        );
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
      }
      return;
    }

    // Avec coordonnées
    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}
