import '../../l10n/generated/app_localizations.dart';

/// Converts speech_to_text / platform error identifiers into localized copy.
///
/// SDK values such as `error_speech_timeout` are useful for branching and
/// diagnostics, but must never be rendered directly to users.
String speechRecognitionErrorMessage(
  AppLocalizations l10n,
  Object? rawCode,
) {
  final code = rawCode
      ?.toString()
      .trim()
      .toLowerCase()
      .replaceAll('-', '_')
      .replaceAll(' ', '_');

  return switch (code) {
    'error_permission' ||
    'permission_denied' ||
    'not_allowed' ||
    'service_not_allowed' =>
      l10n.voiceRecognitionPermissionRequired,
    'error_no_match' ||
    'error_speech_timeout' ||
    'no_match' =>
      l10n.voiceNothingHeard,
    'error_network' ||
    'error_network_timeout' ||
    'network' ||
    'network_timeout' =>
      l10n.voiceRecognitionNetworkError,
    'error_busy' || 'recognizer_busy' || 'busy' => l10n.voiceRecognitionBusy,
    'error_language_not_supported' ||
    'error_language_unavailable' ||
    'language_not_supported' ||
    'language_unavailable' =>
      l10n.voiceRecognitionLanguageUnavailable,
    'error_too_many_requests' ||
    'too_many_requests' ||
    'rate_limited' =>
      l10n.voiceRecognitionTooManyAttempts,
    'error_audio' || 'audio' => l10n.voiceMicrophoneUnavailable,
    _ => l10n.voiceRecognitionUnavailable,
  };
}
