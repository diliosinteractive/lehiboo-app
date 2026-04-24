# Messages Mobile - Guide d'integration API

Ce document sert de reference pour construire la section `Messages` de l'application mobile.

Scope retenu pour cette v1 mobile :
- utilisateur authentifie uniquement
- conversations `participant_vendor`
- conversations `user_support`
- pas de dashboard vendor/admin dans le mobile

Si vous ouvrez plus tard des vues mobile pour vendor ou admin, utilisez ce document comme base, mais les endpoints de cette version couvrent d'abord le role `user`.

## Vue d'ensemble

Le mobile peut reproduire ce parcours :

```text
/messages
  -> liste des conversations user <-> organisateur
  -> badge unread count

/messages/new
  -> nouvelle conversation depuis dashboard mobile

/messages/new/from-booking/:bookingUuid
  -> ouvrir ou creer une conversation liee a une reservation

/messages/new/from-organizer/:organizationUuid
  -> contacter un organisateur depuis sa page publique

/messages/:conversationUuid
  -> detail conversation organisateur

/messages/support
  -> liste des conversations support LeHiboo

/messages/support/new
  -> ouvrir une conversation support

/messages/support/:conversationUuid
  -> detail conversation support
```

## Conventions importantes

### Base URL

```text
/api/v1
```

### Auth

Tous les endpoints de ce document exigent :

```http
Authorization: Bearer {token}
Accept: application/json
```

### Format de reponse reel

Le module messaging ne renvoie pas toujours `success: true`.

En pratique :
- les listes paginees renvoient `data + links + meta`
- les creations et updates renvoient souvent `message + data`
- certains endpoints renvoient directement un `MessageResource` ou `ConversationResource`
- les counts renvoient juste `count` ou `count + unreadCount`

### Pieces jointes

Utiliser `multipart/form-data` si vous envoyez des fichiers.

Regles communes :
- max `3` fichiers
- max `5 MB` par fichier
- types acceptes : `jpg`, `jpeg`, `png`, `webp`, `pdf`

### Parametres de route

Pour les conversations et les messages, le backend attend des `uuid` dans l'URL.

Exemples :
- `/user/conversations/{conversationUuid}`
- `/user/conversations/{conversationUuid}/messages/{messageUuid}`

### Etats metier

Conversation types :
- `participant_vendor`
- `user_support`

Statuses :
- `open`
- `closed`

Sender types actuellement exposes par le code :
- `participant`
- `organization`
- `admin`
- `system`

### Semantique de lecture actuelle

Quand un thread est ouvert ou quand l'endpoint `POST /read` est appele, le backend marque les messages recus selon le role :

- `participant` : les messages non-system envoyes par `organization` et `admin`
- `vendor` : les messages non-system envoyes par `participant` et `admin`
- `admin` : les messages non-system envoyes par `organization` et `participant`

Note importante :
- cette regle cote admin a ete elargie pour couvrir aussi les threads `user_support`
- sinon les messages envoyes par `participant` restaient non lus dans l'onglet admin `Users`

## Routes frontend mobile recommandees

| Route mobile | Ecran | API principale |
|---|---|---|
| `/messages` | liste conversations organisateurs | `GET /user/conversations` |
| `/messages/new` | nouveau message depuis app | `GET /user/conversations/contactable-organizations`, `POST /user/conversations` |
| `/messages/new/from-booking/:bookingUuid` | contact depuis une reservation | `POST /user/conversations/from-booking/{bookingUuid}` |
| `/messages/new/from-organizer/:organizationUuid` | contact depuis page publique organisateur | `POST /user/conversations/from-organization/{organizationUuid}` |
| `/messages/:conversationUuid` | detail conversation organisateur | `GET /user/conversations/{uuid}` |
| `/messages/support` | liste support LeHiboo | `GET /user/support-conversations` |
| `/messages/support/new` | nouveau ticket support | `POST /user/support-conversations` |
| `/messages/support/:conversationUuid` | detail support | `GET /user/support-conversations/{uuid}` |

## Objets JSON a connaitre

### Conversation summary/detail

Le backend retourne les champs snake_case et une partie des alias camelCase. Pour le mobile, utilisez snake_case comme format canonique.

