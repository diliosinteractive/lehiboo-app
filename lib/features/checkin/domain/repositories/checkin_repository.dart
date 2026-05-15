import '../../data/models/checkin_request_dto.dart';
import '../../data/models/checkin_response_dto.dart';
import '../entities/checkin_blocker.dart';
import '../entities/peek_result.dart';

/// Thin domain abstraction over the check-in datasource. The repository
/// translates DTOs into UI-shaped sealed results and surfaces transport
/// errors as typed `CheckinFailure` exceptions so the screen layer can
/// switch on them.
abstract class CheckinRepository {
  /// Peek a ticket via QR. Returns one of:
  ///   - [CanCheckIn] : green, ready to admit.
  ///   - [WouldBeReEntry] : amber, already entered N×.
  ///   - [Blocked] : red, has a `reason` (cancelled, refunded, …).
  ///
  /// Throws [CheckinFailure] for transport-level errors (404, 403,
  /// network failure). The caller should NOT retry network errors; the
  /// vendor re-scans manually (spec §15).
  Future<PeekResult> peek({
    String? qrData,
    String? qrCode,
    int? eventId,
  });

  /// Commit a check-in or re-entry. Returns the server response (which
  /// includes `action` and `check_in_count`). Throws [CheckinFailure] on
  /// any non-200; specifically maps backend error codes to
  /// [CheckinBlocker] when possible.
  ///
  /// **No retry on network error** (spec §15.1 — risk of double-incrementing
  /// `check_in_count`).
  Future<CheckinResponseDto> commit(
    String ticketUuid,
    CheckinRequestDto request,
  );
}

/// Typed exception covering both server-side errors (404 / 403 / 422 with
/// a known `error` code) and unexpected ones (network / 5xx / parse). The
/// scan screen renders the appropriate sheet based on `blocker`.
class CheckinFailure implements Exception {
  final CheckinBlocker blocker;
  final String? message;
  final int? statusCode;

  /// True for transport-level failures (timeout, no connection). The UI
  /// uses this to render the localized spec §15 network warning and SHOULD
  /// NOT auto-retry.
  final bool isNetworkError;

  const CheckinFailure({
    required this.blocker,
    this.message,
    this.statusCode,
    this.isNetworkError = false,
  });

  @override
  String toString() =>
      'CheckinFailure($blocker, status=$statusCode, network=$isNetworkError)';
}
