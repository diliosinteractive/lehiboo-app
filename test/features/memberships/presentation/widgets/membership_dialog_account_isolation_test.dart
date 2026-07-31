import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_session_key_provider.dart';
import 'package:lehiboo/features/memberships/data/datasources/memberships_api_datasource.dart';
import 'package:lehiboo/features/memberships/data/models/invitation_dto.dart';
import 'package:lehiboo/features/memberships/data/models/membership_dto.dart';
import 'package:lehiboo/features/memberships/data/models/personalized_feed_dto.dart';
import 'package:lehiboo/features/memberships/domain/repositories/memberships_repository.dart';
import 'package:lehiboo/features/memberships/presentation/widgets/organizer_join_button.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

final _accountIdProvider = StateProvider<String?>((ref) => 'user-a');

void main() {
  testWidgets(
    'membership confirmation closes on account switch without executing',
    (tester) async {
      final repository = _MembershipsRepository();
      final container = ProviderContainer(
        overrides: [
          authSessionUserIdProvider.overrideWith(
            (ref) => ref.watch(_accountIdProvider),
          ),
          membershipsRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);
      final ownerA = container.read(authSessionKeyProvider);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, _) => TextButton(
                  onPressed: () => confirmAndCancelMembership(
                    context,
                    ref,
                    'org-a',
                    'Organization A',
                    ownerSession: ownerA,
                  ),
                  child: const Text('Open confirmation'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open confirmation'));
      await tester.pumpAndSettle();
      expect(find.text('Cancel request?'), findsOneWidget);

      container.read(_accountIdProvider.notifier).state = 'user-b';
      await tester.pump();
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('Cancel request?'), findsNothing);
      expect(repository.cancelCalls, isEmpty);

      // The old account's still-mounted callback also fails closed if it is
      // invoked before the surrounding list has rebuilt for account B.
      await tester.tap(find.text('Open confirmation'));
      await tester.pump();
      expect(find.text('Cancel request?'), findsNothing);
      expect(repository.cancelCalls, isEmpty);
    },
  );
}

class _MembershipsRepository implements MembershipsRepository {
  final List<String> cancelCalls = [];

  @override
  Future<void> cancelOrLeaveMembership(String organizationIdentifier) async {
    cancelCalls.add(organizationIdentifier);
  }

  @override
  Future<void> acceptInvitation(String token) => throw UnimplementedError();

  @override
  Future<void> declineInvitation(String token) => throw UnimplementedError();

  @override
  Future<List<InvitationDto>> getMyInvitations() => throw UnimplementedError();

  @override
  Future<MembershipsPage> getMyMemberships({
    MembershipStatus? status,
    String? search,
    int page = 1,
    int perPage = 15,
  }) =>
      throw UnimplementedError();

  @override
  Future<PersonalizedFeedDto> getPersonalizedFeed({int limit = 20}) =>
      throw UnimplementedError();

  @override
  Future<PrivateEventsPage> getPrivateEvents({
    String? search,
    String? organizationId,
    int page = 1,
    int perPage = 15,
  }) =>
      throw UnimplementedError();

  @override
  Future<InvitationPreviewDto> peekInvitationAuthed(String token) =>
      throw UnimplementedError();

  @override
  Future<InvitationPreviewDto> peekInvitationPublic(String token) =>
      throw UnimplementedError();

  @override
  Future<MembershipDto> requestMembership(String organizationIdentifier) =>
      throw UnimplementedError();
}
