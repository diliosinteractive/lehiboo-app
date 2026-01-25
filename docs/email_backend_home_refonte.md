# Email pour l'équipe Backend

**Objet :** [Feature Request] APIs Home Page App Mobile - Module Stories, Urgency & Partenaires

---

Bonjour l'équipe,

Dans le cadre de la refonte de la page d'accueil de l'application mobile, nous avons développé plusieurs nouveaux composants côté frontend qui nécessitent des évolutions de l'API pour fonctionner pleinement.

Actuellement, ces composants fonctionnent en mode "mock" avec les données existantes, mais pour une expérience optimale, nous avons besoin des endpoints et champs suivants.

---

## 1. Stories / Événements Trending

### Contexte

Nous avons implémenté un système de "Stories" similaire à Instagram en haut de la home page. Des cercles avec les événements trending que l'utilisateur peut parcourir en mode plein écran.

### Besoin : Nouvel endpoint

```http
GET /v1/events/trending
```

### Paramètres optionnels

| Paramètre | Type | Description |
|-----------|------|-------------|
| `limit` | int | Nombre max de stories (défaut: 10) |
| `lat` | float | Latitude pour personnalisation |
| `lng` | float | Longitude pour personnalisation |

### Réponse attendue

```json
{
  "data": [
    {
      "uuid": "550e8400-e29b-41d4-a716-446655440000",
      "title": "Festival Jazz à Vienne",
      "story_image_url": "https://cdn.lehiboo.com/stories/event-123-story.jpg",
      "story_video_url": null,
      "thumbnail_url": "https://cdn.lehiboo.com/stories/event-123-thumb.jpg",
      "category": {
        "name": "Concert",
        "slug": "concert"
      },
      "city": {
        "name": "Vienne",
        "slug": "vienne"
      },
      "next_slot": {
        "start_datetime": "2026-02-15T20:00:00Z",
        "end_datetime": "2026-02-15T23:00:00Z"
      },
      "is_sponsored": false,
      "sponsor_name": null,
      "priority": 1,
      "expires_at": "2026-02-14T23:59:59Z"
    }
  ],
  "meta": {
    "total": 8
  }
}
```

### Champs spécifiques Stories

| Champ | Type | Requis | Description |
|-------|------|--------|-------------|
| `story_image_url` | string | Oui | Image optimisée pour mobile (ratio 9:16 recommandé, 1080x1920px) |
| `story_video_url` | string | Non | Vidéo courte (15s max, format MP4) |
| `thumbnail_url` | string | Oui | Miniature pour le cercle (200x200px, carré) |
| `is_sponsored` | bool | Oui | Si true, affiche badge "Sponsorisé" |
| `sponsor_name` | string | Non | Nom du sponsor si sponsorisé |
| `priority` | int | Non | Ordre d'affichage (1 = premier) |
| `expires_at` | datetime | Non | Date d'expiration de la story |

### Questions

1. Quel critère pour déterminer les événements "trending" ? (vues, ventes, manuel ?)
2. Faut-il un module admin pour gérer manuellement les stories ?
3. Les stories sponsorisées seront-elles gérées via le module pub existant ?

---

## 2. Événements Urgents (FOMO Countdown)

### Contexte

Nous affichons une section "Avant qu'il soit trop tard" avec des événements qui commencent bientôt et/ou ont peu de places restantes. Un countdown en temps réel crée un sentiment d'urgence.

### Besoin : Extension de `/v1/home-feed`

Ajouter un nouveau champ `urgency` dans la réponse du home-feed.

### Réponse étendue

```json
{
  "data": {
    "today": [...],
    "tomorrow": [...],
    "recommended": [...],
    "urgency": [
      {
        "uuid": "550e8400-e29b-41d4-a716-446655440001",
        "title": "Escape Game - La Prison",
        "image_url": "https://cdn.lehiboo.com/events/escape-game.jpg",
        "category": {
          "name": "Atelier",
          "slug": "atelier"
        },
        "city": {
          "name": "Lyon",
          "slug": "lyon"
        },
        "next_slot": {
          "start_datetime": "2026-01-25T19:00:00Z"
        },
        "price_min": 25,
        "remaining_spots": 3,
        "booking_deadline": "2026-01-25T18:00:00Z",
        "urgency_type": "low_stock",
        "urgency_message": "Plus que 3 places !"
      }
    ]
  }
}
```

### Champs urgency

| Champ | Type | Requis | Description |
|-------|------|--------|-------------|
| `remaining_spots` | int | Non | Nombre de places restantes |
| `booking_deadline` | datetime | Non | Date limite de réservation |
| `urgency_type` | enum | Oui | Type: `low_stock`, `deadline`, `last_chance`, `selling_fast` |
| `urgency_message` | string | Non | Message personnalisé ("Plus que 3 places !") |

### Critères de sélection suggérés

Un événement apparaît dans `urgency` si :
- `remaining_spots` <= 10 ET `remaining_spots` > 0
- OU `booking_deadline` dans les prochaines 12h
- OU `next_slot.start_datetime` dans les prochaines 6h

### Questions

1. Avez-vous déjà un tracking du nombre de places restantes ?
2. Le champ `booking_deadline` existe-t-il ou faut-il l'ajouter au modèle Event ?
3. Préférez-vous calculer `urgency_type` côté backend ou qu'on le détermine côté app ?

---

## 3. Configuration Partenaires Premium

### Contexte

