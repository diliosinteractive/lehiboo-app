import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/dio_client.dart';
import '../models/checkin_request_dto.dart';
import '../models/checkin_response_dto.dart';
import '../models/peek_response_dto.dart';

final checkinApiDataSourceProvider = Provider<CheckinApiDataSource>((ref) {
  return CheckinApiDataSource(ref.watch(dioProvider));
});

/// Vendor-scoped REST surface — every route lives under `/vendor/...` and
/// requires both a Bearer token and the `X-Organization-Id` header. The
/// header is injected globally by `OrganizationHeaderInterceptor` based
/// on `ActiveOrganizationCache`.
///
/// Spec: docs/MOBILE_CHECKIN_SPEC.md §2.
class CheckinApiDataSource {
  final Dio _dio;

  CheckinApiDataSource(this._dio);

  /// `POST /vendor/tickets/scan/peek` — read-only QR decode. Either
  /// [qrData] (`code:secret`) or [qrCode] (alphanumeric shortcode) is
  /// required. Spec §7 documents the shortcode as 12 chars but staging
  /// tickets ship 16-char codes — pass through verbatim.
  /// [eventId] optionally restricts the scan to a single event — the
  /// server returns 422 `wrong_event` if the ticket is for another event.
  ///
  /// Spec: §3.
  Future<PeekResponseDto> peek({
    String? qrData,
    String? qrCode,
    int? eventId,
  }) async {
    assert(
      (qrData != null && qrData.isNotEmpty) ||
          (qrCode != null && qrCode.isNotEmpty),
      'peek requires qrData or qrCode',
    );
    final response = await _dio.post<Map<String, dynamic>>(
      '/vendor/tickets/scan/peek',
      data: {
        if (qrData != null && qrData.isNotEmpty) 'qr_data': qrData,
        if (qrCode != null && qrCode.isNotEmpty) 'qr_code': qrCode,
        if (eventId != null) 'event_id': eventId,
      },
    );
    return PeekResponseDto.fromEnvelope(response.data ?? const {});
  }

  /// `POST /vendor/tickets/{ticket_uuid}/check-in` — commit. The metadata
  /// fields are optional but recommended — they show up in the audit
  /// dashboard. This call is **not auto-retried** by the client on
  /// network errors (spec §15 idempotency).
  ///
  /// Spec: §4.
  Future<CheckinResponseDto> commit(
    String ticketUuid,
    CheckinRequestDto request,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/vendor/tickets/$ticketUuid/check-in',
      data: request.toJson(),
    );
    return CheckinResponseDto.fromEnvelope(response.data ?? const {});
  }
}
