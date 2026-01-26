import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../core/themes/petit_boo_theme.dart';
import '../../../data/models/tool_schema_dto.dart';
import '../../providers/petit_boo_chat_provider.dart';
import 'dynamic_tool_result_card.dart';

/// Card displaying a trip plan with timeline, map, and action buttons
/// Designed according to the planTrip tool spec from backend
class TripPlanCard extends ConsumerStatefulWidget {
  final ToolSchemaDto schema;
  final Map<String, dynamic> data;

  const TripPlanCard({
    super.key,
    required this.schema,
    required this.data,
  });

  @override
  ConsumerState<TripPlanCard> createState() => _TripPlanCardState();
}

class _TripPlanCardState extends ConsumerState<TripPlanCard> {
  bool _mapExpanded = false;
  final MapController _mapController = MapController();

  /// Extract plan data from nested structure
  Map<String, dynamic> get _plan {
    // Handle nested data structure: data.plan or data.data.plan
    final data = widget.data;
    if (data['plan'] is Map<String, dynamic>) {
      return data['plan'] as Map<String, dynamic>;
    }
    if (data['data'] is Map<String, dynamic>) {
      final innerData = data['data'] as Map<String, dynamic>;
      if (innerData['plan'] is Map<String, dynamic>) {
        return innerData['plan'] as Map<String, dynamic>;
      }
      return innerData;
    }
    return data;
  }

  List<_TripStop> get _stops {
    final stopsData = _plan['stops'] as List<dynamic>? ?? [];
    return stopsData.map((stop) {
      if (stop is! Map<String, dynamic>) {
        return const _TripStop(order: 0, eventTitle: 'Étape');
      }

      // Extract coordinates from nested or flat structure
      double? lat, lng;
      if (stop['coordinates'] is Map<String, dynamic>) {
        final coords = stop['coordinates'] as Map<String, dynamic>;
        lat = (coords['lat'] as num?)?.toDouble();
        lng = (coords['lng'] as num?)?.toDouble();
      } else {
        lat = (stop['latitude'] as num?)?.toDouble();
        lng = (stop['longitude'] as num?)?.toDouble();
      }

      return _TripStop(
        order: (stop['order'] as num?)?.toInt() ?? 0,
        eventUuid: stop['event_uuid'] as String?,
        eventTitle: stop['event_title'] as String? ??
                    stop['title'] as String? ??
                    'Étape',
        venueName: stop['venue_name'] as String?,
        address: stop['address'] as String?,
        city: stop['city'] as String?,
        arrivalTime: stop['arrival_time'] as String?,
        departureTime: stop['departure_time'] as String?,
        durationMinutes: (stop['duration_minutes'] as num?)?.toInt(),
        travelFromPreviousKm: (stop['travel_from_previous_km'] as num?)?.toDouble(),
        travelFromPreviousMinutes: (stop['travel_from_previous_minutes'] as num?)?.toInt(),
        latitude: lat,
        longitude: lng,
      );
    }).toList();
  }

  String get _title => _plan['title'] as String? ?? 'Ton itinéraire';

  String? get _plannedDate => _plan['planned_date'] as String?;

  String? get _startTime => _plan['start_time'] as String?;

  String? get _endTime => _plan['end_time'] as String?;

  int? get _totalDurationMinutes => (_plan['total_duration_minutes'] as num?)?.toInt();

  double? get _totalDistanceKm => (_plan['total_distance_km'] as num?)?.toDouble();

  double? get _score => (_plan['score'] as num?)?.toDouble();

  bool get _isSaved => widget.data['saved'] == true ||
                       (widget.data['data'] is Map && (widget.data['data'] as Map)['saved'] == true);

