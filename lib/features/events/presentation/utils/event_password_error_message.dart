import 'dart:async';

import '../../../../core/utils/api_response_handler.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Maps an unexpected private-event password failure without mislabelling
/// server, parsing, or programming failures as connectivity problems.
String eventPasswordErrorMessage(
  AppLocalizations l10n,
  Object error,
) {
  if (ApiResponseHandler.isNetworkError(error) || error is TimeoutException) {
    return l10n.eventPasswordNetworkError;
  }

  return ApiResponseHandler.extractError(
    error,
    fallback: l10n.eventPasswordCheckFailed,
    localizations: l10n,
  );
}
