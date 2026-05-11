import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import 'package:lehiboo/features/gamification/data/datasources/gamification_api_datasource.dart';
import 'package:share_plus/share_plus.dart';

class ShareButton extends ConsumerWidget {
  final Event event;
  final String? shareUrl;
  final Color? backgroundColor;
  final Color? iconColor;

  const ShareButton({
    super.key,
    required this.event,
    this.shareUrl,
    this.backgroundColor,
    this.iconColor,
  });

  String _buildShareText(WidgetRef ref) {
    final url = shareUrl ?? 'https://lehiboo.com/events/${event.slug}';
    final user = ref.read(authProvider).user;
    final senderName = (user?.firstName?.trim().isNotEmpty ?? false)
        ? user!.firstName!.trim()
        : (user?.displayName.trim().isNotEmpty ?? false)
            ? user!.displayName.trim()
            : null;

    if (senderName != null) {
      return "$senderName vous partage l'évènement ${event.title} : $url";
    }
    return "Découvre l'évènement ${event.title} : $url";
  }

  Future<void> _handleShare(WidgetRef ref) async {
    HapticFeedback.lightImpact();

    final text = _buildShareText(ref);
    await Share.share(text, subject: event.title);
    await ref.read(gamificationApiDataSourceProvider).trackEventShare(
          event.slug,
          'native',
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => _handleShare(ref),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
            ),
          ],
        ),
        child: Center(
          child: Icon(
            Icons.share_outlined,
            size: 20,
            color: iconColor ?? HbColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
