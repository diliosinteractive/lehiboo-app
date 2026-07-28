# Statut d'exécution — Phase 1 deeplinks événements

> Date : 2026-05-19 (correctifs routage : 2026-05-22)
> Branche : `feat/analytics`

> 🔧 Deux correctifs post-intégration ont été appliqués au runtime
> (`No GoRouter found in context` et `There is nothing to pop`). Détails et
> recommandations de routage dans [09_ROUTING_ET_FIXES.md](09_ROUTING_ET_FIXES.md).

---

## ✅ Code livré

### Flutter
- [pubspec.yaml](../../pubspec.yaml) — ajout de `app_links: ^6.3.2`
- [lib/core/deeplinks/deeplink_service.dart](../../lib/core/deeplinks/deeplink_service.dart) — wrapper autour de `app_links` (cold + warm start)
- [lib/core/deeplinks/deeplink_router.dart](../../lib/core/deeplinks/deeplink_router.dart) — `mapDeeplinkToRoute(Uri)` + liste blanche des hosts
- [lib/core/deeplinks/deeplink_providers.dart](../../lib/core/deeplinks/deeplink_providers.dart) — providers Riverpod (service + pending replay)
- [lib/core/deeplinks/deeplink_listener.dart](../../lib/core/deeplinks/deeplink_listener.dart) — widget qui consomme les URLs et navigue via go_router (avec replay quand l'auth est settled)
- [lib/main.dart](../../lib/main.dart) — wrap de `MaterialApp.router` avec `DeeplinkListener`
- [lib/core/analytics/analytics_event.dart](../../lib/core/analytics/analytics_event.dart) — events `deeplink_opened` + `deeplink_unmapped` et params `path`, `host`, `cold_start`, `utm_source`

### Configs natives
- [android/app/src/main/AndroidManifest.xml](../../android/app/src/main/AndroidManifest.xml) — `intent-filter` HTTPS + `autoVerify` pour `lehiboo.com` et `www.lehiboo.com`
- [ios/Runner/Runner.entitlements](../../ios/Runner/Runner.entitlements) — `com.apple.developer.associated-domains` avec `applinks:lehiboo.com` + `applinks:www.lehiboo.com`

### Tests
- [test/core/deeplinks/deeplink_router_test.dart](../../test/core/deeplinks/deeplink_router_test.dart) — 12 cas (slug normal, www, query params, host inconnu, http, slug vide, custom scheme, etc.)

### Backend templates
- [docs/DEEPLINKS/backend-templates/apple-app-site-association](backend-templates/apple-app-site-association)
- [docs/DEEPLINKS/backend-templates/assetlinks.json](backend-templates/assetlinks.json)
- [docs/DEEPLINKS/backend-templates/README.md](backend-templates/README.md) — instructions pour la publication

### Vérifié au passage
- ✅ Les URLs hard-codées `https://lehiboo.com/events/...` mentionnées dans le diagnostic TestFlight sont déjà passées via `EnvConfig.eventShareUrl(event.slug)` — étape 6 sans action.

---

## ⏳ À faire par la team

### 1. Finaliser `flutter pub get` (bloqué sur cet environnement)

`flutter pub get` a échoué localement car le Flutter SDK ici (3.32.5 / Dart 3.8.1) est plus ancien que la version utilisée par la team — `font_awesome_flutter` 10.10+ exige Dart >=3.9.0.

À faire sur un poste avec Flutter 3.44+ :

```bash
flutter pub get
flutter analyze
flutter test test/core/deeplinks/
```

### 2. Récupérer les identifiants externes

| Donnée | Où | Pour quel fichier |
|--------|-----|-------------------|
| **Apple Team ID** (10 chars) | Apple Developer Portal (top-right) ou Xcode > Signing | Remplacer `__TEAM_ID__` dans `apple-app-site-association` |
| **SHA-256 keystore Release** | Google Play Console > App Integrity (si Play Signing), sinon `keytool -list -v -keystore ...` | Remplacer `__SHA256_PLAY_SIGNING_OR_RELEASE_KEYSTORE__` dans `assetlinks.json` |
| **SHA-256 keystore Debug** (optionnel) | `keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android` | À ajouter dans le tableau `sha256_cert_fingerprints` pour tests locaux |

### 3. Trancher le domaine canonique

Le diagnostic [DIAGNOSTIC_PARTAGE_EVENT_TESTFLIGHT.md](../DIAGNOSTIC_PARTAGE_EVENT_TESTFLIGHT.md) signale une possible incohérence : prod utilise-t-elle `lehiboo.com` ou `lehiboo.fr` ?

- Vérifier `.env.production` (clé `WEBSITE_URL`)
- Si `.fr` : ajouter `lehiboo.fr` + `www.lehiboo.fr` dans :
  - [kDeeplinkAllowedHosts](../../lib/core/deeplinks/deeplink_router.dart) (décommenter les lignes prêtes)
  - [Runner.entitlements](../../ios/Runner/Runner.entitlements) (`applinks:lehiboo.fr`, `applinks:www.lehiboo.fr`)
  - [AndroidManifest.xml](../../android/app/src/main/AndroidManifest.xml) (nouveau bloc `intent-filter` — un bloc par domaine avec `autoVerify`)
  - AASA + `assetlinks.json` publiés AUSSI sur `lehiboo.fr`

### 4. Côté backend

- Publier `apple-app-site-association` sur `https://lehiboo.com/.well-known/apple-app-site-association` (et idem `www.`)
- Publier `assetlinks.json` sur `https://lehiboo.com/.well-known/assetlinks.json` (et idem `www.`)
- Respecter `Content-Type: application/json`, **pas de redirect**, **pas d'auth**
- Détails dans [05_BACKEND_AASA_ASSETLINKS.md](05_BACKEND_AASA_ASSETLINKS.md) et [backend-templates/README.md](backend-templates/README.md)

### 5. Côté Apple Developer Portal

- App ID `com.dilios.lehiboo` > Capabilities > cocher **Associated Domains**
- Régénérer le provisioning profile et le télécharger dans Xcode

### 6. QA

Une fois 1-5 faits, suivre la matrice [07_TESTING_QA.md](07_TESTING_QA.md) :
- 18 scénarios manuels (iOS + Android, cold/warm, edge cases)
- Validators officiels Apple + Google
- `adb shell pm get-app-links com.dilios.lehibooexperience` → `verified`

### 7. Rollout

Ordre dans [08_ROLLOUT.md](08_ROLLOUT.md). **Critique** : publier l'AASA et `assetlinks.json` AVANT d'installer un build avec les configs natives, sinon iOS/Android cache un échec de validation pendant plusieurs heures.

---

## 📂 Arborescence livrée

```
lib/core/deeplinks/
├── deeplink_listener.dart
├── deeplink_providers.dart
├── deeplink_router.dart
└── deeplink_service.dart

test/core/deeplinks/
└── deeplink_router_test.dart

docs/DEEPLINKS/
├── 00_OVERVIEW.md
├── 01_ANALYSE_EXISTANT.md
├── 02_IOS_UNIVERSAL_LINKS.md
├── 03_ANDROID_APP_LINKS.md
├── 04_FLUTTER_INTEGRATION.md
├── 05_BACKEND_AASA_ASSETLINKS.md
├── 06_SHARE_URL_CLEANUP.md
├── 07_TESTING_QA.md
├── 08_ROLLOUT.md
├── EXECUTION_STATUS.md  ← ce fichier
└── backend-templates/
    ├── README.md
    ├── apple-app-site-association
    └── assetlinks.json
```

---

## 🧪 Comment tester rapidement après finalisation

```bash
# 1. Resolve deps avec le bon SDK
flutter pub get

# 2. Vérifier qu'il n'y a pas de régression Dart
flutter analyze

# 3. Lancer les tests du router deeplinks
flutter test test/core/deeplinks/

# 4. Build et install sur device Android, puis :
adb shell am start -a android.intent.action.VIEW \
    -c android.intent.category.BROWSABLE \
    -d "https://lehiboo.com/events/{un-vrai-slug}"

# 5. Sur iOS, taper le lien dans Notes/Messages et tap dessus
```
