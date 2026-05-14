# Spec API — `GET /api/v1/user/questions`

Récupère la liste paginée des questions posées par l'utilisateur authentifié, tous événements et tous statuts confondus (incluant `pending`, `approved`, `answered`, `rejected`).

**Base URL** : `https://api.lehiboo.com/api/v1` (prod) · `http://api.lehiboo.localhost/api/v1` (dev)

---

## Authentification

| Header | Valeur |
|---|---|
| `Authorization` | `Bearer <sanctum_token>` |
| `Accept` | `application/json` |

Middlewares appliqués : `auth:sanctum`, `account.active`.

---

## Query parameters

| Paramètre | Type | Requis | Défaut | Description |
|---|---|---|---|---|
| `per_page` | integer | non | `10` | Nombre de questions par page |
| `page` | integer | non | `1` | Numéro de page (Laravel paginator standard) |

> ⚠️ Aucun filtre sur `status`, `event_id` ou autre n'est implémenté. Tri figé : `created_at DESC`.

---

## Réponses

### `200 OK`

Format Laravel `AnonymousResourceCollection` paginé (clés `data`, `links`, `meta` standard du paginator) — **pas** la convention "dual format" custom du projet.

```json
{
  "data": [
    {
      "id": 42,
      "uuid": "9f1c8a4e-1234-4abc-9def-0123456789ab",

      "event_id": 17,
      "user_id": 5,
      "eventId": "17",
      "userId": "5",

      "question": "Le parking est-il gratuit ?",

      "status": "answered",
      "rejection_reason": null,
      "rejectionReason": null,
      "isAnswered": true,
      "is_pinned": false,
      "isPinned": false,
      "isPublic": true,

      "helpful_count": 3,
      "helpfulCount": 3,

      "author": {
        "name": "Jean.D",
        "avatar": "https://.../avatars/5.jpg",
        "initials": "JD",
        "isGuest": false
      },
      "authorName": "Jean.D",

      "answer": {
        "id": 12,
        "uuid": "7c2b...-...",
        "answer": "Oui, parking gratuit sur place.",
        "isOfficial": true,
        "organization": {
          "id": 9,
          "name": null,
          "logo": null
        },
        "organizationId": "9",
        "organizationName": "Productions Le Hiboo",
        "author": {
          "name": "Marie Dupont",
          "avatar": null
        },
        "created_at": "2026-04-20T14:32:11+00:00",
        "updated_at": "2026-04-20T14:32:11+00:00",
        "createdAt": "2026-04-20T14:32:11+00:00",
        "updatedAt": "2026-04-20T14:32:11+00:00",
        "createdAtFormatted": "1 week ago"
      },
      "hasAnswer": true,

      "created_at": "2026-04-19T10:15:00+00:00",
      "updated_at": "2026-04-20T14:32:11+00:00",
      "createdAt": "2026-04-19T10:15:00+00:00",
      "updatedAt": "2026-04-20T14:32:11+00:00",
      "createdAtFormatted": "1 week ago",

      "event": {
        "id": 17,
        "uuid": "5d3e...-...",
        "title": "Concert Jazz au Phare",
        "slug": "concert-jazz-au-phare",
        "isDeleted": false
      }
    }
  ],
  "links": {
    "first": "http://api.lehiboo.localhost/api/v1/user/questions?page=1",
    "last":  "http://api.lehiboo.localhost/api/v1/user/questions?page=4",
    "prev":  null,
    "next":  "http://api.lehiboo.localhost/api/v1/user/questions?page=2"
  },
  "meta": {
    "current_page": 1,
    "from": 1,
    "last_page": 4,
    "path": "http://api.lehiboo.localhost/api/v1/user/questions",
    "per_page": 10,
    "to": 10,
    "total": 37
  }
}
```

### `401 Unauthorized`

Token absent / invalide / expiré.

```json
{ "message": "Unauthenticated.", "error": "unauthenticated" }
```

### `403 Forbidden`

Compte désactivé / suspendu (middleware `account.active`).

---

## Schéma d'un item

### Champs de base

| Champ | Type | Description |
|---|---|---|
| `id` | int | ID interne |
| `uuid` | string | UUID public — utilisé pour les routes `PUT/DELETE /questions/{uuid}` |
| `event_id` / `eventId` | int / string | ID de l'événement |
| `user_id` / `userId` | int / string\|null | ID de l'auteur (toujours rempli ici puisque scope = user connecté) |
| `question` | string | Texte de la question |

### Statut & modération

| Champ | Valeurs |
|---|---|
| `status` | `pending` \| `approved` \| `answered` \| `rejected` |
| `rejection_reason` / `rejectionReason` | string\|null — motif si `status = rejected` |
| `isAnswered` | bool — `true` si `status === 'answered'` |
| `isPublic` / `is_pinned` / `isPinned` | bool |

### Engagement

| Champ | Description |
|---|---|
| `helpful_count` / `helpfulCount` | Nombre de votes "utile" |
| `userVoted` | **Absent** sur cet endpoint (relation `helpfulVotes` non chargée) |

### Auteur

| Champ | Description |
|---|---|
| `author.name` | `Prénom.X` (initiale du nom), ou prénom seul, ou partie locale de l'email |
| `author.avatar` | URL avatar utilisateur (nullable) |
| `author.initials` | 2 lettres pour placeholder |
| `author.isGuest` | `false` (impossible d'être guest sur cet endpoint, scope user_id) |
| `authorName` | Alias plat de `author.name` |

### Réponse organisateur

`answer` est `null` (objet null Resource) tant qu'il n'y a pas de réponse officielle (`is_official = true`). Charge la relation `answer.organization:id,organization_name` et `answer.user:id,name`.

> ⚠️ Bug léger côté Resource : `organization.name` est `null` car `EventAnswerResource` lit `$this->organization?->name` mais le contrôleur ne charge que la colonne `organization_name`. Le champ utile est `organizationName`.

`hasAnswer` est `true` si une réponse est chargée et non null.

### Événement

`event` est toujours présent ici (relation eager-loaded). `isDeleted` reflète `softDelete` côté Event.

### Timestamps

ISO 8601 (`toIso8601String`), exposés en snake_case **et** camelCase. `createdAtFormatted` = sortie `Carbon::diffForHumans()` (langue selon locale Laravel courante côté serveur).

