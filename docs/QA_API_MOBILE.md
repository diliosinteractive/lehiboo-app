# Spec API Q&A — Intégration Mobile

Ce document décrit les endpoints REST à utiliser pour intégrer le système de Questions & Réponses dans l'app mobile Flutter. Il couvre uniquement les **routes publiques** et les **routes utilisateur authentifié** (pas les routes vendor/admin).

**Base URL** : `https://api.lehiboo.com/api/v1` (prod) · `http://api.lehiboo.localhost/api/v1` (dev)

**Auth** : header `Authorization: Bearer <token>` pour toutes les routes authentifiées.

---

## 1. Routes publiques (sans auth)

### 1.1 Lister les Q&A d'un événement

```http
GET /events/{slug}/questions
```

**Query params** :

| Param | Type | Défaut | Description |
|-------|------|--------|-------------|
| `answered_only` | bool | `false` | Ne retourner que les questions répondues |
| `unanswered_only` | bool | `false` | Ne retourner que les non répondues |
| `sort_by` | string | `created_at` | `created_at` ou `helpful` |
| `sort_order` | string | `desc` | `asc` ou `desc` |
| `per_page` | int | `10` | Nb par page |
| `page` | int | `1` | Page |

Les questions épinglées remontent toujours en premier.

**Response 200** :
```json
{
  "data": [
    {
      "uuid": "b1f3...-...",
      "question": "À quelle heure ouvrent les portes ?",
      "status": "approved",
      "isAnswered": true,
      "isPinned": false,
      "helpfulCount": 12,
      "author": {
        "name": "Jean D.",
        "avatar": "https://...",
        "initials": "JD",
        "isGuest": false
      },
      "answer": {
        "uuid": "c2e4...-...",
        "answer": "Les portes ouvrent à 19h.",
        "isOfficial": true,
        "organization": { "name": "Acme Events", "logo": "https://..." },
        "author": { "name": "Acme Events", "avatar": null },
        "createdAt": "2026-04-20T14:32:10+00:00",
        "createdAtFormatted": "il y a 1 jour"
      },
      "hasAnswer": true,
      "userVoted": false,
      "createdAt": "2026-04-19T10:12:00+00:00",
      "createdAtFormatted": "il y a 2 jours"
    }
  ],
  "links": { "first": "...", "last": "...", "prev": null, "next": "..." },
  "meta": { "current_page": 1, "per_page": 10, "total": 23, "last_page": 3 }
}
```

> **Note** : `userVoted` n'est renvoyé que si l'appel est authentifié (token envoyé même sur route publique).

---

## 2. Routes utilisateur authentifié

Préfixe : `/api/v1` — toutes nécessitent `Authorization: Bearer <token>`.

### 2.1 Soumettre une question

```http
POST /events/{slug}/questions
```

**Body** :
```json
{ "question": "Les animaux sont-ils acceptés ?" }
```

**Validation** : `question` required, string, **10 à 1000 caractères**.

**Règles** : 1 seule question par user par événement. La question est créée en `status: pending` (visible uniquement par l'auteur jusqu'à modération).

**Response 201** :
```json
{
  "message": "Question submitted successfully. It will be visible after moderation.",
  "question": { /* EventQuestionResource */ }
}
```

**Erreurs** :
- `422` — déjà soumis : `{ "message": "You have already submitted a question for this event." }`
- `422` — validation : `{ "message": "...", "errors": { "question": ["..."] } }`

---

### 2.2 Récupérer sa propre question sur un événement

```http
GET /events/{slug}/my-question
```

Permet d'afficher sa propre question même si elle est en `pending`.

**Response 200 (avec question)** :
```json
{ "data": { /* EventQuestionResource */ } }
```

**Response 200 (aucune question)** :
```json
{ "data": null }
```

---

### 2.3 Marquer une question comme utile

```http
POST /questions/{uuid}/helpful
```

**Règles** : 1 vote par user par question. Seules les questions visibles (approved/answered) sont votables.

**Response 200** :
```json
{ "message": "Marked as helpful.", "helpful_count": 13 }
```

**Erreurs** :
- `422` — déjà voté : `{ "message": "You have already marked this question as helpful." }`

---

### 2.4 Retirer son vote "utile"

```http
DELETE /questions/{uuid}/helpful
```

**Response 200** :
```json
{ "message": "Vote removed.", "helpful_count": 12 }
```

**Erreurs** :
- `422` — aucun vote à retirer : `{ "message": "No vote to remove." }`

---

### 2.5 Lister ses propres questions (profil utilisateur)

```http
GET /me/questions
```

**Query** : `per_page` (défaut `10`), `page`.

**Response 200** : collection paginée `EventQuestionResource` (triée par date desc). Chaque item inclut l'objet `event` (`uuid`, `title`, `slug`, `isDeleted`) pour permettre la navigation.

---

### 2.6 Compteur de questions en attente de réponse

```http
GET /me/questions/pending-count
```

Retourne le nombre de questions de l'utilisateur dont le statut est `pending` ou `approved` (pas encore `answered`).

**Response 200** :
```json
{ "count": 3 }
```

Utile pour afficher un badge de notification sur le profil.

---

## 3. Schéma `EventQuestion` (réponse type)

| Champ | Type | Description |
|-------|------|-------------|
| `uuid` | string | Identifiant public |
| `question` | string | Texte de la question |
| `status` | enum | `pending` · `approved` · `answered` · `rejected` |
| `isAnswered` | bool | Raccourci `status === answered` |
| `isPinned` | bool | Épinglée par l'organisateur |
| `isPublic` | bool | Visible publiquement |
| `helpfulCount` | int | Nb de votes "utile" |
| `author` | object | `{ name, avatar, initials, isGuest }` |
| `answer` | object\|null | Voir ci-dessous |
| `hasAnswer` | bool | `true` si une réponse existe |
| `userVoted` | bool | Présent uniquement si authentifié |
| `createdAt` / `updatedAt` | ISO 8601 | |
| `createdAtFormatted` | string | "il y a 2 jours" (localisé) |
| `event` | object | Présent dans `/me/questions` : `{ uuid, title, slug, isDeleted }` |

