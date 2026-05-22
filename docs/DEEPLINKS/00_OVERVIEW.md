# Deeplinks événements — Vue d'ensemble

> Date : 2026-05-19
> Objectif : un lien partagé `https://lehiboo.com/events/{slug}` ouvre l'app directement sur l'écran de détail de l'event, sans passer par le navigateur. Si l'app n'est pas installée, le navigateur charge la page web normalement.

---

## Périmètre

**Inclus dans cette première itération** :
- Universal Links iOS (HTTPS, sans confirmation utilisateur)
- App Links Android (HTTPS, vérifiés automatiquement)
- Route `/events/{slug}` → écran de détail d'un event
- Cold start (app fermée) **et** warm start (app en background)
- Fallback web si l'app n'est pas installée
- Gestion des cas spéciaux : event password-protected, auth requise, event introuvable

**Hors périmètre (phase 2)** :
- Deeplinks pour `/booking/{id}`, `/alerts`, `/organizers/{slug}`, billets, etc.
- Custom URL scheme `lehiboo://` (non nécessaire si Universal/App Links suffisent)
- Firebase Dynamic Links (déprécié par Google en 2025, à ne pas utiliser)

---

## Décisions d'architecture

| Sujet | Décision | Raison |
|-------|----------|--------|
| **Mécanisme iOS** | Universal Links (HTTPS) | Pas de prompt utilisateur, ouverture directe, fallback web natif |
| **Mécanisme Android** | App Links (HTTPS, `android:autoVerify="true"`) | Pas de "chooser", lien direct, vérification automatique via `assetlinks.json` |
| **Package Flutter** | `app_links` ^6.x | Standard de fait, supporte cold/warm start, maintenu, remplaçant officiel d'`uni_links` |
| **Routing** | `go_router` (déjà en place) | Les routes `/event/:id` et `/events/:id` existent déjà et acceptent UUID ou slug |
| **Domaine canonique** | À confirmer : `lehiboo.com` vs `lehiboo.fr` | Le code partage hard-code `lehiboo.com`, mais `.env.production` mentionne `lehiboo.fr`. **Bloquant — voir §Préalables** |
| **Bundle IDs** | À uniformiser ou déclarer les deux | iOS = `com.dilios.lehiboo`, Android = `com.dilios.lehibooexperience` — l'AASA doit lister les deux Team ID + Bundle ID iOS, le `assetlinks.json` doit lister Android |

---

## Préalables (bloquants — à clarifier avant de coder)

1. **Domaine de partage canonique** : confirmer avec le backend si les events sont servis sur `lehiboo.com/events/{slug}` ou `lehiboo.fr/events/{slug}`. Si les deux : couvrir les deux dans l'AASA et `assetlinks.json`.
2. **Apple Team ID** : récupérer depuis l'Apple Developer Portal (format `ABCDE12345`). Nécessaire pour l'AASA.
3. **SHA-256 du keystore Android Release** : récupérer pour `assetlinks.json` (commande dans `03_ANDROID_APP_LINKS.md`).
4. **Accès dépôt web** : l'équipe backend doit pouvoir publier deux fichiers statiques :
   - `https://lehiboo.com/.well-known/apple-app-site-association`
   - `https://lehiboo.com/.well-known/assetlinks.json`
   Servis en HTTPS, `Content-Type: application/json`, **sans redirection**, et **sans authentification**.

---

## Étapes (ordre d'exécution recommandé)

