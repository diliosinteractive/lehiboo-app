# Audit — Axe 04 Réseau, API & données

Date : 2026-05-26 · Branche : `main` · Auditeur : Claude (+ agent exploration) · Plan : [04-reseau-api-donnees.md](../plans/04-reseau-api-donnees.md)

## Synthèse
- **État global : 🟠 Majeur** — socle réseau globalement solide (intercepteurs, résilience JSON, refresh token, `ApiResponseHandler`), mais **gestion d'erreur absente sur de nombreux datasources** et **pas de type `Failure` métier unifié**.
- Constats : **~20** (🔴 0 · 🟠 7 · 🟡 8 · 🟢 5 + informatifs)
- **Top 3 actions** :
  1. Introduire un type d'erreur métier (`AppFailure`) + wrapper `safeCall<T>()` et l'appliquer aux datasources sans try/catch.
  2. Corriger `getBookingById(int)` → UUID, et supprimer le DTO booking legacy (`booking_dto.dart`).
  3. Ajouter `sendTimeout` aux 3 configs Dio.

> Note de réconciliation : l'agent a classé le log du token Bearer en P0 ; **vérifié comme protégé par `kDebugMode`** (strippé en release) → re-classé 🟢/info ici, traité côté [audit sécurité](05-securite-audit.md).

---

## Constats détaillés

