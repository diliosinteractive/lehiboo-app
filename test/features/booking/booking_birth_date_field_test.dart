import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/booking/presentation/widgets/booking_birth_date_field.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

void main() {
  final field = find.byKey(const ValueKey('booking-birth-date-field'));

  Future<List<String?>> pump(WidgetTester tester, {String? value}) async {
    final changes = <String?>[];
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authSessionUserIdProvider.overrideWithValue('account-a'),
        ],
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: BookingBirthDateField(
              value: value,
              ownerAccountId: 'account-a',
              decoration: const InputDecoration(labelText: 'Birth date'),
              onChanged: changes.add,
            ),
          ),
        ),
      ),
    );
    return changes;
  }

  DatePickerDialog dialog(WidgetTester tester) =>
      tester.widget<DatePickerDialog>(find.byType(DatePickerDialog));

  testWidgets('an empty field opens on the years and invents no date',
      (tester) async {
    final changes = await pump(tester);

    await tester.tap(field);
    await tester.pumpAndSettle();
    expect(dialog(tester).initialDate, isNull);
    expect(dialog(tester).initialCalendarMode, DatePickerMode.year);
    final today = DateTime.now().toUtc();
    expect(
      dialog(tester).lastDate,
      DateTime(today.year, today.month, today.day - 1),
      reason: 'the API requires a birth date before today',
    );

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(changes, isEmpty);
  });

  testWidgets('a picked date is reported as yyyy-MM-dd', (tester) async {
    final changes = await pump(tester);

    await tester.tap(field);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('2005'),
      -100,
      scrollable: find.descendant(
        of: find.byType(YearPicker),
        matching: find.byType(Scrollable),
      ),
    );
    await tester.ensureVisible(find.text('2005'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('2005'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('15'));
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(changes, hasLength(1));
    expect(changes.single, matches(RegExp(r'^2005-\d{2}-15$')));
  });

  testWidgets('a known birth date is shown, reopened and can be cleared',
      (tester) async {
    final changes = await pump(tester, value: '1990-04-21');
    expect(find.text('04/21/1990'), findsOneWidget);

    await tester.tap(field);
    await tester.pumpAndSettle();
    expect(dialog(tester).initialDate, DateTime(1990, 4, 21));
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('booking-birth-date-clear')));
    expect(changes, [null]);
  });
}
