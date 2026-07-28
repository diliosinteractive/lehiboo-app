# In-App Notifications Mobile Spec

Audience: mobile app team (Flutter)
Status: backend contract implemented
Scope: in-app notification inbox, unread badge, read/delete actions, and realtime delivery through Laravel Reverb.

This spec covers foreground/in-app notifications. Lock-screen push notifications are a separate channel; see `docs/05-reference/PUSH_NOTIFICATIONS_MOBILE_SPEC.md`.

## What already exists

Backend:

- Notifications are stored in Laravel's `notifications` table.
- The authenticated API exposes list, unread count, show, mark-read, mark-all-read, delete-one, and delete-read endpoints under `/api/v1/notifications`.
- `NotificationResource` normalizes every notification into the same client payload: `id`, `type`, `title`, `message`, `action_url`, `data`, `read_at`, `is_read`, `created_at`, `updated_at`.
- Context filtering exists for `participant`, `vendor`, and `admin`. Vendor filtering can also be scoped by `organization_id` (organization UUID).
- New stored in-app notifications are now broadcast on the authenticated user's private Reverb channel as `notification.created`.

Web frontend:

- The web notification center and notifications page use the same `/api/v1/notifications` endpoints.
- The web page has all/unread tabs, type filtering, unread count, mark-all-read, single mark-read, delete, and infinite scroll.
- The web Reverb provider now invalidates notification queries when `notification.created` arrives.

## API

All endpoints require:

```http
Authorization: Bearer <access_token>
Accept: application/json
```

### List notifications

```http
GET /api/v1/notifications
```

Query params:

| Param | Type | Notes |
|---|---|---|
| `page` | integer | Defaults to Laravel pagination page 1. |
| `per_page` | integer | Defaults to 15, max 100. Use 20 for mobile infinite scroll. |
| `unread_only` | boolean | `true` to show unread only. |
| `type` | string | Filters by notification type. |
| `context` | string | `participant`, `vendor`, or `admin`. |
| `organization_id` | string | Organization UUID. Only used when `context=vendor`. |
| `search` | string | Searches the JSON notification data payload. |

Response:

```json
{
  "data": [
    {
      "id": "9f7e9b43-2a1d-4a31-9df2-cb64f23dd0e3",
      "type": "booking_confirmed",
      "title": "Reservation confirmee",
      "message": "Votre reservation ... a ete confirmee.",
      "action_url": null,
      "data": {
        "type": "booking_confirmed",
        "booking_uuid": "9f7e...",
        "event_title": "Atelier creatif"
      },
      "read_at": null,
      "is_read": false,
      "created_at": "2026-05-11T09:25:30+00:00",
      "updated_at": "2026-05-11T09:25:30+00:00"
    }
  ],
  "links": {},
  "meta": {
    "current_page": 1,
    "last_page": 3,
    "per_page": 20,
    "total": 54
  }
}
```

### Unread count

```http
GET /api/v1/notifications/unread-count?context=participant
```

Supports the same `context` and `organization_id` params as the list endpoint.

Response:

```json
{
  "count": 3,
  "unread": 3,
  "total": 54
}
```

`count` is kept for backward compatibility and is equal to `unread`.

### Show one notification

```http
GET /api/v1/notifications/{notification_id}
```

Returns the same normalized notification object as the list item.

### Mark one as read

```http
POST /api/v1/notifications/{notification_id}/read
```

`PATCH` is also accepted.

Response:

```json
{
  "message": "Notification marquee comme lue.",
  "data": {
    "id": "9f7e9b43-2a1d-4a31-9df2-cb64f23dd0e3",
    "is_read": true,
    "read_at": "2026-05-11T09:28:10+00:00"
  }
}
```

### Mark all as read

```http
POST /api/v1/notifications/read-all
POST /api/v1/notifications/read-all?context=vendor&organization_id=<organization_uuid>
```

Response:

```json
{
  "message": "Toutes les notifications ont ete marquees comme lues.",
  "count": 7
}
```

If `context` and `organization_id` are provided, only matching notifications are marked read.

### Delete one notification

```http
DELETE /api/v1/notifications/{notification_id}
```

### Delete all read notifications

```http
DELETE /api/v1/notifications/read
DELETE /api/v1/notifications/read?context=participant
```

Response:

```json
{
  "message": "Notifications lues supprimees.",
  "count": 4
}
```

If `context` and `organization_id` are provided, only matching read notifications are deleted.

## Realtime through Reverb

Reverb is Pusher-protocol compatible. The mobile app should use any Pusher-compatible websocket client that supports private channel auth.

Public config needed by the app:

| Field | Source |
|---|---|
| App key | `REVERB_APP_KEY` from mobile environment config. Public; safe in the app. |
| Host | Production websocket host, for example `ws.lehiboo.com` or configured equivalent. |
| Port | Usually `443` for TLS in production. |
| Scheme | `wss` in production, `ws` locally. |
| Auth endpoint | `POST https://<api-host>/broadcasting/auth`. Not under `/api/v1`. |

Never ship `REVERB_APP_SECRET` in the app.

### Auth flow

1. Connect the Pusher/Reverb client with the public app key and websocket host.
2. Subscribe to the private user channel.
3. The client library will call the auth endpoint with:

```http
POST /broadcasting/auth
Authorization: Bearer <access_token>
Content-Type: application/x-www-form-urlencoded

socket_id=123.456&channel_name=private-user.<user_id>
```

