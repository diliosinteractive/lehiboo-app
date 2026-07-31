/// Centralised unwrapper for every API response format the backend can return.
///
/// Instead of each datasource guessing the shape, call one of the extract
/// methods and get a predictable result — or a clear [ApiFormatException].
///
/// Supported shapes (in resolution order):
///
/// **Lists**
///  1. `{ "success": true, "data": { "<key>": [...] } }`  — nested key
///  2. `{ "success": true, "data": [...] }`                — success wrapper
///  3. `{ "data": [...], "meta": {...} }`                  — Laravel resource
///  4. `{ "data": { "<key>": [...] } }`                    — nested key (no success)
///  5. `[...]`                                             — raw list
///
/// **Objects**
///  1. `{ "success": true, "data": {...} }`
///  2. `{ "data": {...} }`
///  3. `{...}`                                             — raw object (opt-in)
///
/// **Pagination**
///  – `meta` extracted from root or `data.pagination` when present.
///
/// **Errors**
///  – [extractError] turns any exception into a localized user-facing string.
library;

import 'package:dio/dio.dart';

import '../l10n/l10n.dart';

class ApiResponseHandler {
  ApiResponseHandler._();

  // ---------------------------------------------------------------------------
  // List extraction
  // ---------------------------------------------------------------------------

  /// Extracts a `List<dynamic>` from [response].
  ///
  /// If [key] is provided, the handler looks for it inside the `data` payload
  /// (e.g. `key: 'events'` resolves `data.events`).
  ///
  /// Throws [ApiFormatException] when the format is unrecognisable.
  static List<dynamic> extractList(
    dynamic response, {
    String? key,
  }) {
    // Raw list at root (format 5)
    if (response is List) return response;

    if (response is! Map<String, dynamic>) {
      throw ApiFormatException(
        'Expected Map or List, got ${response.runtimeType}',
        response,
      );
    }

    final map = response;
    final dynamic data = map['data'];

    // --- With nested key ---------------------------------------------------
    if (key != null) {
      final list = _extractNestedList(map, data, key);
      if (list != null) return list;

      throw ApiFormatException(
        'Could not find list at key "$key" in response',
        response,
      );
    }

    // --- Without nested key ------------------------------------------------

    // `data` is already a list (formats 2 & 3)
    if (data is List) return data;

    // `data` is a map — but the caller didn't specify a key, so we can't dig
    // deeper. This is ambiguous; fail explicitly.
    if (data is Map) {
      throw ApiFormatException(
        'Response "data" is a Map — provide a key to extract the list from it',
        response,
      );
    }

    throw ApiFormatException(
      'Could not extract list from response',
      response,
    );
  }

  // ---------------------------------------------------------------------------
  // Object extraction
  // ---------------------------------------------------------------------------

  /// Extracts a single `Map<String, dynamic>` payload from [response].
  ///
  /// When [unwrapRoot] is `true` and there is no `data` wrapper, the root map
  /// itself is returned (useful for endpoints like `GET /auth/me → { user: … }`).
  ///
  /// Throws [ApiFormatException] when the format is unrecognisable.
  static Map<String, dynamic> extractObject(
    dynamic response, {
    bool unwrapRoot = false,
  }) {
    if (response is! Map<String, dynamic>) {
      throw ApiFormatException(
        'Expected Map, got ${response.runtimeType}',
        response,
      );
    }

    final map = response;
    final dynamic data = map['data'];

    if (data is Map<String, dynamic>) return data;

    if (unwrapRoot) return map;

    throw ApiFormatException(
      'Could not extract object from response (no "data" key found — '
      'pass unwrapRoot: true if the root map is the payload)',
      response,
    );
  }

  // ---------------------------------------------------------------------------
  // Pagination metadata
  // ---------------------------------------------------------------------------

  /// Extracts pagination metadata when present.
  ///
  /// Looks for `meta` at root level, or `pagination` inside `data`.
  /// Returns `null` when no pagination info is found (not an error).
  static PaginationMeta? extractMeta(dynamic response) {
    if (response is! Map<String, dynamic>) return null;

    final map = response;

    // Root-level `meta` (Laravel resource)
    if (map['meta'] is Map<String, dynamic>) {
      return PaginationMeta.fromJson(map['meta'] as Map<String, dynamic>);
    }

    // Nested `data.pagination`
    final data = map['data'];
    if (data is Map<String, dynamic> &&
        data['pagination'] is Map<String, dynamic>) {
      return PaginationMeta.fromJson(
        data['pagination'] as Map<String, dynamic>,
      );
    }

    return null;
  }

