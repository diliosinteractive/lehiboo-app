import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/events/data/datasources/events_api_datasource.dart';
import 'package:lehiboo/features/events/data/repositories/event_repository_impl.dart';

EventRepositoryImpl _repositoryAnswering(Map<String, dynamic> body) {
  final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) => handler.resolve(
        Response<Map<String, dynamic>>(
          requestOptions: options,
          statusCode: 200,
          data: body,
        ),
      ),
    ),
  );
  return EventRepositoryImpl(EventsApiDataSource(dio));
}

void main() {
  test('event lists drop the events with no date at all', () async {
    final repository = _repositoryAnswering({
      'success': true,
      'data': [
        {
          'id': 1,
          'uuid': 'dated',
          'slug': 'dated',
          'title': 'Dated',
          'dates': {'start_date': '2026-11-24', 'start_time': '18:00:00'},
        },
        // What /events sends for an event whose slots are not loaded: the
        // app used to date it "now".
        {
          'id': 2,
          'uuid': 'undated',
          'slug': 'undated',
          'title': 'Undated',
          'dates': null,
          'slots': <Object>[],
        },
      ],
      'meta': {'current_page': 1, 'last_page': 1, 'total': 2},
    });

    final result = await repository.getEvents();

    expect(result.events.map((event) => event.slug), ['dated']);
  });

  test('map pins keep their events, which carry no dates', () async {
    final repository = _repositoryAnswering(<String, dynamic>{
      'success': true,
      'data': <String, dynamic>{
        'pins': <Map<String, dynamic>>[
          <String, dynamic>{'id': 1, 'title': 'Pin', 'lat': 50.45, 'lng': 3.95},
        ],
      },
    });

    final result = await repository.getEvents(lightweight: true);

    expect(result.events, hasLength(1));
  });
}
