import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/utils/api_response_handler.dart';
import 'package:lehiboo/features/events/data/datasources/event_social_api_datasource.dart';

void main() {
  group('EventSocialApiDataSource.getEventQuestions', () {
    test('accepts an explicit empty question list', () async {
      final dataSource = EventSocialApiDataSource(
        _dioResolving(
          statusCode: 200,
          data: <String, dynamic>{
            'data': <dynamic>[],
            'meta': <String, dynamic>{
              'current_page': 1,
              'last_page': 1,
              'per_page': 15,
              'total': 0,
            },
          },
        ),
      );

      final result = await dataSource.getEventQuestions('event');

      expect(result.data, isEmpty);
      expect(result.meta?.total, 0);
    });

    test('throws ApiFormatException when the question list is missing',
        () async {
      final dataSource = EventSocialApiDataSource(
        _dioResolving(
          statusCode: 200,
          data: <String, dynamic>{'message': 'Success'},
        ),
      );

      await expectLater(
        dataSource.getEventQuestions('event'),
        throwsA(isA<ApiFormatException>()),
      );
    });

    test('throws ApiFormatException for an invalid question item', () async {
      final dataSource = EventSocialApiDataSource(
        _dioResolving(
          statusCode: 200,
          data: <String, dynamic>{
            'data': <dynamic>[
              <String, dynamic>{'question': 'Missing UUID'},
            ],
          },
        ),
      );

      await expectLater(
        dataSource.getEventQuestions('event'),
        throwsA(isA<ApiFormatException>()),
      );
    });
  });

  group('EventSocialApiDataSource helpful counts', () {
    test('accepts an explicit zero count', () async {
      final dataSource = EventSocialApiDataSource(
        _dioResolving(
          statusCode: 200,
          data: <String, dynamic>{
            'message': 'Vote removed',
            'helpful_count': 0,
          },
        ),
      );

      expect(await dataSource.unmarkQuestionHelpful('question'), 0);
    });

    test('throws ApiFormatException when the count is missing', () async {
      final dataSource = EventSocialApiDataSource(
        _dioResolving(
          statusCode: 200,
          data: <String, dynamic>{'message': 'Vote recorded'},
        ),
      );

      await expectLater(
        dataSource.markQuestionHelpful('question'),
        throwsA(isA<ApiFormatException>()),
      );
    });

    test('throws ApiFormatException when the count is invalid', () async {
      final dataSource = EventSocialApiDataSource(
        _dioResolving(
          statusCode: 200,
          data: <String, dynamic>{'helpful_count': 'not-a-count'},
        ),
      );

      await expectLater(
        dataSource.markQuestionHelpful('question'),
        throwsA(isA<ApiFormatException>()),
      );
    });
  });

  group('EventSocialApiDataSource.getMyQuestion', () {
    test('returns null for the documented 200 data-null response', () async {
      final dataSource = EventSocialApiDataSource(
        _dioResolving(
          statusCode: 200,
          data: <String, dynamic>{'data': null},
        ),
      );

      expect(await dataSource.getMyQuestion('event'), isNull);
    });

    test('returns null for a 204 missing-question response', () async {
      final dataSource = EventSocialApiDataSource(
        _dioResolving(statusCode: 204),
      );

      expect(await dataSource.getMyQuestion('event'), isNull);
    });

    test('returns null for a 404 missing-question failure', () async {
      final dataSource = EventSocialApiDataSource(
        _dioRejecting(statusCode: 404),
      );

      expect(await dataSource.getMyQuestion('event'), isNull);
    });

    test('parses a successful question response', () async {
      final dataSource = EventSocialApiDataSource(
        _dioResolving(
          statusCode: 200,
          data: <String, dynamic>{
            'data': <String, dynamic>{
              'uuid': 'question-1',
              'question': 'Is parking available?',
              'status': 'pending',
            },
          },
        ),
      );

      final question = await dataSource.getMyQuestion('event');

      expect(question, isNotNull);
      expect(question!.uuid, 'question-1');
      expect(question.question, 'Is parking available?');
    });

    test('rethrows non-missing HTTP failures', () async {
      final failure = DioException(
        requestOptions: RequestOptions(path: '/events/event/my-question'),
        response: Response<dynamic>(
          requestOptions: RequestOptions(
            path: '/events/event/my-question',
          ),
          statusCode: 500,
          data: <String, dynamic>{'message': 'Server failure'},
        ),
        type: DioExceptionType.badResponse,
      );
      final dataSource =
          EventSocialApiDataSource(_dioRejecting(error: failure));

      await expectLater(
        dataSource.getMyQuestion('event'),
        throwsA(same(failure)),
      );
    });

    test('throws ApiFormatException for a malformed success payload', () async {
      final dataSource = EventSocialApiDataSource(
        _dioResolving(
          statusCode: 200,
          data: <String, dynamic>{'message': 'Success without data'},
        ),
      );

      await expectLater(
        dataSource.getMyQuestion('event'),
        throwsA(isA<ApiFormatException>()),
      );
    });
  });
}

Dio _dioResolving({required int statusCode, dynamic data}) {
  final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        handler.resolve(
          Response<dynamic>(
            requestOptions: options,
            statusCode: statusCode,
            data: data,
          ),
        );
      },
    ),
  );
  return dio;
}

Dio _dioRejecting({int? statusCode, DioException? error}) {
  final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        handler.reject(
          error ??
              DioException(
                requestOptions: options,
                response: Response<dynamic>(
                  requestOptions: options,
                  statusCode: statusCode,
                ),
                type: DioExceptionType.badResponse,
              ),
        );
      },
    ),
  );
  return dio;
}
