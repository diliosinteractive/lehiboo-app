# Documentation mobile — Système Hibons (Plan 05)

État actuel de l'implémentation côté Flutter pour le système Hibons (gamification, wallet, animations). Cette doc reflète le code après l'implémentation du Plan 05 et les correctifs ultérieurs (gestion d'overlay, snackbar, fix angle roue, etc.).

---

## 1. Vue d'ensemble

Le système Hibons est piloté côté backend : à chaque mutation Hibons-modifying, l'API injecte une enveloppe `hibons_update` à la racine de la réponse. Côté mobile :

- Un **intercepteur Dio global** lit l'enveloppe sur chaque réponse.
- Un **service singleton** met à jour le state Riverpod du wallet et émet sur des streams.
- Un **coordinateur d'animation** (monté une fois sous le router) écoute ces streams et déclenche :
  - une **SnackBar Material** "+X Hibons 🪙 gagnés !" pour les gains,
  - une **SnackBar grise** discrète pour les débits,
  - un **overlay rank-up** plein écran lors du franchissement de palier.
- Plus aucun toast/repoll manuel n'est nécessaire dans les écrans appelants.

Deux nouveaux endpoints sont consommés :
- `GET /v1/mobile/hibons/balance` — endpoint léger (cache Redis 30 s) pour le badge header au cold start.
- `GET /v1/mobile/hibons/actions-catalog` — liste dynamique des 15 actions v1 avec montants live et caps utilisateur.

L'écran `/transactions` retourne désormais des items enrichis (`pillar_label`, `pillar_color`, `title`, `subtitle`, `context`) et un `meta.earnings_by_pillar` pour le donut profil.

---

## 2. Architecture — flux d'une mutation

```
[User tap "Ajouter favori"]
        │
        ▼
favorites_provider.toggleFavorite()
        │
        ▼
POST /me/favorites/{uuid}/toggle
        │
        ▼ (backend awards 5 H, attaches `hibons_update` envelope)
Dio response
        │
        ▼
HibonsUpdateInterceptor.onResponse()       ← lit data['hibons_update']
        │
        ▼
HibonsService.handleEnvelope(data, silent: false)
        │
        ├─→ container.read(gamificationNotifierProvider.notifier).applyUpdate(...)
        │       (met à jour balance, lifetime, rank dans le wallet state)
        │
        └─→ _deltaController.add(update)   ← stream broadcast
                │
                ▼
HibonsAnimationCoordinator (mounted in MaterialApp.builder)
                │
                ▼
scaffoldMessengerKey.currentState.showSnackBar("+5 Hibons 🪙 gagnés !")
```

---

## 3. Composants et responsabilités

| Composant | Fichier | Rôle |
|-----------|---------|------|
| `HibonsUpdateInterceptor` | [lib/features/gamification/data/interceptors/hibons_update_interceptor.dart](../../lib/features/gamification/data/interceptors/hibons_update_interceptor.dart) | Lit `response.data['hibons_update']` sur chaque réponse Dio. Skip path-scopé pour les routes silencieuses. |
| `HibonsService` (singleton) | [lib/features/gamification/application/hibons_service.dart](../../lib/features/gamification/application/hibons_service.dart) | Pont Dio↔Riverpod. Parse l'enveloppe, applique au notifier, émet sur streams. Pure-Dart, testable. |
| `GamificationNotifier.applyUpdate(HibonsUpdate)` | [lib/features/gamification/presentation/providers/gamification_provider.dart](../../lib/features/gamification/presentation/providers/gamification_provider.dart) | Met à jour `balance`, `lifetimeEarned`, et conditionnellement `rank` + `rankLabel`. |
| `HibonsAnimationCoordinator` | [lib/features/gamification/presentation/widgets/hibons_animation_coordinator.dart](../../lib/features/gamification/presentation/widgets/hibons_animation_coordinator.dart) | StatefulWidget souscrit aux streams. Sérialise les snackbars (queue), affiche overlay rank-up. |
| `RankUpOverlay` | [lib/features/gamification/presentation/widgets/rank_up_overlay.dart](../../lib/features/gamification/presentation/widgets/rank_up_overlay.dart) | Overlay plein écran "Bravo, tu es maintenant {rang} !" — animation scale + fade, auto-dismiss 6 s. |
| `EarningsByPillarDonut` | [lib/features/gamification/presentation/widgets/earnings_by_pillar_donut.dart](../../lib/features/gamification/presentation/widgets/earnings_by_pillar_donut.dart) | Donut "Répartition par pilier" via CustomPainter, lit `meta.earnings_by_pillar`. |
| Clés globales | [lib/routes/app_router.dart](../../lib/routes/app_router.dart) | `rootNavigatorKey` (Navigator) + `scaffoldMessengerKey` (snackbars) — exposées globalement pour usage depuis l'intercepteur. |

---

## 4. Endpoints API consommés

### Existants (inchangés)

| Méthode | Endpoint | Usage |
|---------|----------|-------|
| `GET` | `/mobile/hibons/wallet` | État complet du wallet (rang, streak, daily, chat quota) |
| `POST` | `/mobile/hibons/daily` | Claim daily reward |
| `GET` | `/mobile/hibons/wheel/config` | Config de la roue |
| `POST` | `/mobile/hibons/wheel` | Lancer la roue |
| `POST` | `/mobile/hibons/session-heartbeat` | Crédite +10 H après 3 min en foreground (1×/jour) |
| `POST` | `/categories/{slug}/track-view` | Crédite +20 H à la 1ère exploration (cap 5/jour) |
| `POST` | `/events/{slug}/track-share` | Crédite +10 H par event (cap 2/sem) |
| `POST` | `/mobile/chat/unlock` | Débloque +N messages chat |

### Nouveaux (Plan 05)

| Méthode | Endpoint | Cache | Usage |
|---------|----------|-------|-------|
| `GET` | `/mobile/hibons/balance` | Redis 30 s | Badge header au cold start, pull-to-refresh |
| `GET` | `/mobile/hibons/actions-catalog` | aucun | Liste dynamique des 15 actions v1 |

### Modifié (rétro-compatible)

| Méthode | Endpoint | Changement |
|---------|----------|-----------|
| `GET` | `/mobile/hibons/transactions` | Items enrichis + `meta.earnings_by_pillar` + filtre `?pillar=` |

---

## 5. Format de l'enveloppe `hibons_update`

Injectée à la racine de toute mutation Hibons-modifying, **à côté** de `data` (pas dedans) :

```json
{
  "success": true,
  "data": { /* payload métier intact */ },
  "hibons_update": {
    "delta": 5,
    "new_balance": 295,
    "new_lifetime": 325,
    "lifetime_delta": 5,
    "rank_changed": false,
    "new_rank": null,
    "new_rank_label": null,
    "animation_label": "+5 Hibons",
    "pillar": "discovery"
  }
}
```

**Règles d'affichage** appliquées par le coordinateur :
- `delta > 0` → snackbar "+X Hibons 🪙 gagnés !" (3 s, dark, icône monétaire dorée)
- `delta < 0` → snackbar "{delta} Hibons" (2 s, gris discret)
- `delta == 0` → no-op
- `rank_changed === true` → en plus du snackbar, overlay rank-up plein écran

### Routes silencieuses

L'intercepteur passe `silent: true` pour les routes qui ont leur propre UI de célébration (le state est mis à jour mais aucun snackbar ne s'affiche) :

