# Audit — Axe 12 Plateforme (iOS / Android)

Date : 2026-05-28 · Branche : `main` · Auditeur : Claude · Plan : [12-plateforme-ios-android.md](../plans/12-plateforme-ios-android.md)

## Synthèse
- **État global : 🟢 Bon** — la configuration native est **soignée** : ATS sécurisé (iOS), cleartext cantonné au debug/profile (Android), permissions minimales et justifiées, **Universal Links / App Links correctement configurés et cohérents** sur les deux plateformes. Deux points bloquent la soumission/qualité store : **PrivacyInfo.xcprivacy absent** et **sur-permissionnement « Always » location**.
- Constats : **1 🟠 P1 · 3 🟡 P2 · 2 🟢 P3**
- **Top 3 actions** :
  1. Ajouter `PrivacyInfo.xcprivacy` (requis App Store).
  2. Réduire la localisation iOS à `WhenInUse` (retirer « Always » non justifié).
  3. Vérifier/justifier `UIFileSharingEnabled` (exposition du conteneur Documents).

---

## Constats détaillés

### 🟠 P1 — Bloquant soumission
| # | Constat | Fichier:ligne | Recommandation | Effort |
|---|---------|---------------|----------------|--------|
| P1-1 | **`PrivacyInfo.xcprivacy` absent.** Apple l'exige depuis mai 2024 pour les apps utilisant des « required reason APIs » (UserDefaults via `shared_preferences`, timestamps fichier, etc.) et pour agréger les manifests des SDK tiers. Risque de **rejet App Store**. | `ios/Runner/` (absent) | Ajouter `PrivacyInfo.xcprivacy` déclarant les required-reason APIs + collecte de données (localisation, identifiants). Vérifier que firebase/onesignal embarquent les leurs (versions anciennes — cf. [audit 08](08-dependances-build-config-audit.md)). | M |

### 🟡 P2 — Qualité / risque review
| # | Constat | Fichier:ligne | Recommandation |
|---|---------|---------------|----------------|
| P2-1 | **Sur-permissionnement localisation iOS** : `NSLocationAlwaysAndWhenInUseUsageDescription` déclare « Always » alors que tous les usages décrits sont **when-in-use** (suggestions proches, recherche autour, Petit Boo) et qu'**aucun background mode location** n'est déclaré (`UIBackgroundModes` = `remote-notification`, `fetch`). « Always » est fortement scruté par Apple → risque de review. | [ios/Runner/Info.plist:47-50](../../../ios/Runner/Info.plist#L47-L50) | Ne garder que `NSLocationWhenInUseUsageDescription` (retirer la clé « Always »). |
| P2-2 | **`UIFileSharingEnabled=true` + `LSSupportsOpeningDocumentsInPlace=true`** → le conteneur Documents est exposé via l'app Fichiers/Finder. Si des données sensibles (billets, caches) y sont stockées, elles sont exportables par l'utilisateur/un tiers ayant l'appareil. | [ios/Runner/Info.plist:57-60](../../../ios/Runner/Info.plist#L57-L60) | Vérifier la nécessité (file_picker/partage) ; sinon passer à `false`. Ne pas stocker de données sensibles dans Documents. |
| P2-3 | **`UIBackgroundModes: fetch`** déclaré — vérifier qu'un background fetch est réellement implémenté ; sinon capability inutile (signalée en review). | [ios/Runner/Info.plist:84-87](../../../ios/Runner/Info.plist#L84-L87) | Retirer `fetch` si non utilisé. |

### 🟢 P3 — Mineurs
- **`NSContactsUsageDescription`** : la justification (autocomplétion de lieu de l'écran calendrier iOS) est défendable mais borderline — vérifier qu'aucune API Contacts n'est appelée directement, sinon clarifier en review ([Info.plist:45-46](../../../ios/Runner/Info.plist#L45-L46)).
- **Incohérence de version** pubspec `1.0.0+1` vs Android `1.0.1+2` (déjà en [audit 08](08-dependances-build-config-audit.md) P2-4) — impacte aussi le numéro de build store.

---

## Points conformes (✅)
- **ATS sécurisé (iOS)** : aucun `NSAllowsArbitraryLoads` → HTTPS-only en production. Le dev HTTP local n'est pas ouvert dans le plist de prod (bon pour la sécurité).
- **Cleartext Android cantonné** : `usesCleartextTraffic="true"` uniquement dans `src/debug` et `src/profile` ; le manifest `main` (release) ne l'active pas → cleartext bloqué en release (API 28+).
- **Permissions minimales et justifiées** :
  - iOS : Calendars (3), Camera (scan billets), Contacts, Location WhenInUse, Microphone (Petit Boo), PhotoLibrary (avatar), SpeechRecognition — **usage strings localisées et significatives**.
  - Android : `RECORD_AUDIO`, `INTERNET`, `POST_NOTIFICATIONS`, `ACCESS_COARSE/FINE_LOCATION`, `CAMERA`. **Pas de background location, pas de stockage large** (photo picker moderne).
- **Universal Links / App Links** correctement configurés et **cohérents avec la whitelist Dart** (cf. [audit 05](05-securite-audit.md)) :
  - Android : `intent-filter android:autoVerify="true"`, scheme `https`, hosts lehiboo.com/www/staging ([AndroidManifest.xml:47-57](../../../android/app/src/main/AndroidManifest.xml#L47-L57)).
  - iOS : `com.apple.developer.associated-domains` = `applinks:lehiboo.com`, `applinks:staging.lehiboo.com` ([Runner.entitlements:7-10](../../../ios/Runner/Runner.entitlements#L7-L10)).
  - Dart : n'accepte que `scheme == 'https'` + host whitelisté.
- **Toolchain native saine** : iOS deployment target 15.5, Java 17, `namespace`/`ndkVersion` via défauts Flutter, orientation portrait, app icons via `flutter_launcher_icons`.

## Annexes (commandes lancées)
- Lecture `ios/Runner/Info.plist` (permissions, ATS, background modes, file sharing), `ios/Runner/Runner.entitlements`.
- Greps `android/app/src/*/AndroidManifest.xml` (permissions, cleartext, intent-filters/autoVerify).
- `find ios -name PrivacyInfo.xcprivacy` → absent. `android/app/build.gradle.kts` (namespace/SDK/Java).
