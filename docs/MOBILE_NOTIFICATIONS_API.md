# Notifications — API Mobile (centre de notifications + temps réel)

> Référence complète pour l'équipe mobile (Flutter). Couvre l'API REST du centre de notifications, le contrat WebSocket temps réel (Laravel Reverb) et l'articulation avec les push notifications OneSignal.
>
> **Public cible** : développeurs mobile qui implémentent la page « notifications » de l'app et la mise à jour live.

---

## 1. Vue d'ensemble

### 1.1 Trois canaux complémentaires

L'app reçoit les notifications par **trois canaux distincts mais cohérents**. La source de vérité reste la base de données Laravel ; les autres canaux servent à **réveiller** l'UI.

```
┌──────────────────────────────────────────────────────────────────────┐
│                          APP MOBILE FLUTTER                          │
│                                                                      │
│  ┌────────────────┐   ┌────────────────┐   ┌────────────────────┐   │
│  │ REST API       │   │ WebSocket      │   │ Push OneSignal     │   │
│  │ (source vérité)│   │ (live update)  │   │ (background)       │   │
│  └───────┬────────┘   └───────┬────────┘   └─────────┬──────────┘   │
│          │                    │                       │              │
└──────────┼────────────────────┼───────────────────────┼──────────────┘
           │                    │                       │
           ▼                    ▼                       ▼
   GET /api/v1/         private-user.{id}        OneSignal API
   notifications        event "notification.     (fan-out external_id)
                        created"
```

| Canal | Quand l'utiliser | Couvre |
|---|---|---|
| **REST** | Affichage de la page liste, pagination, badge, mark-as-read | 100% des notifications stockées |
| **WebSocket** (Reverb) | App au premier plan → MAJ live de la liste et du badge | Toutes les nouvelles notifications du user connecté |
| **Push** (OneSignal) | App fermée / arrière-plan → bannière système + ouverture deep link | Sous-ensemble — voir [PUSH_NOTIFICATIONS_CATALOG.md](../03-guides/PUSH_NOTIFICATIONS_CATALOG.md) |

### 1.2 Règle d'or côté mobile

1. À l'ouverture du centre de notifications → **fetch REST** pour récupérer la liste (paginée).
2. Pendant que l'écran est visible → **s'abonner au channel WebSocket** et réagir aux events `notification.created` :
   - prepend la notification fraîche en tête de liste,
   - rafraîchir le badge avec `unread_count` fourni dans le payload.
3. Quand l'utilisateur tape **« marquer comme lu »** → appel REST + MAJ optimiste locale.
4. **Push notification** = simple bannière OS. Au tap, ouvrir l'écran ciblé via `data.action_url` ou `data.type` puis refetch la liste.

---

## 2. Authentification

Tous les endpoints sont protégés par `auth:sanctum`. Inclure le token utilisateur dans chaque requête :

```
Authorization: Bearer {personal_access_token}
Accept: application/json
```

WebSocket : l'auth utilise aussi ce token, voir [§6.2 Authentification du channel](#62-authentification-du-channel-privé).

---

## 3. Endpoints REST

Base : `https://api.lehiboo.com/api/v1` (prod) — `http://api.lehiboo.localhost/api/v1` (local).

### 3.1 Liste paginée des notifications

`GET /notifications`

**Query params :**

