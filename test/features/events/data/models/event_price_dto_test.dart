import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/events/data/models/event_dto.dart';

void main() {
  test('EventPriceDto parses decimal min and max strings without truncation',
      () {
    final price = EventPriceDto.fromJson({
      'is_free': false,
      'min': '5.5',
      'max': '14.3',
      'currency': 'EUR',
    });

    expect(price.min, 5.5);
    expect(price.max, 14.3);
    expect(price.min, isA<double>());
    expect(price.max, isA<double>());
  });
}
