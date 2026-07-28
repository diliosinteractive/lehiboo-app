# Spec API Avis (Reviews) — Intégration Mobile

Ce document décrit les endpoints REST à utiliser pour intégrer le système d'avis dans l'app mobile Flutter. Il couvre les **routes publiques** et les **routes utilisateur authentifié**. Les routes vendor / admin sont référencées en annexe pour information mais ne doivent pas être consommées par l'app mobile.

**Base URL** : `https://api.lehiboo.com/api/v1` (prod) · `http://api.lehiboo.localhost/api/v1` (dev)

**Auth** : header `Authorization: Bearer <token>` pour toutes les routes authentifiées. Les routes publiques peuvent aussi recevoir un token — dans ce cas, certains champs supplémentaires sont retournés (par ex. `userVote`).

**Format de réponse** : tous les endpoints suivent la convention dual-format : les champs sont présents en **snake_case** ET en **camelCase**. Pour le mobile, privilégier le **camelCase**.

---

## Vue d'ensemble du modèle métier

Un **avis** (`EventReview`) est une note (1 à 5 étoiles) avec titre + commentaire laissée par un utilisateur sur un événement.

| Statut (`status`) | Visibilité publique | Description |
|-------------------|---------------------|-------------|
| `pending` | ❌ | En attente de modération admin |
| `approved` | ✅ | Visible publiquement |
| `rejected` | ❌ | Rejeté par modération |

**Règles métier importantes** :
- ⏳ L'événement doit être **passé** pour pouvoir être noté.
- 🎫 L'utilisateur doit avoir **participé** (booking confirmé OU ticket utilisé) — sinon refus 422 `not_participated`.
- 🚫 L'organisateur **ne peut pas** noter ses propres événements (422 `organizer_cannot_review`).
- 🔒 Un seul avis par couple (event, user). Tentative supplémentaire → 422 `already_reviewed`.
- ✏️ La modification d'un avis approuvé le repasse en `pending` (re-modération).
- 👍 Un utilisateur ne peut pas voter sur son propre avis, ni le signaler.

---

## 1. Routes publiques (sans auth)

### 1.1 Lister les avis d'un événement

```http
GET /events/{slug}/reviews
```

Retourne uniquement les avis **approved** (les `pending` / `rejected` ne sont pas exposés).

**Query params** :

| Param | Type | Défaut | Description |
|-------|------|--------|-------------|
| `rating` | int (1-5) | — | Filtrer par note exacte |
| `verified_only` | bool | `false` | Uniquement les avis vérifiés (auteur a participé) |
| `featured_only` | bool | `false` | Uniquement les avis mis en avant par l'organisateur |
| `sort_by` | string | `helpful` | `helpful`, `rating`, `created_at` |
| `sort_order` | string | `desc` | `asc` ou `desc` |
| `per_page` | int | `10` | Nombre d'avis par page |
| `page` | int | `1` | Page |

**Response 200** :
```json
{
  "data": [
    {
      "uuid": "550e8400-e29b-41d4-a716-446655440000",
      "rating": 5,
      "title": "Excellent événement !",
      "comment": "L'organisation était impeccable, je recommande...",
      "status": "approved",
      "helpfulCount": 24,
      "notHelpfulCount": 2,
      "helpfulnessPercentage": 92.3,
      "isVerifiedPurchase": true,
      "isFeatured": true,
      "author": {
        "name": "Jean Dupont",
        "firstName": "Jean",
        "lastName": "Dupont",
        "avatar": "https://cdn.lehiboo.com/avatars/12.jpg",
        "initials": "JD"
      },
      "response": {
        "uuid": "660e8400-e29b-41d4-a716-446655440001",
        "response": "Merci beaucoup pour ce retour positif !",
        "organization": {
          "name": "Mon Événementiel",
          "logo": "https://cdn.lehiboo.com/logos/3.jpg"
        },
        "author": { "name": "Marie Martin", "avatar": null },
        "createdAt": "2026-02-01T10:00:00+00:00",
        "createdAtFormatted": "il y a 3 mois"
      },
      "hasResponse": true,
      "userVote": true,
      "createdAt": "2026-01-25T14:30:00+00:00",
      "createdAtFormatted": "il y a 3 mois"
    }
  ],
  "links": { "first": "...", "last": "...", "prev": null, "next": "..." },
  "meta": { "current_page": 1, "per_page": 10, "total": 142, "last_page": 15 }
}
```