### 🟠 P1 — Majeurs
| # | Constat | Fichier:ligne | Recommandation |
|---|---------|---------------|----------------|
| P1-1 | **Aucun type `Failure` métier unifié** (`class Failure` → 0 résultat). Les `DioException` remontent brutes jusqu'aux providers, affichées via `error.toString()` ("DioException [bad response]…"). | global | Créer `core/utils/app_failure.dart` + wrapper `safeCall<T>()`. |
| P1-2 | **Datasources sans try/catch ni `on DioException`** (erreurs non traduites) : `stories`, `reminders`, `in_app_notifications`, `checkin`, `reviews` (8/10), `favorites` (toutes), `events` (`getHomeFeed`, `getEventAvailability`, `getCategories`, `getThematiques`, `getCities`, `getFilters`, `getSearchSuggestions`), `booking` (`createBooking`, `createBookingDraft`, `getPaymentIntent`, `confirmBooking`, `confirmFreeBooking`). | multiples datasources | Appliquer `safeCall`/`ApiResponseHandler` partout. |
| P1-3 | **`getBookingById(int bookingId)` → `GET /me/bookings/$bookingId`** : viole la règle UUID (backend route par UUID → 404 si appelé avec un id numérique). | [booking_api_datasource.dart:293-298](../../../lib/features/booking/data/datasources/booking_api_datasource.dart#L293-L298) | Signature `String bookingUuid`. Vérifier les appelants. |
| P1-4 | **Double DTO booking incompatibles** : `booking_dto.dart` (V1, `id: String`) vs `booking_api_dto.dart` (V2, `id: int` + `uuid: String?`) ; `BookingItemDto` défini 2×. `booking_mapper.dart:8` fait `id.toString()` (risque id numérique). | [booking_dto.dart](../../../lib/features/booking/data/models/booking_dto.dart), [booking_api_dto.dart:226](../../../lib/features/booking/data/models/booking_api_dto.dart#L226) | Supprimer `booking_dto.dart` (legacy), aligner mapper sur `uuid`. |
| P1-5 | **`sendTimeout` non défini** dans les 3 `BaseOptions` (Dio principal, refresh, Petit Boo) → upload lent peut rester suspendu. | [dio_client.dart:38-48](../../../lib/config/dio_client.dart#L38-L48), `dio_client.dart:313-340`, [petit_boo_api_datasource.dart:19-29](../../../lib/features/petit_boo/data/datasources/petit_boo_api_datasource.dart#L19-L29) | Ajouter `sendTimeout: AppConstants.apiTimeout`. |
| P1-6 | **Dio Petit Boo parallèle sans intercepteurs hérités** : pas de security header, `Accept-Language`, retry JSON, ni gestion 401/refresh (un 401 Petit Boo ne force pas le logout). | [petit_boo_api_datasource.dart:17-53](../../../lib/features/petit_boo/data/datasources/petit_boo_api_datasource.dart#L17-L53) | Factory partagé dans `DioClient` ou héritage des intercepteurs. |
| P1-7 | **Pas de `CancelToken` sur le typeahead** `/search/suggestions` : le debounce Riverpod annule le provider mais pas la requête en vol → réponses obsolètes possibles. | [events_api_datasource.dart:543-559](../../../lib/features/events/data/datasources/events_api_datasource.dart#L543-L559), [filter_provider.dart:826-831](../../../lib/features/search/presentation/providers/filter_provider.dart#L826-L831) | `CancelToken` annulé à chaque frappe. |

### 🟡 P2 — Moyens
| # | Constat | Fichier:ligne | Recommandation |
|---|---------|---------------|----------------|
| P2-1 | Helpers `_parseInt/_parseBool/_parseString/_parseDouble` **dupliqués dans ≥5 fichiers** (signatures divergentes). | event_dto.dart (source), event_availability_dto.dart, favorite_list_dto.dart, favorites_api_datasource.dart, trip_plan_dto.dart | Centraliser dans `core/utils/json_parse_helpers.dart`. |
| P2-2 | `alertsApiDataSource.createAlert` parse `response.data` brut (sans `ApiResponseHandler`) → champs `null` si enveloppe `{success,data}`. | [alerts_api_datasource.dart:96-98](../../../lib/features/alerts/data/datasources/alerts_api_datasource.dart#L96-L98) | `ApiResponseHandler.extractObject`. |
| P2-3 | `confirmOrder` envoie `payment_intent_id` **ET** `paymentIntentId` (doublon → incertitude contrat). | [booking_api_datasource.dart:222-231](../../../lib/features/booking/data/datasources/booking_api_datasource.dart#L222-L231) | Garder `payment_intent_id` seul. |
| P2-4 | DTO avec **fallback dual camelCase/snake_case** (`sort_order ?? sortOrder`…) masquant l'incohérence backend. | favorite_list_dto.dart:46-48, profile_api_datasource.dart:29-32, trip_plan_dto.dart:47-62 | Documenter le format canonique, retirer le fallback si backend stable. |
| P2-5 | `JsonRetryInterceptor` log `debugPrint` **non gardé** `kDebugMode` (leak possible en Flutter Web). | [json_resilience.dart:115-116](../../../lib/core/network/json_resilience.dart#L115-L116) | Encapsuler `if (kDebugMode)`. |
| P2-6 | `PetitBooSseDataSource` crée un `http.Client()` par appel sans `try/finally` → fuite TCP sur exception. (Recoupe C1 de l'[audit 14](14-paiement-realtime-push-audit.md).) | [petit_boo_sse_datasource.dart:86](../../../lib/features/petit_boo/data/datasources/petit_boo_sse_datasource.dart#L86) | `try { … } finally { client.close(); }`. |
| P2-7 | `_isRefreshing` (bool mutable) dans `JwtAuthInterceptor` — sûr grâce à `QueuedInterceptor` mais code trompeur. | [dio_client.dart:136,218-270](../../../lib/config/dio_client.dart#L136) | `Completer<void>?` ou doc explicite. |
| P2-8 | Pagination absente : `getMyFavorites`, `getMyAlerts`, `getMyReminders` (`perPage:50` codé en dur), `getMyTickets` chargent des listes entières. | favorites/alerts/reminders datasources | Pagination ou plafond documenté. |

### 🟢 P3 — Mineurs
- Commentaire trompeur `FavoriteEventDto.id // for API calls` alors que l'API attend l'UUID ([favorites_api_datasource.dart:161-165](../../../lib/features/favorites/data/datasources/favorites_api_datasource.dart#L161-L165)).
- Normalisation pagination inline de 97 lignes mêlant parsing/métier ([events_api_datasource.dart:155-252](../../../lib/features/events/data/datasources/events_api_datasource.dart#L155-L252)).
- `http` utilisé en parallèle de Dio (SSE, `company_search_service` api.gouv.fr, auth Pusher) — **justifié**, à documenter.
- `HibonsUpdateInterceptor` log « no envelope » sur quasi toutes les réponses (pollution debug).
- `enableOfflineMode=false` sans fallback réel ([app_constants.dart:149](../../../lib/core/constants/app_constants.dart#L149)).
- Désalignement spec : `customer_birth_date`/`customer_town` envoyés mais absents de `openapi.yaml`.
- Log token Bearer **gardé `kDebugMode`** (re-classé depuis P0 ; cf. [sécurité](05-securite-audit.md)).

---

## Tableau endpoint × (gestion erreur / UUID / pagination) — extrait
| Endpoint | Try/catch | UUID OK | Pagination |
|----------|:---------:|:-------:|:----------:|
| `GET /events` | ❌ | N/A | ✅ (meta manuelle) |
| `GET /events/{identifier}` | ✅ (403/404) | ✅ | N/A |
| `POST /me/favorites/{uuid}/toggle` | ❌ | ✅ | N/A |
| `POST /bookings` | ❌ | ✅ | N/A |
| `POST /bookings/{uuid}/confirm` | ❌ | ✅ | N/A |
| `GET /bookings/{uuid}/tickets` | ⚠️ partiel | ✅ | N/A |
| `POST /me/bookings/{uuid}/cancel` | ✅ | ✅ | N/A |
| `GET /me/bookings/{id}` | ❌ | ❌ **(int)** | N/A |
| `GET /me/bookings` | ❌ | N/A | ✅ |

---

## Points conformes (✅)
- **Règle UUID respectée** sur la majorité : `toggleFavorite`, `cancelBooking`, `getPaymentIntent`, `confirmBooking`, `confirmFreeBooking`, `getBookingTickets`. `EventMapper.toEvent` applique `dto.uuid ?? dto.id.toString()` ([event_mapper.dart:151](../../../lib/features/events/data/mappers/event_mapper.dart#L151)).
- **`pretty_dio_logger` désactivé en release** (`if (kDebugMode)`) ([dio_client.dart:74-88](../../../lib/config/dio_client.dart#L74-L88)).
- **Refresh token** via Dio séparé (`_buildRefreshDio`) → pas de boucle ; `JwtAuthInterceptor extends QueuedInterceptor` (pas de refresh concurrents). 401 → `onForceLogout` câblé ([main.dart:309](../../../lib/main.dart#L309)).
- **`ApiResponseHandler`** unifie 5 formats de réponse Laravel + `extractError()` localisé.
- **Résilience JSON** : `DiagnosticJsonTransformer` + `JsonRetryInterceptor` (retry GET only, sur `FormatException`) — bien isolés dans `json_resilience.dart`.
- **Sécurité transport** : URLs prod HTTPS ; aucune `http://` en dur (les deux occurrences sont du routing deeplink).

## Annexes
- Source : agent d'exploration code-explorer (89 outils, ~408 s). Réconciliations de gravité appliquées par l'auditeur (token logging P0→P3).
