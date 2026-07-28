# Étape 7 — Tests et QA

> Cette étape se déroule **après** que toutes les étapes 02-06 soient mergées et le backend déployé.

---

## 1. Matrice de tests manuels

| # | Plateforme | Scénario | Attendu |
|---|------------|----------|---------|
| 1 | iOS | App fermée, lien tapé dans Notes, long-press → "Ouvrir dans Le Hiboo" | Option visible |
| 2 | iOS | App fermée, tap normal sur le lien depuis Messages | App s'ouvre directement sur le détail event en < 3s |
| 3 | iOS | App ouverte sur Home, lien cliqué depuis Mail | App navigue immédiatement vers le détail |
| 4 | iOS | App ouverte sur le détail d'un autre event, lien cliqué | Navigation vers le nouvel event (pas de stack pollué) |
| 5 | iOS | App non installée, tap sur le lien | Safari ouvre la page web |
| 6 | iOS | Lien partagé pointe sur un event introuvable (404) | App s'ouvre, écran d'erreur clair |
| 7 | iOS | Lien partagé pointe sur un event password-protected | App s'ouvre, `EventPasswordSheet` s'affiche |
| 8 | iOS | Lien tronqué/mal formé `https://lehiboo.com/events/` | App ne s'ouvre pas via UL, Safari prend le relais |
| 9 | iOS | Slug avec caractères spéciaux (accents, espaces encodés) | Décodage OK, event chargé |
| 10 | Android | App fermée, clic sur lien depuis Gmail | App s'ouvre directement, pas de chooser |
| 11 | Android | App ouverte (background), clic depuis Chrome | App reprend et navigue vers le détail |
| 12 | Android | App non installée, clic sur le lien | Chrome ouvre la page web |
| 13 | Android | `adb shell am start ... lehiboo.com/events/{slug}` | Ouvre l'app sur le bon écran |
| 14 | Android | URL avec `www.` (`https://www.lehiboo.com/events/...`) | Ouvre l'app (les deux hosts sont vérifiés) |
| 15 | Android | URL en HTTP (pas HTTPS) | Ouvre Chrome, pas l'app (volontaire — sécurité) |
| 16 | iOS + Android | Multi-cold-start : tuer l'app, relancer via deeplink × 3 | Pas de duplicate de l'event, pas de crash |
| 17 | iOS + Android | Deeplink reçu pendant que `EventDetailScreen` est en cours de chargement | Annule l'ancien load, charge le nouveau |
| 18 | iOS + Android | Analytics : event `deeplink_opened` reçu dans Firebase DebugView | Params : `source`, `path`, `cold_start`, `utm_source` si présent |

---

## 2. Validators avant test

### iOS

```bash
# 1. AASA accessible
curl -I https://lehiboo.com/.well-known/apple-app-site-association
# HTTP/2 200, content-type: application/json

# 2. Validator officiel Apple (web)
# https://search.developer.apple.com/appsearch-validation-tool/

# 3. Validator tiers
# https://branch.io/resources/aasa-validator/

# 4. Sur le device, après install : Réglages > Développeur > Universal Links > Diagnostics
```

### Android

```bash
# 1. assetlinks.json accessible
curl -I https://lehiboo.com/.well-known/assetlinks.json

# 2. Validator Google
# https://developers.google.com/digital-asset-links/tools/generator

# 3. Sur le device, après install (et après autoVerify) :
adb shell pm get-app-links com.dilios.lehibooexperience
# Attendu : lehiboo.com: verified, www.lehiboo.com: verified

# 4. Si non vérifié, forcer :
adb shell pm verify-app-links --re-verify com.dilios.lehibooexperience
```

---

## 3. Commandes utiles

### Tester un deeplink sans cliquer (Android)

```bash
adb shell am start -a android.intent.action.VIEW \
    -c android.intent.category.BROWSABLE \
    -d "https://lehiboo.com/events/jazz-night-paris-2026"
```

### Tester un deeplink sans cliquer (iOS Simulator)