- `/mobile/hibons/wheel` — dialog `_showResultDialog` après l'animation 5 s de la roue
- `/mobile/hibons/daily` — animation custom du daily reward

Liste maintenue dans `HibonsUpdateInterceptor._silentPaths`.

---

## 6. DTOs et entités

### DTOs freezed ([hibons_api_dto.dart](../../lib/features/gamification/data/models/hibons_api_dto.dart))

| Classe | Endpoint | Notes |
|--------|----------|-------|
| `WalletResponseDto` | `/wallet` | Existant |
| `BalanceResponseDto` | `/balance` | **Nouveau** — léger (5 champs) |
| `HibonsUpdateDto` | enveloppe | **Nouveau** — 9 champs |
| `ActionsCatalogEntryDto` | `/actions-catalog` | **Nouveau** — 11 champs constants + 6 compteurs nullables |
| `TransactionDto` | `/transactions` | **Enrichi** — `pillarLabel`, `pillarColor`, `title`, `subtitle`, `context`, `formattedAmount`, `typeLabel` |
| `TransactionContextDto` | nested | **Nouveau** — event/organization/booking |
| `EarningsByPillarEntryDto` | nested in meta | **Nouveau** |
| `TransactionsListResponseDto` | wrapper | **Nouveau** — capture `meta` (que `extractList` ignorerait) |

