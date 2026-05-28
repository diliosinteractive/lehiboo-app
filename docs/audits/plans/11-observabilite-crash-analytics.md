# Plan 11 — Observabilité (crash & analytics)

Objectif : vérifier la capture des crashs, la qualité des analytics, le respect du
consentement RGPD et la stratégie de logging.

## Périmètre
`lib/core/analytics/`, `lib/main.dart` (`_configureCrashlytics`, consent gate),
`firebase_crashlytics`, `firebase_analytics`, `CrashReporter` (intégré dans `OrderCartScreen`),
`logger`.

## Contexte (constaté dans `main.dart`)
- Crashlytics activé seulement si `AppConstants.enableCrashlytics && EnvConfig.crashlyticsEnabled && !kDebugMode`.
- `FlutterError.onError` + `PlatformDispatcher.onError` câblés sur Crashlytics quand activé. ✅
- Analytics : `setCollectionEnabled(false)` au boot, réactivé par le **consent gate** RGPD (statut persisté) → `granted` réactive.
- Fallback `NoopAnalyticsService` si Firebase échoue. ✅
- User properties : `env`, `app_locale`, `notif_consent`.

## Risques connus / hypothèses
- ⚠️ `CrashReporter` n'est intégré que dans `OrderCartScreen` (commit récent) → couverture partielle, pas de stratégie globale d'`error reporting` côté repositories/datasources.
- ⚠️ 88 fichiers avec `print/debugPrint` → pas de logging structuré ni de breadcrumbs envoyés à Crashlytics.

## Checklist
### Crash reporting
- [ ] **Capture globale** : `FlutterError.onError`, `PlatformDispatcher.onError`, et zones async (`runZonedGuarded` si nécessaire pour les erreurs non-Flutter).
- [ ] **Erreurs non fatales** : les `catch` silencieux des datasources/repositories devraient `recordError` (non-fatal) au lieu de juste `debugPrint`.
- [ ] **Custom keys / logs** : `env`, user id (anonymisé), route courante, dernière action — pour contextualiser les crashs.
- [ ] **`CrashReporter`** : généraliser au-delà de `OrderCartScreen` (chemin paiement, auth, realtime).
- [ ] **dSYM / mapping** : upload des symboles iOS (dSYM) et mapping Android (R8) — à intégrer en CI (plan 13).
- [ ] **Activation par env** : confirmer désactivé en debug, activé en staging/prod selon `.env`.

### Analytics
- [ ] **Catalogue d'événements** : `AnalyticsEvent` centralisé, nommage cohérent, pas d'événements en dur dispersés.
- [ ] **Couverture funnel** : recherche → détail event → réservation → paiement → ticket tracée bout-en-bout.
- [ ] **Pas de PII** dans les paramètres d'événements.
- [ ] **User properties** : pertinentes et stables (`env`, locale, consent, rôle).

### RGPD / consentement
- [ ] **Consent gate** : modal affichée aux nouveaux users ; choix persisté ; collecte strictement conditionnée au consentement (vérifié au boot et au runtime).
- [ ] **Cohérence** : `notif_consent` (push) vs analytics consent — bien distincts.
- [ ] **Réversibilité** : l'utilisateur peut changer d'avis (écran réglages) → désactive Analytics + Crashlytics.

### Logging
- [ ] **Logger structuré** : migrer `print/debugPrint` vers `logger` avec niveaux ; rien en release sauf erreurs routées vers Crashlytics.
- [ ] **Breadcrumbs** : logs importants poussés en `Crashlytics.log()` pour reconstituer les crashs.

## Commandes / mesures
```bash
rg -n "recordError|recordFlutterError|FirebaseCrashlytics|crashlytics\." lib --glob '!*.g.dart'
rg -n "CrashReporter" lib --glob '!*.g.dart'
rg -n "logEvent|AnalyticsEvent|setUserProperty|setCollectionEnabled" lib --glob '!*.g.dart'
rg -n "consent|RGPD|GDPR" lib --glob '!*.g.dart' -i
# catch silencieux (à transformer en non-fatal)
rg -n "catch \(.*\) \{\s*$" -A2 lib --glob '!*.g.dart' | rg -i "debugprint|//|^\s*\}"
```

## Livrable
Carte de la couverture crash (global vs partiel), liste des `catch` silencieux à instrumenter, catalogue d'événements analytics avec trous du funnel, validation du flux de consentement RGPD, plan de migration logging.
