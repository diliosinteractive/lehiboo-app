import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/notifications/domain/repositories/in_app_notifications_repository.dart';
import 'package:lehiboo/features/notifications/presentation/providers/in_app_notifications_provider.dart';

import '../../../../helpers/fake_auth_repository.dart';
import '../../../../helpers/fake_in_app_notifications_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('load does not call protected API while unauthenticated', () async {
    final notificationsRepository = FakeInAppNotificationsRepository();
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
        inAppNotificationsRepositoryProvider.overrideWithValue(
          notificationsRepository,
        ),
      ],
    );
    addTearDown(container.dispose);

    await container
        .read(inAppNotificationsProvider.notifier)
        .load(refresh: true);

    final state = container.read(inAppNotificationsProvider);
    expect(state.notifications.valueOrNull, isEmpty);
    expect(state.unreadCount, 0);
    expect(notificationsRepository.loadCount, 0);
    expect(notificationsRepository.unreadCountCalls, 0);
  });
}