### Entités domain (Dart pur, pas de freezed)

- `HibonsBalance` — [hibons_balance.dart](../../lib/features/gamification/data/models/hibons_balance.dart)
- `HibonsUpdate` — [hibons_update.dart](../../lib/features/gamification/data/models/hibons_update.dart)
- `HibonsActionEntry` — [hibons_action_entry.dart](../../lib/features/gamification/data/models/hibons_action_entry.dart)
- `TransactionContext` — [transaction_context.dart](../../lib/features/gamification/data/models/transaction_context.dart)
- `EarningsByPillarEntry` — [earnings_by_pillar_entry.dart](../../lib/features/gamification/data/models/earnings_by_pillar_entry.dart)
- `TransactionsListResult` — [transactions_list_result.dart](../../lib/features/gamification/data/models/transactions_list_result.dart)
- `HibonTransaction` (freezed) — [hibon_transaction.dart](../../lib/features/gamification/data/models/hibon_transaction.dart) — enrichi avec les nouveaux champs

---

## 7. Providers Riverpod

[lib/features/gamification/presentation/providers/gamification_provider.dart](../../lib/features/gamification/presentation/providers/gamification_provider.dart)

| Provider | Type | Usage |
|----------|------|-------|
| `gamificationNotifierProvider` | `AsyncNotifier<HibonsWallet>` | Wallet complet. Méthodes : `refresh()`, `setBalance(int)` (legacy), `applyUpdate(HibonsUpdate)` |
| `hibonsBalanceProvider` | `FutureProvider<HibonsBalance>` | **Nouveau** — `/balance`, fallback header au cold start |
| `actionsCatalogProvider` | `FutureProvider<List<HibonsActionEntry>>` | **Nouveau** — catalogue dynamique |
| `hibonTransactionsProvider` | `FutureProvider.family<TransactionsListResult, String?>` | **Modifié** — paramètre = filtre pillar nullable |
| `earningsByPillarProvider` | `Provider<AsyncValue<List<EarningsByPillarEntry>>>` | **Nouveau** — dérivé du même appel `/transactions` (pas de round-trip) |
| `dailyRewardProvider` | `AsyncNotifier<DailyRewardState>` | Daily — invalide aussi le wallet après claim |
| `wheelConfigProvider` | `FutureProvider<WheelConfig>` | Config roue |
| `wheelSpinProvider` | `StateNotifier<AsyncValue<WheelSpinResult?>>` | Spin |
| `chatUnlockProvider` | `StateNotifier<AsyncValue<bool>>` | Unlock chat — invalide aussi le wallet |

⚠️ **Attention** : utiliser `state.valueOrNull` (et non `state.value`) lors de la lecture du state d'un AsyncNotifier — sur un état `AsyncError`, `.value` re-throw l'erreur sous-jacente. Tous les call sites du projet ont été convertis.

---

## 8. Pipeline d'animation détaillé

### `HibonsService` (singleton, pure-Dart)

