import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/events/domain/entities/event_question.dart';
import 'package:lehiboo/features/events/domain/repositories/event_questions_repository.dart';
import 'package:lehiboo/features/events/presentation/providers/event_questions_providers.dart';
import 'package:lehiboo/features/events/presentation/screens/event_questions_screen.dart';
import 'package:lehiboo/features/events/presentation/widgets/detail/event_qa_section.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

void main() {
  testWidgets(
    'event detail disables Ask and exposes a retry when my-question fails',
    (tester) async {
      var attempts = 0;
      await tester.pumpWidget(
        _localizedApp(
          overrides: _overrides(() async {
            attempts += 1;
            if (attempts == 1) throw StateError('status unavailable');
            return null;
          }),
          child: const Scaffold(
            body: EventQASection(
              eventSlug: 'event',
              eventTitle: 'Event',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Question status unavailable'), findsOneWidget);
      expect(
        tester.widget<TextButton>(_textButtonWithText('Ask')).onPressed,
        isNull,
      );
      expect(
        tester
            .widget<FilledButton>(_filledButtonWithText('Ask a question'))
            .onPressed,
        isNull,
      );

      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();

      expect(find.text('Question status unavailable'), findsNothing);
      expect(
        tester.widget<TextButton>(_textButtonWithText('Ask')).onPressed,
        isNotNull,
      );
      expect(
        tester
            .widget<FilledButton>(_filledButtonWithText('Ask a question'))
            .onPressed,
        isNotNull,
      );
    },
  );

  testWidgets(
    'full questions screen disables Ask and retries my-question independently',
    (tester) async {
      var attempts = 0;
      await tester.pumpWidget(
        _localizedApp(
          overrides: _overrides(() async {
            attempts += 1;
            if (attempts == 1) throw StateError('status unavailable');
            return null;
          }),
          child: const EventQuestionsScreen(
            eventSlug: 'event',
            eventTitle: 'Event',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Question status unavailable'), findsOneWidget);
      expect(
        tester
            .widget<FloatingActionButton>(find.byType(FloatingActionButton))
            .onPressed,
        isNull,
      );
      expect(
        tester
            .widget<FilledButton>(_filledButtonWithText('Ask a question'))
            .onPressed,
        isNull,
      );

      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();

      expect(find.text('Question status unavailable'), findsNothing);
      expect(
        tester
            .widget<FloatingActionButton>(find.byType(FloatingActionButton))
            .onPressed,
        isNotNull,
      );
      expect(
        tester
            .widget<FilledButton>(_filledButtonWithText('Ask a question'))
            .onPressed,
        isNotNull,
      );
    },
  );
}

Finder _textButtonWithText(String text) => find.ancestor(
      of: find.text(text),
      matching: find.byWidgetPredicate((widget) => widget is TextButton),
    );

Finder _filledButtonWithText(String text) => find.ancestor(
      of: find.text(text),
      matching: find.byWidgetPredicate((widget) => widget is FilledButton),
    );

List<Override> _overrides(
  Future<EventQuestion?> Function() loadMyQuestion,
) {
  return <Override>[
    isAuthenticatedProvider.overrideWithValue(true),
    eventQuestionsRepositoryProvider.overrideWithValue(
      const _EmptyQuestionsRepository(),
    ),
    eventQuestionsPreviewProvider.overrideWith(
      (ref, eventSlug) async => const QuestionsPage(),
    ),
    myQuestionProvider.overrideWith(
      (ref, eventSlug) => loadMyQuestion(),
    ),
  ];
}

Widget _localizedApp({
  required List<Override> overrides,
  required Widget child,
}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    ),
  );
}

class _EmptyQuestionsRepository implements EventQuestionsRepository {
  const _EmptyQuestionsRepository();

  @override
  Future<QuestionsPage> getQuestions(
    String eventSlug, {
    int page = 1,
    int perPage = 10,
  }) async {
    return const QuestionsPage();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
