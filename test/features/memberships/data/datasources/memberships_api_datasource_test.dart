import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/memberships/data/datasources/memberships_api_datasource.dart';

void main() {
  test('customer memberships use the adherences-only endpoint', () async {
    late RequestOptions request;
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          request = options;
          handler.resolve(
            Response<Map<String, dynamic>>(
              requestOptions: options,
              statusCode: 200,
              data: const {
                'data': <Map<String, dynamic>>[],
                'meta': {
                  'total': 0,
                  'page': 1,
                  'per_page': 20,
                  'last_page': 1,
                },
              },
            ),
          );
        },
      ),
    );

    await MembershipsApiDataSource(dio).getMyMemberships();

    expect(request.path, '/me/memberships');
  });
}
