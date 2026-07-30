import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../l10n/generated/app_localizations.dart';
import 'app_locale.dart';

export '../../l10n/generated/app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  String get appLanguageCode => Localizations.localeOf(this).languageCode;

  String get appLocaleName => localeNameForLanguageCode(appLanguageCode);

  bool get isEnglishLocale => appLanguageCode == 'en';

  DateFormat appDateFormat(String frPattern, {String? enPattern}) {
    return DateFormat(
      isEnglishLocale ? enPattern ?? frPattern : frPattern,
      appLocaleName,
    );
  }

  NumberFormat get appCompactNumberFormat {
    return NumberFormat.compact(locale: appLocaleName);
  }

  String appEuroAmount(num amount) {
    // Keep the API's numeric value intact. Deserializing a whole JSON number
    // as a double can add a synthetic ".0", which is the only part removed.
    final rawAmount = amount.toString();
    final apiAmount = rawAmount.endsWith('.0')
        ? rawAmount.substring(0, rawAmount.length - 2)
        : rawAmount;
    final localizedAmount =
        isEnglishLocale ? apiAmount : apiAmount.replaceAll('.', ',');
    return isEnglishLocale ? '€$localizedAmount' : '$localizedAmount€';
  }
}

AppLocalizations cachedAppLocalizations() {
  return lookupAppLocalizations(Locale(AppLocaleCache.languageCode));
}
