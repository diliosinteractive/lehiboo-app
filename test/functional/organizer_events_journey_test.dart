import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_session_key_provider.dart';
import 'package:lehiboo/features/partners/data/datasources/organizer_api_datasource.dart';
import 'package:lehiboo/features/partners/data/repositories/organizer_repository_impl.dart';
import 'package:lehiboo/features/partners/domain/repositories/organizer_repository.dart';
import 'package:lehiboo/features/partners/presentation/widgets/organizer_activities_tab.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

void main() {
  testWidgets('organizer API events are separated into current and past tabs', (
    tester,
  ) async {
    final capturedRequest =
        await _pumpOrganizerTab(tester, [_futurePrivateEvent, _pastEvent]);

    expect(capturedRequest.path, '/organizers/org-pro/events');
    expect(capturedRequest.queryParameters, {'page': 1, 'per_page': 12});
    expect(find.text('En cours (1)'), findsOneWidget);
    expect(find.text('Passés (1)'), findsOneWidget);
    expect(find.text('Événement privé futur'), findsOneWidget);
    expect(find.text('Événement terminé'), findsNothing);

    await tester.tap(find.text('Passés (1)'));
    await tester.pumpAndSettle();

    expect(find.text('Événement privé futur'), findsNothing);
    expect(find.text('Événement terminé'), findsOneWidget);
  });

  testWidgets('an organizer event with no date at all is left out', (
    tester,
  ) async {
    await _pumpOrganizerTab(tester, [_futurePrivateEvent, _undatedEvent]);

    expect(find.text('En cours (1)'), findsOneWidget);
    expect(find.text('Passés (0)'), findsOneWidget);
    expect(find.text('Événement sans date'), findsNothing);
  });
}

const _undatedEvent = <String, dynamic>{
  'id': 3,
  'uuid': 'undated-event',
  'slug': 'undated-event',
  'title': 'Événement sans date',
  'booking_mode': 'discovery',
  'dates': null,
  'slots': <Object>[],
};

Future<RequestOptions> _pumpOrganizerTab(
  WidgetTester tester,
  List<Map<String, dynamic>> events,
) async {
  late RequestOptions capturedRequest;
  final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
  addTearDown(() => dio.close(force: true));
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        capturedRequest = options;
        handler.resolve(
          Response<Map<String, dynamic>>(
            requestOptions: options,
            statusCode: 200,
            data: {
              'success': true,
              'data': events,
              'meta': {
                'page': 1,
                'per_page': 12,
                'total': events.length,
                'last_page': 1
              },
            },
          ),
        );
      },
    ),
  );
  final repository = OrganizerRepositoryImpl(OrganizerApiDataSource(dio));

  tester.view.physicalSize = const Size(1080, 1920);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authSessionUserIdProvider.overrideWithValue('member-1'),
        organizerRepositoryProvider.overrideWithValue(repository),
      ],
      child: MaterialApp(
        locale: const Locale('fr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Consumer(
          builder: (context, ref, _) => Scaffold(
            body: OrganizerActivitiesTab(
              organizerIdentifier: 'org-pro',
              ownerSession: ref.watch(authSessionKeyProvider),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return capturedRequest;
}

const _futurePrivateEvent = <String, dynamic>{
  'id': 1,
  'uuid': 'private-future',
  'slug': 'private-future',
  'title': 'Événement privé futur',
  'visibility': 'private',
  'is_members_only': true,
  'booking_mode': 'booking',
  'dates': {
    'start_date': '2099-09-08',
    'end_date': '2099-09-08',
    'start_time': '18:00:00',
    'end_time': '20:00:00',
  },
  'slots': [
    {
      'uuid': 'slot-future',
      'date': '2099-09-08',
      'start_time': '18:00:00',
      'end_time': '20:00:00',
    },
  ],
};

const _pastEvent = <String, dynamic>{
  'id': 2,
  'uuid': 'past-event',
  'slug': 'past-event',
  'title': 'Événement terminé',
  'booking_mode': 'booking',
  'dates': {
    'start_date': '2000-01-01',
    'end_date': '2000-01-01',
    'start_time': '10:00:00',
    'end_time': '12:00:00',
  },
  'slots': [
    {
      'uuid': 'slot-past',
      'date': '2000-01-01',
      'start_time': '10:00:00',
      'end_time': '12:00:00',
    },
  ],
};
