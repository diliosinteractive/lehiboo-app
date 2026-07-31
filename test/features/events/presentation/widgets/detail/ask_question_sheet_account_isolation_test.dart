import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_session_key_provider.dart';
import 'package:lehiboo/features/events/domain/entities/event_question.dart';
import 'package:lehiboo/features/events/domain/repositories/event_questions_repository.dart';
import 'package:lehiboo/features/events/presentation/providers/event_questions_providers.dart';
import 'package:lehiboo/features/events/presentation/widgets/detail/ask_question_sheet.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

final _accountIdProvider = StateProvider<String?>((ref) => 'user-a');

void main() {
  testWidgets('ask sheet discards its draft when the account changes',
      (tester) async {
    final container = _container(_QuestionsRepository());
    addTearDown(container.dispose);

    await tester.pumpWidget(_testApp(container));
    await tester.tap(find.text('Ask'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextFormField),
      'Question drafted by account A',
    );
    expect(find.text('Question drafted by account A'), findsOneWidget);

    container.read(_accountIdProvider.notifier).state = 'user-b';
    await tester.pump();
    await tester.pump();
    expect(find.byType(AskQuestionSheet), findsNothing);
    expect(find.text('Question drafted by account A'), findsNothing);

    await tester.tap(find.text('Ask'));
    await tester.pumpAndSettle();
    final field = tester.widget<TextFormField>(find.byType(TextFormField));
    expect(field.controller?.text, isEmpty);
  });

  testWidgets('in-flight question submission cannot survive account switch',
      (tester) async {
    final repository = _QuestionsRepository();
    final container = _container(repository);
    addTearDown(container.dispose);

    await tester.pumpWidget(_testApp(container));
    await tester.tap(find.text('Ask'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextFormField),
      'A sufficiently long account A question',
    );
    await tester.tap(find.text('Send my question'));
    await tester.pump();
    expect(repository.createRequests, hasLength(1));

    container.read(_accountIdProvider.notifier).state = 'user-b';
    await tester.pump();
    await tester.pump();
    expect(find.byType(AskQuestionSheet), findsNothing);

    repository.createRequests.single.complete(
      const EventQuestion(
        uuid: 'question-a',
        question: 'A sufficiently long account A question',
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.byType(AskQuestionSheet), findsNothing);
    expect(repository.createRequests, hasLength(1));
  });

  testWidgets('stale A sheet launcher is rejected after A -> B -> A',
      (tester) async {
    final container = _container(_QuestionsRepository());
    addTearDown(container.dispose);

    await tester.pumpWidget(_testApp(container));
    final staleLauncher = tester
        .widget<TextButton>(find.widgetWithText(TextButton, 'Ask'))
        .onPressed!;

    container.read(_accountIdProvider.notifier).state = 'user-b';
    await tester.pump();
    container.read(_accountIdProvider.notifier).state = 'user-a';
    await tester.pump();

    staleLauncher();
    await tester.pumpAndSettle();

    expect(find.byType(AskQuestionSheet), findsNothing);
  });
}

ProviderContainer _container(EventQuestionsRepository repository) =>
    ProviderContainer(
      overrides: [
        authSessionUserIdProvider.overrideWith(
          (ref) => ref.watch(_accountIdProvider),
        ),
        eventQuestionsRepositoryProvider.overrideWithValue(repository),
      ],
    );

Widget _testApp(ProviderContainer container) => UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Consumer(
            builder: (context, ref, _) {
              final ownerSession = ref.watch(authSessionKeyProvider);
              return TextButton(
                onPressed: ownerSession.accountId == null
                    ? null
                    : () => AskQuestionSheet.show(
                          context,
                          eventSlug: 'event',
                          eventTitle: 'Event',
                          ownerSession: ownerSession,
                        ),
                child: const Text('Ask'),
              );
            },
          ),
        ),
      ),
    );

class _QuestionsRepository implements EventQuestionsRepository {
  final List<Completer<EventQuestion>> createRequests = [];

  @override
  Future<EventQuestion> createQuestion(String eventSlug, String text) {
    final request = Completer<EventQuestion>();
    createRequests.add(request);
    return request.future;
  }

  @override
  Future<EventQuestion?> getMyQuestion(String eventSlug) =>
      throw UnimplementedError();

  @override
  Future<QuestionsPage> getQuestions(
    String eventSlug, {
    int page = 1,
    int perPage = 10,
  }) =>
      throw UnimplementedError();

  @override
  Future<int> markHelpful(String questionUuid) => throw UnimplementedError();

  @override
  Future<int> unmarkHelpful(String questionUuid) => throw UnimplementedError();
}
