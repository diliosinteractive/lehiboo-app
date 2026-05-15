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
  ///  3. `{ "error": "…" }`                                      — simple string
  ///  4. `{ "message": "…" }`                                    — top-level message
  ///  5. `{ "data": { "message": "…" } }`                        — nested message
  ///
  /// Network / timeout errors return a localized connectivity message.
  /// [ApiFormatException] and unrecognised errors return [fallback].
  static String extractError(
    dynamic error, {
    String? fallback,
  }) {
    final l10n = cachedAppLocalizations();
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
          if (data is Map<String, dynamic>) {
            return _extractMessageFromBody(data) ?? fallbackMessage;
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

    // Generic Exception — strip prefix if present
    final str = error.toString();
    final cleaned = str.startsWith('Exception: ') ? str.substring(11) : str;
    // "Instance of '<Class>'" is the default toString for classes without
    // an override — it's never a helpful message for a user.
    if (cleaned.isNotEmpty &&
        !cleaned.startsWith('http') &&
        !cleaned.startsWith('Instance of ') &&
        !cleaned.contains('DioException')) {
      return cleaned;
    }

    return fallbackMessage;
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

  /// Extracts a human-readable message from a Laravel error response body.
  static String? _extractMessageFromBody(Map<String, dynamic> body) {
    // Validation: { "error": { "details": { "field": ["msg"] } } }
    final error = body['error'];
    if (error is Map<String, dynamic>) {
      final details = error['details'];
      if (details is Map<String, dynamic> && details.isNotEmpty) {
        final first = details.values.first;
        if (first is List && first.isNotEmpty) return first.first.toString();
        return first.toString();
      }
      if (error['message'] is String) return error['message'] as String;
    }
    if (error is String) return error;

    // Top-level message
    if (body['message'] is String) return body['message'] as String;

    // Nested data.message
    final data = body['data'];
    if (data is Map<String, dynamic> && data['message'] is String) {
      return data['message'] as String;
    }

    return null;
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
