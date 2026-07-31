import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lehiboo/core/analytics/noop_analytics_service.dart';
import 'package:lehiboo/core/services/deep_link_service.dart';
import 'package:lehiboo/core/services/push_notification_service.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/notifications/presentation/providers/push_notification_provider.dart';

import '../../../../helpers/fake_auth_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('requestPermission converts SDK exceptions into a stable failure state',
      () async {
    markOneSignalConfigured();
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );
    addTearDown(router.dispose);

    final service = _ThrowingPushNotificationService(router);
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
        pushNotificationServiceProvider.overrideWithValue(service),
      ],
    );
    addTearDown(container.dispose);

    final result = await container
        .read(pushNotificationProvider.notifier)
        .requestPermission();
    final state = container.read(pushNotificationProvider);

    expect(result, isFalse);
    expect(state.status, PushNotificationStatus.error);
    expect(state.failureReason, PushNotificationFailureReason.unexpected);
  });
}

class _ThrowingPushNotificationService extends PushNotificationService {
  _ThrowingPushNotificationService(GoRouter router)
      : super(
          deepLinkService: DeepLinkService(router: router),
          analytics: const NoopAnalyticsService(),
        );

  @override
  bool get isInitialized => false;

  @override
  Future<void> initialize() =>
      Future<void>.error(StateError('technical SDK failure'));
}
