# Audit — Axe 05 Sécurité

Date : 2026-05-26 · Branche : `main` · Auditeur : Claude · Plan : [05-securite.md](../plans/05-securite.md)

## Synthèse
- **État global : 🔴 Critique** — secrets exposés sur deux vecteurs (historique git + binaire).
- Constats : **6** (🔴 2 · 🟠 1 · 🟡 2 · ⚪ 1)
- **Top 3 actions prioritaires** :
  1. **Roter immédiatement** tous les secrets sensibles exposés (HT_PASSWORD, API_KEY, GOOGLE_MAPS_API_KEY, PUSHER_APP_KEY).
  2. **Sortir les secrets du bundle** : `HT_USERNAME/HT_PASSWORD` et `API_KEY` ne doivent pas être embarqués comme assets.
  3. **Gater/supprimer les logs d'email (PII)** non protégés par `kDebugMode`.

> Points sains confirmés : stockage tokens chiffré, deeplinks whitelistés, transport HTTPS/TLS en prod, log du token Bearer protégé en release. Voir § Points conformes.

---

## Constats détaillés

| # | Gravité | Constat | Fichier:ligne | Recommandation | Effort |
|---|---------|---------|---------------|----------------|--------|
| 1 | 🔴 P0 | **Secrets dans l'historique git.** Les `.env*` ont été trackés depuis le `first commit` (`404c236`) jusqu'à `e1ac79a chore: stop tracking .env files`. Le `.gitignore` ne les exclut que **depuis** ce commit. Les valeurs restent récupérables dans tout clone de l'historique. | `e1ac79a` (suppression) ; `404c236`→`e1ac79a~1` (présence) | Roter tous les secrets exposés **puis** réécrire l'historique (`git filter-repo`/BFG) + force-push coordonné. Voir § Remédiation. | L |
| 2 | 🔴 P0 | **Secrets embarqués dans le binaire.** `.env`, `.env.development/staging/production` sont déclarés comme **assets** Flutter → présents en clair dans l'APK/IPA. Contiennent des secrets **actifs** : `HT_PASSWORD` (basic auth, injecté à chaque requête), `API_KEY` (`X-API-Key`), `GOOGLE_MAPS_API_KEY`, `PUSHER_APP_KEY`. Extractibles par `unzip`+`strings`. | [pubspec.yaml:155-158](../../../pubspec.yaml#L155-L158) ; usage : [dio_client.dart:57-62](../../../lib/config/dio_client.dart#L57-L62), [dio_client.dart:209-210](../../../lib/config/dio_client.dart#L209-L210) | Ne pas embarquer les secrets serveur côté client : supprimer le basic auth htaccess en prod (ou le porter côté infra/CDN), récupérer un token applicatif après auth plutôt qu'un `API_KEY` statique partagé. La clé Stripe *publishable* peut rester (publique par design). | L |
| 3 | 🟠 P1 | **PII (email) loggée via `debugPrint` non gardé** → fuite dans les logs système en **release** (`debugPrint` n'est pas strippé en release). | [register_screen.dart:65](../../../lib/features/auth/presentation/screens/register_screen.dart#L65), [business_register_provider.dart:707](../../../lib/features/auth/presentation/providers/business_register_provider.dart#L707), [auth_api_datasource.dart:565](../../../lib/features/auth/data/datasources/auth_api_datasource.dart#L565), [push_notification_provider.dart:279](../../../lib/features/notifications/presentation/providers/push_notification_provider.dart#L279) | Gater par `if (kDebugMode)` ou supprimer. Plus largement, router vers `logger` avec filtrage release (recoupe [plan 02](../plans/02-qualite-code-conventions.md) / [11](../plans/11-observabilite-crash-analytics.md)). | S |
| 4 | 🟡 P2 | **Aucune obfuscation release** (`--obfuscate`/`--split-debug-info`) configurée → chaînes, noms de classes et secrets bundlés plus faciles à extraire. | aucun script/CI (absent) | Activer `flutter build --obfuscate --split-debug-info=…` dans la chaîne release (recoupe [plan 13](../plans/13-ci-cd-release.md)). | S |
| 5 | 🟡 P2 | **Basic auth potentiellement écrasé par le Bearer.** `securityHeaderName` vaut `Authorization` par défaut ; le basic auth est posé sur ce header au boot ([dio_client.dart:62](../../../lib/config/dio_client.dart#L62)), puis `JwtAuthInterceptor` réécrit `Authorization: Bearer …` ([dio_client.dart:186](../../../lib/config/dio_client.dart#L186)) pour les requêtes authentifiées. À clarifier (incohérence de protection + secret inutilement embarqué si jamais réellement requis). | [dio_client.dart:57-62](../../../lib/config/dio_client.dart#L57-L62), [dio_client.dart:186](../../../lib/config/dio_client.dart#L186) | Statuer sur la nécessité réelle du basic auth ; si requis, header dédié non écrasé ; sinon le retirer (réduit aussi le constat #2). | S |
| 6 | ⚪ i | `firebase_options.dart` contient les identifiants Firebase (App ID, sender ID, projet) commités. Ce sont des identifiants **semi-publics** (présents dans toute app Firebase) — non bloquant, mais la sécurité repose alors entièrement sur les **règles backend/App Check**. | [lib/firebase_options.dart](../../../lib/firebase_options.dart) | Vérifier l'activation de Firebase App Check + règles serveur ; restreindre la `GOOGLE_MAPS_API_KEY` (référents/bundle id) côté console GCP. | M |

---

## Inventaire des secrets (classés)

| Secret | Sensible ? | Dans git history | Bundlé (asset) | Injecté runtime | Action |
|--------|:----------:|:----------------:|:--------------:|-----------------|--------|
| `HT_PASSWORD` / `HT_USERNAME` | 🔴 Oui | ✅ exposé | ✅ | `Authorization: Basic …` | **Roter + sortir du bundle / supprimer** |
| `API_KEY` | 🔴 Oui | ✅ exposé | ✅ | header `X-API-Key` | **Roter + repenser (token post-auth)** |
| `GOOGLE_MAPS_API_KEY` | 🟠 Oui | ✅ exposé | ✅ | SDK Maps | **Roter + restreindre (referrer/bundle)** |
| `PUSHER_APP_KEY` | 🟠 Modéré | ✅ exposé | ✅ | WebSocket Reverb | Roter ; clé « app » Pusher est semi-publique mais l'auth des canaux privés doit protéger |
| `STRIPE_PUBLISHABLE_KEY` | 🟢 Non | ✅ | ✅ | Stripe SDK | OK (publique par design) — vérifier qu'aucune clé *secrète* n'a transité |
| `FIREBASE_*` | 🟢 Non | ✅ | ✅ | Firebase | Semi-public — sécuriser via App Check + règles |

---

## Points conformes (✅)

- **Stockage tokens chiffré** : `flutter_secure_storage` avec `AndroidOptions(encryptedSharedPreferences: true)` et `IOSOptions(accessibility: KeychainAccessibility.first_unlock)` ([dio_client.dart:25-26](../../../lib/config/dio_client.dart#L25-L26)). Tokens jamais en `SharedPreferences`.
- **Effacement complet au logout** : `clearAuthData()` supprime token, refresh, userId, rôle et toutes les PII persistées ([secure_storage_service.dart:156-171](../../../lib/core/services/secure_storage_service.dart#L156-L171)).
- **Deeplinks whitelistés** : `kDeeplinkAllowedHosts` + rejet des hosts non listés ([deeplink_router.dart:10-31](../../../lib/core/deeplinks/deeplink_router.dart#L10-L31)).
- **Transport sécurisé en prod/staging** : toutes les URLs en `https://`, `PUSHER_USE_TLS=true`. Le cleartext/ATS ouvert est cantonné au dev (à confirmer sur les manifests release — [plan 12](../plans/12-plateforme-ios-android.md)).
- **Log du token Bearer protégé** : gardé par `if (kDebugMode)` avec commentaire « NEVER enable in release » ([dio_client.dart:196-205](../../../lib/config/dio_client.dart#L196-L205)).
- **Gitignore corrigé** : les `.env*` sont désormais ignorés (depuis `e1ac79a`).

---

## Remédiation P0 (procédure)

1. **Rotation d'abord** (sans attendre le nettoyage d'historique, car l'exposition est déjà effective) :
   - Générer une nouvelle `HT_PASSWORD`, nouvelle `API_KEY`, nouvelle `GOOGLE_MAPS_API_KEY` (+ restrictions GCP), nouvelle `PUSHER_APP_KEY` côté Reverb.
   - Mettre à jour les `.env*` locaux et les secrets CI (jamais recommités).
2. **Réécriture d'historique** (coordonnée avec toute l'équipe — invalide les clones) :
   ```bash
   git filter-repo --path .env --path .env.development --path .env.production --path .env.staging --invert-paths
   # ou BFG : bfg --delete-files '.env*'
   git push --force-with-lease --all
   ```
3. **Sortir les secrets serveur du binaire** : retirer le basic auth client (#5), remplacer l'`API_KEY` statique par un jeton émis après authentification.
4. **Activer l'obfuscation** release + Firebase App Check.

## Annexes (commandes lancées)
- `git log --all --full-history -- .env*` → présence de `404c236`→`e1ac79a`.
- `git show e1ac79a --stat` → suppression de 170 lignes de `.env*` + ajout au `.gitignore`.
- `git show e1ac79a~1:.env` → `HT_PASSWORD` (24c), `GOOGLE_MAPS_API_KEY` (24c) présents en clair.
- Greps : secure storage options, whitelist deeplinks, logs sensibles, usage basic auth / `X-API-Key`, obfuscation.
