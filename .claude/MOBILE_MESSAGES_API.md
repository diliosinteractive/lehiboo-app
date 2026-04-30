# Messages Mobile — Guide d'intégration API

Ce document est la référence contractuelle pour la section `Messages` de l'application mobile Flutter.
Pour l'architecture écrans, les patterns UX et les DTOs Dart, voir `MOBILE_MESSAGES_IMPLEMENTATION.md`.

---

## Scope retenu (participant uniquement)

| Type de conversation      | Inclus | Endpoint prefix                   |
|---------------------------|--------|-----------------------------------|
| `participant_vendor`      | Oui    | `/api/v1/user/conversations`      |
| `user_support`            | Oui    | `/api/v1/user/support-conversations` |
| `vendor_admin`            | Non    | (v2, rôle vendor)                 |
| `organization_organization` | Non  | (v2, rôle vendor)                 |

---

## Conventions générales

### Base URL

```
/api/v1
```

### Auth

Tous les endpoints de ce document exigent :

```http
Authorization: Bearer {token}
Accept: application/json
```

### Format de réponse

| Type                | Structure                                         |
|---------------------|---------------------------------------------------|
| Liste paginée       | `{ data: [...], links: {...}, meta: {...} }`      |
| Création / update   | `{ message: "...", data: {...} }`                 |
| Objet unique (show) | `{ data: {...} }`                                 |
| Compteurs           | `{ count: N, unreadCount: N }`                    |
| Signalement (création) | `{ message: "...", data: { uuid, support_conversation_uuid } }` |

### Pièces jointes — règles communes

- `multipart/form-data` dès qu'il y a au moins un fichier
- Max `3` fichiers par message
- Max `5 MB` par fichier
- Types acceptés : `jpg`, `jpeg`, `png`, `webp`, `pdf`
- `content` peut être omis si au moins un fichier est joint

### Identifiants

Toujours utiliser des **uuid** dans les URLs :
- `/user/conversations/{conversationUuid}`
- `/user/conversations/{conversationUuid}/messages/{messageUuid}`

---

## Objets JSON canoniques

### Conversation (résumé — liste)

```json
{
  "id": 41,
  "uuid": "2c83f27f-d6f7-4300-bfbf-9ee5f48e43fd",
  "subject": "Question sur ma réservation",
  "status": "open",
  "status_label": "Ouvert",
  "conversation_type": "participant_vendor",
  "closed_at": null,
  "last_message_at": "2026-04-23T10:30:00+00:00",
  "unread_count": 2,
  "is_signalement": false,
  "user_has_reported": false,
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
    "is_mine": false,
    "attachments": [
      {
        "uuid": "0c51dc2b-1315-4277-a95a-fc00f3e4d162",
        "url": "https://cdn.example.com/messages/photo.jpg",
        "original_name": "photo.jpg",
        "mime_type": "image/jpeg",
        "size": 204800,
        "is_image": true,
        "is_pdf": false
      }
    ],
    "created_at": "2026-04-23T10:30:00+00:00"
  },
  "created_at": "2026-04-22T12:00:00+00:00",
  "updated_at": "2026-04-23T10:30:00+00:00"
}
```

**Champs importants :**

| Champ | Type | Usage |
|-------|------|-------|
| `organization.logo_url` | string\|null | Afficher le logo dans le tile de liste et la sidebar |
| `organization.avatar_url` | string\|null | Fallback si `logo_url` est null |
| `latest_message.attachments` | array | Toujours retourné depuis le 24 avril 2026 (eager-loaded côté backend) |
| `latest_message.content` | string\|null | `null` si message pièces jointes uniquement |
| `user_has_reported` | bool | Griser/masquer le bouton "Signaler" sans appel supplémentaire |
| `is_signalement` | bool | Afficher chip "Signalement" dans l'onglet support |
| `unread_count` | int | Nombre de messages non lus dans cette conversation |

### Logique de preview du dernier message (ConversationTile)

Utiliser cette règle pour afficher le texte de prévisualisation dans le tile :

