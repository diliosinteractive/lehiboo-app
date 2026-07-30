import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/alerts/data/models/alert_dto.dart';

void main() {
  test(
    'AlertDto parses search criteria price decimal strings without truncation',
    () {
      final alert = AlertDto.fromJson({
        'id': 'alert-1',
        'name': 'Decimal prices',
        'created_at': '2026-07-30T12:00:00Z',
        'search_criteria': <String, dynamic>{
          'price_min': '5.5',
          'price_max': '14.3',
        },
      });

      expect(alert.priceMin, 5.5);
      expect(alert.priceMax, 14.3);
      expect(alert.priceMin, isA<double>());
      expect(alert.priceMax, isA<double>());
    },
  );
}
