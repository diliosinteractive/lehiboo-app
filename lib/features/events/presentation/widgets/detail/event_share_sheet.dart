import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lehiboo/config/env_config.dart';
import 'package:lehiboo/core/analytics/analytics_event.dart';
import 'package:lehiboo/core/analytics/analytics_provider.dart';
import 'package:lehiboo/core/l10n/l10n.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_session_key_provider.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import 'package:lehiboo/features/gamification/data/datasources/gamification_api_datasource.dart';
import 'package:share_plus/share_plus.dart';

typedef EventShareLauncher = Future<ShareResult> Function(ShareParams params);

/// Test seam around the native share UI, whose result can arrive long after
/// the event page's authenticated owner has changed.
final eventShareLauncherProvider = Provider<EventShareLauncher>((ref) {
  return SharePlus.instance.share;
});

class ShareButton extends ConsumerWidget {
  final Event event;
  final AuthSessionKey ownerSession;
  final String? shareUrl;
  final Color? backgroundColor;
  final Color? iconColor;

  const ShareButton({
    super.key,
    required this.event,
    required this.ownerSession,
    this.shareUrl,
    this.backgroundColor,
    this.iconColor,
  });

  String _buildShareText(BuildContext context, WidgetRef ref) {
    final url = shareUrl ?? EnvConfig.eventShareUrl(event.slug);
    final user = ref.read(authProvider).user;
    final senderName = (user?.firstName?.trim().isNotEmpty ?? false)
        ? user!.firstName!.trim()
        : (user?.displayName.trim().isNotEmpty ?? false)
            ? user!.displayName.trim()
            : null;

    if (senderName != null) {
      return context.l10n.eventShareWithSender(senderName, event.title, url);
    }
    return context.l10n.eventShareDefault(event.title, url);
  }

  Future<void> _handleShare(BuildContext context, WidgetRef ref) async {
    // The button may still be mounted for one frame after an account switch.
    // Never open a user-owned action from an event rendered for another exact
    // auth session (including a rapid A -> B -> A replacement).
    if (!identical(ref.read(authSessionKeyProvider), ownerSession)) return;

    HapticFeedback.lightImpact();

    final text = _buildShareText(context, ref);
    late final ShareResult shareResult;
    try {
      shareResult = await ref.read(eventShareLauncherProvider)(
        ShareParams(text: text, subject: event.title),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.commonShareFailed)),
      );
      return;
    }

    if (!context.mounted) return;
    // Native share UIs are unbounded async work. If auth changed while one was
    // open, its analytics and Hibons reward still belong to the old session.
    if (!identical(ref.read(authSessionKeyProvider), ownerSession)) return;
    if (shareResult.status == ShareResultStatus.dismissed) return;
    ref.read(analyticsServiceProvider).logEvent(
      AnalyticsEvent.eventShared,
      params: {
        AnalyticsParam.eventUuid: event.id,
        AnalyticsParam.channel: AnalyticsChannel.native,
      },
    );
    // Aussi le standard GA4 `share` pour les rapports built-in.
    ref.read(analyticsServiceProvider).logEvent(
      AnalyticsEvent.share,
      params: {
        AnalyticsParam.contentType: 'event',
        AnalyticsParam.itemId: event.id,
      },
    );
    try {
      await ref.read(gamificationApiDataSourceProvider).trackEventShare(
            event.slug,
            'native',
          );
    } catch (error) {
      debugPrint('Event share reward tracking failed: $error');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => _handleShare(context, ref),
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