```json
{
  "id": 41,
  "uuid": "2c83f27f-d6f7-4300-bfbf-9ee5f48e43fd",
  "subject": "Question sur ma reservation",
  "status": "open",
  "status_label": "Ouvert",
  "conversation_type": "participant_vendor",
  "closed_at": null,
  "last_message_at": "2026-04-23T10:30:00+00:00",
  "unread_count": 2,
  "is_signalement": false,
  "organization": {
    "id": 8,
    "uuid": "6c1dc735-83ff-48e3-a94f-f97f5233fa51",
    "company_name": "Le Hiboo Events",
    "organization_name": "Le Hiboo Events",
    "organization_display_name": "Le Hiboo Events",
    "user_name": "Le Hiboo",
    "user_email": "contact@example.com",
    "logo_url": "https://cdn.example.com/logo.png",
    "avatar_url": "https://cdn.example.com/avatar.png"
  },
  "participant": {
    "id": 17,
    "name": "Jane Doe",
    "email": "jane@example.com",
    "avatar_url": "https://cdn.example.com/users/jane.png"
  },
  "event": {
    "id": 12,
    "uuid": "553300f8-d6de-47f9-876d-1bb08e9d5984",
    "title": "Concert du vendredi",
    "slug": "concert-du-vendredi"
  },
  "latest_message": {
    "id": 90,
    "uuid": "71d17bd7-909c-4dd1-a535-3bdb5fc53d9d",
    "conversation_id": 41,
    "sender_type": "organization",
    "sender_type_label": "Organisateur",
    "is_system": false,
    "sender": {
      "id": 8,
      "name": "Le Hiboo",
      "avatar_url": "https://cdn.example.com/avatar.png"
    },
    "guest_name": null,
    "guest_email": null,
    "content": "Bonjour, voici la confirmation.",
    "is_deleted": false,
    "is_edited": false,
    "is_read": false,
    "is_delivered": true,
    "read_at": null,
    "delivered_at": "2026-04-23T10:31:00+00:00",
    "edited_at": null,
    "is_mine": false,
    "attachments": [],
    "created_at": "2026-04-23T10:30:00+00:00",
    "updated_at": "2026-04-23T10:30:00+00:00"
  },
  "messages": [],
  "created_at": "2026-04-22T12:00:00+00:00",
  "updated_at": "2026-04-23T10:30:00+00:00"
}
```

### Message

```json
{
  "id": 90,
  "uuid": "71d17bd7-909c-4dd1-a535-3bdb5fc53d9d",
  "conversation_id": 41,
  "sender_type": "participant",
  "sender_type_label": "Participant",
  "is_system": false,
  "sender": {
    "id": 17,
    "name": "Jane Doe",
    "avatar_url": "https://cdn.example.com/users/jane.png"
  },
  "guest_name": null,
  "guest_email": null,
  "content": "Bonjour, j'ai une question.",
  "is_deleted": false,
  "is_edited": false,
  "is_read": false,
  "is_delivered": true,
  "read_at": null,
  "delivered_at": "2026-04-23T10:31:00+00:00",
  "edited_at": null,
  "is_mine": true,
  "attachments": [
    {
      "uuid": "0c51dc2b-1315-4277-a95a-fc00f3e4d162",
      "url": "https://cdn.example.com/messages/file.pdf",
      "original_name": "ticket.pdf",
      "mime_type": "application/pdf",
      "size": 301245,
      "is_image": false,
      "is_pdf": true
    }
  ],
  "created_at": "2026-04-23T10:30:00+00:00",
  "updated_at": "2026-04-23T10:30:00+00:00"
}
```

## Endpoints mobile - conversations organisateur

### 1. Lister les conversations

```http
GET /api/v1/user/conversations?status=open&unread_only=true&page=1&per_page=15
```

Query possibles :
- `status`: `open` | `closed`
- `event_id`: integer
- `unread_only`: `true`
- `search`: string
- `period`: `today` | `week` | `month` | `older`
- `page`
- `per_page`

Reponse :

```json
{
  "data": [
    {
      "id": 41,
      "uuid": "2c83f27f-d6f7-4300-bfbf-9ee5f48e43fd",
      "subject": "Question sur ma reservation",
      "status": "open",
      "status_label": "Ouvert",
      "conversation_type": "participant_vendor",
      "last_message_at": "2026-04-23T10:30:00+00:00",
      "unread_count": 2,
      "organization": {
        "uuid": "6c1dc735-83ff-48e3-a94f-f97f5233fa51",
        "company_name": "Le Hiboo Events",
        "organization_name": "Le Hiboo Events",
        "logo_url": "https://cdn.example.com/logo.png",
        "avatar_url": "https://cdn.example.com/avatar.png"
      },
      "event": {
        "id": 12,
        "uuid": "553300f8-d6de-47f9-876d-1bb08e9d5984",
        "title": "Concert du vendredi",
        "slug": "concert-du-vendredi"
      },
      "latest_message": {
        "uuid": "71d17bd7-909c-4dd1-a535-3bdb5fc53d9d",
        "sender_type": "organization",
        "content": "Bonjour, voici la confirmation.",
        "is_read": false,
        "created_at": "2026-04-23T10:30:00+00:00"
      }
    }
  ],
  "links": {
    "first": "http://api.example.test/api/v1/user/conversations?page=1",
    "last": "http://api.example.test/api/v1/user/conversations?page=3",
    "prev": null,
    "next": "http://api.example.test/api/v1/user/conversations?page=2"
  },
  "meta": {
    "current_page": 1,
    "last_page": 3,
    "per_page": 15,
    "total": 33,
    "from": 1,
    "to": 15
  }
}
```

