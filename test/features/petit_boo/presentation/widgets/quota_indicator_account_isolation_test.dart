import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/auth/presentation/widgets/account_bound_route_guard.dart';
import 'package:lehiboo/features/petit_boo/data/models/quota_dto.dart';
import 'package:lehiboo/features/petit_boo/presentation/widgets/quota_indicator.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

void main() {
  testWidgets('account switch closes the previous account quota sheet',
      (tester) async {
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
        child: const MaterialApp(
          locale: Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: CircularQuotaIndicator(
              quota: QuotaDto(used: 1, limit: 3, remaining: 2),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(CircularQuotaIndicator));
    await tester.pumpAndSettle();
    expect(find.byType(AccountBoundRouteGuard<void>), findsOneWidget);
    expect(find.byType(QuotaExplanationSheet), findsOneWidget);

    auth.setUser(_accountB);
    await tester.pumpAndSettle();

    expect(find.byType(QuotaExplanationSheet), findsNothing);
  });

  testWidgets('A to B to A cannot revive the original quota sheet',
      (tester) async {
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
        child: const MaterialApp(
          locale: Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: CircularQuotaIndicator(
              quota: QuotaDto(used: 1, limit: 3, remaining: 2),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(CircularQuotaIndicator));
    await tester.pumpAndSettle();
    expect(find.byType(QuotaExplanationSheet), findsOneWidget);

    auth.setUser(_accountB);
    auth.setUser(_accountA);
    await tester.pumpAndSettle();

    expect(find.byType(QuotaExplanationSheet), findsNothing);
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
