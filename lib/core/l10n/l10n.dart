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
}