| Param | Type | Défaut | Description |
|---|---|---|---|
| `per_page` | int | 15 | Items par page, **max 100** |
| `page` | int | 1 | Page (pagination standard Laravel) |
| `type` | string | — | Filtre `LIKE %...%` sur le slug du type (ex. `booking_`) |
| `unread_only` | bool | false | Si `true`, retourne uniquement les non lues |
| `context` | string | — | `participant`, `vendor` ou `admin` (voir [§5](#5-contextes-participant--vendor--admin)) |
| `organization_id` | uuid | — | (Si `context=vendor`) filtre sur une organisation précise |
| `search` | string | — | Recherche full-text dans le payload (PostgreSQL `data::text ILIKE '%search%'`) |

**Réponse 200** — pagination Laravel standard via `AnonymousResourceCollection` :

```json
{
  "data": [
    {
      "id": "0193a8c4-1b2c-7000-8000-abcdef012345",
      "type": "booking_confirmed",
      "title": "Réservation confirmée",
      "message": "Votre réservation « Yoga Workshop » (réf. ABC123) a été confirmée.",
      "action_url": "/bookings/0193a8c4-...",
      "data": {
        "type": "booking_confirmed",
        "booking_id": 123,
        "booking_uuid": "0193a8c4-...",
        "booking_reference": "ABC123",
        "event_id": 456,
        "event_title": "Yoga Workshop",
        "total_amount": 25.00,
        "confirmed_at": "2026-05-12T10:30:00+00:00"
      },
      "read_at": null,
      "is_read": false,
      "created_at": "2026-05-12T10:30:00+00:00",
      "updated_at": "2026-05-12T10:30:00+00:00"
    }
  ],
  "links": {
    "first": "https://api.lehiboo.com/api/v1/notifications?page=1",
    "last":  "https://api.lehiboo.com/api/v1/notifications?page=8",
    "prev":  null,
    "next":  "https://api.lehiboo.com/api/v1/notifications?page=2"
  },
  "meta": {
    "current_page": 1,
    "from": 1,
    "last_page": 8,
    "per_page": 15,
    "to": 15,
    "total": 120,
    "path": "https://api.lehiboo.com/api/v1/notifications"
  }
}
```

> ⚠️ Ce endpoint utilise le format pagination **standard Laravel** (avec `links` + `meta` Laravel), pas le format custom `meta: {total, page, per_page, last_page}` documenté dans CLAUDE.md.

**Exemples :**

```bash
# Page 1, 20 items, uniquement non lues
GET /v1/notifications?per_page=20&unread_only=true

# Contexte participant uniquement
GET /v1/notifications?context=participant

# Vendor, filtré sur une organisation
GET /v1/notifications?context=vendor&organization_id=550e8400-...

# Recherche libre
GET /v1/notifications?search=yoga
```

---

### 3.2 Détail d'une notification

`GET /notifications/{id}`

`id` = UUID (validé côté serveur ; tout autre format → 404).

**Réponse 200 :**

```json
{
  "data": {
    "id": "0193a8c4-...",
    "type": "booking_confirmed",
    "title": "Réservation confirmée",
    "message": "…",
    "action_url": "/bookings/0193a8c4-...",
    "data": { ... },
    "read_at": null,
    "is_read": false,
    "created_at": "…",
    "updated_at": "…"
  }
}
```

**404 :** `{ "message": "Notification non trouvée." }` (UUID invalide ou n'appartenant pas au user).

---

### 3.3 Marquer une notification comme lue

`POST /notifications/{id}/read` *(ou `PATCH`, les deux verbes sont acceptés)*

**Body :** vide.

**Réponse 200 :**

```json
{
  "message": "Notification marquée comme lue.",
  "data": { /* NotificationResource complète, read_at maintenant rempli */ }
}
```

**Recommandation mobile :** MAJ optimiste — marquer localement en lu avant la réponse, rollback en cas d'erreur. Idempotent : appeler deux fois ne pose pas de problème.

---

### 3.4 Marquer toutes les notifications comme lues

`POST /notifications/read-all`

**Query params (optionnels)** — pour ne marquer qu'un sous-ensemble :

| Param | Type | Description |
|---|---|---|
| `context` | string | Cible un contexte précis (`participant`/`vendor`/`admin`) |
| `organization_id` | uuid | Cible une organisation (vendor uniquement) |

**Réponse 200 :**

```json
{
  "message": "Toutes les notifications ont été marquées comme lues.",
  "count": 12
}
```

`count` = nombre de notifications mises à jour côté DB.

---

### 3.5 Badge — compteur de non-lues

`GET /notifications/unread-count`

**Query params** (mêmes filtres que `read-all`) :

| Param | Type | Description |
|---|---|---|
| `context` | string | Filtre contexte |
| `organization_id` | uuid | Filtre organisation |

**Réponse 200 :**

```json
{
  "count": 5,
  "unread": 5,
  "total": 42
}
```

> `count` et `unread` sont identiques (alias historique). Côté mobile, lire `count`.

**Recommandation :** ne pas poller cet endpoint. Le badge se met à jour automatiquement via :
- le champ `unread_count` reçu dans chaque event WebSocket `notification.created`,
- un refetch après chaque action mutante (mark/delete),
- un refetch au resume de l'app (foreground).

Si polling indispensable (fallback WebSocket KO), intervalle conseillé **≥ 60 s**.

---

### 3.6 Supprimer une notification

`DELETE /notifications/{id}`

**Réponse 200 :** `{ "message": "Notification supprimée." }`
**Réponse 404 :** `{ "message": "Notification non trouvée." }`

---

### 3.7 Supprimer toutes les lues

`DELETE /notifications/read`

Accepte les mêmes filtres `context` / `organization_id` que `read-all`.

**Réponse 200 :**

```json
{
  "message": "Notifications lues supprimées.",
  "count": 8
}
```

---

## 4. Schéma `NotificationResource`

Format retourné par tous les endpoints qui exposent une notification.

| Champ | Type | Description |
|---|---|---|
| `id` | uuid string | Identifiant unique (clé primaire de `notifications`) |
| `type` | string | Slug snake_case (ex. `booking_confirmed`, `new_alert_events`). Voir [§7](#7-types-de-notifications) |
| `title` | string | Titre localisé FR, calculé côté serveur |
| `message` | string | Corps localisé FR, calculé côté serveur |
| `action_url` | string \| null | Cible deep link (chemin relatif, ex. `/bookings/xxx`) |
| `data` | object | Payload brut spécifique au type — clé de routage et données métier |
| `read_at` | iso8601 \| null | Timestamp de lecture, `null` si non lue |
| `is_read` | bool | Convenance : `read_at !== null` |
| `created_at` | iso8601 | Timestamp de création |
| `updated_at` | iso8601 | Timestamp de dernière MAJ |

### 4.1 Résolution de `title` (côté serveur)

`api/app/Http/Resources/NotificationResource.php:34,60`

1. `data.title` si non vide.
2. `data.subject` si non vide.
3. Sinon `defaultTitle()` = match sur `type` (table complète au [§7](#7-types-de-notifications)).
4. Préfixes dynamiques : `story_*`, `otp*`, `booking_*` non standards retombent sur un titre générique.
5. Fallback ultime : `"Notification"`.

### 4.2 Résolution de `message` (côté serveur)

`api/app/Http/Resources/NotificationResource.php:19,208`

Cascade : `data.message` → `data.body` → `data.description` → `data.content_preview` → `defaultMessage()` (composé à partir de `event_title`, `organization_name`, `booking_reference`, `amount`, etc.).

### 4.3 `action_url` — règle de routage mobile

- Chaîne **relative** type `/bookings/{uuid}`, `/events/{slug}`, `/messages/{conversation_uuid}`.
- L'app mobile doit mapper ces chemins vers ses routes natives (deep link).
- Les valeurs `"null"`, `"undefined"`, `""` sont nettoyées en `null` côté API — on peut se fier strictement à `action_url === null`.

### 4.4 `data` — payload type-spécifique

Toujours présent (jamais `null`). Contient au minimum `type` (snake_case). Selon le type, peut contenir :

```jsonc
{
  "type": "booking_confirmed",
  "booking_id": 123,            // numeric ID interne
  "booking_uuid": "...",        // UUID exposable
  "booking_reference": "ABC12", // référence courte affichable
  "event_id": 456,
  "event_title": "Yoga Workshop",
  "event_slug": "yoga-workshop-paris",
  "organization_id": 10,
  "organization_name": "Yoga Studio",
  "organization_uuid": "...",
  "amount": 25.00,
  "total_amount": 25.00,
  "action_url": "/bookings/...",
  // + champs spécifiques selon le type
}
```

Liste non exhaustive — mobile doit **traiter `data` comme un map<String, dynamic>** et lire défensivement (`data?['booking_uuid']`). De nouveaux champs peuvent être ajoutés sans préavis (non-breaking).

---

## 5. Contextes (`participant` / `vendor` / `admin`)

Une même notification est destinée à un seul user, mais elle « appartient » à un rôle. Le mobile peut filtrer la liste selon l'onglet UI affiché.

### 5.1 Mapping

`api/app/Http/Controllers/Api/V1/NotificationController.php:258,355`

| Contexte | Pour qui | Inclut (extrait) |
|---|---|---|
| `participant` | Le user en tant qu'acheteur de billets | `booking_confirmed`, `booking_cancelled`, `payment_received`, `tickets_ready`, `ticket_checked_in`, `new_alert_events`, `new_message`, `refund`, `event_updated`, `event_cancelled`, `question_answered`, `review_*`, `organization_join_approved`… |
| `vendor` | Le user en tant qu'organisateur | `booking_received_organiser`, `organizer_review_submitted`, `question_submitted_organizer`, `document_received`, `document_approved`, `payout_completed`, `organization_join_requested`, `partnership_*`, `story_*`… |
| `admin` | Admin plateforme | `admin_review_pending`, `document_uploaded`, `new_organization_registration`, `crm_*`, `story_submitted`, `new_message`… |

### 5.2 Logique de filtrage (côté serveur)

Le filtre combine deux clauses **OR** :

1. Match du slug dans le JSON : `data::text ILIKE '%"type":"<slug>"%'` — c'est la **voie nominale**, donc bien stocker `type` dans `toArray()` est obligatoire pour les notifs côté API.
2. Fallback FQCN : `notifications.type LIKE 'App\Notifications\Xxx%'` — couvre les notifs legacy qui n'auraient pas mis `type` dans le payload.

### 5.3 Filtre organisation

Quand `context=vendor` + `organization_id={uuid}` :

```sql
AND ( data::text LIKE '%"organization_id":<id>%'
   OR data::text LIKE '%"organization_uuid":"<uuid>"%' )
```

Utile pour les vendors multi-organisation qui veulent voir uniquement les notifs de l'organisation active (header `X-Organization-Id`).

---

## 6. Temps réel — WebSocket (Laravel Reverb)

### 6.1 Configuration serveur

**Broadcaster :** Laravel Reverb (compatible Pusher Protocol). Drivers possibles dans `api/config/broadcasting.php`, valeur par défaut `BROADCAST_CONNECTION=reverb`.

**Variables d'env utiles côté client :**

| Variable | Local | Prod |
|---|---|---|
| `REVERB_APP_KEY` | `lehiboo-local-key` | `<clé prod>` |
| `REVERB_HOST` | `localhost` | `ws.lehiboo.com` (à confirmer côté ops) |
| `REVERB_PORT` | `8080` | `443` |
| `REVERB_SCHEME` | `http` | `https` |

> Côté mobile, demander ces valeurs au backend par config remote ou les hardcoder par flavor. Ne PAS exposer `REVERB_APP_SECRET` à l'app.

### 6.2 Authentification du channel privé

Tous les channels notifications sont **privés**. Le SDK Pusher/Reverb appelle automatiquement l'endpoint d'auth Laravel :

`POST {API_BASE_URL}/broadcasting/auth`
Headers : `Authorization: Bearer {token}`, `Cookie: …` (si applicable)
Body : `socket_id={socketId}&channel_name=private-user.{userId}`

Laravel vérifie via `api/routes/channels.php:30` que `user.id === userId` puis retourne un token de souscription. Le SDK fait ça en transparent — il suffit de configurer le **`authEndpoint`** et les **`auth.headers`** dans le client Pusher/Echo mobile.

### 6.3 Channels à écouter

| Channel | Quand le rejoindre | Authorization |
|---|---|---|
| `private-user.{userId}` | Toujours, dès que l'utilisateur est authentifié | `user.id === userId` (`channels.php:30`) |
| `private-organization.{organizationId}` | Si l'utilisateur est vendor ET a une organisation active | Owner OU membre actif (`channels.php:40`) |

> Le channel `user.{id}` couvre **toutes** les notifications individuelles (bookings, tickets, alertes, messages, etc.). C'est le seul indispensable pour la page « notifications ».
>
> Le channel `organization.{id}` sert aux events business côté vendor (nouvelle réservation, check-in, payout, etc.) — utile pour rafraîchir d'autres écrans, pas la liste des notifications.

### 6.4 Event clé pour la liste de notifications

**Event name :** `notification.created` (broadcast as)
**Source :** `api/app/Events/InAppNotificationCreated.php`
**Channel :** `private-user.{userId}`

**Payload :**

```json
{
  "notification": {
    "id": "0193a8c4-...",
    "type": "booking_confirmed",
    "title": "Réservation confirmée",
    "message": "…",
    "action_url": "/bookings/0193a8c4-...",
    "data": { /* … */ },
    "read_at": null,
    "is_read": false,
    "created_at": "2026-05-12T10:30:00+00:00",
    "updated_at": "2026-05-12T10:30:00+00:00"
  },
  "unread_count": 6,
  "occurred_at": "2026-05-12T10:30:00+00:00"
}
```

→ `notification` a **exactement le même format que celui renvoyé par REST**. Mobile peut le `prepend()` directement à sa liste sans refetch.
→ `unread_count` = nombre total de non-lues pour ce user à l'instant T. Met à jour le badge directement.

### 6.5 Autres events utiles sur `private-user.{userId}`

Ces events broadcast **avant** que la notification DB ne soit créée (ou en parallèle). Ils donnent du contexte instantané mais ne sont **pas indispensables** pour la page « notifications » — qui doit s'aligner sur `notification.created`.

| Event | Quand | Source |
|---|---|---|
| `.booking.created` | Nouvelle réservation côté vendor | `Events/BookingCreated.php` |
| `.booking.confirmed` | Réservation confirmée | `Events/BookingConfirmed.php` |
| `.booking.cancelled` | Annulation | `Events/BookingCancelled.php` |
| `.booking.refunded` | Remboursement | `Events/BookingRefunded.php` |
| `.ticket.checked_in` | Check-in d'un billet | `Events/TicketCheckedIn.php` |
| `.message.received` | Nouveau message | `Events/MessageSent.php` |
| `.message.delivered`, `.message.edited`, `.message.deleted` | Lifecycle message | `Events/Message*.php` |
| `.conversation.created`, `.conversation.read`, `.conversation.closed`, `.conversation.reopened` | Lifecycle conversation | `Events/Conversation*.php` |

Mobile peut s'abonner pour rafraîchir d'autres écrans (liste des messages, dashboard) mais **pour la page notifications, écouter uniquement `notification.created` suffit**.

### 6.6 Reconnexion & gestion d'erreurs

- Le SDK Pusher gère automatiquement la reconnexion exponentielle.
- Recommandé : exposer un état `connectionState` (`connecting` / `connected` / `disconnected` / `error`) dans l'UI (icône discrète).
- En cas de déconnexion prolongée → **refetch REST** au retour du foreground pour rattraper les notifs manquées.
- Le frontend web limite à 5 tentatives de reconnexion (cf. `frontend/src/lib/hooks/use-realtime-notifications.ts:80`). À répliquer côté mobile.

---

## 7. Types de notifications

Liste complète des slugs `type` reconnus par `defaultTitle()` / `defaultMessage()`. Tout type inconnu retombe sur le titre `"Notification"` et un message vide — c'est OK mais à signaler côté backend si ça arrive.

### 7.1 Bookings / Paiements

| Slug | Titre | Contexte |
|---|---|---|
| `booking_confirmed` | Réservation confirmée | participant |
| `booking_received_organiser` | Nouvelle réservation reçue | vendor |
| `booking_cancelled` | Réservation annulée | participant |
| `booking_cancelled_organiser` | Réservation annulée par le client | vendor |
| `booking_reminder` | Rappel de réservation | participant |
| `booking_internal_note_added` | Nouvelle note interne | vendor |
| `booking_customer_note_added` | Nouveau message client | vendor |
| `booking_confirmation` | Confirmation de réservation | participant |
| `payment_received` | Paiement reçu | participant |
| `payment_failed` | Paiement échoué | participant |
| `refund` | Remboursement effectué | participant |
| `payout_completed` | Virement effectué | vendor |
| `payout_cancelled` | Virement annulé | vendor |
| `payout_requested` | Demande de virement | vendor |

### 7.2 Événements & créneaux

| Slug | Titre | Contexte |
|---|---|---|
| `event_updated` | Événement mis à jour | participant |
| `event_cancelled` | Événement annulé | participant |
| `new_event_from_followed_organization` | Nouvel événement d'un organisateur suivi | participant |
| `new_slots_from_followed_organization` | Nouvelles dates disponibles | participant |
| `discovery_reminder`, `discovery_event_reminder` | Rappel : événement à découvrir | participant |
| `slot_cancelled_by_organiser` | Réservation annulée par l'organisateur | participant |
| `slot_info_updated` | Informations du créneau mises à jour | participant |
| `event_reminder_removed` | Rappel supprimé : événement annulé | participant |
| `event_reminder_rescheduled` | Rappel mis à jour : nouvelle date | participant |

### 7.3 Billets

| Slug | Titre | Contexte |
|---|---|---|
| `ticket_ready`, `tickets_ready` | Billets disponibles | participant |
| `ticket_email`, `ticket_resend` | Vos billets par email | participant |
| `ticket_checked_in` | Check-in effectué | participant |
| `ticket_transfer_received` | Billet transféré reçu | participant |
| `ticket_transfer_sent` | Billet transféré | participant |

### 7.4 Vendors / Organisations

| Slug | Titre | Contexte |
|---|---|---|
| `vendor_approved` | Compte organisateur approuvé | vendor |
| `vendor_rejected` | Compte organisateur refusé | vendor |
| `organization_approved` | Organisation approuvée | vendor |
| `organization_rejected` | Organisation refusée | vendor |
| `organization_deletion_requested` | Demande de suppression d'organisation | admin |
| `organization_invitation`, `organization_invitation_received` | Invitation à rejoindre une organisation | participant |
| `organization_join_requested` | Nouvelle demande d'adhésion | vendor |
| `organization_join_approved` | Votre demande a été acceptée | participant |
| `organization_join_rejected` | Votre demande n'a pas abouti | participant |
| `organization_invitation_accepted` | Invitation acceptée | vendor |
| `organization_invitation_declined` | Invitation refusée | vendor |
| `organization_member_left` | Départ d'un adhérent | vendor |
| `new_organization_registration` | Nouvelle inscription d'organisation | admin |
| `welcome_organization` | Bienvenue dans Le Hiboo | vendor |

### 7.5 Documents

| Slug | Titre | Contexte |
|---|---|---|
| `document_uploaded` | Document à vérifier | admin |
| `document_received` | Document reçu | vendor |
| `document_approved` | Document approuvé | vendor |
| `document_rejected` | Document rejeté | vendor |
| `document_expired` | Document expiré | vendor |
| `document_expiration_reminder` | Rappel d'expiration du document | vendor |
| `document_reminder` | Rappel : document manquant | vendor |
| `document_reimport_requested` | Réimport de document demandé | vendor |
| `document_status` | Mise à jour du document | vendor |

### 7.6 Reviews & Q&A

| Slug | Titre | Contexte |
|---|---|---|
| `new_review` | Nouvel avis client | vendor |
| `review_submitted` | Avis soumis | participant |
| `review_approved` | Avis approuvé | participant |
| `review_rejected` | Avis refusé | participant |
| `organizer_review_submitted` | Avis sur l'organisateur soumis | vendor |
| `organizer_review_approved` | Avis sur l'organisateur approuvé | vendor |
| `admin_review_pending` | Avis en attente de modération | admin |
| `question_submitted` | Nouvelle question | participant |
| `question_submitted_organizer` | Nouvelle question sur votre événement | vendor |
| `question_approved` | Question approuvée | participant |
| `question_answered` | Réponse à votre question | participant |
| `question_rejected` | Question refusée | participant |

### 7.7 Alertes / messages / autres

| Slug | Titre | Contexte |
|---|---|---|
| `new_alert_events` | Nouveaux événements correspondant à votre alerte | participant |
| `daily_alert_digest` | Résumé quotidien des alertes | participant |
| `new_message` | Nouveau message | participant/vendor/admin |
| `promo_code` | Nouveau code promo | participant |
| `marketing_renewal_reminder` | Renouvellement marketing à venir | vendor |
| `new_organizer_follower` | Nouvel abonné | vendor |
| `partnership_accepted` | Partenariat accepté | vendor |
| `partnership_invitation` | Invitation à un partenariat | vendor |

### 7.8 Stories

| Slug | Titre | Contexte |
|---|---|---|
| `story_submitted` | Story en attente de validation | admin |
| `story_submitted_vendor` | Story soumise pour validation | vendor |
| `story_approved` | Story approuvée | vendor |
| `story_rejected` | Story refusée | vendor |
| `story_*` (autres) | Mise à jour de Story | — |

### 7.9 Compte / Auth

| Slug | Titre |
|---|---|
| `account_approved` | Compte approuvé |
| `account_rejected` | Compte refusé |
| `account_suspended`, `user_account_suspended` | Compte suspendu |
| `admin_user_invitation` | Invitation administrateur |
| `verify_email` | Vérifiez votre email |
| `email_changed` | Email modifié |
| `password_changed` | Mot de passe modifié |
| `password_reset` | Réinitialisation du mot de passe |
| `otp`, `otp_*` | Votre code de vérification |

### 7.10 CRM (admin)

| Slug | Titre |
|---|---|
| `crm_match_detected` | Correspondance CRM détectée |
| `crm_artifact_ingested` | Artefact CRM importé |
| `crm_task_overdue` | Tâche CRM en retard |
| `crm_document_blocking` | Document CRM bloquant |

---

## 8. Articulation avec les push notifications (OneSignal)

Vue détaillée : [docs/03-guides/MOBILE_PUSH_INTEGRATION_ONESIGNAL.md](../03-guides/MOBILE_PUSH_INTEGRATION_ONESIGNAL.md) et [docs/03-guides/PUSH_NOTIFICATIONS_CATALOG.md](../03-guides/PUSH_NOTIFICATIONS_CATALOG.md).

### 8.1 Enregistrement du device

Au login, l'app envoie son subscription ID OneSignal :

`POST /api/v1/device-tokens`

```json
{
  "provider": "onesignal",
  "token": "<onesignal_subscription_id>",
  "subscription_id": "<uuid>",
  "external_user_id": "<user.onesignalId>",
  "platform": "ios"
}
```

### 8.2 Push payload reçu par l'app

OneSignal délivre une payload avec `additionalData` qui contient au minimum :

```json
{
  "type": "booking_confirmed",
  "action": "/bookings/0193a8c4-...",
  // + identifiants métier (booking_id, event_id, etc.)
}
```

**Au tap du push** :

1. Lire `additionalData.action` (= `action_url`).
2. Naviguer vers l'écran natif correspondant.
3. **Refetch** `GET /v1/notifications/unread-count` puis (si la page notif est ouverte) `GET /v1/notifications` pour aligner l'état.

### 8.3 Quelles actions déclenchent un push ?

20 notifications sont aujourd'hui push-enabled (cf. catalogue). Toutes les autres existent en in-app uniquement (DB + WebSocket).

---

## 9. Implémentation côté Flutter — recommandations

### 9.1 Stack conseillée

| Besoin | Package |
|---|---|
| REST | `dio` ou `http` |
| WebSocket Pusher/Reverb | `pusher_channels_flutter` ou `laravel_echo` + `pusher-js` adapter |
| Push notifications | `onesignal_flutter` |
| State management | Riverpod / Bloc (au choix) |

### 9.2 Structure de données Dart suggérée

```dart
class AppNotification {
  final String id;
  final String type;
  final String title;
  final String message;
  final String? actionUrl;
  final Map<String, dynamic> data;
  final DateTime? readAt;
  final bool isRead;
  final DateTime createdAt;

  factory AppNotification.fromJson(Map<String, dynamic> json) => AppNotification(
    id: json['id'] as String,
    type: json['type'] as String,
    title: json['title'] as String,
    message: json['message'] as String,
    actionUrl: json['action_url'] as String?,
    data: Map<String, dynamic>.from(json['data'] as Map),
    readAt: json['read_at'] != null ? DateTime.parse(json['read_at']) : null,
    isRead: json['is_read'] as bool,
    createdAt: DateTime.parse(json['created_at']),
  );
}
```

### 9.3 Setup Pusher → Reverb (extrait)

```dart
final pusher = PusherChannelsFlutter.getInstance();

await pusher.init(
  apiKey: 'lehiboo-local-key',          // REVERB_APP_KEY
  cluster: 'mt1',                        // non utilisé par Reverb mais requis par le SDK
  onAuthorizer: (channelName, socketId, _) async {
    final res = await dio.post(
      '/broadcasting/auth',
      data: {'socket_id': socketId, 'channel_name': channelName},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return res.data;
  },
  onEvent: (event) {
    if (event.eventName == 'notification.created') {
      final payload = jsonDecode(event.data) as Map<String, dynamic>;
      final notif = AppNotification.fromJson(payload['notification']);
      final unread = payload['unread_count'] as int;
      // → prepend à la liste, MAJ badge
    }
  },
  // host/port via config flavor (REVERB_HOST/REVERB_PORT/REVERB_SCHEME)
);

await pusher.subscribe(channelName: 'private-user.${user.id}');
await pusher.connect();
```

### 9.4 Cycle de vie de la page notifications

```
onScreenOpen:
  1. fetch GET /v1/notifications?per_page=20
  2. subscribe private-user.{userId}, listen "notification.created"
  3. afficher loader / vide / liste

onNotificationReceived (WebSocket):
  - prepend notification à la liste in-memory
  - badgeCount = payload.unread_count

onPullToRefresh:
  - refetch page 1

onScrollToBottom:
  - fetch page suivante (links.next ou meta.current_page + 1)

onTapNotification(n):
  - if (!n.isRead) → POST /v1/notifications/{n.id}/read (optimiste)
  - if (n.actionUrl != null) → navigate(n.actionUrl)

onTapMarkAllRead:
  - POST /v1/notifications/read-all
  - flush local state, badgeCount = 0

onTapDelete(n):
  - DELETE /v1/notifications/{n.id}
  - remove de la liste locale

onScreenClose:
  - unsubscribe private-user.{userId}

onAppResume:
  - reconnect WS si déconnecté
  - refetch badge (et liste si visible)
```

### 9.5 Mapping `action_url` → routes Flutter

Convention serveur : chemins relatifs façon web. Mobile mappe vers ses routes natives :

| `action_url` pattern | Route mobile |
|---|---|
| `/bookings/{uuid}` | `BookingDetailPage(uuid)` |
| `/events/{slug}` | `EventDetailPage(slug)` |
| `/messages/{conversation_uuid}` | `ConversationPage(uuid)` |
| `/messages/support/{conversation_uuid}` | `SupportConversationPage(uuid)` |
| `/search?alert={uuid}` | `SearchPage(alertUuid: uuid)` |
| `/vendor/members` | `VendorMembersPage` |
| `/vendor/documents` | `VendorDocumentsPage` |
| `/vendor/reviews?review={uuid}` | `VendorReviewsPage(reviewUuid: uuid)` |
| `null` | aucune action — tap juste mark-as-read |

Si l'URL ne matche aucun pattern → fallback : juste mark-as-read sans navigation.

---

## 10. Codes d'erreur

| Code | Cause | Réponse |
|---|---|---|
| 401 | Token absent / invalide / expiré | `{ "message": "Unauthenticated.", "error": "unauthenticated" }` |
| 403 | Tentative de subscription à un channel non autorisé (WS) | Le SDK Pusher remonte une erreur sur le channel |
| 404 | UUID invalide ou notification non trouvée | `{ "message": "Notification non trouvée." }` |
| 422 | Param de validation invalide (rare ici) | Format Laravel standard `errors: {...}` |
| 429 | Rate-limit dépassé | Headers `Retry-After` |

---

## 11. Checklist QA mobile

- [ ] Liste paginée s'affiche, scroll infinite OK
- [ ] Pull-to-refresh refetch la page 1
- [ ] Badge unread visible et synchronisé (badge OS + UI)
- [ ] Tap → mark-as-read optimiste + navigation
- [ ] Mark all → toutes lues, badge à 0
- [ ] Delete → disparait de la liste
- [ ] App au foreground : nouvelle notification arrive en live (sans refresh manuel)
- [ ] App en arrière-plan : push reçu, tap ouvre le bon écran
- [ ] Reconnexion WS après perte réseau (mode avion → on/off)
- [ ] Filtre `context=participant` masque les notifs vendor (et inverse)
- [ ] Logout → unsubscribe WS, désenregistrement du device token
- [ ] Type inconnu → titre par défaut « Notification », pas de crash
- [ ] `action_url=null` → tap = mark-as-read seul, pas de navigation

---

## 12. Fichiers de référence côté backend

| Fichier | Rôle |
|---|---|
| `api/routes/api.php:832-840` | Définition des routes notifications |
| `api/app/Http/Controllers/Api/V1/NotificationController.php` | Endpoints REST + logique de contexte |
| `api/app/Http/Resources/NotificationResource.php` | Format de sortie + `defaultTitle()` / `defaultMessage()` |
| `api/app/Events/InAppNotificationCreated.php` | Event WebSocket — channel + payload |
| `api/routes/channels.php` | Authorization des channels privés |
| `api/config/broadcasting.php` | Driver Reverb |
| `api/app/Notifications/*` | Toutes les classes Notification (~80 fichiers) |
| `api/app/Notifications/Concerns/HasPushNotification.php` | Trait pour activer le push OneSignal |
| `frontend/src/lib/hooks/use-realtime-notifications.ts` | Implémentation web de référence (events écoutés, query invalidation) |
| `frontend/src/lib/hooks/use-notifications.ts` | Implémentation web REST + cache |

Côté docs :

- `docs/03-guides/PUSH_NOTIFICATIONS_CATALOG.md` — quelles actions envoient un push
- `docs/03-guides/MOBILE_PUSH_INTEGRATION_ONESIGNAL.md` — intégration OneSignal Flutter
- `docs/03-guides/MIGRATION_FCM_TO_ONESIGNAL.md` — historique migration

---

## 13. Évolutions à anticiper

- **Pagination cursor-based** : pas en place aujourd'hui, mais probable pour l'infinite scroll long. Surveiller `meta.next_cursor` à l'avenir.
- **Localisation** : les `title` / `message` sont aujourd'hui calculés **côté serveur en français**. Si i18n côté mobile devient prioritaire, ce sera côté API qu'il faudra exposer une clé i18n + params au lieu d'une string. Pas le cas actuellement.
- **Filtres avancés** : pas de filtre par date / par groupe de types côté API aujourd'hui. À demander si besoin.
- **`unread_count` par contexte** : déjà supporté via `?context=...&organization_id=...`.

---

**Dernière MAJ :** 2026-05-12
**Owner :** équipe backend Le Hiboo — ouvrir un ticket si un slug manque ou si un payload évolue.
