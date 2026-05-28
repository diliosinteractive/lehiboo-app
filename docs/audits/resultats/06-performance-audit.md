# Audit — Axe 06 Performance

Date : 2026-05-28 · Branche : `main` · Auditeur : Claude (+ agent exploration) · Plan : [06-performance.md](../plans/06-performance.md)

## Synthèse
- **État global : 🟠 Majeur (socle correct)** — les bases sont bonnes (`ListView.builder` sur les listes principales, `VisibilityDetector` sur le carrousel hero, dispose des controllers vidéo/anim). Mais plusieurs **sources de jank mesurables** : `setState` sur tout l'écran à chaque pixel de scroll (home + détail event), **aucune image dimensionnée** (`memCacheWidth` jamais utilisé sur 56 `CachedNetworkImage`), markers de carte reconstruits à chaque pan/zoom, et `LeHibooApp.build()` qui observe 11 providers globaux.
- Constats : **0 🔴 · 6 🟠 P1 · 8 🟡 P2 · 6 🟢 P3**
- **Top 3 actions** :
  1. Isoler l'AppBar du scroll (`ValueNotifier`/sous-widget) pour stopper le rebuild plein écran (home + détail).
  2. Ajouter `memCacheWidth` aux images (vignettes décodent du plein format).
  3. Mémoïser `_buildMarkers()` + isoler les watches de `LeHibooApp`.

> Réconciliation : les 2 « P0 » de l'agent (`setState` au scroll) sont re-classés **🟠 P1** (jank fort, pas un crash/blocage) — priorité n°1 dans cet axe.

---

## Constats détaillés

