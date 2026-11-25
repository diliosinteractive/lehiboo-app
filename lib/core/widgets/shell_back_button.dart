import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// App bar back button for a page inside the bottom-nav shell that is not a
/// tab, such as Profile.
///
/// Opened directly (a link, a redirect after sign-in), such a page has no page
/// under it, so the default back button does not show, and no bottom nav
/// either. iOS has no system back: without this button the user would be
/// stuck. It pops when there is somewhere to go back to, and goes home
/// otherwise.
class ShellBackButton extends StatelessWidget {
  const ShellBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const BackButtonIcon(),
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      onPressed: () => context.canPop() ? context.pop() : context.go('/'),
    );
  }
}
