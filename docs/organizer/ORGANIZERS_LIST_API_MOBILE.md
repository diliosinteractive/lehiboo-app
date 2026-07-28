# Organizers List — API Reference

**Audience** : App mobile (Flutter), intégrations tierces, frontend web
**Status** : Stable contract
**Controller** : `App\Http\Controllers\Api\V1\VendorController@index`
**Route name** : `organizers.index`

Endpoint public qui retourne la liste paginée des organisateurs **vérifiés**, avec recherche par nom, filtre par ville et tri. C'est le pendant "annuaire" du profil public unitaire (`GET /v1/organizers/{slug_or_uuid}`).

---

## 1. Endpoint

```
GET /api/v1/organizers
```

- **Auth** : aucune (endpoint public).
- **Visibilité** : seules les organisations au statut `verified` sont exposées. Les organisations `pending` / `suspended` ne remontent jamais.

---

## 2. Query Parameters

| Paramètre | Type | Défaut | Contraintes | Description |
|-----------|------|--------|-------------|-------------|
| `search` | string | – | max 255 | Recherche insensible à la casse sur le nom commercial (`organization_display_name`), le nom d'organisation (`organization_name`) et la raison sociale (`company_name`). |
| `city` | string | – | max 255 | Filtre insensible à la casse sur la ville (correspondance partielle). |
| `sort_by` | string | `name` | `name`, `events_count`, `followers_count`, `created_at` | Champ de tri. `events_count` = nombre d'événements publiés ; `followers_count` = nombre d'abonnés. |
| `sort_order` | string | `asc` si `sort_by=name`, sinon `desc` | `asc`, `desc` | Sens du tri. |
| `per_page` | int | `12` | 1 – 100 | Nombre de résultats par page. |
| `page` | int | `1` | – | Numéro de page (pagination standard Laravel). |

### Exemples

```
GET /api/v1/organizers?search=theatre&per_page=20
GET /api/v1/organizers?city=Lille&sort_by=events_count&sort_order=desc
GET /api/v1/organizers?sort_by=followers_count&page=2
```

---

## 3. Réponse — `200 OK`

La réponse suit le format standard des collections paginées (resource collection Laravel) : un tableau `data` + les blocs `links` et `meta`.

```json
{
  "data": [
    {
      "id": 42,
      "uuid": "9f1c8e2a-3b4d-4e5f-8a9b-0c1d2e3f4a5b",
      "name": "Théâtre de Denain",
      "slug": "theatre-de-denain",
      "display_name": "Théâtre de Denain",
      "displayName": "Théâtre de Denain",
      "description": "Salle de spectacle municipale…",
      "logo": "https://.../logo.png",
      "logo_url": "https://.../logo.png",
      "cover_image": "https://.../cover.jpg",
      "website": "https://theatre-denain.fr",
      "email": "contact@theatre-denain.fr",
      "phone": "+33 3 27 00 00 00",
      "city": "Denain",
      "country": "FR",
      "isVerified": true,
      "verified": true,
      "eventsCount": 12,
      "events_count": 12,
      "followersCount": 340,
      "followers_count": 340,
      "teamCount": 5,
      "adherentsCount": 0,
      "reviews_count": 87,
      "average_rating": 4.6,
      "is_followed": null,
      "is_owner": null,
      "createdAt": "2025-03-01T09:00:00+00:00"
    }
  ],
  "links": {
    "first": "http://api.lehiboo.localhost/api/v1/organizers?page=1",
    "last": "http://api.lehiboo.localhost/api/v1/organizers?page=8",
    "prev": null,
    "next": "http://api.lehiboo.localhost/api/v1/organizers?page=2"
  },
  "meta": {
    "current_page": 1,
    "from": 1,
    "last_page": 8,
    "per_page": 12,
    "to": 12,
    "total": 94
  }
}
```

> **Note** : le payload de chaque item est produit par `OrganizationResource` (même resource que le profil unitaire). Les champs sensibles (SIRET, Stripe, réglages) sont **omis** pour un appelant non authentifié — ils n'apparaissent que pour le propriétaire ou un admin. La liste ci-dessus ne montre que les champs pertinents pour un annuaire public.

### Champs utiles pour une carte "organisateur"

| Champ | Usage carte |
|-------|-------------|
| `uuid` | Clé de navigation vers le profil (`/v1/organizers/{uuid}`). |
| `name` / `displayName` | Nom affiché. |
| `logo` / `cover_image` | Visuels. |
| `city` | Badge localisation. |
| `verified` | Badge "vérifié". |
| `events_count` | Nombre d'activités publiées. |
| `followers_count` | Nombre d'abonnés. |
| `average_rating` / `reviews_count` | Note moyenne + volume d'avis (agrégés sur tous les événements de l'organisateur). |

---

## 4. Champs `is_followed` / `is_owner`

Cet endpoint n'exige pas d'authentification et **ne personnalise pas** les champs : `is_followed` et `is_owner` valent `null`. Pour connaître l'état "suivi" d'un organisateur précis, appeler le profil unitaire authentifié `GET /v1/organizers/{uuid}` (avec `Authorization`), ou la liste `GET /v1/me/organizers/following`.

---

## 5. Codes d'erreur

| Code | Cause |
|------|-------|
| `200` | Succès (y compris résultat vide : `data: []`). |
| `422` | Paramètre invalide (`sort_by` hors énumération, `per_page` hors bornes, etc.). |

Exemple `422` :

```json
{
  "message": "The selected sort by is invalid.",
  "errors": {
    "sort_by": ["The selected sort by is invalid."]
  }
}
```

---

## 6. Performance

- Les compteurs (`events_count`, `followers_count`, `team_count`, `adherents_count`) sont chargés via `withCount` (une seule requête).
- Les agrégats d'avis (`reviews_count`, `average_rating`) sont hydratés par **une** requête groupée sur la page courante (pas de N+1).
- La recherche utilise `ILIKE` (PostgreSQL). Pour un catalogue volumineux, envisager un basculement futur vers Meilisearch (comme `events/search`).

---

## 7. Endpoints organisateurs liés

| Méthode | Route | Description |
|---------|-------|-------------|
| `GET` | `/v1/organizers` | **Liste paginée** des organisateurs (ce document). |
| `GET` | `/v1/organizers/{slug_or_uuid}` | Profil public d'un organisateur. |
| `GET` | `/v1/organizers/{slug_or_uuid}/events` | Événements publiés d'un organisateur. |
| `GET` | `/v1/organizers/{slug_or_uuid}/reviews` | Avis agrégés d'un organisateur. |
| `GET` | `/v1/organizers/{slug_or_uuid}/reviews/stats` | Distribution des notes. |
| `GET` | `/v1/me/organizers/following` | Organisateurs suivis par l'utilisateur connecté. |

Voir aussi : `docs/05-reference/ORGANIZER_PROFILE_MOBILE_SPEC.md`.
