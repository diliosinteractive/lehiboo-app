import 'package:flutter/widgets.dart';

import '../../../../core/l10n/l10n.dart';

extension HomeL10nFormatters on BuildContext {
  String homeEuroAmount(num amount) {
    final rounded = amount.toStringAsFixed(0);
    return isEnglishLocale ? '€$rounded' : '$rounded€';
  }

  String homePriceFrom(num amount) =>
      l10n.homePriceFrom(homeEuroAmount(amount));

  String homePriceFromShort(num amount) =>
      l10n.homePriceFromShort(homeEuroAmount(amount));

  String homeTime(DateTime date) {
    return appDateFormat('HH:mm', enPattern: 'h:mm a').format(date);
  }

  String homeShortDate(DateTime date) {
    return appDateFormat('EEE d MMM yy', enPattern: 'EEE, MMM d, yy')
        .format(date);
  }

  String homeDateAtTime(DateTime date) {
    return l10n.homeDateAtTime(homeShortDate(date), homeTime(date));
  }

  String homeFriendlyDateAtTime(
    DateTime date, {
    bool forceToday = false,
    bool forceTomorrow = false,
  }) {
    if (forceToday || _isSameDay(date, DateTime.now())) {
      return l10n.homeTodayAtTime(homeTime(date));
    }
    if (forceTomorrow ||
        _isSameDay(date, DateTime.now().add(const Duration(days: 1)))) {
      return l10n.homeTomorrowAtTime(homeTime(date));
    }
    return homeDateAtTime(date);
  }

  String homeFriendlyDate(DateTime date) {
    if (_isSameDay(date, DateTime.now())) {
      return l10n.commonToday;
    }
    if (_isSameDay(date, DateTime.now().add(const Duration(days: 1)))) {
      return l10n.commonTomorrow;
    }
    return appDateFormat('EEE d/M/yy', enPattern: 'EEE, M/d/yy').format(date);
  }

  String homeCountdown(Duration remaining) {
    if (remaining == Duration.zero) {
      return l10n.homeCountdownNow;
    }

    final hours = remaining.inHours;
    final minutes = remaining.inMinutes.remainder(60);
    final seconds = remaining.inSeconds.remainder(60);

    if (hours > 24) {
      final days = remaining.inDays;
      final remainingHours = hours.remainder(24);
      return days == 1
          ? l10n.homeCountdownDayHour(days, remainingHours)
          : l10n.homeCountdownDaysHours(days, remainingHours);
    }
    if (hours > 0) {
      return '${hours}h ${minutes}min';
    }
    if (minutes > 0) {
      return '${minutes}min ${seconds}s';
    }
    return '${seconds}s';
  }

  String homeCompactCountdown(Duration remaining) {
    if (remaining == Duration.zero) {
      return l10n.homeCountdownNow;
    }

    final hours = remaining.inHours;
    final minutes = remaining.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}h${minutes.toString().padLeft(2, '0')}';
    }
    return '${minutes}min';
  }
}

bool _isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}
