# Analyse du système d'authentification & déconnexions aléatoires

> Analyse réalisée le 2026-06-04 sur la branche `main`.
> Objectif : documenter le fonctionnement complet du flow d'auth de l'app Flutter et identifier les causes possibles des déconnexions inopinées rapportées par les utilisateurs.

---

## 1. TL;DR — Causes les plus probables des déconnexions « aléatoires »

Classées par probabilité d'expliquer le symptôme.

| # | Cause | Gravité | Mécanisme résumé |
|---|-------|---------|------------------|
| **C1** | **`refresh_token` = `access_token` (fallback silencieux)** | 🔴 Critique | Quand le backend ne renvoie pas de refresh token distinct, l'app stocke l'access token *comme* refresh token. À l'expiration de l'access token, le refresh échoue forcément → `forceLogout`. La déconnexion arrive « pile » à la fin du TTL du token. |
| **C2** | **Un seul 401 sur une route protégée = logout immédiat** | 🔴 Critique | Aucune tolérance : un 401 transitoire (hoquet backend, throttling mal typé, invalidation côté serveur, course réseau) suffit à tout effacer. Pas de retry, pas de backoff, pas de distinction 401-auth / 401-autorisation. |
| **C3** | **Fragilité du `flutter_secure_storage` sur Android** | 🟠 Élevée | `EncryptedSharedPreferences` (Jetpack Security) peut invalider sa clé (mise à jour OS, restauration de sauvegarde, changement d'empreinte/code). La lecture du token renvoie alors `null`/throw → requête sans `Authorization` → 401 → logout. |
| **C4** | **Le refresh parse exige un refresh token distinct** | 🟠 Élevée | `_parseRefreshTokens` retourne `null` si `refresh_token` absent du payload de `/auth/refresh`. Si le backend ne renvoie qu'un nouvel access token, le refresh est considéré comme **échoué** même en HTTP 200 → logout. |
| **C5** | **Cold start « optimiste »** | 🟡 Moyenne | Au lancement, l'app se déclare *authenticated* dès qu'un token existe en storage, sans valider son expiration. Si le token est périmé, le 1er appel protégé renvoie 401 → l'utilisateur est éjecté juste après l'ouverture (perçu comme « déconnecté tout seul »). |
| **C6** | **Pas de refresh proactif basé sur `expires_in`** | 🟡 Moyenne | `expiresIn` est reçu mais jamais persisté ni utilisé. L'app n'anticipe jamais l'expiration ; elle subit le 401. Combiné à C1, garantit une déconnexion dure à chaque expiration. |
| **C7** | **Invalidation côté backend (multi-device / révocation)** | 🟡 Moyenne (à confirmer) | Si le backend révoque le token lors d'un login ailleurs, d'un changement de mot de passe, ou d'un redéploiement, le prochain appel mobile renvoie 401 → logout. C'est « aléatoire » du point de vue utilisateur. |

> **Hypothèse la plus forte :** la combinaison **C1 + C2 + C6**. L'app ne sait pas vraiment rafraîchir un token (le refresh token est souvent l'access token lui-même), donc dès que l'access token expire — ou est invalidé côté serveur — le premier appel protégé déclenche un `forceLogout` irréversible.

---

## 2. Architecture générale

Architecture Clean classique (data / domain / presentation) + Riverpod + Dio.

```
Presentation
  AuthNotifier (StateNotifier<AuthState>)         lib/features/auth/presentation/providers/auth_provider.dart
        │ watch
  GoRouter redirect + _AuthRouterRefresh          lib/routes/app_router.dart
        │
Domain
  AuthRepository (interface)                       lib/features/auth/domain/repositories/auth_repository.dart
        │
Data
  AuthRepositoryImpl                               lib/features/auth/data/repositories/auth_repository_impl.dart
  AuthApiDataSource (Dio)                          lib/features/auth/data/datasources/auth_api_datasource.dart
        │
Transport / sécurité
  DioClient + JwtAuthInterceptor                   lib/config/dio_client.dart
  SecureStorageService / SharedSecureStorage       lib/core/services/secure_storage_service.dart
```

Fichiers structurants :

