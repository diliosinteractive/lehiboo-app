import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/providers/auth_session_key_provider.dart';
import '../../domain/entities/event.dart';
import '../screens/event_detail_screen.dart';
import '../widgets/detail/event_password_sheet.dart';

/// Single chokepoint for navigating to the event detail screen when an
/// [Event] object is in scope. If the event is password-protected, this
/// shows the password sheet first and only navigates after a successful
/// unlock. The unlocked event is pre-seeded into the detail controller's
/// cache, and held there until the detail screen closes, so the screen
/// renders without a follow-up GET.
Future<void> openEvent(
  BuildContext context,
  WidgetRef ref,
  Event event, {
  required AuthSessionKey ownerSession,
}) async {
  if (!identical(ref.read(authSessionKeyProvider), ownerSession)) return;
  if (!event.isPasswordProtected) {
    context.push('/event/${event.id}');
    return;
  }
  final request = eventDetailRequest(ownerSession, event.id);
  final provider = eventDetailControllerProvider(request);
  final keepAlive = ref.listenManual(provider, (_, __) {});
  final controller = ref.read(provider.notifier);
  try {
    final unlocked = await EventPasswordSheet.show(
      context,
      identifier: event.id,
      ownerSession: ownerSession,
      onSubmit: (pw) => controller.unlock(pw, owner: ownerSession),
      eventTitle: event.title,
    );
    if (unlocked == null ||
        !context.mounted ||
        !identical(ref.read(authSessionKeyProvider), ownerSession) ||
        !identical(ref.read(provider.notifier), controller)) {
      return;
    }
    // Keep the verified payload in this exact session's cache so the detail
    // screen renders without another protected request.
    if (!controller.seed(unlocked, owner: ownerSession)) return;
    // The controller is autoDispose and the backend never remembers an
    // unlock. The detail screen only subscribes once its route builds, a
    // frame after the push, so releasing the controller before then would
    // dispose the payload and send the screen back to the locked shell.
    await context.push('/event/${event.id}');
  } finally {
    keepAlive.close();
  }
}
