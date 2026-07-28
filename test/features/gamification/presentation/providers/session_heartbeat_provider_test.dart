import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/analytics/analytics_provider.dart';
import 'package:lehiboo/core/analytics/noop_analytics_service.dart';
import 'package:lehiboo/core/providers/shared_preferences_provider.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/gamification/data/datasources/gamification_api_datasource.dart';
import 'package:lehiboo/features/gamification/data/models/hibons_api_dto.dart';
import 'package:lehiboo/features/gamification/presentation/providers/session_heartbeat_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<bool> isAuthenticated() async => false;

  @override
  Future<HbUser?> getCurrentUser() async => null;

  @override
  Future<void> logout() async {}

  @override
  Future<void> clearLocalAuthData() async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeGamificationApiDataSource implements GamificationApiDataSource {
  int heartbeatCalls = 0;

  @override
  Future<HibonsRewardResponseDto> sendSessionHeartbeat(
    DateTime sessionStartedAt,
  ) async {
    heartbeatCalls++;
    return const HibonsRewardResponseDto(awarded: true, amount: 10);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

const _userOne = HbUser(
  id: 'heartbeat-user-1',
  email: 'one@example.test',
  displayName: 'One',
);

const _userTwo = HbUser(
  id: 'heartbeat-user-2',
  email: 'two@example.test',
  displayName: 'Two',
);

const _userThree = HbUser(
  id: 'heartbeat-user-3',
  email: 'three@example.test',
  displayName: 'Three',
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'heartbeat timer and daily cache follow the authenticated user',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      final api = _FakeGamificationApiDataSource();
      final container = ProviderContainer(
        overrides: [
          analyticsServiceProvider.overrideWithValue(
            const NoopAnalyticsService(),
          ),
          sharedPreferencesProvider.overrideWithValue(preferences),
          authRepositoryProvider.overrideWithValue(_FakeAuthRepository()),
          gamificationApiDataSourceProvider.overrideWithValue(api),
        ],
      );
      addTearDown(container.dispose);

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: Consumer(
            builder: (context, ref, child) {
              ref.watch(sessionHeartbeatProvider);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      await tester.pump();

      // Guests never schedule a protected heartbeat request.
      await tester.pump(const Duration(minutes: 4));
      expect(api.heartbeatCalls, 0);

      container.read(authProvider.notifier).setAuthenticatedUser(_userOne);
      await tester.pump();
      await tester.pump(const Duration(minutes: 2, seconds: 59));
      expect(api.heartbeatCalls, 0);
      await tester.pump(const Duration(seconds: 1));
      await tester.pump();
      expect(api.heartbeatCalls, 1);
      expect(
        preferences.getString(
          sessionHeartbeatDateKeyForUser(_userOne.id),
        ),
        isNotNull,
      );

      // Switching account in the foreground starts a fresh three-minute
      // session and uses a separate once-per-day key.
      container.read(authProvider.notifier).setAuthenticatedUser(_userTwo);
      await tester.pump();
      await tester.pump(const Duration(minutes: 3));
      await tester.pump();
      expect(api.heartbeatCalls, 2);
      expect(
        preferences.getString(
          sessionHeartbeatDateKeyForUser(_userTwo.id),
        ),
        isNotNull,
      );
      expect(
        sessionHeartbeatDateKeyForUser(_userOne.id),
        isNot(sessionHeartbeatDateKeyForUser(_userTwo.id)),
      );

      // Returning to an unauthenticated state disposes the account notifier
      // and cancels its pending timer, even while the app stays foregrounded.
      container.read(authProvider.notifier).setAuthenticatedUser(_userThree);
      await tester.pump();
      await tester.pump(const Duration(minutes: 2, seconds: 59));
      await container.read(authProvider.notifier).refreshAuthStatus();
      await tester.pump();
      await tester.pump(const Duration(minutes: 5));
      expect(api.heartbeatCalls, 2);
      expect(
        preferences.getString(
          sessionHeartbeatDateKeyForUser(_userThree.id),
        ),
        isNull,
      );

      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
}