```
si latest_message == null
  → afficher rien (pas de "Aucun message")

si latest_message.content != null
  → afficher content (tronqué à ~80 chars)

si latest_message.content == null et attachments.length > 0
  imageCount = attachments.filter(a => a.is_image).length
  fileCount  = attachments.length - imageCount

  si fileCount == 0 :
    imageCount == 1  → "Une image envoyée"  (+ icone paperclip)
    imageCount  > 1  → "{n} images envoyées" (+ icone paperclip)

  si imageCount == 0 :
    fileCount == 1  → "Un fichier envoyé"  (+ icone paperclip)
    fileCount  > 1  → "{n} fichiers envoyés" (+ icone paperclip)

  sinon (mixte) :
    → "{n} pièces jointes" (+ icone paperclip)

si latest_message.content == null et attachments vide
  → afficher rien
```

### Conversation (détail — show)

Même structure que le résumé avec en plus :
- `messages: [Message]` — liste complète triée par `id ASC`
- `participant: { id, name, email, avatar_url }`

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

**Règles d'affichage :**

| Condition | Rendu |
|-----------|-------|
| `is_deleted = true` | `content = null` — afficher "Ce message a été supprimé" (italique gris) |
| `content = null` + `attachments` non vide | Afficher uniquement les pièces jointes, pas de texte |
| `is_edited = true` | Afficher "(modifié)" sous le timestamp |
| `is_system = true` | Chip centré, pas de bulle |
| `is_mine = true` | Bulle droite, couleur primaire |
| `is_mine = false` | Bulle gauche, avatar du sender |

### Sender types

| Valeur | Qui | Bulle |
|--------|-----|-------|
| `participant` | L'utilisateur connecté | Droite (`is_mine = true`) |
| `organization` | L'organisateur | Gauche |
| `admin` | Admin LeHiboo | Gauche (dans support) |
| `system` | Système | Chip centré |

---

## Endpoints — Conversations organisateur

### 1. Lister les conversations

```http
GET /api/v1/user/conversations
```

Query params :

| Paramètre | Type | Description |
|-----------|------|-------------|
| `status` | `open` \| `closed` | Filtrer par statut |
| `event_id` | integer | Filtrer par événement |
| `unread_only` | `true` | Seulement les non lus |
| `search` | string | Recherche texte libre |
| `period` | `today` \| `week` \| `month` \| `older` | Filtrer par période |
| `page` | integer | Page (défaut 1) |
| `per_page` | integer | Résultats par page (défaut 15) |

Réponse `200` :

```json
{
  "data": [ /* Conversation summary */ ],
  "links": {
    "first": "...", "last": "...", "prev": null, "next": "..."
  },
  "meta": {
    "current_page": 1,
    "last_page": 3,
    "per_page": 15,
    "total": 33
  }
}
```

**Important** : `latest_message.attachments` est toujours inclus depuis le 24 avril 2026.

---

### 2. Compteur non lus (participant_vendor uniquement)

```http
GET /api/v1/user/conversations/unread-count
```

Réponse :

```json
{
  "count": 4,
  "unreadCount": 4
}
```

**Attention** : cet endpoint ne compte que les conversations `participant_vendor`. Les conversations `user_support` ne sont pas incluses. Pour un badge global, additionner manuellement les `unread_count` des conversations support depuis la liste `GET /user/support-conversations`.

---

### 3. Événements utilisables comme filtre

```http
GET /api/v1/user/conversations/events
```

Réponse :

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

---

### 4. Organisateurs contactables (sélecteur de destinataire)

```http
GET /api/v1/user/conversations/contactable-organizations
```

Retourne les organisations avec lesquelles l'utilisateur a déjà une relation (réservation confirmée ou conversation existante).

Réponse :

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

**Usage UI** : Cet endpoint alimente le sélecteur de destinataire dans le formulaire "Nouveau message". Implémenter un champ de recherche côté client avec filtrage local sur `company_name` (pas de paramètre `search` côté serveur sur cet endpoint — filtrer la liste reçue).

---

### 5. Créer une conversation depuis le dashboard

```http
POST /api/v1/user/conversations
Content-Type: application/json          (si pas de fichiers)
Content-Type: multipart/form-data       (si pièces jointes à l'envoi initial)
```

Corps JSON :

```json
{
  "organization_uuid": "6c1dc735-83ff-48e3-a94f-f97f5233fa51",
  "subject": "Question sur mon billet",
  "message": "Bonjour, puis-je modifier ma venue ?",
  "event_id": 12
}
```

