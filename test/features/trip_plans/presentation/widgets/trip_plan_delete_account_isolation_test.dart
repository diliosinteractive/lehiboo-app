import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_session_key_provider.dart';
import 'package:lehiboo/features/auth/presentation/widgets/account_bound_route_guard.dart';
import 'package:lehiboo/features/trip_plans/domain/entities/trip_plan.dart';
import 'package:lehiboo/features/trip_plans/presentation/widgets/trip_plan_list_card.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

void main() {
  testWidgets('account switch closes delete confirmation without deleting',
      (tester) async {
    var deletes = 0;
    late _TestAuthNotifier auth;
    final container = ProviderContainer(
      overrides: [
        authProvider.overrideWith((ref) {
          auth = _TestAuthNotifier(ref, _accountA);
          return auth;
        }),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(
              child: Consumer(
                builder: (context, ref, _) => TripPlanListCard(
                  plan: _plan,
                  ownerAccountId: 'account-a',
                  ownerSession: ref.watch(authSessionKeyProvider),
                  onDelete: () => deletes++,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(InkWell).first);
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();
    expect(find.byType(AccountBoundRouteGuard<bool>), findsOneWidget);
    expect(find.text('Account A private plan'), findsWidgets);

    auth.setUser(_accountB);
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(deletes, 0);
  });

  testWidgets('A to B to A still invalidates the original delete confirmation',
      (tester) async {
    var deletes = 0;
    late _TestAuthNotifier auth;
    final container = ProviderContainer(
      overrides: [
        authProvider.overrideWith((ref) {
          auth = _TestAuthNotifier(ref, _accountA);
          return auth;
        }),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(
              child: Consumer(
                builder: (context, ref, _) => TripPlanListCard(
                  plan: _plan,
                  ownerAccountId: 'account-a',
                  ownerSession: ref.watch(authSessionKeyProvider),
                  onDelete: () => deletes++,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(InkWell).first);
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();
    expect(find.byType(AccountBoundRouteGuard<bool>), findsOneWidget);

    auth.setUser(_accountB);
    auth.setUser(_accountA);
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(deletes, 0);
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
}

final _plan = TripPlan(
  uuid: 'plan-a',
  title: 'Account A private plan',
  plannedDate: null,
  stopsCount: 1,
  stops: const [
    TripStop(
      order: 1,
      eventUuid: 'event-a',
      eventTitle: 'Account A private stop',
      venueName: 'Account A private venue',
    ),
  ],
  createdAt: DateTime(2026),
);

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