  // ---------------------------------------------------------------------------
  // Error extraction
  // ---------------------------------------------------------------------------

  /// Turns any exception into a user-facing message.
  ///
  /// Resolution order for [DioException] response bodies:
  ///  1. `{ "error": { "details": { "<field>": ["msg", …] } } }` — first validation error
  ///  2. `{ "error": { "message": "…" } }`
  ///  3. `{ "errors": { "<field>": ["msg", …] } }`                — Laravel validation
  ///  4. `{ "message": "…" }`                                    — top-level message
  ///  5. `{ "data": { "message": "…" } }`                        — nested message
  ///  6. `{ "error": "…" }`                                      — machine-code fallback
  ///
  /// Network / timeout errors return a localized connectivity message.
  /// Empty, boilerplate, or machine-code-only response messages fall back to
  /// an actionable message derived from the HTTP status.
  /// [ApiFormatException] and unrecognised errors return [fallback].
  static String extractError(
    dynamic error, {
    String? fallback,
    AppLocalizations? localizations,
  }) {
    final l10n = localizations ?? cachedAppLocalizations();
    final fallbackMessage = fallback ?? l10n.commonGenericRetryError;

    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.connectionError:
          return l10n.commonConnectionError;
        case DioExceptionType.badResponse:
          final data = error.response?.data;
          if (data is Map) {
            final body = Map<String, dynamic>.from(data);
            final message = _extractMessageFromBody(body);
            if (message != null) return message;

            final codeMessage = _messageForMachineCode(
              _extractMachineCode(body),
              l10n,
            );
            if (codeMessage != null) return codeMessage;
          }
          return _messageForStatus(error.response?.statusCode, l10n) ??
              fallbackMessage;
        case DioExceptionType.unknown:
          final diagnostic = '${error.message ?? ''} ${error.error ?? ''}';
          if (_looksLikeConnectivityFailure(diagnostic)) {
            return l10n.commonConnectionError;
          }
          return fallbackMessage;
        default:
          return fallbackMessage;
      }
    }

    if (error is ApiFormatException) return fallbackMessage;

    // Dart `Error` subclasses (CircularDependencyError, RangeError, etc.) are
    // programming bugs, not user-facing problems. Their toString often looks
    // like "Instance of '<ClassName>'" — never surface that to the UI.
    if (error is Error) return fallbackMessage;

    final str = _stripGenericExceptionPrefix(error.toString());
    if (_looksLikeConnectivityFailure(str)) {
      return l10n.commonConnectionError;
    }

    return safeUserMessage(str) ?? fallbackMessage;
  }

  /// Returns a short message only if it looks safe to show to end users.
  ///
  /// This intentionally keeps ordinary validation/API messages, but rejects
  /// diagnostics such as stack traces, exception class names, file paths, SDK
  /// provider details, and raw network/socket internals.
  static String? safeUserMessage(Object? value) {
    final raw = value?.toString().trim();
    if (raw == null || raw.isEmpty) return null;

    final message = _stripGenericExceptionPrefix(raw).trim();
    if (message.isEmpty) return null;
    if (_looksLikeDiagnosticMessage(message)) return null;
    if (_looksLikeMachineCode(message)) return null;
    if (_looksLikeBackendBoilerplate(message)) return null;

    return message;
  }

  /// Returns true when the exception is a transport/connectivity failure.
  static bool isNetworkError(dynamic error) {
    if (error is! DioException) return false;

    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.connectionError =>
        true,
      _ => false,
    };
  }

  /// Returns a stable API error code when the exception carries one.
  ///
  /// This is intended for feature-specific mappers (authentication, booking,
  /// payments, etc.). The raw code must never be rendered directly.
  static String? extractErrorCode(dynamic error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map) {
        return _extractMachineCode(Map<String, dynamic>.from(data));
      }
    }

    final value = _stripGenericExceptionPrefix(error.toString()).trim();
    return _looksLikeMachineCode(value) ? value.toLowerCase() : null;
  }

  /// Extracts a human-readable message from a Laravel error response body.
  static String? _extractMessageFromBody(Map<String, dynamic> body) {
    // Validation: { "error": { "details": { "field": ["msg"] } } }
    final error = body['error'];
    if (error is Map<String, dynamic>) {
      final details = error['details'];
      final detailsMessage = _firstValidationMessage(details);
      if (detailsMessage != null) return detailsMessage;
      if (error['message'] is String) return safeUserMessage(error['message']);
    }

    // Standard Laravel validation: { "errors": { "field": ["msg"] } }
    final validationMessage = _firstValidationMessage(body['errors']);
    if (validationMessage != null) return validationMessage;

    // Top-level message
    if (body['message'] is String) return safeUserMessage(body['message']);

    // Nested data.message
    final data = body['data'];
    if (data is Map<String, dynamic> && data['message'] is String) {
      return safeUserMessage(data['message']);
    }

    // A string `error` can still be a human sentence. Machine codes such as
    // `booking_error` are rejected by [safeUserMessage] and mapped separately.
    if (error is String) return safeUserMessage(error);

    return null;
  }

  static String? _firstValidationMessage(dynamic errors) {
    if (errors is! Map || errors.isEmpty) return null;

    for (final value in errors.values) {
      if (value is List) {
        for (final item in value) {
          final message = safeUserMessage(item);
          if (message != null) return message;
        }
        continue;
      }
      if (value is Map) {
        final message = _firstValidationMessage(value);
        if (message != null) return message;
        continue;
      }
      final message = safeUserMessage(value);
      if (message != null) return message;
    }
    return null;
  }

  static String? _extractMachineCode(Map<String, dynamic> body) {
    final candidates = <dynamic>[
      body['code'],
      body['error_code'],
      if (body['error'] is String) body['error'],
      if (body['error'] is Map) (body['error'] as Map)['code'],
      if (body['error'] is Map) (body['error'] as Map)['error_code'],
    ];

    for (final candidate in candidates) {
      if (candidate is String && _looksLikeMachineCode(candidate.trim())) {
        return candidate.trim().toLowerCase();
      }
    }
    return null;
  }

  static String? _messageForMachineCode(
    String? code,
    AppLocalizations l10n,
  ) {
    if (code == null) return null;

    return switch (code) {
      'unauthenticated' ||
      'unauthorized' ||
      'authentication_required' ||
      'session_expired' =>
        l10n.commonSessionExpiredError,
      'forbidden' ||
      'access_denied' ||
      'permission_denied' =>
        l10n.commonAccessDeniedError,
      'not_found' || 'resource_not_found' || 'gone' => l10n.commonNotFoundError,
      'conflict' ||
      'already_exists' ||
      'state_conflict' =>
        l10n.commonConflictError,
      'invalid_request' ||
      'validation_error' ||
      'validation_failed' =>
        l10n.commonValidationError,
      'rate_limited' ||
      'too_many_requests' ||
      'too_many_attempts' =>
        l10n.commonTooManyRequestsError,
      'request_timeout' || 'timeout' => l10n.commonRequestTimeoutError,
      'network_error' || 'connection_error' => l10n.commonConnectionError,
      'internal_error' ||
      'server_error' ||
      'service_unavailable' =>
        l10n.commonServiceUnavailableError,
      _ => null,
    };
  }

  static String? _messageForStatus(
    int? statusCode,
    AppLocalizations l10n,
  ) {
    return switch (statusCode) {
      400 => l10n.commonValidationError,
      401 => l10n.commonSessionExpiredError,
      403 => l10n.commonAccessDeniedError,
      404 || 410 => l10n.commonNotFoundError,
      408 => l10n.commonRequestTimeoutError,
      409 => l10n.commonConflictError,
      422 => l10n.commonValidationError,
      429 => l10n.commonTooManyRequestsError,
      int code when code >= 500 => l10n.commonServiceUnavailableError,
      _ => null,
    };
  }

  static String _stripGenericExceptionPrefix(String value) {
    const prefix = 'Exception: ';
    return value.startsWith(prefix) ? value.substring(prefix.length) : value;
  }

  static bool _looksLikeConnectivityFailure(String value) {
    final lower = value.toLowerCase();
    return lower.contains('socketexception') ||
        lower.contains('failed host lookup') ||
        lower.contains('network is unreachable') ||
        lower.contains('connection refused') ||
        lower.contains('connection timed out') ||
        lower.contains('connection reset by peer');
  }

  static bool _looksLikeDiagnosticMessage(String value) {
    final lower = value.toLowerCase();
    if (value.length > 500) return true;
    if (value.startsWith('http://') || value.startsWith('https://')) {
      return true;
    }
    if (value.startsWith('Instance of ')) return true;
    if (lower.startsWith('<!doctype') ||
        lower.startsWith('<html') ||
        value.startsWith('{') ||
        value.startsWith('[')) {
      return true;
    }
    if (_looksLikeConnectivityFailure(value)) return true;

    final diagnosticTokens = <String>[
      'traceback',
      'stack trace',
      'stacktrace',
      'dioexception',
      'socketexception',
      'formatexception',
      'stateerror',
      'fluttererror',
      'rangeerror',
      'typeerror',
      'assertion failed',
      'error code:',
      'unhandled exception',
      'null check operator used on a null value',
      'is not a subtype of type',
      'bad state:',
      'package:',
      'file://',
      'api.openai',
      'openai',
      'deepseek',
      'langchain',
      'insufficient_quota',
      'sqlstate',
      'queryexception',
      'pdoexception',
    ];
    if (diagnosticTokens.any(lower.contains)) return true;

    final diagnosticPatterns = <RegExp>[
      RegExp(r'(^|\n)\s*#\d+\s+'),
      RegExp(r'(^|\n)\s*at\s+[\w.$<>]+\('),
      RegExp(r'(/[A-Za-z0-9._-]+)+\.dart:\d+'),
      RegExp(r'[A-Za-z]:\\[^:]+:\d+'),
      RegExp(r'\.dart:\d+:\d+'),
    ];
    return diagnosticPatterns.any((pattern) => pattern.hasMatch(value));
  }

  static bool _looksLikeMachineCode(String value) {
    return RegExp(
      r'^[a-z0-9]+(?:[_-][a-z0-9]+)+$',
      caseSensitive: false,
    ).hasMatch(value);
  }

  static bool _looksLikeBackendBoilerplate(String value) {
    final normalized =
        value.trim().toLowerCase().replaceAll(RegExp(r'[.!:]+$'), '').trim();
    final internalFailurePatterns = <RegExp>[
      RegExp(r'^unexpected\b.*\b(response|payload|data|format)\b'),
      RegExp(r'^failed to (load|fetch|parse|decode|save)\b'),
      RegExp(r'^(missing|invalid)\b.*\b(response|payload|field|key)\b'),
    ];
    if (internalFailurePatterns
        .any((pattern) => pattern.hasMatch(normalized))) {
      return true;
    }

    return <String>{
      'error',
      'unknown error',
      'an error occurred',
      'something went wrong',
      'bad request',
      'unauthenticated',
      'unauthorized',
      'forbidden',
      'not found',
      'server error',
      'internal server error',
      'service unavailable',
      'validation failed',
      'the given data was invalid',
      'too many requests',
    }.contains(normalized);
  }

  // ---------------------------------------------------------------------------
  // Internals
  // ---------------------------------------------------------------------------

  /// Tries to find a list at [key] inside the `data` payload.
  static List<dynamic>? _extractNestedList(
    Map<String, dynamic> root,
    dynamic data,
    String key,
  ) {
    // data is a Map that contains the key
    if (data is Map<String, dynamic> && data[key] is List) {
      return data[key] as List<dynamic>;
    }

    // Root contains the key directly (e.g. `{ "pins": [...] }`)
    if (root[key] is List) {
      return root[key] as List<dynamic>;
    }

    return null;
  }
}

// ---------------------------------------------------------------------------
// Supporting types
// ---------------------------------------------------------------------------

/// Thrown when [ApiResponseHandler] cannot make sense of a response shape.
class ApiFormatException implements Exception {
  const ApiFormatException(this.message, [this.responseBody]);

  final String message;
  final dynamic responseBody;

  @override
  String toString() => 'ApiFormatException: $message';
}

/// Lightweight pagination metadata extracted from API responses.
class PaginationMeta {
  const PaginationMeta({
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.total,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      currentPage: _toInt(json['current_page']),
      lastPage: _toInt(json['last_page']),
      perPage: _toInt(json['per_page']),
      total: _toInt(json['total']),
    );
  }

  final int? currentPage;
  final int? lastPage;
  final int? perPage;
  final int? total;

  bool get hasMore =>
      currentPage != null && lastPage != null && currentPage! < lastPage!;

  static int? _toInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}
