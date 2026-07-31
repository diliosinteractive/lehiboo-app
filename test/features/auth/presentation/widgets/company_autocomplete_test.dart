import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lehiboo/features/auth/data/services/company_search_service.dart';
import 'package:lehiboo/features/auth/presentation/widgets/company_autocomplete.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';
import 'package:lehiboo/l10n/generated/app_localizations_en.dart';

void main() {
  Future<void> pumpAutocomplete(
    WidgetTester tester,
    CompanySearchService service,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: CompanyAutocomplete(
              searchService: service,
              onSelect: (_) {},
              organizationName: 'company',
              organizationPossessive: 'your company',
            ),
          ),
        ),
      ),
    );
  }

  Future<void> search(WidgetTester tester) async {
    await tester.enterText(find.byType(TextField), 'LeHiboo');
    await tester.pump(const Duration(milliseconds: 301));
    await tester.pumpAndSettle();
  }

  testWidgets('shows lookup-unavailable guidance and retry on API failure',
      (tester) async {
    final service = CompanySearchService(
      client: MockClient((_) async => http.Response('Unavailable', 503)),
    );
    addTearDown(service.dispose);
    await pumpAutocomplete(tester, service);

    await search(tester);

    final l10n = AppLocalizationsEn();
    expect(find.text(l10n.authCompanySearchUnavailable), findsOneWidget);
    expect(find.text(l10n.commonRetry), findsOneWidget);
    expect(find.text(l10n.authCompanySearchNoResults), findsNothing);
  });

  testWidgets('shows manual-entry guidance for a valid zero-result response',
      (tester) async {
    final service = CompanySearchService(
      client: MockClient((_) async => http.Response('{"results": []}', 200)),
    );
    addTearDown(service.dispose);
    await pumpAutocomplete(tester, service);

    await search(tester);

    final l10n = AppLocalizationsEn();
    expect(find.text(l10n.authCompanySearchNoResults), findsOneWidget);
    expect(find.text(l10n.authCompanySearchUnavailable), findsNothing);
  });
}
