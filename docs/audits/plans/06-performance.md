# Plan 06 — Performance

Objectif : repérer les sources de jank (rebuilds, listes, images, animations),
les coûts de démarrage et les fuites mémoire.

## Périmètre
Presentation (`screens/`, `widgets/`), listes/feeds (home, events, search, messages),
carte (`flutter_map`), `main.dart` (boot), animations (`flutter_animate`, `confetti`).

## Risques connus / hypothèses
- ⚠️ **Boot lourd** : `main()` enchaîne dotenv + Firebase + Crashlytics + OneSignal + Stripe + SharedPreferences + date formatting **avant `runApp`** → temps de démarrage à mesurer.
- ⚠️ **`LeHibooApp.build` observe ~8 providers globaux** → tout rebuild propage largement.
- ⚠️ **God widgets** (filter_bottom_sheet 107 Ko, airbnb_search_sheet 81 Ko) → `build()` coûteux, peu de `const`.
- ⚠️ Carte events : filtrage/markers reconstruits (cf. `CLAUDE.md` map_view_screen) ; vidéos (`video_player`), carrousels auto-rotate.

## Checklist
- [ ] **Rebuilds** : profiler avec DevTools (Performance + « Track Widget Rebuilds »). Repérer les `setState`/`watch` trop larges ; pousser l'usage de `const` et `select`.
- [ ] **Listes** : `ListView.builder`/`SliverList` partout (pas de `ListView(children: [...])` sur listes longues) ; `itemExtent`/`prototypeItem` si possible ; pagination (cf. plan 04).
- [ ] **Images** : `cached_network_image` avec `memCacheWidth/Height` et placeholders ; pas d'images pleine résolution dans des miniatures ; `flutter_image_compress` sur les uploads.
- [ ] **Démarrage** : mesurer time-to-first-frame ; différer ce qui peut l'être après `runApp` (init non bloquantes), garder le strict nécessaire avant.
- [ ] **Init globale** : déplacer les `ref.watch` de `LeHibooApp` vers un widget enfant pour limiter la portée des rebuilds (cf. plan 03).
- [ ] **Animations** : `flutter_animate`, `confetti`, `shimmer`, carrousels — contrôleurs disposés, animations stoppées hors écran (`visibility_detector` déjà utilisé sur le hero carousel ✅ — étendre au reste).
- [ ] **Carte** : markers mémoïsés, clustering si nombreux pins, rebuild de la couche markers seulement si les events changent.
- [ ] **Vidéo** : `video_player` libéré quand hors écran ; pas de lecture multiple simultanée.
- [ ] **Mémoire** : profiler les écrans lourds (stories vidéo, chat, feed) ; fuites d'images/contrôleurs.
- [ ] **Jank** : viser 60/120 fps ; repérer les frames > 16 ms en scroll.
- [ ] **Taille de l'app** : `--analyze-size` (assets, fonts, images) ; assets inutilisés dans `assets/`.
- [ ] **Build release** : tree-shaking des icônes, `--obfuscate` (recoupe plan 05), `--split-debug-info`.

## Commandes / mesures
```bash
# Profilage (device réel, mode profile)
flutter run --profile        # puis DevTools : Performance, Memory, Rebuild stats

# Listes non lazy (anti-pattern sur longues listes)
rg -n "ListView\(|Column\(\s*children:\s*\[" lib --glob '!*.g.dart'

# Images sans contrainte de cache mémoire
rg -n "CachedNetworkImage\(|Image\.network\(" lib --glob '!*.g.dart'
rg -n "memCacheWidth|cacheWidth" lib --glob '!*.g.dart'

# const manquants (indicatif — s'appuyer surtout sur le lint prefer_const)
rg -n "return Padding\(|return Container\(|child: Text\(" lib --glob '!*.g.dart' | wc -l

# Taille du bundle release
flutter build apk --analyze-size --target-platform android-arm64
```

## Livrable
Tableau des écrans critiques avec métriques (fps scroll, time-to-first-frame, pics mémoire), liste des god widgets à `const`-ifier/découper, plan d'allègement du boot, assets inutilisés.
