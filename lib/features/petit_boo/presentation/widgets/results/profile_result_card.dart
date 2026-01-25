import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../../core/themes/colors.dart';
import '../../../data/models/tool_result_dto.dart';

/// Card displaying profile info from getMyProfile tool
class ProfileResultCard extends StatelessWidget {
  final ProfileToolResult result;

  const ProfileResultCard({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
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
                    backgroundColor: HbColors.brandPrimary.withOpacity(0.1),
                    backgroundImage: result.user.avatarUrl != null
                        ? CachedNetworkImageProvider(result.user.avatarUrl!)
                        : null,
                    child: result.user.avatarUrl == null
                        ? Text(
                            _getInitials(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: HbColors.brandPrimary,
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
                          _getDisplayName(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: HbColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          result.user.email,
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
              if (result.hiboosBalance > 0)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        HbColors.brandPrimary.withOpacity(0.1),
                        HbColors.brandPrimary.withOpacity(0.05),
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
                              'Hiboos Balance',
                              style: TextStyle(
                                fontSize: 12,
                                color: HbColors.textSecondary,
                              ),
                            ),
                            Text(
                              '${result.hiboosBalance} Hiboos',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: HbColors.brandPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.push('/hibons-dashboard'),
                        child: const Text('View'),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 16),

              // Stats
              if (result.stats != null) _buildStats(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStats() {
    final stats = result.stats!;

    return Row(
      children: [
        _StatItem(
          icon: Icons.confirmation_number_outlined,
          label: 'Bookings',
          value: stats.totalBookings.toString(),
        ),
        _StatItem(
          icon: Icons.event_available,
          label: 'Attended',
          value: stats.totalEventsAttended.toString(),
        ),
        _StatItem(
          icon: Icons.favorite_border,
          label: 'Favorites',
          value: stats.totalFavorites.toString(),
        ),
        _StatItem(
          icon: Icons.notifications_outlined,
          label: 'Alerts',
          value: stats.totalAlerts.toString(),
        ),
      ],
    );
  }

  String _getDisplayName() {
    final firstName = result.user.firstName ?? '';
    final lastName = result.user.lastName ?? '';

    if (firstName.isNotEmpty || lastName.isNotEmpty) {
      return '$firstName $lastName'.trim();
    }
    return 'User';
  }

  String _getInitials() {
    final firstName = result.user.firstName ?? '';
    final lastName = result.user.lastName ?? '';

    final first = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final last = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';

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
          ),
        ],
      ),
    );
  }
}
