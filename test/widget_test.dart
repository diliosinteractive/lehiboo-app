// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lehiboo/config/dio_client.dart';
import 'package:lehiboo/core/providers/shared_preferences_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:lehiboo/main.dart';

void main() {
  testWidgets('LeHiboo app starts correctly', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    dotenv.testLoad(fileInput: '');
    DioClient.initialize();

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const LeHibooApp(),
      ),
    );

    // Verify that the app loads
    expect(tester.takeException(), isNull);
  });
}