> **Note** : `userVote` (`true` = helpful, `false` = not helpful, `null` = pas voté) n'est renvoyé que si l'appel est authentifié (token envoyé même sur cette route publique).

---

### 1.2 Statistiques d'avis d'un événement

```http
GET /events/{slug}/reviews/stats
```

À utiliser pour afficher la note moyenne + distribution sur la fiche événement.

**Response 200** :
```json
{
  "totalReviews": 142,
  "averageRating": 4.6,
  "verifiedCount": 128,
  "distribution": {
    "5": 98,
    "4": 32,
    "3": 8,
    "2": 3,
    "1": 1
  },
  "percentages": {
    "5": 69,
    "4": 23,
    "3": 6,
    "2": 2,
    "1": 1
  }
}
```

---

## 2. Routes utilisateur authentifié

Préfixe : `/api/v1` — toutes nécessitent `Authorization: Bearer <token>` et un compte actif (middleware `account.active`).

---

### 2.1 Vérifier si l'utilisateur peut laisser un avis

```http
GET /events/{slug}/reviews/can-review
```

À appeler **avant** d'afficher le bouton "Laisser un avis" sur la fiche événement.

**Response 200 — autorisé** :
```json
{
  "canReview": true,
  "hasAttended": true,
  "isVerifiedPurchase": true
}
```

**Response 200 — déjà examiné** :
```json
{
  "canReview": false,
  "reason": "already_reviewed",
  "review_status": "pending",
  "existingReview": { /* EventReviewResource complet */ }
}
```

**Response 200 — refusé pour autre raison** :
```json
{
  "canReview": false,
  "reason": "organizer_cannot_review",
  "hasAttended": false,
  "isVerifiedPurchase": false
}
```

| `reason` | Signification |
|----------|---------------|
| `already_reviewed` | L'utilisateur a déjà laissé un avis (voir `existingReview`) |
| `organizer_cannot_review` | C'est l'organisateur de l'événement |
| `event_not_ended` | L'événement n'a pas encore eu lieu |
| `not_participated` | L'utilisateur n'a pas de booking/ticket valide |

---

### 2.2 Créer un avis

```http
POST /events/{slug}/reviews
```

**Body (JSON)** :

| Champ | Type | Required | Contraintes |
|-------|------|----------|-------------|
| `rating` | int | ✅ | 1 à 5 |
| `title` | string | ✅ | max 150 caractères |
| `comment` | string | ✅ | 10 à 2000 caractères |
| `booking_uuid` | string | ❌ | UUID d'un booking lié (pour marquage "verified purchase") |

**Response 201** :
```json
{
  "message": "Review created successfully.",
  "review": {
    "uuid": "550e8400-e29b-41d4-a716-446655440000",
    "rating": 5,
    "title": "Magnifique !",
    "comment": "L'événement était excellent...",
    "status": "pending",
    "isVerifiedPurchase": true,
    "createdAt": "2026-04-28T10:00:00+00:00"
    /* + tous les autres champs EventReviewResource */
  }
}
```

L'avis est créé en statut **`pending`** : il ne sera visible publiquement qu'après validation par un administrateur. L'utilisateur reçoit une push notification à chaque transition (approuvé / rejeté).

**Erreurs 422** :
```json
{
  "message": "You have already reviewed this event.",
  "errors": { "review": ["already_reviewed"] }
}
```

| Code d'erreur | Cas |
|---------------|-----|
| `already_reviewed` | L'utilisateur a déjà un avis sur cet événement |
| `organizer_cannot_review` | Tentative de noter ses propres événements |
| `event_not_ended` | L'événement n'est pas encore passé |
| `not_participated` | Pas de booking/ticket valide |
| Validation classique | Champs manquants ou invalides |

---

### 2.3 Récupérer un avis spécifique

```http
GET /reviews/{uuid}
```

**Response 200** : objet `EventReviewResource` (voir 1.1 pour la structure).

---

### 2.4 Modifier son avis

```http
PUT /reviews/{uuid}
```

Seul l'auteur de l'avis peut le modifier. **Toute modification repasse l'avis en `pending`** (re-modération).

**Body (JSON)** : tous les champs sont optionnels — n'envoyer que ceux à modifier.

| Champ | Type | Contraintes |
|-------|------|-------------|
| `rating` | int | 1 à 5 |
| `title` | string | max 150 caractères |
| `comment` | string | 10 à 2000 caractères |

