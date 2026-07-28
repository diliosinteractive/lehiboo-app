# Plan 01 — Architecture & structure

Objectif : vérifier l'application réelle de la **Clean Architecture** (data / domain / presentation)
et la **cohérence** entre les 23 features, sachant qu'un audit existant
(`qa-events-audit.md`) a déjà montré une architecture *mixte* (DTO utilisés directement
en presentation, repositories/entities absents pour certaines sous-features).

## Périmètre
- `lib/core/`, `lib/config/`, `lib/shared/`, `lib/routes/`
- `lib/features/*/{data,domain,presentation}/`
- `lib/data/`, `lib/domain/` (couches « legacy » à la racine — à clarifier)

## Risques connus / hypothèses à vérifier
- ⚠️ Double emplacement : `lib/data` + `lib/domain` à la racine **et** dans chaque feature → modèle hérité (activity) vs nouveau.
- ⚠️ DTO consommés directement par la presentation (contournement du mapper/entity).
- ⚠️ Sous-features sans repository ni entity (ex. Q&A events).
- ⚠️ DI centralisée dans `main.dart` via overrides manuels (`_getRealApiOverrides`) — couplage fort, ordre d'init implicite.

## Checklist
- [ ] **Couches respectées** : pour chaque feature, présence cohérente de `data/{models,mappers,datasources,repositories}`, `domain/{entities,repositories,usecases}`, `presentation/{screens,widgets,providers}`.
- [ ] **Sens des dépendances** : `presentation → domain ← data`. Vérifier qu'aucun `screen/widget/provider` n'importe un `*_dto.dart` directement.
- [ ] **Mapping DTO→Entity systématique** : chaque datasource renvoie des entities (ou le repository mappe), jamais des DTO vers la presentation.
- [ ] **Règle UUID vs id** (cf. `CLAUDE.md`) appliquée dans tous les mappers Event/Booking : `id: dto.uuid ?? dto.id.toString()`.
- [ ] **Couche legacy** : statuer sur `lib/data` + `lib/domain` racine (activity) — migrer ou documenter comme déprécié.
- [ ] **`usecases/`** : présents ? Si la logique métier vit dans les providers/repositories, le documenter comme choix assumé.
- [ ] **Cohérence de nommage des dossiers** entre features (`controllers/` vs `providers/`, `application/` chez gamification…).
- [ ] **Routing** : `lib/routes/app_router.dart` — routes typées (go_router_builder) vs strings, gestion des guards d'auth, deep links, redirections.
- [ ] **Barrel files / imports** : imports relatifs vs `package:lehiboo/...` (mix constaté dans `main.dart`).
- [ ] **Frontières features** : détecter les imports croisés entre features (couplage). Une feature devrait dépendre de `core/shared`, pas d'une autre feature.
- [ ] **`core/` cohérent** : `analytics, constants, deeplinks, l10n, mock, network, providers, realtime, services, themes, utils, widgets` — pas de logique métier de feature qui aurait fui dans `core`.

## Commandes / mesures
```bash
# Presentation important-elle des DTO directement ? (anti-pattern)
rg -n "import .*_dto\.dart" lib/features --glob '!*.g.dart' --glob '!*.freezed.dart' \
  | rg "/presentation/"

# Imports croisés entre features (couplage inter-features)
rg -n "import 'package:lehiboo/features/" lib/features --glob '!*.g.dart' \
  | rg -v "features/(\w+)/.*features/\1/"   # à raffiner par feature

# Features sans couche domain/repositories
for f in lib/features/*/; do
  [ -d "${f}domain/repositories" ] || echo "NO domain/repositories: $f"
done

# Mappers respectant la règle UUID
rg -n "id: .*\.id\.toString\(\)" lib/features --glob '!*.g.dart'   # suspects sans uuid fallback
```

## Livrable
Tableau par feature : couches présentes/absentes, écarts à la Clean Architecture, couplages inter-features, conformité règle UUID. Schéma de dépendances cible si refonte recommandée.