```dart
HibonsService.instance.attach(container);     // appelé une fois dans main.dart
HibonsService.instance.handleEnvelope(data);  // appelé par l'intercepteur
HibonsService.instance.deltaStream;           // Stream<HibonsUpdate> (broadcast)
HibonsService.instance.rankUpStream;          // Stream<RankUpEvent> (broadcast)
HibonsService.instance.detach();              // pour les tests
```

Fonctionnement :
1. `handleEnvelope` parse l'enveloppe (try/catch silencieux si parse échoue).
2. Met à jour le state via `container.read(gamificationNotifierProvider.notifier).applyUpdate(update)`.
3. Si non-silent : émet sur `_deltaController` si `delta != 0`, et sur `_rankUpController` si `rank_changed`.

### `HibonsAnimationCoordinator`

Monté **une seule fois** dans `MaterialApp.builder` ([main.dart](../../lib/main.dart)) :

```dart
return MaterialApp.router(
  ...
  scaffoldMessengerKey: scaffoldMessengerKey,
  builder: (context, child) =>
      HibonsAnimationCoordinator(child: child ?? const SizedBox()),
);
```

Le coordinateur souscrit aux streams dans `initState`, sérialise les snackbars via une queue interne (évite le télescopage en cas de mass-favoriting) :

```dart
// Pseudocode
onDelta(update):
  queue.add(update)
  drainQueue()

drainQueue (async):
  if showing: return
  while queue.isNotEmpty:
    if !mounted: return
    showing = true
    showSnackbar()       ← entouré try/catch pour éviter de bloquer la queue
    await delay(800ms)
    showing = false
```

Pour afficher la snackbar, il utilise `scaffoldMessengerKey.currentState?.showSnackBar(...)`. Pour l'overlay rank-up, il utilise `rootNavigatorKey.currentState?.overlay` directement (via `RankUpOverlay.showOnOverlay(OverlayState, ...)` qui contourne `Overlay.of(context)`).

---

## 9. Écrans et widgets modifiés

| Écran | Fichier | Changement |
|-------|---------|-----------|
| Dashboard gamification | [gamification_dashboard_screen.dart](../../lib/features/gamification/presentation/screens/gamification_dashboard_screen.dart) | Section "Répartition par pilier" insérée (donut) |
| Comment gagner des Hibons | [how_to_earn_hibons_screen.dart](../../lib/features/gamification/presentation/screens/how_to_earn_hibons_screen.dart) | **Réécrit** — consomme `actionsCatalogProvider` (la liste statique des 15 actions a été supprimée) |
| Boutique Hibons / historique | [hibon_shop_screen.dart](../../lib/features/gamification/presentation/screens/hibon_shop_screen.dart) | `ConsumerStatefulWidget` avec chips de filtre par pilier ; transactions affichent `title`, `subtitle`, `pillarColor`, thumbnail si `context.imageUrl` |
| Roue de la Fortune | [lucky_wheel_screen.dart](../../lib/features/gamification/presentation/screens/lucky_wheel_screen.dart) | Fix bug d'angle (`destinationAngle = -prizeAngle`, plus de décalage `-π/2`) |
| Badge compteur Hibons | [hibon_counter_widget.dart](../../lib/features/gamification/presentation/widgets/hibon_counter_widget.dart) | Fallback sur `hibonsBalanceProvider` pendant le chargement de `/wallet` au cold start |

---

## 10. Suppressions et nettoyage (Phase 6)

L'enveloppe globale rend les patterns suivants obsolètes — **supprimés** :

