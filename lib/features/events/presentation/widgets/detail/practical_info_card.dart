import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lehiboo/core/themes/colors.dart';

/// Card d'info pratique pour la grille 2x2
///
/// Tap → ouvre un bottom sheet avec détails
class PracticalInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color color;
  final bool available;
  final VoidCallback? onTap;
  final String? badge;

  const PracticalInfoCard({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.color = HbColors.brandPrimary,
    this.available = true,
    this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap != null
          ? () {
              HapticFeedback.lightImpact();
              onTap!();
            }
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: available ? Colors.white : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: available ? color.withValues(alpha: 0.2) : Colors.grey.shade300,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header avec icône et badge
            Row(
              children: [
                // Icône
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (available ? color : Colors.grey).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: available ? color : Colors.grey,
                    size: 22,
                  ),
                ),
                const Spacer(),
                // Badge uniquement si explicitement fourni
                // Supprimé : checkmark automatique qui était incongru sur "Lieu"
                if (badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      badge!,
                      style: TextStyle(
                        color: color,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                else if (!available)
                  const Icon(
                    Icons.cancel_outlined,
                    color: Colors.grey,
                    size: 18,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            // Titre
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: available ? HbColors.textPrimary : Colors.grey,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            // Sous-titre
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            // Indicateur tap
            if (onTap != null) ...[
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Détails',
                    style: TextStyle(
                      fontSize: 11,
                      color: color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Icon(
                    Icons.chevron_right,
                    size: 14,
                    color: color,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Card compacte pour les services rapides
class CompactInfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool available;
  final VoidCallback? onTap;

  const CompactInfoChip({
    super.key,
    required this.icon,
    required this.label,
    this.color = HbColors.brandPrimary,
    this.available = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: (available ? color : Colors.grey).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: (available ? color : Colors.grey).withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: available ? color : Colors.grey,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: available ? color : Colors.grey,
              ),
            ),
            if (available) ...[
              const SizedBox(width: 4),
              const Icon(
                Icons.check,
                size: 14,
                color: Colors.green,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
