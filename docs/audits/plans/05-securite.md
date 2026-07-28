# Plan 05 — Sécurité 🔴 (priorité critique)

Objectif : identifier les risques de sécurité applicative mobile : secrets exposés,
stockage des tokens, cycle de vie de l'authentification, deeplinks, transport,
fuite de données dans les logs.

## Périmètre
- `lib/config/env_config.dart`, fichiers `.env*` (bundlés), `lib/firebase_options.dart`
- `lib/features/auth/`, `flutter_secure_storage`, intercepteur 401
- `lib/core/deeplinks/`, configs natives (ATS iOS, cleartext Android)
- Historique git (recherche de secrets commités)

## Risques connus / hypothèses
- 🔴 **`.env`, `.env.development`, `.env.production`, `.env.staging` sont déclarés comme assets** dans `pubspec.yaml` → embarqués dans le binaire. `API_KEY`, `STRIPE_PUBLISHABLE_KEY`, `GOOGLE_MAPS_API_KEY`, `ONESIGNAL_APP_ID`, `PUSHER_APP_KEY`, **`HT_USERNAME`/`HT_PASSWORD`** sont donc **extractibles** d'un APK/IPA.
  - La clé Stripe *publishable* est OK à exposer ; **`HT_USERNAME`/`HT_PASSWORD` (basic auth) et `API_KEY` ne le sont pas**.
- ⚠️ Commit récent `add stripe key` → vérifier qu'aucun **secret** n'a été commité dans l'historique.
- ⚠️ URLs locales en `http://` + `usesCleartextTraffic` Android + ATS `NSAllowsArbitraryLoads` iOS (cf. `CLAUDE.md`) → s'assurer que c'est **strictement dev**, jamais en release.

## Checklist
- [ ] **Inventaire des secrets** : lister toutes les clés lues dans `env_config.dart` et classer (public OK / sensible). Tout secret sensible doit **sortir du bundle** (récupéré côté backend après auth, ou non embarqué).
- [ ] **Basic auth htaccess** (`HT_USERNAME`/`HT_PASSWORD`) : confirmer si encore nécessaire ; si oui, ne pas l'embarquer en clair côté client.
- [ ] **Historique git** : scanner les commits pour secrets/clés privées (`gitleaks`/`trufflehog`). Confirmer que `.env*` n'a jamais été tracké (gitignore OK aujourd'hui, vérifier le passé).
- [ ] **Stockage tokens** : token d'auth dans `flutter_secure_storage` (pas `shared_preferences`). Options Keychain/Keystore correctes (`accessibility`, `encryptedSharedPreferences`).
- [ ] **Cycle de vie auth** : expiration/refresh token, `forceLogout` sur 401, effacement complet du secure storage au logout (token + active org + caches sensibles).
- [ ] **Deeplinks** ([core/deeplinks](../../../lib/core/deeplinks/)) : validation/whitelist des hosts et paramètres ; pas d'ouverture d'URL arbitraire ni d'action sensible sans auth.
- [ ] **Transport** : aucune URL `http://` ni ATS ouvert en build **release** ; cleartext Android limité aux manifests `debug`/`profile`.
- [ ] **Logs sensibles** : aucun token / email / PII / payload de paiement dans `print`/`debugPrint`/`pretty_dio_logger` (88 fichiers à passer au crible) ; logger désactivé en release.
- [ ] **WebView / liens externes** : `url_launcher` n'ouvre que des schémas attendus.
- [ ] **Paiement** : aucun secret Stripe (clé secrète) côté app ; seul le `clientSecret` transite (cf. plan 14).
- [ ] **Permissions** : principe du moindre privilège (caméra, localisation, micro, stockage) — justifier chaque permission (cf. plan 12).
- [ ] **Données au repos** : caches images/fichiers, `path_provider`, `file_picker` — pas de stockage de données sensibles en clair.
- [ ] **Obfuscation** : build release avec `--obfuscate --split-debug-info` envisagé.

## Commandes / mesures
```bash
# Secrets dans l'historique git
gitleaks detect --source . --no-banner   # ou trufflehog filesystem .

# .env a-t-il déjà été tracké ?
git log --all --full-history -- .env .env.development .env.production .env.staging

# Lecture de secrets côté code
rg -n "dotenv.env\[|EnvConfig\." lib --glob '!*.g.dart'

# Stockage : secure storage vs shared_preferences pour des données sensibles
rg -n "SharedPreferences|secure_storage|FlutterSecureStorage" lib --glob '!*.g.dart'
rg -n "token|password|secret|apiKey|api_key" lib --glob '!*.g.dart' -i | rg -i "prefs|sharedpref"

# Transport en clair / ATS / cleartext
rg -n "http://" lib --glob '!*.g.dart'
rg -n "NSAllowsArbitraryLoads|usesCleartextTraffic" ios android

# PII/token dans les logs
rg -n "debugPrint|print\(" lib --glob '!*.g.dart' | rg -i "token|email|password|secret|card|stripe"
```

## Livrable
Inventaire classé des secrets (action : sortir du bundle / OK), résultat du scan d'historique, état du stockage des tokens, liste des logs à expurger, confirmation transport release sain. Tout 🔴 P0 = ticket immédiat.
