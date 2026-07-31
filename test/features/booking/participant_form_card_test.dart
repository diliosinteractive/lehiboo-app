import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/booking/domain/models/booking_flow_state.dart';
import 'package:lehiboo/features/booking/presentation/widgets/participant_form_card.dart';
import 'package:lehiboo/features/profile/domain/models/saved_participant.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

final _activeAccountIdProvider = StateProvider<String?>((ref) => 'account-a');

void main() {
  testWidgets(
    'syncs the prefill dropdown when parent applies a saved participant',
    (tester) async {
      const savedParticipant = SavedParticipant(
        uuid: 'participant-1',
        displayName: 'Alice Martin',
        firstName: 'Alice',
        lastName: 'Martin',
        relationship: 'child',
        birthDate: '2018-04-12',
        membershipCity: 'Lyon',
      );

      await tester.pumpWidget(
        const _Subject(
          initialValue: ParticipantInfo(),
          savedParticipants: [savedParticipant],
        ),
      );

      expect(_prefillDropdown(tester).initialValue, 'manual');

      await tester.pumpWidget(
        _Subject(
          initialValue: savedParticipant.toParticipantInfo(),
          savedParticipants: const [savedParticipant],
        ),
      );

      expect(_prefillDropdown(tester).initialValue, 'participant-1');
    },
  );

  testWidgets('account switch closes the participant birth-date picker',
      (tester) async {
    final changes = <ParticipantInfo>[];
    await tester.pumpWidget(
      _Subject(
        initialValue: const ParticipantInfo(birthDate: '2018-04-12'),
        savedParticipants: const [],
        onChanged: changes.add,
      ),
    );

    final calendarIcon = find.byIcon(Icons.calendar_today_outlined);
    await tester.ensureVisible(calendarIcon);
    await tester.tap(calendarIcon);
    await tester.pumpAndSettle();
    expect(find.byType(DatePickerDialog), findsOneWidget);

    final container = ProviderScope.containerOf(
      tester.element(find.byType(ParticipantFormCard)),
    );
    container.read(_activeAccountIdProvider.notifier).state = 'account-b';
    await tester.pumpAndSettle();

    expect(find.byType(DatePickerDialog), findsNothing);
    expect(changes, isEmpty);
    expect(tester.takeException(), isNull);
  });
}

DropdownButtonFormField<String> _prefillDropdown(WidgetTester tester) {
  return tester.widget<DropdownButtonFormField<String>>(
    find.byType(DropdownButtonFormField<String>).first,
  );
}

class _Subject extends StatelessWidget {
  final ParticipantInfo initialValue;
  final List<SavedParticipant> savedParticipants;
  final ValueChanged<ParticipantInfo>? onChanged;

  const _Subject({
    required this.initialValue,
    required this.savedParticipants,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        authSessionUserIdProvider.overrideWith(
          (ref) => ref.watch(_activeAccountIdProvider),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: ParticipantFormCard(
              ownerAccountId: 'account-a',
              ticketTypeName: 'Standard',
              participantIndex: 1,
              totalForType: 1,
              initialValue: initialValue,
              savedParticipants: savedParticipants,
              initiallyExpanded: true,
              onChanged: onChanged ?? (_) {},
            ),
          ),
        ),
      ),
    );
  }
}
