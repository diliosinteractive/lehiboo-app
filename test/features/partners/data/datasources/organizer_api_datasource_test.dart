import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/partners/data/datasources/organizer_api_datasource.dart';

void main() {
  test('organizer directory requests verified vendors only', () async {
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
                  'current_page': 1,
                  'per_page': 20,
                  'total': 0,
                  'last_page': 1,
                },
              },
            ),
          );
        },
      ),
    );

    await OrganizerApiDataSource(dio).getOrganizers();

    expect(request.path, '/organizers');
    expect(request.queryParameters, containsPair('type', 'vendor'));
  });
}
