import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/events/data/models/event_dto.dart';
import 'package:lehiboo/features/events/data/models/home_feed_response_dto.dart';
import 'package:lehiboo/features/events/domain/repositories/event_repository.dart';
import 'package:lehiboo/features/home/presentation/providers/home_providers.dart';
import 'package:lehiboo/features/home/presentation/providers/user_location_provider.dart';

class _CategoriesRepository implements EventRepository {
  List<EventCategoryDto> categories = const [
    EventCategoryDto(id: 1, name: 'Initial', slug: 'initial'),
  ];
  Object? error;
  int calls = 0;

  @override
  Future<List<EventCategoryDto>> getCategories() async {
    calls++;
    final currentError = error;
    if (currentError != null) throw currentError;
    return categories;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _PendingAuthRepository implements AuthRepository {
  final Completer<bool> _authentication = Completer<bool>();

  @override
  Future<bool> isAuthenticated() => _authentication.future;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _TestAuthNotifier extends AuthNotifier {
  _TestAuthNotifier(Ref ref, HbUser? user)
      : super(_PendingAuthRepository(), ref) {
    setUser(user);
  }

  void setUser(HbUser? user) {
    state = AuthState(
      status:
          user == null ? AuthStatus.unauthenticated : AuthStatus.authenticated,
      user: user,
    );
  }
}

class _StaticUserLocationNotifier extends UserLocationNotifier {
  @override
  Future<void> refresh() => Future.value();
}

class _HomeFeedRepository implements EventRepository {
  final requests = <Completer<HomeFeedDataDto>>[];

  @override
  Future<HomeFeedDataDto> getHomeFeed({
    double? lat,
    double? lng,
    int? radius,
    int? limit,
  }) {
    final request = Completer<HomeFeedDataDto>();
    requests.add(request);
    return request.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('home feed cache and late responses are isolated by account', () async {
    const userA = HbUser(
      id: 'home-user-a',
      email: 'a@example.test',
      displayName: 'A',
    );
    const userB = HbUser(
      id: 'home-user-b',
      email: 'b@example.test',
      displayName: 'B',
    );
    final repository = _HomeFeedRepository();
    late _TestAuthNotifier auth;
    final container = ProviderContainer(
      overrides: [
        authProvider.overrideWith((ref) {
          auth = _TestAuthNotifier(ref, userA);
          return auth;
        }),
        eventRepositoryProvider.overrideWithValue(repository),
        userLocationProvider.overrideWith(
          (ref) => _StaticUserLocationNotifier(),
        ),
      ],
    );
    addTearDown(container.dispose);
    final subscription = container.listen(
      homeFeedProvider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);

    final accountAFuture = container.read(homeFeedProvider.future);
    expect(repository.requests, hasLength(1));

    auth.setUser(userB);
    final accountBFuture = container.read(homeFeedProvider.future);
    expect(repository.requests, hasLength(2));

    repository.requests.last.complete(
      const HomeFeedDataDto(locationProvided: true),
    );
    expect((await accountBFuture).locationProvided, isTrue);

    repository.requests.first.complete(
      const HomeFeedDataDto(locationProvided: false),
    );
    await accountAFuture;
    await pumpEventQueue();

    expect(
        container.read(homeFeedProvider).requireValue.locationProvided, true);
  });

  test(
    'refresh reports failure while retaining the last successful value',
    () async {
      final repository = _CategoriesRepository();
      final container = ProviderContainer(
        overrides: [
          eventRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);
      final subscription = container.listen(
        categoriesProvider,
        (_, __) {},
        fireImmediately: true,
      );
      addTearDown(subscription.close);

      final initial = await container.read(categoriesProvider.future);
      expect(initial.single.name, 'Initial');

      repository.error = StateError('temporary failure');
      await expectLater(
        container.read(categoriesProvider.notifier).refresh(),
        throwsA(isA<StateError>()),
      );

      final failedRefresh = container.read(categoriesProvider);
      expect(failedRefresh.hasError, isTrue);
      expect(failedRefresh.hasValue, isTrue);
      expect(failedRefresh.requireValue.single.name, 'Initial');

      repository
        ..error = null
        ..categories = const [
          EventCategoryDto(id: 2, name: 'Recovered', slug: 'recovered'),
        ];
      await container.read(categoriesProvider.notifier).refresh();

      final recovered = container.read(categoriesProvider);
      expect(recovered.hasError, isFalse);
      expect(recovered.requireValue.single.name, 'Recovered');
      expect(repository.calls, 3);
    },
  );

  testWidgets('manual refresh replaces the active 15-minute timer', (
    tester,
  ) async {
    final repository = _CategoriesRepository();
    late WidgetRef homeRef;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          eventRepositoryProvider.overrideWithValue(repository),
        ],
        child: Consumer(
          builder: (context, ref, _) {
            homeRef = ref;
            final categories = ref.watch(categoriesProvider);
            return MaterialApp(
              home: Text('${categories.valueOrNull?.length ?? 0}'),
            );
          },
        ),
      ),
    );
    await tester.pump();
    expect(repository.calls, 1);

    await tester.pump(const Duration(minutes: 5));
    await homeRef.read(categoriesProvider.notifier).refresh();
    expect(repository.calls, 2);

    // The original timer would expire here if refresh had not cancelled it.
    await tester.pump(const Duration(minutes: 10));
    await tester.pump();
    expect(repository.calls, 2);

    await tester.pump(const Duration(minutes: 5));
    await tester.pump();
    expect(repository.calls, 3);
  });

  testWidgets('an unobserved cached provider expires without polling', (
    tester,
  ) async {
    final repository = _CategoriesRepository();
    final container = ProviderContainer(
      overrides: [
        eventRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);

    Widget scope(Widget child) {
      return UncontrolledProviderScope(
        container: container,
        child: child,
      );
    }

    await tester.pumpWidget(
      scope(
        Consumer(
          builder: (context, ref, _) {
            ref.watch(categoriesProvider);
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    await container.read(categoriesProvider.future);
    expect(repository.calls, 1);

    await tester.pumpWidget(scope(const SizedBox.shrink()));
    await tester.pump(homeDataFreshness);
    await tester.pump();

    expect(repository.calls, 1);
    expect(container.exists(categoriesProvider), isFalse);

    await tester.pump(homeDataFreshness);
    expect(repository.calls, 1);
  });
}
