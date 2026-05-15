# Catalogue des évènements Pusher

Documentation exhaustive de tous les évènements diffusés en temps réel via Pusher (driver `BROADCAST_CONNECTION=pusher`) par l'API Laravel.

> **Source** : `api/app/Events/*.php` (classes implémentant `Illuminate\Contracts\Broadcasting\ShouldBroadcast`)
>
> **Authorization des channels** : `api/routes/channels.php`
>
> **Config broadcasting** : `api/config/broadcasting.php`

---

## Sommaire

1. [Configuration & channels](#1-configuration--channels)
2. [Conventions de payload](#2-conventions-de-payload)
3. [Notifications in-app (générique)](#3-notifications-in-app-générique)
4. [Bookings](#4-bookings)
5. [Tickets / Check-ins](#5-tickets--check-ins)
6. [Events (publication / annulation)](#6-events-publication--annulation)
7. [Conversations](#7-conversations)
8. [Messages](#8-messages)
9. [Collaborations (event collaborators)](#9-collaborations-event-collaborators)
10. [Partnerships (org ↔ org)](#10-partnerships-org--org)
11. [Organizations (admin lifecycle)](#11-organizations-admin-lifecycle)
12. [Payouts](#12-payouts)
13. [Évènements non broadcastés](#13-évènements-non-broadcastés)

---

## 1. Configuration & channels

### Driver

```env
BROADCAST_CONNECTION=pusher
PUSHER_APP_ID=...
PUSHER_APP_KEY=...
PUSHER_APP_SECRET=...
PUSHER_APP_CLUSTER=eu
```

Voir [api/config/broadcasting.php](../../api/config/broadcasting.php).

### Channels privés et autorisations

Toutes les channels listées dans ce catalogue sont **privées** (préfixe `private-` côté Pusher). L'autorisation est gérée dans [api/routes/channels.php](../../api/routes/channels.php) :

| Channel | Autorisation |
|---------|-------------|
| `user.{userId}` | Seul l'utilisateur dont `id === userId` |
| `organization.{organizationId}` | Owner OU membre actif de l'organisation |
| `event.{eventId}.updates` | Owner / membres actifs de l'org OU collaborator `accepted` |
| `event.{eventId}.checkins` | Mêmes règles que `event.{eventId}.updates` |
| `admin.{scope}` | Utilisateur avec rôle admin (`isAdmin()`) |
| `vendor.{vendorId}` *(deprecated)* | Backward-compat, route vers la logique organization |
| `events` *(public)* | Channel publique pour les listings (aucune auth) |

Le trait [api/app/Events/Concerns/BroadcastableEvent.php](../../api/app/Events/Concerns/BroadcastableEvent.php) fournit les helpers `userChannel()`, `organizationChannel()`, `eventUpdatesChannel()`, `eventCheckinsChannel()`, `adminChannel()`.

### Conventions de nommage

- Nom de l'évènement côté wire : `broadcastAs()` → snake_case point-séparé (`booking.confirmed`, `message.received`)
- Payload côté wire : `broadcastWith()` → snake_case
- Tous les timestamps sont au format ISO 8601 (`toIso8601String()`)

---

## 2. Conventions de payload

Tous les payloads partagent ces traits :

- **Identifiants** : on expose souvent `id` (entier interne) **et** `uuid` (string public). Le client mobile/web doit privilégier `uuid` quand disponible.
- **Timestamps** : ISO 8601 (`2026-05-13T14:32:01+00:00`)
- **Champs `*_id`** : références entières internes (utiles pour matcher avec d'autres évènements reçus pendant la session)

---

## 3. Notifications in-app (générique)

> Évènement transverse qui diffuse **toutes** les `DatabaseNotification` Laravel vers le user concerné. C'est le canal recommandé pour le centre de notifications mobile/web.

### `notification.created`

| Trait | Valeur |
|-------|--------|
| **Classe** | `App\Events\InAppNotificationCreated` |
| **Channel** | `private-user.{notifiable_id}` |
| **Trigger** | Tout `DatabaseNotification::created` sur un `User` — déclenché automatiquement par Laravel quand `$user->notify(...)` stocke une notif en base. Hook dans [api/app/Providers/AppServiceProvider.php:114-120](../../api/app/Providers/AppServiceProvider.php) |
| **`ShouldDispatchAfterCommit`** | Oui |

**Payload** :

```json
{
  "notification": {
    "id": "uuid",
    "type": "booking_confirmed",
    "title": "...",
    "message": "...",
    "data": { "...": "..." },
    "read_at": null,
    "created_at": "2026-05-13T..."
  },
  "unread_count": 12,
  "occurred_at": "2026-05-13T14:32:01+00:00"
}
```

Le sous-objet `notification` correspond à [`NotificationResource`](../../api/app/Http/Resources/NotificationResource.php). Voir aussi [CRITIQUE - Convention Notifications](../../CLAUDE.md#critique---convention-notifications).

---

## 4. Bookings

### `booking.created`

| Trait | Valeur |
|-------|--------|
| **Classe** | `App\Events\BookingCreated` |
| **Channels** | `private-user.{booking.user_id}` *(si user_id)*, `private-organization.{event.organization_id}`, `private-event.{event_id}.updates` |
| **Trigger** | Création d'une réservation. Dispatché par `BookingService::create()` (api/app/Services/BookingService.php:213, 340) et `BusinessBookingService::create()` (:163). **Note** : la réservation n'est pas encore payée. |

```json
{
  "booking_id": 1234,
  "booking_uuid": "uuid",
  "event_id": 99,
  "total_amount": 4500,
  "created_at": "2026-05-13T..."
}
```

---

### `booking.confirmed`

| Trait | Valeur |
|-------|--------|
| **Classe** | `App\Events\BookingConfirmed` |
| **Channels** | `private-user.{booking.user_id}`, `private-organization.{org_id}`, `private-event.{event_id}.updates` |
| **Trigger** | Paiement Stripe validé. Dispatché par `OrderService::handleSuccessfulPayment()` (api/app/Services/OrderService.php:1058, 1084). |
| **Interfaces** | `ShouldBroadcast`, `ShouldDispatchAfterCommit`, `ShouldRescue` |

```json
{
  "booking_id": 1234,
  "booking_uuid": "uuid",
  "event_id": 99,
  "total_amount": 4500,
  "confirmed_at": "2026-05-13T..."
}
```

---

### `booking.cancelled`

| Trait | Valeur |
|-------|--------|
| **Classe** | `App\Events\BookingCancelled` |
| **Channels** | `private-user.{booking.user_id}`, `private-organization.{org_id}` |
| **Trigger** | Annulation d'une réservation. Dispatché par `BookingService::cancel()` (api/app/Services/BookingService.php:439). |

```json
{
  "booking_id": 1234,
  "booking_uuid": "uuid",
  "event_id": 99,
  "reason": "Annulation client",
  "cancelled_at": "2026-05-13T..."
}
```

---

### `booking.refunded`

| Trait | Valeur |
|-------|--------|
| **Classe** | `App\Events\BookingRefunded` |
| **Channels** | `private-user.{booking.user_id}`, `private-organization.{org_id}` |
| **Trigger** | Remboursement Stripe (total ou partiel). Dispatché par `BookingService::refund()` (api/app/Services/BookingService.php:502) et `ProcessEventCancellationRefunds::handle()` (api/app/Listeners/ProcessEventCancellationRefunds.php:160) lors de l'annulation d'un évènement. |

```json
{
  "booking_id": 1234,
  "booking_uuid": "uuid",
  "refund_amount": 4500,
  "is_partial": false,
  "refunded_at": "2026-05-13T..."
}
```

---

## 5. Tickets / Check-ins

### `ticket.checked_in`

| Trait | Valeur |
|-------|--------|
| **Classe** | `App\Events\TicketCheckedIn` |
| **Channels** | `private-user.{ticket.booking.user_id}`, `private-event.{event_id}.checkins`, `private-organization.{event.organization_id}` |
| **Trigger** | Premier scan QR validé. Dispatché par `TicketService::checkIn()` (api/app/Services/TicketService.php:215). |

```json
{
  "ticket_id": 5,
  "ticket_uuid": "uuid",
  "qr_code": "QR-XYZ...",
  "event_id": 99,
  "checked_in_at": "2026-05-13T...",
  "scan_location": "Entrée Nord",
  "attendee_name": "Jean Dupont"
}
```

---

### `ticket.re_entered`

| Trait | Valeur |
|-------|--------|
| **Classe** | `App\Events\TicketReEntered` |
| **Channels** | `private-event.{event_id}.checkins`, `private-organization.{event.organization_id}` |
| **Trigger** | Scan d'un ticket **déjà** en état `CheckedIn` (re-entry). Dispatché par `TicketService` (api/app/Services/TicketService.php:183). **Ne touche PAS** la channel utilisateur (évite de re-spammer le client à chaque scan de portique). |

```json
{
  "ticket_id": 5,
  "ticket_uuid": "uuid",
  "qr_code": "QR-XYZ...",
  "event_id": 99,
  "scanned_at": "2026-05-13T...",
  "scan_location": "Entrée Sud",
  "check_in_count": 2,
  "attendee_name": "Jean Dupont"
}
```

---

### `ticket.transferred`

| Trait | Valeur |
|-------|--------|
| **Classe** | `App\Events\TicketTransferred` |
| **Channels** | `private-user.{fromUser.id}` *(uniquement l'ancien propriétaire)* |
| **Trigger** | Transfert d'un billet à un autre email. Dispatché par `TicketService::transfer()` (api/app/Services/TicketService.php:291). |

```json
{
  "ticket_id": 5,
  "event_id": 99,
  "from_user_id": 42,
  "to_email": "ami@example.com",
  "transferred_at": "2026-05-13T..."
}
```

---

## 6. Events (publication / annulation)

### `event.published`

| Trait | Valeur |
|-------|--------|
| **Classe** | `App\Events\EventPublished` |
| **Channels** | `events` *(channel publique)*, `private-organization.{org_id}` |
| **Trigger** | Publication manuelle d'un évènement par `EventService::publish()` (api/app/Services/EventService.php:1465) ou publication planifiée par le job `PublishScheduledEvents` (api/app/Jobs/PublishScheduledEvents.php:59). |

```json
{
  "event_id": 99,
  "event_uuid": "uuid",
  "title": "Festival d'été",
  "slug": "festival-ete",
  "organization_id": 7,
  "published_at": "2026-05-13T..."
}
```

---

### `event.unpublished`

| Trait | Valeur |
|-------|--------|
| **Classe** | `App\Events\EventUnpublished` |
| **Channels** | `private-vendor.{event.vendor_id}` *(legacy — utilise encore le channel deprecated `vendor.*`)* |
| **Trigger** | Dépublication par `EventService::unpublish()` (api/app/Services/EventService.php:1489). |

```json
{
  "event_id": 99,
  "title": "Festival d'été",
  "slug": "festival-ete",
  "vendor_id": 7,
  "unpublished_at": "2026-05-13T..."
}
```

> **Note de migration** : ce broadcast utilise encore l'ancienne channel `vendor.{id}` (deprecated). À harmoniser sur `organization.{id}` dans une prochaine itération.

---

### `event.cancelled`

| Trait | Valeur |
|-------|--------|
| **Classe** | `App\Events\EventCancelled` |
| **Channels** | `events` *(publique)*, `private-organization.{org_id}`, `private-event.{event_id}.updates` |
| **Trigger** | Annulation d'un évènement par `EventService::cancel()` (api/app/Services/EventService.php:1685). Déclenche aussi en cascade les `booking.refunded` via le listener `ProcessEventCancellationRefunds`. |

```json
{
  "event_id": 99,
  "event_uuid": "uuid",
  "title": "Festival d'été",
  "reason": "Conditions météo",
  "cancelled_at": "2026-05-13T..."
}
```

---

## 7. Conversations

### `conversation.created`

| Trait | Valeur |
|-------|--------|
| **Classe** | `App\Events\ConversationCreated` |
| **Channels** (selon le type) | `private-organization.{organization_id}`, `private-organization.{partner_organization_id}`, `private-user.{admin_id}`, `private-user.{participant_id}` |
| **Trigger** | Ouverture d'une conversation. Dispatché par `ConversationController::openSupportThread()`, `storeDirectMessage()`, `storeGroupMessage()` (api/app/Http/Controllers/Api/V1/ConversationController.php:254, 311, 373) et `ParticipantConversationController::storeDirectMessage()` (:483). |

```json
{
  "conversation_uuid": "uuid",
  "conversation_type": "participant_vendor",
  "subject": "Question sur le festival",
  "created_at": "2026-05-13T..."
}
```

---

### `conversation.closed`

| Trait | Valeur |
|-------|--------|
| **Classe** | `App\Events\ConversationClosed` |
| **Channels** | participant, organization, admin, partner_organization (selon présence) |
| **Trigger** | Fermeture d'une conversation. **Aucun appel `event()` ou `dispatch()` n'est trouvé dans le code applicatif** — vraisemblablement déclenché via un observer/model event sur `Conversation`, ou pas encore branché. |

```json
{
  "conversation_uuid": "uuid",
  "closed_at": "2026-05-13T..."
}
```

---

### `conversation.read`

| Trait | Valeur |
|-------|--------|
| **Classe** | `App\Events\ConversationRead` |
| **Channels** | L'autre partie (pas le lecteur) : `private-user.{other_participant_id}`, `private-organization.{org}`, `private-organization.{partner_org}`, `private-user.{admin_id}` |
| **Trigger** | Marquage des messages comme lus. `ConversationController::markAsRead()` (api/app/Http/Controllers/Api/V1/ConversationController.php:517) ou `Conversation::markMessagesAsRead()` (api/app/Models/Conversation.php:256). Seulement si `messagesReadCount > 0`. |

```json
{
  "conversation_uuid": "uuid",
  "reader_id": 42,
  "reader_name": "Jean Dupont",
  "messages_read_count": 3,
  "read_at": "2026-05-13T..."
}
```

> Permet à l'UI de l'expéditeur de basculer ses tick "Délivré" → "Lu" en temps réel.

---

### `conversation.reopened`

| Trait | Valeur |
|-------|--------|
| **Classe** | `App\Events\ConversationReopened` |
| **Channels** | participant, organization, admin, partner_organization (selon présence) |
| **Trigger** | Réouverture d'une conversation fermée. `ConversationController::openSupportThread()` quand `wasReopened` (api/app/Http/Controllers/Api/V1/ConversationController.php:256) et `ConversationController::reopen()` (:567). |

```json
{
  "conversation_uuid": "uuid",
  "reopened_at": "2026-05-13T..."
}
```

---

### `conversation.reported`

| Trait | Valeur |
|-------|--------|
| **Classe** | `App\Events\ConversationReported` |
| **Channels** | `private-admin.conversations` |
| **Trigger** | Signalement d'une conversation par un user. `ParticipantConversationController::report()` (api/app/Http/Controllers/Api/V1/ParticipantConversationController.php:760). |

```json
{
  "report_uuid": "uuid",
  "conversation_uuid": "uuid",
  "reason": "spam"
}
```

---

## 8. Messages

### `message.received`

| Trait | Valeur |
|-------|--------|
| **Classe** | `App\Events\MessageSent` |
| **Channels** (selon contexte) | `private-user.{participant_id}`, `private-organization.{organization_id}`, `private-user.{admin_id}`, `private-organization.{partner_organization_id}` |
| **Trigger** | **Création d'un message** — déclenché par Eloquent `$dispatchesEvents = ['created' => MessageSent::class]` dans [api/app/Models/Message.php:57](../../api/app/Models/Message.php). |

```json
{
  "message_uuid": "uuid",
  "conversation_uuid": "uuid",
  "sender_type": "participant",
  "sender_name": "Jean Dupont",
  "content_preview": "Bonjour, j'ai une question...",
  "conversation_subject": "Question sur le festival",
  "created_at": "2026-05-13T..."
}
```

> Le contenu est **tronqué à 100 caractères** (`content_preview`). Le client doit faire un fetch complet pour afficher le message en entier.

---

### `message.edited`

| Trait | Valeur |
|-------|--------|
| **Classe** | `App\Events\MessageEdited` |
| **Channels** | mêmes que `message.received` |
| **Trigger** | Édition d'un message. `ConversationController::update()` (api/app/Http/Controllers/Api/V1/ConversationController.php:614). |

```json
{
  "message_uuid": "uuid",
  "conversation_uuid": "uuid",
  "content": "Contenu édité complet",
  "edited_at": "2026-05-13T..."
}
```

---

### `message.deleted`

| Trait | Valeur |
|-------|--------|
| **Classe** | `App\Events\MessageDeleted` |
| **Channels** | mêmes que `message.received` |
| **Trigger** | Suppression d'un message. `ConversationController::destroy()` (api/app/Http/Controllers/Api/V1/ConversationController.php:653). |

```json
{
  "message_uuid": "uuid",
  "conversation_uuid": "uuid",
  "deleted_at": "2026-05-13T..."
}
```

---

### `message.delivered`

| Trait | Valeur |
|-------|--------|
| **Classe** | `App\Events\MessageDelivered` |
| **Channels** | **Seulement l'expéditeur initial** (pour flipper son tick "Envoyé" → "Délivré") :<br>• `private-user.{sender_id}` si sender = participant ou admin<br>• `private-organization.{org_id}` (+ partner_org) si sender = organization |
| **Trigger** | Listener `SendMessageNotification::handle(MessageSent)` quand `delivered_at` est null (api/app/Listeners/SendMessageNotification.php:31). |

```json
{
  "message_uuid": "uuid",
  "conversation_uuid": "uuid",
  "delivered_at": "2026-05-13T..."
}
```

---

## 9. Collaborations (event collaborators)

### `collaboration.invited`

| Trait | Valeur |
|-------|--------|
| **Classe** | `App\Events\CollaborationInviteSent` |
| **Channels** | `private-organization.{collaborator.organization_id}` |
| **Trigger** | Invitation envoyée à une org pour collaborer sur un event. `EventCollaboratorService::invite()` et `reinvite()` (api/app/Services/EventCollaboratorService.php:153, 388). |

```json
{
  "collaborator_id": 12,
  "collaborator_uuid": "uuid",
  "event_id": 99,
  "event_title": "Festival d'été",
  "role": "co_organizer",
  "invited_by": "Marie Curie",
  "created_at": "2026-05-13T..."
}
```

---

### `collaboration.accepted`

| Trait | Valeur |
|-------|--------|
| **Classe** | `App\Events\CollaborationAccepted` |
| **Channels** | `private-organization.{event.organization_id}` *(propriétaire)*, `private-organization.{collaborator.organization_id}`, `private-user.{collaborator.user_id}` |
| **Trigger** | Acceptation d'une invitation collaborator. `EventCollaboratorInvitationService::accept()` (api/app/Services/EventCollaboratorInvitationService.php:133). |

```json
{
  "collaborator_id": 12,
  "collaborator_uuid": "uuid",
  "event_id": 99,
  "event_title": "Festival d'été",
  "organization_id": 8,
  "organization_name": "AssoXYZ",
  "role": "co_organizer",
  "accepted_at": "2026-05-13T..."
}
```

---

### `collaboration.rejected`

| Trait | Valeur |
|-------|--------|
| **Classe** | `App\Events\CollaborationRejected` |
| **Channels** | `private-organization.{event.organization_id}` *(propriétaire de l'event)* |
| **Trigger** | Rejet d'une invitation collaborator par l'org invitée. `EventCollaboratorService::reject()` (api/app/Services/EventCollaboratorService.php:200). |

```json
{
  "collaborator_id": 12,
  "collaborator_uuid": "uuid",
  "event_id": 99,
  "event_title": "Festival d'été",
  "organization_id": 8,
  "organization_name": "AssoXYZ",
  "role": "co_organizer"
}
```

---

### `collaboration.removed`

| Trait | Valeur |
|-------|--------|
| **Classe** | `App\Events\CollaborationRemoved` |
| **Channels** | `private-organization.{collaborator.organization_id}` *(l'org retirée)* |
| **Trigger** | Retrait manuel d'un collaborator. `EventCollaboratorService::remove()` (api/app/Services/EventCollaboratorService.php:251). |

```json
{
  "collaborator_id": 12,
  "collaborator_uuid": "uuid",
  "event_id": 99,
  "event_title": "Festival d'été"
}
```

---

### `collaborator.invitation.declined`

| Trait | Valeur |
|-------|--------|
| **Classe** | `App\Events\CollaboratorInvitationDeclined` |
| **Channels** | `private-organization.{invitation.event.organization_id}` |
| **Trigger** | Une invitation par **email** (pas par org) est déclinée. `EventCollaboratorInvitationService::decline()` (api/app/Services/EventCollaboratorInvitationService.php:150). |

```json
{
  "invitation_id": 33,
  "invitation_uuid": "uuid",
  "event_id": 99,
  "event_title": "Festival d'été",
  "email": "invitee@example.com",
  "role": "co_organizer"
}
```

---

## 10. Partnerships (org ↔ org)

### `partnership.invited`

| Trait | Valeur |
|-------|--------|
| **Classe** | `App\Events\PartnershipInvited` |
| **Channels** | `private-organization.{partner_organization_id}` *(seulement si l'invité a un compte existant)* |
| **Trigger** | Création d'un partenariat. `PartnershipService::invite()` (api/app/Services/PartnershipService.php:113). |

```json
{
  "partnership_id": "uuid",
  "inviter_name": "Acme Corp",
  "invited_at": "2026-05-13T..."
}
```

---

### `partnership.accepted`

| Trait | Valeur |
|-------|--------|
| **Classe** | `App\Events\PartnershipAccepted` |
| **Channels** | `private-organization.{partnership.organization_id}` *(l'org qui avait initié)* |
| **Trigger** | Acceptation d'un partenariat. `PartnershipService::accept()` (api/app/Services/PartnershipService.php:141). |

```json
{
  "partnership_id": "uuid",
  "partner_name": "AssoXYZ",
  "accepted_at": "2026-05-13T..."
}
```

---

## 11. Organizations (admin lifecycle)

### `organization.registered`

| Trait | Valeur |
|-------|--------|
| **Classe** | `App\Events\OrganizationRegistered` |
| **Channels** | `private-admin.organizations` |
| **Trigger** | Inscription d'une nouvelle organisation. `OrganizationService::register()` (api/app/Services/OrganizationService.php:153). Sert à alerter l'admin pour qu'il modère. |

```json
{
  "organization_id": 7,
  "organization_name": "Acme Corp",
  "user_id": 42,
  "registered_at": "2026-05-13T..."
}
```

---

### `organization.approved`

| Trait | Valeur |
|-------|--------|
| **Classe** | `App\Events\OrganizationApproved` |
| **Channels** | `private-organization.{organization_id}`, `private-user.{organization.user_id}` |
| **Trigger** | Modération admin OK. `Admin\OrganizationController::approve()` (api/app/Http/Controllers/Api/V1/Admin/OrganizationController.php:405) et `Admin\VendorController::approve()` (:106). |

```json
{
  "organization_id": 7,
  "organization_uuid": "uuid",
  "organization_name": "Acme Corp",
  "approved_at": "2026-05-13T..."
}
```

---

### `organization.rejected`

| Trait | Valeur |
|-------|--------|
| **Classe** | `App\Events\OrganizationRejected` |
| **Channels** | `private-organization.{organization_id}`, `private-user.{organization.user_id}` |
| **Trigger** | Modération admin KO. `Admin\VendorController::reject()` (api/app/Http/Controllers/Api/V1/Admin/VendorController.php:134). |

```json
{
  "organization_id": 7,
  "organization_uuid": "uuid",
  "organization_name": "Acme Corp",
  "reason": "Documents manquants",
  "rejected_at": "2026-05-13T..."
}
```

---

### `organization.verified`

| Trait | Valeur |
|-------|--------|
| **Classe** | `App\Events\OrganizationVerified` |
| **Channels** | `private-organization.{organization_id}` |
| **Trigger** | Vérification complète (badge "verified"). `OrganizationService::verify()` (api/app/Services/OrganizationService.php:553). |

```json
{
  "organization_id": 7,
  "organization_name": "Acme Corp",
  "verified_at": "2026-05-13T..."
}
```

---

### `organization.suspended`

| Trait | Valeur |
|-------|--------|
| **Classe** | `App\Events\OrganizationSuspended` |
| **Channels** | `private-organization.{organization_id}` |
| **Trigger** | Suspension admin. `OrganizationService::suspend()` (api/app/Services/OrganizationService.php:591). |

```json
{
  "organization_id": 7,
  "reason": "Violation des CGU",
  "suspended_at": "2026-05-13T..."
}
```

---

### `organization.reactivated`

| Trait | Valeur |
|-------|--------|
| **Classe** | `App\Events\OrganizationReactivated` |
| **Channels** | `private-organization.{organization_id}` |
| **Trigger** | Réactivation admin après une suspension. `OrganizationService::reactivate()` (api/app/Services/OrganizationService.php:630). |

```json
{
  "organization_id": 7,
  "reactivated_at": "2026-05-13T..."
}
```

---

## 12. Payouts

> ⚠️ Les classes `PayoutRequested`, `PayoutCompleted` et `PayoutCancelled` existent et déclarent leurs channels/payloads, mais **aucun appel `event(new Payout...)` n'a été trouvé dans le code applicatif**. Probablement à brancher depuis le module Stripe Connect / webhook quand la feature payout sera finalisée. À documenter ici quand le câblage sera fait.

### `payout.requested` *(défini, pas encore émis)*

| Trait | Valeur |
|-------|--------|
| **Classe** | `App\Events\PayoutRequested` |
| **Channels** | `private-organization.{organization_id}` |
| **Trigger** | Demande de versement initié par un vendor (TBD). |

```json
{
  "organization_id": 7,
  "amount": 45000,
  "payout_reference": "PO-2026-0001",
  "requested_at": "2026-05-13T..."
}
```

---

### `payout.completed` *(défini, pas encore émis)*

| Trait | Valeur |
|-------|--------|
| **Classe** | `App\Events\PayoutCompleted` |
| **Channels** | `private-organization.{organization_id}` |
| **Trigger** | Versement effectué (webhook Stripe Connect) (TBD). |

```json
{
  "organization_id": 7,
  "amount": 45000,
  "payout_reference": "PO-2026-0001",
  "completed_at": "2026-05-13T..."
}
```

---

### `payout.cancelled` *(défini, pas encore émis)*

| Trait | Valeur |
|-------|--------|
| **Classe** | `App\Events\PayoutCancelled` |
| **Channels** | `private-organization.{organization_id}` |
| **Trigger** | Versement annulé (TBD). |

```json
{
  "organization_id": 7,
  "amount": 45000,
  "payout_reference": "PO-2026-0001",
  "reason": "...",
  "cancelled_at": "2026-05-13T..."
}
```

---

## 13. Évènements non broadcastés

Pour mémoire, les évènements suivants existent dans `api/app/Events/` mais **n'implémentent pas `ShouldBroadcast`** — ils sont consommés uniquement par des listeners serveur (emails, jobs, observers) et **ne génèrent aucun trafic Pusher** :

| Classe | Usage |
|--------|-------|
| `TicketsGenerated` | Trigger des emails de billets + génération PDF |
| `DocumentUploaded` / `DocumentApproved` / `DocumentRejected` | Workflow de modération KYC |
| `NewEventsMatchingAlert` | Système d'alertes saved searches (job hourly) |
| `PasswordChanged` | Email de sécurité |
| `SubscriptionCreated` / `Cancelled` / `Renewed` / `Resumed` / `PaymentFailed` / `PlanChanged` / `PlanScheduled` | Lifecycle abonnement vendor |
| `OrganizationHibonsPurchased` / `Distributed` / `Reclaimed` | Wallet interne Hibons |

Si un jour l'un de ces évènements doit pousser une notif temps réel à l'utilisateur, le pattern recommandé est de **ne pas** ajouter `ShouldBroadcast` directement mais d'envoyer une `Notification` via `$user->notify(...)`. Elle sera automatiquement repoussée par `InAppNotificationCreated` (cf. §3) sur la channel `user.{id}`.

---

## Annexe — Côté client (Echo)

Configuration recommandée pour s'abonner aux channels :

```ts
import Echo from 'laravel-echo';
import Pusher from 'pusher-js';

window.Pusher = Pusher;
const echo = new Echo({
  broadcaster: 'pusher',
  key: import.meta.env.NEXT_PUBLIC_PUSHER_APP_KEY,
  cluster: import.meta.env.NEXT_PUBLIC_PUSHER_APP_CLUSTER,
  forceTLS: true,
  authEndpoint: `${API_URL}/broadcasting/auth`,
  auth: { headers: { Authorization: `Bearer ${token}` } },
});

// Notifications in-app (universel)
echo.private(`user.${userId}`)
  .listen('.notification.created', (data) => { /* ... */ })
  .listen('.booking.confirmed', (data) => { /* ... */ })
  .listen('.ticket.checked_in', (data) => { /* ... */ });

// Dashboard vendor temps réel
echo.private(`organization.${orgId}`)
  .listen('.booking.created', ...)
  .listen('.message.received', ...);

// Dashboard live check-in
echo.private(`event.${eventId}.checkins`)
  .listen('.ticket.checked_in', ...)
  .listen('.ticket.re_entered', ...);
```

> **Important** : le `.` (point) devant le nom d'évènement est nécessaire côté Echo pour matcher `broadcastAs()` au lieu du nom de classe.