  List<String> get _recommendations {
    final recs = _plan['recommendations'] as List<dynamic>?;
    if (recs == null) return [];
    return recs.map((r) => r.toString()).toList();
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = parseHexColor(widget.schema.color);
    final stops = _stops;

    // Don't show the card if there are no stops
    if (stops.isEmpty) {
      return const SizedBox.shrink();
    }

    final validStops = stops.where((s) => s.hasCoordinates).toList();

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
          // Header with title, date, stats
          _buildHeader(accentColor),

          const Divider(height: 1, color: PetitBooTheme.border),

          // Map (collapsible)
          if (validStops.isNotEmpty)
            _buildMap(validStops, accentColor),

          // Timeline
          _buildTimeline(stops, accentColor),

          // Recommendations
          if (_recommendations.isNotEmpty) ...[
            const Divider(height: 1, color: PetitBooTheme.border),
            _buildRecommendations(),
          ],

          // Action buttons
          const Divider(height: 1, color: PetitBooTheme.border),
          _buildActionButtons(accentColor, validStops.isNotEmpty),
        ],
      ),
    );
  }

  Widget _buildHeader(Color accentColor) {
    return Padding(
      padding: const EdgeInsets.all(PetitBooTheme.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // First row: Icon + Title + Score
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.route,
                  color: accentColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: PetitBooTheme.spacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _title,
                      style: PetitBooTheme.headingSm.copyWith(
                        color: PetitBooTheme.textPrimary,
                      ),
                    ),
                    if (_plannedDate != null)
                      Text(
                        _formatDate(_plannedDate!),
                        style: PetitBooTheme.bodySm.copyWith(
                          color: PetitBooTheme.textTertiary,
                        ),
                      ),
                  ],
                ),
              ),
              // Score badge
              if (_score != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getScoreColor(_score!).withValues(alpha: 0.1),
                    borderRadius: PetitBooTheme.borderRadiusFull,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star,
                        size: 16,
                        color: _getScoreColor(_score!),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _score!.toStringAsFixed(1),
                        style: PetitBooTheme.label.copyWith(
                          color: _getScoreColor(_score!),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          const SizedBox(height: PetitBooTheme.spacing12),

          // Second row: Stats chips (duration, distance, time range)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (_totalDurationMinutes != null)
                _buildStatChip(
                  Icons.schedule,
                  _formatDuration(_totalDurationMinutes!),
                  accentColor,
                ),
              if (_totalDistanceKm != null)
                _buildStatChip(
                  Icons.straighten,
                  '${_totalDistanceKm!.toStringAsFixed(1)} km',
                  accentColor,
                ),
              if (_startTime != null && _endTime != null)
                _buildStatChip(
                  Icons.access_time,
                  '$_startTime - $_endTime',
                  accentColor,
                ),
              _buildStatChip(
                Icons.flag,
                '${_stops.length} étape${_stops.length > 1 ? 's' : ''}',
                accentColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String label, Color accentColor) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: PetitBooTheme.grey100,
        borderRadius: PetitBooTheme.borderRadiusFull,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: PetitBooTheme.textTertiary),
          const SizedBox(width: 4),
          Text(
            label,
            style: PetitBooTheme.caption.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMap(List<_TripStop> validStops, Color accentColor) {
    final bounds = _calculateBounds(validStops);

    return GestureDetector(
      onTap: () => setState(() => _mapExpanded = !_mapExpanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: _mapExpanded ? 280 : 140,
        child: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: bounds?.center ?? const LatLng(46.6, 2.3),
                initialZoom: 12,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.none,
                ),
              ),
              children: [
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
                // Markers with numbers
                MarkerLayer(
                  markers: validStops.asMap().entries.map((entry) {
                    final index = entry.key;
                    final stop = entry.value;
                    return Marker(
                      point: LatLng(stop.latitude!, stop.longitude!),
                      width: 28,
                      height: 28,
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
                            '${index + 1}',
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
            // Expand/collapse hint
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
                        _mapExpanded ? 'Réduire' : 'Agrandir la carte',
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
    );
  }

  Widget _buildTimeline(List<_TripStop> stops, Color accentColor) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: PetitBooTheme.spacing8),
      itemCount: stops.length,
      itemBuilder: (context, index) {
        final stop = stops[index];
        final isLast = index == stops.length - 1;
        final nextStop = isLast ? null : stops[index + 1];

        return _TimelineStopWidget(
          stop: stop,
          index: index,
          isLast: isLast,
          accentColor: accentColor,
          travelToNextKm: nextStop?.travelFromPreviousKm,
          travelToNextMinutes: nextStop?.travelFromPreviousMinutes,
          onTap: stop.eventUuid != null
              ? () {
                  HapticFeedback.selectionClick();
                  context.push('/event/${stop.eventUuid}');
                }
              : null,
        );
      },
    );
  }

  Widget _buildRecommendations() {
    return Padding(
      padding: const EdgeInsets.all(PetitBooTheme.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.lightbulb_outline,
                size: 18,
                color: Color(0xFFF39C12),
              ),
              const SizedBox(width: 8),
              Text(
                'Conseils',
                style: PetitBooTheme.label.copyWith(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFF39C12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...(_recommendations.map((rec) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ',
                      style: PetitBooTheme.bodySm.copyWith(
                        color: PetitBooTheme.textSecondary,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        rec,
                        style: PetitBooTheme.bodySm.copyWith(
                          color: PetitBooTheme.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ))),
        ],
      ),
    );
  }

  Widget _buildActionButtons(Color accentColor, bool hasValidStops) {
    return Padding(
      padding: const EdgeInsets.all(PetitBooTheme.spacing16),
      child: Row(
        children: [
          // Save button
          if (!_isSaved)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _onSavePlan,
                icon: const Icon(Icons.bookmark_border, size: 18),
                label: const Text('Sauvegarder'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: accentColor,
                  side: BorderSide(color: accentColor),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bookmark, size: 18, color: accentColor),
                    const SizedBox(width: 6),
                    Text(
                      'Sauvegardé',
                      style: PetitBooTheme.label.copyWith(
                        color: accentColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          if (hasValidStops) ...[
            const SizedBox(width: 12),
            // View on map button
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  setState(() => _mapExpanded = !_mapExpanded);
                },
                icon: Icon(
                  _mapExpanded ? Icons.map : Icons.map_outlined,
                  size: 18,
                ),
                label: Text(_mapExpanded ? 'Masquer carte' : 'Voir carte'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _onSavePlan() {
    HapticFeedback.lightImpact();
    // Send message to save the plan via LLM
    final planUuid = _plan['uuid'] as String?;
    if (planUuid != null) {
      ref.read(petitBooChatProvider.notifier).sendMessage(
        'Sauvegarde ce plan de sortie',
      );
    }
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final formatter = DateFormat('EEEE d MMMM', 'fr_FR');
      final formatted = formatter.format(date);
      // Capitalize first letter
      return formatted[0].toUpperCase() + formatted.substring(1);
    } catch (_) {
      return dateStr;
    }
  }

  String _formatDuration(int minutes) {
    if (minutes < 60) {
      return '${minutes}min';
    }
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (mins == 0) {
      return '${hours}h';
    }
    return '${hours}h${mins.toString().padLeft(2, '0')}';
  }

  Color _getScoreColor(double score) {
    if (score >= 8) return const Color(0xFF27AE60);
    if (score >= 6) return const Color(0xFFF39C12);
    return const Color(0xFFE74C3C);
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

    const padding = 0.01;
    return LatLngBounds(
      LatLng(minLat - padding, minLng - padding),
      LatLng(maxLat + padding, maxLng + padding),
    );
  }
}

/// Individual timeline stop widget
class _TimelineStopWidget extends StatelessWidget {
  final _TripStop stop;
  final int index;
  final bool isLast;
  final Color accentColor;
  final double? travelToNextKm;
  final int? travelToNextMinutes;
  final VoidCallback? onTap;

  const _TimelineStopWidget({
    required this.stop,
    required this.index,
    required this.isLast,
    required this.accentColor,
    this.travelToNextKm,
    this.travelToNextMinutes,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasTravel = !isLast &&
        (travelToNextMinutes != null && travelToNextMinutes! > 0);

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
              // Time column
              SizedBox(
                width: 50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(height: 2),
                    Text(
                      stop.arrivalTime ?? '',
                      style: PetitBooTheme.label.copyWith(
                        fontWeight: FontWeight.w700,
                        color: accentColor,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Timeline indicator
              Column(
                children: [
                  // Circle marker
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: accentColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: accentColor.withValues(alpha: 0.3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Line to next stop
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: PetitBooTheme.grey200,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: isLast ? PetitBooTheme.spacing8 : PetitBooTheme.spacing16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Event title
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              stop.eventTitle,
                              style: PetitBooTheme.bodyMd.copyWith(
                                fontWeight: FontWeight.w600,
                                color: PetitBooTheme.textPrimary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (onTap != null)
                            const Icon(
                              Icons.chevron_right,
                              size: 20,
                              color: PetitBooTheme.textTertiary,
                            ),
                        ],
                      ),

                      // Venue + City
                      if (stop.venueName != null || stop.city != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 14,
                                color: PetitBooTheme.textTertiary,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  [stop.venueName, stop.city]
                                      .where((s) => s != null && s.isNotEmpty)
                                      .join(', '),
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

                      // Duration at stop
                      if (stop.durationMinutes != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: accentColor.withValues(alpha: 0.1),
                              borderRadius: PetitBooTheme.borderRadiusMd,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.schedule,
                                  size: 12,
                                  color: accentColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _formatDuration(stop.durationMinutes!),
                                  style: PetitBooTheme.caption.copyWith(
                                    color: accentColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      // Travel to next stop
                      if (hasTravel)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: PetitBooTheme.grey50,
                              borderRadius: PetitBooTheme.borderRadiusMd,
                              border: Border.all(
                                color: PetitBooTheme.grey200,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.directions_car,
                                  size: 14,
                                  color: PetitBooTheme.textTertiary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  _formatTravel(travelToNextMinutes, travelToNextKm),
                                  style: PetitBooTheme.caption.copyWith(
                                    fontWeight: FontWeight.w500,
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
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(int minutes) {
    if (minutes < 60) {
      return '${minutes}min';
    }
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (mins == 0) {
      return '${hours}h';
    }
    return '${hours}h${mins.toString().padLeft(2, '0')}';
  }

  String _formatTravel(int? minutes, double? km) {
    final parts = <String>[];
    if (minutes != null && minutes > 0) {
      parts.add('${minutes}min');
    }
    if (km != null && km > 0) {
      parts.add('${km.toStringAsFixed(1)} km');
    }
    return parts.join(' • ');
  }
}

/// Data model for a trip stop
class _TripStop {
  final int order;
  final String? eventUuid;
  final String eventTitle;
  final String? venueName;
  final String? address;
  final String? city;
  final String? arrivalTime;
  final String? departureTime;
  final int? durationMinutes;
  final double? travelFromPreviousKm;
  final int? travelFromPreviousMinutes;
  final double? latitude;
  final double? longitude;

  const _TripStop({
    required this.order,
    this.eventUuid,
    required this.eventTitle,
    this.venueName,
    this.address,
    this.city,
    this.arrivalTime,
    this.departureTime,
    this.durationMinutes,
    this.travelFromPreviousKm,
    this.travelFromPreviousMinutes,
    this.latitude,
    this.longitude,
  });

  bool get hasCoordinates =>
      latitude != null &&
      longitude != null &&
      latitude != 0.0 &&
      longitude != 0.0;
}
