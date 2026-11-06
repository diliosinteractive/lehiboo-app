import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Changes whenever the authenticated user's membership-based event access
/// may have changed.
///
/// Event providers watch this revision in addition to the auth session so an
/// approval, rejection, revocation, or foreground reconciliation cannot leave
/// member-only content cached for the same signed-in account.
final membershipContentRevisionProvider =
    NotifierProvider<MembershipContentRevisionController, int>(
  MembershipContentRevisionController.new,
);

class MembershipContentRevisionController extends Notifier<int> {
  @override
  int build() => 0;

  void advance() => state++;
}
