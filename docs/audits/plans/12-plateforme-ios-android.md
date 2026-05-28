# Plan 12 — Plateforme iOS / Android

Objectif : auditer les configurations natives (permissions, manifests, Info.plist,
signing, capabilities) et la « store readiness ».

## Périmètre
- `android/app/src/{main,debug,profile}/AndroidManifest.xml`, `android/app/build.gradle(.kts)`
- `ios/Runner/Info.plist`, `ios/Runner/Runner.entitlements`, `ios/Podfile`
- `ios/OneSignalNotificationServiceExtension/` (extension push + entitlements)
- `flutter_launcher_icons`, deep link config (Universal Links / App Links)

## Constaté
- Manifests Android : `main`, `debug`, `profile` (cleartext autorisé en debug/profile — cf. `CLAUDE.md`).
- Permissions Android main : `RECORD_AUDIO`, `INTERNET`, `POST_NOTIFICATIONS`, `ACCESS_COARSE_LOCATION`, `ACCESS_FINE_LOCATION`, `CAMERA`.
- iOS : `Runner/Info.plist` + `Runner.entitlements`, extension OneSignal avec son `Info.plist`/entitlements.
- iOS min 15.5 (Podfile, requis par `mobile_scanner`).

## Checklist
### Permissions (moindre privilège + justification)
- [ ] Chaque permission Android est **réellement utilisée** et justifiée :
  - `RECORD_AUDIO` → `speech_to_text` (VoiceFab) ; `CAMERA` → `mobile_scanner` (check-in) + `image_picker` ; `ACCESS_FINE/COARSE_LOCATION` → `geolocator` (carte) ; `POST_NOTIFICATIONS` → push.
- [ ] **Background location** non demandée si non nécessaire.
- [ ] iOS `Info.plist` : chaînes d'usage (`NS*UsageDescription`) présentes et claires pour **caméra, micro, localisation, photos** (sinon rejet App Store).
- [ ] Demande de permission **au bon moment** (juste avant usage), pas au boot.

### Transport / sécurité réseau (recoupe plan 05)
- [ ] iOS : `NSAllowsArbitraryLoads`/ATS ouvert **uniquement** en config dev, pas en release.
- [ ] Android : `usesCleartextTraffic` limité aux manifests `debug`/`profile` ; **absent** du `main` en release. Idéalement `network_security_config` restrictif.

### Signing & build
- [ ] Android : `signingConfig` release **non** sur la clé debug ; keystore hors VCS ; `minifyEnabled`/`shrinkResources` (R8) en release.
- [ ] iOS : provisioning/profiles, `Runner.entitlements` (push `aps-environment`, associated domains pour Universal Links).
- [ ] `applicationId`/bundle id corrects ; envisager des flavors/suffixes par env (recoupe plan 08).
- [ ] Versioning : `version: 1.0.0+1` → process d'incrément `versionCode`/`build` défini.

### Push & deep links
- [ ] OneSignal : extension de service de notif configurée (rich push), entitlements cohérents, `aps-environment` = `production` pour les builds store.
- [ ] App Links Android (`assetlinks.json`) + Universal Links iOS (`apple-app-site-association`) hébergés et `associated domains` déclarés.
- [ ] Schémas custom (`app_links`) validés (recoupe plan 05 deeplinks).

### Store readiness
- [ ] Icônes/splash générés pour toutes densités (`flutter_launcher_icons`), pas d'alpha iOS.
- [ ] Privacy : `PrivacyInfo.xcprivacy` iOS (manifest de confidentialité — requis), Data Safety form Google Play (collecte caméra/micro/localisation/analytics).
- [ ] Target SDK Android à jour vs exigences Play Store en cours.
- [ ] 64-bit, App Bundle (`.aab`), tailles d'écran/tablette.

## Commandes / mesures
```bash
# Permissions déclarées vs usage runtime
rg -n "uses-permission" android/app/src/main/AndroidManifest.xml
rg -n "NS\w+UsageDescription" ios/Runner/Info.plist
rg -n "Permission\.|permission_handler|Geolocator|ImagePicker|MobileScanner|SpeechToText" lib --glob '!*.g.dart'

# Cleartext / ATS par config
rg -n "usesCleartextTraffic|networkSecurityConfig" android/app/src
rg -n "NSAllowsArbitraryLoads|NSAppTransportSecurity" ios/Runner/Info.plist

# Signing & shrink
rg -n "signingConfig|minifyEnabled|shrinkResources|applicationId" android/app/build.gradle*

# Deep links / associated domains
rg -n "associated|applinks|assetlinks|aps-environment|CFBundleURLSchemes" ios android
```

## Livrable
Matrice permission × usage × justification × plateforme, état transport release (ATS/cleartext), checklist signing/flavors, état des deep links (AASA/assetlinks), checklist store readiness (privacy manifest, data safety, icônes).
