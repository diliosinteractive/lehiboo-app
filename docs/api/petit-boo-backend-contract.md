# Contrat API Petit Boo - Documentation Backend

> **Audience** : Équipe backend refondant Petit Boo avec LangChain
> **Version** : 1.0
> **Dernière mise à jour** : Janvier 2025

---

## 1. Vue d'ensemble

### Architecture

```
┌─────────────┐         ┌─────────────────────┐
│   Mobile    │   SSE   │   Backend LangChain │
│   Flutter   │ ◄────── │   Petit Boo API     │
│             │ ──────► │                     │
└─────────────┘  REST   └─────────────────────┘
```

**Principe fondamental** : Le mobile est un **client passif**. Toute l'intelligence IA (prompts, outils MCP, mémoire, contexte) est gérée côté backend.

Le mobile :
- Envoie les messages utilisateur via SSE
- Affiche les tokens reçus en streaming
- Rend les résultats d'outils de manière riche (cartes événements, billets, etc.)
- Gère l'historique des conversations via les endpoints REST

---

## 2. Configuration

### URLs

| Environnement | URL Base |
|---------------|----------|
| Développement | `http://petitboo.lehiboo.localhost` |
| Production | `https://petitboo.lehiboo.com` |

### Authentification

Toutes les requêtes (sauf `/health/ready`) requièrent un **JWT Bearer token** :

```http
Authorization: Bearer <jwt_token>
```

Le token JWT est le même que celui utilisé pour l'API principale Le Hiboo.

---

## 3. Endpoints REST

### 3.1 Health Check

```http
GET /health/ready
```

**Réponse** : `200 OK` si le service est disponible.

**Usage** : Vérifier la disponibilité avant d'ouvrir le chat.

---

### 3.2 Quota utilisateur

```http
GET /api/v1/quota
```

**Réponse** :
```json
{
  "success": true,
  "data": {
    "used": 5,
    "limit": 10,
    "remaining": 5,
    "resets_at": "2025-01-26T00:00:00Z",
    "period": "daily"
  }
}
```

| Champ | Type | Description |
|-------|------|-------------|
| `used` | int | Messages utilisés dans la période |
| `limit` | int | Limite maximale |
| `remaining` | int | Messages restants |
| `resets_at` | string (ISO 8601) | Date de réinitialisation |
| `period` | string | Type de période : `daily`, `weekly`, `monthly` |

---

### 3.3 Liste des conversations

```http
GET /api/v1/sessions
```

**Query Parameters** :
| Param | Type | Default | Description |
|-------|------|---------|-------------|
| `page` | int | 1 | Page courante |
| `per_page` | int | 20 | Éléments par page |

**Réponse** :
```json
{
  "success": true,
  "data": [
    {
      "uuid": "550e8400-e29b-41d4-a716-446655440000",
      "title": "Recherche concert Paris",
      "created_at": "2025-01-20T14:30:00Z",
      "updated_at": "2025-01-20T15:00:00Z",
      "message_count": 8,
      "last_message": "Voici les concerts disponibles..."
    }
  ],
  "meta": {
    "total": 42,
    "page": 1,
    "per_page": 20,
    "last_page": 3
  }
}
```

---

### 3.4 Détail d'une conversation

```http
GET /api/v1/sessions/{uuid}
```

**Réponse** :
```json
{
  "success": true,
  "data": {
    "uuid": "550e8400-e29b-41d4-a716-446655440000",
    "title": "Recherche concert Paris",
    "created_at": "2025-01-20T14:30:00Z",
    "updated_at": "2025-01-20T15:00:00Z",
    "message_count": 8,
    "last_message": "Voici les concerts disponibles...",
    "messages": [
      {
        "id": "msg_001",
        "role": "user",
        "content": "Je cherche un concert ce weekend",
        "created_at": "2025-01-20T14:30:00Z"
      },
      {
        "id": "msg_002",
        "role": "assistant",
        "content": "Voici les concerts disponibles ce weekend à Paris !",
        "tool_results": [
          {
            "tool": "searchEvents",
            "data": { ... },
            "executed_at": "2025-01-20T14:30:05Z"
          }
        ],
        "created_at": "2025-01-20T14:30:10Z"
      }
    ]
  }
}
```

