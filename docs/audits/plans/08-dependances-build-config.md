# Plan 08 — Dépendances & configuration de build

Objectif : auditer les dépendances (obsolètes, abandonnées, vulnérables, redondantes),
la configuration multi-environnement et la chaîne de build/codegen.

## Périmètre
`pubspec.yaml`, `pubspec.lock`, `main.dart` (chargement env), `lib/config/env_config.dart`,
`build_runner`/codegen, configs natives de build (`android/app/build.gradle`, signing iOS).

## Risques connus / hypothèses
- 🔴 **Bug de sélection d'environnement** — [main.dart:95-99](../../../lib/main.dart#L95-L99) :
  ```dart
  final envFile = switch (environment) {
    'production' => '.env.production',
    'staging'    => '.env.staging',
    _            => '.env.production',   // ⚠️ 'development' tombe ici → charge la PROD
  };
  ```
  Contredit `CLAUDE.md` (« le mobile charge `.env.development` par défaut »). Risque : un build dev/local tape la prod.
- ⚠️ **`useRealApi = true` en constante** ([main.dart:82](../../../lib/main.dart#L82)) — pas de flavor.
- ⚠️ HTTP `http` package **et** Dio coexistent → redondance/incohérence de la couche réseau.
- ⚠️ Dépendances nombreuses (~60) : surface d'attaque, poids, risque d'abandon.

## Checklist
- [ ] **`flutter pub outdated`** : lister majeures en retard, classer (sécurité / breaking / mineur).
- [ ] **Packages abandonnés / non maintenus** : vérifier dernière publication & santé (ex. `visibility_detector`, `add_2_calendar`, `screen_brightness`, `dart_pusher_channels`).
- [ ] **Redondances** : `http` vs `dio` (consolider) ; `font_awesome_flutter` + `phosphor_flutter` + `cupertino_icons` (3 sets d'icônes) ; `google_fonts` (téléchargement runtime vs assets).
- [ ] **Versions épinglées** : `pubspec.lock` commité et cohérent ; éviter les `any`.
- [ ] **Switch d'environnement** : corriger le `_ =>` pour que `development` charge `.env.development` ; clarifier la stratégie `--dart-define=ENV=`.
- [ ] **Flavors** : envisager des flavors Android/iOS (dev/staging/prod) + suffixe d'`applicationId`/bundle id, plutôt que `useRealApi` en dur.
- [ ] **Codegen** : `dart run build_runner build --delete-conflicting-outputs` passe sans erreur ; fichiers générés à jour vs sources ; décider commit ou non des `*.g/.freezed.dart`.
- [ ] **Assets** : tous les chemins déclarés dans `pubspec.yaml` existent ; pas d'assets orphelins (recoupe plan 06).
- [ ] **Min SDK / cibles** : `min_sdk_android: 21`, iOS 15.5 (Podfile, lié à `mobile_scanner`) — cohérence et conséquences.
- [ ] **Licences** : vérifier la compatibilité des licences des dépendances (usage commercial).
- [ ] **Permissions implicites** : certaines libs ajoutent des permissions (image_picker, geolocator, mobile_scanner) → recouper plan 12.
- [ ] **`flutter doctor`** propre ; version Flutter/Dart figée pour l'équipe (ex. `fvm`/`.tool-versions`).

## Commandes / mesures
```bash
flutter pub outdated
flutter pub deps --style=compact
dart run build_runner build --delete-conflicting-outputs

# Coexistence http + dio
rg -n "package:http/http\.dart|import 'package:dio" lib --glob '!*.g.dart'

# Vérifier les assets déclarés
rg -n "assets/" pubspec.yaml

# Sélection d'env
rg -n "String.fromEnvironment\('ENV'|\.env\." lib/main.dart lib/config
```

## Livrable
Tableau des dépendances (version actuelle / dernière / risque / action), correctif du switch d'env, proposition de flavors, état du codegen, liste des redondances à consolider.
