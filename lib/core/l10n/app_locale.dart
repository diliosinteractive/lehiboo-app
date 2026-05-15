import 'dart:ui' show Locale, PlatformDispatcher;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';
import '../providers/shared_preferences_provider.dart';

const fallbackAppLocale = Locale('fr');
const supportedAppLocales = [Locale('fr'), Locale('en')];

final appLocaleControllerProvider =
    StateNotifierProvider<AppLocaleController, Locale>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return AppLocaleController(prefs);
});

final appLanguageCodeProvider = Provider<String>((ref) {
  return ref.watch(appLocaleControllerProvider).languageCode;
});

final appLocaleNameProvider = Provider<String>((ref) {
  return localeNameForLanguageCode(ref.watch(appLanguageCodeProvider));
});

class AppLocaleCache {
  AppLocaleCache._();

  static String _languageCode = fallbackAppLocale.languageCode;

  static String get languageCode => _languageCode;
  static String get localeName => localeNameForLanguageCode(_languageCode);

  static void setLanguageCode(String languageCode) {
    _languageCode =
        normalizeLanguageCode(languageCode) ?? fallbackAppLocale.languageCode;
  }
}

class AppLocaleController extends StateNotifier<Locale> {
  AppLocaleController(this._prefs)
      : super(resolveAppLocale(
          savedLanguageCode: _prefs.getString(AppConstants.keyLanguage),
          platformLocale: PlatformDispatcher.instance.locale,
        )) {
    AppLocaleCache.setLanguageCode(state.languageCode);
  }

  final SharedPreferences _prefs;

  Future<void> setLanguageCode(String languageCode) async {
    final normalized =
        normalizeLanguageCode(languageCode) ?? fallbackAppLocale.languageCode;
    final nextLocale = Locale(normalized);

    state = nextLocale;
    AppLocaleCache.setLanguageCode(normalized);
    await _prefs.setString(AppConstants.keyLanguage, normalized);
  }
}

Locale resolveAppLocale({
  String? savedLanguageCode,
  Locale? platformLocale,
}) {
  final saved = normalizeLanguageCode(savedLanguageCode);
  if (saved != null) return Locale(saved);

  final platform = normalizeLanguageCode(platformLocale?.languageCode);
  if (platform != null) return Locale(platform);

  return fallbackAppLocale;
}

String? normalizeLanguageCode(String? languageCode) {
  if (languageCode == null || languageCode.trim().isEmpty) return null;

  final normalized =
      languageCode.trim().replaceAll('_', '-').split('-').first.toLowerCase();
  final isSupported = supportedAppLocales.any(
    (locale) => locale.languageCode == normalized,
  );

  return isSupported ? normalized : null;
}

String localeNameForLanguageCode(String languageCode) {
  return switch (normalizeLanguageCode(languageCode)) {
    'en' => 'en_US',
    _ => 'fr_FR',
  };
}