4. The backend authorizes only if `<user_id>` matches the authenticated user.

Channel names:

| Client style | Channel |
|---|---|
| Laravel Echo style | `user.<user_id>` |
| Raw Pusher protocol | `private-user.<user_id>` |

### Event

Listen for:

| Client style | Event |
|---|---|
| Laravel Echo style | `.notification.created` |
| Raw Pusher protocol | `notification.created` |

Payload:

```json
{
  "notification": {
    "id": "9f7e9b43-2a1d-4a31-9df2-cb64f23dd0e3",
    "type": "new_message",
    "title": "Nouveau message",
    "message": "Nouveau message de Alice.",
    "action_url": null,
    "data": {
      "type": "new_message",
      "conversation_uuid": "9f7e...",
      "sender_name": "Alice",
      "content_preview": "Bonjour..."
    },
    "read_at": null,
    "is_read": false,
    "created_at": "2026-05-11T09:25:30+00:00",
    "updated_at": "2026-05-11T09:25:30+00:00"
  },
  "unread_count": 4,
  "occurred_at": "2026-05-11T09:25:31+00:00"
}
```

Mobile behavior on event:

- Upsert `notification` at the top of the local inbox cache.
- Set the notification badge to `unread_count`.
- Show a foreground snackbar/banner if the app is active and the notification is relevant to the current context.
- Do not mark it read automatically.
- On reconnect or app resume, refetch `GET /api/v1/notifications/unread-count` and the first page of `GET /api/v1/notifications` to recover missed events.

## Mobile UX

Add a Notifications entry in the app navigation with an unread badge.

Inbox screen:

- Infinite scroll list backed by `GET /api/v1/notifications?per_page=20`.
- Pull-to-refresh refetches page 1 and unread count.
- Tabs or segmented control: `All`, `Unread`.
- Optional type filter, using the `type` field.
- Empty state for all and unread tabs.
- Loading and retry states.
- Swipe or overflow action to delete one notification.
- Bulk action: mark all visible-context notifications as read.

Notification row:

- Icon/color can be derived from `type`, matching the web categories:
  - success: confirmed, approved, payment received
  - warning: reminders, pending moderation, payouts requested
  - destructive: cancelled, rejected, failed
  - default: messages, questions, generic updates
- Show unread state with a dot or stronger text weight.
- Tap behavior:
  - If unread, call `POST /notifications/{id}/read` optimistically.
  - Navigate using `action_url` first when present.
  - If no `action_url`, derive a deep link from `type` and `data`.

## Context rules

Participant/customer app:

```http
GET /api/v1/notifications?context=participant
GET /api/v1/notifications/unread-count?context=participant
```

Vendor app:

```http
GET /api/v1/notifications?context=vendor&organization_id=<organization_uuid>
GET /api/v1/notifications/unread-count?context=vendor&organization_id=<organization_uuid>
```

Admin mobile, if supported:

```http
GET /api/v1/notifications?context=admin
```

Realtime subscription is still only the user channel. Context filtering is applied in the app cache/UI after receiving `notification.created`, and fully reconciled by API refetch.

## Deep-link mapping

Use `action_url` when present. Otherwise use `type` and `data`:

| Type family | Required data | Target |
|---|---|---|
| `new_message` | `conversation_uuid` | Message thread. |
| `booking_*` | `booking_uuid` | Booking detail. |
| `tickets_ready`, `ticket_*` | `booking_uuid` or `ticket_uuid` | Ticket or booking tickets screen. |
| `event_*`, `new_event_*`, `new_slots_*`, `discovery_*` | `event_uuid` or event slug when present | Event detail. |
| `question_*`, `review_*` | `event_uuid` plus review/question identifiers when present | Event detail or user contributions screen. |
| `organization_*`, `vendor_*` | `organization_uuid` when present | Organization/vendor area or membership/invitation screen. |
| `document_*` | `organization_uuid`, `document_id` when present | Vendor documents screen. |
| `payout_*`, `payment_*`, `refund` | `booking_uuid`, `payout_id`, or payment refs when present | Finance or booking detail. |
| `story_*` | `story_uuid` | Story management/detail screen. |

If a required identifier is missing, open the notification detail or the generic notifications inbox rather than failing silently.

## Failure handling

- `401` on REST endpoints or `/broadcasting/auth`: refresh/re-login, disconnect Reverb, and retry after auth is restored.
- Reverb disconnect: keep REST polling on app resume and reconnect with exponential backoff.
- Duplicate `notification.created`: de-duplicate by notification `id`.
- Out-of-order events: sort by `created_at` descending after every cache update.
- Unknown `type`: render with generic bell/info icon and still show `title`/`message`.

## Acceptance checklist

- User can open a notifications page and see paginated notifications.
- Unread badge matches `GET /notifications/unread-count`.
- Pull-to-refresh and app resume reconcile missed realtime events.
- New database notifications arrive through Reverb on `notification.created`.
- Tapping an unread notification marks it read and updates the badge.
- Mark-all-read respects the active mobile context.
- Deleting one notification removes it locally and from the server.
- Unknown notification types still render safely.

## Open product questions

- Should the first mobile release include vendor notifications, or participant-only?
- Should admin notifications be supported on mobile?
- Should foreground Reverb banners be suppressed when the user is already viewing the target screen, for example the active message thread?
- Confirm final mobile route names for each deep-link target in the table above.