**Response 200** :
```json
{
  "message": "Review updated successfully.",
  "review": { /* EventReviewResource */ }
}
```

| Erreur | Cas |
|--------|-----|
| `403` | L'utilisateur n'est pas l'auteur de l'avis |
| `404` | UUID inconnu |
| `422` | Validation |

---

### 2.5 Supprimer son avis

```http
DELETE /reviews/{uuid}
```

Soft delete. L'auteur peut supprimer son propre avis.

**Response 200** :
```json
{ "message": "Review deleted successfully." }
```

---

### 2.6 Voter sur l'utilité d'un avis (helpful / not helpful)

```http
POST /reviews/{uuid}/vote
```

**Body (JSON)** :

| Champ | Type | Required | Description |
|-------|------|----------|-------------|
| `is_helpful` | bool | ✅ | `true` = utile, `false` = pas utile |

**Response 200** :
```json
{
  "message": "Vote recorded successfully.",
  "helpful_count": 25,
  "not_helpful_count": 2
}
```

**Erreurs 422** :
- `"You cannot vote on your own review."`
- `"You have already voted on this review."` (utiliser `unvote` puis re-vote pour changer)

---

### 2.7 Retirer son vote

```http
DELETE /reviews/{uuid}/vote
```

**Response 200** :
```json
{
  "message": "Vote removed successfully.",
  "helpful_count": 24,
  "not_helpful_count": 2
}
```

**Erreur 422** : `"No vote to remove."`

> **Pattern UI conseillé** : pour changer un vote (passer de helpful à not helpful), faire un `DELETE /vote` puis un `POST /vote` avec la nouvelle valeur. Le champ `userVote` du `EventReviewResource` indique l'état courant du vote utilisateur sur l'avis.

---

### 2.8 Signaler un avis inapproprié

```http
POST /reviews/{uuid}/report
```

**Body (JSON)** :

| Champ | Type | Required | Valeurs |
|-------|------|----------|---------|
| `reason` | string | ✅ | `spam`, `inappropriate`, `fake`, `offensive`, `other` |
| `details` | string | ❌ | Précisions, max 500 caractères |

**Response 200** :
```json
{ "message": "Report submitted successfully." }
```

**Erreur 422** : `"You cannot report your own review."`

---

### 2.9 Lister mes avis

```http
GET /user/reviews
```

Retourne **tous** les avis de l'utilisateur, **tous statuts confondus** (`pending`, `approved`, `rejected`).

**Query params** :

| Param | Type | Défaut | Description |
|-------|------|--------|-------------|
| `per_page` | int | `10` | Nombre d'avis par page |
| `page` | int | `1` | Page |

**Response 200** :
```json
{
  "data": [
    {
      "uuid": "550e8400-...",
      "rating": 5,
      "title": "Excellent",
      "comment": "...",
      "status": "approved",
      "helpfulCount": 10,
      "createdAt": "2026-01-25T14:30:00+00:00",
      "event": {
        "uuid": "660e8400-...",
        "title": "Atelier de photographie",
        "slug": "atelier-photographie",
        "organization": {
          "organization_name": "Photo Events",
          "company_name": "Photo Events SAS"
        }
      },
      "response": { /* ReviewResponseResource ou null */ },
      "hasResponse": true
    }
  ],
  "meta": { "current_page": 1, "per_page": 10, "total": 8, "last_page": 1 }
}
```

---

### 2.10 Compteur d'avis en attente

```http
GET /user/reviews/pending-count
```

À utiliser pour afficher un badge dans le profil utilisateur (« vous avez X avis en cours de modération »).

**Response 200** :
```json
{
  "count": 2,
  "pendingCount": 2
}
```

---

## 3. Notifications push reçues par le mobile

Les notifications push (FCM) suivantes sont envoyées au revieweur. Le mobile doit les gérer pour réveiller l'app et afficher la bonne page.

| Notification | Quand | Payload utile |
|--------------|-------|---------------|
| `ReviewSubmittedNotification` | Avis créé (confirmation) | `review_uuid`, `event_slug` |
| `ReviewApprovedNotification` | Avis approuvé par admin | `review_uuid`, `event_slug` |
| `ReviewRejectedNotification` | Avis rejeté par admin | `review_uuid`, `event_slug`, `rejection_reason` |

