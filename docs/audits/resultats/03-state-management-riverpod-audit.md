# Audit — Axe 03 State management (Riverpod)

Date : 2026-05-28 · Branche : `main` · Auditeur : Claude (+ agent exploration) · Plan : [03-state-management-riverpod.md](../plans/03-state-management-riverpod.md)

## Synthèse
- **État global : 🟠 Majeur (socle sain)** — Riverpod est utilisé avec compétence : **tous les providers à ressources actives (WebSocket, timers, SSE) ont un `dispose()` propre**, le pattern auth-listener + invalidations ciblées est cohérent, et `.select()` est utilisé sur les transitions critiques. Les défauts sont surtout des **`autoDispose` manquants** (cache/état périmé), un **bloc d'init surchargé dans `LeHibooApp.build()`**, et quelques **`.value!` non sûrs**.
- Constats : **0 🔴 · 5 🟠 P1 · 8 🟡 P2 · 3 🟢 P3**
- **Top 3 actions** :
  1. Extraire l'init globale de `LeHibooApp.build()` dans un `AppInitializer` monté une fois.
  2. Passer en `autoDispose` les providers transitoires non libérés + déplacer les providers déclarés dans des fichiers widgets.
  3. Sécuriser les `.value!` (→ `valueOrNull` / `.when`).

