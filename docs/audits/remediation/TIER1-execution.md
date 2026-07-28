# Plan d'exécution — Remédiation Tier 1 (risque faible, périmètre isolé)

Date : 2026-05-28 · Branche cible : `fix/audit-tier1` · Pré-requis : [Tier 0](TIER0-execution.md) mergé (recommandé)

> **Périmètre** : changements qui modifient un comportement **uniquement dans un cas d'erreur / edge case / config**, ou strictement défensifs/perf. Périmètre par fichier maîtrisable. **Décision n°1 du tier** : réparer le toolchain pour retrouver `flutter test` (T1.1).
> **Validation** : `dart analyze` (⚠️ `flutter analyze` cassé : réclame SDK 3.44.0) + smoke manuel + `flutter run` debug. Après T1.1, `flutter test` redevient utilisable.

---

## Tâches

### T1.1 — Réparer & épingler le toolchain Flutter ⭐ (priorité)
- **Constat** : [13](../resultats/13-ci-cd-release-audit.md) P2-1, [07](../resultats/07-tests-qualite-audit.md) P0-2, [08](../resultats/08-dependances-build-config-audit.md) P2-6. 3 versions divergentes (CI 3.38.7 / PATH 3.32.5 / fvm 3.35.7 cassé) ; `flutter analyze`/`pub get` réclament SDK 3.44.0.
- **Action** :
  1. Committer un **`.fvmrc`** pinné sur **3.38.7** (version prouvée par la CI Xcode Cloud `ci_post_clone.sh:28`).
  2. `fvm install 3.38.7 && fvm use 3.38.7` (ou réparer l'install cassée).
  3. Vérifier `fvm flutter pub get` puis **`fvm flutter test`** → doit compiler.
- **Impact runtime** : **nul** (tooling). Mais change la version de build locale → 3.38.7 est déjà la version de prod (CI), donc alignement, pas régression.
- **Validation** : `fvm flutter test` compile (même si rouge sur le fond), `fvm flutter analyze` tourne.
- **Effort** : S-M. **Débloque la validation automatisée de tous les tiers suivants.**

### T1.2 — Restaurer les messages d'erreur de paiement (retirer `[DEBUG]`)
- **Constat** : [14](../resultats/14-paiement-realtime-push-audit.md) A2. `order_cart_screen.dart:1030-1036,1060-1063` affichent `[DEBUG …]` à l'utilisateur.
- **Action** : remplacer par les lignes commentées « Restaurer: » (`e.error.localizedMessage` / `ApiResponseHandler.extractError(e)`). Vérifier aussi `checkout_screen.dart`.
- **Risque** : faible — n'affecte que la **branche d'échec** de paiement (le succès est inchangé).
- **Validation** : déclencher un échec Stripe (carte test refusée) → message localisé propre.
- **Effort** : S.

### T1.3 — Garde de ré-entrée au submit du checkout
- **Constat** : [14](../resultats/14-paiement-realtime-push-audit.md) A3. `_submitOrder` (order_cart_screen.dart:908) sans `if (_isLoading) return;`.
- **Action** : ajouter `if (_isLoading) return;` en tête de `_submitOrder`.
- **Risque** : faible — bloque uniquement le double-tap (simple tap inchangé).
- **Validation** : double-tap rapide sur « Payer » → une seule commande créée.
- **Effort** : S.

### T1.4 — `PopScope` sur les écrans de paiement
- **Constat** : [09](../resultats/09-ui-ux-accessibilite-audit.md) P1-5. Back Android pendant paiement détruit le state.
- **Action** : wrapper `checkout_screen` / `order_cart_screen` avec `PopScope(canPop: !_isLoading, …)`.
- **Risque** : faible — n'agit que pendant `_isLoading`.
- **Validation** : back pendant paiement en cours → bloqué/confirmation.
- **Effort** : S.

### T1.5 — Sécuriser les `.value!` non sûrs
- **Constat** : [03](../resultats/03-state-management-riverpod-audit.md) P1-3. map_view_screen:488,673 ; categories_chips_section:37 ; city_detail_screen:271.
- **Action** : `eventsAsync.valueOrNull?.x ?? <fallback>` ou `.when(...)`.
- **Risque** : faible — ne change le comportement que dans le cas de course qui crashait.
- **Validation** : écrans carte / catégories / détail ville s'affichent normalement.
- **Effort** : S.

### T1.6 — `sendTimeout` sur les 3 configs Dio
- **Constat** : [04](../resultats/04-reseau-api-donnees-audit.md) P1-5. Absent (Dio principal, refresh, Petit Boo).
- **Action** : ajouter `sendTimeout: AppConstants.apiTimeout` aux 3 `BaseOptions`.
- **Risque** : faible — n'affecte que les envois pathologiquement lents (upload bloqué) ; comportement nominal inchangé.
- **Validation** : upload avatar/photo fonctionne ; pas de timeout sur réseau normal.
- **Effort** : S.

### T1.7 — `authProvider.select` dans les app bars
- **Constat** : [03](../resultats/03-state-management-riverpod-audit.md) P2-2, [06](../resultats/06-performance-audit.md). `ref.watch(authProvider).user` / `orderCartProvider` entiers.
- **Action** : `ref.watch(authProvider.select((s) => s.user))` ; `.select` sur le compte panier.
- **Risque** : faible — `select` est déterministe (mêmes données, moins de rebuilds).
- **Validation** : avatar/badge panier se mettent à jour comme avant.
- **Effort** : S.

### T1.8 — Tap targets favori ≥ 48 dp
- **Constat** : [09](../resultats/09-ui-ux-accessibilite-audit.md) P1-4. `FavoriteButton` à 32/36 dp.
- **Action** : `containerSize ≥ 48` (ou zone tactile élargie sans changer le visuel de l'icône).
- **Risque** : faible — changement visuel/tactile mineur.
- **Validation** : bouton favori reste cohérent visuellement, plus facile à toucher.
- **Effort** : S.

### T1.9 — Supprimer la clé dupliquée `paymentIntentId`
- **Constat** : [04](../resultats/04-reseau-api-donnees-audit.md) P2-3. `confirmOrder` envoie `payment_intent_id` ET `paymentIntentId`.
- **Action** : ne garder que `payment_intent_id` (contrat Laravel).
- **Risque** : faible — vérifier d'abord que le backend n'utilise que `payment_intent_id` (sinon différer).
- **Validation** : confirmer une commande payante → succès.
- **Effort** : S.

### T1.10 — Activer un lint moderne (dev tooling)
- **Constat** : [02](../resultats/02-qualite-code-conventions-audit.md) Q4. `flutter_lints` 3.0, `riverpod_lint`/`custom_lint` non activés, `avoid_print` off.
- **Action** : passer `flutter_lints` à ^5/6, ajouter la section `custom_lint:` dans `analysis_options.yaml`, activer `avoid_print` + `prefer_const_constructors`.
- **Risque** : **nul au runtime** ; mais fera **remonter beaucoup d'issues** (les 1171 + nouvelles). Ne pas les corriger ici → c'est le Tier 2. Juste activer + établir la baseline.
- **Validation** : `dart analyze` tourne ; documenter le nouveau total.
- **Effort** : S (activation) — la résorption est Tier 2.

### T1.11 — i18n : formatage prix + dates hardcodées
- **Constat** : [10](../resultats/10-internationalisation-audit.md) P1-1/P1-3.
- **Action** : (a) helper `context.formatPrice(amount, currency)` via `NumberFormat.currency(locale:…)` et l'utiliser dans `Event.priceForDisplay` + cart/checkout ; (b) remplacer les 3 `DateFormat('dd/MM…')` par `context.appDateFormat(fr, enPattern:…)`. Nécessite `flutter gen-l10n` si nouvelles clés.
- **Risque** : faible-moyen — le format prix change l'affichage en EN ; **tester FR (`25,00 €`) ET EN (`€25.00`)** pour ne pas casser le FR.
- **Validation** : prix corrects dans les 2 locales sur détail/cart/checkout.
- **Effort** : M.

---

## Séquencement
1. **T1.1 en premier** (débloque `flutter test` → validation auto pour le reste).
2. Puis paiement (T1.2-T1.4), state/perf (T1.5-T1.7), réseau (T1.6-T1.9), lint (T1.10), i18n (T1.11).
3. 1 tâche = 1 commit atomique.

## Validation globale
- `fvm flutter test` compile (après T1.1) ; `dart analyze` ne régresse pas (hors T1.10 qui établit une nouvelle baseline volontairement plus haute).
- `flutter run` debug : golden path **+ un paiement test (succès et échec)** + bascule FR/EN sur un écran avec prix.

## Definition of Done
- [ ] `.fvmrc`=3.38.7 committé, `flutter test` compile.
- [ ] Paiement : plus de `[DEBUG]`, garde ré-entrée, `PopScope` en place.
- [ ] Prix/dates corrects en FR **et** EN.
- [ ] Aucune régression sur le golden path + flow paiement.

> **Suite** : [Tier 2](TIER2-execution.md) (refactors par zone : erreurs unifiées, observabilité, perf, a11y, résorption lint).
