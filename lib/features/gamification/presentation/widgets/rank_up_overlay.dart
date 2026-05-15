import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/l10n/l10n.dart';

/// Overlay plein écran affiché lors du franchissement d'un palier de rang.
/// Auto-dismiss après 6 s ou au tap sur le bouton "Continuer".
class RankUpOverlay {
  static void show(
    BuildContext context, {
    required String rankLabel,
    String? rankIcon,
  }) {
    showOnOverlay(
      Overlay.of(context),
      rankLabel: rankLabel,
      rankIcon: rankIcon,
    );
  }

  /// Variante qui prend un [OverlayState] directement (Plan 05) — utile
  /// quand on n'a pas de descendant d'Overlay sous la main.
  static void showOnOverlay(
    OverlayState overlay, {
    required String rankLabel,
    String? rankIcon,
  }) {
    HapticFeedback.mediumImpact();

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => _RankUpContent(
        rankLabel: rankLabel,
        rankIcon: rankIcon,
        onDismiss: () {
          if (entry.mounted) entry.remove();
        },
      ),
    );

    overlay.insert(entry);
  }
}

class _RankUpContent extends StatefulWidget {
  final String rankLabel;
  final String? rankIcon;
  final VoidCallback onDismiss;

  const _RankUpContent({
    required this.rankLabel,
    required this.rankIcon,
    required this.onDismiss,
  });

  @override
  State<_RankUpContent> createState() => _RankUpContentState();
}

class _RankUpContentState extends State<_RankUpContent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();
    _scale = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    Future.delayed(const Duration(seconds: 6), () {
      if (mounted) widget.onDismiss();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: Material(
        color: Colors.black.withOpacity(0.7),
        child: Center(
          child: ScaleTransition(
            scale: _scale,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 32),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF8A65), Color(0xFFFF601F)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.rankIcon != null && widget.rankIcon!.isNotEmpty)
                    Text(
                      widget.rankIcon!,
                      style: const TextStyle(fontSize: 72),
                    )
                  else
                    const Icon(
                      Icons.emoji_events,
                      size: 72,
                      color: Colors.white,
                    ),
                  const SizedBox(height: 16),
                  Text(
                    context.l10n.gamificationRankUpCongratsTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.gamificationRankUpNowRank(widget.rankLabel),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 24),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white, width: 2),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    onPressed: widget.onDismiss,
                    child: Text(
                      context.l10n.commonContinue,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
