# Plan d'exécution — Remédiation Tier 2 (risque modéré, refactors par zone)

Date : 2026-05-28 · Branche cible : `refactor/audit-tier2` · Pré-requis : [Tier 1](TIER1-execution.md) (toolchain réparé → `flutter test` + CI nécessaires pour valider)

> **Périmètre** : refactors qui touchent **beaucoup de fichiers** ou changent la **propagation d'erreurs / le cycle de vie / le rendu**, mais restent **bien délimités par zone**. Régression possible si non testé → **à faire après le toolchain (T1.1) et idéalement après une CI minimale**.
> **Approche** : par **lots thématiques**, chacun mergé et validé séparément. Validation : `dart analyze` + `flutter test` (réparé) + smoke manuel par zone.

---

## Lot 2.A — Gestion d'erreurs unifiée
- **Constats** : [04](../resultats/04-reseau-api-donnees-audit.md) P1-1/P1-2.
- **Tâches** :
  1. Créer `core/utils/app_failure.dart` (`AppFailure` métier) + wrapper `safeCall<T>()`.
  2. Appliquer aux datasources sans try/catch : stories, reminders, in_app_notifications, checkin, reviews, favorites, events (home_feed/availability/categories/…), booking (create/confirm/intent).
  3. `alertsApiDataSource.createAlert` → `ApiResponseHandler.extractObject`.
- **Risque** : **modéré** — change ce que reçoivent les providers (Failure typé au lieu de DioException brute). Tester chaque écran consommateur (états erreur).
- **Effort** : M-L. **Pré-requis tests** : couvrir au moins booking + favorites avant.

## Lot 2.B — Observabilité & logging
- **Constats** : [11](../resultats/11-observabilite-crash-analytics-audit.md) P1-2/P1-3/P2-1/P2-2, [02](../resultats/02-qualite-code-conventions-audit.md) Q2/Q3.
- **Tâches** :
  1. Créer un **`AppLogger`** central (sur `logger`, `Level.nothing` en release) ; remplacer les **~405 `debugPrint`** par lots (par feature).
  2. Instrumenter les **36 `catch(_){}` vides** : best-effort → `if(kDebugMode)`/log ; critiques (auth/booking/realtime) → `CrashReporter.recordError`.
  3. Router les **52 `dev.log`** (messages) vers `AppLogger.error` → Crashlytics.
  4. Brancher `EnvConfig.analyticsEnabled` au boot (cohérence avec la garde Crashlytics).
  5. Breadcrumbs Crashlytics sur transitions de route + actions paiement.
- **Risque** : **modéré** — remplacement massif de logs (risque de typo/comportement si un `catch` change de flux). Faire par feature, ne **jamais** changer le flux de contrôle des `catch`.
- **Effort** : L (étalable par feature).

## Lot 2.C — Cycle de vie state (Riverpod)
- **Constats** : [03](../resultats/03-state-management-riverpod-audit.md) P1-1/P1-4/P1-5, P2-1/P2-3/P2-4.
- **Tâches** :
  1. Extraire l'init globale de `LeHibooApp.build()` dans un `AppInitializer` (initState + `ref.listen`).
  2. Passer en `autoDispose` : `vendorBroadcastsProvider`, `categoryHistoryProvider`, `viewedStoriesProvider`, `savedSearchesProvider`, `wheelSpin/purchase/chatUnlock`, `_broadcastDetailProvider`, `_reportDetailProvider`.
  3. Déplacer les providers déclarés dans des fichiers widgets vers `*_provider.dart`.
  4. Sortir la pagination de `eventFilterProvider` ; annuler la souscription SSE dans `petitBooChat._initialize()`.
- **Risque** : **modéré** — `autoDispose` change la durée de vie de l'état (un écran qui re-rentre repart de zéro). Vérifier les écrans concernés (messages vendor/admin, broadcasts, stories).
- **Effort** : M-L.

## Lot 2.D — Performance
- **Constats** : [06](../resultats/06-performance-audit.md) P1-1→P1-6, P2-1→P2-8.
- **Tâches** :
  1. Isoler l'AppBar du scroll (home + détail event) via `ValueNotifier`/sous-widget.
  2. `memCacheWidth` sur les `CachedNetworkImage` (vignettes) ; remplacer les 2 `Image.network` bruts.
  3. Mémoïser `_buildMarkers()` (carte) ; `VisibilityDetector` sur countdown cards / stories ; pause du timer idle Petit Boo.
  4. `RepaintBoundary` sur sections home ; `compute()` pour le parsing events/home feed.
