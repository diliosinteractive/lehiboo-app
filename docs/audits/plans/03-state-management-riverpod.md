# Plan 03 — State management (Riverpod)

Objectif : auditer l'usage de Riverpod (cycle de vie, fuites, scope de rebuild,
initialisation eager au boot) pour fiabilité et performance.

## Périmètre
- Tous les `*_provider.dart`, `*_controller.dart`, `*_notifier.dart`
- `lib/core/providers/`, `lib/main.dart` (container + overrides + watches globaux)

## Risques connus / hypothèses
- ⚠️ **`main.dart` `build()` observe de nombreux providers globaux** (push, in-app notifs, realtime Pusher, conversations selon rôle, heartbeat Hibons, auth sync, active org). Un rebuild de `LeHibooApp` ré-évalue tout ce bloc → vérifier le scope.
- ⚠️ **DI par overrides manuels** dans un `ProviderContainer` explicite ; `HibonsService.instance.attach(container)` = singleton lisant l'état hors `Ref` (couplage).
- ⚠️ Providers globaux **non `autoDispose`** susceptibles de retenir des ressources (WebSocket, listeners, timers).

## Checklist
- [ ] **`autoDispose` vs `keepAlive`** : chaque provider justifie son cycle de vie. Les providers liés à un écran doivent être `autoDispose`.
- [ ] **Fuites** : `StreamSubscription`, `Timer`, `AnimationController`, channels Pusher, SSE — tous fermés dans `dispose`/`ref.onDispose`.
- [ ] **`ref.watch` vs `ref.read` vs `ref.listen`** : pas de `watch` dans un callback ; pas de `read` réactif attendu ; `listen` pour les effets de bord.
- [ ] **Scope de rebuild** : usage de `select`/`ref.watch(provider.select(...))` pour éviter les rebuilds larges ; découper les `Consumer`/`ConsumerWidget`.
- [ ] **Boot global ([main.dart:304-350](../../../lib/main.dart#L304-L350))** : déplacer les `ref.watch` globaux dans un widget dédié monté une fois (éviter la ré-évaluation à chaque rebuild de `LeHibooApp`).
- [ ] **Effets de bord pendant `build`** : aucun appel réseau / mutation déclenché directement dans `build`.
- [ ] **`family`** : clés stables (pas d'objet recréé à chaque build → cache cassé).
- [ ] **Codegen Riverpod** : cohérence entre providers `@riverpod` générés et providers manuels (`Provider`, `StateNotifierProvider`, `NotifierProvider`).
- [ ] **Gestion d'erreur d'état** : `AsyncValue` correctement géré (`when`/`maybeWhen`), pas de `.value!` non gardé.
- [ ] **Invalidation** : `ref.invalidate`/`refresh` ciblés (ex. wallet Hibons au login/logout) sans cascade involontaire.
- [ ] **`riverpod_lint`** : zéro alerte (providers non utilisés, `ref` mal scopé, manque de `autoDispose`).

## Commandes / mesures
```bash
dart run custom_lint   # riverpod_lint inclus

# Providers globaux (sans autoDispose) — candidats à fuite
rg -n "Provider(\.family)?<" lib --glob '!*.g.dart' | rg -v "autoDispose"

# Souscriptions / timers — vérifier leur fermeture
rg -n "\.listen\(|StreamSubscription|Timer\(|Timer\.periodic" lib --glob '!*.g.dart'
rg -n "onDispose|dispose\(\)" lib --glob '!*.g.dart'

# Usage de select (bon signe pour le scope de rebuild)
rg -n "\.select\(" lib --glob '!*.g.dart' | wc -l
```

## Livrable
Carte des providers (cycle de vie, keepAlive justifié ou non), liste des fuites potentielles (subscriptions/timers non fermés), recommandation de refactor du bloc d'init global de `main.dart`.
