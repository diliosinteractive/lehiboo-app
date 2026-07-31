import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/analytics/analytics_provider.dart';
import 'package:lehiboo/core/analytics/noop_analytics_service.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/gamification/data/models/wheel_models.dart';
import 'package:lehiboo/features/gamification/domain/repositories/gamification_repository.dart';
import 'package:lehiboo/features/gamification/presentation/providers/gamification_provider.dart';

class _AuthenticatedAuthRepository implements AuthRepository {
  @override
  Future<bool> isAuthenticated() async => true;

  @override
  Future<HbUser?> getCurrentUser() async => _user;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FailingGamificationRepository implements GamificationRepository {
  _FailingGamificationRepository(this.failure);

  final Object failure;

  @override
  Future<WheelSpinResult> spinWheel() => Future.error(failure);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

const _user = HbUser(
  id: 'user-1',
  email: 'person@example.test',
  displayName: 'Person',
);

void main() {
  test('wheel spin keeps error state and surfaces the failure to its caller',
      () async {
    final failure = StateError('spin rejected');
    final repository = _FailingGamificationRepository(failure);
    final container = ProviderContainer(
      overrides: [
        analyticsServiceProvider.overrideWithValue(
          const NoopAnalyticsService(),
        ),
        authRepositoryProvider.overrideWithValue(
          _AuthenticatedAuthRepository(),
        ),
        gamificationRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
    container.read(authProvider);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
    expect(container.read(authProvider).isAuthenticated, isTrue);

    final subscription = container.listen(
      wheelSpinProvider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);

    await expectLater(
      container.read(wheelSpinProvider.notifier).spin(),
      throwsA(same(failure)),
    );

    final state = container.read(wheelSpinProvider);
    expect(state.hasError, isTrue);
    expect(state.asError?.error, same(failure));
  });
}
