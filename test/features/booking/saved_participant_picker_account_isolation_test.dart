import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/booking/presentation/widgets/saved_participant_picker_sheet.dart';
import 'package:lehiboo/features/profile/domain/models/saved_participant.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

final _activeAccountIdProvider = StateProvider<String?>((ref) => 'account-a');

const _accountAParticipant = SavedParticipant(
  uuid: 'participant-a',
  label: 'Account A child',
  relationship: 'child',
  displayName: 'Account A child',
  firstName: 'Alice',
  lastName: 'Account A',
  birthDate: '2015-01-02',
  membershipCity: 'Private City A',
);

void main() {
  testWidgets('account switch closes the saved-participant PII picker',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authSessionUserIdProvider.overrideWith(
            (ref) => ref.watch(_activeAccountIdProvider),
          ),
        ],
        child: const MaterialApp(
          locale: Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: _PickerLauncher(),
        ),
      ),
    );

    await tester.tap(find.text('Open picker'));
    await tester.pumpAndSettle();
    expect(find.text('Account A child'), findsOneWidget);
    expect(find.textContaining('Private City A'), findsOneWidget);

    final container = ProviderScope.containerOf(
      tester.element(find.byType(_PickerLauncher)),
    );
    container.read(_activeAccountIdProvider.notifier).state = 'account-b';
    await tester.pumpAndSettle();

    expect(find.text('Account A child'), findsNothing);
    expect(find.textContaining('Private City A'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}

class _PickerLauncher extends StatelessWidget {
  const _PickerLauncher();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => showSavedParticipantPickerSheet(
            context,
            ownerAccountId: 'account-a',
            participants: const [_accountAParticipant],
          ),
          child: const Text('Open picker'),
        ),
      ),
    );
  }
}
