import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import 'package:lehiboo/shared/widgets/animations/pulse_animation.dart';
import 'package:url_launcher/url_launcher.dart';

/// Carte interactive OSM avec marker animé
///
/// Features Material Expressive:
/// - Carte OSM 180px avec marker pulsant
/// - Adresse complète + distance utilisateur
/// - 4 boutons actions : Voiture, À pied, Transports, Copier
/// - Tap carte → Expand fullscreen
class EventLocationMap extends StatefulWidget {
  final Event event;
  final double? userLatitude;
  final double? userLongitude;
  final bool expandable;

  const EventLocationMap({
    super.key,
    required this.event,
    this.userLatitude,
    this.userLongitude,
    this.expandable = true,
  });

  @override
  State<EventLocationMap> createState() => _EventLocationMapState();
}

class _EventLocationMapState extends State<EventLocationMap> {
  bool _isExpanded = false;
  final MapController _mapController = MapController();

  double? get _lat => widget.event.latitude;
  double? get _lng => widget.event.longitude;
  bool get _hasCoordinates => _lat != null && _lng != null && _lat != 0 && _lng != 0;

  String? get _distanceKm {
    if (widget.userLatitude == null ||
        widget.userLongitude == null ||
        !_hasCoordinates) {
      return null;
    }
    final distance = const Distance().as(
      LengthUnit.Kilometer,
      LatLng(widget.userLatitude!, widget.userLongitude!),
      LatLng(_lat!, _lng!),
    );
    if (distance < 1) {
      return '${(distance * 1000).round()} m';
    }
    return '${distance.toStringAsFixed(1)} km';
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasCoordinates) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text(
            'Localisation',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: HbColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          // Carte
          GestureDetector(
            onTap: widget.expandable ? _toggleExpand : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              height: _isExpanded ? 280 : 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: HbColors.grey200, width: 1),
                // Flat design : ombre subtile
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    // Carte OSM
                    FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: LatLng(_lat!, _lng!),
                        initialZoom: 15,
                        interactionOptions: const InteractionOptions(
                          flags: InteractiveFlag.none,
                        ),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.lehiboo.app',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: LatLng(_lat!, _lng!),
                              width: 50,
                              height: 50,
                              child: _buildAnimatedMarker(),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Overlay gradient en bas
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: 60,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.4),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Bouton expand
                    if (widget.expandable)
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Icon(
                            _isExpanded
                                ? Icons.fullscreen_exit
                                : Icons.fullscreen,
                            size: 20,
                            color: HbColors.textPrimary,
                          ),
                        ),
                      ),

                    // Distance badge
                    if (_distanceKm != null)
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.near_me,
                                size: 14,
                                color: HbColors.brandPrimary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _distanceKm!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: HbColors.brandPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Adresse
          _buildAddress(),

          const SizedBox(height: 16),

          // Boutons actions
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildAnimatedMarker() {
    return PulseAnimation(
      duration: const Duration(milliseconds: 2000),
      minScale: 0.9,
      maxScale: 1.1,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: HbColors.brandPrimary.withValues(alpha: 0.4),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: HbColors.brandPrimary,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.place,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildAddress() {
    final venue = widget.event.venue;
    final address = _buildFullAddress();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (venue != null && venue.isNotEmpty)
          Text(
            venue,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: HbColors.textPrimary,
            ),
          ),
        if (address.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            address,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildActionButtons() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildActionButton(
            icon: Icons.directions_car,
            label: 'Voiture',
            color: HbColors.brandPrimary,
            onTap: () => _openMaps('driving'),
          ),
          const SizedBox(width: 8),
          _buildActionButton(
            icon: Icons.directions_walk,
            label: 'À pied',
            color: Colors.green,
            onTap: () => _openMaps('walking'),
          ),
          const SizedBox(width: 8),
          _buildActionButton(
            icon: Icons.directions_transit,
            label: 'Transports',
            color: Colors.blue,
            onTap: () => _openMaps('transit'),
          ),
          const SizedBox(width: 8),
          _buildActionButton(
            icon: Icons.copy,
            label: 'Copier',
            color: Colors.grey,
            onTap: _copyAddress,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _buildFullAddress() {
    final parts = <String>[];

    // Adresse (rue, numéro)
    if (widget.event.address != null && widget.event.address!.isNotEmpty) {
      parts.add(widget.event.address!);
    }

    // Combiner code postal + ville, en évitant les doublons
    // (ex: "59300 Valenciennes" au lieu de "59300, Valenciennes, Valenciennes")
    final cityParts = <String>[];
    if (widget.event.postalCode != null && widget.event.postalCode!.isNotEmpty) {
      cityParts.add(widget.event.postalCode!);
    }
    if (widget.event.city != null && widget.event.city!.isNotEmpty) {
      // Vérifier que la ville n'est pas déjà dans l'adresse
      final city = widget.event.city!;
      final addressLower = (widget.event.address ?? '').toLowerCase();
      if (!addressLower.contains(city.toLowerCase())) {
        cityParts.add(city);
      }
    }
    if (cityParts.isNotEmpty) {
      parts.add(cityParts.join(' '));
    }

    return parts.join(', ');
  }

  void _toggleExpand() {
    HapticFeedback.lightImpact();
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  Future<void> _openMaps(String mode) async {
    if (!_hasCoordinates) return;

    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$_lat,$_lng&travelmode=$mode',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _copyAddress() {
    final venue = widget.event.venue ?? '';
    final address = _buildFullAddress();
    final fullText = [venue, address].where((s) => s.isNotEmpty).join('\n');

    if (fullText.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: fullText));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Adresse copiée'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
