import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:lehiboo/core/l10n/app_locale.dart';
import 'package:lehiboo/core/utils/api_response_handler.dart';
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

  group('Stripe failures', () {
    test('maps cancellation without using raw SDK details', () {
      final error = _stripeError(
        FailureCode.Canceled,
        localizedMessage: 'The payment sheet was canceled by the customer',
      );

      expect(
        OrderCheckoutErrorMapper.stripeUserMessage(
          error,
          AppLocalizationsEn(),
        ),
        'Payment was cancelled. You can try again when you are ready.',
      );
    });

    test('maps a failed or declined payment to actionable safe copy', () {
      final error = _stripeError(
        FailureCode.Failed,
        localizedMessage: 'com.stripe.android paymentsheet stack detail',
        declineCode: 'do_not_honor',
      );

      final message = OrderCheckoutErrorMapper.stripeUserMessage(
        error,
        AppLocalizationsEn(),
      );

      expect(message, contains('declined'));
      expect(message, contains('another payment method'));
      expect(message, isNot(contains('com.stripe')));
      expect(message, isNot(contains('do_not_honor')));
    });

    test('distinguishes timeout from an unavailable Stripe setup', () {
      expect(
        OrderCheckoutErrorMapper.stripeUserMessage(
          _stripeError(FailureCode.Timeout),
          AppLocalizationsEn(),
        ),
        contains('timed out'),
      );
      expect(
        OrderCheckoutErrorMapper.stripeUserMessage(
          _stripeError(
            FailureCode.Unknown,
            localizedMessage: 'PaymentSheet has not been initialized',
          ),
          AppLocalizationsEn(),
        ),
        contains('temporarily unavailable'),
      );
    });

    test('maps Stripe configuration exceptions to unavailable copy', () {
      expect(
        OrderCheckoutErrorMapper.userMessage(
          const StripeConfigException('Missing publishable key'),
          AppLocalizationsEn(),
        ),
        contains('temporarily unavailable'),
      );
    });
  });

  group('confirmation after payment', () {
    test('warns against paying twice after a transport failure', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/bookings/draft/confirm'),
        type: DioExceptionType.connectionError,
      );

      final message = OrderCheckoutErrorMapper.userMessage(
        error,
        AppLocalizationsEn(),
        paymentWasCompleted: true,
      );

      expect(message, contains('payment may have succeeded'));
      expect(message, contains('Check My bookings'));
      expect(message, contains('charged twice'));
      expect(
        OrderCheckoutErrorMapper.isConfirmationOutcomeUncertain(error),
        isTrue,
      );
    });

    test('warns after server and validation responses', () {
      final serverError = _dioError(
        {'message': 'Internal server error'},
        statusCode: 503,
      );
      final validationError = _dioError({
        'code': 'ticket_maximum_exceeded',
        'details': {'maximum': 4},
      });

      expect(
        OrderCheckoutErrorMapper.userMessage(
          serverError,
          AppLocalizationsEn(),
          paymentWasCompleted: true,
        ),
        contains('Check My bookings'),
      );
      expect(
        OrderCheckoutErrorMapper.userMessage(
          validationError,
          AppLocalizationsEn(),
          paymentWasCompleted: true,
        ),
        contains('Check My bookings'),
      );
      expect(
        OrderCheckoutErrorMapper.isConfirmationOutcomeUncertain(
          validationError,
        ),
        isTrue,
      );
    });

    test('warns after a malformed successful confirmation response', () {
      const error = ApiFormatException(
        'Confirmation response did not contain a booking.',
      );

      expect(
        OrderCheckoutErrorMapper.userMessage(
          error,
          AppLocalizationsEn(),
          paymentWasCompleted: true,
        ),
        contains('Check My bookings'),
      );
      expect(
        OrderCheckoutErrorMapper.isConfirmationOutcomeUncertain(error),
        isTrue,
      );
    });

    test('warns after a post-payment conflict response', () {
      final error = _dioError(
        {'message': 'Order is already confirmed.'},
        statusCode: 409,
      );

      expect(
        OrderCheckoutErrorMapper.userMessage(
          error,
          AppLocalizationsEn(),
          paymentWasCompleted: true,
        ),
        contains('charged twice'),
      );
    });

    test('uses checkout-specific copy for pre-payment network failures', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/orders'),
        type: DioExceptionType.receiveTimeout,
      );

      expect(
        OrderCheckoutErrorMapper.userMessage(
          error,
          AppLocalizationsEn(),
        ),
        'Checkout timed out. Check your internet connection, then try again.',
      );
    });
  });
}

DioException _dioError(
  Map<String, dynamic> data, {
  int statusCode = 422,
}) {
  final options = RequestOptions(path: '/orders');
  return DioException(
    requestOptions: options,
    response: Response<dynamic>(
      requestOptions: options,
      statusCode: statusCode,
      data: data,
    ),
    type: DioExceptionType.badResponse,
  );
}

StripeException _stripeError(
  FailureCode code, {
  String? localizedMessage,
  String? declineCode,
}) =>
    StripeException(
      error: LocalizedErrorMessage(
        code: code,
        localizedMessage: localizedMessage,
        declineCode: declineCode,
      ),
    );
