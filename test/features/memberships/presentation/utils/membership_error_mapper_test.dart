import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/l10n/app_locale.dart';
import 'package:lehiboo/features/memberships/presentation/utils/membership_error_mapper.dart';

void main() {
  setUp(() {
    AppLocaleCache.setLanguageCode('en');
  });

  group('MembershipErrorMapper.actionMessage', () {
    test('preserves a safe backend validation message', () {
      final error = _responseError(
        statusCode: 422,
        data: {'message': 'This membership request is already pending.'},
      );

      expect(
        MembershipErrorMapper.actionMessage(
          error,
          fallback: 'Could not send the request.',
        ),
        'This membership request is already pending.',
      );
    });

    test('replaces a machine code with the action-specific fallback', () {
      final error = _responseError(
        statusCode: 422,
        data: {'error': 'membership_request_failed'},
      );

      expect(
        MembershipErrorMapper.actionMessage(
          error,
          fallback: 'Could not send the request.',
        ),
        'Could not send the request.',
      );
    });

    test('maps a transport failure to the localized connection message', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/memberships'),
        type: DioExceptionType.connectionError,
      );

      expect(
        MembershipErrorMapper.actionMessage(
          error,
          fallback: 'Could not send the request.',
        ),
        'Connection error. Check your internet connection.',
      );
    });
  });

  group('MembershipErrorMapper.invitationPreviewKind', () {
    test('treats only 404 and 410 responses as missing invitations', () {
      expect(
        MembershipErrorMapper.invitationPreviewKind(
          _responseError(statusCode: 404),
        ),
        InvitationPreviewErrorKind.notFound,
      );
      expect(
        MembershipErrorMapper.invitationPreviewKind(
          _responseError(statusCode: 410),
        ),
        InvitationPreviewErrorKind.notFound,
      );
      expect(
        MembershipErrorMapper.invitationPreviewKind(
          _responseError(statusCode: 500),
        ),
        InvitationPreviewErrorKind.server,
      );
    });

    test('distinguishes transport failures from server failures', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/invitations/token'),
        type: DioExceptionType.connectionTimeout,
      );

      expect(
        MembershipErrorMapper.invitationPreviewKind(error),
        InvitationPreviewErrorKind.network,
      );
    });
  });
}

DioException _responseError({
  required int statusCode,
  Map<String, dynamic>? data,
}) {
  final request = RequestOptions(path: '/invitations/token');
  return DioException(
    requestOptions: request,
    response: Response<dynamic>(
      requestOptions: request,
      statusCode: statusCode,
      data: data,
    ),
    type: DioExceptionType.badResponse,
  );
}