**`answer`** :

| Champ | Type |
|-------|------|
| `uuid` | string |
| `answer` | string |
| `isOfficial` | bool |
| `organization` | `{ id, name, logo }` |
| `author` | `{ name, avatar }` |
| `createdAt`, `createdAtFormatted` | string |

---

## 4. Statuts & workflow

```
PENDING  ──(organisateur approve)──▶  APPROVED  ──(organisateur répond)──▶  ANSWERED
   │
   └──(organisateur reject)──▶  REJECTED  (invisible publiquement)
```

- **pending** : visible uniquement par l'auteur (via `my-question`).
- **approved / answered** : visible publiquement.
- **rejected** : jamais renvoyée par les endpoints publics.

---

## 5. Contraintes d'implémentation (mobile)

Ces contraintes **doivent être respectées** côté app mobile. Les endpoints correspondants existent côté API mais ne sont pas à utiliser dans cette version.

### 5.1 Pas d'édition ni de suppression de question

- ❌ **Ne pas implémenter** la modification d'une question (`PUT /questions/{uuid}`).
- ❌ **Ne pas implémenter** la suppression d'une question (`DELETE /questions/{uuid}`).
- Une question soumise est **définitive** du point de vue de l'utilisateur mobile.

### 5.2 Une seule question par utilisateur par événement

- Un utilisateur ne peut poser **qu'une seule question** par événement.
- **Avant d'afficher le bouton "Poser une question"**, appeler `GET /events/{slug}/my-question` :
  - Si `data === null` → afficher le bouton / formulaire de soumission.
  - Si `data !== null` → **masquer** le bouton et afficher la question existante (et sa réponse si disponible) à la place.
- Après un `POST /events/{slug}/questions` réussi (`201`), le bouton doit disparaître **immédiatement** (mise à jour de l'état local).
- Le serveur renverra `422` en cas de seconde tentative — cela ne doit jamais arriver si l'UI respecte la contrainte ci-dessus.

### 5.3 Bouton "Like" = toggle avec compteur visible

- Le "like" (vote utile) est un **toggle** : un utilisateur ne peut liker qu'**une seule fois** une question donnée.
- Déterminer l'état initial avec le champ `userVoted` (nécessite que l'appel `GET /events/{slug}/questions` soit fait avec le token Bearer).
- Au tap sur le bouton :
  - Si `userVoted === false` → `POST /questions/{uuid}/helpful` puis passer `userVoted = true` et incrémenter `helpfulCount`.
  - Si `userVoted === true` → `DELETE /questions/{uuid}/helpful` puis passer `userVoted = false` et décrémenter `helpfulCount`.
- **Afficher le nombre total de likes** (`helpfulCount`) à côté du bouton like, en temps réel (UI optimiste recommandée).
- En cas d'erreur `422` (désync avec le serveur), rollback l'état local et utiliser le `helpful_count` renvoyé par la réponse.

**Exemple d'UI** :

```
┌─────────────────────────────┐
│  👍 Utile  ·  12            │   ← état non liké (contour)
└─────────────────────────────┘

┌─────────────────────────────┐
│  ❤️ Utile  ·  13            │   ← état liké (plein / couleur)
└─────────────────────────────┘
```

---

## 6. Bonnes pratiques mobile

1. **Avant d'afficher le bouton "Poser une question"** : appeler `GET /events/{slug}/my-question` — si `data !== null`, masquer le bouton et afficher la question existante (lecture seule) à la place (voir section 5.2).
2. **Vote "utile" (toggle)** : UI optimiste — mettre à jour `helpfulCount` et `userVoted` localement, rollback en cas d'erreur `422`. Toujours afficher le compteur de likes à côté du bouton (voir section 5.3).
3. **Pagination infinie** : utiliser `meta.last_page` ou `links.next` pour la détection de fin.
4. **Badge profil** : rafraîchir `GET /me/questions/pending-count` au retour sur l'écran profil (pas de push pour l'instant).
5. **i18n** : les `message` renvoyés sont en anglais — prévoir un mapping côté mobile vers les 6 langues supportées.
6. **Erreurs** : gérer `401` (token expiré → relogin) et `422` (validation/règles métier — afficher `errors` ou `message`).

---

## 7. Récapitulatif des endpoints (mobile)

| # | Méthode | Endpoint | Auth | Usage mobile |
|---|---------|----------|------|--------------|
| 1.1 | `GET` | `/events/{slug}/questions` | Optionnelle | Liste publique Q&A |
| 2.1 | `POST` | `/events/{slug}/questions` | ✅ | Soumettre (1x max) |
| 2.2 | `GET` | `/events/{slug}/my-question` | ✅ | Vérifier si déjà posée |
| 2.3 | `POST` | `/questions/{uuid}/helpful` | ✅ | Toggle like (ON) |
| 2.4 | `DELETE` | `/questions/{uuid}/helpful` | ✅ | Toggle like (OFF) |
| 2.5 | `GET` | `/me/questions` | ✅ | Liste profil utilisateur |
| 2.6 | `GET` | `/me/questions/pending-count` | ✅ | Badge profil |

> Les endpoints `PUT /questions/{uuid}` et `DELETE /questions/{uuid}` (édition/suppression) **ne sont pas à implémenter** dans cette version — voir section 5.1.
