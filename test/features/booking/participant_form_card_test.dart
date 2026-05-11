import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/booking/domain/models/booking_flow_state.dart';
import 'package:lehiboo/features/booking/presentation/widgets/participant_form_card.dart';
import 'package:lehiboo/features/profile/domain/models/saved_participant.dart';

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
}

DropdownButtonFormField<String> _prefillDropdown(WidgetTester tester) {
  return tester.widget<DropdownButtonFormField<String>>(
    find.byType(DropdownButtonFormField<String>).first,
  );
}

class _Subject extends StatelessWidget {
  final ParticipantInfo initialValue;
  final List<SavedParticipant> savedParticipants;

  const _Subject({
    required this.initialValue,
    required this.savedParticipants,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: ParticipantFormCard(
            ticketTypeName: 'Standard',
            participantIndex: 1,
            totalForType: 1,
            initialValue: initialValue,
            savedParticipants: savedParticipants,
            initiallyExpanded: true,
            onChanged: (_) {},
          ),
        ),
      ),
    );
  }
}