**Structure d'un message** :
| Champ | Type | Description |
|-------|------|-------------|
| `id` | string | Identifiant unique du message |
| `role` | string | `user`, `assistant`, ou `system` |
| `content` | string | Contenu textuel du message |
| `tool_results` | array? | Résultats d'outils (assistant uniquement) |
| `created_at` | string | Date de création ISO 8601 |

---

### 3.5 Créer une conversation

```http
POST /api/v1/sessions
```

**Body** :
```json
{
  "title": "Ma nouvelle conversation"
}
```

| Champ | Type | Requis | Description |
|-------|------|--------|-------------|
| `title` | string | Non | Titre optionnel |

**Réponse** : Même structure que le détail d'une conversation.

---

### 3.6 Supprimer une conversation

```http
DELETE /api/v1/sessions/{uuid}
```

**Réponse** : `204 No Content` en cas de succès.

---

## 4. Chat SSE Streaming

### Endpoint

```http
POST /api/v1/chat
```

### Headers requis

```http
Authorization: Bearer <jwt_token>
Content-Type: application/json
Accept: text/event-stream
Cache-Control: no-cache
```

### Body

```json
{
  "session_uuid": "550e8400-e29b-41d4-a716-446655440000",
  "message": "Je cherche un concert ce weekend à Paris"
}
```

| Champ | Type | Requis | Description |
|-------|------|--------|-------------|
| `session_uuid` | string | Non | UUID de session existante (nouvelle session si absent) |
| `message` | string | Oui | Message de l'utilisateur |

---

### Format des événements SSE

Chaque ligne suit le format standard SSE :
```
data: {"type": "...", ...}
```

Le mobile parse chaque ligne commençant par `data: ` et extrait le JSON.

---

### Types d'événements

#### 4.1 `session` - Nouvelle session créée

Envoyé au début si `session_uuid` n'était pas fourni.

```json
{
  "type": "session",
  "session_uuid": "550e8400-e29b-41d4-a716-446655440000"
}
```

Le mobile **doit** stocker cet UUID pour les messages suivants de la conversation.

---

#### 4.2 `token` - Token de texte (streaming)

Envoyé pour chaque fragment de la réponse de l'assistant.

```json
{
  "type": "token",
  "content": "Voici "
}
```

```json
{
  "type": "token",
  "content": "les concerts "
}
```

Le mobile concatène les tokens pour afficher la réponse en temps réel.

---

#### 4.3 `tool_call` - Outil en cours d'appel

Envoyé quand l'IA décide d'appeler un outil MCP.

```json
{
  "type": "tool_call",
  "tool": "searchEvents",
  "arguments": {
    "query": "concert",
    "city": "Paris",
    "date_start": "2025-01-25",
    "date_end": "2025-01-26"
  }
}
```

Le mobile affiche un indicateur de chargement avec le nom de l'outil (ex: "Recherche d'événements...").

---

#### 4.4 `tool_result` - Résultat d'un outil

Envoyé après l'exécution de l'outil avec les données structurées.

```json
{
  "type": "tool_result",
  "tool": "searchEvents",
  "result": {
    "events": [...],
    "total": 5,
    "filters_applied": {...}
  }
}
```

Le mobile rend ces données avec des widgets riches (cartes événements, listes de billets, etc.).

---

#### 4.5 `error` - Erreur

```json
{
  "type": "error",
  "error": "Rate limit exceeded",
  "code": "rate_limit"
}
```

| Code | Description |
|------|-------------|
| `auth_required` | Token manquant ou invalide |
| `rate_limit` | Quota dépassé |
| `timeout` | Timeout de connexion |
| `network` | Erreur réseau |
| `unknown` | Erreur inconnue |

