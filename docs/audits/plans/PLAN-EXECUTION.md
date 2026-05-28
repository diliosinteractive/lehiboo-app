# Plan d'exécution de l'audit — Le Hiboo

> Runbook opérationnel : **comment dérouler** concrètement les plans de
> [00-index-audit-global.md](00-index-audit-global.md). Définit le séquençage, les charges,
> les dépendances, les jalons, le tableau de suivi et la consolidation finale.

Date : 2026-05-26 · Branche d'audit recommandée : `audit/2026-q2`

---

## 1. Principe : la boucle d'audit (par session)

Chaque session de travail sur un plan suit **toujours** les 6 étapes du plan maître :

```
1. Cadrer   → relire le plan, fixer le périmètre exact
2. Mesurer  → lancer les commandes (grep/analyze/test) AVANT de lire le code
3. Lire     → ouvrir uniquement les points chauds remontés par la mesure
4. Classer  → chaque constat avec gravité 🔴/🟠/🟡/🟢/⚪ + fichier:ligne
5. Documenter → remplir le rapport dans docs/audits/resultats/<axe>-audit.md
6. Proposer → correctif + effort (S < 0,5j · M 0,5-2j · L > 2j)
```

**Règle d'or** : un 🔴 P0 trouvé pendant une session est **escaladé immédiatement** (ticket + signalement), sans attendre la fin de l'axe.

---

## 2. Organisation & parallélisation

Découpage en **3 pistes** parallélisables (1 auditeur ou binôme par piste) :

| Piste | Focus | Axes |
|-------|-------|------|
| **A — Risque** | Sécurité & flux critiques | 05, 14, 04 |
| **B — Fiabilité** | Robustesse & socle | 01, 03, 07, 11 |
| **C — Qualité/Livraison** | Dette & mise en prod | 02, 06, 08, 12, 13, 09, 10 |

Les **audits par feature** (gabarit) démarrent après que les axes transverses ont posé les grilles de lecture (sinon on re-découvre les mêmes problèmes feature par feature).

---

## 3. Phasage (4 vagues)

### Vague 1 — Fondations & risque  ·  charge estimée ~6-8 j
> Objectif : éteindre les risques majeurs et poser les bases.

| Axe | Charge | Dépend de | Livrable |
|-----|:------:|-----------|----------|
| [05 Sécurité](05-securite.md) | M-L | — | Inventaire secrets classés + scan historique git |
| [04 Réseau/API](04-reseau-api-donnees.md) | M | — | Tableau endpoint × erreur/UUID/mapping |
| [01 Architecture](01-architecture-structure.md) | M | — | Carte des couches par feature + couplages |
| [14 Paiement/Realtime/Push](14-paiement-realtime-push.md) | L | 04, 05 | Diagramme d'états du flow réservation/paiement |

**Jalon J1** : tous les 🔴 P0 sécurité & paiement identifiés et ticketés.

### Vague 2 — Fiabilité  ·  charge estimée ~5-7 j
| Axe | Charge | Dépend de | Livrable |
|-----|:------:|-----------|----------|
| [07 Tests](07-tests-qualite.md) | M | 01, 04 | % couverture + backlog tests P0 |
| [03 State/Riverpod](03-state-management-riverpod.md) | M | 01 | Carte providers + fuites |
| [11 Observabilité](11-observabilite-crash-analytics.md) | S-M | 05 | Couverture crash + funnel analytics |
| [08 Dépendances/Build](08-dependances-build-config.md) | S-M | — | Tableau deps + correctif switch d'env |

**Jalon J2** : baseline de couverture mesurée + correctif du bug de sélection d'environnement.

### Vague 3 — Qualité & livraison  ·  charge estimée ~5-7 j
| Axe | Charge | Dépend de | Livrable |
|-----|:------:|-----------|----------|
| [02 Qualité code](02-qualite-code-conventions.md) | M | — | Top god files + plan logger |
| [06 Performance](06-performance.md) | M | 03 | Métriques écrans critiques |
| [12 Plateforme](12-plateforme-ios-android.md) | S-M | 05 | Matrice permissions + store readiness |
| [13 CI/CD](13-ci-cd-release.md) | M | 07 | Workflow CI minimal opérationnel |

**Jalon J3** : CI verte (analyze + test + build) sur la branche d'audit.

### Vague 4 — Finition & par feature  ·  charge estimée ~8-12 j
| Lot | Charge | Livrable |
|-----|:------:|----------|
| [09 UI/UX-a11y](09-ui-ux-accessibilite.md) + [10 i18n](10-internationalisation.md) | M | Rapport a11y + couverture l10n |
| Audits par feature (priorité : booking, auth, petit_boo, messages) | L | Fiches [gabarit](GABARIT-audit-feature.md) |
| Reste des 19 features | L | Fiches gabarit (synthèse + P0/P1 au minimum) |

**Jalon J4** : les 23 features ont au moins une synthèse + constats P0/P1.

