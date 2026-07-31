import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/analytics/analytics_provider.dart';
import 'package:lehiboo/core/analytics/noop_analytics_service.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/gamification/data/models/hibons_wallet.dart';
import 'package:lehiboo/features/gamification/data/models/wheel_models.dart';
import 'package:lehiboo/features/gamification/domain/repositories/gamification_repository.dart';
import 'package:lehiboo/features/gamification/presentation/providers/gamification_provider.dart';
import 'package:lehiboo/features/gamification/presentation/screens/lucky_wheel_screen.dart';
import 'package:lehiboo/features/petit_boo/presentation/widgets/limit_reached_dialog.dart';
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

class _UiGamificationRepository implements GamificationRepository {
  final spinResult = Completer<WheelSpinResult>();

  @override
  Future<HibonsWallet> getWallet() async => const HibonsWallet(balance: 777);

  @override
  Future<WheelConfig> getWheelConfig() async => const WheelConfig(
        prizes: [
          WheelPrize(index: 0, amount: 0, label: 'Empty'),
          WheelPrize(index: 1, amount: 50, label: '50'),
        ],
      );

  @override
  Future<WheelSpinResult> spinWheel() => spinResult.future;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
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
  testWidgets('Hibons balance modal closes when its owner account changes',
      (tester) async {
    late _MutableAuthNotifier auth;
    final repository = _UiGamificationRepository();

    await tester.pumpWidget(_app(
      repository: repository,
      authBuilder: (ref) => auth = _MutableAuthNotifier(ref, _accountA),
      home: Builder(
        builder: (context) => Scaffold(
          body: ElevatedButton(
            onPressed: () => LimitReachedDialog.show(context),
            child: const Text('Open limit'),
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Open limit'));
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsOneWidget);
    expect(find.textContaining('777'), findsOneWidget);

    auth.setUser(_accountB);
    await tester.pumpAndSettle();

    expect(find.byType(Dialog), findsNothing);
    expect(find.textContaining('777'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('late wheel result cannot show for a replacement account',
      (tester) async {
    late _MutableAuthNotifier auth;
    final repository = _UiGamificationRepository();

    await tester.pumpWidget(_app(
      repository: repository,
      authBuilder: (ref) => auth = _MutableAuthNotifier(ref, _accountA),
      home: const LuckyWheelScreen(),
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Spin'));
    await tester.pump();

    auth.setUser(_accountB);
    await tester.pump();
    auth.setUser(_accountA);
    await tester.pumpAndSettle();

    repository.spinResult.complete(const WheelSpinResult(
      prize: 50,
      prizeIndex: 1,
      message: 'Private A spin result',
      newBalance: 999,
    ));
    await tester.pumpAndSettle();

    expect(find.text('Private A spin result'), findsNothing);
    expect(find.byType(Dialog), findsNothing);
    expect(tester.takeException(), isNull);
  });
}

Widget _app({
  required GamificationRepository repository,
  required AuthNotifier Function(Ref ref) authBuilder,
  required Widget home,
}) {
  return ProviderScope(
    overrides: [
      analyticsServiceProvider.overrideWithValue(const NoopAnalyticsService()),
      authProvider.overrideWith(authBuilder),
      gamificationRepositoryProvider.overrideWithValue(repository),
    ],
    child: MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: home,
    ),
  );
}
