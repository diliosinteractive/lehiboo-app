import 'package:flutter/material.dart';

import 'birth_date_validation.dart';

final _earliestBirthDate = DateTime(1920);

/// Date picker for a birth date the API checks against [minimumAgeYears].
///
/// The API refuses to change a birth date once it is saved, so the picker
/// never preselects one: it opens on the years, and confirming it untouched
/// returns null instead of the latest allowed date. [initialDate] reopens on
/// a date the user already picked, when it is still in range.
Future<DateTime?> showBirthDatePicker(
  BuildContext context, {
  required int minimumAgeYears,
  DateTime? initialDate,
  String? helpText,
}) {
  final lastDate = latestAllowedBirthDate(minimumAgeYears: minimumAgeYears);
  final initial = initialDate != null &&
          !initialDate.isBefore(_earliestBirthDate) &&
          !initialDate.isAfter(lastDate)
      ? initialDate
      : null;
  return showDatePicker(
    context: context,
    initialDate: initial,
    firstDate: _earliestBirthDate,
    lastDate: lastDate,
    initialDatePickerMode:
        initial == null ? DatePickerMode.year : DatePickerMode.day,
    helpText: helpText,
  );
}