| Fichier | Suppression |
|---------|-------------|
| [favorites_provider.dart](../../lib/features/favorites/presentation/providers/favorites_provider.dart) | `_syncWalletFromReward(result)` et son appel |
| [favorite_button.dart](../../lib/features/favorites/presentation/widgets/favorite_button.dart) | Toast `+X Hibons` manuel après toggle (méthode `_showRewardToastIfAny` est devenue no-op) |
| [event_share_sheet.dart](../../lib/features/events/presentation/widgets/detail/event_share_sheet.dart) | `PetitBooToast.hibonsEarned` + `ref.invalidate(gamificationNotifierProvider)` après `trackEventShare` |
| [search_screen.dart](../../lib/features/search/presentation/screens/search_screen.dart) | Idem après `trackCategoryView` |
| [settings_screen.dart](../../lib/features/profile/presentation/screens/settings_screen.dart) | Repoll wallet + comparaison delta + toast manuel après update profil |
| [session_heartbeat_provider.dart](../../lib/features/gamification/presentation/providers/session_heartbeat_provider.dart) | `_ref.invalidate(gamificationNotifierProvider)` après heartbeat |

**Conservés** (non couverts par l'enveloppe — modifient des champs hors-balance) :

- `claimDailyReward` → invalide le wallet pour rafraîchir streak/daily_rewards
- `wheelSpin` → invalide pour rafraîchir `canSpinWheel`
- `confirmPurchase` → invalide pour le solde post-achat IAP
- `chatUnlock` → invalide pour rafraîchir le chat quota

---

## 11. SnackBar Hibons (style)

Style appliqué par le coordinateur :

| Variant | Background | Durée | Icône |
|---------|-----------|-------|-------|
| Gain (`delta > 0`) | `#2D3748` (dark) | 3 s | `Icons.monetization_on` doré (`#FFB300`) |
| Perte (`delta < 0`) | `#6B7280` (gris) | 2 s | aucune |

Comportement commun :
- `behavior: SnackBarBehavior.floating`
- `shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))`
- `margin: EdgeInsets.all(16)`
- `hideCurrentSnackBar()` avant chaque `showSnackBar` pour éviter l'empilement

---

## 12. Comportement par route

| Route | Enveloppe attendue | Mode | UI déclenchée |
|-------|-------------------|------|---------------|
| `POST /me/favorites/{uuid}/toggle` | ✅ | normal | snackbar +5 H |
| `POST /me/organizers/{slug}/follow` | ✅ | normal | snackbar +5 H |
| `POST /events/{slug}/reminders/{slot}` | ✅ | normal | snackbar +5 H |
| `POST /events/{slug}/reviews` | ✅ | normal | snackbar +40 H |
| `POST /events/{slug}/questions` | ✅ | normal | snackbar +40 H |
| `POST /events/{slug}/contact` | ✅ | normal | snackbar +10 H |
| `POST /events/{slug}/track-share` | ✅ | normal | snackbar +10 H |
| `POST /categories/{slug}/track-view` | ✅ | normal | snackbar +20 H |
| `POST /mobile/hibons/session-heartbeat` | ✅ | normal | snackbar +10 H |
| `PUT/PATCH /account/profile` | ✅ | normal | snackbar +30/50 H |
| `POST /mobile/hibons/wheel` | ✅ | **silent** | dialog custom après animation 5 s |
| `POST /mobile/hibons/daily` | ✅ | **silent** | animation custom daily |
| Stripe webhook (booking) | ❌ (différé +10 min) | — | push notification serveur |

---

## 13. Comment tester

### Cas nominal — favori
1. Hot restart (cold-start le service).
2. Naviguer sur un event, taper le cœur "Ajouter favori".
3. Observer :
   - Logs `🪙 HibonsUpdateInterceptor: envelope detected on /me/favorites/{uuid}/toggle`
   - SnackBar "+5 Hibons 🪙 gagnés !" en bas de l'écran
   - Badge compteur Hibons en haut à droite : valeur incrémentée
   - **Aucun appel** à `GET /wallet` après le toggle (vérifier les logs Dio)

### Cas silent — roue
1. Naviguer sur "Roue de la Fortune".
2. Lancer la roue.
3. Observer :
   - Logs `🪙 HibonsUpdateInterceptor: envelope detected on /mobile/hibons/wheel (silent=true)`
   - **Aucune snackbar** pendant l'animation
   - Le segment gagnant correspond bien au prix renvoyé par l'API
   - Dialog "Félicitations !" affiché après les 5 s d'animation
   - Badge compteur incrémenté

### Cas rank-up
1. Avoir un compte juste sous un palier (~990 Hibons pour Aventurier à 1000).
2. Effectuer une action gratifiante (favori, follow…) pour franchir le palier.
3. Observer :
   - SnackBar "+X Hibons" + overlay rank-up "Bravo, tu es maintenant Aventurier !" plein écran
   - Auto-dismiss après 6 s ou tap "Continuer"

### Cas catalogue dynamique
1. Naviguer sur "Comment gagner des Hibons".
2. Observer :
   - Logs `GET /mobile/hibons/actions-catalog`
   - Liste de 15 actions groupées par pilier
   - Compteurs `completed/remaining` selon le scope du cap
   - Actions atteintes grisées avec badge "Atteint"

### Cas filtre transactions
1. Naviguer sur "Boutique Hibons" (section Historique).
2. Taper un chip pillar (ex : "Découverte").
3. Observer :
   - Logs `GET /mobile/hibons/transactions?pillar=discovery`
   - Liste filtrée

---

## 14. Logs de diagnostic

Tous les logs Hibons sont préfixés `🪙` pour faciliter le filtrage :

```
🪙 HibonsService: attached to ProviderContainer       ← cold start
🪙 HibonsAnimationCoordinator: subscribing to streams ← coordinator mounted
🪙 HibonsUpdateInterceptor: envelope detected on {path} (silent={bool}) → {...}
🪙 HibonsService: parsed update delta=X balance=Y rankChanged=...
🪙 HibonsService: emitting delta on stream (delta=X)
🪙 HibonsAnimationCoordinator: enqueue toast delta=X
🪙 HibonsAnimationCoordinator: showing snackbar delta=X
```

Si un maillon est absent, voir le tableau diagnostic dans la conversation initiale.

---

## 15. Limitations et notes pour la suite

- **Booking confirmation** : pas d'enveloppe sur le webhook Stripe (crédit différé +10 min côté serveur). Le toast doit venir d'une push notification ou polling.
- **Actions v2** non câblées : `ticket_checked_in` (75 H) et `referral_validated` (150 H) ne sont pas exposées par le backend, ne pas les ajouter à la main.
- **Donut profil** : dépend de `/transactions` étant appelé au moins une fois par session. Le dashboard l'appelle au build, donc OK en pratique. Si l'utilisateur deep-link directement ailleurs, le donut sera vide jusqu'à la première visite du dashboard.
- **Locale** : le backend respecte `X-Locale` ou `Accept-Language`. À vérifier que l'app envoie bien l'un de ces headers (à confirmer hors scope Plan 05).
- **i18n côté Flutter** : les libellés UX (boutons, écrans) restent en `.arb` Flutter. Les champs localisés côté serveur (`rank_label`, `pillar_label`, transaction `title`, `cap_text`) sont affichés tels quels.
- **`setBalance(int)`** est conservé sur le notifier comme primitive bas niveau (utilisable pour les tests). `applyUpdate(HibonsUpdate)` est la méthode canonique côté production.
- **Toasts custom obsolètes** : `PetitBooToast.hibonsEarned` et `PetitBooToast.hibonsEarnedOnOverlay` existent encore mais ne sont plus appelés par le pipeline Hibons. Ils peuvent être supprimés dans un nettoyage ultérieur.

---

## 16. Référence backend

Voir [docs/hibons/05-mobile-update-spec.md](05-mobile-update-spec.md) pour la spec complète. Côté Laravel :

- Middleware : `api/app/Http/Middleware/AppendHibonsUpdate.php`
- Resource transactions : `api/app/Http/Resources/HibonTransactionResource.php`
- Observer cache : `api/app/Observers/HibonTransactionObserver.php`
- Routes : `api/routes/api.php` (chercher `balance`, `actions-catalog`, `hibons.update`)
- i18n : `api/lang/{fr,en,es,de,nl,ar}/hibons.php`
