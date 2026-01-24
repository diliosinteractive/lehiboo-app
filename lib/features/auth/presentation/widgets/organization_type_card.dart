import 'package:flutter/material.dart';
import '../providers/business_register_provider.dart';

/// Card widget for selecting organization type
///
/// Displays an icon, title, and description for each organization type.
/// Shows orange border and title when selected.
class OrganizationTypeCard extends StatelessWidget {
  final OrganizationType type;
  final bool isSelected;
  final VoidCallback onTap;

  const OrganizationTypeCard({
    super.key,
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  /// Get icon for organization type
  IconData get _icon => switch (type) {
    OrganizationType.company => Icons.business_outlined,
    OrganizationType.association => Icons.favorite_border,
    OrganizationType.municipality => Icons.account_balance_outlined,
  };

  /// Get description for organization type
  String get _description => switch (type) {
    OrganizationType.company => 'Soci\u00e9t\u00e9, TPE, PME, startup...',
    OrganizationType.association => 'Loi 1901, fondation...',
    OrganizationType.municipality => 'Mairie, d\u00e9partement, r\u00e9gion...',
  };

  static const _orangeColor = Color(0xFFFF601F);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? _orangeColor.withValues(alpha: 0.08)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? _orangeColor : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon in circle
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected
                    ? _orangeColor.withValues(alpha: 0.15)
                    : Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                _icon,
                size: 22,
                color: isSelected ? _orangeColor : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),

            // Title
            Text(
              type.label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? _orangeColor : const Color(0xFF2D3748),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),

            // Description
            Text(
              _description,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