### 🟠 P1 — Jank / rebuilds coûteux
| # | Constat | Fichier:ligne | Recommandation | Effort |
|---|---------|---------------|----------------|--------|
| P1-1 | **`HomeScreen._onScroll` → `setState` plein écran à 60 Hz** : reconstruit tout le `CustomScrollView` (12+ slivers : hero, stories, sections) alors que seul `_scrollOffset` (opacité AppBar) change. | [home_screen.dart:67-71](../../../lib/features/home/presentation/screens/home_screen.dart#L67-L71) | Isoler l'AppBar (`ValueNotifier<double>` + `ValueListenableBuilder` ou sous-widget avec son propre listener). | S |
| P1-2 | **`EventDetailScreen._onScroll` → même anti-pattern** : rebuild des 14+ sections de la fiche à chaque pixel. | [event_detail_screen.dart:239-243](../../../lib/features/events/presentation/screens/event_detail_screen.dart#L239-L243) | Idem P1-1. | S |
| P1-3 | **Aucune image dimensionnée** : `memCacheWidth`/`memCacheHeight` jamais utilisé (0 résultat) sur **56 `CachedNetworkImage`** (41 fichiers). Des vignettes 60-180 px décodent des images 1200 px+ en RAM (10-40 Mo RGBA par feed). | global (event_stories, booking_list_card, countdown_event_card, event_similar_carousel…) | Ajouter `memCacheWidth` ≈ 2× la taille d'affichage. | M |
| P1-4 | **`_buildMarkers()` reconstruit tous les markers** (Stack/Column/GestureDetector/Image.asset) depuis zéro à chaque `setState` (pan/zoom), avec tri O(n) par `_selectedIndex`. Pas de mémo ni clustering. | [map_view_screen.dart:185-352](../../../lib/features/events/presentation/screens/map_view_screen.dart#L185-L352) | Mémoïser markers (clé = events + `_selectedIndex`) ; envisager clustering. | M |
| P1-5 | **`LeHibooApp.build()` observe 11 providers globaux sans `.select`** : tout changement d'`authProvider`/`sessionHeartbeat` reconstruit `MaterialApp.router` + DeeplinkListener + HibonsAnimationCoordinator. (Recoupe [audit 03](03-state-management-riverpod-audit.md) P1-1.) | [main.dart:304-374](../../../lib/main.dart#L304-L374) | Déplacer les watches sous un `_AppProviderWatcher` ; `authProvider.select((s)=>s.status)`. | M |
| P1-6 | **`Image.network` brut (sans cache)** : re-télécharge à chaque rebuild. | [booking_summary_card.dart:28](../../../lib/features/booking/presentation/widgets/booking_summary_card.dart#L28), [city_detail_screen.dart:222](../../../lib/features/home/presentation/screens/city_detail_screen.dart#L222) | `CachedNetworkImage` + `memCacheWidth`. | S |

> `_buildAppBar` observe aussi `orderCartProvider`/`authProvider` entiers ([home_screen.dart:246-249](../../../lib/features/home/presentation/screens/home_screen.dart#L246-L249)) — résolu en même temps que P1-1 (extraction + `.select`). Les `debugPrint` non gardés en datasource events / `event_list_screen` (s'exécutent en release) recoupent [audit 11](11-observabilite-crash-analytics-audit.md).

### 🟡 P2 — À traiter prochainement
| # | Constat | Fichier:ligne | Recommandation |
|---|---------|---------------|----------------|
| P2-1 | **`CountdownEventCard` : 3 variants × (`Timer.periodic(1s)` + `AnimationController.repeat`)** sans pause hors viewport (contrairement au hero). N cards visibles = N timers + N anim. | [countdown_event_card.dart:55-63,558,923](../../../lib/features/home/presentation/widgets/countdown_event_card.dart#L55-L63) | Wrapper `VisibilityDetector` pour suspendre timer + pulse. |
| P2-2 | **`MainScaffold` : `Timer.periodic(5s)` permanent** appelle `checkIdle()` sur Petit Boo toute la session, même si jamais ouvert. | [main_scaffold.dart:36](../../../lib/core/widgets/main_scaffold.dart#L36) | Pause via `AppLifecycleListener` / désactiver hors contexte Petit Boo. |
| P2-3 | **`_StoryCircle._shimmerController.repeat()`** par story non vue (8 stories = 8 anim) ; tournent même hors viewport horizontal. | [event_stories.dart:207-236](../../../lib/features/home/presentation/widgets/event_stories.dart#L207-L236) | `VisibilityDetector` ou un controller mutualisé. |
| P2-4 | **Listes non virtualisées** (`ListView(children:[...map()])`) sur des écrans potentiellement longs : reminders, event_questions (3×), memberships, gamification. | reminders_list_screen.dart:57-72, event_questions_screen.dart:214/238/632, memberships_screen.dart:219-273 | `ListView.builder` pour reminders/questions. |
| P2-5 | **JSON parsé sur le main isolate** : `HomeFeedDataDto.fromJson` (feed complet) et `EventsResponseDto.fromJson` (20 events × ~50 champs imbriqués). 0 usage de `compute()`/`Isolate.run()`. | events_api_datasource.dart, home_providers.dart | `compute(...)` pour les gros payloads. |
| P2-6 | **`_VideoThumbnail` initialise un `VideoPlayerController.networkUrl` par story vidéo** (probe metadata) pour un simple poster → connexions réseau multiples au scroll. | [event_stories.dart:438-471](../../../lib/features/home/presentation/widgets/event_stories.dart#L438-L471) | Poster statique fourni par l'API. |
| P2-7 | **8 `RegExp` recréées à chaque frappe** dans l'indicateur de force du mot de passe. | [password_strength_indicator.dart:115-143](../../../lib/features/auth/presentation/widgets/password_strength_indicator.dart#L115-L143) | `static final RegExp`. |
| P2-8 | **`RegExp(uuidPattern)` recréée dans `_looksLikeUuid()`** appelé à chaque rebuild de la sticky bar. | [event_detail_screen.dart:1482](../../../lib/features/events/presentation/screens/event_detail_screen.dart#L1482) | `static final RegExp`. |

### 🟢 P3 — Améliorations diffuses
- **`const` manquants à ~33 %** (~858 widgets statiques non-const vs 1756 const) — concentrés dans filter_bottom_sheet, airbnb_search_sheet, event_detail_screen. Activer/respecter `prefer_const_constructors` (recoupe les 1171 issues de [audit 02](02-qualite-code-conventions-audit.md)). *(L)*
- **`RepaintBoundary` absent** sur les sections indépendantes de la home (un rebuild stories invalide le repaint des autres).
- **`itemExtent`/`prototypeItem` jamais utilisés** sur les listes à hauteur fixe (notifications, reminders, bookings).
- **`MediaQuery.of(context)`** (38 occurrences) au lieu de `MediaQuery.sizeOf` (abonnement sélectif).
- **Boot séquentiel** : 6-7 `await` avant `runApp` (Firebase ~200-400 ms, Stripe `applySettings` ~50-100 ms) → différer `Stripe.applySettings()` après le first frame si possible ; mesurer en `--profile`.
- **Polling messages** : jusqu'à 5 `Timer.periodic` simultanés en mode dégradé (WS down) — surcharge réseau, pas jank (correctement bypassés quand Pusher actif).

---

## Points conformes (✅)
- **Carrousel hero** : `VisibilityDetector` (seuil 25 %) suspend le `Timer.periodic` hors écran — **pattern de référence** à étendre aux countdown cards/stories.
- **Listes principales virtualisées** : `event_list_screen` (`ListView.builder` + pagination), `bookings_list_screen` (`builder`), `notifications_inbox_screen` (`separated`), `favorites_screen` (`GridView.builder`).
- **Dispose propre** : controllers vidéo (`StoryVideoPlayer`, `_VideoThumbnail`), animations (`_shimmer/_pulse/_shake/_bounce/_scale`), `ConfettiController`.
- **Skeletons** : `SkeletonEventCard` (shimmer) pendant le chargement de la home.
- **Galerie** : `PageView.builder` (lazy) + `InteractiveViewer`.

## Annexes
- Source : agent code-explorer (108 outils, ~612 s). Réconciliations de gravité appliquées (2× P0→P1).
