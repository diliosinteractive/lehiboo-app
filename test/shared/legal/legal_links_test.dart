import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/shared/legal/legal_links.dart';

void main() {
  test('uses the merged CGUV document as the canonical terms page', () {
    expect(
      LegalDocument.values.map((document) => document.slug),
      ['cguv', 'privacy', 'cookies', 'mentions-legales'],
    );
  });
}
