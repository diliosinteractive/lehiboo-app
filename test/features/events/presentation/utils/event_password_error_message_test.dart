import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/utils/api_response_handler.dart';
import 'package:lehiboo/features/events/presentation/utils/event_password_error_message.dart';
import 'package:lehiboo/l10n/generated/app_localizations_en.dart';

void main() {
  final l10n = AppLocalizationsEn();

  test('labels transport failures as network errors', () {
    final error = DioException(
      requestOptions: RequestOptions(path: '/events/private'),
      type: DioExceptionType.connectionError,
    );

    expect(
        eventPasswordErrorMessage(l10n, error), l10n.eventPasswordNetworkError);
  });

  test('uses an action-specific fallback for malformed responses', () {
    const error = ApiFormatException('Unexpected private event payload');

    expect(
        eventPasswordErrorMessage(l10n, error), l10n.eventPasswordCheckFailed);
  });

  test('does not call a server outage a network error', () {
    final request = RequestOptions(path: '/events/private');
    final error = DioException(
      requestOptions: request,
      response: Response<dynamic>(requestOptions: request, statusCode: 503),
      type: DioExceptionType.badResponse,
    );

    final message = eventPasswordErrorMessage(l10n, error);

    expect(message, l10n.commonServiceUnavailableError);
    expect(message, isNot(l10n.eventPasswordNetworkError));
  });
}
