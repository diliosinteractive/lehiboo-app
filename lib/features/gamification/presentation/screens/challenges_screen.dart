import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/themes/colors.dart';

class ChallengesScreen extends StatelessWidget {
  const ChallengesScreen({super.key});

  static const _accentColor = Color(0xFF16A34A);
  static const _accentColorDark = Color(0xFF15803D);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          context.l10n.gamificationChallengesTitle,
          style: const TextStyle(
            color: HbColors.textSlate,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        foregroundColor: HbColors.textSlate,
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              sliver: SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: const _ComingSoonCard(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ComingSoonCard extends StatelessWidget {
  const _ComingSoonCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: ChallengesScreen._accentColor.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: HbColors.textSlate.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            const Positioned(
              right: -42,
              top: -42,
              child: _DecorativeCircle(size: 132, opacity: 0.07),
            ),
            const Positioned(
              left: -30,
              bottom: -36,
              child: _DecorativeCircle(size: 104, opacity: 0.05),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 40, 28, 36),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 104,
                    height: 104,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          ChallengesScreen._accentColor,
                          ChallengesScreen._accentColorDark,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: ChallengesScreen._accentColor
                              .withValues(alpha: 0.28),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.flag_rounded,
                      size: 52,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color:
                          ChallengesScreen._accentColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.auto_awesome_rounded,
                          size: 16,
                          color: ChallengesScreen._accentColorDark,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            context.l10n.gamificationComingSoonCta,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: ChallengesScreen._accentColorDark,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    context.l10n.gamificationChallengesComingSoonTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: HbColors.textSlate,
                      fontSize: 26,
                      height: 1.2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    context.l10n.gamificationChallengesComingSoonDescription,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: HbColors.textSecondary,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DecorativeCircle extends StatelessWidget {
  const _DecorativeCircle({required this.size, required this.opacity});

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: ChallengesScreen._accentColor.withValues(alpha: opacity),
        shape: BoxShape.circle,
      ),
    );
  }
}