- Intercepteur JWT & gestion 401/refresh : [lib/config/dio_client.dart](../../lib/config/dio_client.dart)
- État d'auth & logout : [lib/features/auth/presentation/providers/auth_provider.dart](../../lib/features/auth/presentation/providers/auth_provider.dart)
- Stockage sécurisé : [lib/core/services/secure_storage_service.dart](../../lib/core/services/secure_storage_service.dart)
- Repository : [lib/features/auth/data/repositories/auth_repository_impl.dart](../../lib/features/auth/data/repositories/auth_repository_impl.dart)
- Datasource API : [lib/features/auth/data/datasources/auth_api_datasource.dart](../../lib/features/auth/data/datasources/auth_api_datasource.dart)
- Redirections : [lib/routes/app_router.dart](../../lib/routes/app_router.dart)
- Câblage `onForceLogout` : [lib/main.dart](../../lib/main.dart#L308-L310)

---

## 3. Le flow d'authentification complet

### 3.1 Stockage des jetons

Tout passe par un **singleton partagé** `SharedSecureStorage.instance` ([dio_client.dart:23-28](../../lib/config/dio_client.dart#L23-L28)) pour garantir que l'écriture (auth) et la lecture (intercepteur) visent le même coffre :

```dart
static const FlutterSecureStorage instance = FlutterSecureStorage(
  aOptions: AndroidOptions(encryptedSharedPreferences: true),
  iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
);
```

Clés stockées : `auth_token`, `refresh_token`, `user_id`, `user_role`, plus les champs de profil (email, nom, avatar…). Voir [secure_storage_service.dart](../../lib/core/services/secure_storage_service.dart).

`SecureStorageService.isAuthenticated()` = **simple présence d'un token non vide** ([secure_storage_service.dart:174-177](../../lib/core/services/secure_storage_service.dart#L174-L177)). Aucune validation d'expiration n'est faite ici.

### 3.2 Démarrage à froid (cold start)

1. Route initiale `/bootstrap` → [AuthBootstrapScreen](../../lib/features/auth/presentation/screens/auth_bootstrap_screen.dart) (juste un spinner).
2. `AuthNotifier` est construit → `_checkAuthStatus()` ([auth_provider.dart:90-104](../../lib/features/auth/presentation/providers/auth_provider.dart#L90-L104)) :
   - `isAuthenticated()` → token présent ?
   - si oui : `getCurrentUser()` reconstruit `HbUser` **depuis le storage local** (pas d'appel `/auth/me`), puis état = `authenticated`.
   - si non : `unauthenticated`.
3. Le redirect GoRouter ([app_router.dart:141-222](../../lib/routes/app_router.dart#L141-L222)) attend `status != initial`, gère onboarding/OTP, puis route vers `/`.

> ⚠️ **Point clé :** l'app se considère connectée sans jamais vérifier que le token est encore valide. La validité n'est testée qu'au premier appel réseau protégé.

### 3.3 Login

`AuthNotifier.login()` → `AuthRepositoryImpl.login()` → `AuthApiDataSource.login()` (`POST /auth/login`).

Deux cas gérés ([auth_api_datasource.dart:139-177](../../lib/features/auth/data/datasources/auth_api_datasource.dart#L139-L177)) :
- **2FA** : `requires_otp == true` → état `pendingLoginOtp`, redirection `/verify-otp`.
- **Auth directe** (Laravel v2) : `user` + `token`/`tokens` présents → `_handleAuthResponse` enregistre les jetons + le profil, état `authenticated`.

### 3.4 OTP (inscription & 2FA login)

- `verifyOtp` / `verifyLoginOtp` → `POST /auth/verify-otp` → `_handleAuthResponse`.
- Inscription « moderne » : `otp/send` → `otp/verify` (renvoie `verified_email_token`) → `register` (customer/business).

### 3.5 Enregistrement des jetons (`_handleAuthResponse`)

[auth_repository_impl.dart:271-285](../../lib/features/auth/data/repositories/auth_repository_impl.dart#L271-L285) :

```dart
await _secureStorage.saveAccessToken(response.tokens.accessToken);
await _secureStorage.saveRefreshToken(response.tokens.refreshToken);
await persistUser(user);
```

Le `response.tokens` provient de `_parseTokensFromPayload` ([auth_api_datasource.dart:310-340](../../lib/features/auth/data/datasources/auth_api_datasource.dart#L310-L340)), qui contient le **fallback dangereux** :

```dart
final refreshToken = parsedRefreshToken ?? accessToken; // ← C1
```

Et les chemins d'inscription customer/business posent explicitement `refreshToken = token` ([auth_repository_impl.dart:333-340](../../lib/features/auth/data/repositories/auth_repository_impl.dart#L333-L340), [375-379](../../lib/features/auth/data/repositories/auth_repository_impl.dart#L375-L379)).

### 3.6 Attache du token sur chaque requête

`JwtAuthInterceptor.onRequest` ([dio_client.dart:176-214](../../lib/config/dio_client.dart#L176-L214)) :
- lit le token via `await _storage.read(...)` (**sans try/catch**),
- l'ajoute en `Authorization: Bearer …` sur toutes les requêtes sauf `/auth/refresh`,
- la liste `_publicPrefixes` ne sert plus qu'au logging (le token est attaché même sur les routes « publiques »).

### 3.7 Gestion du 401 & refresh

`JwtAuthInterceptor.onError` ([dio_client.dart:216-275](../../lib/config/dio_client.dart#L216-L275)), intercepteur de type `QueuedInterceptor` (sérialise les erreurs) :

1. Si `statusCode == 401` et pas déjà en refresh :
2. Si la route n'est pas dans `_noRefreshPrefixes` → tentative de refresh :
   - `_refreshAccessToken()` lit le `refresh_token`, appelle `POST /auth/refresh` via un **Dio séparé** (`_buildRefreshDio`, évite la récursion d'intercepteur),
   - parse avec `_parseRefreshTokens` qui **exige** `access_token` ET `refresh_token` non vides ([dio_client.dart:343-366](../../lib/config/dio_client.dart#L343-L366)) — sinon `null` (= échec, **C4**),
   - si OK : réécrit les jetons, rejoue la requête d'origine, `handler.resolve`.
3. Si refresh échoue/impossible et route non publique → `_forceLogoutIfTokenPresent()` :
   - supprime `auth_token` + `refresh_token` du storage,
   - appelle `DioClient.onForceLogout?.call()` ([dio_client.dart:368-386](../../lib/config/dio_client.dart#L368-L386)).

`onForceLogout` est câblé dans `LeHibooApp.build()` vers `AuthNotifier.forceLogout()` ([main.dart:308-310](../../lib/main.dart#L308-L310)).

### 3.8 Logout

- `logout()` (volontaire) ([auth_provider.dart:361-375](../../lib/features/auth/presentation/providers/auth_provider.dart#L361-L375)) : désinscrit les push tokens, appelle `/auth/logout`, vide le storage et les caches utilisateur, invalide les providers.
- `forceLogout()` (déclenché par 401) ([auth_provider.dart:379-385](../../lib/features/auth/presentation/providers/auth_provider.dart#L379-L385)) : **pas** d'appel API, vide le storage + caches, état `unauthenticated`.
- `_AuthRouterRefresh` ([app_router.dart:95-119](../../lib/routes/app_router.dart#L95-L119)) re-déclenche le redirect quand `status` change → l'utilisateur retombe sur `/` (déconnecté) ou `/login`.

### 3.9 Autres clients Dio

- **Petit Boo** ([petit_boo_api_datasource.dart:17-53](../../lib/features/petit_boo/data/datasources/petit_boo_api_datasource.dart#L17-L53)) : Dio dédié, attache le token mais **aucune gestion 401/refresh** → un 401 y génère une erreur locale, **pas** de logout (cohérence partielle mais pas de risque de déconnexion globale).

---

## 4. Analyse détaillée des problèmes

### 🔴 C1 — `refresh_token` retombe sur l'`access_token`

**Où :**
- [auth_api_datasource.dart:327](../../lib/features/auth/data/datasources/auth_api_datasource.dart#L327) : `final refreshToken = parsedRefreshToken ?? accessToken;`
- [auth_repository_impl.dart:333-340](../../lib/features/auth/data/repositories/auth_repository_impl.dart#L333-L340) et [375-379](../../lib/features/auth/data/repositories/auth_repository_impl.dart#L375-L379) : `TokensDto(accessToken: token, refreshToken: token, …)`.

**Mécanisme :** si le backend renvoie seulement un `token` (cas Laravel Sanctum / personal access token, fréquent), l'app sauvegarde le même jeton comme access ET refresh. Quand l'access token expire, l'intercepteur appelle `/auth/refresh` avec un refresh token… qui est l'access token expiré. Le backend répond 401 (ou un payload sans tokens) → refresh échoué → `forceLogout`.

**Symptôme côté utilisateur :** déconnexion qui tombe « toute seule » exactement à la fin de la durée de vie du token (donc semble aléatoire mais est en réalité périodique).

**À confirmer :** le backend Laravel renvoie-t-il un vrai `refresh_token` distinct sur `/auth/login` et `/auth/refresh` ? Si non, le modèle de refresh de l'app est inopérant par construction.

---

### 🔴 C2 — Un seul 401 protégé déclenche un logout définitif

**Où :** [dio_client.dart:262-271](../../lib/config/dio_client.dart#L262-L271) + `_forceLogoutIfTokenPresent`.

**Problèmes :**
- Aucune distinction entre **401 = token invalide** (légitime) et **401 transitoire** (redéploiement backend, hoquet réseau, réponse mal typée d'un proxy, course pendant une rotation de token).
- Aucun **retry / backoff** avant de conclure à l'expiration.
- Le 401 peut aussi être renvoyé par une logique d'**autorisation** (ressource interdite) et non d'authentification : l'app le traite quand même comme « session morte ».
- `forceLogout` est **irréversible** (efface tokens + caches) : aucune session de grâce.

**Effet :** n'importe quel incident ponctuel renvoyant 401 éjecte l'utilisateur.

---

### 🟠 C3 — Fragilité du stockage sécurisé (Android surtout)

**Où :** [dio_client.dart:24-27](../../lib/config/dio_client.dart#L24-L27), lecture token [dio_client.dart:179](../../lib/config/dio_client.dart#L179).

**Problèmes connus :**
- `AndroidOptions(encryptedSharedPreferences: true)` s'appuie sur Jetpack Security, sujet à des **invalidations de clé** (mise à jour OS, restauration de backup sur un nouvel appareil, changement de credential/empreinte) → lectures qui **throw** ou renvoient `null`.
- `onRequest` lit le token **sans try/catch** : une exception du keystore se propage en erreur de requête.
- Si la lecture renvoie `null`, la requête part **sans `Authorization`** → 401 → logout (alors que le token existe peut-être encore physiquement).
- iOS `first_unlock` : une requête déclenchée en arrière-plan (push, background fetch) avant le 1er déverrouillage lirait `null` → 401 (cas plus rare).

---

### 🟠 C4 — Le parsing du refresh exige un refresh token distinct

**Où :** [dio_client.dart:355-360](../../lib/config/dio_client.dart#L355-L360).

`_parseRefreshTokens` retourne `null` (= échec → logout) si `refresh_token` est absent ou vide dans la réponse de `/auth/refresh`. Si le backend ne renvoie **qu'un** nouvel access token (sans refresh token), l'app considère le refresh comme échoué **même avec un HTTP 200 valide**. Incohérent avec le fallback permissif de C1.

---

### 🟡 C5 — Cold start optimiste (token jamais validé au lancement)

**Où :** [auth_provider.dart:90-104](../../lib/features/auth/presentation/providers/auth_provider.dart#L90-L104) + [secure_storage_service.dart:174-177](../../lib/core/services/secure_storage_service.dart#L174-L177).

L'app affiche l'utilisateur comme connecté sur la seule présence d'un token, sans `/auth/me` ni contrôle d'expiration. Si le token est périmé, l'utilisateur voit l'app « connectée » puis est éjecté au 1er appel protégé → perçu comme une déconnexion aléatoire à l'ouverture.

---

### 🟡 C6 — Pas de refresh proactif sur `expires_in`

`expiresIn` est reçu et transporté jusqu'à `AuthResult` mais **jamais persisté ni exploité** (aucune clé d'expiration dans le storage ; `refreshTokenIfNeeded()` du repository [auth_repository_impl.dart:153-173](../../lib/features/auth/data/repositories/auth_repository_impl.dart#L153-L173) n'est **appelé nulle part**). L'app ne rafraîchit jamais en avance : elle attend systématiquement le 401.

---

### 🟡 C7 — Invalidation côté backend (à investiguer)

Causes serveur possibles d'un 401 « surprise » : login du même compte sur un autre appareil (politique mono-session), changement de mot de passe, expiration/rotation de la clé de signature JWT lors d'un déploiement, purge des tokens. Toutes débouchent sur le logout dur de C2. **Nécessite une corrélation côté logs backend.**

---

### Points secondaires (faible gravité)

- **`onForceLogout` réassigné à chaque `build()`** de `LeHibooApp` ([main.dart:308-310](../../lib/main.dart#L308-L310)) — déjà noté dans l'audit 03 (P1-1). Pas une cause directe de déconnexion, mais couplage UI/réseau fragile.
- **Échec de refresh non observable en prod** — déjà identifié (TIER0 T6) : les `catch` du refresh ne remontent rien à Crashlytics, donc les déconnexions sont invisibles côté monitoring. **À corriger en priorité pour diagnostiquer.**
- **Double effacement des tokens** (interceptor + `forceLogout`) — inoffensif.

---

## 5. Recommandations (par priorité)

### Étape 0 — Rendre le problème observable (prérequis)
1. Logguer chaque `forceLogout` et chaque échec de refresh en non-fatal Crashlytics avec le contexte : route, `statusCode`, présence d'un refresh token distinct, raison (`refresh_parse_null`, `refresh_http_401`, `storage_read_null`…). Référence : TIER0 T6 ([dio_client.dart:305-309](../../lib/config/dio_client.dart#L305-L309)).
2. Ajouter un event analytics `session_expired` distinct du `logout` volontaire.

> Sans ces logs, impossible de confirmer laquelle de C1–C7 domine en prod.

### Étape 1 — Sécuriser le contrat de jetons (C1, C4)
3. **Vérifier le backend** : `/auth/login` et `/auth/refresh` renvoient-ils un `refresh_token` distinct ? Aligner le contrat mobile ↔ API.
4. Si oui : supprimer le fallback `refreshToken ?? accessToken` et **ne plus stocker** de refresh token quand le backend n'en fournit pas (au lieu de dupliquer l'access token).
5. Si le backend n'a pas de refresh token (Sanctum simple) : abandonner la mécanique de refresh côté mobile et basculer sur des tokens longue durée + re-login explicite, OU implémenter un vrai refresh côté backend.

### Étape 2 — Tolérance aux 401 transitoires (C2)
6. Ajouter un **retry unique avec backoff** sur 401 avant tout logout (rejouer une fois après un court délai si le refresh n'est pas applicable).
7. Ne déclencher `forceLogout` que sur un 401 **confirmé** d'authentification (ex. corps d'erreur `token_expired` / `unauthenticated`), pas sur tout 401.
8. Distinguer 401 (auth) de 403 (autorisation) et ne jamais déconnecter sur 403.

### Étape 3 — Robustesse du stockage (C3)
9. Entourer toutes les lectures storage de `try/catch` ; en cas d'exception keystore, **ne pas** envoyer une requête sans token et **ne pas** logout sur le 401 qui suivrait — tenter une relecture/réhydratation d'abord.
10. Évaluer le passage d'`encryptedSharedPreferences` à une option plus stable, ou ajouter une migration/healthcheck du keystore au démarrage.

### Étape 4 — Validation au démarrage & refresh proactif (C5, C6)
11. Au cold start, valider la session via `/auth/me` (ou décoder l'`exp` du JWT) avant de se déclarer `authenticated` ; si périmé, tenter un refresh **avant** d'afficher l'app.
12. Persister `expires_in` et rafraîchir **proactivement** un peu avant l'expiration (réactiver/brancher `refreshTokenIfNeeded`).

### Étape 5 — Backend (C7)
13. Confirmer avec l'équipe backend la politique de session (mono/multi-device), la TTL réelle des tokens, et le comportement lors des déploiements (rotation de clé JWT invalidant les tokens existants).

---

## 6. Comment confirmer le diagnostic

1. Activer le logging Étape 0 et collecter sur quelques jours.
2. Mesurer le **délai médian entre login et déconnexion forcée** : s'il correspond à la TTL du token → C1/C6 confirmés.
3. Vérifier sur un device de test : se connecter, attendre l'expiration de l'access token, déclencher un appel protégé, observer si `/auth/refresh` réussit. S'il échoue avec `refresh_token == access_token` → C1 confirmé.
4. Croiser les `session_expired` mobiles avec les logs 401 backend (route, raison) → départage C2/C7.
5. Sur Android, tester restauration de backup / mise à jour OS et observer la persistance du token → C3.

---

## 7. Références fichiers

| Sujet | Fichier |
|-------|---------|
| Intercepteur JWT, 401, refresh | [lib/config/dio_client.dart](../../lib/config/dio_client.dart) |
| État auth, login, logout, forceLogout | [lib/features/auth/presentation/providers/auth_provider.dart](../../lib/features/auth/presentation/providers/auth_provider.dart) |
| Repository (tokens, fallback) | [lib/features/auth/data/repositories/auth_repository_impl.dart](../../lib/features/auth/data/repositories/auth_repository_impl.dart) |
| Datasource API auth | [lib/features/auth/data/datasources/auth_api_datasource.dart](../../lib/features/auth/data/datasources/auth_api_datasource.dart) |
| Stockage sécurisé | [lib/core/services/secure_storage_service.dart](../../lib/core/services/secure_storage_service.dart) |
| Redirections / refresh router | [lib/routes/app_router.dart](../../lib/routes/app_router.dart) |
| Câblage onForceLogout | [lib/main.dart](../../lib/main.dart#L308-L310) |
| Client Petit Boo (sans refresh) | [lib/features/petit_boo/data/datasources/petit_boo_api_datasource.dart](../../lib/features/petit_boo/data/datasources/petit_boo_api_datasource.dart) |

> Audits connexes : [docs/audits/resultats/04-reseau-api-donnees-audit.md](resultats/04-reseau-api-donnees-audit.md), [docs/audits/remediation/TIER0-execution.md](remediation/TIER0-execution.md) (T6 — observabilité du refresh).

---

## 8. Investigation ciblée — pertes de session en back-office

> Contexte : le test manuel de refresh (bouton debug dans Paramètres) **fonctionne**. Le mécanisme de refresh n'est donc pas cassé en soi. Les déconnexions surviennent surtout en **back-office** (écrans vendor/admin : dashboard, conversations, listes), qui déclenchent **beaucoup de requêtes authentifiées en parallèle**.

### 8.1 Cause racine : la « ruée » sur le refresh (refresh stampede)

`JwtAuthInterceptor` est un `QueuedInterceptor` ([dio_client.dart:134](../../lib/config/dio_client.dart#L134)) avec un simple booléen `_isRefreshing`. Quand l'access token expire pendant que **N requêtes** sont en vol (cas typique d'un dashboard back-office) :

1. La 1ʳᵉ requête en 401 entre dans le bloc de refresh, met `_isRefreshing = true`, rafraîchit, rejoue, puis remet `_isRefreshing = false`.
2. Les requêtes 401 suivantes sont **sérialisées** par la file du `QueuedInterceptor`. Quand elles sont traitées :
   - soit `_isRefreshing` est déjà repassé à `false` → elles relancent **chacune un refresh** (refreshs en cascade) ;
   - soit elles tombent dans `super.onError` (branche `!_isRefreshing` fausse) → la requête **échoue en 401 brut**, sans retry.

**Le point critique** : si le backend **rotate le refresh token** (chaque refresh invalide le précédent — pratique courante), alors la 2ᵉ tentative de refresh présente un refresh token **déjà consommé** → 401 → `_forceLogoutIfTokenPresent()` → **déconnexion**.

Le test isolé ne reproduit jamais ce bug car il n'envoie **qu'une seule** requête. En back-office, le parallélisme rend la course probable.

Aggravants spécifiques au back-office :
- **Fan-out de providers** chargés d'un coup à l'authentification ([main.dart:326-350](../../lib/main.dart#L326-L350)) : conversations (vendor/admin), unread count, active organization, heartbeat, push, realtime…
- **Sessions longues** : l'écran reste ouvert, le token expire pendant l'inactivité, puis un burst de requêtes part au resume ou sur un événement realtime.
- **Realtime Pusher** ([messages_realtime_provider.dart](../../lib/features/messages/presentation/providers/messages_realtime_provider.dart)) : une reconnexion socket peut redéclencher un lot d'appels REST simultanés.

### 8.2 Correctif appliqué — 2 retries sur le refresh (+ détection de rotation concurrente)

`_refreshAccessToken()` ([dio_client.dart](../../lib/config/dio_client.dart#L277)) passe de **1 tentative** à **3 tentatives** (1 initiale + **2 retries**) :

- **Échec transitoire** (pas de réponse réseau / timeout / 5xx) → retry après un backoff progressif (`400ms × n°tentative`).
- **Rotation concurrente détectée** : après un échec, on relit le refresh token en storage ; s'il a **changé** depuis celui qu'on a essayé, c'est qu'un *pair* a déjà rafraîchi → on **retry immédiatement** avec le nouveau token au lieu de déconnecter. **C'est ce cas qui désamorce la perte de session en back-office.**
- **401 « franc »** (refresh token réellement invalide, sans rotation par un pair) → **pas** de retry inutile, on abandonne proprement (évite de marteler le backend).
- **HTTP 200 sans tokens exploitables** → pas de retry (ni transitoire ni rotation).

### 8.3 Limite & correctif complémentaire recommandé

Les 2 retries **réduisent fortement** la fenêtre de course mais ne la suppriment pas totalement : la vraie correction définitive est le **single-flight** — partager **un seul** `Future` de refresh entre toutes les requêtes 401 concurrentes (les autres attendent le même refresh au lieu d'en lancer un chacune). À planifier en complément si des déconnexions persistent après ce correctif (à confirmer via l'observabilité de l'Étape 0).