### 2. Compteur non lus

```http
GET /api/v1/user/conversations/unread-count
```

Reponse :

```json
{
  "count": 4,
  "unreadCount": 4
}
```

### 3. Evenements utilisables comme filtre

```http
GET /api/v1/user/conversations/events
```

Reponse :

```json
{
  "data": [
    {
      "id": 12,
      "uuid": "553300f8-d6de-47f9-876d-1bb08e9d5984",
      "title": "Concert du vendredi",
      "slug": "concert-du-vendredi"
    }
  ]
}
```

### 4. Organisateurs contactables

```http
GET /api/v1/user/conversations/contactable-organizations
```

Reponse :

```json
{
  "data": [
    {
      "uuid": "6c1dc735-83ff-48e3-a94f-f97f5233fa51",
      "company_name": "Le Hiboo Events",
      "organization_name": "Le Hiboo Events",
      "logo_url": "https://cdn.example.com/logo.png",
      "avatar_url": "https://cdn.example.com/avatar.png"
    }
  ]
}
```

### 5. Creer une conversation depuis l'app

```http
POST /api/v1/user/conversations
Content-Type: application/json
```

```json
{
  "organization_uuid": "6c1dc735-83ff-48e3-a94f-f97f5233fa51",
  "subject": "Question sur mon billet",
  "message": "Bonjour, puis-je modifier ma venue ?",
  "event_id": 12
}
```

Reponse `201` :

```json
{
  "message": "Conversation creee avec succes.",
  "data": {
    "uuid": "2c83f27f-d6f7-4300-bfbf-9ee5f48e43fd",
    "subject": "Question sur mon billet",
    "status": "open",
    "conversation_type": "participant_vendor",
    "messages": [
      {
        "uuid": "71d17bd7-909c-4dd1-a535-3bdb5fc53d9d",
        "sender_type": "participant",
        "content": "Bonjour, puis-je modifier ma venue ?"
      }
    ]
  }
}
```

### 6. Ouvrir ou creer depuis une reservation

```http
POST /api/v1/user/conversations/from-booking/{bookingUuid}
```

Cas conversation deja existante :

```json
{
  "message": "Conversation existante trouvee.",
  "data": {
    "uuid": "2c83f27f-d6f7-4300-bfbf-9ee5f48e43fd",
    "subject": "Reservation #AB12CD34 - Concert du vendredi",
    "status": "open",
    "conversation_type": "participant_vendor"
  },
  "created": false
}
```

Cas conversation creee :

```json
{
  "message": "Conversation creee avec succes.",
  "data": {
    "uuid": "2c83f27f-d6f7-4300-bfbf-9ee5f48e43fd",
    "subject": "Reservation #AB12CD34 - Concert du vendredi",
    "status": "open",
    "conversation_type": "participant_vendor"
  },
  "created": true
}
```

### 7. Contacter un organisateur depuis sa page publique

```http
POST /api/v1/user/conversations/from-organization/{organizationUuid}
Content-Type: application/json
```

```json
{
  "subject": "Question avant reservation",
  "message": "Bonjour, est-ce adapte aux enfants ?",
  "event_id": "553300f8-d6de-47f9-876d-1bb08e9d5984"
}
```

Notes :
- `event_id` peut etre UUID ou integer string pour cet endpoint
- si `allow_public_contact = false`, le backend renvoie `403`

Reponse `201` :

```json
{
  "message": "Conversation creee avec succes.",
  "data": {
    "uuid": "2c83f27f-d6f7-4300-bfbf-9ee5f48e43fd",
    "subject": "Question avant reservation",
    "status": "open",
    "conversation_type": "participant_vendor"
  }
}
```

### 8. Detail d'une conversation

```http
GET /api/v1/user/conversations/{conversationUuid}
```

Effet de bord important :
- ouvre le thread
- marque comme lus les messages recus
- declenche l'evenement realtime de lecture

