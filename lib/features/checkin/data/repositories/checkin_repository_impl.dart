import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/checkin_blocker.dart';
import '../../domain/entities/peek_result.dart';
import '../../domain/repositories/checkin_repository.dart';
import '../datasources/checkin_api_datasource.dart';
import '../models/checkin_request_dto.dart';
import '../models/checkin_response_dto.dart';

final checkinRepositoryProvider = Provider<CheckinRepository>((ref) {
  return CheckinRepositoryImpl(ref.watch(checkinApiDataSourceProvider));
});

class CheckinRepositoryImpl implements CheckinRepository {
  final CheckinApiDataSource _api;

  CheckinRepositoryImpl(this._api);

  @override
  Future<PeekResult> peek({
    String? qrData,
    String? qrCode,
    int? eventId,
  }) async {
    try {
      final dto = await _api.peek(
        qrData: qrData,
        qrCode: qrCode,
        eventId: eventId,
      );
      return mapPeekResponseToResult(dto);
    } on DioException catch (e) {
      throw _mapDioException(e);
    } on FormatException catch (e) {
      throw CheckinFailure(
        blocker: CheckinBlocker.unknown,
        message: e.message,
      );
    }
  }

  @override
  Future<CheckinResponseDto> commit(
    String ticketUuid,
    CheckinRequestDto request,
  ) async {
    try {
      return await _api.commit(ticketUuid, request);
    } on DioException catch (e) {
      throw _mapDioException(e);
    } on FormatException catch (e) {
      throw CheckinFailure(
        blocker: CheckinBlocker.unknown,
        message: e.message,
      );
    }
  }

  /// Map Dio errors (HTTP + transport) to a `CheckinFailure`. The
  /// envelope shape on a 4xx is `{"error": "<code>", "message": "<...>"}`
  /// per spec §3.3 / §4.4 — we read `error` first, then fall back to
  /// status-code heuristics.
  CheckinFailure _mapDioException(DioException e) {
    // Transport errors (no response) — spec §15 says don't auto-retry.
    final isTransport = e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.connectionError;
    if (isTransport) {
      return CheckinFailure(
        blocker: CheckinBlocker.unknown,
        message: e.message,
        isNetworkError: true,
      );
    }

    final response = e.response;
    final status = response?.statusCode;
    final body = response?.data;
    String? errorCode;
    String? message;
    if (body is Map<String, dynamic>) {
      errorCode = body['error']?.toString();
      message = body['message']?.toString();
    }

    // The "error" field is the canonical signal. Map it directly.
    if (errorCode != null && errorCode.isNotEmpty) {
      return CheckinFailure(
        blocker: checkinBlockerFromCode(errorCode),
        message: message,
        statusCode: status,
      );
    }

    // Fallback by status code — covers servers that return a 4xx without
    // a structured `error` field (shouldn't happen but defensive).
    final fallback = switch (status) {
      404 => CheckinBlocker.ticketNotFound,
      403 => CheckinBlocker.unauthorized,
      _ => CheckinBlocker.unknown,
    };
    return CheckinFailure(
      blocker: fallback,
      message: message,
      statusCode: status,
    );
  }
}
