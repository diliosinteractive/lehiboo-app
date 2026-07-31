import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/utils/api_response_handler.dart';
import 'package:lehiboo/features/user_questions/data/datasources/user_questions_api_datasource.dart';

void main() {
  group('UserQuestionsApiDataSource.getMyQuestions', () {
    test('accepts an explicit empty paginated list', () async {
      final dataSource = UserQuestionsApiDataSource(
        _dioResolving(<String, dynamic>{
          'data': <dynamic>[],
          'meta': <String, dynamic>{
            'current_page': 1,
            'last_page': 1,
            'per_page': 15,
            'total': 0,
          },
        }),
      );

      final result = await dataSource.getMyQuestions();

      expect(result.data, isEmpty);
      expect(result.meta?.total, 0);
    });

    test('throws ApiFormatException when the required list is missing',
        () async {
      final dataSource = UserQuestionsApiDataSource(
        _dioResolving(<String, dynamic>{'message': 'Success'}),
      );

      await expectLater(
        dataSource.getMyQuestions(),
        throwsA(isA<ApiFormatException>()),
      );
    });

    test('throws ApiFormatException for malformed pagination metadata',
        () async {
      final dataSource = UserQuestionsApiDataSource(
        _dioResolving(<String, dynamic>{
          'data': <dynamic>[],
          'meta': 'not-a-map',
        }),
      );

      await expectLater(
        dataSource.getMyQuestions(),
        throwsA(isA<ApiFormatException>()),
      );
    });
  });
}

Dio _dioResolving(dynamic data) {
  final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        handler.resolve(
          Response<dynamic>(
            requestOptions: options,
            statusCode: 200,
            data: data,
          ),
        );
      },
    ),
  );
  return dio;
}
