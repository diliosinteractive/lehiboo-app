import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/auth/presentation/utils/birth_date_picker.dart';
import 'package:lehiboo/features/auth/presentation/utils/birth_date_validation.dart';

void main() {
  Future<Future<DateTime?>> open(
    WidgetTester tester, {
    DateTime? initialDate,
  }) async {
    late Future<DateTime?> result;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () => result = showBirthDatePicker(
              context,
              minimumAgeYears: customerMinimumRegistrationAgeYears,
              initialDate: initialDate,
            ),
            child: const Text('pick'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('pick'));
    await tester.pumpAndSettle();
    return result;
  }

  DatePickerDialog dialog(WidgetTester tester) =>
      tester.widget<DatePickerDialog>(find.byType(DatePickerDialog));

  testWidgets('opens on the years with nothing selected', (tester) async {
    final result = await open(tester);

    expect(dialog(tester).initialDate, isNull);
    expect(dialog(tester).initialCalendarMode, DatePickerMode.year);
    expect(
      dialog(tester).lastDate,
      latestAllowedBirthDate(
        minimumAgeYears: customerMinimumRegistrationAgeYears,
      ),
    );

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(await result, isNull,
        reason: 'confirming untouched must not produce a birth date');
  });

  testWidgets('reopens on a date already picked', (tester) async {
    final result = await open(tester, initialDate: DateTime(1990, 4, 21));

    expect(dialog(tester).initialDate, DateTime(1990, 4, 21));
    expect(dialog(tester).initialCalendarMode, DatePickerMode.day);

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(await result, DateTime(1990, 4, 21));
  });

  testWidgets('drops an initial date outside the allowed range',
      (tester) async {
    await open(tester, initialDate: DateTime(1900));
    expect(dialog(tester).initialDate, isNull);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    await open(tester, initialDate: DateTime.now());
    expect(dialog(tester).initialDate, isNull);
  });
}
