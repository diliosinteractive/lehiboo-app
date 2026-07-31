import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/messages/data/repositories/messages_repository_impl.dart';
import 'package:lehiboo/features/messages/domain/entities/conversation.dart';
import 'package:lehiboo/features/messages/domain/repositories/messages_repository.dart';
import 'package:lehiboo/features/messages/presentation/screens/conversation_detail_screen.dart';
import 'package:lehiboo/features/messages/presentation/screens/support_detail_screen.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';
import 'package:lehiboo/core/themes/app_theme.dart';

final _activeAccountProvider = StateProvider<String?>((ref) => 'account-a');

void main() {
  testWidgets(
    'conversation detail permanently hides account A data after A-B-A switch',
    (tester) async {
      final container = _container();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        _testApp(
          container,
          const ConversationDetailScreen(conversationUuid: 'conversation-a'),
        ),
      );
      await tester.pump();

      expect(find.text('Account A private subject'), findsWidgets);

      container.read(_activeAccountProvider.notifier).state = 'account-b';
      await tester.pump();

      expect(
        find.byKey(const Key('conversation-detail-session-invalid')),
        findsOneWidget,
      );
      expect(find.text('Account A private subject'), findsNothing);

      container.read(_activeAccountProvider.notifier).state = 'account-a';
      await tester.pump();

      expect(
        find.byKey(const Key('conversation-detail-session-invalid')),
        findsOneWidget,
      );
      expect(find.text('Account A private subject'), findsNothing);
    },
  );

  testWidgets(
    'support detail permanently hides account A data after A-B-A switch',
    (tester) async {
      final container = _container();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        _testApp(
          container,
          const SupportDetailScreen(conversationUuid: 'conversation-a'),
        ),
      );
      await tester.pump();

      expect(find.text('Account A private subject'), findsOneWidget);

      container.read(_activeAccountProvider.notifier).state = 'account-b';
      await tester.pump();

      expect(
        find.byKey(const Key('support-detail-session-invalid')),
        findsOneWidget,
      );
      expect(find.text('Account A private subject'), findsNothing);

      container.read(_activeAccountProvider.notifier).state = 'account-a';
      await tester.pump();

      expect(
        find.byKey(const Key('support-detail-session-invalid')),
        findsOneWidget,
      );
      expect(find.text('Account A private subject'), findsNothing);
    },
  );
}

ProviderContainer _container() {
  return ProviderContainer(
    overrides: [
      authRepositoryProvider
          .overrideWithValue(_NeverCompletingAuthRepository()),
      authSessionUserIdProvider.overrideWith(
        (ref) => ref.watch(_activeAccountProvider),
      ),
      messagesRepositoryProvider.overrideWithValue(_DetailRepository()),
    ],
  );
}

Widget _testApp(ProviderContainer container, Widget home) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      locale: const Locale('en'),
      theme: AppTheme.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: home,
    ),
  );
}

class _NeverCompletingAuthRepository implements AuthRepository {
  final Completer<bool> _authenticated = Completer<bool>();

  @override
  Future<bool> isAuthenticated() => _authenticated.future;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _DetailRepository implements MessagesRepository {
  @override
  Future<Conversation> getConversation(String uuid) async =>
      _conversation(uuid);

  @override
  Future<Conversation> getSupportConversation(String uuid) async =>
      _conversation(uuid);

  Conversation _conversation(String uuid) => Conversation(
        uuid: uuid,
        subject: 'Account A private subject',
        status: 'open',
        conversationType: 'participant_vendor',
        unreadCount: 0,
        isSignalement: false,
        userHasReported: false,
        messages: const [],
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
