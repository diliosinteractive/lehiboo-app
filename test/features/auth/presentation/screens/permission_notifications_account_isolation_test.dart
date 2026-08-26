import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lehiboo/core/analytics/noop_analytics_service.dart';
import 'package:lehiboo/core/services/deep_link_service.dart';
import 'package:lehiboo/core/services/push_notification_service.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/auth/data/models/auth_response_dto.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/auth/presentation/screens/permission_notifications_screen.dart';
import 'package:lehiboo/features/notifications/presentation/providers/push_notification_provider.dart';
import 'package:lehiboo/features/profile/data/datasources/profile_api_datasource.dart';
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

  void setUser(HbUser user) {
    state = AuthState(status: AuthStatus.authenticated, user: user);
  }
}

class _ControlledProfileApi extends ProfileApiDataSource {
  _ControlledProfileApi() : super(Dio());

  final updateResponse = Completer<UserDto>();
  CancelToken? cancelToken;
  bool? submittedPushPreference;
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
    submittedPushPreference = pushNotificationsEnabled;
    this.cancelToken = cancelToken;
    return updateResponse.future;
  }
}

class _ReadyPushNotificationService extends PushNotificationService {
  _ReadyPushNotificationService(GoRouter router)
      : super(
          deepLinkService: DeepLinkService(router: router),
          analytics: const NoopAnalyticsService(),
        );

  @override
  String? get subscriptionId => null;

  @override
  bool get isInitialized => true;

  @override
  Future<void> initialize() async {}

  @override
  Future<void> bindUser(String externalId) async {}

  @override
  Future<void> unbindUser() async {}

  @override
  Future<String?> ensureSubscriptionId() async => subscriptionId;

  @override
  Future<String> getDeviceId() async => 'device-1';

  @override
  Future<String> getDeviceName() async => 'Test device';

  @override
  String getPlatform() => 'android';
}

class _ReadyPushNotificationNotifier extends PushNotificationNotifier {
  _ReadyPushNotificationNotifier(super.ref) {
    state = const PushNotificationState(
      status: PushNotificationStatus.initialized,
      subscriptionId: 'subscription-1',
    );
  }

  @override
  Future<bool> requestPermission() async => true;
}

const _accountA = HbUser(
  id: '1',
  email: 'alice.private@example.test',
  displayName: 'Alice Private',
  onesignalId: 'external-a',
);

const _accountB = HbUser(
  id: '2',
  email: 'bob@example.test',
  displayName: 'Bob Account',
  onesignalId: 'external-b',
);

const _accountAResponse = UserDto(
  id: 1,
  email: 'alice.private@example.test',
  displayName: 'Alice Private',
  role: 'subscriber',
  pushNotificationsEnabled: true,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  markOneSignalConfigured();

  testWidgets(
    'an account switch cancels notification opt-in and ignores its response',
    (tester) async {
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (_, __) => const SizedBox.shrink(),
          ),
        ],
      );
      addTearDown(router.dispose);
      final api = _ControlledProfileApi();
      final service = _ReadyPushNotificationService(router);
      late _MutableAuthNotifier auth;
      final container = ProviderContainer(
        overrides: [
          authProvider.overrideWith((ref) {
            auth = _MutableAuthNotifier(ref, _accountA);
            return auth;
          }),
          profileApiDataSourceProvider.overrideWithValue(api),
          pushNotificationServiceProvider.overrideWithValue(service),
          pushNotificationProvider.overrideWith(
            _ReadyPushNotificationNotifier.new,
          ),
        ],
      );
      addTearDown(container.dispose);
      container.read(authProvider);
      expect(
        container.read(pushNotificationProvider).status,
        PushNotificationStatus.initialized,
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            locale: Locale('en'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: PermissionNotificationsScreen(),
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      expect(api.updateCalls, 1);
      expect(api.submittedPushPreference, isTrue);
      expect(api.cancelToken?.isCancelled, isFalse);

      auth.setUser(_accountB);
      await tester.pump();
      await tester.pump();
      expect(api.cancelToken?.isCancelled, isTrue);
      expect(find.byType(ElevatedButton), findsNothing);

      api.updateResponse.complete(_accountAResponse);
      await tester.pump();

      expect(auth.state.user, _accountB);
      expect(tester.takeException(), isNull);
    },
  );
}
