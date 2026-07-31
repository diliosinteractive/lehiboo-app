import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/l10n/app_locale.dart';
import 'package:lehiboo/core/utils/api_response_handler.dart';
import 'package:lehiboo/l10n/generated/app_localizations_fr.dart';

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
        'The service is temporarily unavailable. Try again in a moment.',
      );
    });

    test('rejects generic exception diagnostics', () {
      final error = Exception(
        'Null check operator used on a null value\n'
        '#0 CheckoutScreen.build (/app/lib/checkout.dart:12:4)',
      );

      expect(
        ApiResponseHandler.extractError(error),
        "We couldn't complete your request. Please try again.",
      );
    });

    test('keeps short safe exception messages', () {
      expect(
        ApiResponseHandler.extractError(Exception('Please choose a date.')),
        'Please choose a date.',
      );
    });

    test('rejects client-generated response and parsing diagnostics', () {
      const fallback = 'Could not load activities. Please try again.';

      for (final diagnostic in [
        'Unexpected data format in events response',
        'Unexpected cancel response',
        'Failed to load events',
        'Failed to save PDF to Downloads',
        'Missing auth field in response payload',
      ]) {
        expect(
          ApiResponseHandler.extractError(
            Exception(diagnostic),
            fallback: fallback,
          ),
          fallback,
          reason: diagnostic,
        );
      }
    });

    test('maps an empty 401 response to an actionable session message', () {
      final requestOptions = RequestOptions(path: '/me');
      final error = DioException(
        requestOptions: requestOptions,
        response: Response<dynamic>(
          requestOptions: requestOptions,
          statusCode: 401,
          data: {'message': 'Unauthenticated.'},
        ),
        type: DioExceptionType.badResponse,
      );

      expect(
        ApiResponseHandler.extractError(error),
        'Your session has expired. Sign in again.',
      );
    });

    test('maps response status when no useful backend message exists', () {
      final expectedByStatus = <int, String>{
        403: "You don't have permission to perform this action.",
        404: 'This item is no longer available. Refresh and try again.',
        408: 'The request took too long. Check your connection and try again.',
        409: 'This information has changed. Refresh and try again.',
        422: 'Some information is invalid. Check it and try again.',
        429: 'Too many attempts. Wait a moment and try again.',
        503: 'The service is temporarily unavailable. Try again in a moment.',
      };

      for (final entry in expectedByStatus.entries) {
        final requestOptions = RequestOptions(path: '/resource');
        final error = DioException(
          requestOptions: requestOptions,
          response: Response<dynamic>(
            requestOptions: requestOptions,
            statusCode: entry.key,
            data: const <String, dynamic>{},
          ),
          type: DioExceptionType.badResponse,
        );

        expect(
          ApiResponseHandler.extractError(error),
          entry.value,
          reason: 'status ${entry.key}',
        );
      }
    });

    test('never exposes a machine-code-only error', () {
      final requestOptions = RequestOptions(path: '/orders');
      final error = DioException(
        requestOptions: requestOptions,
        response: Response<dynamic>(
          requestOptions: requestOptions,
          statusCode: 422,
          data: {'error': 'booking_error'},
        ),
        type: DioExceptionType.badResponse,
      );

      expect(
        ApiResponseHandler.extractError(error),
        'Some information is invalid. Check it and try again.',
      );
      expect(ApiResponseHandler.safeUserMessage('booking_error'), isNull);
    });

    test('maps known machine codes when the response has no human message', () {
      final requestOptions = RequestOptions(path: '/resource');
      final error = DioException(
        requestOptions: requestOptions,
        response: Response<dynamic>(
          requestOptions: requestOptions,
          statusCode: 400,
          data: {'error_code': 'rate_limited'},
        ),
        type: DioExceptionType.badResponse,
      );

      expect(
        ApiResponseHandler.extractError(error),
        'Too many attempts. Wait a moment and try again.',
      );
    });

    test('extracts the first safe nested validation message', () {
      final requestOptions = RequestOptions(path: '/orders');
      final error = DioException(
        requestOptions: requestOptions,
        response: Response<dynamic>(
          requestOptions: requestOptions,
          statusCode: 422,
          data: {
            'errors': {
              'items': {
                '0': {
                  'quantity': ['Choose a smaller quantity.'],
                },
              },
            },
          },
        ),
        type: DioExceptionType.badResponse,
      );

      expect(
        ApiResponseHandler.extractError(error),
        'Choose a smaller quantity.',
      );
    });

    test('uses localized status messages', () {
      AppLocaleCache.setLanguageCode('fr');
      final requestOptions = RequestOptions(path: '/resource');
      final error = DioException(
        requestOptions: requestOptions,
        response: Response<dynamic>(
          requestOptions: requestOptions,
          statusCode: 429,
          data: {'error': 'too_many_requests'},
        ),
        type: DioExceptionType.badResponse,
      );

      expect(
        ApiResponseHandler.extractError(error),
        'Trop de tentatives. Patientez un instant puis réessayez.',
      );
    });

    test('uses explicitly supplied localizations over the cached locale', () {
      final request = RequestOptions(path: '/events/private');
      final error = DioException(
        requestOptions: request,
        response: Response<dynamic>(
          requestOptions: request,
          statusCode: 503,
        ),
        type: DioExceptionType.badResponse,
      );
      final french = AppLocalizationsFr();

      expect(
        ApiResponseHandler.extractError(error, localizations: french),
        french.commonServiceUnavailableError,
      );
    });
  });
}