- **Risque** : **modéré** — `memCacheWidth` mal dimensionné = images floues ; refactor scroll touche 2 écrans très visibles. Tester visuellement.
- **Effort** : M-L.

## Lot 2.E — Accessibilité
- **Constats** : [09](../resultats/09-ui-ux-accessibilite-audit.md) P1-1→P1-7.
- **Tâches** :
  1. `Semantics`/`tooltip` sur les boutons icônes (favori, partage, nav, galerie) ; `ExcludeSemantics` sur les images décoratives.
  2. Gérer le **text scaling** (layouts flex au lieu des hauteurs fixes) — prioriser billets/checkout.
  3. Contraste : `Colors.grey` → `HbColors.grey500` (nav bar, métadonnées).
  4. États d'erreur visibles sur les sections home principales (vs `SizedBox.shrink()`).
- **Risque** : **modéré** — le passage en layouts flex peut décaler des UI ; faire écran par écran avec revue visuelle.
- **Effort** : L.

## Lot 2.F — Robustesse réseau secondaire
- **Constats** : [04](../resultats/04-reseau-api-donnees-audit.md) P1-6/P1-7/P2-6, [14](../resultats/14-paiement-realtime-push-audit.md) C1.
- **Tâches** : Dio Petit Boo hérite des intercepteurs (sécurité/refresh/timeout) ; `try/finally` sur le `http.Client` SSE ; `CancelToken` sur le typeahead `/search/suggestions` ; centraliser `_parseInt/_parseBool/...`.
- **Risque** : **modéré** — l'héritage des intercepteurs Petit Boo change le comportement 401 (force-logout) ; tester le chat.
- **Effort** : M.

## Lot 2.G — Store readiness
- **Constats** : [12](../resultats/12-plateforme-ios-android-audit.md) P1-1, P2-1/P2-2.
- **Tâches** : ajouter `PrivacyInfo.xcprivacy` ; retirer la permission iOS « Always » location (garder WhenInUse) ; statuer sur `UIFileSharingEnabled` ; aligner les versions (pubspec ↔ Android).
- **Risque** : **modéré** — changer les permissions/plist peut affecter l'archivage iOS ; tester un build iOS.
- **Effort** : M.

## Lot 2.H — Résorption du lint
- **Constats** : [02](../resultats/02-qualite-code-conventions-audit.md) Q4 + 1171 issues.
- **Tâches** : corriger par lots les familles dominantes (`withOpacity`→`withValues`, `invalid_annotation_target`, `curly_braces`, `prefer_const`). Activer `--fatal-warnings` une fois proche de 0.
- **Risque** : faible-modéré — `withValues` change la précision alpha (négligeable) ; `const` peut révéler des erreurs de compilation à corriger.
- **Effort** : M (étalable).

---

## Séquencement conseillé
2.A (erreurs) → 2.B (observabilité) en parallèle de 2.H (lint) → 2.C (state) → 2.D (perf) → 2.E (a11y) → 2.F (réseau) → 2.G (store). Chaque lot = sa propre branche + validation.

## Validation
Pré-requis : `flutter test` opérationnel (Tier 1) + idéalement **CI minimale** (Tier 3 §CI) pour valider chaque lot. Sinon, smoke manuel **par zone** obligatoire. Chaque lot doit laisser `dart analyze` ≤ baseline du lot.

## Definition of Done
- [ ] Type `AppFailure` + `safeCall` appliqués aux datasources critiques.
- [ ] `AppLogger` en place, `debugPrint`/`dev.log`/`catch` vides traités (≥ hot paths).
- [ ] `autoDispose`/`AppInitializer` appliqués sans régression d'état.
- [ ] Écrans clés sans jank (AppBar isolée, images dimensionnées).
- [ ] Boutons icônes labellisés ; text scaling géré sur billets/checkout.
- [ ] `PrivacyInfo.xcprivacy` présent ; permissions iOS réduites.

> **Suite** : [Tier 3](TIER3-execution.md) (fort blast radius : sécurité secrets, CI/CD, tests critiques, suppression legacy, env).
