# Audit — Axe 11 Observabilité (Crash / Analytics / Logging)

Date : 2026-05-28 · Branche : `main` · Auditeur : Claude (+ agent exploration) · Plan : [11-observabilite-crash-analytics.md](../plans/11-observabilite-crash-analytics.md)

## Synthèse
- **État global : 🟠 Majeur** — fondations **bien conçues** (Crashlytics + consent RGPD conforme CNIL, `AnalyticsService` abstrait, `CrashReporter` helper, funnel de réservation complet), mais **couverture opérationnelle trouée** : `CrashReporter` n'est appelé que dans **1 fichier**, **36 `catch(_){}` vides**, **userId Crashlytics jamais posé**, échec de refresh token **silencieux**, flag `ANALYTICS_ENABLED` ignoré au boot.
- Constats : **0 🔴 · 5 🟠 P1 · 7 🟡 P2 · 4 🟢 P3**
- **Chiffres** : `debugPrint` non gardés = **405** (87 fichiers) · `catch(_){}` vides = **36** (15 fichiers) · `dev.log` = **52** (6 fichiers messages) · `CrashReporter.recordError` = **2 appels (1 fichier)** · breadcrumbs `Crashlytics.log()` = **0**.
- **Top 3 actions** :
  1. Poser `setUserIdentifier` (corrélation crash↔user) + remonter l'échec de refresh token en non-fatal.
  2. Instrumenter les `catch` des chemins critiques (auth/paiement/realtime) avec `CrashReporter` ; traiter les 36 catch vides.
  3. Centraliser le logging (`AppLogger` sur `logger`, filtre release) et purger les `debugPrint` exposant des PII.

> Réconciliation : les « P0 » de l'agent sont déjà couverts ailleurs ou concernent le flow mort → re-classés. P0-2 (log token) = gardé `kDebugMode`, cf. [sécurité](05-securite-audit.md) ; P0-3 (messages `[DEBUG]` à l'utilisateur) = [audit 14](14-paiement-realtime-push-audit.md) A2 ; P0-1 (CrashReporter absent du `BookingFlowController`) concerne le **flow legacy mort** → 🟡.

---

## Constats détaillés

### 🟠 P1 — Trous d'observabilité en prod
| # | Constat | Fichier:ligne | Recommandation | Effort |
|---|---------|---------------|----------------|--------|
| P1-1 | **`setUserIdentifier` Crashlytics jamais appelé** : `_syncAuthUser()` pose `analytics.setUserId(user.id)` mais pas l'équivalent Crashlytics → tous les crashs sous user anonyme, corrélation impossible. | [auth_provider.dart:563-578](../../../lib/features/auth/presentation/providers/auth_provider.dart#L563-L578) | `FirebaseCrashlytics.instance.setUserIdentifier(user?.id ?? '')` au login/logout. | S |
| P1-2 | **`CrashReporter` quasi inexploité** (2 appels, 1 fichier) : erreurs réseau/repo silencieuses. Ex. `refreshTokenIfNeeded` (`catch (e) { return false; }`), tickets (`catch(_){}`), toggle favori/`loadBookings` en `debugPrint` seul, échec Pusher en `dev.log`. | auth_repository_impl.dart:170 ; api_booking_repository_impl.dart:137,141,291 ; favorites_provider.dart:165 ; booking_list_controller.dart:234 ; messages_realtime_provider.dart:242 | Instrumenter au minimum les hot paths (auth refresh, paiement, realtime). | M |
| P1-3 | **36 blocs `catch(_){}` vides** (zéro trace). Concentration : vendor_conversations_provider (7), admin_conversations_provider (5), auth_provider (5, cleanup logout), api_booking_repository_impl (3). | 15 fichiers (cf. agent) | Catégoriser : best-effort → `if(kDebugMode) debugPrint` ; critiques → `CrashReporter`. | M |
| P1-4 | **Échec de refresh token non remonté** → déconnexion silencieuse de l'utilisateur, invisible en prod (instrumenté en `debugPrint` gardé seulement). | [dio_client.dart:305-309](../../../lib/config/dio_client.dart#L305-L309), [auth_repository_impl.dart:170-172](../../../lib/features/auth/data/repositories/auth_repository_impl.dart#L170-L172) | `CrashReporter.recordError(..., reason: 'token_refresh_failed')`. | S |
| P1-5 | **Flag `ANALYTICS_ENABLED` ignoré au boot** : `EnvConfig.analyticsEnabled` existe (false en dev) mais n'est jamais consulté ; seul le consent RGPD pilote la collecte. Asymétrie avec la triple garde Crashlytics → flag trompeur. | [env_config.dart:47-48](../../../lib/config/env_config.dart#L47-L48), [main.dart:134](../../../lib/main.dart#L134) | Conditionner l'activation analytics sur `EnvConfig.analyticsEnabled && consent==granted`. | S |

