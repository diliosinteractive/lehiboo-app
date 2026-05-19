# Étape 3 — Tracking de navigation (screen_view)

Objectif : envoyer automatiquement un event `screen_view` GA4 à chaque changement de route, sans avoir à instrumenter manuellement chaque écran.

## 3.1 Brancher `FirebaseAnalyticsObserver` sur GoRouter

Fichier à modifier : [lib/routes/app_router.dart](../../lib/routes/app_router.dart) (`routerProvider`, ligne ~126).

Le `GoRouter` accepte un paramètre `observers` (liste de `NavigatorObserver`). `firebase_analytics` fournit `FirebaseAnalyticsObserver` qui en hérite.

```dart
final routerProvider = Provider<GoRouter>((ref) {
  final analytics = ref.read(analyticsServiceProvider);
  // ...
  return GoRouter(
    observers: [analytics.observer],
    // ...
  );
});
```

⚠️ **Piège GoRouter v14** : `observers` n'est appliqué qu'au `Navigator` racine. Les sous-routes `ShellRoute` ou `StatefulShellRoute` ont leurs propres Navigators et **n'envoient pas** d'event sauf si on passe aussi `observers` à chaque `ShellRoute.observers`. À vérifier dans le router actuel (présence d'un shell pour la bottom nav).

## 3.2 Nommage des écrans

`FirebaseAnalyticsObserver` lit `Route.settings.name` pour remplir `screen_name`. GoRouter remplit ce nom à partir du **`name:` de la `GoRoute`**, pas du `path`.

→ Vérifier que **toutes les `GoRoute` ont un `name:` court et explicite** (ex: `event_detail`, `booking_payment`, `petit_boo_chat`). Sans `name:`, le screen_view arrive avec `null` et est inutile.

À auditer : grep `GoRoute(` dans `lib/routes/app_router.dart`, lister les routes sans `name`, en ajouter un.

## 3.3 Routes paramétrées

GoRouter passe les paramètres de chemin dans `state.pathParameters` mais pas dans `screen_name`. Pour les fiches événement, par défaut on aura :

- `screen_name = "event_detail"` (sans l'UUID) → bon pour l'agrégation.

Si on veut conserver l'UUID, **ne pas le mettre dans le screen_name** (sinon haute cardinalité, GA4 va sampler). À la place, logguer un event custom `event_viewed` (cf. [05_EVENT_CATALOG.md](05_EVENT_CATALOG.md)) avec `event_uuid` en paramètre, depuis le `initState` de l'écran de détail.

## 3.4 Modaux et bottom sheets

Les `showModalBottomSheet` / `showDialog` créent des routes et déclenchent aussi le `didPush` de l'observer. Risque : `screen_name` devient `null` ou `_BottomSheet`. Deux options :

- **Filtrer** dans une sous-classe de `FirebaseAnalyticsObserver` (override `didPush` pour ignorer les `ModalRoute` sans settings.name).
- **Nommer** chaque bottom sheet via `RouteSettings(name: 'search_modal')` à l'appel.

L'app utilise plusieurs sheets importantes (`AirbnbSearchSheet`, `SaveSearchSheet`, `FilterBottomSheet` — cf. [CLAUDE.md](../../CLAUDE.md)). Décider feuille par feuille si elles méritent un `screen_view` ou un event custom.

## 3.5 Cas particulier : Petit Boo

L'écran Petit Boo a 3 routes (cf. [CLAUDE.md](../../CLAUDE.md)) :

- `/petit-boo`
- `/petit-boo?session=xxx`
- `/petit-boo?message=xxx`

Le `screen_name` sera identique pour les 3. C'est OK pour mesurer "combien de personnes ouvrent le chat", mais pour distinguer "ouverture depuis VoiceFab" vs "reprise de session", il faut un event custom (`petitboo_chat_opened` avec `source: voicefab|history|cold`).

## Critères de sortie

- [ ] `observers: [analytics.observer]` ajouté au GoRouter et à chaque ShellRoute.
- [ ] Toutes les `GoRoute` ont un `name:` explicite.
- [ ] DebugView affiche `screen_view` à chaque changement de route, avec un `screen_name` cohérent.
- [ ] Décision documentée pour chaque bottom sheet critique (track ou ignore).
