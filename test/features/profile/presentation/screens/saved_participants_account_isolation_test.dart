import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/profile/data/datasources/saved_participants_api_datasource.dart';
import 'package:lehiboo/features/profile/domain/models/saved_participant.dart';
import 'package:lehiboo/features/profile/presentation/screens/saved_participants_screen.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

final _accountIdProvider = StateProvider<String?>((ref) => 'account-a');

const _accountAParticipant = SavedParticipant(
  uuid: 'participant-a',
  label: 'Account A child',
  relationship: 'child',
  displayName: 'Account A child',
  firstName: 'Alice',
  lastName: 'Account A',
  email: 'alice-a@example.test',
  phone: '+237600000001',
  birthDate: '2015-01-02',
  membershipCity: 'Private City A',
);

void main() {
  testWidgets(
    'account switch closes an edit draft and never sends account-A PII',
    (tester) async {
      tester.view.physicalSize = const Size(900, 1400);
      tester.view.devicePixelRatio = 1;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final api = _RecordingSavedParticipantsApi();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authSessionUserIdProvider.overrideWith(
              (ref) => ref.watch(_accountIdProvider),
            ),
            savedParticipantsApiDataSourceProvider.overrideWithValue(api),
          ],
          child: const MaterialApp(
            locale: Locale('en'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: SavedParticipantsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Account A child'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.edit_outlined));
      await tester.pumpAndSettle();

      expect(find.text('alice-a@example.test'), findsOneWidget);
      expect(find.text('Private City A'), findsOneWidget);

      final container = ProviderScope.containerOf(
        tester.element(find.byType(SavedParticipantsScreen)),
      );
      container.read(_accountIdProvider.notifier).state = 'account-b';
      await tester.pumpAndSettle();

      expect(find.text('Account A child'), findsNothing);
      expect(find.text('alice-a@example.test'), findsNothing);
      expect(find.text('Private City A'), findsNothing);
      expect(find.text('Save'), findsNothing);
      expect(api.updateCalls, isEmpty);
      expect(api.createCalls, isEmpty);
    },
  );
}

class _RecordingSavedParticipantsApi extends SavedParticipantsApiDataSource {
  _RecordingSavedParticipantsApi() : super(Dio());

  final List<SavedParticipant> createCalls = [];
  final List<SavedParticipant> updateCalls = [];

  @override
  Future<List<SavedParticipant>> list() async => [_accountAParticipant];

  @override
  Future<SavedParticipant> create(SavedParticipant participant) async {
    createCalls.add(participant);
    return participant;
  }

  @override
  Future<SavedParticipant> update(SavedParticipant participant) async {
    updateCalls.add(participant);
    return participant;
  }

  @override
  Future<void> delete(String uuid) async {}
}