| # | Fichier | Description | Owner |
|---|---------|-------------|-------|
| 1 | [01_ANALYSE_EXISTANT.md](01_ANALYSE_EXISTANT.md) | État actuel du code (partage, routing, configs natives) | — (déjà fait) |
| 2 | [02_IOS_UNIVERSAL_LINKS.md](02_IOS_UNIVERSAL_LINKS.md) | Config Xcode + entitlements iOS | Mobile |
| 3 | [03_ANDROID_APP_LINKS.md](03_ANDROID_APP_LINKS.md) | Config `AndroidManifest.xml` + signing | Mobile |
| 4 | [04_FLUTTER_INTEGRATION.md](04_FLUTTER_INTEGRATION.md) | Package `app_links` + branchement `go_router` + auth replay | Mobile |
| 5 | [05_BACKEND_AASA_ASSETLINKS.md](05_BACKEND_AASA_ASSETLINKS.md) | Fichiers à publier côté web | Backend |
| 6 | [06_SHARE_URL_CLEANUP.md](06_SHARE_URL_CLEANUP.md) | Centralisation URL de partage + suppression des hard-codes | Mobile |
| 7 | [07_TESTING_QA.md](07_TESTING_QA.md) | Tests manuels + automatisés, checklist QA | Mobile + QA |
| 8 | [08_ROLLOUT.md](08_ROLLOUT.md) | Ordre de déploiement, feature flags, suivi analytics | Mobile + Backend |
| 9 | [09_ROUTING_ET_FIXES.md](09_ROUTING_ET_FIXES.md) | Correctifs post-intégration + recommandations `go`/`push` + convention boutons retour | Mobile |

L'ordre est important : **les fichiers AASA et `assetlinks.json` doivent être publiés AVANT d'envoyer un build avec les associated domains**, sinon iOS/Android marquent l'app comme "verification failed" et le système peut mettre 24h à retenter.

---

## Schéma du flow cible

```
[Utilisateur clique https://lehiboo.com/events/jazz-night-paris]
                              │
                ┌─────────────┴─────────────┐
                ▼                           ▼
        App installée               App non installée
                │                           │
                │                           ▼
                │                   Ouvre Safari/Chrome
                │                   → page web /events/jazz-night-paris
                │                   → bannière "Ouvrir dans l'app"
                ▼
        iOS Universal Link / Android App Link
                │
                ▼
        Flutter reçoit l'URL via `app_links`
                │
                ▼
        go_router.go('/events/jazz-night-paris')
                │
                ▼
        eventDetailControllerProvider('jazz-night-paris')
                │
                ▼
        ┌───────┴───────┐
        ▼               ▼
    Event public    Event protégé / 404
        │               │
        ▼               ▼
    EventDetailScreen   EventLockedView / écran "introuvable"
```

---

## Risques connus

| Risque | Impact | Mitigation |
|--------|--------|------------|
| L'AASA n'est pas servi correctement (mauvais MIME, redirect) | Universal Links silencieusement ignorés sur iOS | Tester avec `curl -I` + `https://branch.io/resources/aasa-validator/` avant release |
| `assetlinks.json` ne contient pas le SHA-256 du build store | App Links non vérifiés → ouverture dans le navigateur | Vérifier après upload avec `adb shell pm get-app-links com.dilios.lehibooexperience` |
| Deeplink vers route protégée par auth → utilisateur perdu | UX cassée | Capturer l'URL pendant le redirect login, rejouer après auth réussie (voir [04_FLUTTER_INTEGRATION.md](04_FLUTTER_INTEGRATION.md)) |
| Slug renvoyé par l'API ne correspond pas au slug dans l'URL | 404 dans l'app | Le repo `getEvent(identifier)` gère déjà UUID + slug — à valider en test |
| Mismatch domaine prod (`lehiboo.com` vs `lehiboo.fr`) | Liens partagés morts | Bloqué tant que le préalable #1 n'est pas tranché |

---

## Critères d'acceptation

- [ ] Sur iOS Release/TestFlight, cliquer un lien `https://lehiboo.com/events/{slug}` depuis Messages/Mail ouvre l'app sur le détail event en < 2 s
- [ ] Sur Android Release, idem depuis Gmail/Messages
- [ ] App fermée (cold start) : même comportement, idéalement < 3 s
- [ ] App non installée : la page web se charge dans le navigateur sans erreur
- [ ] Event password-protected accédé par deeplink : affiche le `EventPasswordSheet`
- [ ] Event 404 : écran d'erreur clair avec bouton retour home
- [ ] Deeplink reçu en background (app ouverte sur une autre page) : navigue immédiatement vers le détail
- [ ] Analytics : event `deeplink_opened` envoyé avec `source=universal_link|app_link`, `event_slug`, `cold_start=true|false`
