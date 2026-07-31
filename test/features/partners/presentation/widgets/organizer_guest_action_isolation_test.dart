import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_session_key_provider.dart';
import 'package:lehiboo/features/auth/presentation/widgets/guest_restriction_dialog.dart';
import 'package:lehiboo/features/partners/data/models/organizer_profile_dto.dart';
import 'package:lehiboo/features/partners/presentation/widgets/organizer_action_bar.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

void main() {
  testWidgets('guest replay resumes only the initiating organizer action',
      (tester) async {
    late _TestAuthNotifier auth;
    var organizerAToggles = 0;
    var organizerBToggles = 0;
    final container = ProviderContainer(
      overrides: [
        authProvider.overrideWith((ref) {
          auth = _TestAuthNotifier(ref);
          return auth;
        }),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Consumer(
            builder: (context, ref, _) => Scaffold(
              body: Column(
                children: [
                  OrganizerActionBar(
                    organizer: _organizerA,
                    ownerSession: ref.watch(authSessionKeyProvider),
                    coordinatesOpen: false,
                    onCoordinatesToggle: (_) => organizerAToggles++,
                  ),
                  OrganizerActionBar(
                    organizer: _organizerB,
                    ownerSession: ref.watch(authSessionKeyProvider),
                    coordinatesOpen: false,
                    onCoordinatesToggle: (_) => organizerBToggles++,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    final coordinatesButtons = find.byIcon(Icons.expand_more);
    expect(coordinatesButtons, findsNWidgets(2));
    await tester.tap(coordinatesButtons.at(1));
    await tester.pumpAndSettle();
    expect(find.byType(GuestRestrictionDialog), findsOneWidget);

    auth.setUser(_accountB);
    await tester.pumpAndSettle();

    expect(find.byType(GuestRestrictionDialog), findsNothing);
    expect(organizerAToggles, 0);
    expect(organizerBToggles, 1);
  });

  testWidgets('guest intent is discarded across guest to A to B to A',
      (tester) async {
    late _TestAuthNotifier auth;
    var toggles = 0;
    final container = ProviderContainer(
      overrides: [
        authProvider.overrideWith((ref) {
          auth = _TestAuthNotifier(ref);
          return auth;
        }),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Consumer(
            builder: (context, ref, _) => Scaffold(
              body: OrganizerActionBar(
                organizer: _organizerA,
                ownerSession: ref.watch(authSessionKeyProvider),
                coordinatesOpen: false,
                onCoordinatesToggle: (_) => toggles++,
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.expand_more));
    await tester.pumpAndSettle();
    expect(find.byType(GuestRestrictionDialog), findsOneWidget);

    auth.setUser(_accountA);
    auth.setUser(_accountB);
    auth.setUser(_accountA);
    await tester.pumpAndSettle();

    expect(find.byType(GuestRestrictionDialog), findsNothing);
    expect(toggles, 0);
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
  _TestAuthNotifier(Ref ref) : super(_NeverCompletingAuthRepository(), ref) {
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  void setUser(HbUser user) {
    state = AuthState(status: AuthStatus.authenticated, user: user);
  }
}

const _accountB = HbUser(
  id: 'account-b',
  email: 'b@example.test',
  displayName: 'Account B',
);

const _accountA = HbUser(
  id: 'account-a',
  email: 'a@example.test',
  displayName: 'Account A',
);

const _organizerA = OrganizerProfileDto(
  uuid: 'organizer-a',
  slug: 'organizer-a',
  name: 'Organizer A',
);

const _organizerB = OrganizerProfileDto(
  uuid: 'organizer-b',
  slug: 'organizer-b',
  name: 'Organizer B',
);
