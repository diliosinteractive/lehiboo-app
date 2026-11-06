import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/memberships/data/models/invitation_dto.dart';

void main() {
  test('management roles are separated from customer adherence invitations',
      () {
    for (final role in ['owner', 'admin', 'manager', 'staff']) {
      expect(
        invitationAccessKindForRole(role),
        InvitationAccessKind.management,
        reason: '$role should open the managed-organization handoff',
      );
    }

    for (final role in ['viewer', null, 'future-role']) {
      expect(
        invitationAccessKindForRole(role),
        InvitationAccessKind.adherence,
        reason: '$role must fail closed to the customer membership flow',
      );
    }
  });
}
