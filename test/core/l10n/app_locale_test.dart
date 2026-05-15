import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/constants/app_constants.dart';
import 'package:lehiboo/core/l10n/app_locale.dart';
import 'package:lehiboo/core/providers/shared_preferences_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('resolves saved language before platform locale', () {
    final locale = resolveAppLocale(
      savedLanguageCode: 'en',
      platformLocale: const Locale('fr', 'FR'),
    );

    expect(locale.languageCode, 'en');
  });

  test('uses supported platform locale when no saved language exists', () {
    expect(
      resolveAppLocale(platformLocale: const Locale('en', 'GB')).languageCode,
      'en',
    );
    expect(
      resolveAppLocale(platformLocale: const Locale('fr', 'CA')).languageCode,
      'fr',
    );
  });

  test('falls back to French for unsupported locales', () {
    final locale = resolveAppLocale(
      platformLocale: const Locale('es', 'ES'),
    );

    expect(locale.languageCode, 'fr');
  });

  test('locale controller persists manual language changes', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
    );
    addTearDown(container.dispose);

    await container
        .read(appLocaleControllerProvider.notifier)
        .setLanguageCode('en');

    expect(container.read(appLocaleControllerProvider).languageCode, 'en');
    expect(prefs.getString(AppConstants.keyLanguage), 'en');
    expect(AppLocaleCache.languageCode, 'en');
    expect(AppLocaleCache.localeName, 'en_US');
  });
}
