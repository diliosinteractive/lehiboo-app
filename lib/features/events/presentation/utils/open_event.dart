import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/event.dart';
import '../screens/event_detail_screen.dart';
import '../widgets/detail/event_password_sheet.dart';

/// Single chokepoint for navigating to the event detail screen when an
/// [Event] object is in scope. If the event is password-protected, this
/// shows the password sheet first and only navigates after a successful
/// unlock. The unlocked event is pre-seeded into the detail controller's
/// cache so the detail screen renders without a follow-up GET.
Future<void> openEvent(
  BuildContext context,
  WidgetRef ref,
  Event event,
) async {
  if (event.isPasswordProtected) {
    final unlocked = await EventPasswordSheet.show(
      context,
      identifier: event.id,
      onSubmit: (pw) => ref
          .read(eventDetailControllerProvider(event.id).notifier)
          .unlock(pw),
      eventTitle: event.title,
    );
    if (unlocked == null) return;
    // Sheet already updated controller state via unlock(); also seed in case
    // the user landed via a different identifier (slug vs uuid).
    ref.read(eventDetailControllerProvider(event.id).notifier).seed(unlocked);
  }
  if (!context.mounted) return;
  context.push('/event/${event.id}');
}
