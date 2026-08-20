import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/auth/data/models/auth_response_dto.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/auth/presentation/widgets/account_bound_route_guard.dart';
import 'package:lehiboo/features/gamification/data/models/hibons_balance.dart';
import 'package:lehiboo/features/gamification/data/models/hibons_wallet.dart';
import 'package:lehiboo/features/gamification/presentation/providers/gamification_provider.dart';
import 'package:lehiboo/features/messages/presentation/providers/unread_count_provider.dart';
import 'package:lehiboo/features/profile/data/datasources/profile_api_datasource.dart';
import 'package:lehiboo/features/profile/presentation/screens/profile_screen.dart';
import 'package:lehiboo/features/reviews/presentation/providers/pending_count_provider.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

class _NeverCompletingAuthRepository implements AuthRepository {
  final _result = Completer<bool>();

  @override
  Future<bool> isAuthenticated() => _result.future;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MutableAuthNotifier extends AuthNotifier {
  _MutableAuthNotifier(Ref ref, HbUser user)
      : super(_NeverCompletingAuthRepository(), ref) {
    setUser(user);
  }

  int logoutCalls = 0;

  void setUser(HbUser user) {
    state = AuthState(status: AuthStatus.authenticated, user: user);
  }

  @override
  Future<void> logout() async {
    logoutCalls++;
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

class _ControlledProfileApi extends ProfileApiDataSource {
  _ControlledProfileApi() : super(Dio());

  final avatarResponse = Completer<UserDto>();
  CancelToken? avatarCancelToken;
  int avatarCalls = 0;

  @override
  Future<UserStatsDto> getStats() async => UserStatsDto(
        bookingsCount: 0,
        favoritesCount: 0,
        reviewsCount: 0,
        upcomingEventsCount: 0,
      );

  @override
  Future<UserDto> uploadAvatar(
    File imageFile, {
    CancelToken? cancelToken,
  }) {
    avatarCalls++;
    avatarCancelToken = cancelToken;
    return avatarResponse.future;
  }
}

class _ZeroUnreadCountNotifier extends UnreadCountNotifier {
  @override
  int build() => 0;
}

class _EmptyGamificationNotifier extends GamificationNotifier {
  @override
  Future<HibonsWallet> build(GamificationSessionKey? ownerSession) async =>
      const HibonsWallet();
}

class _LogoutRouterHarness extends ConsumerStatefulWidget {
  const _LogoutRouterHarness();

  @override
  ConsumerState<_LogoutRouterHarness> createState() =>
      _LogoutRouterHarnessState();
}

class _LogoutRouterHarnessState extends ConsumerState<_LogoutRouterHarness> {
  final _authRefresh = ChangeNotifier();
  late final ProviderSubscription<AuthState> _authSubscription;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authSubscription = ref.listenManual<AuthState>(
      authProvider,
      (_, __) => _authRefresh.notifyListeners(),
    );
    _router = GoRouter(
      initialLocation: '/profile',
      refreshListenable: _authRefresh,
      redirect: (_, state) {
        if (!ref.read(authProvider).isAuthenticated &&
            state.matchedLocation != '/') {
          return '/';
        }
        return null;
      },
      routes: [
        ShellRoute(
          builder: (_, __, child) => child,
          routes: [
            GoRoute(
              path: '/',
              builder: (_, __) => const Scaffold(
                body: Text('Logged-out home'),
              ),
            ),
            GoRoute(
              path: '/profile',
              builder: (_, __) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _router.dispose();
    _authSubscription.close();
    _authRefresh.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: _router,
    );
  }
}

const _emptyBalance = HibonsBalance(
  balance: 0,
  lifetimeEarned: 0,
  rank: 'curieux',
  rankLabel: '',
  rankIcon: '',
);

const _accountA = HbUser(
  id: '1',
  email: 'alice.private@example.test',
  displayName: 'Alice Private',
);

const _accountB = HbUser(
  id: '2',
  email: 'bob@example.test',
  displayName: 'Bob Account',
);

const _accountAResponse = UserDto(
  id: 1,
  email: 'alice.private@example.test',
  displayName: 'Alice Private',
  avatarUrl: 'https://example.test/alice-new.jpg',
  role: 'subscriber',
);

Widget _testApp({
  required _ControlledProfileApi api,
  required ProfileAvatarImagePicker picker,
  required void Function(_MutableAuthNotifier notifier) captureAuth,
}) {
  return ProviderScope(
    overrides: [
      authProvider.overrideWith((ref) {
        final notifier = _MutableAuthNotifier(ref, _accountA);
        captureAuth(notifier);
        return notifier;
      }),
      profileApiDataSourceProvider.overrideWithValue(api),
      profileAvatarImagePickerProvider.overrideWithValue(picker),
      unreadCountProvider.overrideWith(_ZeroUnreadCountNotifier.new),
      gamificationNotifierProvider.overrideWith(
        _EmptyGamificationNotifier.new,
      ),
      hibonsBalanceProvider.overrideWith(
        (ref, ownerSession) async => _emptyBalance,
      ),
      pendingReviewCountProvider.overrideWith((ref, owner) async => 0),
    ],
    child: const MaterialApp(
      locale: Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: ProfileScreen(),
    ),
  );
}

Widget _routerTestApp({
  required _ControlledProfileApi api,
  required void Function(_MutableAuthNotifier notifier) captureAuth,
}) {
  return ProviderScope(
    overrides: [
      authProvider.overrideWith((ref) {
        final notifier = _MutableAuthNotifier(ref, _accountA);
        captureAuth(notifier);
        return notifier;
      }),
      profileApiDataSourceProvider.overrideWithValue(api),
      profileAvatarImagePickerProvider.overrideWithValue(() async => null),
      unreadCountProvider.overrideWith(_ZeroUnreadCountNotifier.new),
      gamificationNotifierProvider.overrideWith(
        _EmptyGamificationNotifier.new,
      ),
      hibonsBalanceProvider.overrideWith(
        (ref, ownerSession) async => _emptyBalance,
      ),
      pendingReviewCountProvider.overrideWith((ref, owner) async => 0),
    ],
    child: const _LogoutRouterHarness(),
  );
}

void main() {
  testWidgets('a gallery result is ignored after switching accounts',
      (tester) async {
    final api = _ControlledProfileApi();
    final pickerResult = Completer<XFile?>();
    late _MutableAuthNotifier auth;
    await tester.pumpWidget(
      _testApp(
        api: api,
        picker: () => pickerResult.future,
        captureAuth: (notifier) => auth = notifier,
      ),
    );
    await tester.pump();

    await tester.tap(find.byKey(const ValueKey('profile-avatar-edit')));
    await tester.pump();
    auth.setUser(_accountB);
    await tester.pump();

    pickerResult.complete(XFile('/tmp/account-a-private-avatar.jpg'));
    await tester.pump();

    expect(api.avatarCalls, 0);
    expect(auth.state.user, _accountB);
    expect(find.text('Alice Private'), findsNothing);
  });

  testWidgets('an account switch cancels and ignores an avatar upload',
      (tester) async {
    final api = _ControlledProfileApi();
    late _MutableAuthNotifier auth;
    await tester.pumpWidget(
      _testApp(
        api: api,
        picker: () async => XFile('/tmp/account-a-private-avatar.jpg'),
        captureAuth: (notifier) => auth = notifier,
      ),
    );
    await tester.pump();

    await tester.tap(find.byKey(const ValueKey('profile-avatar-edit')));
    await tester.pump();
    expect(api.avatarCalls, 1);
    expect(api.avatarCancelToken?.isCancelled, isFalse);

    auth.setUser(_accountB);
    await tester.pump();
    expect(api.avatarCancelToken?.isCancelled, isTrue);

    api.avatarResponse.complete(_accountAResponse);
    await tester.pump();

    expect(auth.state.user, _accountB);
    expect(find.text('Alice Private'), findsNothing);
    expect(find.text('Profile photo updated.'), findsNothing);
  });

  testWidgets('an account switch closes the logout confirmation',
      (tester) async {
    final api = _ControlledProfileApi();
    late _MutableAuthNotifier auth;
    await tester.pumpWidget(
      _testApp(
        api: api,
        picker: () async => null,
        captureAuth: (notifier) => auth = notifier,
      ),
    );
    await tester.pump();

    final logout = find.byKey(const ValueKey('profile-logout'));
    await tester.scrollUntilVisible(
      logout,
      500,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(logout);
    await tester.pumpAndSettle();
    expect(find.byType(AccountBoundRouteGuard<bool>), findsOneWidget);

    auth.setUser(_accountB);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(AlertDialog), findsNothing);
    expect(auth.logoutCalls, 0);
    expect(auth.state.user, _accountB);
  });

  testWidgets('logout does not pop an already closing dialog route',
      (tester) async {
    final api = _ControlledProfileApi();
    late _MutableAuthNotifier auth;
    await tester.pumpWidget(
      _routerTestApp(
        api: api,
        captureAuth: (notifier) => auth = notifier,
      ),
    );
    await tester.pumpAndSettle();

    final logout = find.byKey(const ValueKey('profile-logout'));
    await tester.scrollUntilVisible(
      logout,
      500,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(logout);
    await tester.pumpAndSettle();

    final confirmation = find.descendant(
      of: find.byType(AlertDialog),
      matching: find.byType(ElevatedButton),
    );
    await tester.tap(confirmation);
    await tester.pump();
    await tester.pumpAndSettle();

    expect(auth.logoutCalls, 1);
    expect(find.text('Logged-out home'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
