import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../../core/themes/colors.dart';
import '../../../data/models/tool_schema_dto.dart';
import 'dynamic_tool_result_card.dart';

/// Card displaying user profile information
class ProfileCard extends StatelessWidget {
  final ToolSchemaDto schema;
  final Map<String, dynamic> data;

  const ProfileCard({
    super.key,
    required this.schema,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    // User info - can be nested under 'user' key
    final userData = data['user'] as Map<String, dynamic>? ?? data;
    final firstName = userData['first_name'] as String?;
    final lastName = userData['last_name'] as String?;
    final email = userData['email'] as String? ?? '';
    final avatarUrl = userData['avatar_url'] as String?;

    // Stats - can be nested under 'stats' key
    final statsData = data['stats'] as Map<String, dynamic>?;

    // Hiboos balance
    final hiboosBalance = data['hiboos_balance'] as int? ?? 0;

    final accentColor = parseHexColor(schema.color);

    return GestureDetector(
      onTap: () => context.push('/profile'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Profile header
              Row(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: accentColor.withOpacity(0.1),
                    backgroundImage: avatarUrl != null
                        ? CachedNetworkImageProvider(avatarUrl)
                        : null,
                    child: avatarUrl == null
                        ? Text(
                            _getInitials(firstName, lastName),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: accentColor,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),

                  // Name and email
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getDisplayName(firstName, lastName),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: HbColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          email,
                          style: TextStyle(
                            fontSize: 13,
                            color: HbColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Edit button
                  IconButton(
                    onPressed: () => context.push('/profile/edit'),
                    icon: const Icon(Icons.edit_outlined),
                    color: HbColors.textSecondary,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Hiboos balance
              if (hiboosBalance > 0)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        accentColor.withOpacity(0.1),
                        accentColor.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Text('🦉', style: TextStyle(fontSize: 24)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Solde Hiboos',
                              style: TextStyle(
                                fontSize: 12,
                                color: HbColors.textSecondary,
                              ),
                            ),
                            Text(
                              '$hiboosBalance Hiboos',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: accentColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.push('/hibons-dashboard'),
                        child: const Text('Voir'),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 16),

              // Stats
              if (statsData != null || schema.responseSchema?.stats != null)
                _buildStats(statsData),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStats(Map<String, dynamic>? statsData) {
    final statSchemas = schema.responseSchema?.stats;

    // Use schema-defined stats if available
    if (statSchemas != null && statSchemas.isNotEmpty) {
      return Row(
        children: statSchemas.map((stat) {
          final value = getNestedValue(data, stat.field);
          return _StatItem(
            icon: getIconFromName(stat.icon),
            label: stat.label,
            value: (value ?? 0).toString(),
          );
        }).toList(),
      );
    }

    // Fallback to hardcoded stats
    if (statsData != null) {
      return Row(
        children: [
          _StatItem(
            icon: Icons.confirmation_number_outlined,
            label: 'Réservations',
            value: (statsData['total_bookings'] ?? 0).toString(),
          ),
          _StatItem(
            icon: Icons.event_available,
            label: 'Participations',
            value: (statsData['total_events_attended'] ?? 0).toString(),
          ),
          _StatItem(
            icon: Icons.favorite_border,
            label: 'Favoris',
            value: (statsData['total_favorites'] ?? 0).toString(),
          ),
          _StatItem(
            icon: Icons.notifications_outlined,
            label: 'Alertes',
            value: (statsData['total_alerts'] ?? 0).toString(),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  String _getDisplayName(String? firstName, String? lastName) {
    if (firstName != null || lastName != null) {
      return '${firstName ?? ''} ${lastName ?? ''}'.trim();
    }
    return 'Utilisateur';
  }

  String _getInitials(String? firstName, String? lastName) {
    final first =
        firstName != null && firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final last =
        lastName != null && lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    return '$first$last'.isNotEmpty ? '$first$last' : '?';
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(
            icon,
            size: 20,
            color: HbColors.textSecondary,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: HbColors.textPrimary,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: HbColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
