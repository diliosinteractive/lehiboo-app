# Audit — Axe 13 CI/CD & release

Date : 2026-05-28 · Branche : `main` · Auditeur : Claude · Plan : [13-ci-cd-release.md](../plans/13-ci-cd-release.md)

## Synthèse
- **État global : 🟠 Majeur** — la **seule CI est Xcode Cloud (iOS, build App Store uniquement)**. Aucune validation automatisée sur PR (pas de `flutter analyze`, pas de `flutter test`, pas de build Android), donc **aucun filet de sécurité contre les régressions**. Le script Xcode Cloud est de bonne facture, mais il révèle une **fragmentation des versions Flutter** (CI 3.38.7 vs PATH local 3.32.5 vs fvm 3.35.7 cassé).
- Constats : **2 🟠 P1 · 2 🟡 P2 · points conformes**
- **Top 3 actions** :
  1. Ajouter une **CI de PR** (GitHub Actions) : `flutter analyze` + `flutter test` + build debug (proposition fournie ci-dessous).
  2. **Unifier la version Flutter** sur 3.38.7 (CI) via `.fvmrc` + réparer le local (débloque les tests, [J2-P0-1](J2-consolidation-vague2.md)).
  3. Automatiser le **build/release Android** (absent aujourd'hui).

> **Jalon J3 (« CI verte : analyze + test + build ») : ❌ non atteint.** `analyze` tourne (1171 issues, exit 0) ; `test` **ne compile pas** en local ; aucune CI ne lance test/analyze. Préalable : résoudre le toolchain ([J2-P0-1](J2-consolidation-vague2.md)) — la version canonique est **3.38.7** (celle de la CI).

---

## 1. Inventaire de l'existant

| Élément | État |
|---------|------|
| GitHub Actions | ❌ absent |
| Xcode Cloud (iOS) | ✅ `ios/ci_scripts/ci_post_clone.sh` — build App Store |
| CI Android | ❌ absente (release manuelle) |
| fastlane | ❌ absent |
| Tests/analyze en CI | ❌ aucun |
| pre-commit / hooks | ❌ absent |
| Gates de PR | ❌ aucun |

---

## 2. Constats détaillés

### 🟠 P1 — Majeurs
| # | Constat | Détail | Recommandation |
|---|---------|--------|----------------|
| P1-1 | **Aucune validation automatisée sur PR** : ni `flutter analyze`, ni `flutter test`, ni build. Combiné à l'absence de tests exécutables ([audit 07](07-tests-qualite-audit.md)), **rien n'empêche une régression de merger**. | pas de `.github/workflows/` | Ajouter une CI de PR (proposition § 3). |
| P1-2 | **CI/CD Android inexistante** : seul iOS est automatisé (Xcode Cloud). Les builds/releases Android (signing, bundle, Play) sont **manuels** → risque d'erreur + dépendance à une machine. Rappel : le signing release retombe sur la clé debug si keystore absent ([audit 08](08-dependances-build-config-audit.md) P1-2). | Xcode Cloud iOS only | Workflow Android (build appbundle signé + upload Play interne via fastlane/Gradle Play Publisher). |

### 🟡 P2 — Moyens
| # | Constat | Détail | Recommandation |
|---|---------|--------|----------------|
| P2-1 | **Fragmentation des versions Flutter** : CI Xcode Cloud épingle **3.38.7** ([ci_post_clone.sh:28](../../../ios/ci_scripts/ci_post_clone.sh#L28)), le PATH local est **3.32.5**, et un **fvm 3.35.7 cassé** traîne. Builds/tests non reproductibles ; le pin n'existe que dans un script shell. | 3 versions divergentes | Committer `.fvmrc` = **3.38.7** ; aligner local + CI ; le script Xcode Cloud peut lire la version depuis `.fvmrc`. |
| P2-2 | **`analyze` n'échoue pas malgré 1171 issues** (warnings/info, exit 0) → aucune pression sur la dette lint ([audit 02](02-qualite-code-conventions-audit.md)). | exit 0 | En CI, `flutter analyze` avec baseline (échouer sur *nouvelles* issues) ou `--fatal-infos`/`--fatal-warnings` après nettoyage. |

---

## 3. Proposition — CI de PR minimale (GitHub Actions)

> À placer dans `.github/workflows/ci.yml`. **Préalable** : que `flutter test` compile (résoudre [J2-P0-1](J2-consolidation-vague2.md)). Version alignée sur la CI iOS (3.38.7).

```yaml
name: CI
on:
  pull_request:
    branches: [main]
  push:
    branches: [main]

jobs:
  analyze-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.38.7'   # = .fvmrc (source unique de vérité)
          channel: stable
          cache: true
      - run: flutter pub get
      # .env.* sont gitignorés : créer des placeholders pour que dotenv charge
      - run: |
          echo "ENVIRONMENT=development" > .env
          cp .env .env.development && cp .env .env.staging && cp .env .env.production
      - run: dart format --output=none --set-exit-if-changed .
      - run: flutter analyze        # passer à --fatal-warnings après nettoyage du lint
      - run: flutter test --coverage
      - uses: codecov/codecov-action@v4   # ou artefact lcov

  build-android:
    runs-on: ubuntu-latest
    needs: analyze-test
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with: { flutter-version: '3.38.7', channel: stable, cache: true }
      - run: flutter pub get
      - run: |
          echo "ENVIRONMENT=staging" > .env.staging
          # injecter les secrets via ${{ secrets.* }} comme le fait ci_post_clone.sh
      - run: flutter build apk --debug --dart-define=ENV=staging
```

**Étapes de durcissement (ultérieur)** : signing release Android via secrets + `fastlane`/Gradle Play Publisher ; scan OSV des dépendances ([audit 08](08-dependances-build-config-audit.md) P2-5) ; `--obfuscate --split-debug-info` ([audit 05](05-securite-audit.md)).

---

## Points conformes (✅)
- **Xcode Cloud épingle la version Flutter** (3.38.7) avec justification documentée (évite les régressions de `stable` flottant).
- **Secrets reconstruits depuis les variables de workflow** (App Store Connect), avec `set +x` pour ne pas les fuiter dans les logs, et **validation des secrets requis** manquants ([ci_post_clone.sh:110-174](../../../ios/ci_scripts/ci_post_clone.sh#L110-L174)). Bon pattern — les `.env*` restent gitignorés. _(N.B. : ces secrets restent ceux exposés historiquement → rotation V1 toujours requise.)_
- **Marketing version synchronisée depuis `pubspec.yaml`** (`agvtool`), build number auto-incrémenté par Xcode Cloud.
- **SPM désactivé délibérément** (CocoaPods exclusif) — évite des échecs xcodebuild.
- **`--dart-define=ENV=$APP_ENV`** correctement passé (défaut `production`) — le build CI sélectionne le bon env (contraste avec le bug du défaut **local** → `.env.staging`, [audit 08](08-dependances-build-config-audit.md) P1-1).

## Annexes (commandes lancées)
- `ls .github/workflows` (absent), `find` fastlane/codemagic/bitrise (absents), lecture `ios/ci_scripts/ci_post_clone.sh`.
- `flutter analyze --no-pub` → 1171 issues, exit 0 (162 s).