```bash
xcrun simctl openurl booted "https://lehiboo.com/events/jazz-night-paris-2026"
```

⚠️ Sur simulateur, les Universal Links sont moins fiables qu'un vrai device. À utiliser uniquement pour valider le routing Flutter interne — pas pour valider la vérification AASA.

### Logs Flutter en temps réel

```bash
flutter logs
# ou pour Android :
adb logcat -s flutter
# pour iOS :
xcrun simctl spawn booted log stream --predicate 'subsystem == "io.flutter"'
```

---

## 4. Tests automatisés

### Tests unitaires (Dart)

Déjà couvert dans [04_FLUTTER_INTEGRATION.md](04_FLUTTER_INTEGRATION.md) §8 :

```bash
flutter test test/core/deeplinks/deeplink_router_test.dart
```

### Tests d'intégration (optionnel — phase 2)

`flutter_driver` ou `integration_test` peut simuler une réception d'URL via `platform.invokeMethod`. C'est lourd à mettre en place. Pour cette première itération, **les tests manuels suffisent**.

---

## 5. Scénarios edge à valider

| Scénario | Comportement attendu |
|----------|----------------------|
| Lien partagé sur un autre device (clipboard cross-device) | Idem qu'un lien tapé manuellement |
| Lien dans une bio Instagram | Tap depuis l'app Instagram doit ouvrir Le Hiboo (Instagram in-app browser peut intercepter — connu) |
| Lien dans un PDF | Tap depuis Adobe Reader / Aperçu doit déclencher UL/App Link |
| Slug très long (>200 chars) | App ne crashe pas, charge ou affiche erreur 404 |
| Slug avec `..` ou `../` | `Uri.pathSegments` normalise, mais valider qu'on ne tombe pas sur une mauvaise route |
| Deeplink reçu pendant une vidéo en plein écran | Navigation vers détail, sortie clean du plein écran |
| Deeplink pendant un onboarding non terminé | À discuter UX — probablement laisser finir l'onboarding et stocker en pending |

---

## 6. Critères de "feu vert"

- [ ] 100 % de la matrice §1 passe sur au moins 1 device iOS et 1 Android physiques
- [ ] Validators officiels (Apple + Google) → green
- [ ] `adb shell pm get-app-links` → `verified`
- [ ] iOS Réglages > Développeur > UL → `applinks:lehiboo.com` en `Approved`
- [ ] Analytics `deeplink_opened` visible dans Firebase DebugView avec les bons params
- [ ] Pas de régression sur le partage normal (les events partagés produisent toujours une URL fonctionnelle)
- [ ] Pas de régression sur les routes existantes accessibles depuis l'app (bottom nav, push notifications, etc.)

---

## 7. Debug : checklist quand "ça marche pas"

### iOS

1. L'AASA est-il accessible ? `curl -I https://lehiboo.com/.well-known/apple-app-site-association`
2. Le Team ID dans l'AASA matche-t-il le build ? (vérifier dans Xcode)
3. L'entitlement est-il actif sur le build installé ? `codesign -d --entitlements - /path/to/Runner.app`
4. Réglages > Développeur > UL : statut du domaine ?
5. Logs Xcode : chercher `swcd:` (Shared Web Credentials Daemon) — c'est lui qui fait la vérification
6. Désinstaller / réinstaller l'app (force une re-validation)

### Android

1. `assetlinks.json` accessible ? `curl -I https://lehiboo.com/.well-known/assetlinks.json`
2. Le SHA dans `assetlinks.json` matche-t-il l'APK installé ? `apksigner verify --print-certs app-release.apk`
3. `adb shell pm get-app-links com.dilios.lehibooexperience` → quel statut ?
4. Si `legacy_failure` : `adb shell pm verify-app-links --re-verify com.dilios.lehibooexperience`
5. `adb logcat | grep -i "applinks\|intent"` pendant un tap
6. Vérifier que `autoVerify="true"` est bien dans le manifest installé : `adb shell dumpsys package com.dilios.lehibooexperience | grep -A5 "Domain"`
