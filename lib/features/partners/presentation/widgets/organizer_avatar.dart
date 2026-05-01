import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/themes/colors.dart';

/// Circular avatar with a white ring + drop-shadow. Falls back to the first
/// letter of [fallbackName] when no logo is provided.
class OrganizerAvatar extends StatelessWidget {
  final String? logoUrl;
  final String fallbackName;
  final double size;

  const OrganizerAvatar({
    super.key,
    required this.logoUrl,
    required this.fallbackName,
    this.size = 72,
  });

  @override
  Widget build(BuildContext context) {
    final initial = fallbackName.isNotEmpty
        ? fallbackName.characters.first.toUpperCase()
        : '?';
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: logoUrl != null && logoUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: logoUrl!,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => _initialFallback(initial),
              )
            : _initialFallback(initial),
      ),
    );
  }

  Widget _initialFallback(String initial) => Container(
        color: HbColors.brandPrimary.withValues(alpha: 0.12),
        alignment: Alignment.center,
        child: Text(
          initial,
          style: TextStyle(
            fontSize: size * 0.42,
            fontWeight: FontWeight.bold,
            color: HbColors.brandPrimary,
          ),
        ),
      );
}
