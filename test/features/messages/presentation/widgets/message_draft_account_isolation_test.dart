import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/messages/presentation/widgets/message_composer.dart';
import 'package:lehiboo/features/messages/presentation/widgets/new_conversation_form.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

final _activeAccountProvider = StateProvider<String?>((ref) => 'account-a');

Widget _testApp(ProviderContainer container, Widget child) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    ),
  );
}

ProviderContainer _container() {
  return ProviderContainer(
    overrides: [
      authSessionUserIdProvider.overrideWith(
        (ref) => ref.watch(_activeAccountProvider),
      ),
    ],
  );
}

void main() {
  testWidgets('composer clears A draft and cannot send it after switching to B',
      (tester) async {
    final container = _container();
    addTearDown(container.dispose);
    final sent = <String?>[];

    await tester.pumpWidget(
      _testApp(
        container,
        MessageComposer(
          conversationUuid: 'conversation-a',
          onSend: sent.add,
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'account A private draft');
    expect(find.text('account A private draft'), findsOneWidget);

    container.read(_activeAccountProvider.notifier).state = 'account-b';
    await tester.pump();

    expect(
      find.byKey(const Key('message-composer-session-invalid')),
      findsOneWidget,
    );
    expect(find.text('account A private draft'), findsNothing);
    expect(sent, isEmpty);

    container.read(_activeAccountProvider.notifier).state = 'account-a';
    await tester.pump();

    // Returning to the same id is a new session. The old composer must not
    // become interactive again after it observed the intervening B session.
    expect(
      find.byKey(const Key('message-composer-session-invalid')),
      findsOneWidget,
    );
    expect(find.byType(TextField), findsNothing);
  });

  testWidgets('new conversation clears A draft and fails closed for B',
      (tester) async {
    final container = _container();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      _testApp(
        container,
        Builder(
          builder: (context) => NewConversationForm(
            conversationContext: SupportConversationContext(),
            navigationContext: context,
          ),
        ),
      ),
    );

    final fields = find.byType(TextField);
    expect(fields, findsNWidgets(2));
    await tester.enterText(fields.at(0), 'account A subject');
    await tester.enterText(fields.at(1), 'account A private message');

    container.read(_activeAccountProvider.notifier).state = 'account-b';
    await tester.pump();
    await tester.pump();

    expect(
      find.byKey(const Key('new-conversation-form-session-invalid')),
      findsOneWidget,
    );
    expect(find.text('account A subject'), findsNothing);
    expect(find.text('account A private message'), findsNothing);

    container.read(_activeAccountProvider.notifier).state = 'account-a';
    await tester.pump();

    expect(
      find.byKey(const Key('new-conversation-form-session-invalid')),
      findsOneWidget,
    );
    expect(find.byType(TextField), findsNothing);
  });
}
