import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_session_key_provider.dart';
import 'package:lehiboo/features/events/domain/entities/event_question.dart';
import 'package:lehiboo/features/events/domain/repositories/event_questions_repository.dart';
import 'package:lehiboo/features/events/presentation/providers/event_questions_providers.dart';
import 'package:lehiboo/features/events/presentation/screens/event_questions_screen.dart';
import 'package:lehiboo/features/events/presentation/widgets/detail/ask_question_sheet.dart';
import 'package:lehiboo/features/events/presentation/widgets/detail/event_qa_section.dart';
import 'package:lehiboo/features/events/presentation/widgets/detail/question_card.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

final _accountIdProvider = StateProvider<String?>((ref) => 'user-a');

void main() {
  testWidgets('stale full-screen ask and vote reject A -> B -> A',
      (tester) async {
    final repository = _QuestionsRepository();
    final container = _container(repository);
    addTearDown(container.dispose);

    await tester.pumpWidget(
      _app(
        container,
        const EventQuestionsScreen(
          eventSlug: 'event',
          eventTitle: 'Event',
        ),
      ),
    );
    await tester.pumpAndSettle();

    final staleVote =
        tester.widget<QuestionCard>(find.byType(QuestionCard)).onToggleHelpful!;
    final staleAsk = tester
        .widget<FloatingActionButton>(find.byType(FloatingActionButton))
        .onPressed!;

    container.read(_accountIdProvider.notifier).state = 'user-b';
    await tester.pumpAndSettle();
    container.read(_accountIdProvider.notifier).state = 'user-a';
    await tester.pumpAndSettle();

    staleVote();
    staleAsk();
    await tester.pumpAndSettle();

    expect(repository.markHelpfulCalls, 0);
    expect(repository.createCalls, 0);
    expect(find.byType(AskQuestionSheet), findsNothing);
  });

  testWidgets('account-owned questions route blanks after A -> B -> A',
      (tester) async {
    final repository = _QuestionsRepository(
      myQuestion: const EventQuestion(
        uuid: 'private-a',
        question: 'Account A private question',
      ),
    );
    final container = _container(repository);
    addTearDown(container.dispose);
    final ownerSession = container.read(authSessionKeyProvider);

    await tester.pumpWidget(
      _app(
        container,
        EventQuestionsScreen(
          eventSlug: 'event',
          eventTitle: 'Account A private event',
          ownerSession: ownerSession,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Account A private question'), findsOneWidget);

    container.read(_accountIdProvider.notifier).state = 'user-b';
    await tester.pump();
    container.read(_accountIdProvider.notifier).state = 'user-a';
    await tester.pump();

    expect(find.text('Account A private question'), findsNothing);
    expect(find.text('Account A private event'), findsNothing);
  });

  testWidgets('stale preview navigation rejects A -> B -> A', (tester) async {
    final repository = _QuestionsRepository(total: 2);
    final container = _container(repository);
    addTearDown(container.dispose);
    late final GoRouter router;
    router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => Consumer(
            builder: (context, ref, _) => Scaffold(
              body: EventQASection(
                eventSlug: 'event',
                eventTitle: 'Account A event',
                ownerSession: ref.watch(authSessionKeyProvider),
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/event/:slug/questions',
          builder: (_, __) => const Scaffold(body: Text('Questions route')),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();
    final staleNavigation =
        tester.widget<OutlinedButton>(find.byType(OutlinedButton)).onPressed!;

    container.read(_accountIdProvider.notifier).state = 'user-b';
    await tester.pumpAndSettle();
    container.read(_accountIdProvider.notifier).state = 'user-a';
    await tester.pumpAndSettle();

    staleNavigation();
    await tester.pumpAndSettle();

    expect(router.routeInformationProvider.value.uri.path, '/');
  });
}

ProviderContainer _container(_QuestionsRepository repository) {
  return ProviderContainer(
    overrides: [
      authSessionUserIdProvider.overrideWith(
        (ref) => ref.watch(_accountIdProvider),
      ),
      isAuthenticatedProvider.overrideWith(
        (ref) => ref.watch(_accountIdProvider) != null,
      ),
      eventQuestionsRepositoryProvider.overrideWithValue(repository),
    ],
  );
}

Widget _app(ProviderContainer container, Widget home) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: home,
    ),
  );
}

class _QuestionsRepository implements EventQuestionsRepository {
  _QuestionsRepository({this.myQuestion, this.total = 1});

  final EventQuestion? myQuestion;
  final int total;
  int markHelpfulCalls = 0;
  int createCalls = 0;

  @override
  Future<QuestionsPage> getQuestions(
    String eventSlug, {
    int page = 1,
    int perPage = 10,
  }) async {
    return QuestionsPage(
      items: const [
        EventQuestion(
          uuid: 'public-question',
          question: 'Is parking available?',
          status: QuestionStatus.approved,
        ),
      ],
      total: total,
    );
  }

  @override
  Future<EventQuestion?> getMyQuestion(String eventSlug) async => myQuestion;

  @override
  Future<int> markHelpful(String questionUuid) async {
    markHelpfulCalls++;
    return 1;
  }

  @override
  Future<EventQuestion> createQuestion(String eventSlug, String text) async {
    createCalls++;
    return EventQuestion(uuid: 'created', question: text);
  }

  @override
  Future<int> unmarkHelpful(String questionUuid) async => 0;
}
