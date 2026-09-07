import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/l10n/app_locale.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/events/data/models/event_dto.dart';
import 'package:lehiboo/features/memberships/data/datasources/memberships_api_datasource.dart';
import 'package:lehiboo/features/memberships/data/models/membership_dto.dart';
import 'package:lehiboo/features/memberships/domain/repositories/memberships_repository.dart';
import 'package:lehiboo/features/memberships/presentation/providers/private_events_provider.dart';
import 'package:lehiboo/features/memberships/presentation/screens/private_events_screen.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

void main() {
  setUp(() {
    AppLocaleCache.setLanguageCode('fr');
  });

  test(
    'private events clear at an account switch and ignore the stale response',
    () async {
      final repository = _ControlledMembershipsRepository();
      late _TestAuthNotifier auth;
      final container = ProviderContainer(
        overrides: [
          authProvider.overrideWith((ref) {
            auth = _TestAuthNotifier(ref, _accountA);
            return auth;
          }),
          membershipsRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);
      container.read(authProvider);

      final subscription = container.listen(
        privateEventsControllerProvider,
        (_, __) {},
        fireImmediately: true,
      );
      addTearDown(subscription.close);

      expect(repository.privateEventRequests, hasLength(1));
      repository.privateEventRequests[0].complete(
        _page('Événement privé du compte A'),
      );
      await _flush();
      expect(
        container
            .read(privateEventsControllerProvider)
            .requireValue
            .events
            .single
            .title,
        'Événement privé du compte A',
      );

      final accountAController = container.read(
        privateEventsControllerProvider.notifier,
      );
      final staleRefresh = accountAController.refresh();
      expect(repository.privateEventRequests, hasLength(2));

      auth.setUser(_accountB);
      await _flush();

      expect(container.read(privateEventsControllerProvider).isLoading, isTrue);
      expect(
        container.read(privateEventsControllerProvider).valueOrNull,
        isNull,
      );
      expect(repository.privateEventRequests, hasLength(3));

      repository.privateEventRequests[2].complete(
        _page('Événement privé du compte B'),
      );
      await _flush();
      expect(
        container
            .read(privateEventsControllerProvider)
            .requireValue
            .events
            .single
            .title,
        'Événement privé du compte B',
      );

      repository.privateEventRequests[1].complete(
        _page('Réponse tardive du compte A'),
      );
      await staleRefresh;
      await _flush();

      expect(
        container
            .read(privateEventsControllerProvider)
            .requireValue
            .events
            .single
            .title,
        'Événement privé du compte B',
      );

      auth.signOut();
      await _flush();

      expect(
        container.read(privateEventsControllerProvider).requireValue.events,
        isEmpty,
      );
      expect(repository.privateEventRequests, hasLength(3));
    },
  );

  testWidgets('a 429 keeps the screen recoverable and retry loads events', (
    tester,
  ) async {
    final repository = _OutcomeMembershipsRepository([
      _tooManyAttempts(),
      _page('Événement chargé après réessai'),
    ]);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith((ref) => _TestAuthNotifier(ref, _accountA)),
          membershipsRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MaterialApp(
          locale: Locale('fr'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: PrivateEventsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Trop de tentatives. Patientez un instant puis réessayez.'),
      findsOneWidget,
    );
    expect(find.text('Réessayer'), findsOneWidget);

    await tester.tap(find.text('Réessayer'));
    await tester.pumpAndSettle();

    expect(find.text('Événement chargé après réessai'), findsOneWidget);
    expect(repository.privateEventCalls, 2);
  });
}

class _NeverCompletingAuthRepository implements AuthRepository {
  final Completer<bool> _result = Completer<bool>();

  @override
  Future<bool> isAuthenticated() => _result.future;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _TestAuthNotifier extends AuthNotifier {
  _TestAuthNotifier(Ref ref, HbUser user)
      : super(_NeverCompletingAuthRepository(), ref) {
    setUser(user);
  }

  void setUser(HbUser user) {
    state = AuthState(status: AuthStatus.authenticated, user: user);
  }

  void signOut() {
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

class _ControlledMembershipsRepository implements MembershipsRepository {
  final privateEventRequests = <Completer<PrivateEventsPage>>[];

  @override
  Future<MembershipsPage> getMyMemberships({
    MembershipStatus? status,
    String? search,
    int page = 1,
    int perPage = 20,
  }) async {
    return const MembershipsPage();
  }

  @override
  Future<PrivateEventsPage> getPrivateEvents({
    String? search,
    String? organizationId,
    int page = 1,
    int perPage = 15,
  }) {
    final request = Completer<PrivateEventsPage>();
    privateEventRequests.add(request);
    return request.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _OutcomeMembershipsRepository implements MembershipsRepository {
  _OutcomeMembershipsRepository(this._outcomes);

  final List<Object> _outcomes;
  int privateEventCalls = 0;

  @override
  Future<MembershipsPage> getMyMemberships({
    MembershipStatus? status,
    String? search,
    int page = 1,
    int perPage = 20,
  }) async {
    return const MembershipsPage();
  }

  @override
  Future<PrivateEventsPage> getPrivateEvents({
    String? search,
    String? organizationId,
    int page = 1,
    int perPage = 15,
  }) async {
    privateEventCalls++;
    final outcome = _outcomes.removeAt(0);
    if (outcome is PrivateEventsPage) return outcome;
    throw outcome;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

PrivateEventsPage _page(String title) {
  return PrivateEventsPage(
    events: [EventDto(id: 1, title: title, slug: 'private-event')],
    page: 1,
    perPage: 15,
    total: 1,
    lastPage: 1,
  );
}

DioException _tooManyAttempts() {
  final request = RequestOptions(path: '/me/private-events');
  return DioException(
    requestOptions: request,
    response: Response<Map<String, dynamic>>(
      requestOptions: request,
      statusCode: 429,
      data: const {},
    ),
    type: DioExceptionType.badResponse,
  );
}

Future<void> _flush() => Future<void>.delayed(Duration.zero);

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
