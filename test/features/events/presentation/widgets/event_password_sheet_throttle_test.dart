import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import 'package:lehiboo/features/events/domain/exceptions/event_password_exceptions.dart';
import 'package:lehiboo/features/events/presentation/widgets/detail/event_password_sheet.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

/// The backend allows 6 password attempts per minute for a requester and an
/// event (`throttle:event-password`), stamps every answer with
/// `X-RateLimit-Remaining`, then replies 429 with `Retry-After`. The sheet must
/// mirror that budget truthfully and lock the button for the whole cooldown.
void main() {
  Future<void> pumpSheet(
    WidgetTester tester, {
    required Future<Event> Function(String password) onSubmit,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: EventPasswordSheet(
              identifier: 'vernissage-galerie-x',
              onSubmit: onSubmit,
            ),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  Future<void> attempt(WidgetTester tester) async {
    await tester.enterText(find.byType(TextField), 'wrong');
    await tester.tap(find.text('Unlock'));
    await tester.pump();
    await tester.pump();
  }

  ElevatedButton unlockButton(WidgetTester tester) {
    return tester.widget<ElevatedButton>(find.byType(ElevatedButton));
  }

  testWidgets('the warning follows the budget the server reports',
      (tester) async {
    // The counter is shared with `GET /events/{slug}?password=`, so the server
    // can report less budget than this sheet has spent itself.
    final remaining = <int>[2, 1];
    var call = 0;
    await pumpSheet(
      tester,
      onSubmit: (_) async => throw InvalidEventPasswordException(
        remainingAttempts: remaining[call++],
        attemptLimit: 6,
      ),
    );

    await attempt(tester);
    expect(find.text('2 attempts left before a 1-minute delay.'),
        findsOneWidget);

    await attempt(tester);
    expect(find.text('1 attempt left before a 1-minute delay.'), findsOneWidget);
  });

  testWidgets('the warning counts down locally when the header is stripped',
      (tester) async {
    await pumpSheet(
      tester,
      onSubmit: (_) async => throw const InvalidEventPasswordException(),
    );

    await attempt(tester);
    await attempt(tester);
    await attempt(tester);
    expect(find.text('3 attempts left before a 1-minute delay.'),
        findsOneWidget);

    await attempt(tester);
    expect(find.text('2 attempts left before a 1-minute delay.'),
        findsOneWidget);

    await attempt(tester);
    expect(find.text('1 attempt left before a 1-minute delay.'), findsOneWidget);
  });

  testWidgets('the lockout message shows while the button is disabled',
      (tester) async {
    var calls = 0;
    await pumpSheet(
      tester,
      onSubmit: (_) async {
        calls++;
        if (calls <= 6) {
          throw InvalidEventPasswordException(
            remainingAttempts: 6 - calls,
            attemptLimit: 6,
          );
        }
        throw const EventPasswordRateLimitedException(
          Duration(seconds: 60),
          attemptLimit: 6,
        );
      },
    );

    for (var i = 0; i < 7; i++) {
      await attempt(tester);
    }

    expect(find.text("You've reached the maximum number of attempts."),
        findsOneWidget);
    expect(find.text('Try again in 60s'), findsOneWidget);
    expect(unlockButton(tester).onPressed, isNull,
        reason: 'the button must be disabled while the cooldown runs');

    await tester.pump(const Duration(seconds: 30));
    expect(unlockButton(tester).onPressed, isNull,
        reason: 'still cooling down at 30s');

    await tester.pump(const Duration(seconds: 31));
    expect(unlockButton(tester).onPressed, isNotNull,
        reason: 'the button comes back once the cooldown ends');
    expect(find.text("You've reached the maximum number of attempts."),
        findsNothing,
        reason: 'the lockout message clears with the limiter window');
    expect(find.textContaining('attempts left'), findsNothing,
        reason: 'the budget starts fresh after the cooldown');
  });

  testWidgets('an exhausted budget is announced before the next attempt',
      (tester) async {
    await pumpSheet(
      tester,
      onSubmit: (_) async => throw const InvalidEventPasswordException(
        remainingAttempts: 0,
        attemptLimit: 6,
      ),
    );

    await attempt(tester);
    expect(find.text("You've reached the maximum number of attempts."),
        findsOneWidget);
  });
}