---

#### 4.6 `done` - Fin du stream

```json
{
  "type": "done"
}
```

Le mobile ferme la connexion SSE et finalise l'affichage.

---

## 5. Outils MCP (Tools)

Le backend expose 8 outils que l'IA peut appeler. Le mobile attend des structures de résultats précises pour chaque outil.

### 5.1 `searchEvents` - Recherche d'événements

**Résultat attendu** :
```json
{
  "events": [
    {
      "uuid": "evt-uuid-001",
      "slug": "concert-rock-paris",
      "title": "Concert Rock Paris",
      "description": "Un super concert...",
      "image_url": "https://...",
      "venue_name": "Le Zenith",
      "city_name": "Paris",
      "next_slot_date": "2025-01-25",
      "next_slot_time": "20:00",
      "price_display": "25€ - 50€",
      "is_free": false,
      "is_favorite": true
    }
  ],
  "total": 15,
  "filters_applied": {
    "city": "Paris",
    "date_start": "2025-01-25"
  }
}
```

---

### 5.2 `getEventDetails` - Détails d'un événement

**Résultat attendu** :
```json
{
  "uuid": "evt-uuid-001",
  "slug": "concert-rock-paris",
  "title": "Concert Rock Paris",
  "description": "Description complète...",
  "image_url": "https://...",
  "venue": {
    "name": "Le Zenith",
    "address": "211 Avenue Jean Jaurès",
    "city": "Paris",
    "latitude": 48.8939,
    "longitude": 2.3931
  },
  "next_slot": {
    "uuid": "slot-uuid-001",
    "slot_date": "2025-01-25",
    "start_time": "20:00",
    "end_time": "23:00",
    "available_capacity": 150
  },
  "ticket_types": [
    {
      "uuid": "tt-uuid-001",
      "name": "Place debout",
      "price": 25.00,
      "description": "Accès fosse",
      "available_quantity": 50
    },
    {
      "uuid": "tt-uuid-002",
      "name": "Place assise",
      "price": 50.00,
      "description": "Tribune haute",
      "available_quantity": 100
    }
  ],
  "is_favorite": false,
  "can_book": true,
  "category": "Concert",
  "tags": ["rock", "musique", "live"]
}
```

---

### 5.3 `getMyBookings` - Réservations utilisateur

**Résultat attendu** :
```json
{
  "bookings": [
    {
      "uuid": "booking-uuid-001",
      "reference": "HB-2025-001234",
      "status": "confirmed",
      "event_title": "Concert Rock Paris",
      "event_slug": "concert-rock-paris",
      "event_image": "https://...",
      "slot_date": "2025-01-25",
      "slot_time": "20:00",
      "tickets_count": 2,
      "total_price": 50.00,
      "currency": "EUR"
    }
  ],
  "total": 5,
  "pending_count": 1,
  "upcoming_count": 3
}
```

**Statuts de réservation** : `pending`, `confirmed`, `cancelled`, `completed`

---

### 5.4 `getMyTickets` - Billets utilisateur

**Résultat attendu** :
```json
{
  "tickets": [
    {
      "uuid": "ticket-uuid-001",
      "qr_code": "data:image/png;base64,...",
      "status": "active",
      "event_title": "Concert Rock Paris",
      "event_slug": "concert-rock-paris",
      "ticket_type": "Place debout",
      "slot_date": "2025-01-25",
      "slot_time": "20:00",
      "attendee_name": "Jean Dupont"
    }
  ],
  "total": 2,
  "active_count": 2
}
```

**Statuts de billet** : `active`, `used`, `cancelled`, `expired`

---

### 5.5 `getMyFavorites` - Favoris utilisateur

