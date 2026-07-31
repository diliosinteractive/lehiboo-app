import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/l10n/app_locale.dart';
import 'package:lehiboo/features/booking/presentation/utils/order_checkout_error_mapper.dart';
import 'package:lehiboo/l10n/generated/app_localizations_en.dart';
import 'package:lehiboo/l10n/generated/app_localizations_fr.dart';

void main() {
  setUp(() => AppLocaleCache.setLanguageCode('en'));

  test('localizes the legacy misleading stock envelope', () {
    final error = _dioError({
      'message':
          'Stock insuffisant. Demande: 1, Disponible: 9223372036854775807.',
      'error': 'booking_error',
    });

    expect(
      OrderCheckoutErrorMapper.userMessage(
        error,
        AppLocalizationsFr(),
      ),
      contains("Un billet n'est plus disponible"),
    );
    expect(OrderCheckoutErrorMapper.isExpectedValidation(error), isTrue);
  });

  test('uses structured minimum details instead of the server message', () {
    final error = _dioError({
      'message': 'Quantity is invalid.',
      'error': 'booking_error',
      'code': 'ticket_minimum_not_met',
      'details': {'minimum': 5},
    });

    expect(
      OrderCheckoutErrorMapper.userMessage(
        error,
        AppLocalizationsEn(),
      ),
      'Select at least 5 tickets of this type.',
    );
  });

  test('falls back to the central API error handler for unrelated errors', () {
    final error = _dioError({
      'message': 'The promo code is invalid.',
      'error': 'booking_error',
    });

    expect(
      OrderCheckoutErrorMapper.userMessage(
        error,
        AppLocalizationsEn(),
      ),
      'The promo code is invalid.',
    );
    expect(OrderCheckoutErrorMapper.isExpectedValidation(error), isFalse);
  });
}

DioException _dioError(Map<String, dynamic> data) {
  final options = RequestOptions(path: '/orders');
  return DioException(
    requestOptions: options,
    response: Response<dynamic>(
      requestOptions: options,
      statusCode: 422,
      data: data,
    ),
    type: DioExceptionType.badResponse,
  );
}
