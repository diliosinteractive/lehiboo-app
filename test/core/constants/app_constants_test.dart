import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/constants/app_constants.dart';

void main() {
  group('AppConstants.isValidEmail', () {
    test('accepts plus aliases after the first local-part character', () {
      for (final email in [
        'example+example@domain.com',
        'Pauline+ado@dilios.fr',
        'name+one+two@sub.domain.travel',
      ]) {
        expect(AppConstants.isValidEmail(email), isTrue, reason: email);
      }
    });

    test('rejects a plus at the start of the local part', () {
      for (final email in [
        '+example@domain.com',
        '+@domain.com',
      ]) {
        expect(AppConstants.isValidEmail(email), isFalse, reason: email);
      }
    });

    test('keeps ordinary emails valid and rejects malformed addresses', () {
      expect(AppConstants.isValidEmail('person@example.com'), isTrue);
      expect(AppConstants.isValidEmail(' person@example.com '), isTrue);

      for (final email in [
        '',
        'person',
        'person@domain',
        'person domain@example.com',
      ]) {
        expect(AppConstants.isValidEmail(email), isFalse, reason: email);
      }
    });
  });
}
