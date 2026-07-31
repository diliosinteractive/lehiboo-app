import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/gamification/data/models/hibons_balance.dart';
import 'package:lehiboo/features/gamification/data/models/hibons_wallet.dart';
import 'package:lehiboo/features/gamification/presentation/providers/gamification_provider.dart';
import 'package:lehiboo/features/gamification/presentation/widgets/hibon_counter_widget.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

class _TestGamificationNotifier extends GamificationNotifier {
  _TestGamificationNotifier(this._loadWallet);

  final Future<HibonsWallet> Function() _loadWallet;

  @override
  Future<HibonsWallet> build(GamificationSessionKey? ownerSession) =>
      _loadWallet();

  void failRefreshWhilePreservingValue() {
    final previous = state;
    state = AsyncError<HibonsWallet>(
      StateError('wallet refresh failed'),
      StackTrace.current,
    ).copyWithPrevious(previous);
  }
}

const _fallbackBalance = HibonsBalance(
  balance: 73,
  lifetimeEarned: 100,
  rank: 'curieux',
  rankLabel: 'Curieux',
  rankIcon: '🔍',
);

void main() {
  testWidgets('keeps the previous wallet balance after a refresh error', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          isAuthenticatedProvider.overrideWithValue(true),
          gamificationSessionProvider.overrideWith((ref) => null),
          gamificationNotifierProvider.overrideWith(
            () => _TestGamificationNotifier(
              () async => const HibonsWallet(balance: 42),
            ),
          ),
          hibonsBalanceProvider.overrideWith(
            (ref, ownerSession) async => _fallbackBalance,
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: HibonCounterWidget()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('42'), findsOneWidget);

    final container = ProviderScope.containerOf(
      tester.element(find.byType(HibonCounterWidget)),
    );
    final ownerSession = container.read(gamificationSessionProvider);
    final notifier =
        container.read(gamificationNotifierProvider(ownerSession).notifier)
            as _TestGamificationNotifier;
    notifier.failRefreshWhilePreservingValue();
    await tester.pump();

    expect(find.text('42'), findsOneWidget);
    expect(find.text('---'), findsNothing);
  });

  testWidgets('uses the balance endpoint when the wallet has no value', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          isAuthenticatedProvider.overrideWithValue(true),
          gamificationSessionProvider.overrideWith((ref) => null),
          gamificationNotifierProvider.overrideWith(
            () => _TestGamificationNotifier(
              () async => throw StateError('wallet unavailable'),
            ),
          ),
          hibonsBalanceProvider.overrideWith(
            (ref, ownerSession) async => _fallbackBalance,
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: HibonCounterWidget()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('73'), findsOneWidget);
    expect(find.text('---'), findsNothing);
  });
}
