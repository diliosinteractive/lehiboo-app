import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/config/dio_client.dart';

void main() {
  group('maskAuthTokenForDebugLog', () {
    test('masks short tokens completely', () {
      expect(maskAuthTokenForDebugLog('abcd1234'), '***');
      expect(maskAuthTokenForDebugLog('short'), '***');
    });

    test('keeps only the first and last four characters for longer tokens', () {
      expect(
        maskAuthTokenForDebugLog('abcdefghijklmnopqrstuvwxyz'),
        'abcd...wxyz',
      );
    });
  });
}
