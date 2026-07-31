import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/themes/petit_boo_theme.dart';
import '../providers/petit_boo_chat_provider.dart';

class PetitBooServiceStatusBanner extends StatelessWidget {
  final PetitBooServiceStatus status;
  final VoidCallback onRetry;

  const PetitBooServiceStatusBanner({
    super.key,
    required this.status,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (status == PetitBooServiceStatus.available) {
      return const SizedBox.shrink();
    }

    final (message, icon) = switch (status) {
      PetitBooServiceStatus.checking => (
          context.l10n.petitBooServiceChecking,
          Icons.cloud_sync_outlined,
        ),
      PetitBooServiceStatus.unavailable => (
          context.l10n.petitBooServiceUnavailable,
          Icons.cloud_off_rounded,
        ),
      PetitBooServiceStatus.checkFailed => (
          context.l10n.petitBooServiceCheckFailed,
          Icons.wifi_off_rounded,
        ),
      PetitBooServiceStatus.available => throw StateError('unreachable'),
    };
    final isChecking = status == PetitBooServiceStatus.checking;

    return Container(
      key: ValueKey('petit-boo-service-${status.name}'),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: PetitBooTheme.spacing16,
        vertical: PetitBooTheme.spacing12,
      ),
      decoration: BoxDecoration(
        color: PetitBooTheme.warningLight,
        border: Border(
          bottom: BorderSide(
            color: PetitBooTheme.warning.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: PetitBooTheme.warning,
            size: PetitBooTheme.iconMd,
          ),
          const SizedBox(width: PetitBooTheme.spacing8),
          Expanded(
            child: Text(
              message,
              style: PetitBooTheme.bodySm.copyWith(
                color: PetitBooTheme.grey700,
              ),
            ),
          ),
          if (isChecking)
            const SizedBox.square(
              key: ValueKey('petit-boo-service-checking-progress'),
              dimension: PetitBooTheme.iconMd,
              child: CircularProgressIndicator(
                color: PetitBooTheme.warning,
                strokeWidth: 2,
              ),
            )
          else
            TextButton(
              key: const ValueKey('petit-boo-service-retry'),
              onPressed: onRetry,
              style: TextButton.styleFrom(
                foregroundColor: PetitBooTheme.warning,
                padding: const EdgeInsets.symmetric(
                  horizontal: PetitBooTheme.spacing12,
                ),
              ),
              child: Text(context.l10n.commonRetry),
            ),
        ],
      ),
    );
  }
}
