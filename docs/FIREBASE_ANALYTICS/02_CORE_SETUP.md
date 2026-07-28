# Étape 2 — Service & provider analytics

Objectif : isoler `FirebaseAnalytics` derrière une abstraction maison pour pouvoir :

- mocker en tests,
- forcer le nommage cohérent des events,
- gérer le consentement à un seul endroit,
- ajouter un decorator de logs en dev.

## 2.1 Arborescence cible

```
lib/core/analytics/
├── analytics_service.dart       # Interface + implémentation Firebase
├── analytics_provider.dart      # Riverpod provider
├── analytics_event.dart         # Constantes des noms d'events (cf. 05)
└── noop_analytics_service.dart  # Impl no-op pour tests / opt-out
```

Pourquoi `lib/core/analytics/` et pas `lib/core/services/` : volume de fichiers attendu (catalogue + helpers), même découpage que `lib/core/realtime/`.

## 2.2 `AnalyticsService` — contrat

Interface minimale à exposer :

```dart
abstract class AnalyticsService {
  Future<void> logEvent(String name, {Map<String, Object?>? params});
  Future<void> setUserId(String? userId);
  Future<void> setUserProperty(String name, String? value);
  Future<void> setCollectionEnabled(bool enabled);

  // Pour l'observer GoRouter
  FirebaseAnalyticsObserver get observer;
  FirebaseAnalytics get rawInstance; // échappatoire si besoin
}
```

Règles d'implémentation :

- **Fire-and-forget** : aucun `await` côté appelant, jamais bloquer l'UI.
- **Try/catch silencieux** : un échec de log ne doit jamais remonter.
- **Sanitization** : Firebase impose nom d'event ≤ 40 chars, param ≤ 40 chars, valeur string ≤ 100 chars. Centraliser le check dans le service.
- **Convertir les `Object?` non-supportés** (DateTime, enum) en string avant envoi — sinon Firebase drop le param silencieusement.

## 2.3 No-op service

`NoopAnalyticsService` qui implémente toutes les méthodes en `Future.value()`. Utilisé :

- en tests unitaires (override du provider),
- quand l'utilisateur a refusé le consentement (cf. [07_CONSENT_RGPD.md](07_CONSENT_RGPD.md)),
- si `Firebase.initializeApp` a échoué (try/catch existant dans `main.dart`).

## 2.4 Provider Riverpod

```dart
// lib/core/analytics/analytics_provider.dart
final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  // L'implémentation est overridée dans main.dart APRÈS Firebase.initializeApp
  // pour pouvoir échouer proprement sur NoopAnalyticsService si init KO.
  throw UnimplementedError('analyticsServiceProvider must be overridden');
});
```

L'override est posé dans le `ProviderContainer` de [main.dart](../../lib/main.dart) à côté de `sharedPreferencesProvider.overrideWithValue(...)`. Pattern déjà utilisé dans le projet (lignes ~157-162).

## 2.5 Wiring dans `main.dart`

Modifications dans [lib/main.dart](../../lib/main.dart) :

1. Après le bloc `Firebase.initializeApp` (ligne ~107), instancier l'implémentation :
   ```dart
   final analytics = firebaseOk
       ? FirebaseAnalyticsService(FirebaseAnalytics.instance)
       : const NoopAnalyticsService();
   ```
2. Désactiver la collecte **par défaut** tant que le consentement n'est pas donné :
   ```dart
   await analytics.setCollectionEnabled(false);
   ```
   Le consent gate (étape 7) appellera `setCollectionEnabled(true)` à l'acceptation.
3. Ajouter l'override dans le `ProviderContainer` :
   ```dart
   analyticsServiceProvider.overrideWithValue(analytics),
   ```

## 2.6 Pattern d'usage

Depuis un provider Riverpod :

```dart
ref.read(analyticsServiceProvider).logEvent(AnalyticsEvent.eventViewed, params: {
  'event_uuid': event.id,
  'category': event.category,
});
```

Depuis un widget : passer par `Consumer` / `ref.read` dans un callback, **jamais dans `build()`** (un screen_view se loggue via l'observer, pas en manuel).

## Critères de sortie

- [ ] `AnalyticsService`, `NoopAnalyticsService`, `analyticsServiceProvider` créés.
- [ ] Wiring dans `main.dart` fait, build OK iOS + Android.
- [ ] Test unitaire : injection d'un fake `AnalyticsService` dans un provider compile et passe.
- [ ] `setCollectionEnabled(false)` au boot vérifié (rien ne remonte dans DebugView avant consent).
