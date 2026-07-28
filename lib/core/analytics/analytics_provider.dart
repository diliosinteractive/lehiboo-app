import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'analytics_service.dart';

/// Provider Riverpod du service analytics.
///
/// Doit être overridé dans le `ProviderContainer` de `main.dart` avec une
/// instance concrète (`FirebaseAnalyticsService` ou `NoopAnalyticsService`).
/// Même pattern que `sharedPreferencesProvider`.
final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  throw UnimplementedError(
    'analyticsServiceProvider must be overridden in main.dart',
  );
});
