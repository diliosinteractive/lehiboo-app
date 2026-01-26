import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../core/themes/petit_boo_theme.dart';
import '../../../data/models/tool_schema_dto.dart';
import 'dynamic_tool_result_card.dart';

/// Card displaying a trip plan with map and timeline
/// Features: OSM map, drag & drop reordering, expandable map
class TripPlanCard extends StatefulWidget {
  final ToolSchemaDto schema;
  final Map<String, dynamic> data;

  const TripPlanCard({
    super.key,
    required this.schema,
    required this.data,
  });

  @override
  State<TripPlanCard> createState() => _TripPlanCardState();
}

class _TripPlanCardState extends State<TripPlanCard> {
  bool _mapExpanded = false;
  late List<_TripStop> _stops;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _stops = _parseStops();
  }

  List<_TripStop> _parseStops() {
    final stopsData = widget.data['stops'] as List<dynamic>? ?? [];
    return stopsData.asMap().entries.map((entry) {
      final index = entry.key;
      final stop = entry.value as Map<String, dynamic>;
      return _TripStop(
        index: index,
        title: stop['title'] as String? ?? 'Étape ${index + 1}',
        time: stop['time'] as String? ?? '',
        duration: stop['duration'] as String?,
        address: stop['address'] as String?,
        latitude: (stop['latitude'] as num?)?.toDouble(),
        longitude: (stop['longitude'] as num?)?.toDouble(),
        eventSlug: stop['event_slug'] as String?,
        transitDuration: stop['transit_duration'] as String?,
        transitDistance: stop['transit_distance'] as String?,
      );
    }).toList();
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final item = _stops.removeAt(oldIndex);
      _stops.insert(newIndex, item);
      // Update indices
      for (var i = 0; i < _stops.length; i++) {
        _stops[i] = _stops[i].copyWith(index: i);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = parseHexColor(widget.schema.color);
    final tripSchema = widget.schema.tripSchema;
    final showMap = tripSchema?.showMap ?? true;
    final enableReorder = tripSchema?.enableReorder ?? true;

    // Trip metadata
    final date = widget.data['date'] as String?;
    final totalDuration = widget.data['total_duration'] as String?;
    final totalDistance = widget.data['total_distance'] as String?;
    final recommendations = widget.data['recommendations'] as List<dynamic>?;

    // Calculate map bounds
    final validStops = _stops.where((s) => s.hasCoordinates).toList();
    final bounds = _calculateBounds(validStops);

    // Don't show the card if there are no stops (empty itinerary)
    if (_stops.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: PetitBooTheme.borderRadiusXl,
        boxShadow: PetitBooTheme.shadowMd,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(PetitBooTheme.spacing16),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.route,
                    color: accentColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: PetitBooTheme.spacing12),

                // Title and metadata
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.schema.title ?? 'Ton itinéraire',
                        style: PetitBooTheme.headingSm,
                      ),
                      if (date != null || totalDuration != null || totalDistance != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            children: [
                              if (date != null) ...[
                                Icon(
                                  Icons.calendar_today,
                                  size: 12,
                                  color: PetitBooTheme.textTertiary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  date,
                                  style: PetitBooTheme.caption,
                                ),
                              ],
                              if (totalDuration != null) ...[
                                if (date != null)
                                  Text(' • ', style: PetitBooTheme.caption),
                                Text(totalDuration, style: PetitBooTheme.caption),
                              ],
                              if (totalDistance != null) ...[
                                Text(' • ', style: PetitBooTheme.caption),
                                Text(totalDistance, style: PetitBooTheme.caption),
                              ],
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Map
          if (showMap && validStops.isNotEmpty)
            GestureDetector(
              onTap: () => setState(() => _mapExpanded = !_mapExpanded),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: _mapExpanded ? 300 : 150,
                child: Stack(
                  children: [
                    FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: bounds?.center ?? const LatLng(45.75, 4.85),
                        initialZoom: 13,
                        interactionOptions: const InteractionOptions(
                          flags: InteractiveFlag.none,
                        ),
                      ),
                      children: [
                        // OSM Tile Layer
                        TileLayer(
                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.lehiboo.app',
                        ),

                        // Route polyline
                        if (validStops.length > 1)
                          PolylineLayer(
                            polylines: [
                              Polyline(
                                points: validStops
                                    .map((s) => LatLng(s.latitude!, s.longitude!))
                                    .toList(),
                                strokeWidth: 3,
                                color: accentColor,
                              ),
                            ],
                          ),

                        // Markers
                        MarkerLayer(
                          markers: validStops.asMap().entries.map((entry) {
                            final stop = entry.value;
                            return Marker(
                              point: LatLng(stop.latitude!, stop.longitude!),
                              width: 30,
                              height: 30,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: accentColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.2),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    '${stop.index + 1}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),

                    // Expand hint
                    Positioned(
                      bottom: 8,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: PetitBooTheme.borderRadiusFull,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _mapExpanded ? Icons.unfold_less : Icons.unfold_more,
                                color: Colors.white,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _mapExpanded ? 'Réduire' : 'Agrandir',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          const Divider(height: 1, color: PetitBooTheme.border),

          // Timeline
          if (_stops.isNotEmpty)
            enableReorder
                ? ReorderableListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    buildDefaultDragHandles: false,
                    itemCount: _stops.length,
                    onReorder: _onReorder,
                    proxyDecorator: (child, index, animation) {
                      return Material(
                        elevation: 4,
                        color: Colors.transparent,
                        child: child,
                      );
                    },
                    itemBuilder: (context, index) {
                      final stop = _stops[index];
                      final isLast = index == _stops.length - 1;
                      return _TimelineStop(
                        key: ValueKey(stop.title + stop.time),
                        stop: stop,
                        isLast: isLast,
                        accentColor: accentColor,
                        enableReorder: enableReorder,
                        reorderIndex: index,
                        onTap: stop.eventSlug != null
                            ? () => context.push('/event/${stop.eventSlug}')
                            : null,
                      );
                    },
                  )
                : Column(
                    children: _stops.asMap().entries.map((entry) {
                      final index = entry.key;
                      final stop = entry.value;
                      final isLast = index == _stops.length - 1;
                      return _TimelineStop(
                        stop: stop,
                        isLast: isLast,
                        accentColor: accentColor,
                        enableReorder: false,
                        onTap: stop.eventSlug != null
                            ? () => context.push('/event/${stop.eventSlug}')
                            : null,
                      );
                    }).toList(),
                  ),

          // Recommendations
          if (recommendations != null && recommendations.isNotEmpty) ...[
            const Divider(height: 1, color: PetitBooTheme.border),
            Padding(
              padding: const EdgeInsets.all(PetitBooTheme.spacing16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: recommendations.map((rec) {
                  final text = rec is String ? rec : rec['text'] as String? ?? '';
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          size: 18,
                          color: const Color(0xFFF39C12),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            text,
                            style: PetitBooTheme.bodySm.copyWith(
                              color: PetitBooTheme.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  LatLngBounds? _calculateBounds(List<_TripStop> stops) {
    if (stops.isEmpty) return null;

    double minLat = 90, maxLat = -90, minLng = 180, maxLng = -180;

    for (final stop in stops) {
      if (stop.latitude! < minLat) minLat = stop.latitude!;
      if (stop.latitude! > maxLat) maxLat = stop.latitude!;
      if (stop.longitude! < minLng) minLng = stop.longitude!;
      if (stop.longitude! > maxLng) maxLng = stop.longitude!;
    }

    // Add padding
    const padding = 0.01;
    return LatLngBounds(
      LatLng(minLat - padding, minLng - padding),
      LatLng(maxLat + padding, maxLng + padding),
    );
  }
}

/// Timeline stop widget
class _TimelineStop extends StatelessWidget {
  final _TripStop stop;
  final bool isLast;
  final Color accentColor;
  final bool enableReorder;
  final int? reorderIndex;
  final VoidCallback? onTap;

  const _TimelineStop({
    super.key,
    required this.stop,
    required this.isLast,
    required this.accentColor,
    required this.enableReorder,
    this.reorderIndex,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: PetitBooTheme.spacing16,
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline indicator
              SizedBox(
                width: 32,
                child: Column(
                  children: [
                    // Time
                    if (stop.time.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          stop.time,
                          style: PetitBooTheme.caption.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Timeline line and dot
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    // Dot
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: accentColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: accentColor.withValues(alpha: 0.3),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    // Line
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: PetitBooTheme.grey200,
                        ),
                      ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: PetitBooTheme.spacing8,
                    bottom: PetitBooTheme.spacing16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title row
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              stop.title,
                              style: PetitBooTheme.bodySm.copyWith(
                                fontWeight: FontWeight.w600,
                                color: PetitBooTheme.textPrimary,
                              ),
                            ),
                          ),
                          // Drag handle
                          if (enableReorder && reorderIndex != null)
                            ReorderableDragStartListener(
                              index: reorderIndex!,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Icon(
                                  Icons.drag_handle,
                                  size: 20,
                                  color: PetitBooTheme.textTertiary,
                                ),
                              ),
                            ),
                          // Navigation arrow
                          if (onTap != null)
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Icon(
                                Icons.chevron_right,
                                size: 20,
                                color: PetitBooTheme.textTertiary,
                              ),
                            ),
                        ],
                      ),

                      // Duration
                      if (stop.duration != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            stop.duration!,
                            style: PetitBooTheme.caption,
                          ),
                        ),

                      // Address
                      if (stop.address != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 12,
                                color: PetitBooTheme.textTertiary,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  stop.address!,
                                  style: PetitBooTheme.caption.copyWith(
                                    color: PetitBooTheme.textTertiary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Transit info (between stops)
                      if (!isLast && (stop.transitDuration != null || stop.transitDistance != null))
                        Container(
                          margin: const EdgeInsets.only(top: 12),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: PetitBooTheme.grey50,
                            borderRadius: PetitBooTheme.borderRadiusMd,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.directions_walk,
                                size: 14,
                                color: PetitBooTheme.textTertiary,
                              ),
                              const SizedBox(width: 4),
                              if (stop.transitDuration != null)
                                Text(
                                  stop.transitDuration!,
                                  style: PetitBooTheme.caption.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              if (stop.transitDuration != null && stop.transitDistance != null)
                                Text(' • ', style: PetitBooTheme.caption),
                              if (stop.transitDistance != null)
                                Text(
                                  stop.transitDistance!,
                                  style: PetitBooTheme.caption,
                                ),
                            ],
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
    );
  }
}

/// Data model for a trip stop
class _TripStop {
  final int index;
  final String title;
  final String time;
  final String? duration;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? eventSlug;
  final String? transitDuration;
  final String? transitDistance;

  const _TripStop({
    required this.index,
    required this.title,
    required this.time,
    this.duration,
    this.address,
    this.latitude,
    this.longitude,
    this.eventSlug,
    this.transitDuration,
    this.transitDistance,
  });

  bool get hasCoordinates => latitude != null && longitude != null;

  _TripStop copyWith({int? index}) {
    return _TripStop(
      index: index ?? this.index,
      title: title,
      time: time,
      duration: duration,
      address: address,
      latitude: latitude,
      longitude: longitude,
      eventSlug: eventSlug,
      transitDuration: transitDuration,
      transitDistance: transitDistance,
    );
  }
}
