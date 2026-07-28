# Plan 04 — Réseau, API & données

Objectif : auditer la couche réseau (Dio/Retrofit), la robustesse des appels,
la gestion d'erreurs, et la fidélité du mapping DTO↔Entity face au contrat backend.

## Périmètre
- `lib/config/dio_client.dart`, `lib/core/network/`
- Tous les `*_api_datasource.dart`, `*_repository_impl.dart`, `*_dto.dart`, `*_mapper.dart`
- `openapi.yaml` (contrat de référence à la racine)
- SSE Petit Boo (`petit_boo_sse_datasource.dart`) — voir aussi plan 14

## Risques connus / hypothèses
- ⚠️ **Bug UUID vs id numérique** documenté dans `CLAUDE.md` (404 sur `/favorites/{id}/toggle`). À re-vérifier sur **toutes** les routes paramétrées.
- ⚠️ DTO avec **double champ camelCase/snake_case** (backend incohérent) — fragilité de parsing.
- ⚠️ Gestion d'erreur **absente** sur certaines méthodes datasource (constaté pour Q&A : `markQuestionHelpful` sans try/catch).
- ⚠️ Intercepteur 401 → `DioClient.onForceLogout` câblé depuis `build()` de `LeHibooApp` (couplage UI/réseau).

## Checklist
- [ ] **Configuration Dio** : `baseUrl`, `connectTimeout`, `receiveTimeout`, `sendTimeout` définis et raisonnables.
- [ ] **Intercepteurs** : auth (injection token), refresh/logout 401, logging (désactivé en release ? cf. `pretty_dio_logger`), header `Host` custom (reverse proxy), headers sécurité (`SECURITY_HEADER_NAME`).
- [ ] **Gestion d'erreurs unifiée** : un type d'erreur métier (ex. `Failure`/exception) ; pas de `DioException` qui remonte brut jusqu'à l'UI.
- [ ] **Retry / backoff** : présent pour les appels idempotents ? Politique sur timeout/erreur réseau.
- [ ] **Mapping fidèle au contrat** : comparer chaque DTO au `openapi.yaml` (champs, types, nullabilité). Repérer les champs ignorés ou mal typés.
- [ ] **Règle UUID** : toute route `/{event}`, `/{booking}`, `/{uuid}` reçoit bien l'UUID, pas le hash numérique.
- [ ] **Parsing défensif** : helpers `_parseInt/_parseBool/_parseString` cohérents et centralisés (éviter la duplication entre DTO).
- [ ] **Pagination** : `meta` (currentPage/lastPage…) gérée uniformément ; pas de chargement de listes entières.
- [ ] **Annulation** : `CancelToken` sur les recherches/typeahead pour éviter les réponses obsolètes.
- [ ] **Offline / connectivité** : comportement sans réseau (message clair, pas de crash) ; cache éventuel.
- [ ] **Sécurité transport** : pas d'URL `http://` en prod (cf. plan 05) ; `apiHost`/reverse proxy maîtrisés.
- [ ] **Cohérence base URL** : `EnvConfig.apiBaseUrl` (fallback `https://api.lehiboo.com/api/v1`) vs valeurs `.env` chargées (cf. bug switch d'env, plan 08).
- [ ] **Désérialisation des erreurs** : messages backend (`{"message": "..."}`) exploités pour l'UX.

## Commandes / mesures
```bash
# Datasources & repositories
fd -e dart 'api_datasource|repository_impl' lib/features

# Routes paramétrées — vérifier l'usage d'UUID
rg -n "toggle|/cancel|/confirm|payment-intent|/tickets|\{event\}|\{booking\}|\{uuid\}" lib --glob '!*.g.dart'

# Méthodes sans gestion d'erreur (datasources)
rg -n "Future<.*> \w+\(" lib/features --glob '!*.g.dart' | rg "datasource"
rg -n "try \{|catch \(|on DioException" lib/features --glob '!*.g.dart'

# URLs en dur / http
rg -n "http://|https://" lib --glob '!*.g.dart' --glob '!**/generated/**'

# Timeouts Dio
rg -n "Timeout|connectTimeout|receiveTimeout|sendTimeout" lib/config lib/core/network
```

## Livrable
Tableau endpoint × (gestion erreur / UUID / mapping conforme openapi / pagination), liste des DTO divergents du contrat, recommandation d'un gestionnaire d'erreurs unifié et d'une politique retry/timeout.
