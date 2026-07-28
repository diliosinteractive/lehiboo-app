# Étape 8 — Rollout et suivi

---

## 1. Ordre de déploiement (critique)

L'ordre minimise les "verification failed" qu'iOS/Android cachent ensuite plusieurs heures.

```
J-7    Backend prépare AASA + assetlinks.json en staging
J-5    Validation des deux fichiers sur staging (curl + validators)
J-3    Backend déploie sur prod (lehiboo.com/.well-known/*)
J-3    Validation prod (curl + validators)
J-2    Build mobile interne avec entitlements/manifest, install sur device QA
J-2    QA : matrice de tests (étape 07)
J-1    Si OK → submission App Store / publication Play Store
J0     Release publique
J+1    Monitoring (cf. §3)
```

→ **Ne pas inverser** : si un build mobile avec entitlements est installé avant l'AASA, iOS marque le domaine "failed" pour ce device et peut attendre 8h-24h avant de retenter.

---

## 2. Feature flag (optionnel mais recommandé)

Pour pouvoir désactiver le listener sans nouvelle release, ajouter un toggle :

`lib/config/env_config.dart` :

```dart
static bool get deeplinksEnabled =>
    dotenv.env['DEEPLINKS_ENABLED']?.toLowerCase() != 'false';
```

Dans `DeeplinkListener._bootstrap()` :

```dart
if (!EnvConfig.deeplinksEnabled) return;
```

Par défaut activé. En cas de problème en prod, on peut pousser un `.env` distant (si disponible via remote config) ou faire un hotfix.

**Note** : même si le listener est off, les URLs continuent d'ouvrir l'app (c'est l'OS qui le fait). Le flag ne désactive que le **routing** vers l'event — l'app s'ouvre simplement sur la home. Acceptable comme degraded mode.

---

## 3. Monitoring post-release

### Métriques à suivre dans Firebase / GA4

| Event | Params | Ce qu'on regarde |
|-------|--------|------------------|
| `deeplink_opened` | `source`, `path`, `cold_start`, `utm_source` | Volume quotidien, ratio cold/warm |
| `deeplink_unmapped` (à ajouter) | `host`, `path` | Détecter les URLs non gérées (formats inattendus) |
| `event_view` (existant) | `entry_point=deeplink` | Conversion deeplink → vue détail |
| `event_share` (existant) | — | Volume de partages (pour mesurer le ROI) |
| Crashlytics | — | Surveiller crash spike post-release lié au listener |

### Dashboard

À créer (GA4 ou Looker Studio) :

1. **Volume deeplinks par jour** (cold vs warm vs iOS vs Android)
2. **Funnel partage → ouverture** : `event_shared` (jour J) → `deeplink_opened` (J → J+7)
3. **Taux d'erreur** : `deeplink_opened` → `event_view` (gap = events introuvables / locked)

### Alertes

- Si `deeplink_opened` chute de >50% d'un jour à l'autre → vérifier AASA / assetlinks accessibles
- Si `deeplink_unmapped` >5% du total → format d'URL non prévu, investigation

---

## 4. Communication interne

### Avant rollout

- [ ] Slack/Notion : informer le support que les liens partagés vont commencer à ouvrir l'app (anticipation des questions utilisateurs)
- [ ] Backend : confirmer le SLA sur l'uptime de `/.well-known/*` (si ces fichiers tombent, les deeplinks cassent)

### Après rollout

- [ ] Post J+1 : partager les premiers chiffres deeplinks dans le canal mobile/produit
- [ ] Documenter dans le README projet (ou ce dossier) la procédure de regen des certificats si le keystore change

---

## 5. Roadmap suite (phase 2)

Une fois la phase 1 stable, étendre aux autres écrans avec des deeplinks utiles :

| URL | Cible app | Priorité |
|-----|-----------|----------|
| `https://lehiboo.com/organizers/{slug}` | `/organizers/:identifier` | Moyen — augmente reach des organisateurs |
| `https://lehiboo.com/booking/{uuid}` | `/booking-detail/:id` | Haut — confirmation email → app |
| `https://lehiboo.com/ticket/{uuid}` | `/ticket/:id` | Haut — ouvrir un billet depuis l'email |
| `https://lehiboo.com/alerts` | `/alerts` | Bas |
| `https://lehiboo.com/categories/{slug}` | Recherche filtrée | Moyen |

Chaque ajout nécessite :
- Une mise à jour de l'AASA (`/organizers/*`, `/booking/*`, etc.)
- Une mise à jour du manifest Android (`pathPrefix` supplémentaire)
- Une extension de `mapDeeplinkToRoute`
- Tests dédiés

L'AASA permet de **multiplier les `components`** sans limite — voir la doc Apple. Le manifest Android peut aussi avoir plusieurs `intent-filter`.

---

## 6. Maintenance

### Quand le keystore Android change

1. Récupérer le nouveau SHA-256
2. Mettre à jour `assetlinks.json` (ajouter sans retirer l'ancien pendant la transition)
3. Pousser sur prod
4. Sur device de test : `adb shell pm verify-app-links --re-verify com.dilios.lehibooexperience`
5. Une fois 100% des users sur la nouvelle clé : retirer l'ancien SHA

### Quand le Bundle ID iOS change

1. Mettre à jour `appIDs` dans l'AASA (ajouter, ne pas retirer pendant transition)
2. Mettre à jour `Runner.entitlements` au prochain build

### Quand un nouveau domaine est ajouté (ex: lancement `.fr`)

1. Mettre à jour `Runner.entitlements` : ajouter `applinks:lehiboo.fr`
2. Mettre à jour `AndroidManifest.xml` : nouveau `intent-filter` avec `host="lehiboo.fr"`
3. Publier AASA + assetlinks **sur le nouveau domaine**
4. Tester les deux domaines

---

## 7. Checklist finale avant release

- [ ] Toutes les checklists des étapes 02-07 sont cochées
- [ ] Build interne testé sur device iOS physique et Android physique
- [ ] Feature flag en place et testé
- [ ] Dashboard analytics créé
- [ ] Support averti
- [ ] Documentation backend à jour (qui re-génère les fichiers .well-known si besoin)
- [ ] Note de release : "Les liens d'événements partagés ouvrent maintenant directement l'app"
