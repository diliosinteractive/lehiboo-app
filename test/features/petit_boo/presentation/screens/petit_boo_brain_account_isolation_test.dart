import 'dart:async';
import 'dart:convert';

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
import 'package:lehiboo/features/petit_boo/presentation/screens/petit_boo_brain_screen.dart';
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

  testWidgets('account switch closes an edit dialog and hides its memory value',
      (tester) async {
    tester.view.physicalSize = const Size(900, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    SharedPreferences.setMockInitialValues({
      'petit_boo_user_context': jsonEncode({
        '_storage_account_id': _accountA.id,
        'data': {'city': 'Account A secret city'},
      }),
    });
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
          home: PetitBooBrainScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Account A secret city'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Account A secret city'), findsNWidgets(2));

    auth.setUser(_accountB);
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(find.text('Account A secret city'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
