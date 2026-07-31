import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/petit_boo/data/datasources/petit_boo_context_storage.dart';
import 'package:lehiboo/features/petit_boo/data/models/quota_dto.dart';
import 'package:lehiboo/features/petit_boo/domain/repositories/petit_boo_repository.dart';
import 'package:lehiboo/features/petit_boo/presentation/providers/petit_boo_chat_provider.dart';
import 'package:lehiboo/features/petit_boo/presentation/widgets/chat_input_bar.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class _AvailablePetitBooRepository implements PetitBooRepository {
  @override
  Future<bool> isServiceAvailable() async => true;

  @override
  Future<QuotaDto> getQuota() async => const QuotaDto();

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

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('text drafts are cleared on account switch and logout',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    late _MutableAuthNotifier auth;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith((ref) {
            auth = _MutableAuthNotifier(ref, _accountA);
            return auth;
          }),
          petitBooRepositoryProvider.overrideWithValue(
            _AvailablePetitBooRepository(),
          ),
          petitBooContextStorageProvider.overrideWithValue(
            PetitBooContextStorage(preferences),
          ),
        ],
        child: const MaterialApp(
          locale: Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: ChatInputBar(initializeSpeechOnMount: false),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final input = find.byKey(const ValueKey('petit-boo-chat-input'));
    await tester.enterText(input, 'Account A private draft');
    expect(
      tester.widget<TextField>(input).controller!.text,
      'Account A private draft',
    );

    auth.setUser(_accountB);
    await tester.pump();
    expect(tester.widget<TextField>(input).controller!.text, isEmpty);
    expect(find.textContaining('Account A private draft'), findsNothing);

    await tester.enterText(input, 'Account B private draft');
    auth.signOutLocally();
    await tester.pump();
    expect(tester.widget<TextField>(input).controller!.text, isEmpty);
    expect(find.textContaining('Account B private draft'), findsNothing);
  });
}