Corps multipart (si pièces jointes dès la création) :

```text
organization_uuid=6c1dc735-83ff-48e3-a94f-f97f5233fa51
subject=Question sur mon billet
message=Bonjour, puis-je modifier ma venue ?
event_id=12
files[]=<fichier1>
files[]=<fichier2>
```

Notes :
- `organization_uuid` : obligatoire, uuid de l'org contactable
- `subject` : obligatoire, **max 100 caractères**
- `message` : obligatoire si aucun fichier joint, max 2000 caractères
- `event_id` : optionnel, integer ou uuid string
- `files[]` : optionnel, mêmes contraintes que les pièces jointes de message (max 3, 5 MB, jpg/png/webp/pdf)

### Limites de validation

| Champ | Contrainte |
| ----- | ---------- |
| `subject` | Obligatoire, max **100** caractères |
| `message` | Obligatoire si aucun fichier, max **2 000** caractères |
| `files[]` / `attachments[]` | Max **3** fichiers par envoi, max **5 MB** par fichier |
| Types acceptés | `jpg`, `jpeg`, `png`, `webp`, `pdf` |

Réponse `201` :

```json
{
  "message": "Conversation créée avec succès.",
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

---

### 6. Ouvrir ou créer depuis une réservation

```http
POST /api/v1/user/conversations/from-booking/{bookingUuid}
```

Pas de corps requis. Le backend déduit l'organisation depuis la réservation.

Réponse si conversation existante :

```json
{
  "message": "Conversation existante trouvée.",
  "data": { "uuid": "...", "subject": "Réservation #AB12CD34 - Concert du vendredi", "status": "open" },
  "created": false
}
```

Réponse si créée :

```json
{
  "message": "Conversation créée avec succès.",
  "data": { "uuid": "...", "subject": "Réservation #AB12CD34 - Concert du vendredi", "status": "open" },
  "created": true
}
```

**Flow** : naviguer vers le thread `data.uuid` dans les deux cas. Si `created = true`, le thread est vide — l'utilisateur écrit le premier message.

---

### 7. Contacter un organisateur depuis sa page publique

```http
POST /api/v1/user/conversations/from-organization/{organizationUuid}
Content-Type: application/json
```

Corps :

```json
{
  "subject": "Question avant réservation",
  "message": "Bonjour, est-ce adapté aux enfants ?",
  "event_id": "553300f8-d6de-47f9-876d-1bb08e9d5984"
}
```

Notes :
- `event_id` accepte uuid string ou integer string
- Si `allow_public_contact = false` côté organisateur → réponse `403`

Réponse `201` :

```json
{
  "message": "Conversation créée avec succès.",
  "data": { "uuid": "2c83f27f-...", "subject": "Question avant réservation", "status": "open" }
}
```

Erreur `403` :

```json
{
  "message": "Cet organisateur n'accepte pas les messages depuis sa page publique."
}
```

**UI** : Masquer ou désactiver le bouton "Contacter" si `allow_public_contact = false` est disponible dans la réponse de la page organisateur.

---

### 8. Détail d'une conversation (+ mark-as-read automatique)

```http
GET /api/v1/user/conversations/{conversationUuid}
```

**Effet de bord** : ouvre le thread et marque automatiquement comme lus tous les messages reçus non lus. Pas besoin d'appel séparé.

Réponse `200` :

```json
{
  "data": {
    "uuid": "2c83f27f-d6f7-4300-bfbf-9ee5f48e43fd",
    "subject": "Question sur ma réservation",
    "status": "open",
    "conversation_type": "participant_vendor",
    "user_has_reported": false,
    "organization": { /* ConversationOrganization complet */ },
    "participant": {
      "id": 17,
      "name": "Jane Doe",
      "email": "jane@example.com",
      "avatar_url": "https://cdn.example.com/users/jane.png"
    },
    "event": { /* ConversationEvent */ },
    "messages": [ /* Message[] trié par id ASC */ ]
  }
}
```

---

### 9. Envoyer un message

```http
POST /api/v1/user/conversations/{conversationUuid}/messages
Content-Type: application/json   (ou multipart/form-data si fichiers)
```

Corps JSON :

```json
{ "content": "Merci pour votre retour." }
```

Corps multipart (avec fichiers) :

```
content=Merci pour votre retour.
attachments[]=<fichier1>
attachments[]=<fichier2>
```

Réponse `200` : objet `Message` complet.

Erreur si conversation fermée :

```json
{
  "message": "Cette conversation est close. Vous ne pouvez plus y répondre."
}
```
HTTP `422`.

---

### 10. Éditer un message

```http
PATCH /api/v1/user/conversations/{conversationUuid}/messages/{messageUuid}
Content-Type: application/json
```

```json
{ "content": "Texte corrigé." }
```

Réponse `200` :

```json
{
  "message": "Message modifié avec succès.",
  "data": {
    "uuid": "...",
    "content": "Texte corrigé.",
    "is_edited": true,
    "edited_at": "2026-04-23T10:40:00+00:00"
  }
}
```

**Règle** : uniquement disponible pour les conversations `participant_vendor`. Ne pas exposer pour `user_support`.

---

### 11. Supprimer un message

```http
DELETE /api/v1/user/conversations/{conversationUuid}/messages/{messageUuid}
```

Réponse `200` :

```json
{ "message": "Message supprimé avec succès." }
```

Le message passe en soft-delete : `content = null`, `is_deleted = true`. Les pièces jointes sont également masquées.

**Règle** : uniquement disponible pour les conversations `participant_vendor`. Ne pas exposer pour `user_support`.

---

### 12. Fermer une conversation

```http
POST /api/v1/user/conversations/{conversationUuid}/close
```

Réponse `200` :

```json
{
  "message": "Conversation close avec succès.",
  "data": {
    "uuid": "...",
    "status": "closed",
    "closed_at": "2026-04-23T11:00:00+00:00"
  }
}
```

Après fermeture : le composer est désactivé, l'utilisateur ne peut pas rouvrir (seul un admin peut réouvrir).

---

### 13. Signaler une conversation

```http
POST /api/v1/user/conversations/{conversationUuid}/report
Content-Type: application/json
```

```json
{
  "reason": "spam",
  "comment": "Cet organisateur m'envoie des messages non souhaités."
}
```

Valeurs autorisées pour `reason` :

| Valeur | Label |
|--------|-------|
| `inappropriate` | Contenu inapproprié |
| `harassment` | Harcèlement |
| `spam` | Spam |
| `other` | Autre |

`comment` : **requis**, min 10 chars, max 2000 chars. Le dialog côté web invalide si `comment.trim().length < 10`.

Réponse `201` :

```json
{
  "message": "Votre signalement a bien été transmis à l'équipe LeHiboo.",
  "data": {
    "uuid": "3f4f601c-0f3c-4d84-a91a-fae96415d731",
    "support_conversation_uuid": "0a2f52f0-ae65-4547-ae75-0d8172b8b3f7"
  }
}
```

**Comportement** : crée automatiquement un thread support de suivi (`support_conversation_uuid`). Proposer à l'utilisateur de naviguer vers ce thread.

Erreur si déjà signalé :

```json
{ "message": "Vous avez déjà signalé cette conversation." }
```
HTTP `422`.

---

## Endpoints — Conversations support LeHiboo

### 14. Lister les conversations support

```http
GET /api/v1/user/support-conversations?page=1&per_page=15
```

Query params :

| Paramètre | Type | Description |
|-----------|------|-------------|
| `status` | `open` \| `closed` | Filtrer par statut |
| `unread_only` | `true` | Seulement les non lus |
| `search` | string | Recherche texte |
| `period` | `today` \| `week` \| `month` \| `older` | Filtrer par période |
| `page` | integer | Page |
| `per_page` | integer | Par page |

Réponse `200` :

```json
{
  "data": [
    {
      "uuid": "0a2f52f0-ae65-4547-ae75-0d8172b8b3f7",
      "subject": "Problème de paiement",
      "status": "open",
      "conversation_type": "user_support",
      "unread_count": 1,
      "is_signalement": false,
      "latest_message": {
        "uuid": "9b4acfd0-ef51-4948-9298-f3c68c06229c",
        "sender_type": "admin",
        "content": "Nous examinons votre demande.",
        "is_mine": false,
        "attachments": []
      }
    }
  ],
  "meta": { "current_page": 1, "last_page": 1, "per_page": 15, "total": 1 }
}
```

**Badge "Signalement"** : `is_signalement` est visible dans la liste support — ces threads sont créés automatiquement quand l'utilisateur signale une conversation organisateur. Ce champ n'est **jamais exposé au participant côté organisateur** (uniquement dans les threads support qui lui appartiennent).

**Unread count support** : il n'existe pas d'endpoint `unread-count` dédié pour le support. Pour le badge, sommer les `unread_count` de chaque item retourné par cet endpoint (ou garder un compteur local mis à jour via les events realtime).

---

### 15. Créer une conversation support

```http
POST /api/v1/user/support-conversations
Content-Type: application/json         (si pas de fichiers)
Content-Type: multipart/form-data      (si pièces jointes)
```

Corps JSON :

```json
{
  "subject": "Problème de paiement",
  "message": "Mon paiement est resté en attente depuis 48h."
}
```

Corps multipart (avec pièces jointes) :

```text
subject=Problème de paiement
message=Mon paiement est resté en attente depuis 48h.
attachments[]=<fichier>
```

`subject` (requis, max 255 chars) et `message` (requis) obligatoires. Les pièces jointes suivent les mêmes contraintes que les messages : max 3, 5 MB, types `jpg/jpeg/png/webp/pdf`.

Réponse `201` :

```json
{
  "message": "Conversation support créée avec succès.",
  "data": {
    "uuid": "0a2f52f0-ae65-4547-ae75-0d8172b8b3f7",
    "subject": "Problème de paiement",
    "status": "open",
    "conversation_type": "user_support"
  }
}
```

---

### 16. Détail d'une conversation support (+ mark-as-read automatique)

```http
GET /api/v1/user/support-conversations/{conversationUuid}
```

**Effet de bord** : marque automatiquement les messages reçus comme lus.

Réponse `200` :

```json
{
  "data": {
    "uuid": "0a2f52f0-ae65-4547-ae75-0d8172b8b3f7",
    "subject": "Problème de paiement",
    "status": "open",
    "conversation_type": "user_support",
    "is_signalement": false,
    "messages": [
      {
        "uuid": "9b4acfd0-ef51-4948-9298-f3c68c06229c",
        "sender_type": "admin",
        "content": "Nous examinons votre demande.",
        "is_mine": false,
        "attachments": []
      }
    ]
  }
}
```

---

### 17. Envoyer un message dans support

```http
POST /api/v1/user/support-conversations/{conversationUuid}/messages
Content-Type: application/json         (si pas de fichiers)
Content-Type: multipart/form-data      (si pièces jointes)
```

Corps JSON :

```json
{ "content": "Merci, je joins une capture." }
```

Corps multipart (avec pièces jointes) :

```text
content=Merci, je joins une capture.
attachments[]=<fichier>
```

Réponse `200` : objet `Message` complet.

**Restrictions** : pas d'endpoints d'édition, suppression, fermeture ou signalement côté participant sur les conversations support. Le menu long-press (modifier/supprimer) et l'option "Fermer" ne doivent pas être affichés dans ces threads.

---

## Temps réel — WebSocket Broadcasting

### Infrastructure

Le backend broadcast via **Laravel Reverb** sur des channels privés.

Auth channel : `POST /broadcasting/auth` avec `Authorization: Bearer {token}` (standard Laravel Broadcasting).

### Channels

| Channel | Scope |
|---------|-------|
| `private-user.{userId}` | Tous les events participant |

### Événements disponibles sur `private-user.{userId}`

#### `message.received`

Nouveau message dans une conversation (toutes directions).

```json
{
  "message_uuid": "...",
  "conversation_uuid": "...",
  "sender_type": "organization",
  "sender_name": "Le Hiboo Events",
  "content_preview": "Bonjour, voici...",
  "conversation_subject": "Question sur ma réservation",
  "created_at": "2026-04-23T10:30:00+00:00"
}
```

**Action** : si on est dans ce thread → appeler `GET show` pour récupérer le message complet. Sinon → incrémenter le badge unread, mettre à jour `latest_message` dans la liste.

#### `message.delivered`

Confirmation de livraison d'un message envoyé par l'utilisateur.

```json
{
  "message_uuid": "...",
  "conversation_uuid": "...",
  "delivered_at": "2026-04-23T10:30:01+00:00"
}
```

**Action** : passer `is_delivered = true` sur le message correspondant dans le cache local (ticks gris simple → double).

#### `message.edited`

Un message a été édité par son expéditeur.

```json
{
  "message_uuid": "...",
  "conversation_uuid": "...",
  "content": "Texte mis à jour",
  "edited_at": "2026-04-23T10:45:00+00:00"
}
```

**Action** : mettre à jour `content`, `is_edited = true`, `edited_at` dans le cache local. Pas de refetch complet nécessaire.

#### `message.deleted`

Un message a été supprimé.

```json
{
  "message_uuid": "...",
  "conversation_uuid": "...",
  "deleted_at": "2026-04-23T10:50:00+00:00"
}
```

**Action** : passer `is_deleted = true`, `content = null`, vider `attachments` dans le cache local.

#### `conversation.read`

L'autre partie a lu les messages envoyés par l'utilisateur.

```json
{
  "conversation_uuid": "...",
  "reader_id": 8,
  "reader_name": "Le Hiboo Events",
  "messages_read_count": 3,
  "read_at": "2026-04-23T11:00:00+00:00"
}
```

**Action** : passer `is_read = true` sur les messages `is_mine = true` concernés. Ticks doubles gris → bleus/primaire.

#### `conversation.created`

Nouvelle conversation créée (notamment quand un admin ou vendor initie la conversation vers l'utilisateur).

```json
{
  "conversation_uuid": "...",
  "conversation_type": "participant_vendor",
  "subject": "Question avant réservation",
  "created_at": "2026-04-23T11:05:00+00:00"
}
```

**Action** : invalider la liste de conversations + unread count.

#### `conversation.closed`

La conversation a été fermée.

```json
{
  "conversation_uuid": "...",
  "closed_at": "2026-04-23T11:10:00+00:00"
}
```

**Action** : refetch du détail pour verrouiller le composer. Mettre à jour `status = "closed"` dans la liste.

#### `conversation.reopened`

La conversation a été réouverte par un admin.

```json
{
  "conversation_uuid": "...",
  "reopened_at": "2026-04-23T14:00:00+00:00"
}
```

**Action** : refetch du détail pour déverrouiller le composer. Mettre à jour `status = "open"` dans la liste.

---

## Stratégie de synchronisation — Polling (actuel)

| Surface | Intervalle | Endpoint |
|---------|------------|----------|
| Thread detail (actif) | 10 secondes | `GET /user/conversations/{uuid}` |
| Badge unread global | 30 secondes | `GET /user/conversations/unread-count` + somme support |
| Liste conversations | Au retour sur l'écran | `GET /user/conversations` |

**Note** : le polling du detail marque automatiquement comme lus (effet de bord du `GET show`). Pas besoin d'appel `POST /read` séparé — cet endpoint n'existe pas côté participant.

---

## Erreurs courantes

### 401 — Non authentifié

```json
{ "message": "Unauthenticated.", "error": "unauthenticated" }
```

### 403 — Relation non autorisée

```json
{ "message": "Vous ne pouvez contacter que les organisateurs avec lesquels vous avez une relation." }
```

### 403 — Contact public désactivé

```json
{ "message": "Cet organisateur n'accepte pas les messages depuis sa page publique." }
```

### 404 — Ressource introuvable

```json
{ "message": "Conversation non trouvée." }
```

### 422 — Validation

```json
{
  "message": "The given data was invalid.",
  "errors": { "subject": ["The subject field is required."] }
}
```

### 422 — Conversation fermée

```json
{ "message": "Cette conversation est close. Vous ne pouvez plus y répondre." }
```

### 422 — Signalement en double

```json
{ "message": "Vous avez déjà signalé cette conversation." }
```

---

## Hors scope participant (endpoints web/dashboard existants non exposés côté user)

| Endpoint | Rôle web |
|----------|----------|
| `GET /vendor/conversations` | Vendor — liste côté org |
| `POST /vendor/conversations/to-participant` | Vendor — contacter un participant |
| `GET /admin/conversations` | Admin |
| `POST /admin/conversations/{uuid}/reopen` | Admin — réouvrir |
| `GET /admin/conversation-reports` | Admin — liste signalements |
