import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/petit_boo/presentation/utils/petit_boo_error_mapper.dart';
import 'package:lehiboo/l10n/generated/app_localizations_en.dart';
import 'package:lehiboo/l10n/generated/app_localizations_fr.dart';

void main() {
  group('petitBooErrorMessageForCode', () {
    test('maps stable auth, quota, and network codes to localized copy', () {
      final en = AppLocalizationsEn();
      final fr = AppLocalizationsFr();

      expect(
        petitBooErrorMessageForCode(en, code: 'auth_required'),
        en.petitBooAuthRequiredError,
      );
      expect(
        petitBooErrorMessageForCode(fr, code: 'rate_limit'),
        fr.petitBooQuotaExceededError,
      );
      expect(
        petitBooErrorMessageForCode(en, code: 'connection_closed'),
        en.petitBooConnectionError,
      );
    });

    test('keeps a safe human backend message', () {
      expect(
        petitBooErrorMessageForCode(
          AppLocalizationsEn(),
          serverMessage: 'This activity is no longer available.',
        ),
        'This activity is no longer available.',
      );
    });

    test('replaces provider diagnostics and machine codes with the fallback',
        () {
      const fallback = 'Could not complete this action. Please try again.';
      final l10n = AppLocalizationsEn();

      expect(
        petitBooErrorMessageForCode(
          l10n,
          serverMessage: 'OpenAI error code: insufficient_quota',
          fallback: fallback,
        ),
        fallback,
      );
      expect(
        petitBooErrorMessageForCode(
          l10n,
          serverMessage: 'tool_execution_failed',
          fallback: fallback,
        ),
        fallback,
      );
    });
  });

  group('safePetitBooServerMessage', () {
    test('rejects structured payloads', () {
      expect(
        safePetitBooServerMessage({'message': 'internal error'}),
        isNull,
      );
    });
  });

  group('petitBooErrorMessageFromPayload', () {
    test('maps a code from the nested standard error envelope', () {
      final l10n = AppLocalizationsEn();

      expect(
        petitBooErrorMessageFromPayload(
          l10n,
          {
            'success': false,
            'message': 'Authentication failed.',
            'error': {
              'code': 'auth_required',
              'message': 'provider_auth_error',
            },
          },
        ),
        l10n.petitBooAuthRequiredError,
      );
    });

    test('uses the action fallback for unsafe nested details', () {
      const fallback = 'Could not complete this action. Please try again.';

      expect(
        petitBooErrorMessageFromPayload(
          AppLocalizationsEn(),
          {
            'success': false,
            'error': {
              'code': 'tool_execution_failed',
              'message': 'OpenAI error code: insufficient_quota',
            },
          },
          fallback: fallback,
        ),
        fallback,
      );
    });
  });
}
