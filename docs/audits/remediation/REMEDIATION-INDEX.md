# Index de remédiation — Le Hiboo (par ordre d'impact)

Date : 2026-05-28 · Source : [SYNTHESE-EXECUTIVE.md](../resultats/SYNTHESE-EXECUTIVE.md)

> Les correctifs de l'audit sont organisés en **5 tiers, du plus sûr (impact fonctionnel / risque de régression minimal) au plus structurant**. L'ordre est celui de **l'impact / blast radius**, pas de l'urgence métier — certains items urgents (sécurité, paiement) sont volontairement en Tier 3 car leur exécution a un fort blast radius et demande préparation.

---

## Vue d'ensemble

| Tier | Thème | Risque de régression | Effort | Quand |
|:----:|-------|:--------------------:|:------:|-------|
| **[0](TIER0-execution.md)** | Quick wins additifs/défensifs/tooling | **Quasi nul** | ~½ j | Tout de suite |
| **[1](TIER1-execution.md)** | Correctifs isolés (edge cases) + **réparer le toolchain** | **Faible** | ~1-2 j | Juste après T0 |
| **[2](TIER2-execution.md)** | Refactors par zone (erreurs, observabilité, perf, a11y, lint) | **Modéré** | ~2-4 sem | Après toolchain + CI |
| **[3](TIER3-execution.md)** | Fort blast radius (sécurité secrets, CI/CD, tests, env, legacy) | **Élevé / opérationnel** | ~2-4 sem | Créneaux dédiés + décisions |
| **[4](TIER4-execution.md)** | Initiatives architecturales (versions, legacy `Activity`, god widgets, design tokens) | **Élevé diffus** | Continu (XL) | Sous filet CI/tests |

---

## Détail par tier

### [Tier 0 — Quick wins](TIER0-execution.md) · risque quasi nul
Dé-tracker les artefacts (`.txt`) · supprimer les logs PII · `RegExp` en `static final` · privatiser les `State` · `userId` Crashlytics · non-fatal sur refresh token · localiser le widget d'erreur conversation.
→ **7 tâches, ~½ journée, commits atomiques.** Aucun changement du happy path.

### [Tier 1 — Correctifs isolés](TIER1-execution.md) · risque faible
⭐ **`.fvmrc`=3.38.7 + réparer le toolchain** (débloque `flutter test`) · restaurer les messages d'erreur paiement · garde de ré-entrée checkout · `PopScope` paiement · sécuriser `.value!` · `sendTimeout` · `.select` app bars · tap targets ≥48 · activer `custom_lint`/`riverpod_lint` · formatage prix/dates i18n.
→ **11 tâches.** Ne changent qu'un edge case / la config. **T1.1 est le pivot** : transforme la validation manuelle en validation automatisée.

### [Tier 2 — Refactors par zone](TIER2-execution.md) · risque modéré
A. `AppFailure` + `safeCall` · B. `AppLogger` + traiter `catch` vides/`dev.log` · C. `autoDispose` + `AppInitializer` · D. perf (AppBar hors scroll, `memCacheWidth`, markers) · E. accessibilité (Semantics, text scaling, contraste) · F. Dio Petit Boo + SSE + CancelToken · G. store readiness (PrivacyInfo, permissions iOS) · H. résorber les 1171 issues lint.
→ **8 lots thématiques**, chacun mergé/validé séparément.

### [Tier 3 — Fort blast radius](TIER3-execution.md) · risque élevé / décisions
A. 🟥 **rotation secrets + réécriture historique** · B. 🟦 sortir secrets du bundle · C. 🟦 corriger le switch d'env · D. 🟥 **CI/CD** (PR + Android) · E. signing release · F. minify/R8 + obfuscation · G. 🟦 supprimer le flow paiement legacy · H. **tests des chemins critiques**.
→ **Urgent au fond** (sécu, paiement) mais à exécuter avec **préparation + décisions** (🟦) et **coordination** (🟥).

### [Tier 4 — Architecture (epics)](TIER4-execution.md) · risque élevé diffus
A. montées de versions (Riverpod 3…) · B. éliminer la couche legacy `Activity` · C. entities/mappers manquants (fuite DTO) · D. décomposer les god widgets · E. `HibonsService` Riverpod-aware · F. design tokens + dark mode · G. couverture de tests progressive.
→ **Chantiers continus**, à mener **uniquement sous filet CI/tests** (Tier 3).

---

## Deux séquences de lecture

**Par sécurité d'exécution (ce fil)** : 0 → 1 → 2 → 3 → 4.

**Par urgence métier** (si l'objectif est « prod-ready » au plus vite) :
1. **Tier 0** (gratuit) +
2. **Tier 1 T1.1** (toolchain) +
3. **Tier 3 A/D/H** (sécurité secrets + CI + tests critiques) +
4. **Tier 3 G + Tier 1 T1.2-T1.4** (supprimer le paiement simulé + nettoyer le paiement réel) +
5. puis Tier 2 et le reste du Tier 3 en continu, Tier 4 en fond.

> Quel que soit l'ordre choisi, **réparer le toolchain (T1.1) est le multiplicateur** : sans lui, aucun tier n'est validable automatiquement.

---

## Suivi
Cocher l'avancement directement dans chaque fichier Tier (sections « Definition of Done »). Re-mesurer la **baseline** ([SYNTHESE-EXECUTIVE.md](../resultats/SYNTHESE-EXECUTIVE.md) §7) à chaque fin de tier pour quantifier la dette résorbée.
