import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/checkin/data/models/checkin_request_dto.dart';
import 'package:lehiboo/features/checkin/data/models/checkin_response_dto.dart';
import 'package:lehiboo/features/checkin/data/models/ticket_summary_dto.dart';
import 'package:lehiboo/features/checkin/data/repositories/checkin_repository_impl.dart';
import 'package:lehiboo/features/checkin/domain/entities/active_organization.dart';
import 'package:lehiboo/features/checkin/domain/entities/peek_result.dart';
import 'package:lehiboo/features/checkin/domain/repositories/checkin_repository.dart';
import 'package:lehiboo/features/checkin/presentation/providers/active_organization_provider.dart';
import 'package:lehiboo/features/checkin/presentation/providers/scan_session_provider.dart';
import 'package:lehiboo/features/checkin/presentation/screens/checkin_manual_entry_screen.dart';
import 'package:lehiboo/features/memberships/data/models/membership_dto.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

final _accountIdProvider = StateProvider<String?>((ref) => 'account-a');

const _ticket = TicketSummaryDto(
  uuid: 'ticket-a',
  attendeeFirstName: 'Alice',
  attendeeLastName: 'Account A',
  eventTitle: 'Account A private event',
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'manual peek completion cannot expose account-A ticket data after A to B',
    (tester) async {
      final peek = Completer<PeekResult>();
      final repository =
          _ControlledCheckinRepository(onPeek: () => peek.future);

      await _pumpManualScreen(tester, repository);
      await tester.enterText(find.byType(TextField), 'PRIVATECODEA');
      await tester.tap(find.text('Verify code'));
      await tester.pump();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(CheckinManualEntryScreen)),
      );
      container.read(_accountIdProvider.notifier).state = 'account-b';
      await tester.pump();

      expect(find.text('PRIVATECODEA'), findsNothing);
      peek.complete(const CanCheckIn(_ticket));
      await tester.pumpAndSettle();

      expect(find.text('Alice Account A'), findsNothing);
      expect(find.text('Account A private event'), findsNothing);
      expect(repository.commitCalls, 0);
    },
  );

  testWidgets(
    'account switch closes a visible confirmation and prevents its commit',
    (tester) async {
      final repository = _ControlledCheckinRepository(
        onPeek: () async => const CanCheckIn(_ticket),
      );

      await _pumpManualScreen(tester, repository);
      await tester.enterText(find.byType(TextField), 'PRIVATECODEA');
      await tester.tap(find.text('Verify code'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Alice Account A'), findsOneWidget);
      expect(find.text('Confirm entry'), findsOneWidget);

      final container = ProviderScope.containerOf(
        tester.element(find.byType(CheckinManualEntryScreen)),
      );
      container.read(_accountIdProvider.notifier).state = 'account-b';
      await tester.pumpAndSettle();

      expect(find.text('Alice Account A'), findsNothing);
      expect(find.text('Confirm entry'), findsNothing);
      expect(repository.commitCalls, 0);
    },
  );

  test('scan gate state is recreated per exact account', () async {
    final container = ProviderContainer(
      overrides: [
        authSessionUserIdProvider.overrideWith(
          (ref) => ref.watch(_accountIdProvider),
        ),
      ],
    );
    addTearDown(container.dispose);

    final accountANotifier = container.read(scanSessionProvider.notifier);
    accountANotifier.setGate('Account A private gate');
    expect(container.read(scanSessionProvider).gate, 'Account A private gate');

    container.read(_accountIdProvider.notifier).state = 'account-b';
    await Future<void>.delayed(Duration.zero);

    expect(container.read(scanSessionProvider).gate, isNull);
    accountANotifier.setGate('stale update');
    expect(container.read(scanSessionProvider).gate, isNull);
  });

  test('rapid A to B to A cannot revive the first A scan gate', () {
    late _MutableAuthNotifier auth;
    final container = ProviderContainer(
      overrides: [
        authProvider.overrideWith((ref) {
          auth = _MutableAuthNotifier(ref);
          return auth;
        }),
      ],
    );
    addTearDown(container.dispose);

    final firstA = container.read(scanSessionProvider.notifier);
    firstA.setGate('First A private gate');
    expect(container.read(scanSessionProvider).gate, 'First A private gate');

    auth.setAccount('account-b');
    auth.setAccount('account-a');

    final secondA = container.read(scanSessionProvider.notifier);
    expect(identical(secondA, firstA), isFalse);
    expect(container.read(scanSessionProvider).gate, isNull);

    firstA.setGate('stale first A update');
    expect(container.read(scanSessionProvider).gate, isNull);
  });
}

Future<void> _pumpManualScreen(
  WidgetTester tester,
  CheckinRepository repository,
) async {
  final storage = _MemoryActiveOrganizationStorage();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authSessionUserIdProvider.overrideWith(
          (ref) => ref.watch(_accountIdProvider),
        ),
        checkinRepositoryProvider.overrideWithValue(repository),
        activeOrganizationStorageProvider.overrideWithValue(storage),
      ],
      child: const MaterialApp(
        locale: Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: CheckinManualEntryScreen(),
      ),
    ),
  );
  await tester.pump();

  final container = ProviderScope.containerOf(
    tester.element(find.byType(CheckinManualEntryScreen)),
  );
  await container.read(activeOrganizationProvider.notifier).set(
        const ActiveOrganization(
          uuid: 'org-a',
          name: 'Account A organization',
          role: MembershipRole.staff,
        ),
      );
  await tester.pumpAndSettle();
}

class _ControlledCheckinRepository implements CheckinRepository {
  _ControlledCheckinRepository({required this.onPeek});

  final Future<PeekResult> Function() onPeek;
  int commitCalls = 0;

  @override
  Future<PeekResult> peek({
    String? qrData,
    String? qrCode,
    int? eventId,
  }) {
    return onPeek();
  }

  @override
  Future<CheckinResponseDto> commit(
    String ticketUuid,
    CheckinRequestDto request,
  ) async {
    commitCalls++;
    return const CheckinResponseDto(
      ticket: _ticket,
      action: 'check_in',
      checkInCount: 1,
    );
  }
}

class _MemoryActiveOrganizationStorage implements ActiveOrganizationStorage {
  final Map<String, String> values = {};

  @override
  Future<void> delete({required String key}) async {
    values.remove(key);
  }

  @override
  Future<String?> read({required String key}) async => values[key];

  @override
  Future<void> write({required String key, required String value}) async {
    values[key] = value;
  }
}

class _NeverCompletingAuthRepository implements AuthRepository {
  final Completer<bool> _authentication = Completer<bool>();

  @override
  Future<bool> isAuthenticated() => _authentication.future;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MutableAuthNotifier extends AuthNotifier {
  _MutableAuthNotifier(Ref ref) : super(_NeverCompletingAuthRepository(), ref) {
    setAccount('account-a');
  }

  void setAccount(String accountId) {
    state = AuthState(
      status: AuthStatus.authenticated,
      user: HbUser(
        id: accountId,
        email: '$accountId@example.test',
        displayName: accountId,
      ),
    );
  }
}