---

## 4. Tableau de bord de suivi

### Axes transverses
| # | Axe | Piste | Vague | Statut | Rapport | 🔴 | 🟠 |
|---|-----|:-----:|:-----:|:------:|---------|:--:|:--:|
| 05 | Sécurité | A | 1 | ✅ Terminé | [05](../resultats/05-securite-audit.md) | 2 | 1 |
| 04 | Réseau/API | A | 1 | ✅ Terminé | [04](../resultats/04-reseau-api-donnees-audit.md) | 0 | 7 |
| 01 | Architecture | B | 1 | ✅ Terminé | [01](../resultats/01-architecture-structure-audit.md) | 0 | 8 |
| 14 | Paiement/Realtime/Push | A | 1 | ✅ Terminé | [14](../resultats/14-paiement-realtime-push-audit.md) | 1 | 3 |
| 07 | Tests | B | 2 | ✅ Terminé | [07](../resultats/07-tests-qualite-audit.md) | 2 | 3 |
| 03 | State/Riverpod | B | 2 | ✅ Terminé | [03](../resultats/03-state-management-riverpod-audit.md) | 0 | 5 |
| 11 | Observabilité | B | 2 | ✅ Terminé | [11](../resultats/11-observabilite-crash-analytics-audit.md) | 0 | 5 |
| 08 | Dépendances/Build | C | 2 | ✅ Terminé | [08](../resultats/08-dependances-build-config-audit.md) | 0 | 2 |
| 02 | Qualité code | C | 3 | ✅ Terminé | [02](../resultats/02-qualite-code-conventions-audit.md) | 0 | 8 |
| 06 | Performance | C | 3 | ✅ Terminé | [06](../resultats/06-performance-audit.md) | 0 | 6 |
| 12 | Plateforme | C | 3 | ✅ Terminé | [12](../resultats/12-plateforme-ios-android-audit.md) | 0 | 1 |
| 13 | CI/CD | C | 3 | ✅ Terminé | [13](../resultats/13-ci-cd-release-audit.md) | 0 | 2 |
| 09 | UI/UX-a11y | C | 4 | ✅ Terminé | [09](../resultats/09-ui-ux-accessibilite-audit.md) | 0 | 7 |
| 10 | i18n | C | 4 | ✅ Terminé | [10](../resultats/10-internationalisation-audit.md) | 0 | 3 |

> **Audits par feature** : [features-audit.md](../resultats/features-audit.md) (4 fiches + matrice des 23).
> **Clôture** : [SYNTHESE-EXECUTIVE.md](../resultats/SYNTHESE-EXECUTIVE.md). ✅ **Audit complet terminé** (14 axes + features).

> Statuts : ☐ À faire · 🔄 En cours · ✅ Terminé · ⏸️ Bloqué.
> La colonne « Rapport » pointe vers `docs/audits/resultats/<axe>-audit.md`.
> La table de suivi **par feature** vit dans le [gabarit](GABARIT-audit-feature.md#table-de-suivi-des-23-features).

---

## 5. Rituels & cadence

- **Triage P0 quotidien** : revue des 🔴 trouvés dans la journée → décision (hotfix immédiat / ticket sprint).
- **Point de fin de vague** : valider le jalon, mettre à jour le tableau de bord, ajuster les charges de la vague suivante.
- **Un commit = un constat traçable** : chaque rapport est commité au fil de l'eau sur `audit/2026-q2`.
- **Pas de correctif sauvage pendant l'audit** : on documente d'abord. Exception : 🔴 P0 sécurité/paiement (hotfix + note dans le rapport).

---

## 6. Consolidation finale (livrable de clôture)

À produire dans `docs/audits/resultats/SYNTHESE-EXECUTIVE.md` une fois les 14 axes terminés :

1. **Synthèse exécutive** : état global de l'app, top 10 des risques, dette par thème.
2. **Tableau consolidé P0/P1** : tous axes + features confondus, trié par gravité.
3. **Roadmap de remédiation** : regroupée par lot (Sécurité, Stabilité paiement, Tests/CI, Dette, UX/a11y), avec effort cumulé.
4. **Re-mesure de la baseline** (§1 de l'index) : quantifier la dette résiduelle vs initiale.
5. **Quick wins** (effort S, impact élevé) listés à part pour exécution immédiate.

---

## 7. Critères de sortie (definition of done global)

- [ ] Les 14 axes ont un rapport au format § 5 du plan maître.
- [ ] Les 23 features ont une fiche issue du gabarit (synthèse + P0/P1 minimum).
- [ ] Tous les 🔴 P0 ont un ticket + correctif proposé (et les P0 sécu/paiement sont traités).
- [ ] CI opérationnelle (analyze + test + build) sur la branche d'audit.
- [ ] `SYNTHESE-EXECUTIVE.md` produite avec roadmap et re-mesure de baseline.
- [ ] Tableau de bord (§4) entièrement à jour (aucun ☐ restant).
