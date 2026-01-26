import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/themes/petit_boo_theme.dart';
import '../../../data/models/tool_schema_dto.dart';
import 'dynamic_tool_result_card.dart';

/// Card displaying a list of trip plans in the chat
/// Used for the getMyTripPlans tool result
class TripPlansListCard extends StatelessWidget {
  final ToolSchemaDto schema;
  final Map<String, dynamic> data;

  const TripPlansListCard({
    super.key,
    required this.schema,
    required this.data,
  });

  List<Map<String, dynamic>> get _plans {
    // Handle nested data structure
    final dataContent = data['data'] ?? data;
    if (dataContent is Map<String, dynamic>) {
      if (dataContent.containsKey('plans') && dataContent['plans'] is List) {
        return (dataContent['plans'] as List)
            .whereType<Map<String, dynamic>>()
            .toList();
      }
    }
    if (data['plans'] is List) {
      return (data['plans'] as List)
          .whereType<Map<String, dynamic>>()
          .toList();
    }
    return [];
  }

  int get _total => (data['total'] as num?)?.toInt() ??
                    (data['data']?['total'] as num?)?.toInt() ??
                    _plans.length;

  /// Check if backend returned an error
  bool get _hasError {
    if (data['success'] == false) return true;
    if (data['error'] != null) return true;
    final dataContent = data['data'];
    if (dataContent is Map<String, dynamic>) {
      if (dataContent['success'] == false) return true;
      if (dataContent['error'] != null) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = parseHexColor(schema.color, fallback: const Color(0xFF27AE60));

    // Check for errors first
    if (_hasError) {
      return _buildErrorState(accentColor);
    }

    final plans = _plans;

    if (plans.isEmpty) {
      return _buildEmptyState(accentColor);
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
          _buildHeader(accentColor),
          const Divider(height: 1, color: PetitBooTheme.border),

          // Plans list
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: plans.length.clamp(0, 5), // Show max 5 plans
            separatorBuilder: (_, __) => const Divider(height: 1, color: PetitBooTheme.border),
            itemBuilder: (context, index) {
              return _PlanListItem(
                plan: plans[index],
                accentColor: accentColor,
              );
            },
          ),

          // Show more button if there are more plans
          if (_total > 5) ...[
            const Divider(height: 1, color: PetitBooTheme.border),
            _buildShowMoreButton(context, accentColor),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(Color accentColor) {
    return Padding(
      padding: const EdgeInsets.all(PetitBooTheme.spacing16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              getIconFromName(schema.icon),
              color: accentColor,
              size: 22,
            ),
          ),
          const SizedBox(width: PetitBooTheme.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  schema.title ?? 'Tes sorties',
                  style: PetitBooTheme.headingSm.copyWith(
                    color: PetitBooTheme.textPrimary,
                  ),
                ),
                Text(
                  '$_total plan${_total > 1 ? 's' : ''} sauvegardé${_total > 1 ? 's' : ''}',
                  style: PetitBooTheme.caption.copyWith(
                    color: PetitBooTheme.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(PetitBooTheme.spacing24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: PetitBooTheme.borderRadiusXl,
        boxShadow: PetitBooTheme.shadowMd,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 28,
            ),
          ),
          const SizedBox(height: PetitBooTheme.spacing16),
          Text(
            'Impossible de charger tes sorties',
            style: PetitBooTheme.bodyMd.copyWith(
              color: PetitBooTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: PetitBooTheme.spacing8),
          Text(
            'Réessaie dans quelques instants',
            style: PetitBooTheme.caption.copyWith(
              color: PetitBooTheme.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(PetitBooTheme.spacing24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: PetitBooTheme.borderRadiusXl,
        boxShadow: PetitBooTheme.shadowMd,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.route_outlined,
              color: accentColor,
              size: 28,
            ),
          ),
          const SizedBox(height: PetitBooTheme.spacing16),
          Text(
            schema.emptyMessage ?? 'Aucune sortie planifiée',
            style: PetitBooTheme.bodyMd.copyWith(
              color: PetitBooTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: PetitBooTheme.spacing8),
          Text(
            'Demande-moi de planifier une sortie !',
            style: PetitBooTheme.caption.copyWith(
              color: PetitBooTheme.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildShowMoreButton(BuildContext context, Color accentColor) {
    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        context.push('/trip-plans');
      },
      child: Padding(
        padding: const EdgeInsets.all(PetitBooTheme.spacing16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Voir toutes mes sorties',
              style: PetitBooTheme.label.copyWith(
                color: accentColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.arrow_forward, size: 16, color: accentColor),
          ],
        ),
      ),
    );
  }
}

class _PlanListItem extends StatelessWidget {
  final Map<String, dynamic> plan;
  final Color accentColor;

  const _PlanListItem({
    required this.plan,
    required this.accentColor,
  });

  String get _title => plan['title'] as String? ?? 'Plan sans titre';
  String? get _plannedDate => plan['planned_date'] as String?;
  int? get _totalDurationMinutes => (plan['total_duration_minutes'] as num?)?.toInt();
  int get _stopsCount => (plan['stops_count'] as num?)?.toInt() ??
                          (plan['stops'] as List?)?.length ?? 0;

  List<Map<String, dynamic>> get _stops {
    final stopsData = plan['stops'] as List?;
    if (stopsData == null) return [];
    return stopsData.whereType<Map<String, dynamic>>().toList();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        context.push('/trip-plans');
      },
      child: Padding(
        padding: const EdgeInsets.all(PetitBooTheme.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title row
            Row(
              children: [
                Expanded(
                  child: Text(
                    _title,
                    style: PetitBooTheme.bodyMd.copyWith(
                      fontWeight: FontWeight.w600,
                      color: PetitBooTheme.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: PetitBooTheme.textTertiary,
                ),
              ],
            ),

            const SizedBox(height: 6),

            // Meta info
            Wrap(
              spacing: 12,
              runSpacing: 4,
              children: [
                if (_plannedDate != null)
                  _buildMetaChip(Icons.calendar_today, _formatDate(_plannedDate!)),
                if (_totalDurationMinutes != null)
                  _buildMetaChip(Icons.schedule, _formatDuration(_totalDurationMinutes!)),
                _buildMetaChip(Icons.flag, '$_stopsCount étape${_stopsCount > 1 ? 's' : ''}'),
              ],
            ),

            // First 2 stops preview
            if (_stops.isNotEmpty) ...[
              const SizedBox(height: 10),
              ...(_stops.take(2).map((stop) {
                final title = stop['event_title'] as String? ?? stop['title'] as String? ?? 'Étape';
                final time = stop['arrival_time'] as String?;
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: accentColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          title,
                          style: PetitBooTheme.caption.copyWith(
                            color: PetitBooTheme.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (time != null)
                        Text(
                          time,
                          style: PetitBooTheme.caption.copyWith(
                            color: accentColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                );
              })),
              if (_stopsCount > 2)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 14),
                  child: Text(
                    '+${_stopsCount - 2} autres étapes',
                    style: PetitBooTheme.caption.copyWith(
                      color: PetitBooTheme.textTertiary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ],

            // Quick action buttons
            const SizedBox(height: 12),
            Row(
              children: [
                _buildActionButton(
                  Icons.map_outlined,
                  'Maps',
                  accentColor,
                  () => _openInGoogleMaps(context),
                ),
                const SizedBox(width: 8),
                _buildActionButton(
                  Icons.navigation_outlined,
                  'Waze',
                  const Color(0xFF33CCFF),
                  () => _openInWaze(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaChip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: PetitBooTheme.textTertiary),
        const SizedBox(width: 4),
        Text(
          label,
          style: PetitBooTheme.caption.copyWith(
            color: PetitBooTheme.textTertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: color.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: PetitBooTheme.caption.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openInGoogleMaps(BuildContext context) {
    final validStops = _stops.where((s) {
      final coords = s['coordinates'] as Map<String, dynamic>?;
      if (coords != null) {
        return coords['lat'] != null && coords['lng'] != null;
      }
      return s['latitude'] != null && s['longitude'] != null;
    }).toList();

    if (validStops.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aucune coordonnée disponible')),
      );
      return;
    }

    final waypoints = validStops.map((s) {
      final coords = s['coordinates'] as Map<String, dynamic>?;
      final lat = coords?['lat'] ?? s['latitude'];
      final lng = coords?['lng'] ?? s['longitude'];
      return '$lat,$lng';
    }).join('/');

    final url = 'https://www.google.com/maps/dir/$waypoints';
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  void _openInWaze(BuildContext context) {
    final validStops = _stops.where((s) {
      final coords = s['coordinates'] as Map<String, dynamic>?;
      if (coords != null) {
        return coords['lat'] != null && coords['lng'] != null;
      }
      return s['latitude'] != null && s['longitude'] != null;
    }).toList();

    if (validStops.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aucune coordonnée disponible')),
      );
      return;
    }

    final firstStop = validStops.first;
    final coords = firstStop['coordinates'] as Map<String, dynamic>?;
    final lat = coords?['lat'] ?? firstStop['latitude'];
    final lng = coords?['lng'] ?? firstStop['longitude'];

    final url = 'https://waze.com/ul?ll=$lat,$lng&navigate=yes';
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final formatter = DateFormat('EEE d MMM', 'fr_FR');
      final formatted = formatter.format(date);
      return formatted[0].toUpperCase() + formatted.substring(1);
    } catch (_) {
      return dateStr;
    }
  }

  String _formatDuration(int minutes) {
    if (minutes < 60) return '${minutes}min';
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (mins == 0) return '${hours}h';
    return '${hours}h${mins.toString().padLeft(2, '0')}';
  }
}
