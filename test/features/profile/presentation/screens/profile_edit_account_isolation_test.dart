import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/auth/data/models/auth_response_dto.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/profile/data/datasources/profile_api_datasource.dart';
import 'package:lehiboo/features/profile/presentation/screens/profile_edit_screen.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

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

class _ControlledProfileApi extends ProfileApiDataSource {
  _ControlledProfileApi() : super(Dio());

  final profileResponse = Completer<UserDto>();
  final passwordResponse = Completer<void>();
  CancelToken? profileCancelToken;
  CancelToken? passwordCancelToken;
  String? submittedFirstName;
  String? submittedCurrentPassword;

  @override
  Future<UserDto> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    String? jobTitle,
    String? birthDate,
    String? membershipCity,
    bool? newsletter,
    bool? pushNotificationsEnabled,
    bool clearBirthDate = false,
    bool clearMembershipCity = false,
    CancelToken? cancelToken,
  }) {
    submittedFirstName = firstName;
    profileCancelToken = cancelToken;
    return profileResponse.future;
  }

  @override
  Future<UserDto> uploadAvatar(
    File imageFile, {
    CancelToken? cancelToken,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
    CancelToken? cancelToken,
  }) {
    submittedCurrentPassword = currentPassword;
    passwordCancelToken = cancelToken;
    return passwordResponse.future;
  }
}

const _accountA = HbUser(
  id: '1',
  email: 'alice.private@example.test',
  displayName: 'Alice Private',
  firstName: 'Alice',
  lastName: 'Private',
  phone: '+33111111111',
  membershipCity: 'Paris',
);

const _accountB = HbUser(
  id: '2',
  email: 'bob@example.test',
  displayName: 'Bob',
  firstName: 'Bob',
  lastName: 'Account',
);

UserDto get _accountAResponse => const UserDto(
      id: 1,
      email: 'alice.private@example.test',
      displayName: 'Alice Private',
      firstName: 'Alice changed',
      lastName: 'Private',
      role: 'subscriber',
    );

Widget _testApp({
  required _ControlledProfileApi api,
  required void Function(_MutableAuthNotifier notifier) captureAuth,
}) {
  return ProviderScope(
    overrides: [
      authProvider.overrideWith((ref) {
        final notifier = _MutableAuthNotifier(ref, _accountA);
        captureAuth(notifier);
        return notifier;
      }),
      profileApiDataSourceProvider.overrideWithValue(api),
    ],
    child: const MaterialApp(
      locale: Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: ProfileEditScreen(),
    ),
  );
}

void main() {
  testWidgets(
    'account switch clears profile PII and cancels an in-flight save',
    (tester) async {
      final api = _ControlledProfileApi();
      late _MutableAuthNotifier auth;
      await tester.pumpWidget(
        _testApp(api: api, captureAuth: (value) => auth = value),
      );
      await tester.pumpAndSettle();

      final firstName = tester.widget<TextFormField>(
        find.byKey(const ValueKey('profile-edit-first-name')),
      );
      expect(firstName.controller!.text, 'Alice');
      await tester.enterText(
        find.byKey(const ValueKey('profile-edit-first-name')),
        'Alice private edit',
      );

      final save = find.byKey(const ValueKey('profile-edit-save'));
      await tester.ensureVisible(save);
      await tester.tap(save);
      await tester.pump();
      expect(api.submittedFirstName, 'Alice private edit');
      expect(api.profileCancelToken?.isCancelled, isFalse);

      auth.setUser(_accountB);
      await tester.pump();
      await tester.pumpAndSettle();

      expect(api.profileCancelToken?.isCancelled, isTrue);
      expect(find.textContaining('Alice'), findsNothing);
      expect(
        find.byKey(const ValueKey('profile-edit-first-name')),
        findsNothing,
      );

      api.profileResponse.complete(_accountAResponse);
      await tester.pump();
      expect(auth.state.user, _accountB);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'account switch closes and cancels the password dialog',
    (tester) async {
      final api = _ControlledProfileApi();
      late _MutableAuthNotifier auth;
      await tester.pumpWidget(
        _testApp(api: api, captureAuth: (value) => auth = value),
      );
      await tester.pumpAndSettle();

      final changePassword =
          find.byKey(const ValueKey('profile-change-password'));
      await tester.ensureVisible(changePassword);
      await tester.tap(changePassword);
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('profile-current-password')),
        'account-a-secret',
      );
      await tester.enterText(
        find.byKey(const ValueKey('profile-new-password')),
        'new-account-a-secret',
      );
      await tester.enterText(
        find.byKey(const ValueKey('profile-confirm-password')),
        'new-account-a-secret',
      );
      await tester.tap(
        find.byKey(const ValueKey('profile-change-password-submit')),
      );
      await tester.pump();
      expect(api.submittedCurrentPassword, 'account-a-secret');

      auth.setUser(_accountB);
      await tester.pump();
      await tester.pumpAndSettle();

      expect(api.passwordCancelToken?.isCancelled, isTrue);
      expect(
        find.byKey(const ValueKey('profile-current-password')),
        findsNothing,
      );
      expect(find.textContaining('account-a-secret'), findsNothing);

      api.passwordResponse.complete();
      await tester.pump();
      expect(auth.state.user, _accountB);
      expect(tester.takeException(), isNull);
    },
  );
}
