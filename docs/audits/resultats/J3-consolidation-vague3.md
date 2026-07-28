# Jalon J3 — Consolidation Vague 3 (Qualité & livraison)

Date : 2026-05-28 · Branche : `main` · Auditeur : Claude
Axes couverts : [02 Qualité code](02-qualite-code-conventions-audit.md) · [06 Performance](06-performance-audit.md) · [12 Plateforme](12-plateforme-ios-android-audit.md) · [13 CI/CD](13-ci-cd-release-audit.md)

> **Critère du jalon J3** : « CI verte (analyze + test + build) sur la branche d'audit ».
> Statut : ❌ **non atteint** — il n'existe aucune CI analyze/test, et `flutter test` ne compile pas ([J2-P0-1](J2-consolidation-vague2.md)). `flutter analyze` passe (1171 issues, exit 0) et le build iOS Xcode Cloud fonctionne. **Préalable bloquant** : unifier/réparer le toolchain Flutter sur **3.38.7** (version CI) puis ajouter la CI de PR proposée ([axe 13 §3](13-ci-cd-release-audit.md)).

---

## 1. État global par axe

| Axe | État | 🔴 | 🟠 P1 | Note clé |
|-----|:----:|:--:|:-----:|----------|
| 02 Qualité code | 🟠 Majeur | 0 | 8 | 1171 issues, lint sous-exploité, god widgets |
| 06 Performance | 🟠 Majeur (socle correct) | 0 | 6 | `setState` plein écran au scroll, images non dimensionnées |
| 12 Plateforme | 🟢 Bon | 0 | 1 | PrivacyInfo absent ; deeplinks/permissions exemplaires |
| 13 CI/CD | 🟠 Majeur | 0 | 2 | CI iOS-only, aucune validation de PR |

---

## 2. Synthèse chiffrée

| Métrique | Valeur |
|----------|-------:|
| `flutter analyze` | **1171 issues** (exit 0, non bloquant) |
| God files > 800 / > 2000 lignes | **≥7 / 3** |
| `debugPrint` non gardés | **~405** |
| `catch(_){}` (vides → quasi-vides) | **36 → 82** |
| `CachedNetworkImage` sans `memCacheWidth` | **56** (41 fichiers) |
| Couleurs raw `Color(0xFF…)` / `Colors.grey.shade*` | **539 / 581** |
| Dimensions en dur | **4258** (215 fichiers) |
| Versions Flutter divergentes | **3** (CI 3.38.7 / local 3.32.5 / fvm 3.35.7 cassé) |

---

## 3. 🟠 P1 — Priorités de la vague

| ID | Problème | Action | Axe |
|----|----------|--------|-----|
| J3-P1-1 | **Pas de CI de PR** (ni analyze, ni test, ni build) → régressions libres. | Ajouter `.github/workflows/ci.yml` (proposition fournie). | [13](13-ci-cd-release-audit.md) |
| J3-P1-2 | **Lint sous-exploité** : `flutter_lints` 3.0, `riverpod_lint`/`custom_lint` non activés, `avoid_print` off, 1171 issues. | Lint moderne + `custom_lint:` + résorption par lots. | [02](02-qualite-code-conventions-audit.md) |
| J3-P1-3 | **`setState` plein écran au scroll** (home + détail event) → jank certain. | Isoler l'AppBar (`ValueNotifier`/sous-widget). | [06](06-performance-audit.md) |
| J3-P1-4 | **Images non dimensionnées** (56 `CachedNetworkImage`, 0 `memCacheWidth`) → surconsommation RAM. | `memCacheWidth` ≈ 2× taille d'affichage. | [06](06-performance-audit.md) |
| J3-P1-5 | **`PrivacyInfo.xcprivacy` absent** → risque de rejet App Store. | Ajouter le privacy manifest. | [12](12-plateforme-ios-android-audit.md) |
| J3-P1-6 | **God widgets > 2000 lignes** (filter_bottom_sheet, new_conversation_form, airbnb_search_sheet). | Découpage en sous-widgets. | [02](02-qualite-code-conventions-audit.md) |
| J3-P1-7 | **CI/CD Android inexistante** + signing release → clé debug si keystore absent. | Workflow Android signé. | [13](13-ci-cd-release-audit.md) / [08](08-dependances-build-config-audit.md) |
| J3-P1-8 | **`markers` carte reconstruits à chaque pan/zoom** + `LeHibooApp` observe 11 providers. | Mémoïser markers ; isoler les watches. | [06](06-performance-audit.md) |

> Sur-permissionnement iOS « Always » location + `UIFileSharingEnabled` (🟡, [12](12-plateforme-ios-android-audit.md)) ; dark mode factice + magic numbers/couleurs à grande échelle (🟡, [02](02-qualite-code-conventions-audit.md)).

---

## 4. Roadmap de remédiation (lots)

1. **Lot Toolchain & CI (préalable, débloque J3)** : `.fvmrc`=3.38.7 + réparer local → CI de PR (analyze+test+build) + CI Android signée. *(J3-P1-1, J3-P1-7, J2-P0-1)*
2. **Lot Lint & dette (continu)** : lint moderne + `custom_lint` → résorber 1171 issues + découper god widgets + `AppLogger`. *(J3-P1-2, J3-P1-6)*
3. **Lot Performance (sprint)** : AppBar hors scroll, `memCacheWidth`, mémo markers, isoler `LeHibooApp`, `const`/RepaintBoundary. *(J3-P1-3, J3-P1-4, J3-P1-8)*
4. **Lot Store-readiness (avant release)** : `PrivacyInfo.xcprivacy`, réduire permissions iOS, aligner versions. *(J3-P1-5, axe 12)*

## 5. Quick wins (effort S, impact élevé)
- `.fvmrc` = 3.38.7. · Activer `custom_lint`/`riverpod_lint` + `avoid_print`. · Isoler l'AppBar du scroll (2 écrans). · `static final RegExp` (password, uuid). · Retirer permission iOS « Always » location. · Supprimer `font_awesome_flutter` (1 usage). · Préfixer `_PulseAnimationState`/`_ShakeWidgetState`.

## 6. Liens transverses
- **Toolchain** : J3 (CI) dépend de J2-P0-1 (tests ne compilent pas) → la version canonique est **3.38.7** (CI iOS).
- **Code debug/legacy** : récurrent en V1 (14), V2 (07), V3 (02) → une seule suppression résout plusieurs constats.
- **Logging/`catch` vides** : V2 (11) ↔ V3 (02) → un seul `AppLogger`.
- **`LeHibooApp.build()` surchargé** : V2 (03) ↔ V3 (06) → même remédiation.
- **`EventToActivityMapper`/legacy `Activity`** : V1 (01) ↔ V3 (02) → migration progressive.

## 7. Suite (Vague 4 — finition)
Conformément au [plan d'exécution](../plans/PLAN-EXECUTION.md) : **09 UI/UX-a11y · 10 i18n** + **audits par feature** (gabarit ; priorité booking, auth, petit_boo, messages). Puis **synthèse exécutive** finale (`SYNTHESE-EXECUTIVE.md`) avec re-mesure de la baseline.
