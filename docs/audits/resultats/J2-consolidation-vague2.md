# Jalon J2 — Consolidation Vague 2 (Fiabilité)

Date : 2026-05-28 · Branche : `main` · Auditeur : Claude
Axes couverts : [07 Tests](07-tests-qualite-audit.md) · [03 State/Riverpod](03-state-management-riverpod-audit.md) · [11 Observabilité](11-observabilite-crash-analytics-audit.md) · [08 Dépendances/Build](08-dependances-build-config-audit.md)

> **Critère du jalon J2** : baseline de couverture mesurée + correctif du switch d'env.
> Statut : ⚠️ **Partiellement atteint** — la baseline est **chiffrée structurellement** mais la **couverture lcov est non mesurable** (le test suite ne compile pas, voir J2-P0-1). Le switch d'env est **documenté + correctif proposé**, non appliqué (décision produit).

---

## 1. État global par axe

| Axe | État | 🔴 P0 | 🟠 P1 | Note clé |
|-----|:----:|:-----:|:-----:|----------|
| 07 Tests | 🔴 Critique | 2 | 3 | ~2 % fichiers testés + **suite ne compile pas** |
| 11 Observabilité | 🟠 Majeur | 0 | 5 | CrashReporter dans 1 fichier, userId jamais posé |
| 03 State/Riverpod | 🟠 Majeur (socle sain) | 0 | 5 | dispose propre ✅ ; `autoDispose` manquants |
| 08 Dépendances/Build | 🟠 Majeur | 0 | 2 | bug switch d'env + signing debug + deps en retard |

---

## 2. Baseline de fiabilité (mesurée)

| Métrique | Valeur |
|----------|-------:|
| Fichiers de test / fichiers source | **12 / 593 (~2 %)** |
| Couverture lignes (lcov) | **non mesurable** (compilation KO) |
| `integration_test/` · golden · mock framework | 0 · 0 · aucun |
| `debugPrint` non gardés `kDebugMode` | **405** (87 fichiers) |
| `catch(_){}` vides | **36** (15 fichiers) |
| Appels `CrashReporter.recordError` | **2** (1 fichier) |
| Breadcrumbs Crashlytics | **0** |
| Deps directes à ≥1 majeure de retard | **~30** |

---

## 3. 🔴 P0 — Actions immédiates

| ID | Problème | Action | Axe |
|----|----------|--------|-----|
| **J2-P0-1** | **`flutter test` ne compile pas** : SDK `fvm 3.35.7` incohérent (`SemanticsFlags`/`SemanticsRole` absents de `dart:ui`), PATH = `flutter 3.32.5`, pas de `.fvmrc`. Bloque tout test/CI. | Réparer/aligner le SDK (`fvm install --force` ou 3.32.5) + committer `.fvmrc`. | [07](07-tests-qualite-audit.md) |
| **J2-P0-2** | **Chemins critiques non testés** (paiement réel, refresh token, realtime) ; le seul test booking cible le **flow mort** simulé. | Tests sur `api_booking_repository_impl` + `JwtAuthInterceptor` + compensation. | [07](07-tests-qualite-audit.md) |

## 4. 🟠 P1 — Sprint courant

| ID | Problème | Action | Axe |
|----|----------|--------|-----|
| J2-P1-1 | **Bug de switch d'env** : défaut → `.env.staging` (pas `.env.development`), `'development'` jamais mappé. Contredit CLAUDE.md. | Ajouter la branche `development` + statuer sur le défaut. **Décision produit** (impact CI/TestFlight). | [08](08-dependances-build-config-audit.md) |
| J2-P1-2 | **Signing release → clé debug** si keystore absent. | Faire échouer le build release sans keystore. | [08](08-dependances-build-config-audit.md) |
| J2-P1-3 | **userId Crashlytics jamais posé** + échec refresh token silencieux. | `setUserIdentifier` au login/logout + `CrashReporter` sur refresh. | [11](11-observabilite-crash-analytics-audit.md) |
| J2-P1-4 | **CrashReporter sous-utilisé** (1 fichier) + 36 `catch(_){}` vides → erreurs prod invisibles. | Instrumenter hot paths (auth/paiement/realtime), traiter les catch vides. | [11](11-observabilite-crash-analytics-audit.md) |
| J2-P1-5 | **`LeHibooApp.build()` surchargé** (~15 watch + mutation par rebuild). | Extraire dans un `AppInitializer`. | [03](03-state-management-riverpod-audit.md) |
| J2-P1-6 | **`autoDispose` manquants** + `.value!` non sûrs + providers déclarés dans des widgets. | Passer en `autoDispose`, sécuriser `.value!`, déplacer les providers. | [03](03-state-management-riverpod-audit.md) |
| J2-P1-7 | **Deps à ≥1 majeure** (firebase, secure_storage, stripe, go_router, riverpod 2→3, flutter_lints 3→6). | Chantier d'upgrade priorisé (sécurité → tooling → Riverpod 3). | [08](08-dependances-build-config-audit.md) |

---

## 5. Roadmap de remédiation (lots)

1. **Lot Toolchain & CI (préalable bloquant)** : réparer le SDK + `.fvmrc` → `flutter test`/`analyze` fonctionnels → CI minimale ([plan 13](../plans/13-ci-cd-release.md)). *(J2-P0-1)*
2. **Lot Tests critiques (sprint)** : booking réel + réseau (401/refresh) + mappers UUID ; ajouter `mocktail` + `integration_test`. *(J2-P0-2)*
3. **Lot Observabilité (sprint)** : `setUserIdentifier`, non-fatals sur refresh/paiement/realtime, traiter les catch vides, `AppLogger` central (`logger`, filtre release), breadcrumbs. *(J2-P1-3, J2-P1-4)*
4. **Lot State (continu)** : `AppInitializer`, `autoDispose`, `.value!`, `.select()`, sortir la pagination du filtre. *(J2-P1-5, J2-P1-6)*
5. **Lot Build/Deps (continu)** : switch d'env, signing, minify+obfuscation, upgrade deps, scan OSV. *(J2-P1-1, J2-P1-2, J2-P1-7)*

## 6. Quick wins (effort S, impact élevé)
- `.fvmrc` pinné. · `setUserIdentifier` Crashlytics. · Non-fatal sur échec refresh token. · Sécuriser les `.value!` (4 sites). · `authProvider.select((s)=>s.user)` dans les app bars. · Brancher `EnvConfig.analyticsEnabled` au boot. · Supprimer `build_log.txt`/`backend_request_email.txt` du repo.

## 7. Liens transverses avec la Vague 1
- Le **flow de paiement simulé mort** (J1) explique le test booking mal ciblé (J2-P0-2) et l'asymétrie Crashlytics (11 P2-6) → sa suppression résout 3 constats.
- Le **logging PII / token** recoupe J1 (sécurité) ; à traiter dans le **lot Observabilité** (AppLogger).
- Le **singleton `HibonsService`/`onForceLogout`** apparaît en axes 01, 03 → même remédiation (Riverpod-aware).

## 8. Suite (Vague 3)
Conformément au [plan d'exécution](../plans/PLAN-EXECUTION.md) : **02 Qualité code · 06 Performance · 12 Plateforme · 13 CI/CD**.
Le **lot Toolchain/CI (J2-P0-1)** est un préalable naturel à l'axe 13.