> Réconciliation : les 3 constats « P0 » de l'agent (init dans build, `eventsListProvider` non-autoDispose, `.value!`) sont **re-classés 🟠 P1** — aucun n'est une fuite ou un crash garanti en usage normal (l'agent note « inoffensif ici » / « race théorique »).

---

## Constats détaillés

### 🟠 P1 — Majeurs
| # | Constat | Fichier:ligne | Recommandation | Effort |
|---|---------|---------------|----------------|--------|
| P1-1 | **`LeHibooApp.build()` surchargé** : ~15 `ref.watch` globaux (Pusher, heartbeat, activeOrg, push) + réassignation de `DioClient.onForceLogout` à **chaque rebuild** (déclenché par tout changement d'`authState`). Ré-exécution coûteuse non bornée (pas une fuite). | [main.dart:305-350](../../../lib/main.dart#L305-L350) | Déplacer l'init dans un `ConsumerStatefulWidget` `AppInitializer` (initState + `ref.listen`), monté une fois. | M |
| P1-2 | **`eventsListProvider` (`FutureProvider.family`) non-autoDispose** : chaque combinaison de params crée une entrée cache jamais libérée. **Redondant** avec `filteredEventsProvider`. | [event_list_screen.dart:19-71](../../../lib/features/events/presentation/screens/event_list_screen.dart#L19-L71) | `autoDispose.family` + unifier avec `filteredEventsProvider`. | S |
| P1-3 | **`.value!` non sûrs** (crash si l'AsyncValue repasse en loading entre le `hasValue` et l'accès). | [map_view_screen.dart:488,673](../../../lib/features/events/presentation/screens/map_view_screen.dart#L488), [categories_chips_section.dart:37](../../../lib/features/thematiques/presentation/widgets/categories_chips_section.dart#L37), [city_detail_screen.dart:271](../../../lib/features/home/presentation/screens/city_detail_screen.dart#L271) | `valueOrNull?.x ?? []` ou `.when(...)`. | S |
| P1-4 | **Providers persistants (keepAlive) sans justification** détenant ressources/état user-scoped : `vendorBroadcastsProvider`, `categoryHistoryProvider`, `viewedStoriesProvider`, `savedSearchesProvider`, `wheelSpinProvider`, `purchaseNotifierProvider`, `chatUnlockProvider`. | voir tableau agent (vendor_broadcasts_provider.dart:189, personalized_section.dart:19, event_stories.dart:20, home_providers.dart:743, gamification_provider.dart:127,222,277) | Passer en `autoDispose` ; déplacer les providers widget-level. | M |
| P1-5 | **`filteredEventsProvider` : pagination logée dans `eventFilterProvider`** → `setPage()`/`nextPage()` muter le filtre retrigger tous ses watchers (rebuilds en cascade) ; provider non-autoDispose sans `ref.onDispose`. | [filter_provider.dart:748-806](../../../lib/features/search/presentation/providers/filter_provider.dart#L748-L806) | Sortir la pagination dans l'état interne du notifier ; `autoDispose`/`keepAlive` explicite. | L |

### 🟡 P2 — Moyens
| # | Constat | Fichier:ligne | Recommandation |
|---|---------|---------------|----------------|
| P2-1 | `petitBooChatProvider` (SSE, non-autoDispose par design) : `_streamSubscription` annulée dans `dispose()`/`sendMessage()` mais **pas dans `_initialize()`** (re-appelée après login) → coexistence possible de 2 souscriptions. | [petit_boo_chat_provider.dart:141-165](../../../lib/features/petit_boo/presentation/providers/petit_boo_chat_provider.dart#L141-L165) | `await _streamSubscription?.cancel()` en tête de `_initialize()`. |
| P2-2 | **Manque de `.select()`** sur des providers volumineux : `ref.watch(authProvider).user` et `ref.watch(orderCartProvider)` dans `_buildAppBar` rebuild pour tout changement d'état. | [home_screen.dart:246-249](../../../lib/features/home/presentation/screens/home_screen.dart#L246-L249) (+ profile/messages/settings) | `authProvider.select((s) => s.user)`, `.select` sur le compte panier. |
| P2-3 | `_broadcastDetailProvider` (`FutureProvider.family` non-autoDispose) avec Timer de poll dans le widget → état périmé en cache. | [broadcast_detail_screen.dart:9-38](../../../lib/features/messages/presentation/screens/broadcast_detail_screen.dart#L9-L38) | `autoDispose.family` + poll dans le provider via `ref.onDispose`. |
| P2-4 | `_reportDetailProvider` (`StateNotifierProvider.family` non-autoDispose) déclaré dans un fichier écran. | [admin_report_detail_screen.dart:131-134](../../../lib/features/messages/presentation/screens/admin_report_detail_screen.dart#L131-L134) | `autoDispose.family`. |
| P2-5 | Effet de bord conditionnel (`_startPolling`) dans `build()` via `whenData` + `addPostFrameCallback`. | [broadcast_detail_screen.dart:51-57](../../../lib/features/messages/presentation/screens/broadcast_detail_screen.dart#L51-L57) | Utiliser `ref.listen()` pour l'effet de bord. |
| P2-6 | `eventFilterProvider._loadPersistedFilters()` appelle `SharedPreferences.getInstance()` directement au lieu de `sharedPreferencesProvider` (double instanciation, contourne le DI). | [filter_provider.dart:84-87](../../../lib/features/search/presentation/providers/filter_provider.dart#L84-L87) | Injecter via le provider. |
| P2-7 | **Invalidation en cascade au logout** : `_invalidateUserScopedProviders()` invalide 11 providers ; ceux watchés par `LeHibooApp.build()` (ex. `conversationsProvider`) se reconstruisent (requête 401) pendant la déconnexion. | [auth_provider.dart:398-422](../../../lib/features/auth/presentation/providers/auth_provider.dart#L398-L422) | Vérifier que les providers invalidés sont `autoDispose` ou ignorent les rebuilds post-logout. |
| P2-8 | `DioClient.onForceLogout` / `HibonsService.instance` : **singletons mutables hors Riverpod** (le `StreamController` Hibons n'est jamais fermé en prod). | [main.dart:309-310](../../../lib/main.dart#L309), [hibons_service.dart:24-154](../../../lib/features/gamification/application/hibons_service.dart#L24-L154) | Intercepteur/coordinateur Riverpod-aware ; `detach()` dans `ref.onDispose` du container. (Recoupe [audit 01](01-architecture-structure-audit.md) P2-7.) |

### 🟢 P3 — Mineurs
- **Pagination dans le filtre** (design smell) : `EventFilter.page` sérialisé en URL → comportement surprenant si deeplink `page=5` ([filter_provider.dart:541-551](../../../lib/features/search/presentation/providers/filter_provider.dart#L541-L551)).
- **Providers déclarés dans des fichiers widgets** (`categoryHistoryProvider`, `viewedStoriesProvider`) → singletons d'app au lieu de providers de feature.
- **Dualité confuse** `eventsListProvider` vs `filteredEventsProvider` (requêtes dupliquées). → unifier (recoupe P1-2/P1-5).

---

## Points conformes (✅)
- **Dispose propre partout** : `MessagesRealtimeNotifier` (5 subscriptions Pusher + close client), `Conversations/VendorConversations/Support/AdminConversationsNotifier` (Timer + StreamSubscription), `SessionHeartbeatNotifier` (`WidgetsBindingObserver` désenregistré), `PetitBooChatNotifier` (SSE).
- **autoDispose bien appliqué** sur les transitoires : `conversationDetailProvider`, `bookingFlowControllerProvider`, `eventQuestionsListControllerProvider`, `businessRegisterProvider`, `searchSuggestionsProvider`, `filterPreviewCountProvider`.
- **`.select()`** sur 12 transitions auth-aware (alerts, favorites, booking list, reminders, reviews, petit_boo, checkin).
- **Family à clés équatables** (`EventsListParams`, `SearchSuggestionsRequest`, records Dart 3).
- **Aucun `ref.watch` dans un callback** (recherche systématique : 0 occurrence).
- **`AsyncValue.guard`** utilisé (`GamificationNotifier.refresh`, `HomeFeedNotifier`).

## Annexes
- Source : agent code-explorer (73 outils, ~429 s). Réconciliations de gravité appliquées (3× P0→P1).
