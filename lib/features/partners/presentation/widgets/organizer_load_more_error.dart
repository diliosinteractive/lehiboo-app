import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/themes/colors.dart';

/// Inline pagination failure that preserves already-loaded organizer rows and
/// gives the user an explicit way to retry the failed page.
class OrganizerLoadMoreError extends StatelessWidget {
  const OrganizerLoadMoreError({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[700], fontSize: 13),
          ),
          const SizedBox(height: 4),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh, size: 18),
            label: Text(context.l10n.commonRetry),
            style: TextButton.styleFrom(
              foregroundColor: HbColors.brandPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
