import 'package:flutter/widgets.dart';

import 'analytics_service.dart';

/// Implémentation no-op utilisée :
/// - si `Firebase.initializeApp` échoue au boot,
/// - en tests unitaires (override du provider),
/// - quand l'utilisateur a refusé le consent (étape 7, à venir).
///
/// `createObserver()` retourne un `NavigatorObserver` brut dont `didPush` /
/// `didPop` par défaut sont des no-ops — aucun appel n'est fait à
/// `FirebaseAnalytics`. Une nouvelle instance par appel pour respecter la
/// contrainte "un observer = un Navigator".
class NoopAnalyticsService implements AnalyticsService {
  const NoopAnalyticsService();

  @override
  NavigatorObserver createObserver() => NavigatorObserver();

  @override
  Future<void> logEvent(String name, {Map<String, Object?>? params}) async {}

  @override
  Future<void> setUserId(String? userId) async {}

  @override
  Future<void> setUserProperty(String name, String? value) async {}

  @override
  Future<void> setCollectionEnabled(bool enabled) async {}
}
