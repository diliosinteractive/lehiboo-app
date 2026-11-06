import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/providers/auth_session_key_provider.dart';
import '../../domain/entities/event.dart';

/// Single chokepoint for navigating to the event detail screen when an
/// [Event] object is in scope.
///
/// Password-protected events are unlocked on the detail screen itself: its
/// locked view opens the password sheet over the controller it watches, so
/// the verified payload never has to outlive a route transition.
Future<void> openEvent(
  BuildContext context,
  WidgetRef ref,
  Event event, {
  required AuthSessionKey ownerSession,
}) async {
  if (!context.mounted ||
      !identical(ref.read(authSessionKeyProvider), ownerSession)) {
    return;
  }
  context.push('/event/${event.id}');
}
