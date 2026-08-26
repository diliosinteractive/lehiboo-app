import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/analytics/analytics_provider.dart';
import 'package:lehiboo/core/analytics/noop_analytics_service.dart';
import 'package:lehiboo/core/providers/shared_preferences_provider.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/auth/data/models/auth_response_dto.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/auth/presentation/widgets/account_bound_route_guard.dart';
import 'package:lehiboo/features/petit_boo/presentation/widgets/animated_toast.dart';
import 'package:lehiboo/features/profile/data/datasources/profile_api_datasource.dart';
import 'package:lehiboo/features/profile/presentation/screens/settings_screen.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  void setUser(HbUser user) {
    state = AuthState(status: AuthStatus.authenticated, user: user);
  }
}

class _ControlledProfileApi extends ProfileApiDataSource {
  _ControlledProfileApi() : super(Dio());

  final updateResponse = Completer<UserDto>();
  CancelToken? cancelToken;
  bool? submittedNewsletter;
  int updateCalls = 0;

  @override
  Future<UserDto> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    String? jobTitle,
    String? membershipCity,
    bool? newsletter,
    bool? pushNotificationsEnabled,
    bool clearMembershipCity = false,
    CancelToken? cancelToken,
  }) {
    updateCalls++;
    submittedNewsletter = newsletter;
    this.cancelToken = cancelToken;
    return updateResponse.future;
  }
}

const _accountA = HbUser(
  id: '1',
  email: 'alice.private@example.test',
  displayName: 'Alice Private',
  newsletter: false,
);

const _accountB = HbUser(
  id: '2',
  email: 'bob@example.test',
  displayName: 'Bob Account',
  newsletter: false,
);

const _accountAResponse = UserDto(
  id: 1,
  email: 'alice.private@example.test',
  displayName: 'Alice Private',
  role: 'subscriber',
  newsletter: true,
);

Widget _testApp({
  required SharedPreferences preferences,
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
      sharedPreferencesProvider.overrideWithValue(preferences),
      analyticsServiceProvider.overrideWithValue(
        const NoopAnalyticsService(),
      ),
    ],
    child: const MaterialApp(
      locale: Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: SettingsScreen(),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('an account switch cancels and ignores a preference update',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final api = _ControlledProfileApi();
    late _MutableAuthNotifier auth;
    await tester.pumpWidget(
      _testApp(
        preferences: preferences,
        api: api,
        captureAuth: (notifier) => auth = notifier,
      ),
    );
    await tester.pump();

    await tester.tap(
      find.byKey(const ValueKey('settings-newsletter-switch')),
    );
    await tester.pump();
    expect(api.updateCalls, 1);
    expect(api.submittedNewsletter, isTrue);
    expect(api.cancelToken?.isCancelled, isFalse);

    auth.setUser(_accountB);
    await tester.pump();
    await tester.pump();
    expect(api.cancelToken?.isCancelled, isTrue);
    expect(
      find.byKey(const ValueKey('settings-newsletter-switch')),
      findsNothing,
    );

    api.updateResponse.complete(_accountAResponse);
    await tester.pump();

    expect(auth.state.user, _accountB);
    expect(find.byType(PetitBooToast), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('an account switch closes the account-deletion confirmation',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final api = _ControlledProfileApi();
    late _MutableAuthNotifier auth;
    await tester.pumpWidget(
      _testApp(
        preferences: preferences,
        api: api,
        captureAuth: (notifier) => auth = notifier,
      ),
    );
    await tester.pump();

    final deletion = find.byKey(
      const ValueKey('settings-account-deletion'),
    );
    await tester.scrollUntilVisible(
      deletion,
      400,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(deletion);
    await tester.pumpAndSettle();
    expect(find.byType(AccountBoundRouteGuard<void>), findsOneWidget);

    auth.setUser(_accountB);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(AlertDialog), findsNothing);
    expect(api.updateCalls, 0);
    expect(auth.state.user, _accountB);
  });
}