**Résultat attendu** :
```json
{
  "favorites": [
    {
      "uuid": "evt-uuid-001",
      "slug": "concert-rock-paris",
      "title": "Concert Rock Paris",
      "image_url": "https://...",
      "venue_name": "Le Zenith",
      "city_name": "Paris",
      "next_slot_date": "2025-01-25",
      "price_display": "25€ - 50€",
      "is_free": false,
      "is_favorite": true
    }
  ],
  "total": 12,
  "lists": [
    {
      "uuid": "list-uuid-001",
      "name": "Concerts 2025",
      "events_count": 5
    }
  ]
}
```

---

### 5.6 `getMyAlerts` - Alertes/Recherches sauvegardées

**Résultat attendu** :
```json
{
  "alerts": [
    {
      "uuid": "alert-uuid-001",
      "name": "Concerts Rock Paris",
      "is_active": true,
      "last_triggered_at": "2025-01-20T10:00:00Z",
      "new_events_count": 3,
      "search_criteria_summary": "Rock, Paris, ce weekend"
    }
  ],
  "total": 4,
  "active_count": 3
}
```

---

### 5.7 `getMyProfile` - Profil utilisateur

**Résultat attendu** :
```json
{
  "user": {
    "uuid": "user-uuid-001",
    "first_name": "Jean",
    "last_name": "Dupont",
    "email": "jean@example.com",
    "avatar_url": "https://...",
    "phone_number": "+33612345678",
    "created_at": "2024-06-15T10:00:00Z"
  },
  "stats": {
    "total_bookings": 15,
    "total_events_attended": 12,
    "total_favorites": 25,
    "total_alerts": 4
  },
  "hiboos_balance": 150
}
```

---

### 5.8 `getNotifications` - Notifications utilisateur

**Résultat attendu** :
```json
{
  "notifications": [
    {
      "id": "notif-001",
      "type": "booking_confirmed",
      "title": "Réservation confirmée",
      "body": "Votre réservation pour Concert Rock Paris est confirmée",
      "is_read": false,
      "created_at": "2025-01-20T14:00:00Z",
      "data": {
        "booking_uuid": "booking-uuid-001"
      }
    }
  ],
  "total": 20,
  "unread_count": 3
}
```

**Types de notifications** : `booking_confirmed`, `booking_cancelled`, `event_reminder`, `alert_triggered`, `promo`, `system`

---

## 6. Codes d'erreur HTTP

| Code | Signification |
|------|---------------|
| 200 | Succès |
| 204 | Succès sans contenu (DELETE) |
| 400 | Requête invalide |
| 401 | Non authentifié / Token expiré |
| 403 | Accès refusé |
| 404 | Ressource non trouvée |
| 429 | Rate limit dépassé |
| 500 | Erreur serveur |

---

## 7. Format de réponse standard

Toutes les réponses REST suivent ce format :

**Succès** :
```json
{
  "success": true,
  "data": { ... }
}
```

**Erreur** :
```json
{
  "success": false,
  "message": "Description de l'erreur",
  "error": {
    "code": "error_code",
    "message": "Message détaillé"
  }
}
```

---

## 8. Notes d'implémentation

### Timeouts

| Type | Valeur |
|------|--------|
| Connection timeout REST | 30 secondes |
| Receive timeout REST | 30 secondes |
| Stream timeout SSE | 5 minutes |

### Génération de titre automatique

Le backend devrait générer automatiquement un `title` pour la conversation basé sur le premier message utilisateur (ex: résumé en 5-6 mots).

### Gestion de session

- Si `session_uuid` est fourni dans `/api/v1/chat`, les messages sont ajoutés à la session existante
- Si absent, une nouvelle session est créée et son UUID est envoyé via l'événement `session`
- Le mobile stocke localement le `session_uuid` pour permettre la reprise de conversation

### Ordre des événements SSE

Un flux typique :
1. `session` (si nouvelle session)
2. `tool_call` (si l'IA appelle un outil)
3. `tool_result` (résultat de l'outil)
4. `token` (plusieurs, streaming de la réponse)
5. `done` (fin)

Les événements `tool_call` → `tool_result` peuvent se répéter plusieurs fois si l'IA appelle plusieurs outils.
