import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/analytics/analytics_provider.dart';
import 'package:lehiboo/core/analytics/noop_analytics_service.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/gamification/application/hibons_service.dart';
import 'package:lehiboo/features/gamification/data/interceptors/hibons_update_interceptor.dart';
import 'package:lehiboo/features/gamification/data/models/hibons_wallet.dart';
import 'package:lehiboo/features/gamification/domain/repositories/gamification_repository.dart';
import 'package:lehiboo/features/gamification/presentation/providers/gamification_provider.dart';

class _AnonymousAuthRepository implements AuthRepository {
  @override
  Future<bool> isAuthenticated() async => false;

  @override
  Future<HbUser?> getCurrentUser() async => null;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _WalletRepository implements GamificationRepository {
  int balance = 0;

  @override
  Future<HibonsWallet> getWallet() async => HibonsWallet(
        balance: balance,
        lifetimeEarned: balance,
      );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _PendingRequest {
  final requestSeen = Completer<RequestOptions>();
  final response = Completer<ResponseBody>();
}

class _ControlledAdapter implements HttpClientAdapter {
  _PendingRequest? next;

  _PendingRequest prepare() {
    final request = _PendingRequest();
    next = request;
    return request;
  }

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    final request = next!;
    next = null;
    request.requestSeen.complete(options);
    return request.response.future;
  }

  @override
  void close({bool force = false}) {}
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

void main() {
  test('request envelope is accepted only by its exact initiating session',
      () async {
    final repository = _WalletRepository()..balance = 10;
    final container = ProviderContainer(
      overrides: [
        analyticsServiceProvider.overrideWithValue(
          const NoopAnalyticsService(),
        ),
        authRepositoryProvider.overrideWithValue(_AnonymousAuthRepository()),
        gamificationRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
    HibonsService.instance.attach(container);
    addTearDown(HibonsService.instance.detach);

    await _authenticate(container, _accountA);
    final accountASession = container.read(gamificationSessionProvider)!;
    final walletSubscription = container.listen(
      gamificationNotifierProvider(accountASession),
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(walletSubscription.close);
    await container.read(gamificationNotifierProvider(accountASession).future);

    final emitted = <HibonsDeltaEvent>[];
    final deltaSubscription = HibonsService.instance.deltaStream.listen(
      emitted.add,
    );
    addTearDown(deltaSubscription.cancel);

    final adapter = _ControlledAdapter();
    final dio = Dio()..httpClientAdapter = adapter;
    dio.interceptors.add(HibonsUpdateInterceptor());

    final staleRequest = adapter.prepare();
    final staleResponse = dio.post<dynamic>('/reward');
    final staleOptions = await staleRequest.requestSeen.future;
    expect(
      staleOptions.extra[HibonsUpdateInterceptor.requestOwnerExtraKey],
      isA<HibonsRequestOwner>(),
    );

    repository.balance = 30;
    container.read(authProvider.notifier).setAuthenticatedUser(_accountB);
    container.read(authProvider.notifier).setAuthenticatedUser(_accountA);
    final accountA2Session = container.read(gamificationSessionProvider)!;
    await _settle();
    await container.read(gamificationNotifierProvider(accountA2Session).future);

    staleRequest.response.complete(_responseWithBalance(999));
    await staleResponse;
    await _settle();

    expect(
      container
          .read(gamificationNotifierProvider(accountA2Session))
          .valueOrNull
          ?.balance,
      30,
    );
    expect(emitted, isEmpty);

    final currentRequest = adapter.prepare();
    final currentResponse = dio.post<dynamic>('/reward');
    await currentRequest.requestSeen.future;
    currentRequest.response.complete(_responseWithBalance(55));
    await currentResponse;
    await _settle();

    expect(
      container
          .read(gamificationNotifierProvider(accountA2Session))
          .valueOrNull
          ?.balance,
      55,
    );
    expect(emitted, hasLength(1));
    expect(emitted.single.update.newBalance, 55);
    expect(
      identical(
        emitted.single.ownerSession,
        container.read(gamificationSessionProvider),
      ),
      isTrue,
    );
  });
}

ResponseBody _responseWithBalance(int balance) {
  return ResponseBody.fromString(
    jsonEncode({
      'data': <String, dynamic>{},
      'hibons_update': {
        'delta': 5,
        'new_balance': balance,
        'new_lifetime': balance,
        'lifetime_delta': 5,
        'rank_changed': false,
        'source': 'test',
      },
    }),
    200,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );
}

Future<void> _authenticate(ProviderContainer container, HbUser user) async {
  container.read(authProvider);
  await _settle();
  container.read(authProvider.notifier).setAuthenticatedUser(user);
  await _settle();
}

Future<void> _settle() async {
  await Future<void>.delayed(Duration.zero);
  await Future<void>.delayed(Duration.zero);
}