Reponse :

```json
{
  "data": {
    "uuid": "2c83f27f-d6f7-4300-bfbf-9ee5f48e43fd",
    "subject": "Question sur ma reservation",
    "status": "open",
    "conversation_type": "participant_vendor",
    "messages": [
      {
        "uuid": "aaa11111-1111-1111-1111-111111111111",
        "sender_type": "participant",
        "content": "Bonjour, j'ai une question.",
        "is_mine": true,
        "is_read": true,
        "attachments": []
      },
      {
        "uuid": "bbb22222-2222-2222-2222-222222222222",
        "sender_type": "organization",
        "content": "Bonjour, nous vous repondons.",
        "is_mine": false,
        "is_read": true,
        "attachments": []
      }
    ]
  }
}
```

### 9. Envoyer un message

```http
POST /api/v1/user/conversations/{conversationUuid}/messages
Content-Type: application/json
```

```json
{
  "content": "Merci pour votre retour."
}
```

Ou en `multipart/form-data` avec `attachments[]`.

Reponse :

```json
{
  "id": 90,
  "uuid": "71d17bd7-909c-4dd1-a535-3bdb5fc53d9d",
  "conversation_id": 41,
  "sender_type": "participant",
  "sender_type_label": "Participant",
  "content": "Merci pour votre retour.",
  "is_deleted": false,
  "is_edited": false,
  "is_read": false,
  "is_delivered": false,
  "is_mine": true,
  "attachments": [],
  "created_at": "2026-04-23T10:35:00+00:00",
  "updated_at": "2026-04-23T10:35:00+00:00"
}
```

Important :
- `content` peut etre omis si vous envoyez au moins un fichier
- si la conversation est `closed`, reponse `422`

### 10. Editer un message

```http
PATCH /api/v1/user/conversations/{conversationUuid}/messages/{messageUuid}
Content-Type: application/json
```

```json
{
  "content": "Merci pour votre retour rapide."
}
```

Reponse :

```json
{
  "message": "Message modifie avec succes.",
  "data": {
    "uuid": "71d17bd7-909c-4dd1-a535-3bdb5fc53d9d",
    "sender_type": "participant",
    "content": "Merci pour votre retour rapide.",
    "is_edited": true,
    "edited_at": "2026-04-23T10:40:00+00:00"
  }
}
```

### 11. Supprimer un message

```http
DELETE /api/v1/user/conversations/{conversationUuid}/messages/{messageUuid}
```

Reponse :

```json
{
  "message": "Message supprime avec succes."
}
```

Apres suppression, le backend garde le message en soft delete et le detail conversation retournera :
- `content: null`
- `is_deleted: true`

### 12. Fermer une conversation

```http
POST /api/v1/user/conversations/{conversationUuid}/close
```

Reponse :

```json
{
  "message": "Conversation close avec succes.",
  "data": {
    "uuid": "2c83f27f-d6f7-4300-bfbf-9ee5f48e43fd",
    "status": "closed",
    "closed_at": "2026-04-23T11:00:00+00:00"
  }
}
```

## Endpoints mobile - support LeHiboo

### 13. Lister les conversations support

```http
GET /api/v1/user/support-conversations?page=1&per_page=15
```

Reponse :

```json
{
  "data": [
    {
      "uuid": "0a2f52f0-ae65-4547-ae75-0d8172b8b3f7",
      "subject": "Probleme de paiement",
      "status": "open",
      "conversation_type": "user_support",
      "unread_count": 1,
      "is_signalement": false,
      "latest_message": {
        "uuid": "9b4acfd0-ef51-4948-9298-f3c68c06229c",
        "sender_type": "admin",
        "content": "Nous examinons votre demande."
      }
    }
  ],
  "meta": {
    "current_page": 1,
    "last_page": 1,
    "per_page": 15,
    "total": 1
  }
}
```

### 14. Creer une conversation support

```http
POST /api/v1/user/support-conversations
Content-Type: application/json
```

```json
{
  "subject": "Probleme de paiement",
  "message": "Mon paiement est reste en attente."
}
```

Reponse `201` :

```json
{
  "message": "Conversation support creee avec succes.",
  "data": {
    "uuid": "0a2f52f0-ae65-4547-ae75-0d8172b8b3f7",
    "subject": "Probleme de paiement",
    "status": "open",
    "conversation_type": "user_support"
  }
}
```

### 15. Detail d'une conversation support

```http
GET /api/v1/user/support-conversations/{conversationUuid}
```

Effet de bord :
- marque les messages recus comme lus

