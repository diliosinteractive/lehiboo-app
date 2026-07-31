import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/utils/api_response_handler.dart';
import 'package:lehiboo/features/reviews/data/datasources/reviews_api_datasource.dart';

void main() {
  group('ReviewsApiDataSource lists', () {
    test('accepts an explicit empty event-review list', () async {
      final dataSource = ReviewsApiDataSource(
        _dioResolving(<String, dynamic>{
          'data': <dynamic>[],
          'meta': <String, dynamic>{
            'current_page': 1,
            'last_page': 1,
            'per_page': 10,
            'total': 0,
          },
        }),
      );

      final result = await dataSource.getEventReviews('event');

      expect(result.data, isEmpty);
      expect(result.meta?.total, 0);
    });

    test('throws when the event-review list is missing', () async {
      final dataSource = ReviewsApiDataSource(
        _dioResolving(<String, dynamic>{'message': 'Success'}),
      );

      await expectLater(
        dataSource.getEventReviews('event'),
        throwsA(isA<ApiFormatException>()),
      );
    });

    test('accepts an explicit empty user-review list', () async {
      final dataSource = ReviewsApiDataSource(
        _dioResolving(<String, dynamic>{'data': <dynamic>[]}),
      );

      final result = await dataSource.getUserReviews();

      expect(result.data, isEmpty);
    });

    test('throws when the user-review list has an invalid shape', () async {
      final dataSource = ReviewsApiDataSource(
        _dioResolving(<String, dynamic>{
          'data': <String, dynamic>{'reviews': <dynamic>[]},
        }),
      );

      await expectLater(
        dataSource.getUserReviews(),
        throwsA(isA<ApiFormatException>()),
      );
    });
  });

  group('ReviewsApiDataSource stats', () {
    test('accepts explicit zero statistics', () async {
      final dataSource = ReviewsApiDataSource(
        _dioResolving(_zeroStats),
      );

      final result = await dataSource.getEventReviewStats('event');

      expect(result.totalReviewsCamel, 0);
      expect(result.averageRatingCamel, 0);
      expect(result.verifiedCountCamel, 0);
      expect(result.distribution, isEmpty);
      expect(result.percentages, isEmpty);
    });

    test('throws when required statistics are missing', () async {
      final dataSource = ReviewsApiDataSource(
        _dioResolving(<String, dynamic>{
          'totalReviews': 0,
          'averageRating': 0,
        }),
      );

      await expectLater(
        dataSource.getEventReviewStats('event'),
        throwsA(isA<ApiFormatException>()),
      );
    });

    test('throws when a statistic has an invalid value', () async {
      final dataSource = ReviewsApiDataSource(
        _dioResolving(<String, dynamic>{
          ..._zeroStats,
          'averageRating': 'not-a-rating',
        }),
      );

      await expectLater(
        dataSource.getEventReviewStats('event'),
        throwsA(isA<ApiFormatException>()),
      );
    });
  });

  group('ReviewsApiDataSource counts', () {
    test('accepts an explicit zero pending count', () async {
      final dataSource = ReviewsApiDataSource(
        _dioResolving(<String, dynamic>{'count': 0, 'pendingCount': 0}),
      );

      expect(await dataSource.getPendingCount(), 0);
    });

    test('throws when the pending count is missing', () async {
      final dataSource = ReviewsApiDataSource(
        _dioResolving(<String, dynamic>{'message': 'Success'}),
      );

      await expectLater(
        dataSource.getPendingCount(),
        throwsA(isA<ApiFormatException>()),
      );
    });

    test('accepts explicit zero vote counts', () async {
      final dataSource = ReviewsApiDataSource(
        _dioResolving(<String, dynamic>{
          'message': 'Vote recorded',
          'helpful_count': 0,
          'not_helpful_count': 0,
        }),
      );

      final result = await dataSource.voteReview(
        'review',
        isHelpful: true,
      );

      expect(result.helpfulCount, 0);
      expect(result.notHelpfulCount, 0);
    });

    test('throws when a required vote count is missing', () async {
      final dataSource = ReviewsApiDataSource(
        _dioResolving(<String, dynamic>{'helpful_count': 0}),
      );

      await expectLater(
        dataSource.unvoteReview('review'),
        throwsA(isA<ApiFormatException>()),
      );
    });
  });
}

const _zeroStats = <String, dynamic>{
  'totalReviews': 0,
  'averageRating': 0,
  'verifiedCount': 0,
  'distribution': <String, dynamic>{},
  'percentages': <String, dynamic>{},
};

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
