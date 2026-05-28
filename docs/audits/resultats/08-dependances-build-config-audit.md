# Audit — Axe 08 Dépendances & configuration de build

Date : 2026-05-28 · Branche : `main` · Auditeur : Claude · Plan : [08-dependances-build-config.md](../plans/08-dependances-build-config.md)

## Synthèse
- **État global : 🟠 Majeur** — un **bug de sélection d'environnement** fait charger `.env.staging` par défaut en local (et non `.env.development` comme documenté), le **signing release retombe sur la clé debug** si le keystore manque, et **~30 dépendances directes sont à ≥1 version majeure de retard**.
- Constats : **2 🟠 P1 · 5 🟡 P2 · 3 ⚪**
- **Top 3 actions** :
  1. Corriger le `switch` d'environnement (ajouter la branche `development`) + statuer sur le défaut.
  2. Sécuriser le signing release (échouer si keystore absent au lieu de signer en debug).
  3. Lancer un chantier de montée de versions priorisé (firebase, secure_storage, stripe, puis Riverpod 3).

---

## Constats détaillés

### 🟠 P1 — Majeurs
| # | Constat | Fichier:ligne | Recommandation |
|---|---------|---------------|----------------|
| P1-1 | **Bug de sélection d'environnement.** Le `switch` n'a **aucune branche `'development'`** ; le défaut `_ => '.env.staging'` fait qu'un `flutter run` local sans `--dart-define=ENV` charge **`.env.staging`** (API/Stripe/Pusher de staging). **Contredit CLAUDE.md** qui affirme que `.env.development` est chargé par défaut. `.env.development` n'est **jamais** chargé par ce chemin (sauf fallback si staging échoue). Risque : dev pensant être en development tout en frappant staging. | [main.dart:93-99](../../../lib/main.dart#L93-L99) | Ajouter `'development' => '.env.development'` ; décider explicitement du défaut (proposé : `'.env.development'`). Mettre à jour CLAUDE.md. **Décision produit requise** (impact TestFlight/CI) → ne pas appliquer sans validation. |
| P1-2 | **Signing release retombe sur la clé debug.** Si `hasReleaseKeystore` est faux (keystore absent en CI/local), `release` est signé avec `signingConfigs.getByName("debug")` → un artefact « release » peut être produit signé en debug (sideload/interne) au lieu d'échouer. | [android/app/build.gradle.kts:67-72](../../../android/app/build.gradle.kts#L67-L72) | Faire **échouer** le build release si le keystore manque (ne pas retomber sur debug). |

### 🟡 P2 — Moyens
| # | Constat | Fichier:ligne | Recommandation |
|---|---------|---------------|----------------|
| P2-1 | **Pas de minification/R8** (`minifyEnabled`/`shrinkResources` absents) malgré `proguard-rules.pro` présent, et **pas d'obfuscation** (`--obfuscate`). Binaire plus gros + rétro-ingénierie facilitée (recoupe [sécurité #4](05-securite-audit.md)). | [android/app/build.gradle.kts](../../../android/app/build.gradle.kts) (release) | Activer `isMinifyEnabled = true` + `isShrinkResources = true` en release, vérifier les règles ProGuard ; ajouter `--obfuscate --split-debug-info`. |
| P2-2 | **Dépendances très en retard** : ~30 deps directes à ≥1 majeure du `Latest`. Notables : firebase_core 3→4, firebase_crashlytics 4→5, flutter_secure_storage 9→10, flutter_stripe 11→12, go_router 14→17, flutter_riverpod 2→3 (migration lourde), freezed 2→3, **flutter_lints 3→6** (ruleset obsolète). Aucune n'est *upgradable* dans les contraintes actuelles. | [pubspec.yaml](../../../pubspec.yaml) | Chantier d'upgrade priorisé : sécurité d'abord (firebase, secure_storage, stripe), puis tooling (flutter_lints 6, build_runner), puis Riverpod 3 (migration dédiée). |
| P2-3 | **Artefacts/logs committés à la racine** : `build_log.txt` (**3,8 Mo**) et `backend_request_email.txt`. Bruit dans le repo, risque d'info interne. | racine repo | Supprimer du suivi git + ajouter au `.gitignore`. |
| P2-4 | **Incohérence de version** : pubspec `1.0.0+1` vs Android `versionName="1.0.1"` / `versionCode=2`. Source de confusion de release. | [pubspec.yaml:5](../../../pubspec.yaml#L5), [build.gradle.kts:51-52](../../../android/app/build.gradle.kts#L51-L52) | Aligner sur la version du pubspec (Flutter dérive `versionCode/Name` du pubspec par défaut). |
| P2-5 | **Pas de scan de vulnérabilités automatisé** des dépendances (aucun `osv-scanner`/CI). | — | Ajouter un scan (OSV) dans la future CI ([plan 13](../plans/13-ci-cd-release.md)). |
| P2-6 | **Version Flutter non épinglée** : pas de `.fvmrc` ; le PATH expose `flutter 3.32.5` alors qu'un SDK `fvm 3.35.7` (incohérent) traîne sur la machine → builds/tests non reproductibles (a cassé `flutter test`, cf. [audit 07](07-tests-qualite-audit.md) P0-2). | racine (`.fvmrc` absent) | Committer `.fvmrc` avec la version cible ; aligner CI dessus. |

### ⚪ Informatif
- **156 fichiers générés** (`.g.dart`/`.freezed.dart`) versionnés — choix acceptable (évite build_runner en CI) mais source de conflits/staleness ; à documenter.
- **SDK Android via défauts Flutter** (`flutter.minSdkVersion/targetSdkVersion/compileSdkVersion`) ✅ ; `applicationId = com.dilios.lehibooexperience`.
- **iOS deployment target 15.5** (cohérent Podfile/projet, quelques cibles à 15.6) ✅ — requis par `mobile_scanner` 6.x.

---

## Points conformes (✅)
- Fallback de chargement d'env robuste (`.env.staging` → `.env` → log) — le mécanisme ne crashe pas si un fichier manque ([main.dart:101-111](../../../lib/main.dart#L101-L111)).
- Keystore lu depuis `keystore.properties` (hors VCS) — pas de secret de signing en dur dans le gradle.
- `proguard-rules.pro` présent (prêt à être activé).
- Lockfile (`pubspec.lock`) cohérent avec les contraintes.

## Annexes (commandes lancées)
- `flutter pub outdated` (40+ deps directes/transitive en retard).
- Lecture `main.dart:75-144` (sélection d'env), `android/app/build.gradle.kts` (signing/minify/version), `ios/Podfile` + `project.pbxproj` (deployment target).
- `git ls-files '*.g.dart' '*.freezed.dart'` → 156.
