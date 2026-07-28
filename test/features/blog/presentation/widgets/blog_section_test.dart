import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/blog/presentation/providers/blog_providers.dart';
import 'package:lehiboo/features/blog/presentation/widgets/blog_section.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

void main() {
  testWidgets('shows a user-facing blog error with a labelled retry', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          latestBlogPostsProvider.overrideWith(
            (ref) async => throw Exception('Le blog est indisponible.'),
          ),
        ],
        child: MaterialApp(
          locale: const Locale('fr'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: BlogSection()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Le blog est indisponible.'), findsOneWidget);
    expect(find.textContaining('Erreur:'), findsNothing);
    expect(find.text('Réessayer'), findsOneWidget);
  });
}
