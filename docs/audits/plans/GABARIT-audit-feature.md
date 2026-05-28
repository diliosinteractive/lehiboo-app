# Gabarit d'audit par feature

> À **dupliquer** pour chaque feature dans `docs/audits/resultats/<feature>-audit.md`.
> S'inspire de l'audit existant `docs/audits/qa-events-audit.md` (couche par couche,
> marqueurs ✅ / ⚠️ / ❌) et applique l'échelle de gravité du [plan maître](00-index-audit-global.md).

---

## Table de suivi des 23 features

> Tailles indicatives (nb de fichiers Dart). Cocher au fur et à mesure.

| Feature | Fichiers | Audit fait | État | Lien rapport |
|---------|:-------:|:----------:|------|--------------|
| events | 69 | ☐ | | |
| petit_boo | 52 | ☐ | | |
| booking | 51 | ☐ | | (recoupe [plan 14](14-paiement-realtime-push.md)) |
| messages | 50 | ☐ | | (recoupe [plan 14](14-paiement-realtime-push.md)) |
| gamification | 45 | ☐ | | |
| reviews | 38 | ☐ | | |
| auth | 38 | ☐ | | (recoupe [plan 05](05-securite.md)) |
| home | 30 | ☐ | | |
| memberships | 25 | ☐ | | |
| partners | 24 | ☐ | | |
| checkin | 20 | ☐ | | |
| favorites | 17 | ☐ | | |
| search | 15 | ☐ | | |
| trip_plans | 10 | ☐ | | |
| profile | 9 | ☐ | | |
| notifications | 9 | ☐ | | (recoupe [plan 14](14-paiement-realtime-push.md)) |
| blog | 9 | ☐ | | |
| user_questions | 7 | ☐ | | |
| thematiques | 7 | ☐ | | |
| stories | 7 | ☐ | | |
| reminders | 7 | ☐ | | |
| alerts | 7 | ☐ | | |
| onboarding | 2 | ☐ | | |

**Priorité suggérée** : booking + auth + petit_boo + messages (enjeux paiement/sécu/realtime),
puis events + home + search (cœur produit), puis le reste.

---

## Modèle de fiche (copier-coller ci-dessous)

```markdown
# Audit feature — <Nom>
Date : AAAA-MM-JJ · Branche : `xxx` · Auditeur : xxx

## 0. Synthèse
- État global : 🔴 / 🟠 / 🟡 / 🟢
- Constats : 🔴 x · 🟠 x · 🟡 x · 🟢 x
- Top 3 actions

## 1. Localisation & architecture
| Couche | Fichier | Lignes | État |
|--------|---------|-------:|:----:|
| Data — DTOs | | | |
| Data — Datasource | | | |
| Data — Mappers | | | |
| Data — Repository impl | | | |
| Domain — Entities | | | |
| Domain — Repository interface | | | |
| Domain — Usecases | | | |
| Presentation — Providers/Controllers | | | |
| Presentation — Screens | | | |
| Presentation — Widgets | | | |
- Respect Clean Architecture : ✅/⚠️/❌ (presentation importe des DTO ? repo/entity manquants ?)
- Couplage vers d'autres features : …

## 2. Data layer
- DTOs : champs, nullabilité, conformité `openapi.yaml`, double camelCase/snake_case ?
- Datasource : endpoints, **règle UUID**, gestion d'erreur par méthode, pagination
- Mappers : DTO→Entity complet, règle `uuid ?? id.toString()`

## 3. Domain layer
- Entities (Equatable ?), repository interface, logique métier placée correctement

## 4. Presentation layer
- Providers Riverpod : cycle de vie (autoDispose/keepAlive), fuites, scope de rebuild
- Écrans : états loading/empty/error/success, navigation, deep links
- Widgets : god widgets, const, réutilisation, a11y (Semantics)

## 5. Transverse (renvoyer aux plans dédiés)
- Sécurité (05) : … · Réseau (04) : … · Perf (06) : … · i18n (10) : … · Observabilité (11) : …

## 6. Tests
- Existants : … · Manquants prioritaires : … · Couverture estimée : …

## 7. Constats détaillés
| # | Gravité | Constat | Fichier:ligne | Recommandation | Effort |
|---|---------|---------|---------------|----------------|--------|

## 8. Points conformes (✅)
```

---

## Checklist express par feature (rappel)

- [ ] Couches Clean Architecture présentes et bien orientées (pas de DTO en presentation).
- [ ] Règle **UUID vs id** respectée dans les mappers et appels API.
- [ ] Gestion d'erreur sur **chaque** méthode datasource.
- [ ] Providers : cycle de vie correct, pas de fuite (subscriptions/timers/controllers).
- [ ] États UI complets (loading/empty/error/success) + a11y de base.
- [ ] Strings localisées (pas de texte en dur) — recoupe [plan 10](10-internationalisation.md).
- [ ] Pas de `print`/`debugPrint` résiduels ni de secret loggé.
- [ ] Tests présents sur le chemin critique de la feature.
- [ ] Pas de god file > 600 lignes non justifié.
