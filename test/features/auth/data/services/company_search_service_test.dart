import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lehiboo/features/auth/data/services/company_search_service.dart';

void main() {
  group('CompanySearchService.search', () {
    test('keeps a valid zero-result response distinct from failure', () async {
      final service = CompanySearchService(
        client: MockClient(
          (_) async => http.Response('{"results": []}', 200),
        ),
      );
      addTearDown(service.dispose);

      expect(await service.search('LeHiboo'), isEmpty);
    });

    test('throws a typed service failure for non-success status', () async {
      final service = CompanySearchService(
        client: MockClient((_) async => http.Response('Unavailable', 503)),
      );
      addTearDown(service.dispose);

      await expectLater(
        service.search('LeHiboo'),
        throwsA(
          isA<CompanyLookupException>()
              .having(
                (error) => error.type,
                'type',
                CompanyLookupFailureType.serviceUnavailable,
              )
              .having((error) => error.statusCode, 'statusCode', 503),
        ),
      );
    });

    test('throws a typed decoding failure for malformed JSON', () async {
      final service = CompanySearchService(
        client: MockClient((_) async => http.Response('{not-json', 200)),
      );
      addTearDown(service.dispose);

      await expectLater(
        service.search('LeHiboo'),
        throwsA(
          isA<CompanyLookupException>().having(
            (error) => error.type,
            'type',
            CompanyLookupFailureType.invalidResponse,
          ),
        ),
      );
    });

    test('does not treat a missing results list as zero matches', () async {
      final service = CompanySearchService(
        client: MockClient((_) async => http.Response('{}', 200)),
      );
      addTearDown(service.dispose);

      await expectLater(
        service.search('LeHiboo'),
        throwsA(
          isA<CompanyLookupException>().having(
            (error) => error.type,
            'type',
            CompanyLookupFailureType.invalidResponse,
          ),
        ),
      );
    });

    test('throws a typed timeout instead of returning no matches', () async {
      final service = CompanySearchService(
        client: MockClient((_) async => throw TimeoutException('timeout')),
      );
      addTearDown(service.dispose);

      await expectLater(
        service.search('LeHiboo'),
        throwsA(
          isA<CompanyLookupException>().having(
            (error) => error.type,
            'type',
            CompanyLookupFailureType.timeout,
          ),
        ),
      );
    });
  });

  group('CompanySearchService.getBySiret', () {
    test('keeps an invalid local SIRET as a valid no-match result', () async {
      final service = CompanySearchService(
        client: MockClient((_) async => http.Response('', 500)),
      );
      addTearDown(service.dispose);

      expect(await service.getBySiret('123'), isNull);
    });

    test('throws a typed network failure instead of returning null', () async {
      final service = CompanySearchService(
        client: MockClient(
          (_) async => throw http.ClientException('connection failed'),
        ),
      );
      addTearDown(service.dispose);

      await expectLater(
        service.getBySiret('12345678901234'),
        throwsA(
          isA<CompanyLookupException>().having(
            (error) => error.type,
            'type',
            CompanyLookupFailureType.network,
          ),
        ),
      );
    });
  });
}
