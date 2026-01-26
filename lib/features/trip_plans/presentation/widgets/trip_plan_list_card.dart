import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/entities/trip_plan.dart';

/// Card displaying a trip plan in the profile list
/// Styled to match the chat TripPlanCard
class TripPlanListCard extends StatefulWidget {
  final TripPlan plan;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TripPlanListCard({
    super.key,
    required this.plan,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<TripPlanListCard> createState() => _TripPlanListCardState();
}

class _TripPlanListCardState extends State<TripPlanListCard> {
  bool _expanded = false;

  static const Color _accentColor = Color(0xFF27AE60);
  static const Color _textPrimary = Color(0xFF2D3748);
  static const Color _textSecondary = Color(0xFF718096);
  static const Color _textTertiary = Color(0xFFA0AEC0);
  static const Color _border = Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Header (always visible)
          InkWell(
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() => _expanded = !_expanded);
            },
            child: _buildHeader(),
          ),

          // Expanded content
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: _buildExpandedContent(),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row with icon and score
          Row(
            children: [
              // Route icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.route,
                  color: _accentColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              // Title and date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.plan.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.plan.plannedDate != null)
                      Text(
                        _formatDate(widget.plan.plannedDate!),
                        style: const TextStyle(
                          fontSize: 13,
                          color: _textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
              // Score badge
              if (widget.plan.score != null) _buildScoreBadge(widget.plan.score!),
              const SizedBox(width: 8),
              // Expand indicator
              AnimatedRotation(
                turns: _expanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                child: const Icon(
                  Icons.keyboard_arrow_down,
                  color: _textTertiary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Stats chips
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _buildStatChip(Icons.schedule, widget.plan.formattedDuration),
              if (widget.plan.totalDistanceKm != null && widget.plan.totalDistanceKm! > 0)
                _buildStatChip(Icons.directions_car, '${widget.plan.totalDistanceKm!.toStringAsFixed(1)} km'),
              if (widget.plan.timeRange != null && widget.plan.timeRange!.isNotEmpty)
                _buildStatChip(Icons.access_time, widget.plan.timeRange!),
              _buildStatChip(Icons.flag, '${widget.plan.stopsCount} étape${widget.plan.stopsCount > 1 ? 's' : ''}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreBadge(double score) {
    Color badgeColor;
    if (score >= 8) {
      badgeColor = _accentColor;
    } else if (score >= 6) {
      badgeColor = Colors.orange;
    } else {
      badgeColor = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, size: 14, color: badgeColor),
          const SizedBox(width: 4),
          Text(
            score.toStringAsFixed(1),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: badgeColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: _textTertiary),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: _textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedContent() {
    final hasStops = widget.plan.stops.isNotEmpty;
    final hasCoordinates = widget.plan.stops.any((s) => s.hasCoordinates);

    return Column(
      children: [
        const Divider(height: 1, color: _border),

        // Timeline of stops
        if (hasStops)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              children: widget.plan.stops.asMap().entries.map((entry) {
                final index = entry.key;
                final stop = entry.value;
                final isLast = index == widget.plan.stops.length - 1;
                return _buildTimelineItem(stop, index + 1, isLast);
              }).toList(),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.info_outline, size: 16, color: _textTertiary),
                const SizedBox(width: 8),
                Text(
                  '${widget.plan.stopsCount} étape${widget.plan.stopsCount > 1 ? 's' : ''} prévue${widget.plan.stopsCount > 1 ? 's' : ''}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: _textTertiary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),

        // Action buttons
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Row(
            children: [
              // Google Maps button
              Expanded(
                child: _buildActionButton(
                  icon: Icons.map_outlined,
                  label: 'Maps',
                  color: _accentColor,
                  enabled: hasCoordinates,
                  onTap: _openInGoogleMaps,
                ),
              ),
              const SizedBox(width: 8),
              // Waze button
              Expanded(
                child: _buildActionButton(
                  icon: Icons.navigation_outlined,
                  label: 'Waze',
                  color: const Color(0xFF33CCFF),
                  enabled: hasCoordinates,
                  onTap: _openInWaze,
                ),
              ),
              const SizedBox(width: 8),
              // Edit button
              if (widget.onEdit != null && hasStops)
                _buildIconButton(
                  icon: Icons.edit_outlined,
                  color: _textSecondary,
                  onTap: widget.onEdit!,
                ),
              // Delete button
              if (widget.onDelete != null)
                _buildIconButton(
                  icon: Icons.delete_outline,
                  color: Colors.red.shade400,
                  onTap: _confirmDelete,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineItem(TripStop stop, int order, bool isLast) {
    final eventId = stop.eventIdentifier;
    final hasEventLink = eventId != null && eventId.isNotEmpty;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Time
        SizedBox(
          width: 50,
          child: Text(
            stop.arrivalTime ?? '--:--',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _textSecondary,
            ),
          ),
        ),

        // Timeline dot and line
        Column(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: _accentColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$order',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: _accentColor.withValues(alpha: 0.3),
              ),
          ],
        ),

        const SizedBox(width: 12),

        // Stop details - tappable if has event link
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
            child: InkWell(
              onTap: hasEventLink ? () {
                HapticFeedback.selectionClick();
                context.push('/event/$eventId');
              } : null,
              borderRadius: BorderRadius.circular(8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stop.eventTitle,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: hasEventLink ? _accentColor : _textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (stop.locationString.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Row(
                              children: [
                                const Icon(Icons.location_on, size: 12, color: _textTertiary),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    stop.locationString,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: _textSecondary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (stop.durationMinutes != null && stop.durationMinutes! > 0)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: _accentColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.schedule, size: 12, color: _accentColor),
                                  const SizedBox(width: 4),
                                  Text(
                                    _formatDuration(stop.durationMinutes!),
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: _accentColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Chevron if tappable
                  if (hasEventLink)
                    const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(
                        Icons.chevron_right,
                        size: 20,
                        color: _textTertiary,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: enabled ? () {
        HapticFeedback.lightImpact();
        onTap();
      } : null,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: enabled ? color.withValues(alpha: 0.4) : _border,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: enabled ? color : _textTertiary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: enabled ? color : _textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return IconButton(
      onPressed: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      icon: Icon(icon, size: 22),
      color: color,
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(),
    );
  }

  void _openInGoogleMaps() {
    final validStops = widget.plan.stops.where((s) => s.hasCoordinates).toList();
    if (validStops.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aucune coordonnée disponible')),
      );
      return;
    }

    final waypoints = validStops
        .map((s) => '${s.latitude},${s.longitude}')
        .join('/');
    final url = 'https://www.google.com/maps/dir/$waypoints';
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  void _openInWaze() {
    final validStops = widget.plan.stops.where((s) => s.hasCoordinates).toList();
    if (validStops.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aucune coordonnée disponible')),
      );
      return;
    }

    final firstStop = validStops.first;
    final url = 'https://waze.com/ul?ll=${firstStop.latitude},${firstStop.longitude}&navigate=yes';
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  void _confirmDelete() {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer ce plan ?'),
        content: Text('Le plan "${widget.plan.title}" sera définitivement supprimé.'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Annuler',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.onDelete?.call();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final formatter = DateFormat('EEEE d MMMM', 'fr_FR');
    final formatted = formatter.format(date);
    return formatted[0].toUpperCase() + formatted.substring(1);
  }

  String _formatDuration(int minutes) {
    if (minutes < 60) return '${minutes}min';
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (mins == 0) return '${hours}h';
    return '${hours}h${mins.toString().padLeft(2, '0')}';
  }
}
