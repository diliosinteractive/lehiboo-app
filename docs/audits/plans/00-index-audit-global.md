# Plan d'audit global — Application Le Hiboo (Flutter)

> **But** : couvrir *tous* les aspects de l'app avant de lancer l'audit complet.
> Chaque plan ci-dessous est une **checklist actionnable + méthodologie**, directement
> exécutable. Ce document est l'index : périmètre, méthode commune, échelle de gravité,
> ordre recommandé et modèle de rapport.

Date de création : 2026-05-26
Périmètre : `lib/` (≈ 749 fichiers Dart, ≈ 257 000 lignes), configs natives `android/` `ios/`, `pubspec.yaml`, docs.
Hors périmètre : code backend Laravel (audité séparément) — seul le **contrat consommé** par l'app est vérifié.

---

## 1. Photographie du projet (état initial)

| Indicateur | Valeur constatée | Remarque |
|------------|------------------|----------|
| Fichiers Dart | ~749 | dont ~190 générés (`*.g.dart`, `*.freezed.dart`, l10n) |
| Lignes de code | ~257 000 | |
| Features (`lib/features/`) | 23 | events (69 fichiers), petit_boo (52), booking (51), messages (50)… |
| Fichiers de test | **12** | couverture quasi nulle vs 257k lignes |
| CI/CD | **absente** | pas de `.github/workflows/` |
| `print`/`debugPrint` | **88 fichiers** | à nettoyer / router vers un logger |
| `TODO`/`FIXME`/`HACK` | 18 occurrences | |
| Plus gros widgets non générés | `filter_bottom_sheet.dart` (107 Ko), `new_conversation_form.dart` (81 Ko), `airbnb_search_sheet.dart` (81 Ko) | god widgets à découper |
| Secrets | `.env*` **gitignorés** mais **bundlés comme assets** | `API_KEY`, clés Stripe/Maps extractibles du binaire |
| Bug config repéré | [main.dart:95-99](../../../lib/main.dart#L95-L99) : `development` → charge `.env.production` | contredit `CLAUDE.md` |

> Ces chiffres servent de **baseline**. Chaque plan thématique les affine.

---

## 2. Méthodologie commune (à appliquer dans chaque plan)

1. **Cadrer** le périmètre exact (fichiers/dossiers concernés).
2. **Mesurer** automatiquement avant de lire (commandes `flutter analyze`, `grep`, `dart`…).
3. **Lire** les points chauds identifiés par la mesure.
4. **Classer** chaque constat avec l'échelle de gravité ci-dessous.
5. **Documenter** dans un rapport au format § 5, avec `fichier:ligne` cliquable.
6. **Proposer** un correctif et estimer l'effort (S / M / L).

### Outils & commandes de base

```bash
# Analyse statique (lints du projet + custom_lint/riverpod_lint)
flutter analyze
dart run custom_lint

# Formatage (détecter les écarts sans modifier)
dart format --output=none --set-exit-if-changed lib

# Dépendances obsolètes / contraintes
flutter pub outdated
flutter pub deps

# Régénération codegen (vérifier qu'elle passe)
dart run build_runner build --delete-conflicting-outputs

# Couverture de tests
flutter test --coverage

# Taille de l'app (release) — utile pour l'axe perf/build
flutter build apk --analyze-size --target-platform android-arm64
```

> ⚠️ Beaucoup de mesures `grep` doivent **exclure les fichiers générés** :
> `--glob '!*.g.dart' --glob '!*.freezed.dart' --glob '!**/generated/**'`.

---

## 3. Échelle de gravité (commune à tous les rapports)

| Niveau | Marqueur | Définition | Délai cible |
|--------|----------|------------|-------------|
| Critique | 🔴 P0 | Faille sécurité, perte de données, crash en masse, blocage paiement/réservation | Immédiat |
| Majeur | 🟠 P1 | Bug fonctionnel important, fuite mémoire, régression UX forte, dette bloquante | Sprint courant |
| Moyen | 🟡 P2 | Incohérence d'archi, manque de tests sur chemin critique, perf dégradée | Backlog priorisé |
| Mineur | 🟢 P3 | Style, nommage, dead code, `debugPrint`, doc | Opportuniste |
| Info | ⚪ i | Observation, piste d'amélioration, à confirmer | — |

Marqueurs de constat (repris de l'audit existant `qa-events-audit.md`) : ✅ conforme · ⚠️ à surveiller · ❌ problème.

---

## 4. Catalogue des plans

### Axes transverses

| # | Plan | Couvre | Priorité de passage |
|---|------|--------|---------------------|
| 01 | [Architecture & structure](01-architecture-structure.md) | Clean Architecture, séparation des couches, cohérence inter-features, routing, DI | Haute |
| 02 | [Qualité de code & conventions](02-qualite-code-conventions.md) | Lints, dead code, `print`, duplication, god files, nommage | Haute |
| 03 | [State management (Riverpod)](03-state-management-riverpod.md) | Cycle de vie providers, `autoDispose`, fuites, scope de rebuild, init eager | Haute |
| 04 | [Réseau, API & données](04-reseau-api-donnees.md) | Dio/Retrofit, interceptors, erreurs, retry/timeout, 401, DTO↔Entity, UUID, pagination | Haute |
| 05 | [Sécurité](05-securite.md) | Secrets, secure storage, cycle de vie token, deeplinks, ATS/cleartext, logs sensibles | **Critique** |
| 06 | [Performance](06-performance.md) | Rebuilds, images, listes, animations, démarrage, mémoire | Moyenne |
| 07 | [Tests & qualité logicielle](07-tests-qualite.md) | Couverture, pyramide de tests, priorités chemins critiques, mocking, golden | **Haute** |
| 08 | [Dépendances & configuration de build](08-dependances-build-config.md) | Packages obsolètes/abandonnés, flavors, switch d'env, codegen | Haute |
| 09 | [UI/UX & accessibilité](09-ui-ux-accessibilite.md) | Design system, dark mode, a11y (Semantics, contraste, tap target, text scaling), états | Moyenne |
| 10 | [Internationalisation (i18n/l10n)](10-internationalisation.md) | Couverture l10n, strings en dur, pluriels, formats, rollout | Moyenne |
| 11 | [Observabilité (crash & analytics)](11-observabilite-crash-analytics.md) | Crashlytics, Analytics, consentement RGPD, logging, breadcrumbs | Moyenne |
| 12 | [Plateforme iOS / Android](12-plateforme-ios-android.md) | Manifests, permissions, Info.plist/ATS, signing, min SDK, store readiness | Haute |
| 13 | [CI/CD & release](13-ci-cd-release.md) | Pipeline (analyze/test/build), gestion secrets, distribution, versioning | Haute |
| 14 | [Paiement, temps réel & push](14-paiement-realtime-push.md) | Stripe, Pusher/Reverb, SSE (Petit Boo), OneSignal, lifecycle/reconnexion | **Critique** |

### Par feature

| Document | Usage |
|----------|-------|
| [Gabarit d'audit feature](GABARIT-audit-feature.md) | Modèle réutilisable à dupliquer pour chacune des 23 features + table de suivi |

### Pilotage

| Document | Usage |
|----------|-------|
| [Plan d'exécution](PLAN-EXECUTION.md) | Runbook : boucle d'audit, phasage en 4 vagues, charges, jalons, tableau de bord, consolidation finale |

---

## 5. Modèle de rapport (livrable de chaque plan)

Chaque plan produit un fichier `docs/audits/resultats/<axe-ou-feature>-audit.md` :

```markdown
# Audit — <Axe / Feature>
Date : AAAA-MM-JJ · Branche : `xxx` · Auditeur : xxx

## Synthèse
- État global : 🔴 / 🟠 / 🟡 / 🟢
- Constats : N (🔴 x · 🟠 x · 🟡 x · 🟢 x)
- Top 3 actions prioritaires

## Constats détaillés
| # | Gravité | Constat | Fichier:ligne | Recommandation | Effort |
|---|---------|---------|---------------|----------------|--------|

## Points conformes (✅)
## Annexes (commandes lancées, sorties brutes)
```

---

## 6. Ordre d'exécution recommandé

```
Vague 1 (fondations / risque)   : 05 Sécurité · 04 Réseau · 01 Architecture · 14 Paiement-realtime
Vague 2 (fiabilité)             : 07 Tests · 03 State · 11 Observabilité · 08 Dépendances/Build
Vague 3 (qualité / livraison)   : 02 Qualité code · 06 Performance · 12 Plateforme · 13 CI-CD
Vague 4 (finition)              : 09 UI/UX-a11y · 10 i18n · puis audits par feature (gabarit)
```

Les axes peuvent être parallélisés entre auditeurs : 05/14 (un binôme « risque »),
07/13 (un binôme « fiabilité/livraison »), 09/10 (un binôme « front »).

> 📋 Le détail opérationnel (charges, dépendances, jalons J1-J4, tableau de bord,
> rituels, consolidation) est dans le [Plan d'exécution](PLAN-EXECUTION.md).

---

## 7. Critères de sortie (definition of done de l'audit)

- [ ] Les 14 axes ont un rapport au format § 5.
- [ ] Les 23 features ont une fiche issue du gabarit (au moins synthèse + constats P0/P1).
- [ ] Tous les 🔴 P0 ont un ticket et un correctif proposé.
- [ ] Une synthèse exécutive consolide les P0/P1 par thème avec une roadmap.
- [ ] La baseline (§ 1) est re-mesurée pour quantifier la dette résiduelle.
