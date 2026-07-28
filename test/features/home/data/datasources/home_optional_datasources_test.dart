import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/utils/api_response_handler.dart';
import 'package:lehiboo/features/home/data/datasources/hero_slides_api_datasource.dart';
import 'package:lehiboo/features/home/data/datasources/mobile_config_datasource.dart';
import 'package:lehiboo/features/memberships/data/datasources/memberships_api_datasource.dart';

void main() {
  group('optional Home datasources', () {
    test('hero slides propagate request failures to presentation state',
        () async {
      final dio = _dioRejectingRequests();

      await expectLater(
        HeroSlidesApiDataSource(dio).getHeroSlides(),
        throwsA(isA<DioException>()),
      );
    });

    test('mobile config propagates request failures to presentation state',
        () async {
      final dio = _dioRejectingRequests();

      await expectLater(
        MobileConfigDataSource(dio).getConfig(),
        throwsA(isA<DioException>()),
      );
    });

    test('personalized feed rejects a malformed data payload', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.resolve(
              Response<Map<String, dynamic>>(
                requestOptions: options,
                statusCode: 200,
                data: <String, dynamic>{
                  'data': <dynamic>[],
                },
              ),
            );
          },
        ),
      );

      await expectLater(
        MembershipsApiDataSource(dio).getPersonalizedFeed(),
        throwsA(isA<ApiFormatException>()),
      );
    });
  });
}

Dio _dioRejectingRequests() {
  final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        handler.reject(
          DioException(
            requestOptions: options,
            type: DioExceptionType.connectionError,
            message: 'offline',
          ),
        );
      },
    ),
  );
  return dio;
}
