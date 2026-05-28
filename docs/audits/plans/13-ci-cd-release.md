# Plan 13 — CI/CD & release

Objectif : combler l'absence de CI/CD, sécuriser la chaîne de build/livraison et
définir un process de release reproductible.

## Constat
- 🔴 **Aucune CI** : pas de `.github/workflows/` (ni autre runner détecté).
- Artefacts de build versionnés à la racine (`build_log.txt`) → signe de builds manuels.
- Secrets en `.env*` (non commités) → besoin d'un coffre pour la CI.

## Périmètre
Pipeline d'intégration (analyze/test/build), gestion des secrets, signing, distribution
(TestFlight / Play Internal), versioning, qualité de code en porte (gate).

## Checklist
### Intégration continue (PR)
- [ ] **Workflow PR** : `flutter pub get` → `dart format --set-exit-if-changed` → `flutter analyze` → `dart run custom_lint` → `flutter test --coverage`.
- [ ] **Codegen** : `dart run build_runner build --delete-conflicting-outputs` vérifié (ou fichiers générés à jour).
- [ ] **Gate qualité** : échec si analyze ≠ 0 ; seuil de couverture (ratchet, cf. plan 07).
- [ ] **Cache** : pub + Gradle + Pods pour des runs rapides.
- [ ] **Matrix** : build Android (`.aab`) + iOS (au moins `flutter build ios --no-codesign`) à chaque PR.

### Livraison (release)
- [ ] **Secrets CI** : `.env.production/staging`, keystore Android, certificats iOS injectés via secrets chiffrés (GitHub Actions secrets / fastlane match), jamais en clair.
- [ ] **Signing automatisé** : keystore Android + provisioning iOS (fastlane `match`).
- [ ] **Symboles** : upload dSYM (iOS) + mapping R8 (Android) vers Crashlytics (recoupe plan 11).
- [ ] **Distribution** : TestFlight + Google Play Internal/Closed via fastlane ou actions dédiées.
- [ ] **Versioning** : bump auto `version`/`build`/`versionCode` (tag git → version) ; changelog généré.
- [ ] **Environnements** : pipelines distincts staging vs prod (recoupe flavors, plan 08).

### Sécurité chaîne d'appro
- [ ] **Scan secrets** en CI (`gitleaks`) bloquant.
- [ ] **Scan deps** : `flutter pub outdated` rapporté ; alertes de vulnérabilité.
- [ ] **Protection de branche** : revue obligatoire, checks requis verts avant merge.

## Esquisse de pipeline (à adapter au runner choisi)
```yaml
# .github/workflows/ci.yml (exemple)
on: { pull_request: {}, push: { branches: [main] } }
jobs:
  analyze-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with: { flutter-version: '3.x', cache: true }
      - run: flutter pub get
      - run: dart format --output=none --set-exit-if-changed lib
      - run: flutter analyze
      - run: dart run custom_lint
      - run: flutter test --coverage
      # - gitleaks, upload coverage, etc.
  build-android:
    needs: analyze-test
    runs-on: ubuntu-latest
    steps: [ checkout, flutter, "flutter build appbundle --dart-define=ENV=staging" ]
```

## Livrable
Décision sur le runner (GitHub Actions / autre), workflow CI minimal opérationnel (analyze+test+build), plan de gestion des secrets, process de release documenté (signing, distribution, versioning, symboles), gates de qualité activés.