> **UX conseillée** : sur tap d'une notif d'avis approuvé/rejeté, naviguer vers la liste « Mes avis » (`GET /user/reviews`) avec l'avis concerné mis en évidence.

---

## 4. Codes d'erreur HTTP — Récapitulatif

| Code | Signification |
|------|---------------|
| `200` | Succès (GET, PUT, DELETE, votes) |
| `201` | Avis créé |
| `401` | Token absent ou invalide |
| `403` | Pas autorisé (ex : modifier l'avis de quelqu'un d'autre) |
| `404` | Avis ou événement inexistant |
| `422` | Erreur métier ou validation (voir messages ci-dessus) |

Format standard d'erreur 422 :
```json
{
  "message": "The given data was invalid.",
  "errors": {
    "rating": ["The rating must be between 1 and 5."],
    "comment": ["The comment must be at least 10 characters."]
  }
}
```

---

## 5. Parcours utilisateur typiques

### 5.1 Afficher le bloc « Avis » sur la fiche événement

1. `GET /events/{slug}/reviews/stats` → afficher note moyenne + distribution.
2. `GET /events/{slug}/reviews?sort_by=helpful&per_page=10` → liste paginée.
3. Si user connecté : `GET /events/{slug}/reviews/can-review` → décider d'afficher le bouton « Laisser un avis ».

### 5.2 Soumettre un avis depuis l'app

1. `GET /events/{slug}/reviews/can-review` → vérifier l'autorisation.
2. Si `canReview = true` → afficher formulaire (rating, title, comment).
3. `POST /events/{slug}/reviews` → l'avis passe en `pending`.
4. Afficher message « Votre avis sera publié après validation ».
5. Réception ultérieure de `ReviewApprovedNotification` ou `ReviewRejectedNotification`.

### 5.3 Voter sur un avis

1. User tape 👍 → `POST /reviews/{uuid}/vote` avec `is_helpful: true`.
2. UI : mettre à jour optimiste (incrémenter `helpfulCount`, `userVote = true`).
3. Pour changer son vote : `DELETE /reviews/{uuid}/vote` puis nouveau `POST` avec `is_helpful: false`.

### 5.4 Gérer ses avis (page profil)

1. `GET /user/reviews/pending-count` → badge.
2. `GET /user/reviews` → liste avec pagination.
3. Pour chaque avis : afficher `status` (badge coloré : 🟡 pending / 🟢 approved / 🔴 rejected).
4. Si `rejected` : permettre `PUT /reviews/{uuid}` pour ré-éditer (repasse en `pending`).
5. `DELETE /reviews/{uuid}` pour supprimer.

---

## 6. Checklist d'intégration mobile

- [ ] Routes publiques accessibles sans token (mais envoyer le token quand l'utilisateur est connecté pour récupérer `userVote`).
- [ ] Conversion `camelCase` côté Flutter (les champs `snake_case` sont disponibles mais préférer le camelCase).
- [ ] Gestion du statut `pending` dans l'UI « Mes avis » (avec un badge clair).
- [ ] `can-review` appelé avant d'afficher le bouton « Laisser un avis ».
- [ ] Pagination implémentée (paramètre `page`, lecture de `meta.last_page`).
- [ ] Optimistic UI sur les votes (avec rollback en cas d'erreur).
- [ ] Handling des push notifications `ReviewApproved` / `ReviewRejected`.
- [ ] i18n des libellés statut, motif rejet, raisons `can-review`.

---

## Annexe — Routes vendor / admin (pour information)

> Ces routes ne sont **pas destinées à l'app mobile** mais sont listées ici pour information.

### Vendor
- `GET /vendor/reviews` — Liste des avis sur les événements de l'organisation.
- `GET /vendor/reviews/stats` — Stats sur les avis du vendor.
- `GET /vendor/reviews/events` — Liste des événements ayant des avis.
- `POST /vendor/review-responses/{reviewUuid}` — Répondre à un avis.
- `PUT /vendor/review-responses/{responseUuid}` — Modifier sa réponse.
- `DELETE /vendor/review-responses/{responseUuid}` — Supprimer sa réponse.

### Admin
- `GET /admin/reviews` — File de modération.
- `GET /admin/reviews/stats` — Compteurs `pending` / `approved` / `rejected`.
- `POST /admin/reviews/{review}/approve` — Approuver un avis.
- `POST /admin/reviews/{review}/reject` — Rejeter (avec `reason`).
- `DELETE /admin/reviews/{review}` — Supprimer.
