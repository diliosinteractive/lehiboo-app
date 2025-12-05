import 'package:flutter/material.dart';
import '../../themes/hb_theme.dart';

enum HbButtonType { primary, secondary, tertiary }

class HbButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final HbButtonType type;
  final bool fullWidth;
  final bool isLoading;

  const HbButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.type = HbButtonType.primary,
    this.fullWidth = false,
    this.isLoading = false,
  });

  const HbButton.primary({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.fullWidth = false,
    this.isLoading = false,
  }) : type = HbButtonType.primary;

  const HbButton.secondary({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.fullWidth = false,
    this.isLoading = false,
  }) : type = HbButtonType.secondary;

  const HbButton.tertiary({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.fullWidth = false,
    this.isLoading = false,
  }) : type = HbButtonType.tertiary;

  @override
  Widget build(BuildContext context) {
    final tokens = HbTheme.tokens(context);
    
    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: type == HbButtonType.primary ? Colors.white : tokens.brand,
            ),
          ),
          SizedBox(width: tokens.spacing.s),
        ] else if (icon != null) ...[
          Icon(icon, size: 20),
          SizedBox(width: tokens.spacing.s),
        ],
        Text(label),
      ],
    );

    Widget button;
    switch (type) {
      case HbButtonType.primary:
        button = ElevatedButton(
          onPressed: isLoading ? null : onTap,
          child: content,
        );
        break;
      case HbButtonType.secondary:
        button = OutlinedButton(
          onPressed: isLoading ? null : onTap,
          child: content,
        );
        break;
      case HbButtonType.tertiary:
        button = TextButton(
          onPressed: isLoading ? null : onTap,
          child: content,
        );
        break;
    }

    if (fullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }
}
