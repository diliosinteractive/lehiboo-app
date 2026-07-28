import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Transformer qui décode la réponse comme [BackgroundTransformer] mais, en cas
/// de `FormatException`, capture le contexte autour de l'offset fautif avant
/// de relancer l'erreur. Aide à identifier les payloads tronqués/corrompus
/// renvoyés par le backend (ex: bug intermittent "Unexpected character at
/// offset N" sur l'écran Explorer).
class DiagnosticJsonTransformer extends BackgroundTransformer {
  @override
  Future<dynamic> transformResponse(
    RequestOptions options,
    ResponseBody responseBody,
  ) async {
    if (options.responseType == ResponseType.bytes ||
        options.responseType == ResponseType.stream) {
      return super.transformResponse(options, responseBody);
    }

    final bytes = await _consume(responseBody);
    if (bytes.isEmpty) return null;

    final raw = utf8.decode(bytes, allowMalformed: true);

    final contentType =
        (responseBody.headers[Headers.contentTypeHeader]?.first ?? '')
            .toLowerCase();
    final isJson = contentType.contains('json');

    if (!isJson || options.responseType == ResponseType.plain) {
      return raw;
    }

    try {
      return jsonDecode(raw);
    } on FormatException catch (e) {
      _logFailure(options, raw, e);
      rethrow;
    }
  }

  Future<List<int>> _consume(ResponseBody body) {
    final completer = Completer<List<int>>();
    final buffer = <int>[];
    body.stream.listen(
      buffer.addAll,
      onDone: () => completer.complete(buffer),
      onError: completer.completeError,
      cancelOnError: true,
    );
    return completer.future;
  }

  void _logFailure(
    RequestOptions options,
    String raw,
    FormatException error,
  ) {
    if (!kDebugMode) return;

    debugPrint('🚨 [JSON parse failure] ${options.method} ${options.uri}');
    debugPrint('🚨 Error: ${error.message}');
    debugPrint('🚨 Response length: ${raw.length} chars');

    final offset = _extractOffset(error.message);
    if (offset != null && offset >= 0 && offset < raw.length) {
      final start = (offset - 200).clamp(0, raw.length);
      final end = (offset + 200).clamp(0, raw.length);
      final code = raw.codeUnitAt(offset);
      debugPrint(
        '🚨 Bad char at offset $offset: '
        'U+${code.toRadixString(16).padLeft(4, '0')} (decimal $code)',
      );
      debugPrint('🚨 Context: ${raw.substring(start, end)}');
    } else {
      final tailStart = (raw.length - 400).clamp(0, raw.length);
      debugPrint('🚨 Last 400 chars: ${raw.substring(tailStart)}');
    }
  }

  int? _extractOffset(String message) {
    final match =
        RegExp(r'(?:offset|position)\s+(\d+)').firstMatch(message);
    if (match == null) return null;
    return int.tryParse(match.group(1)!);
  }
}

/// Retente une seule fois les requêtes GET qui échouent avec une
/// `FormatException` (réponse JSON malformée). Mitige le bug intermittent
/// observé sur `/events` côté Explorer pendant qu'on diagnostique la cause
/// racine côté backend.
class JsonRetryInterceptor extends Interceptor {
  JsonRetryInterceptor(this._dio);

  final Dio _dio;
  static const _retriedKey = '_jsonRetried';

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final isGet = err.requestOptions.method.toUpperCase() == 'GET';
    final alreadyRetried = err.requestOptions.extra[_retriedKey] == true;
    final isJsonParseError = err.error is FormatException;

    if (!isGet || alreadyRetried || !isJsonParseError) {
      return handler.next(err);
    }

    debugPrint(
      '🔄 [JsonRetry] Retrying ${err.requestOptions.method} '
      '${err.requestOptions.path} after JSON parse failure',
    );

    try {
      final retryOptions = err.requestOptions.copyWith(
        extra: {...err.requestOptions.extra, _retriedKey: true},
      );
      final response = await _dio.fetch(retryOptions);
      return handler.resolve(response);
    } catch (e) {
      debugPrint('🔄 [JsonRetry] Retry also failed: $e');
      return handler.next(err);
    }
  }
}
