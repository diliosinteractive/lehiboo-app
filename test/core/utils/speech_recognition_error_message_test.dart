import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/utils/speech_recognition_error_message.dart';
import 'package:lehiboo/l10n/generated/app_localizations_en.dart';
import 'package:lehiboo/l10n/generated/app_localizations_fr.dart';

void main() {
  group('speechRecognitionErrorMessage', () {
    test('maps common SDK identifiers to actionable localized copy', () {
      final en = AppLocalizationsEn();
      final fr = AppLocalizationsFr();

      expect(
        speechRecognitionErrorMessage(en, 'error_permission'),
        en.voiceRecognitionPermissionRequired,
      );
      expect(
        speechRecognitionErrorMessage(en, 'error_speech_timeout'),
        en.voiceNothingHeard,
      );
      expect(
        speechRecognitionErrorMessage(fr, 'error_network_timeout'),
        fr.voiceRecognitionNetworkError,
      );
      expect(
        speechRecognitionErrorMessage(fr, 'error_language_not_supported'),
        fr.voiceRecognitionLanguageUnavailable,
      );
    });

    test('never exposes unknown SDK or exception diagnostics', () {
      final l10n = AppLocalizationsEn();

      expect(
        speechRecognitionErrorMessage(
          l10n,
          'PlatformException(speech_recognizer_failed, internal details)',
        ),
        l10n.voiceRecognitionUnavailable,
      );
    });
  });
}
