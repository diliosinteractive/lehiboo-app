# Étape 9 — Routage des deeplinks & correctifs post-intégration

> Date : 2026-05-22
> Ce document consigne les bugs rencontrés après le branchement initial du
> `DeeplinkListener` et les recommandations de routage qui en découlent.

---

## 1. Correctifs appliqués

### Fix #1 — `No GoRouter found in context`

**Symptôme**

```
[DeeplinkListener] go() failed, deferring:
'package:go_router/src/router.dart': Failed assertion: line 521 pos 12:
'inherited != null': No GoRouter found in context
```

**Cause**

`DeeplinkListener` est monté dans le `builder:` de `MaterialApp.router`
([lib/main.dart](../../lib/main.dart)). Le `BuildContext` de ce `builder` se
situe **au-dessus** de l'`InheritedGoRouter` que go_router insère dans l'arbre.
`GoRouter.of(context)` remonte l'arbre à la recherche de cet inherited widget,
ne le trouve pas, et lève l'assertion.

**Correctif** — [lib/core/deeplinks/deeplink_listener.dart](../../lib/core/deeplinks/deeplink_listener.dart)

On récupère l'instance `GoRouter` via Riverpod plutôt que via le context :

```dart
// ❌ Avant — dépend de l'InheritedGoRouter dans le context
GoRouter.of(context).go(route);

// ✅ Après — singleton Riverpod, indépendant de l'arbre de widgets
ref.read(routerProvider).go(route);
```

C'est la **même** instance que celle passée à `routerConfig:` dans `main.dart`
(`ref.watch(routerProvider)`), donc la navigation cible bien le router actif.
Avantage : robuste quel que soit l'endroit où le widget est monté.

**Règle générale** : pour naviguer depuis un widget monté haut dans l'arbre
(au-dessus du `Navigator`/`Router`), toujours utiliser `ref.read(routerProvider)`
et jamais `GoRouter.of(context)`.

---

### Fix #2 — `There is nothing to pop`

**Symptôme**

```
The following GoError was thrown while handling a gesture:
There is nothing to pop
#0  GoRouterDelegate.pop
...
_EventDetailScreenState._buildOverlayAppBar.<anonymous closure>
(event_detail_screen.dart:634)
```

**Cause**

`router.go('/events/{slug}')` **remplace** toute la pile de navigation par la
location calculée depuis la hiérarchie de routes. Comme `/events/:id` est une
route top-level, la pile ne contient qu'une seule entrée. Quand l'utilisateur
tape sur le bouton retour, `context.pop()` n'a rien à dépiler → crash.

**Correctif** — [event_detail_screen.dart](../../lib/features/events/presentation/screens/event_detail_screen.dart)

On reprend la convention déjà utilisée dans les écrans `messages` :

```dart
// ❌ Avant — crashe si la pile est vide (arrivée par deeplink)
onTap: () => context.pop(),

// ✅ Après — fallback vers la home quand il n'y a rien à dépiler
onTap: () => context.canPop() ? context.pop() : context.go('/'),
```

Appliqué aux **deux** boutons retour de l'écran :
- App bar overlay (bouton flottant en haut à gauche)
- Écran d'erreur / 404 (event introuvable atteint par deeplink)

---

## 2. Recommandations de routage

### `go()` vs `push()`

| | `router.go(route)` | `router.push(route)` |
|---|---|---|
| Pile | **Remplace** la pile par la location | **Empile** par-dessus la pile existante |
| URL / location | Synchronisée avec la route | Inchangée à la base, route empilée |
| Retour (`pop`) | Rien à dépiler pour une route top-level → besoin du fallback `canPop` | Revient naturellement à l'écran précédent |
| Cas d'usage | Cold start, point d'entrée canonique | Préserver le contexte courant (warm start) |

### Choix actuel : `go()` + fallback `canPop`

**Pourquoi `go()`** :
1. Façon canonique de traiter un deeplink dans go_router : « la location, c'est cette URL ». L'état de navigation reflète exactement le lien.
2. Au cold start, il n'existe pas de pile fiable sur laquelle empiler — `go()` construit une pile cohérente quoi qu'il arrive.
3. Un seul chemin de code pour cold et warm start.

**Prix à payer** : `go()` écrase la pile → le retour n'a rien à dépiler.
Corrigé par le pattern `canPop() ? pop() : go('/')` sur les écrans cibles.

### Limite connue (warm start)

Si l'utilisateur est en train de naviguer dans l'app (ex. plein milieu d'un
flow de réservation) et clique un lien partagé depuis une autre app, `go()`
**efface son contexte** et le ramène à l'event seul. Le retour le renvoie à la
home, pas là où il était.

### Évolution possible — hybride `go` / `push`

Pour préserver le contexte en warm start, on peut router selon l'origine. Le
flag `coldStart` circule déjà jusqu'à `_navigate` dans le listener :

```dart
void _navigate(Uri uri, {required bool coldStart}) {
  // ... mapping + analytics ...
  final router = ref.read(routerProvider);
  if (coldStart) {
    router.go(route);   // pas de contexte à préserver
  } else {
    router.push(route); // garde la pile de l'utilisateur, retour naturel
  }
}
```

**Trade-offs de l'hybride** :
- ✅ Warm start : le retour ramène l'utilisateur exactement où il était.
- ⚠️ `push()` répété (l'utilisateur clique plusieurs liens d'affilée) empile
  plusieurs écrans event. Acceptable, mais la pile grandit.
- ⚠️ Si la location de base au warm start n'est pas « propre » (ex. on est sur
  un sheet/modal), `push()` peut produire une pile inattendue. À tester.

**Statut** : non implémenté en phase 1. `go()` + `canPop` est jugé suffisant
car la grande majorité des deeplinks sont ouverts app fermée (cold start) ou
app en background sur la home.

---

## 3. Convention pour les écrans atteignables par deeplink

Tout écran qui peut être un **point d'entrée deeplink** (actuellement
`EventDetailScreen`, demain `/booking/{uuid}`, `/organizers/{slug}`, etc.) doit :

1. **Ne jamais appeler `context.pop()` nu** sur ses boutons retour.
   Toujours `context.canPop() ? context.pop() : context.go('<fallback>')`.
2. Choisir un **fallback pertinent** :
   - Event detail → `/` (home)
   - Booking/ticket → `/` ou `/bookings` selon le contexte
   - Messages → `/messages` (déjà en place)
3. Gérer l'**état 404 / introuvable** avec un bouton retour qui utilise le même
   fallback (un deeplink peut pointer vers une ressource supprimée).

---

## 4. Récapitulatif des fichiers touchés par ces correctifs

| Fichier | Changement |
|---------|-----------|
| [lib/core/deeplinks/deeplink_listener.dart](../../lib/core/deeplinks/deeplink_listener.dart) | `ref.read(routerProvider).go()` au lieu de `GoRouter.of(context).go()` ; suppression de l'import `go_router` (plus nécessaire) |
| [lib/features/events/presentation/screens/event_detail_screen.dart](../../lib/features/events/presentation/screens/event_detail_screen.dart) | Les 2 boutons retour utilisent `canPop() ? pop() : go('/')` |

---

## 5. À reporter dans la QA

Ajouter ces vérifications à la matrice de [07_TESTING_QA.md](07_TESTING_QA.md) :

- [ ] Deeplink cold start → tap retour sur le détail event → arrive sur la home (pas de crash)
- [ ] Deeplink vers un event 404 → tap retour sur l'écran d'erreur → arrive sur la home
- [ ] Deeplink warm start → tap retour → comportement attendu selon le choix `go`/`push` retenu
