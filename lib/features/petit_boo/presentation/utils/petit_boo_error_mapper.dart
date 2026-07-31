import '../../../../core/utils/api_response_handler.dart';
import '../../../../l10n/generated/app_localizations.dart';

String? _normalizePetitBooErrorCode(String? code) =>
    code?.trim().toLowerCase().replaceAll('-', '_');

bool isPetitBooQuotaErrorCode(String? code) {
  return switch (_normalizePetitBooErrorCode(code)) {
    'quota_exceeded' || 'message_limit_reached' || 'rate_limit' => true,
    _ => false,
  };
}

/// Returns backend copy only when it is suitable for direct display.
///
/// Petit Boo responses can contain provider diagnostics or stable machine codes
/// in their `error` / `message` fields. Those values are useful for logs and
/// branching, but should never become chat copy.
String? safePetitBooServerMessage(Object? value) {
  final message = ApiResponseHandler.safeUserMessage(value);
  if (message == null) return null;

  final trimmed = message.trim();
  if (trimmed.startsWith('{') || trimmed.startsWith('[')) return null;

  // Examples: `auth_required`, `quota-exceeded`, `tool_execution_failed`.
  // A normal sentence can contain underscores, but a value made exclusively
  // from identifier characters is a machine code rather than user-facing copy.
  final machineCode = RegExp(r'^[a-z][a-z0-9]*(?:[_-][a-z0-9]+)+$');
  if (machineCode.hasMatch(trimmed)) return null;

  return trimmed;
}

/// Maps stable Petit Boo failure codes to localized, actionable copy and only
/// uses the server message when it passed [safePetitBooServerMessage].
String petitBooErrorMessageForCode(
  AppLocalizations l10n, {
  String? code,
  Object? serverMessage,
  String? fallback,
}) {
  final normalizedCode = _normalizePetitBooErrorCode(code);

  return switch (normalizedCode) {
    'auth_required' ||
    'auth_invalid' ||
    'unauthenticated' ||
    'unauthorized' =>
      l10n.petitBooAuthRequiredError,
    'quota_exceeded' ||
    'message_limit_reached' ||
    'rate_limit' =>
      l10n.petitBooQuotaExceededError,
    'timeout' ||
    'network' ||
    'connection_error' ||
    'connection_closed' =>
      l10n.petitBooConnectionError,
    'service_unavailable' || 'unavailable' => l10n.petitBooUnavailable,
    _ => safePetitBooServerMessage(serverMessage) ??
        fallback ??
        l10n.petitBooUnavailable,
  };
}

/// Extracts the standard Petit Boo error envelope without exposing its raw
/// machine-code fields. Both top-level and nested `error` shapes are accepted.
String petitBooErrorMessageFromPayload(
  AppLocalizations l10n,
  Map<String, dynamic> payload, {
  String? fallback,
}) {
  final error = payload['error'];
  final nestedError = error is Map ? error : null;
  final rawCode = payload['code'] ??
      payload['error_code'] ??
      nestedError?['code'] ??
      nestedError?['error_code'];
  final serverMessage = nestedError?['message'] ?? error ?? payload['message'];

  return petitBooErrorMessageForCode(
    l10n,
    code: rawCode is String ? rawCode : null,
    serverMessage: serverMessage,
    fallback: fallback,
  );
}
