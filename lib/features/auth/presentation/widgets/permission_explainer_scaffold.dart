import 'package:flutter/material.dart';

import '../../../../core/themes/colors.dart';

/// Shared layout for the post-signup permission screens (location, notifications).
///
/// Renders a centered icon badge, title, intro paragraph, bullet list, a muted
/// reassurance line, and a primary CTA. The CTA shows a spinner while [busy]
/// is true and is disabled during that time.
class PermissionExplainerScaffold extends StatelessWidget {
  const PermissionExplainerScaffold({
    super.key,
    required this.icon,
    required this.title,
    required this.intro,
    required this.bullets,
    required this.reassurance,
    required this.ctaLabel,
    required this.busy,
    required this.onContinue,
    this.grantedLabel,
  });

  final IconData icon;
  final String title;
  final String intro;
  final List<String> bullets;
  final String reassurance;
  final String ctaLabel;
  final bool busy;
  final VoidCallback onContinue;

  /// When set, render a green check + this label above the CTA to signal
  /// that the permission has already been granted on this device.
  final String? grantedLabel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HbColors.surfaceWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Center(
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: HbColors.brandPrimary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 48, color: HbColors.brandPrimary),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: HbColors.textPrimary,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                intro,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: HbColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32),
              ...bullets.map((b) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: HbColors.brandPrimary,
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            b,
                            style: const TextStyle(
                              fontSize: 15,
                              color: HbColors.textPrimary,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
              const Spacer(flex: 2),
              if (grantedLabel != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: HbColors.success.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: HbColors.success.withValues(alpha: 0.30),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle,
                          color: HbColors.success, size: 22),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          grantedLabel!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: HbColors.success,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Text(
                reassurance,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: HbColors.textMuted,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: busy ? null : onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HbColors.brandPrimary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        HbColors.brandPrimary.withValues(alpha: 0.6),
                    disabledForegroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: busy
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(ctaLabel),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
