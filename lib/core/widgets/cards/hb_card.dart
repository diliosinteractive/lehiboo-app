import 'package:flutter/material.dart';
import '../../themes/hb_theme.dart';

class HbCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final double? elevation;
  final BorderSide? border;

  const HbCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.backgroundColor,
    this.elevation,
    this.border,
  });

  factory HbCard.elevated({
    required Widget child,
    VoidCallback? onTap,
    EdgeInsetsGeometry? padding,
  }) {
    return HbCard(
      elevation: 4,
      onTap: onTap,
      padding: padding,
      child: child,
    );
  }

  factory HbCard.outlined({
    required Widget child,
    VoidCallback? onTap,
    EdgeInsetsGeometry? padding,
    required BuildContext context,
  }) {
    return HbCard(
      elevation: 0,
      border: BorderSide(color: Colors.grey[300]!),
      onTap: onTap,
      padding: padding,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = HbTheme.tokens(context);

    return Card(
      elevation: elevation ?? 0.5,
      color: backgroundColor ?? Colors.white,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(tokens.radiusXL),
        side: border ?? BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(tokens.radiusXL),
        child: Padding(
          padding: padding ?? EdgeInsets.all(tokens.spacing.m),
          child: child,
        ),
      ),
    );
  }
}
