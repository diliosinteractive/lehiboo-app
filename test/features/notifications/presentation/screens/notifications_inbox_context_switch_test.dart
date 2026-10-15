import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/themes/app_theme.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/notifications/domain/entities/in_app_notification.dart';
import 'package:lehiboo/features/notifications/domain/repositories/in_app_notifications_repository.dart';
import 'package:lehiboo/features/notifications/presentation/screens/notifications_inbox_screen.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

void main() {
  testWidgets('an organizer switches the inbox to participant notifications',
      (tester) async {
    final repository = _ContextNotificationsRepository();
    final container = _container(_organizer, repository);
    addTearDown(container.dispose);
    await tester.pumpWidget(_app(container));
    await tester.pumpAndSettle();

    expect(find.text('Organizer'), findsOneWidget);
    expect(find.text('Participant'), findsOneWidget);
    expect(find.text('New booking received'), findsOneWidget);
    // Unread participant notifications are announced on their segment.
    expect(find.text('3'), findsOneWidget);

    await tester.tap(find.text('Participant'));
    await tester.pumpAndSettle();

    expect(find.text('Your event starts in 1 hour'), findsOneWidget);
    expect(find.text('New booking received'), findsNothing);
    expect(repository.requestedContexts.last, 'participant');
  });

  testWidgets('a participant account has no context switch', (tester) async {
    final repository = _ContextNotificationsRepository();
    final container = _container(_participant, repository);
    addTearDown(container.dispose);
    await tester.pumpWidget(_app(container));
    await tester.pumpAndSettle();

    expect(find.text('Organizer'), findsNothing);
    expect(find.text('Your event starts in 1 hour'), findsOneWidget);
    expect(repository.requestedContexts, everyElement('participant'));
  });
}

ProviderContainer _container(
  HbUser user,
  InAppNotificationsRepository repository,
) {
  final container = ProviderContainer(
    overrides: [
      authProvider.overrideWith((ref) => _TestAuthNotifier(ref, user)),
      inAppNotificationsRepositoryProvider.overrideWithValue(repository),
    ],
  );
  container.read(authProvider);
  return container;
}

Widget _app(ProviderContainer container) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      theme: AppTheme.lightTheme,
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const NotificationsInboxScreen(),
    ),
  );
}

class _NeverCompletingAuthRepository implements AuthRepository {
  final Completer<bool> _result = Completer<bool>();

  @override
  Future<bool> isAuthenticated() => _result.future;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _TestAuthNotifier extends AuthNotifier {
  _TestAuthNotifier(Ref ref, HbUser user)
      : super(_NeverCompletingAuthRepository(), ref) {
    state = AuthState(status: AuthStatus.authenticated, user: user);
  }
}

class _ContextNotificationsRepository implements InAppNotificationsRepository {
  final requestedContexts = <String>[];

  @override
  Future<InAppNotificationsPage> getNotifications({
    int page = 1,
    int perPage = 20,
    bool unreadOnly = false,
    String? type,
    required String context,
    String? organizationId,
    String? search,
  }) async {
    requestedContexts.add(context);
    final notification = context == 'vendor'
        ? _notification(
            'vendor', 'booking_received_organiser', 'New booking received')
        : _notification('participant', 'event_start_reminder',
            'Your event starts in 1 hour');
    return InAppNotificationsPage(
      notifications: [notification],
      currentPage: 1,
      lastPage: 1,
      perPage: perPage,
      total: 1,
    );
  }

  @override
  Future<int> getUnreadCount({
    required String context,
    String? organizationId,
  }) async {
    return context == 'vendor' ? 1 : 3;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

InAppNotification _notification(String id, String type, String title) =>
    InAppNotification(
      id: id,
      type: type,
      title: title,
      message: '',
      isRead: false,
      createdAt: DateTime(2026),
    );

const _organizer = HbUser(
  id: 'organizer',
  email: 'organizer@example.test',
  displayName: 'Organizer account',
  role: UserRole.partner,
);

const _participant = HbUser(
  id: 'participant',
  email: 'participant@example.test',
  displayName: 'Participant account',
);
