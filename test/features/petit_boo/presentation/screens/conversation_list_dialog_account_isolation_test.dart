import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/auth/presentation/widgets/account_bound_route_guard.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/petit_boo/data/models/conversation_dto.dart';
import 'package:lehiboo/features/petit_boo/domain/repositories/petit_boo_repository.dart';
import 'package:lehiboo/features/petit_boo/presentation/screens/conversation_list_screen.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

void main() {
  testWidgets('account switch closes history delete without deleting',
      (tester) async {
    final repository = _PetitBooRepository();
    late _TestAuthNotifier auth;
    final container = ProviderContainer(
      overrides: [
        authProvider.overrideWith((ref) {
          auth = _TestAuthNotifier(ref, _accountA);
          return auth;
        }),
        petitBooRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          locale: Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ConversationListScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.drag(find.byType(Dismissible), const Offset(-600, 0));
    await tester.pumpAndSettle();
    expect(find.byType(AccountBoundRouteGuard<bool>), findsOneWidget);

    auth.setUser(_accountB);
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.byType(AccountBoundRouteGuard<bool>), findsNothing);
    expect(repository.deletedIds, isEmpty);
  });
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

class _PetitBooRepository implements PetitBooRepository {
  final deletedIds = <String>[];

  @override
  Future<ConversationsResult> getConversations({
    int page = 1,
    int perPage = 20,
  }) async {
    return ConversationsResult(
      conversations: [_conversation],
      currentPage: 1,
      totalPages: 1,
      totalItems: 1,
    );
  }

  @override
  Future<void> deleteConversation(String uuid) async {
    deletedIds.add(uuid);
  }

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

const _conversation = ConversationDto(
  uuid: 'conversation-a',
  title: 'Account A private conversation',
  createdAt: '2026-07-31T10:00:00Z',
  lastMessage: 'Account A private message',
);
