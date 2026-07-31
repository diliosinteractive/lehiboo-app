import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:lehiboo/core/themes/app_theme.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/messages/data/repositories/messages_repository_impl.dart';
import 'package:lehiboo/features/messages/domain/entities/broadcast.dart';
import 'package:lehiboo/features/messages/domain/entities/conversation.dart';
import 'package:lehiboo/features/messages/domain/repositories/messages_repository.dart';
import 'package:lehiboo/features/messages/presentation/screens/broadcast_detail_screen.dart';
import 'package:lehiboo/features/messages/presentation/screens/new_conversation_screen.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

void main() {
  setUpAll(() {
    dotenv.testLoad(fileInput: 'PUSHER_APP_KEY=\nPUSHER_HOST=');
  });

  testWidgets(
    'broadcast detail discards a late response and stays invalid after A-B-A',
    (tester) async {
      final repository = _ControlledMessagesRepository();
      final scope = _scope(repository);
      addTearDown(scope.container.dispose);

      await tester.pumpWidget(
        _materialApp(
          scope.container,
          const BroadcastDetailScreen(broadcastUuid: 'broadcast-a'),
        ),
      );
      await tester.pump();

      expect(repository.broadcastCalls, 1);

      scope.auth.setUser(_accountB);
      await tester.pump();
      expect(
        find.byKey(const Key('broadcast-detail-session-invalid')),
        findsOneWidget,
      );

      scope.auth.setUser(_accountA);
      await tester.pump();
      expect(
        find.byKey(const Key('broadcast-detail-session-invalid')),
        findsOneWidget,
      );

      repository.broadcastResponse.complete(_broadcast(isSent: true));
      await tester.pump();

      expect(find.text('Account A private broadcast'), findsNothing);
      expect(find.text('Account A private message body'), findsNothing);
      expect(
        find.byKey(const Key('broadcast-detail-session-invalid')),
        findsOneWidget,
      );
      expect(find.text('Account A private broadcast'), findsNothing);
      expect(repository.broadcastCalls, 1);
    },
  );

  testWidgets('broadcast polling stops immediately on account switch',
      (tester) async {
    final repository = _ImmediateBroadcastRepository();
    final scope = _scope(repository);
    addTearDown(scope.container.dispose);

    await tester.pumpWidget(
      _materialApp(
        scope.container,
        const BroadcastDetailScreen(broadcastUuid: 'broadcast-a'),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Account A private broadcast'), findsOneWidget);
    expect(repository.broadcastCalls, 1);

    scope.auth.setUser(_accountB);
    await tester.pump();
    await tester.pump(const Duration(seconds: 6));

    expect(
      find.byKey(const Key('broadcast-detail-session-invalid')),
      findsOneWidget,
    );
    expect(repository.broadcastCalls, 1);
  });

  testWidgets(
    'late create-from-booking response cannot refresh or navigate account B',
    (tester) async {
      final repository = _ControlledMessagesRepository();
      final scope = _scope(repository);
      final router = _bookingConversationRouter();
      addTearDown(() {
        router.dispose();
        scope.container.dispose();
      });

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: scope.container,
          child: MaterialApp.router(
            theme: AppTheme.lightTheme,
            locale: const Locale('en'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: router,
          ),
        ),
      );
      await tester.pump();

      expect(repository.createFromBookingCalls, 1);

      scope.auth.setUser(_accountB);
      await tester.pump();
      expect(
        find.byKey(const Key('new-conversation-session-invalid')),
        findsOneWidget,
      );

      scope.auth.setUser(_accountA);
      await tester.pump();
      expect(
        find.byKey(const Key('new-conversation-session-invalid')),
        findsOneWidget,
      );
      final listCallsBeforeStaleResponse = repository.conversationListCalls;

      repository.createFromBookingResponse.complete(
        CreateFromBookingResult(
          conversation: _conversation('account-a-private-conversation'),
          created: true,
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byKey(const Key('conversation-destination')), findsNothing);
      expect(
        repository.conversationListCalls,
        listCallsBeforeStaleResponse,
      );
      expect(
        find.byKey(const Key('new-conversation-session-invalid')),
        findsOneWidget,
      );
      expect(find.byKey(const Key('conversation-destination')), findsNothing);
    },
  );
}

({ProviderContainer container, _TestAuthNotifier auth}) _scope(
  MessagesRepository repository,
) {
  late _TestAuthNotifier auth;
  final container = ProviderContainer(
    overrides: [
      authProvider.overrideWith((ref) {
        auth = _TestAuthNotifier(ref, _accountA);
        return auth;
      }),
      messagesRepositoryProvider.overrideWithValue(repository),
    ],
  );
  container.read(authProvider);
  return (container: container, auth: auth);
}

Widget _materialApp(ProviderContainer container, Widget home) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      theme: AppTheme.lightTheme,
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: home,
    ),
  );
}

GoRouter _bookingConversationRouter() {
  return GoRouter(
    initialLocation: '/messages/new/from-booking/booking-a',
    routes: [
      GoRoute(
        path: '/messages/new/from-booking/:bookingUuid',
        builder: (_, state) => NewConversationScreen(
          fromBookingUuid: state.pathParameters['bookingUuid']!,
        ),
      ),
      GoRoute(
        path: '/messages/:conversationUuid',
        builder: (_, __) => const Scaffold(
          body: SizedBox(key: Key('conversation-destination')),
        ),
      ),
    ],
  );
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

class _ControlledMessagesRepository implements MessagesRepository {
  final broadcastResponse = Completer<Broadcast>();
  final createFromBookingResponse = Completer<CreateFromBookingResult>();
  int broadcastCalls = 0;
  int createFromBookingCalls = 0;
  int conversationListCalls = 0;

  @override
  Future<Broadcast> getBroadcast(String uuid) {
    broadcastCalls++;
    return broadcastResponse.future;
  }

  @override
  Future<CreateFromBookingResult> createFromBooking(String bookingUuid) {
    createFromBookingCalls++;
    return createFromBookingResponse.future;
  }

  @override
  Future<ConversationsListResult> getConversations({
    String? status,
    bool? unreadOnly,
    String? search,
    String? period,
    int page = 1,
    int perPage = 15,
  }) async {
    conversationListCalls++;
    return const ConversationsListResult(
      conversations: [],
      hasMore: false,
      currentPage: 1,
      totalCount: 0,
    );
  }

  @override
  Future<int> getUnreadCount() async => 0;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _ImmediateBroadcastRepository implements MessagesRepository {
  int broadcastCalls = 0;

  @override
  Future<Broadcast> getBroadcast(String uuid) async {
    broadcastCalls++;
    return _broadcast(isSent: false);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Broadcast _broadcast({required bool isSent}) {
  return Broadcast(
    uuid: 'broadcast-a',
    subject: 'Account A private broadcast',
    body: 'Account A private message body',
    recipientsCount: 10,
    readCount: 3,
    conversationsCreated: 1,
    isSent: isSent,
    events: const [],
    createdAt: DateTime(2026),
  );
}

Conversation _conversation(String uuid) {
  return Conversation(
    uuid: uuid,
    subject: 'Account A private conversation',
    status: 'open',
    conversationType: 'participant_vendor',
    unreadCount: 0,
    isSignalement: false,
    userHasReported: false,
    messages: const [],
    createdAt: DateTime(2026),
    updatedAt: DateTime(2026),
  );
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
