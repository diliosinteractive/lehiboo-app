import 'package:flutter/material.dart';
import '../../themes/hb_theme.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = HbTheme.tokens(context);
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: tokens.spacing.l,
        vertical: tokens.spacing.s,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: textTheme.titleLarge,
          ),
          if (actionLabel != null && onAction != null)
            TextButton(
              onPressed: onAction,
              child: Text(
                actionLabel!,
                style: textTheme.labelLarge?.copyWith(
                  color: tokens.brand,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
