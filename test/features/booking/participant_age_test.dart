import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/booking/domain/extensions/user_participant_extension.dart';
import 'package:lehiboo/features/profile/domain/models/saved_participant.dart';

/// The app sends a participant's birth date, as the web does, and no longer
/// derives an age from it (November 2026 backend spec, §3).
void main() {
  test('the account holder is prefilled with a birth date and no age', () {
    final participant = HbUser(
      id: '1',
      email: 'alice@example.test',
      displayName: 'Alice',
      birthDate: DateTime(1990, 4, 21),
    ).toParticipantInfo();

    expect(participant.birthDate, '1990-04-21');
    expect(participant.age, isNull);
  });

  test('a saved participant is prefilled with a birth date and no age', () {
    const saved = SavedParticipant(
      uuid: 'saved-1',
      displayName: 'Leo',
      firstName: 'Leo',
      lastName: 'Martin',
      birthDate: '2018-06-02',
    );

    final participant = saved.toParticipantInfo();
    expect(participant.birthDate, '2018-06-02');
    expect(participant.age, isNull);
  });
}
