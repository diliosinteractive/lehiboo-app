# Migration Mobile — Stories Module

**Date**: 17 avril 2026
**Auteur**: Équipe Dev
**Deadline migration**: 1er juillet 2026 (sunset de l'ancien endpoint)

---

## Résumé

L'ancien système de stories (basé sur le trending d'événements) est remplacé par un nouveau module Stories dédié avec gestion de slots, validation admin, et paiement Stripe.

L'app mobile doit migrer de `GET /v1/stories` vers deux nouveaux endpoints.

---

## Ancien endpoint (DÉPRÉCIÉ)

### `GET /v1/stories`

| Élément | Détail |
|---------|--------|
| Contrôleur | `TrendingController::stories()` |
| Retourne | `EventResource[]` — des événements triés par score trending |
| Statut | **Déprécié** — retourne `Deprecation: true` dans les headers HTTP |
| Sunset | **1er juillet 2026** — sera supprimé après cette date |

**Headers de dépréciation retournés** :
```
Deprecation: true
Sunset: 2026-07-01
Link: </api/v1/stories/active>; rel="successor-version"
```

**Champ JSON ajouté** :
```json
{
  "success": true,
  "data": [...],
  "deprecated": true,
  "migration_notice": "This endpoint is deprecated. Use GET /v1/stories/active for the new Story module."
}
```

---

## Nouveaux endpoints

### 1. `GET /v1/stories/active` — Récupérer les stories du jour

| Élément | Détail |
|---------|--------|
| Contrôleur | `StoryController::active()` |
| Auth | Aucune (public) |
| Retourne | `StoryResource[]` — jusqu'à 8 stories actives |
| Ordre | Réservées en premier, puis optionnelles par `slot_position` |

**Exemple d'appel** :
```
GET /api/v1/stories/active
Accept: application/json
```

**Exemple de réponse** :
```json
{
  "success": true,
  "data": [
    {
      "uuid": "019d9183-b9ff-72c3-9c1d-a42122488ba5",
      "type": "optional",
      "status": "active",
      "title": "Brico-Conte: Le jardin de laine",
      "mediaUrl": "https://storage.lehiboo.com/.../image.jpg",
      "mediaType": "image",
      "startDate": "2026-04-20",
      "endDate": "2026-04-25",
      "slotPosition": 1,
      "impressionsCount": 42,
      "organization": {
        "uuid": "019d35e0-...",
        "organizationName": "Théâtre de Denain",
        "displayName": null
      },
      "event": {
        "uuid": "019d35e1-...",
        "slug": "olivier-de-benoist-le-droit-au-bonheur",
        "title": "Olivier de BENOIST : Le droit au bonheur",
        "featuredImage": "https://storage.lehiboo.com/.../cover.webp",
        "city": "Denain",
        "bookingMode": "booking",
        "primaryCategory": {
          "id": 5,
          "name": "Théâtre & Humour"
        }
      }
    }
  ]
}
```

**Règles d'affichage** :
- Seules les stories en statut `active` sont retournées
- Ordre : réservées (payantes/partenariats) → optionnelles (éditoriales)
- Maximum 8 stories simultanées
- Si 0 stories actives → la section ne s'affiche pas
- Après la dernière story → boucle automatique vers la première

---

### 2. `POST /v1/stories/{uuid}/impression` — Enregistrer une vue

| Élément | Détail |
|---------|--------|
| Contrôleur | `StoryController::recordImpression()` |
| Auth | Aucune (public) |
| Body | Aucun |
| Retourne | `{"success": true}` |
| Comportement | Incrémente atomiquement `impressions_count` |

**Exemple d'appel** :
```
POST /api/v1/stories/019d9183-b9ff-72c3-9c1d-a42122488ba5/impression
Accept: application/json
```

**Quand appeler** :
- Chaque fois qu'une story est affichée en plein écran à l'utilisateur
- Fire-and-forget : pas besoin d'attendre la réponse ni de gérer les erreurs
- Un appel par story affichée (pas de déduplication côté serveur)

---

## Mapping des champs (ancien → nouveau)

L'ancien endpoint retournait des `EventResource`. Le nouveau retourne des `StoryResource` avec l'événement imbriqué.

| Ancien (`EventResource`) | Nouveau (`StoryResource`) | Notes |
|--------------------------|---------------------------|-------|
| `uuid` | `event.uuid` | UUID de l'événement (pour les liens) |
| `title` | `title` | Titre de la story (peut différer du titre de l'event) |
| `cover_image` | `mediaUrl` | Image/vidéo 9:16 de la story |
| *(pas de champ)* | `mediaType` | `"image"` ou `"video"` — **nouveau**, permet le support vidéo |
| `category.name` | `event.primaryCategory.name` | Catégorie principale |
| `category.icon` | *(non disponible)* | L'icône catégorie n'est pas sur StoryResource |
| `location.city` | `event.city` | Ville |
| `slug` | `event.slug` | Pour construire l'URL de la fiche activité |
| `next_slot.slot_date` | `startDate` | Date de début de la story (pas du créneau) |
| *(pas de champ)* | `impressionsCount` | **Nouveau** — nombre de vues de la story |
| *(pas de champ)* | `organization.organizationName` | **Nouveau** — nom de l'organisateur |

---

## Comportement du viewer (spec conforme)

### Bande horizontale
- Stories affichées côte à côte dans des cercles
- Scroll horizontal tactile
- Titre de l'activité sous chaque cercle

### Vue plein écran (au tap)
- Auto-advance toutes les 5 secondes
- Barres de progression en haut (une par story)
- Pause au toucher maintenu
- Navigation : tap gauche = précédent, tap droit = suivant
- Bouton CTA "Voir l'activité" → ouvre la fiche événement (même onglet sur mobile)
- Après la dernière story → retour à la première (boucle infinie)

### Contenu affiché en plein écran
- Image ou vidéo en plein écran (`mediaUrl` + `mediaType`)
- Titre de la story en bas
- Catégorie + type d'activité (`event.primaryCategory.name` · Billetterie/Découverte)
- Ville (`event.city`)
- Bouton CTA vers `/{locale}/events/{event.slug}`

---

## Checklist migration

- [ ] Remplacer l'appel `GET /v1/stories` par `GET /v1/stories/active`
- [ ] Adapter le parsing du JSON (StoryResource au lieu de EventResource)
- [ ] Gérer le champ `mediaType` pour supporter les stories vidéo
- [ ] Appeler `POST /v1/stories/{uuid}/impression` à chaque story affichée
- [ ] Construire l'URL CTA avec `event.slug` au lieu de `slug`
- [ ] Afficher catégorie + type (Billetterie/Découverte) dans l'overlay
- [ ] Tester avec 0 stories (section masquée), 1 story, et 8 stories
- [ ] Supprimer les références à l'ancien endpoint avant le 1er juillet 2026
