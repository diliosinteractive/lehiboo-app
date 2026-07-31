import 'package:dio/dio.dart';

import '../../../../core/utils/api_response_handler.dart';

enum InvitationPreviewErrorKind {
  notFound,
  network,
  server,
}

class MembershipErrorMapper {
  MembershipErrorMapper._();

  /// Keeps safe validation/API detail while ensuring machine codes and
  /// diagnostics never replace the action-specific localized fallback.
  static String actionMessage(
    Object error, {
    required String fallback,
  }) {
    if (error is DioException &&
        error.type == DioExceptionType.badResponse &&
        const {400, 409, 422}.contains(error.response?.statusCode) &&
        !_hasSafeHumanMessage(error.response?.data)) {
      return fallback;
    }

    final message = ApiResponseHandler.extractError(
      error,
      fallback: fallback,
    ).trim();

    if (message.isEmpty || _machineCodePattern.hasMatch(message)) {
      return fallback;
    }

    return message.length > 200 ? '${message.substring(0, 197)}...' : message;
  }

  static InvitationPreviewErrorKind invitationPreviewKind(Object error) {
    if (error is DioException) {
      final status = error.response?.statusCode;
      if (status == 404 || status == 410) {
        return InvitationPreviewErrorKind.notFound;
      }
      if (ApiResponseHandler.isNetworkError(error)) {
        return InvitationPreviewErrorKind.network;
      }
    }

    return InvitationPreviewErrorKind.server;
  }

  static bool _hasSafeHumanMessage(dynamic body) {
    if (body is! Map) return false;

    final error = body['error'];
    final data = body['data'];
    final candidates = <dynamic>[
      body['message'],
      if (error is String) error,
      if (error is Map) error['message'],
      if (data is Map) data['message'],
    ];
    if (candidates
        .any((value) => ApiResponseHandler.safeUserMessage(value) != null)) {
      return true;
    }

    return _containsSafeValidationMessage(body['errors']) ||
        (error is Map && _containsSafeValidationMessage(error['details']));
  }

  static bool _containsSafeValidationMessage(dynamic value) {
    if (value is Map) {
      return value.values.any(_containsSafeValidationMessage);
    }
    if (value is List) {
      return value.any(_containsSafeValidationMessage);
    }
    return ApiResponseHandler.safeUserMessage(value) != null;
  }

  static final RegExp _machineCodePattern = RegExp(
    r'^[a-z][a-z0-9]*(?:_[a-z0-9]+)+$',
  );
}