### 🟡 P2 — Qualité & couverture
| # | Constat | Fichier:ligne | Recommandation |
|---|---------|---------------|----------------|
| P2-1 | **405 `debugPrint` non gardés `kDebugMode`** ; certains exposent des **PII** (email) ou du debug oublié. | register_screen.dart:65, business_register_provider.dart:707, event_detail_screen.dart:267 (`"event name test"`) | `AppLogger` central (`logger`, `Level.nothing` en release) + purge PII. |
| P2-2 | **52 `dev.log` (messages)** non routés vers Crashlytics (visibles seulement via Observatory) → erreurs Pusher invisibles en prod. | messages_realtime_provider.dart (30), conversations_provider.dart (7) | `AppLogger.error()` → Crashlytics. |
| P2-3 | **`screen_view` non garanti** : `FirebaseAnalyticsObserver` lit `RouteSettings.name` qui peut différer du `name` GoRouter → noms `null`/`/` possibles. | [app_router.dart:137,236](../../../lib/routes/app_router.dart#L137) | `nameExtractor` custom + test d'intégration de validation. |
| P2-4 | **Aucun breadcrumb Crashlytics** (`Crashlytics.instance.log()` = 0) → crashs sans contexte (dernière route/action/API). Aggravé par P1-1. | global | Breadcrumbs sur transitions de route + actions paiement + erreurs non-fatales. |
| P2-5 | **User properties définies mais jamais posées** : `hasMembership`, `hibonsRank`, `pushEnabled`, `iosAttStatus`. | [analytics_event.dart:226-243](../../../lib/core/analytics/analytics_event.dart#L226-L243) | Les poser aux bons endroits (Hibons rank-up, résolution permission push, état membership). |
| P2-6 | **Couverture Crashlytics asymétrique** entre les 2 flows booking : `OrderCartScreen` instrumenté, `BookingFlowController` (legacy) non (recoupe code mort, [audit 14](14-paiement-realtime-push-audit.md)). | booking_flow_controller.dart:244 | Sera résolu par la suppression du flow legacy. |
| P2-7 | **Package `logger` en pubspec mais non utilisé** dans `lib/` → stratégie 100 % `debugPrint`/`dev.log` sans niveaux ni filtre release. | [pubspec.yaml:97](../../../pubspec.yaml#L97) | Adopter `logger` comme socle de l'`AppLogger`, ou retirer la dépendance. |

### 🟢 P3 — Mineurs
- `runZonedGuarded` absent (risque faible : Crashlytics 4.x gère ses zones ; certains streams Dart pur pourraient échapper) → wrapper optionnel autour de `runApp`.
- `BookingListController.loadBookings` : erreur affichée mais non reportée ([booking_list_controller.dart:235](../../../lib/features/booking/presentation/controllers/booking_list_controller.dart#L235)).
- `debugPrint("event name test")` vestige ([event_detail_screen.dart:267](../../../lib/features/events/presentation/screens/event_detail_screen.dart#L267)).
- 1 seul `print(` résiduel (spring_button.dart, cosmétique).

---

## Points conformes (✅)
- **Crash handlers câblés** : `FlutterError.onError = recordFlutterFatalError` + `PlatformDispatcher.instance.onError` ([main.dart:235-238](../../../lib/main.dart#L235-L238)).
- **Triple garde Crashlytics** : `enableCrashlytics && EnvConfig.crashlyticsEnabled && !kDebugMode` ; `setCustomKey('env', …)` au boot.
- **`CrashReporter` bien conçu** (best-effort, context map, fatal/non-fatal) — sous-utilisé mais correct ([crash_reporter.dart](../../../lib/core/services/crash_reporter.dart)).
- **Funnel de réservation complet** : `beginCheckout → bookingSlotSelected → bookingCustomerFormCompleted → addPaymentInfo → purchase → ticketsDisplayed`, step-aware + `bookingFailed`/`refund`.
- **`AnalyticsEvent` centralisé** (snake_case, pas de littéral en dur), `AnalyticsService` abstrait + `NoopAnalyticsService`.
- **RGPD/CNIL conforme** : consent gate non-dismissible, opt-in strict (`setCollectionEnabled(false)` au boot), réversible, relu depuis prefs avant activation.
- **`setUserId`/`setUserId(null)`** posés aux transitions auth ; `loginFailed`/`signupFailed` avec `reason` catégorisé (cardinalité GA4 maîtrisée).
- **`PrettyDioLogger`** gardé `kDebugMode` + `requestBody: false` (pas de credentials loggés).
- **Double `FirebaseAnalyticsObserver`** (root + ShellRoute) — corrige l'assertion « un observer par Navigator ».

## Annexes
- Source : agent code-explorer (100 outils, ~503 s). Réconciliations de gravité appliquées (P0→P1/P2, renvois axes 05/14).
