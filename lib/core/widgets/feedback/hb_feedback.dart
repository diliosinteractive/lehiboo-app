import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../themes/hb_theme.dart';
import '../buttons/hb_button.dart';

class HbEmptyState extends StatelessWidget {
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData icon;

  const HbEmptyState({
    super.key,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.icon = Icons.inbox_outlined,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = HbTheme.tokens(context);
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(tokens.spacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: Colors.grey[300],
            ),
            SizedBox(height: tokens.spacing.l),
            Text(
              title,
              style: textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: tokens.spacing.s),
            Text(
              message,
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: tokens.spacing.xl),
              HbButton.secondary(
                label: actionLabel!,
                onTap: onAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class HbErrorView extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;

  const HbErrorView({
    super.key,
    this.title = 'Oups !',
    this.message = 'Une erreur est survenue.',
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return HbEmptyState(
      title: title,
      message: message,
      actionLabel: onRetry != null ? 'Réessayer' : null,
      onAction: onRetry,
      icon: Icons.error_outline_rounded,
    );
  }
}

class HbShimmer extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const HbShimmer({
    super.key,
    required this.width,
    required this.height,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