Nous avons une section "Sélection Partenaire" qui met en avant les événements d'un partenaire premium avec son branding (logo, couleur, tagline).

### Besoin : Extension de `/mobile/config`

Ajouter une section `partners` dans la config mobile.

### Réponse étendue

```json
{
  "hero": {
    "image": "https://...",
    "title": "...",
    "subtitle": "..."
  },
  "ads": {
    "enabled": true,
    "banners": [...]
  },
  "partners": {
    "enabled": true,
    "highlight": {
      "id": 1,
      "name": "FNAC Spectacles",
      "slug": "fnac-spectacles",
      "logo_url": "https://cdn.lehiboo.com/partners/fnac-logo.png",
      "tagline": "La sélection FNAC",
      "brand_color": "#E1A100",
      "background_image_url": "https://cdn.lehiboo.com/partners/fnac-bg.jpg",
      "events_count": 45,
      "cta_text": "Voir la sélection",
      "cta_url": null
    }
  },
  "stories_enabled": true,
  "urgency_enabled": true
}
```

### Besoin : Endpoint événements partenaire

```http
GET /v1/partners/{id}/events
```

ou

```http
GET /v1/events?partner_id={id}
```

### Paramètres

| Paramètre | Type | Description |
|-----------|------|-------------|
| `partner_id` | int | ID du partenaire |
| `limit` | int | Nombre max d'événements (défaut: 10) |
| `page` | int | Pagination |

### Questions

1. Avez-vous déjà une table `partners` ou faut-il la créer ?
2. Comment sont liés les événements aux partenaires ? (champ `partner_id` sur Event ?)
3. Le partenaire highlight sera-t-il configurable via admin ou hardcodé ?

---

## 4. Publicités Natives (optionnel)

### Contexte

Nous avons un composant de pub native qui s'intègre au feed comme une card normale mais avec un badge "Sponsorisé".

### Besoin : Extension de `/mobile/config` ads

```json
{
  "ads": {
    "enabled": true,
    "banners": [...],
    "native": {
      "enabled": true,
      "items": [
        {
          "id": "native_ad_1",
          "image_url": "https://cdn.lehiboo.com/ads/festival-ete.jpg",
          "title": "Festival d'été 2026",
          "subtitle": "Les meilleurs concerts de la saison",
          "sponsor_name": "FNAC Spectacles",
          "sponsor_logo_url": "https://cdn.lehiboo.com/partners/fnac-logo.png",
          "cta_text": "Réserver",
          "target_url": "https://www.fnacspectacles.com/festival",
          "tracking_pixel_url": "https://tracking.example.com/impression?id=xyz",
          "position": "after_urgency",
          "start_date": "2026-01-01T00:00:00Z",
          "end_date": "2026-03-31T23:59:59Z"
        }
      ]
    }
  }
}
```

### Champs pub native

| Champ | Type | Description |
|-------|------|-------------|
| `position` | enum | Où afficher: `after_urgency`, `after_recommendations`, `after_thematiques` |
| `tracking_pixel_url` | string | URL à appeler pour tracker l'impression |
| `start_date` / `end_date` | datetime | Période de diffusion |

---

## 5. Module Admin suggéré

Pour gérer tout cela efficacement, voici ce qui serait utile côté admin :

### Section "Mises en avant"

1. **Stories Manager**
   - Sélectionner les événements à afficher en stories
   - Upload d'image/vidéo spécifique pour la story
   - Définir l'ordre de priorité
   - Définir une date d'expiration
   - Marquer comme sponsorisé + lier à un annonceur

2. **Urgency Rules** (optionnel)
   - Configurer les seuils (ex: afficher si < 10 places)
   - Configurer les délais (ex: afficher si commence dans < 6h)
   - Messages personnalisés par type d'urgence

3. **Partners Manager**
   - CRUD partenaires (logo, couleur, tagline)
   - Associer des événements à un partenaire
   - Définir le partenaire "highlight" du moment

4. **Native Ads Manager**
   - Créer des campagnes pub native
   - Définir les dates de diffusion
   - Tracking des impressions/clics

---

## Récapitulatif des priorités

| Priorité | Feature | Effort estimé | Impact UX |
|----------|---------|---------------|-----------|
| **1 - Urgent** | Extension home-feed avec `urgency` | Faible | Fort |
| **2 - Important** | Endpoint `/v1/events/trending` | Moyen | Fort |
| **3 - Moyen** | Config partners dans `/mobile/config` | Faible | Moyen |
| **4 - Nice to have** | Endpoint `/v1/partners/{id}/events` | Faible | Moyen |
| **5 - Optionnel** | Native ads dans config | Faible | Commercial |

---

## Calendrier suggéré

1. **Sprint 1** : `urgency` dans home-feed (les données existent peut-être déjà ?)
2. **Sprint 2** : Endpoint trending + config partners
3. **Sprint 3** : Module admin Stories + Partners

---

## Questions ouvertes

1. Quel est le délai réaliste pour ces évolutions ?
2. Faut-il prévoir une rétrocompatibilité avec l'ancienne app ?
3. Avez-vous des contraintes techniques particulières à anticiper ?

N'hésitez pas à me contacter pour discuter de ces specs ou si vous avez besoin de clarifications.

Merci !

---

**Pièces jointes suggérées :**
- Maquettes/Screenshots des nouveaux composants
- Documentation technique complète (`docs/home_page_refonte.md`)
