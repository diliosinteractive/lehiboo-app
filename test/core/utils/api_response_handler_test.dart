import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/l10n/app_locale.dart';
import 'package:lehiboo/core/utils/api_response_handler.dart';

void main() {
  setUp(() {
    AppLocaleCache.setLanguageCode('en');
  });

  group('ApiResponseHandler.extractError', () {
    test('maps Dio transport errors to the localized connection message', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/events'),
        type: DioExceptionType.connectionError,
        error: 'SocketException: Failed host lookup',
      );

      expect(
        ApiResponseHandler.extractError(error),
        'Connection error. Check your internet connection.',
      );
    });

    test('keeps normal backend validation messages', () {
      final requestOptions = RequestOptions(path: '/auth/register');
      final error = DioException(
        requestOptions: requestOptions,
        response: Response<dynamic>(
          requestOptions: requestOptions,
          statusCode: 422,
          data: {
            'error': {
              'details': {
                'email': ['Email is required.'],
              },
            },
          },
        ),
        type: DioExceptionType.badResponse,
      );

      expect(ApiResponseHandler.extractError(error), 'Email is required.');
    });

    test('prefers a human message over a top-level machine error code', () {
      final requestOptions = RequestOptions(path: '/orders');
      final error = DioException(
        requestOptions: requestOptions,
        response: Response<dynamic>(
          requestOptions: requestOptions,
          statusCode: 422,
          data: {
            'message':
                'Stock insuffisant. Demande: 1, Disponible: 9223372036854775807.',
            'error': 'booking_error',
          },
        ),
        type: DioExceptionType.badResponse,
      );

      expect(
        ApiResponseHandler.extractError(error),
        'Stock insuffisant. Demande: 1, Disponible: 9223372036854775807.',
      );
    });

    test('keeps a simple error string when no human message is provided', () {
      final requestOptions = RequestOptions(path: '/events');
      final error = DioException(
        requestOptions: requestOptions,
        response: Response<dynamic>(
          requestOptions: requestOptions,
          statusCode: 404,
          data: {'error': 'Event not found.'},
        ),
        type: DioExceptionType.badResponse,
      );

      expect(ApiResponseHandler.extractError(error), 'Event not found.');
    });

    test('extracts the first standard Laravel validation error', () {
      final requestOptions = RequestOptions(path: '/orders');
      final error = DioException(
        requestOptions: requestOptions,
        response: Response<dynamic>(
          requestOptions: requestOptions,
          statusCode: 422,
          data: {
            'message': 'The given data was invalid.',
            'errors': {
              'items.0.quantity': ['Quantity must be at least 1.'],
            },
          },
        ),
        type: DioExceptionType.badResponse,
      );

      expect(
        ApiResponseHandler.extractError(error),
        'Quantity must be at least 1.',
      );
    });

    test('rejects backend traceback strings', () {
      final requestOptions = RequestOptions(path: '/events');
      final error = DioException(
        requestOptions: requestOptions,
        response: Response<dynamic>(
          requestOptions: requestOptions,
          statusCode: 500,
          data: {
            'message': 'Traceback (most recent call last):\n'
                '#0 EventController.index (/app/lib/controller.dart:42:13)',
          },
        ),
        type: DioExceptionType.badResponse,
      );

      expect(
        ApiResponseHandler.extractError(error),
        'Something went wrong. Please try again.',
      );
    });

    test('rejects generic exception diagnostics', () {
      final error = Exception(
        'Null check operator used on a null value\n'
        '#0 CheckoutScreen.build (/app/lib/checkout.dart:12:4)',
      );

      expect(
        ApiResponseHandler.extractError(error),
        'Something went wrong. Please try again.',
      );
    });

    test('keeps short safe exception messages', () {
      expect(
        ApiResponseHandler.extractError(Exception('Please choose a date.')),
        'Please choose a date.',
      );
    });
  });
}
