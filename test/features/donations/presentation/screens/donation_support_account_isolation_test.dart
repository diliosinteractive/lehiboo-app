import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/donations/data/repositories/donations_repository_impl.dart';
import 'package:lehiboo/features/donations/domain/entities/donation.dart';
import 'package:lehiboo/features/donations/domain/repositories/donations_repository.dart';
import 'package:lehiboo/features/donations/presentation/screens/donation_support_screen.dart';
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

  void signOutLocally() {
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

class _ControlledDonationsRepository implements DonationsRepository {
  final createResponse = Completer<DonationCheckout>();

  int createCalls = 0;
  int confirmCalls = 0;
  double? submittedAmount;
  String? submittedEmail;
  String? submittedName;

  @override
  Future<DonationCheckout> createDonation({
    required double amount,
    String? email,
    String? name,
    required String locale,
    String sourceScreen = 'settings',
  }) {
    createCalls++;
    submittedAmount = amount;
    submittedEmail = email;
    submittedName = name;
    return createResponse.future;
  }

  @override
  Future<Donation> confirmPayment({
    required String uuid,
    required String paymentIntentId,
  }) async {
    confirmCalls++;
    return const Donation(uuid: 'donation-a', amount: 2);
  }

  @override
  Future<Donation> getDonation(String uuid) async {
    return const Donation(uuid: 'donation-a', amount: 2);
  }
}

const _accountA = HbUser(
  id: 'account-a',
  email: 'alice.private@example.test',
  displayName: 'Alice Private',
);

const _accountB = HbUser(
  id: 'account-b',
  email: 'bob@example.test',
  displayName: 'Bob Account',
);

Widget _testApp({
  required _ControlledDonationsRepository repository,
  required void Function(_MutableAuthNotifier notifier) captureAuth,
}) {
  return ProviderScope(
    overrides: [
      authProvider.overrideWith((ref) {
        final notifier = _MutableAuthNotifier(ref, _accountA);
        captureAuth(notifier);
        return notifier;
      }),
      donationsRepositoryProvider.overrideWithValue(repository),
    ],
    child: const MaterialApp(
      locale: Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: DonationSupportScreen(),
    ),
  );
}

TextEditingController _controller(WidgetTester tester, String key) {
  return tester.widget<TextField>(find.byKey(ValueKey(key))).controller!;
}

void main() {
  testWidgets(
    'account changes clear donation drafts and prefill only the new account',
    (tester) async {
      final repository = _ControlledDonationsRepository();
      late _MutableAuthNotifier auth;
      await tester.pumpWidget(
        _testApp(
          repository: repository,
          captureAuth: (notifier) => auth = notifier,
        ),
      );
      await tester.pumpAndSettle();

      expect(
        _controller(tester, 'donation-email-field').text,
        _accountA.email,
      );
      expect(
        _controller(tester, 'donation-name-field').text,
        _accountA.displayName,
      );

      await tester.enterText(
        find.byKey(const ValueKey('donation-custom-amount-field')),
        '42,50',
      );
      await tester.enterText(
        find.byKey(const ValueKey('donation-name-field')),
        'Alice private donation draft',
      );

      auth.setUser(_accountB);
      await tester.pump();

      expect(
        _controller(tester, 'donation-email-field').text,
        _accountB.email,
      );
      expect(
        _controller(tester, 'donation-name-field').text,
        _accountB.displayName,
      );
      expect(
        _controller(tester, 'donation-custom-amount-field').text,
        isEmpty,
      );
      expect(find.byKey(const ValueKey('donation-error')), findsNothing);
      expect(find.byKey(const ValueKey('donation-success')), findsNothing);

      await tester.enterText(
        find.byKey(const ValueKey('donation-email-field')),
        'bob.private-draft@example.test',
      );
      await tester.enterText(
        find.byKey(const ValueKey('donation-name-field')),
        'Bob private donation draft',
      );
      await tester.enterText(
        find.byKey(const ValueKey('donation-custom-amount-field')),
        '75',
      );

      auth.signOutLocally();
      await tester.pump();

      expect(_controller(tester, 'donation-email-field').text, isEmpty);
      expect(_controller(tester, 'donation-name-field').text, isEmpty);
      expect(
        _controller(tester, 'donation-custom-amount-field').text,
        isEmpty,
      );
      expect(find.textContaining('private donation draft'), findsNothing);
      expect(find.byKey(const ValueKey('donation-error')), findsNothing);
      expect(find.byKey(const ValueKey('donation-success')), findsNothing);
    },
  );

  testWidgets(
    'an account switch invalidates an in-flight donation before Stripe',
    (tester) async {
      final repository = _ControlledDonationsRepository();
      late _MutableAuthNotifier auth;
      await tester.pumpWidget(
        _testApp(
          repository: repository,
          captureAuth: (notifier) => auth = notifier,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('donation-submit')));
      await tester.pump();

      expect(repository.createCalls, 1);
      expect(repository.submittedAmount, 2);
      expect(repository.submittedEmail, _accountA.email);
      expect(repository.submittedName, _accountA.displayName);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      auth.setUser(_accountB);
      await tester.pump();

      expect(
        _controller(tester, 'donation-email-field').text,
        _accountB.email,
      );
      expect(
        _controller(tester, 'donation-name-field').text,
        _accountB.displayName,
      );
      expect(find.byType(CircularProgressIndicator), findsNothing);

      repository.createResponse.complete(
        const DonationCheckout(
          donation: Donation(uuid: 'donation-a', amount: 2),
          paymentSheet: DonationPaymentSheet(
            clientSecret: 'pi_account_a_secret',
            merchantDisplayName: 'LeHiboo',
            paymentIntentId: 'pi_account_a',
          ),
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(repository.confirmCalls, 0);
      expect(find.byKey(const ValueKey('donation-error')), findsNothing);
      expect(find.byKey(const ValueKey('donation-success')), findsNothing);
      expect(
        tester
            .widget<ElevatedButton>(
              find.byKey(const ValueKey('donation-submit')),
            )
            .onPressed,
        isNotNull,
      );
      expect(tester.takeException(), isNull);
    },
  );
}
