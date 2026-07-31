import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lehiboo/core/services/deep_link_service.dart';
import 'package:lehiboo/core/themes/app_theme.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/notifications/domain/entities/in_app_notification.dart';
import 'package:lehiboo/features/notifications/domain/repositories/in_app_notifications_repository.dart';
import 'package:lehiboo/features/notifications/presentation/screens/notifications_inbox_screen.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

void main() {
  testWidgets('late account A mark-read cannot navigate account B',
      (tester) async {
    final scope = _scope();
    addTearDown(scope.dispose);
    await tester.pumpWidget(_app(scope.container));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Account A private notification'));
    await tester.pump();
    expect(scope.repository.markReadRequests, hasLength(1));

    scope.auth.setUser(_accountB);
    await tester.pump();
    scope.repository.markReadRequests.single.complete();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(scope.deepLinks.notificationNavigations, 0);
  });

  testWidgets('account switch closes delete confirmation without deleting',
      (tester) async {
    final scope = _scope();
    addTearDown(scope.dispose);
    await tester.pumpWidget(_app(scope.container));
    await tester.pumpAndSettle();

    await tester.drag(find.byType(Dismissible), const Offset(-600, 0));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);

    scope.auth.setUser(_accountB);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(AlertDialog), findsNothing);
    expect(scope.repository.deletedIds, isEmpty);
  });
}

({
  ProviderContainer container,
  _TestAuthNotifier auth,
  _NotificationsRepository repository,
  _RecordingDeepLinkService deepLinks,
  void Function() dispose,
}) _scope() {
  final repository = _NotificationsRepository();
  final deepLinks = _RecordingDeepLinkService();
  late _TestAuthNotifier auth;
  final container = ProviderContainer(
    overrides: [
      authProvider.overrideWith((ref) {
        auth = _TestAuthNotifier(ref, _accountA);
        return auth;
      }),
      inAppNotificationsRepositoryProvider.overrideWithValue(repository),
      deepLinkServiceProvider.overrideWithValue(deepLinks),
    ],
  );
  container.read(authProvider);

  return (
    container: container,
    auth: auth,
    repository: repository,
    deepLinks: deepLinks,
    dispose: () {
      container.dispose();
      deepLinks.dispose();
    },
  );
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
    setUser(user);
  }

  void setUser(HbUser user) {
    state = AuthState(status: AuthStatus.authenticated, user: user);
  }
}

class _NotificationsRepository implements InAppNotificationsRepository {
  final markReadRequests = <Completer<void>>[];
  final deletedIds = <String>[];

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
    return InAppNotificationsPage(
      notifications: [_notification],
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
    return 1;
  }

  @override
  Future<void> markAsRead(String id) {
    final request = Completer<void>();
    markReadRequests.add(request);
    return request.future;
  }

  @override
  Future<void> deleteNotification(String id) async {
    deletedIds.add(id);
  }

  @override
  Future<int> markAllAsRead({
    required String context,
    String? organizationId,
  }) async {
    return 1;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _RecordingDeepLinkService extends DeepLinkService {
  _RecordingDeepLinkService() : this._(_createRouter());

  _RecordingDeepLinkService._(this._router) : super(router: _router);

  static GoRouter _createRouter() => GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (_, __) => const SizedBox.shrink(),
          ),
        ],
      );

  final GoRouter _router;
  int notificationNavigations = 0;

  @override
  void navigateFromNotification({
    String? actionUrl,
    required String type,
    required Map<String, dynamic> data,
  }) {
    notificationNavigations++;
  }

  void dispose() {
    _router.dispose();
  }
}

const _accountA = HbUser(
  id: 'account-a',
  email: 'a@example.test',
  displayName: 'Account A',
);

const _accountB = HbUser(
  id: 'account-b',
  email: 'b@example.test',
  displayName: 'Account B',
);

final _notification = InAppNotification(
  id: 'notification-a',
  type: 'event_reminder',
  title: 'Account A private notification',
  message: 'Private account A payload',
  actionUrl: '/event/account-a-secret',
  data: const {'event_slug': 'account-a-secret'},
  isRead: false,
  createdAt: DateTime(2026),
);