Reponse :

```json
{
  "data": {
    "uuid": "0a2f52f0-ae65-4547-ae75-0d8172b8b3f7",
    "subject": "Probleme de paiement",
    "status": "open",
    "conversation_type": "user_support",
    "is_signalement": false,
    "messages": [
      {
        "uuid": "9b4acfd0-ef51-4948-9298-f3c68c06229c",
        "sender_type": "admin",
        "content": "Nous examinons votre demande.",
        "is_mine": false
      }
    ]
  }
}
```

### 16. Envoyer un message dans support

```http
POST /api/v1/user/support-conversations/{conversationUuid}/messages
```

```json
{
  "content": "Merci, je joins une capture."
}
```

Reponse :

```json
{
  "id": 112,
  "uuid": "91e8ee69-3cc2-4f94-a44a-32985a4a4540",
  "conversation_id": 51,
  "sender_type": "participant",
  "sender_type_label": "Participant",
  "content": "Merci, je joins une capture.",
  "is_deleted": false,
  "is_edited": false,
  "is_read": false,
  "is_delivered": false,
  "is_mine": true,
  "attachments": [],
  "created_at": "2026-04-23T11:15:00+00:00",
  "updated_at": "2026-04-23T11:15:00+00:00"
}
```

## Endpoint mobile - signalement

### 17. Signaler une conversation

Le signalement cree un thread support de suivi.

```http
POST /api/v1/user/conversations/{conversationUuid}/report
Content-Type: application/json
```

```json
{
  "reason": "spam",
  "comment": "Cet organisateur m'envoie des messages non souhaites."
}
```

Valeurs autorisees pour `reason` :
- `inappropriate`
- `harassment`
- `spam`
- `other`

Reponse `201` :

```json
{
  "message": "Votre signalement a bien ete transmis a l'equipe LeHiboo.",
  "data": {
    "uuid": "3f4f601c-0f3c-4d84-a91a-fae96415d731",
    "support_conversation_uuid": "0a2f52f0-ae65-4547-ae75-0d8172b8b3f7"
  }
}
```

## Erreurs courantes

### 401 non authentifie

```json
{
  "message": "Unauthenticated.",
  "error": "unauthenticated"
}
```

### 403 relation non autorisee

Exemple quand l'utilisateur essaie de contacter un organisateur sans relation :

```json
{
  "message": "Vous ne pouvez contacter que les organisateurs avec lesquels vous avez une relation."
}
```

### 403 contact public desactive

```json
{
  "message": "Cet organisateur n'accepte pas les messages depuis sa page publique."
}
```

### 404 ressource introuvable

```json
{
  "message": "Reservation non trouvee."
}
```

### 422 validation

```json
{
  "message": "The given data was invalid.",
  "errors": {
    "subject": [
      "The subject field is required."
    ]
  }
}
```

### 422 conversation deja fermee

```json
{
  "message": "Cette conversation est close. Vous ne pouvez plus y repondre."
}
```

### 422 signalement en double

```json
{
  "message": "Vous avez deja signale cette conversation."
}
```

## Recommandations implementation mobile

### Liste messages

- afficher `unread_count`
- afficher `latest_message.content`
- afficher le nom de `organization.company_name` pour `participant_vendor`
- afficher un badge `Signalement` si `is_signalement = true`

### Detail conversation

- trier selon `messages` recu du backend, deja ordonnes par `id asc`
- afficher les pieces jointes avant le texte si vous voulez coller au web
- afficher l'etat du message sortant avec `is_delivered`, `is_read`, `read_at`
- si `is_deleted = true`, rendre un placeholder "Message supprime"

### Creation / reply

- passer en `multipart/form-data` des qu'il y a au moins un fichier
- permettre envoi sans texte si au moins un fichier est joint
- bloquer le composer si `status = closed`

### Synchronisation

- ouvrir le detail suffit pour marquer lu
- la logique de "mark as read" depend du role du viewer, pas seulement du type de conversation
- apres `send`, `edit`, `delete`, `close`, invalider detail + liste + unread count
- si vous ajoutez le realtime plus tard, les events utiles sont `message.received`, `message.delivered`, `conversation.read`

## Hors scope de cette v1 mobile

Ces endpoints existent cote web/dashboard mais ne sont pas prioritaires pour l'app mobile user :
- `/api/v1/vendor/conversations`
- `/api/v1/vendor/org-conversations`
- `/api/v1/admin/conversations`
- `/api/v1/admin/conversation-reports`

Si besoin, une v2 de ce document pourra couvrir vendor et admin avec leurs propres routes mobiles.
