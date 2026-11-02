import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lehiboo/core/analytics/analytics_provider.dart';
import 'package:lehiboo/core/analytics/noop_analytics_service.dart';
import 'package:lehiboo/core/providers/shared_preferences_provider.dart';
import 'package:lehiboo/core/services/push_notification_service.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/auth/data/models/auth_response_dto.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/notifications/presentation/providers/push_notification_provider.dart';
import 'package:lehiboo/features/profile/data/datasources/profile_api_datasource.dart';
import 'package:lehiboo/features/profile/presentation/screens/settings_screen.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../helpers/fake_push_notification_service.dart';

class _NeverCompletingAuthRepository implements AuthRepository {
  final _result = Completer<bool>();

  @override
  Future<bool> isAuthenticated() => _result.future;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FixedAuthNotifier extends AuthNotifier {
  _FixedAuthNotifier(Ref ref, HbUser user)
      : super(_NeverCompletingAuthRepository(), ref) {
    state = AuthState(status: AuthStatus.authenticated, user: user);
  }
}

class _RecordingProfileApi extends ProfileApiDataSource {
  _RecordingProfileApi() : super(Dio());

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
    return Completer<UserDto>().future;
  }
}

/// Real notifier wiring, with the device state driven by the test.
class _StubPushNotifier extends PushNotificationNotifier {
  _StubPushNotifier(super.ref);

  int permissionRequests = 0;

  void emit(PushNotificationState next) => state = next;

  @override
  Future<bool> requestPermission() async {
    permissionRequests++;
    return false;
  }
}

HbUser _user({required bool pushOptIn}) => HbUser(
      id: '1',
      email: 'alice@example.test',
      displayName: 'Alice',
      onesignalId: 'external-a',
      pushNotificationsEnabled: pushOptIn,
    );

const _deviceReady = PushNotificationState(
  status: PushNotificationStatus.initialized,
  subscriptionId: 'subscription-1',
  hasPermission: true,
);

const _deviceBlocked = PushNotificationState(
  status: PushNotificationStatus.disabled,
  failureReason: PushNotificationFailureReason.permissionDenied,
);

final _pushSwitch = find.byKey(const ValueKey('settings-push-switch'));
final _pushHint = find.byKey(const ValueKey('settings-push-hint'));
final _openSystemSettings =
    find.byKey(const ValueKey('settings-push-open-system-settings'));

Future<({_StubPushNotifier push, _RecordingProfileApi api})> _pumpSettings(
  WidgetTester tester, {
  required bool pushOptIn,
  required PushNotificationState device,
}) async {
  SharedPreferences.setMockInitialValues({});
  final preferences = await SharedPreferences.getInstance();
  final router = GoRouter(
    routes: [GoRoute(path: '/', builder: (_, __) => const SizedBox.shrink())],
  );
  addTearDown(router.dispose);
  final api = _RecordingProfileApi();
  late _StubPushNotifier push;

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authProvider.overrideWith(
          (ref) => _FixedAuthNotifier(ref, _user(pushOptIn: pushOptIn)),
        ),
        profileApiDataSourceProvider.overrideWithValue(api),
        sharedPreferencesProvider.overrideWithValue(preferences),
        analyticsServiceProvider.overrideWithValue(
          const NoopAnalyticsService(),
        ),
        pushNotificationServiceProvider.overrideWithValue(
          FakePushNotificationService(router),
        ),
        pushNotificationProvider.overrideWith((ref) {
          push = _StubPushNotifier(ref);
          return push;
        }),
      ],
      child: const MaterialApp(
        locale: Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SettingsScreen(),
      ),
    ),
  );
  // Let the notifier's own identity/initialization work settle first, then
  // impose the device state under test.
  await tester.pump();
  push.emit(device);
  await tester.pump();
  return (push: push, api: api);
}

bool _switchValue(WidgetTester tester) =>
    tester.widget<SwitchListTile>(_pushSwitch).value;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('account and device ready: switch on, regular subtitle',
      (tester) async {
    await _pumpSettings(tester, pushOptIn: true, device: _deviceReady);

    expect(_switchValue(tester), isTrue);
    expect(_pushHint, findsNothing);
    expect(find.text('Receive alerts on your phone'), findsOneWidget);
  });

  testWidgets(
      'account opted out stays off without a hint even if the device is ready',
      (tester) async {
    await _pumpSettings(tester, pushOptIn: false, device: _deviceReady);

    expect(_switchValue(tester), isFalse);
    expect(_pushHint, findsNothing);
  });

  testWidgets(
      'account opted in but the OS blocks pushes: off, with a settings '
      'shortcut', (tester) async {
    await _pumpSettings(tester, pushOptIn: true, device: _deviceBlocked);

    expect(_switchValue(tester), isFalse);
    expect(find.text('Blocked in your phone settings'), findsOneWidget);
    expect(_openSystemSettings, findsOneWidget);
  });

  testWidgets(
      'tapping a blocked switch asks the device and leaves the account alone',
      (tester) async {
    final (:push, :api) = await _pumpSettings(
      tester,
      pushOptIn: true,
      device: _deviceBlocked,
    );

    await tester.tap(_pushSwitch);
    await tester.pump();

    expect(push.permissionRequests, 1);
    expect(api.updateCalls, 0);

    // Flush the error toast's auto-dismiss timer.
    await tester.pump(const Duration(seconds: 4));
  });
}
