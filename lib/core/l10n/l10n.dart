import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../l10n/generated/app_localizations.dart';
import 'app_locale.dart';

export '../../l10n/generated/app_localizations.dart';

/// Returns the shortest decimal representation carried by a decoded API
/// number. JSON whole numbers decoded as doubles gain a synthetic `.0`; that
/// suffix is the only part removed.
String apiAmountText(num amount) {
  if (amount == 0) return '0';

  final rawAmount = amount.toString();
  return rawAmount.endsWith('.0')
      ? rawAmount.substring(0, rawAmount.length - 2)
      : rawAmount;
}

String localizedApiAmountText(num amount, String languageCode) {
  final amountText = apiAmountText(amount);
  return languageCode == 'en' ? amountText : amountText.replaceAll('.', ',');
}

String cachedApiAmountText(num amount) {
  return localizedApiAmountText(amount, AppLocaleCache.languageCode);
}

String cachedEuroAmount(num amount) {
  final amountText = cachedApiAmountText(amount);
  return AppLocaleCache.languageCode == 'en' ? '€$amountText' : '$amountText€';
}

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

  String appAmount(num amount) {
    return localizedApiAmountText(amount, appLanguageCode);
  }

  String appEuroAmount(num amount) {
    final amountText = appAmount(amount);
    return isEnglishLocale ? '€$amountText' : '$amountText€';
  }

  /// Formats a derived monetary value in cents, then removes synthetic zeros.
  ///
  /// API amounts should use [appAmount] or [appEuroAmount] directly. This is
  /// reserved for arithmetic totals, where binary double noise must not leak
  /// into the UI and the backend contract is cent-based.
  String appCalculatedAmount(num amount) {
    final cents = (amount * 100).round();
    final isNegative = cents < 0;
    final absoluteCents = cents.abs();
    final whole = absoluteCents ~/ 100;
    final remainder = absoluteCents % 100;
    final fraction = remainder == 0
        ? ''
        : remainder % 10 == 0
            ? '${remainder ~/ 10}'
            : remainder.toString().padLeft(2, '0');
    final separator = isEnglishLocale ? '.' : ',';
    final sign = isNegative ? '-' : '';
    return fraction.isEmpty ? '$sign$whole' : '$sign$whole$separator$fraction';
  }

  String appCalculatedEuroAmount(num amount) {
    final amountText = appCalculatedAmount(amount);
    return isEnglishLocale ? '€$amountText' : '$amountText€';
  }
}

AppLocalizations cachedAppLocalizations() {
  return lookupAppLocalizations(Locale(AppLocaleCache.languageCode));
}
