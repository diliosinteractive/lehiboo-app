import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../routes/app_router.dart';
import '../../application/hibons_service.dart';
import '../../data/models/hibons_update.dart';
import 'rank_up_overlay.dart';

/// Widget invisible, monté une seule fois sous le router (`LeHibooApp`),
/// qui écoute les streams de [HibonsService] et déclenche les animations
/// (toast `+XX Hibons`, overlay rank-up).
///
/// Pour accéder à un Overlay valide, on utilise [rootNavigatorKey] (qui pointe
/// **sous** le Navigator géré par GoRouter), pas le BuildContext de ce widget
/// — celui-ci se trouve au-dessus du Navigator et n'a pas d'Overlay ancêtre.
///
/// Sérialise les toasts pour éviter le télescopage en cas de mass-favoriting.
class HibonsAnimationCoordinator extends StatefulWidget {
  final Widget child;

  const HibonsAnimationCoordinator({super.key, required this.child});

  @override
  State<HibonsAnimationCoordinator> createState() =>
      _HibonsAnimationCoordinatorState();
}

class _HibonsAnimationCoordinatorState
    extends State<HibonsAnimationCoordinator> {
  StreamSubscription<HibonsUpdate>? _deltaSub;
  StreamSubscription<RankUpEvent>? _rankUpSub;
  final Queue<HibonsUpdate> _toastQueue = Queue();
  bool _showingToast = false;

  @override
  void initState() {
    super.initState();
    debugPrint('🪙 HibonsAnimationCoordinator: subscribing to streams');
    _deltaSub = HibonsService.instance.deltaStream.listen(_enqueueToast);
    _rankUpSub = HibonsService.instance.rankUpStream.listen(_showRankUp);
  }

  @override
  void dispose() {
    _deltaSub?.cancel();
    _rankUpSub?.cancel();
    super.dispose();
  }

  /// Récupère l'OverlayState racine (sous le Navigator de GoRouter).
  /// `null` si le navigator n'est pas encore monté (cold start très précoce).
  OverlayState? get _rootOverlay {
    final navState = rootNavigatorKey.currentState;
    if (navState == null) return null;
    final overlay = navState.overlay;
    if (overlay == null || !overlay.mounted) return null;
    return overlay;
  }

  void _enqueueToast(HibonsUpdate update) {
    debugPrint(
        '🪙 HibonsAnimationCoordinator: enqueue toast delta=${update.delta}');
    _toastQueue.add(update);
    _drainToastQueue();
  }

  Future<void> _drainToastQueue() async {
    debugPrint(
        '🪙 drain start: showing=$_showingToast queue=${_toastQueue.length} mounted=$mounted');
    if (_showingToast) {
      debugPrint('🪙 drain: already showing, skip');
      return;
    }
    while (_toastQueue.isNotEmpty) {
      if (!mounted) {
        debugPrint('🪙 drain: not mounted, abort');
        return;
      }
      final update = _toastQueue.removeFirst();
      _showingToast = true;
      try {
        _showToast(update);
      } catch (e, st) {
        debugPrint('🪙 _showToast error: $e\n$st');
      }
      // Attendre la durée du toast avant le suivant pour éviter l'empilement.
      await Future.delayed(const Duration(milliseconds: 800));
      _showingToast = false;
    }
  }

  void _showToast(HibonsUpdate update) {
    final messenger = scaffoldMessengerKey.currentState;
    if (messenger == null) {
      debugPrint(
          '🪙 HibonsAnimationCoordinator: no messenger, skipping snackbar');
      return;
    }
    debugPrint(
      '🪙 HibonsAnimationCoordinator: showing snackbar delta=${update.delta} source=${update.source}',
    );

    // Règle de fallback (cf. HIBONS_REWARD_MESSAGE_MOBILE_SPEC §"Règle d'affichage mobile") :
    // reward_message (i18n backend) → animation_label (générique "+N Hibons")
    // → fallback dur si tout est null.
    final fallback = update.delta > 0
        ? context.l10n.gamificationHibonsGainedToast(update.delta)
        : context.l10n.gamificationHibonsDelta(update.delta);
    final title = update.rewardMessage ?? update.animationLabel ?? fallback;

    if (update.delta > 0) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.monetization_on,
                    color: Color(0xFFFFB300), size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF2D3748),
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
    } else if (update.delta < 0) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(title),
            backgroundColor: const Color(0xFF6B7280),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
    }
  }

  void _showRankUp(RankUpEvent event) {
    final overlay = _rootOverlay;
    if (overlay == null) return;
    RankUpOverlay.showOnOverlay(overlay, rankLabel: event.rankLabel);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
