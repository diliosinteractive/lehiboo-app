# Memberships Workflow — Mobile Integration Spec

**Audience** : Mobile app (Flutter)
**Status** : Stable contract
**Scope** : **Participant only** — joining, leaving, listing memberships, accepting/declining invitations, viewing private events. Vendor approval / rejection / bulk-invite flows are out of scope (separate spec).
**Reference doc** : `docs/03-guides/MEMBERSHIPS_SYSTEM.md`

This spec covers the full **participant** lifecycle for organization memberships and members-only events. It mirrors the web pages at `/dashboard/memberships` and `/dashboard/private-events`.

---

## 1. Workflow overview

There are **two entry paths** into a membership:

```
Path A — self-initiated join request
─────────────────────────────────────────────────────
  user discovers organizer
  ─→ POST /organizations/{slug}/membership-request
       creates OrganizationMember(status=pending)
  ─→ vendor approves or rejects
       approved → status=active   (push + email to user)
       rejected → status=rejected (push + email to user)

Path B — vendor-initiated invitation
─────────────────────────────────────────────────────
  vendor bulk-invites by email
  ─→ user receives email with token link
  ─→ GET /me/invitations (lists pending)
  ─→ POST /me/invitations/{token}/accept
       creates OrganizationMember(status=active) directly
       OR
     POST /me/invitations/{token}/decline
       deletes the invitation (silent)
```

After becoming an `active` member, the user can:

- See `members-only` events of that organization in **all** public listings (search, category, city), not just dedicated screens
- Open the dedicated **Mes événements privés** screen via `GET /me/private-events`
- See members-only events surfaced in the **personalized feed** at `GET /me/personalized-feed`
- Leave at any time via `DELETE /organizations/{slug}/membership-request`

---

## 2. Endpoints used by this workflow

| # | Verb | Path | Purpose | Auth |
|---|---|---|---|---|
| 1 | `POST` | `/api/v1/organizations/{slug}/membership-request` | Request to join an organization | required |
| 2 | `DELETE` | `/api/v1/organizations/{slug}/membership-request` | Cancel pending request OR leave active membership | required |
| 3 | `GET` | `/api/v1/me/memberships` | Paginated list of the user's memberships | required |
| 4 | `GET` | `/api/v1/me/invitations` | Pending invitations for the authenticated user (Flutter alias) | required |
| 5 | `GET` | `/api/v1/invitations/{token}` | View invitation by token (public — pre-login preview) | none |
| 6 | `GET` | `/api/v1/me/invitations/{token}` | View invitation by token (authenticated — same payload) | required |
| 7 | `POST` | `/api/v1/me/invitations/{token}/accept` | Accept an invitation | required |
| 8 | `POST` | `/api/v1/me/invitations/{token}/decline` | Decline an invitation | required |
| 9 | `GET` | `/api/v1/me/private-events` | Paginated list of private events from orgs the user is active member of | required |
| 10 | `GET` | `/api/v1/me/personalized-feed` | Aggregated "Pour vous" feed (top N events) | required |

> **Path-param convention** — Endpoints 1, 2 accept the organization slug or UUID interchangeably (controller resolves both). Endpoints 5–8 take an opaque invitation token (a 32-byte string); send it verbatim from the email link or the listing payload's `token` field.

> **Alias note (endpoints 4, 6, 7, 8)** — these mirror the original `/v1/invitations/...` routes. Both forms work; the `/me/invitations` form is the recommended Flutter convention.

---

## 3. Endpoint 1 — Request to join

```
POST /api/v1/organizations/{slug_or_uuid}/membership-request
```

### 3.1 Headers

```
POST /api/v1/organizations/{slug_or_uuid}/membership-request HTTP/1.1
Host: api.lehiboo.com
Accept: application/json
Authorization: Bearer <token>     # required
X-Platform: mobile                # recommended
Accept-Language: fr               # or en, es, de, nl, ar — drives the localized status_label
```

### 3.2 Path Param

| Param | Type | Resolution |
|---|---|---|
| `slug_or_uuid` | string | Send `organization.slug` or `organization.uuid`. UUID is detected by `Str::isUuid()`; non-UUID strings are looked up by slug. |

### 3.3 Body

No body required. The user is identified by the bearer token; the organization by the path param.

### 3.4 Success — `201 Created`

```jsonc
{
  "success": true,
  "message": "Demande envoyée avec succès.",
  "data": {
    "id": 42,
    "status": "pending",
    "status_label": "En attente",
    "organization": {
      "id": 7,
      "uuid": "019d8652-...",
      "slug": "bobo-corp",
      "name": "Bobo Junior",
      "logo_url": "https://...",
      "cover_url": "https://...",
      "address": "Lyon, France",
      "members_count": 42,
      "membersCount": 42
    },
    "requested_at": "2026-04-30T16:14:00+02:00",
    "approved_at": null,
    "rejected_at": null,
    "created_at": "2026-04-30T16:14:00+02:00"
  }
}
```

> **`members_count`** — count of `active` memberships in the organization (excludes `pending`, `rejected`, `suspended`, and the owner). Useful for showing "N membres" on the membership card. Same field is exposed on `OrganizationResource` (full profile) and on the embedded organization block of invitations.

### 3.5 Errors

| Status | Cause | Body |
|---|---|---|
| `401` | Token missing / expired | `{"message":"Unauthenticated.","error":"unauthenticated"}` |
| `403` | Policy refused (e.g. user owns the organization, can't be a member of own org) | `{"success":false,"message":"…","error":"membership_error"}` |
| `404` | Slug/UUID doesn't exist | `{"message":"Resource not found.","error":"not_found"}` |
| `422` | Already pending or active membership for this org | `{"success":false,"message":"…","error":"membership_error"}` |

> The 422 case is the most common — mobile must also branch on the local `useMemberships` cache: if a `pending` or `active` membership already exists for this org, never call this endpoint, just navigate to the existing card.

### 3.6 Side effects

- Creates `OrganizationMember(status=pending, role=Viewer, role=Viewer)`
- Fires `OrganizationJoinRequestedNotification` to the org owner + active admin members (FCM + email + database)

### 3.7 Sample call (Dio)

```dart
Future<Membership> requestMembership(String slugOrUuid) async {
  final response = await dio.post<Map<String, dynamic>>(
    '/api/v1/organizations/$slugOrUuid/membership-request',
    options: Options(headers: {
      'Authorization': 'Bearer $token',
      'X-Platform': 'mobile',
    }),
  );
  return Membership.fromJson(response.data!['data']);
}
```

---

## 4. Endpoint 2 — Cancel / Leave

```
DELETE /api/v1/organizations/{slug_or_uuid}/membership-request
```

Single endpoint covers two semantic cases:
- **Cancel** a `pending` request before vendor decision
- **Leave** an `active` membership

The server detects the current state and applies the right transition (deletes the row in both cases). The success message differs based on which it was.

### 4.1 Success — `200 OK`

```jsonc
{
  "success": true,
  "message": "Demande annulée."        // OR "Vous avez quitté cette organisation."
}
```

### 4.2 Errors

| Status | Cause |
|---|---|
| `401` | Token missing / expired |
| `403` | Policy refused (not the owner of the membership row) |
| `404` | No `pending` or `active` membership exists for this user+org pair (`{"success":false,"message":"Aucune adhésion à annuler pour cette organisation.","error":"membership_not_found"}`) |

### 4.3 Side effects

- Deletes the `OrganizationMember` row (no soft-delete)
- **No notification** — silent for both cancel and leave (intentional UX choice per `MEMBERSHIPS_SYSTEM.md`)
- The user can immediately request again via Endpoint 1

### 4.4 Sample call

```dart
Future<void> cancelOrLeave(String slugOrUuid) async {
  await dio.delete('/api/v1/organizations/$slugOrUuid/membership-request',
    options: Options(headers: {'Authorization': 'Bearer $token'}),
  );
}
```

---

## 5. Endpoint 3 — List my memberships

```
GET /api/v1/me/memberships
```

Paginated list of the user's memberships across all statuses. Default excludes the legacy `suspended` state.

### 5.1 Query params

| Param | Type | Default | Constraints | Notes |
|---|---|---|---|---|
| `status` | enum | omitted | `pending` \| `active` \| `rejected` | Filter to a single status. When omitted, returns `pending` + `active` + `rejected` (suspended hidden). |
| `search` | string | — | max 255 | ILIKE match on `organization_name`, `organization_display_name`, `company_name`. |
| `per_page` | int | 15 | 1–50 | |
| `page` | int | 1 | ≥ 1 | |

### 5.2 Success — `200 OK`

```jsonc
{
  "success": true,
  "data": [
    {
      "id": 42,
      "status": "active",
      "status_label": "Actif",
      "organization": {
        "id": 7, "uuid": "...", "slug": "bobo-corp", "name": "Bobo Junior",
        "logo_url": "...", "cover_url": "...", "address": "Lyon, France",
        "members_count": 42, "membersCount": 42
      },
      "requested_at": "2026-04-15T10:12:00+02:00",
      "approved_at": "2026-04-16T09:30:00+02:00",
      "rejected_at": null,
      "created_at": "2026-04-15T10:12:00+02:00"
    }
  ],
  "meta": {
    "total": 12,
    "page": 1,
    "per_page": 15,
    "last_page": 1
  }
}
```

> **`meta` shape** — uses `page` (not `current_page`). Matches the project standard for list endpoints (different from the verbose Laravel pagination shape on the reviews endpoints).

### 5.3 Errors

| Status | Cause |
|---|---|
| `401` | Token missing / expired |
| `422` | Invalid `status` (must be one of `pending`, `active`, `rejected`) or `per_page` out of range |

### 5.4 Sample call

```dart
Future<PaginatedMemberships> fetchMemberships({
  MembershipStatus? status,
  String? search,
  int page = 1,
  int perPage = 20,
}) async {
  final response = await dio.get<Map<String, dynamic>>(
    '/api/v1/me/memberships',
    queryParameters: {
      if (status != null) 'status': status.name,
      if (search != null && search.isNotEmpty) 'search': search,
      'page': page,
      'per_page': perPage,
    },
    options: Options(headers: {'Authorization': 'Bearer $token'}),
  );
  return PaginatedMemberships.fromJson(response.data!);
}
```

---

## 6. Endpoint 4 — List my pending invitations

```
GET /api/v1/me/invitations
```

Returns invitations where the email matches the authenticated user **and** the invitation is still pending (not expired, not accepted, not declined).

### 6.1 Query params

None. The list isn't paginated server-side (typical user has 0–5 pending invitations at any time).

### 6.2 Success — `200 OK`

```jsonc
{
  "data": [
    {
      "id": 11,
      "type": "organization_invitation",
      "email": "alice@example.com",
      "role": "viewer",
      "role_label": "Membre",
      "is_valid": true,
      "is_expired": false,
      "is_accepted": false,
      "token": "k7Z9sfAa3...32chars",
      "organization": {
        "id": 7,
        "uuid": "...",
        "slug": "bobo-corp",
        "name": "Bobo Junior",
        "logo": "https://...",
        "city": "Lyon",
        "verified": true,
        "members_count": 42,
        "membersCount": 42
      },
      "invited_by": {
        "uuid": "...",
        "name": "Pauline D.",
        "avatar": "https://..."
      },
      "expires_at": "2026-05-03T16:14:00+02:00",
      "accepted_at": null,
      "created_at": "2026-04-30T16:14:00+02:00",
      "updated_at": "2026-04-30T16:14:00+02:00"
    }
  ],
  "meta": {
    "total": 1
  }
}
```

> **`token` exposure** — only present when the request is authenticated AND the resource is being viewed by the recipient (matches by email). Mobile uses this token for accept/decline calls.

### 6.3 Errors

| Status | Cause |
|---|---|
| `401` | Token missing / expired |

### 6.4 Sample call

```dart
Future<List<Invitation>> fetchPendingInvitations() async {
  final response = await dio.get<Map<String, dynamic>>(
    '/api/v1/me/invitations',
    options: Options(headers: {'Authorization': 'Bearer $token'}),
  );
  final list = (response.data!['data'] as List)
      .map((j) => Invitation.fromJson(j))
      .toList();
  return list;
}
```

---

## 7. Endpoint 5 / 6 — View invitation by token

```
GET /api/v1/invitations/{token}            # public — pre-login preview
GET /api/v1/me/invitations/{token}         # authenticated — Flutter alias
```

Both return the same payload shape. Use the public form for the deep-link preview when the user clicks the email link before logging in; use the `/me/` form once authenticated.

### 7.1 Success — `200 OK`

```jsonc
{
  "data": {
    "id": 11,
    "type": "organization_invitation",
    "email": "alice@example.com",
    "role": "viewer",
    "role_label": "Membre",
    "is_valid": true,
    "is_expired": false,
    "is_accepted": false,
    "has_account": true,                    // only on the public token view
    "token": "k7Z9sfAa3...",
    "organization": { /* see §6.2 */ },
    "invited_by": { /* see §6.2 */ },
    "expires_at": "2026-05-03T16:14:00+02:00",
    "_links": {
      "accept": {
        "href": "https://api.lehiboo.com/api/v1/invitations/k7Z9sfAa3.../accept",
        "method": "POST"
      }
    }
  },
  "meta": {
    "is_valid": true,
    "expires_in_hours": 71,
    "organization_name": "Bobo Junior",
    "role": "viewer",
    "role_label": "Membre"
  }
}
```

### 7.2 Errors

| Status | Cause | Body shape |
|---|---|---|
| `404` | Token doesn't exist | `{"message":"Invitation not found.","errors":{"token":["…"]}}` |
| `410 Gone` | Expired (returns `data` with `is_expired: true` for UI rendering) | `{"message":"This invitation has expired.","data":{...},"errors":{"token":["…"]}}` |
| `410 Gone` | Already accepted | `{"message":"This invitation has already been accepted.","data":{...},"errors":{"token":["…"]}}` |

> **410 with `data`** — mobile should still render the invitation card even when 410, using the `data.organization` and `data.invited_by` info to give context, while showing an "Expired / Already accepted" state instead of accept/decline buttons.

### 7.3 Sample call

```dart
Future<InvitationPreview> peekInvitation(String token) async {
  final response = await dio.get<Map<String, dynamic>>(
    '/api/v1/invitations/$token',
    options: Options(
      validateStatus: (s) => s != null && (s == 200 || s == 410),
    ),
  );
  return InvitationPreview.fromJson(response.data!);
}
```

---

## 8. Endpoint 7 — Accept invitation

```
POST /api/v1/me/invitations/{token}/accept
```

Activates the membership immediately. The user is added as `active` member (no vendor approval needed — the invitation already represents vendor consent).

### 8.1 Success — `200 OK`

```jsonc
{
  "message": "Invitation accepted successfully. You are now a member of Bobo Junior.",
  "data": {
    /* OrganizationMemberResource — different shape from OrganizationMembershipResource */
    "id": 99,
    "user_id": 30,
    "organization_id": 7,
    "role": "viewer",
    "status": "active",
    "joined_at": "2026-04-30T16:14:00+02:00",
    "user": { ... },
    "organization": { ... }
  },
  "user": {
    /* full UserResource — refreshed because role may have changed */
  }
}
```

> **Resource difference** — the accept endpoint returns `OrganizationMemberResource` (vendor-shaped, includes `role` and `user`), not `OrganizationMembershipResource`. Mobile should NOT try to drop this directly into the `useMemberships` cache. Instead, **invalidate** that cache and re-fetch via `GET /me/memberships?status=active` if the screen needs the customer-shaped row.

### 8.2 Errors

| Status | Cause | Body |
|---|---|---|
| `401` | Token missing / expired | `{"message":"You must be logged in to accept an invitation.","errors":{"auth":["…"]}}` |
| `404` | Invitation token doesn't exist | `{"message":"Invitation not found.","errors":{"token":["…"]}}` |
| `422` | Email mismatch, already accepted, expired, or other validation failure | `{"message":"…","errors":{"invitation":["…"]}}` |

### 8.3 Side effects

- Creates / activates `OrganizationMember(status=active)` for `user_id = auth()->id()`, `organization_id = invitation->organization_id`
- Marks the invitation as accepted (`accepted_at` set)
- Notifies the organization (vendor side, out of scope here)

### 8.4 Sample call

```dart
Future<void> acceptInvitation(String token) async {
  await dio.post('/api/v1/me/invitations/$token/accept',
    options: Options(headers: {'Authorization': 'Bearer $token'}),
  );
  // After success: invalidate memberships cache
}
```

---

## 9. Endpoint 8 — Decline invitation

```
POST /api/v1/me/invitations/{token}/decline
```

Deletes the invitation row. Silent operation — vendor is notified separately by the `MembershipService::notifyInvitationDeclined` flow.

### 9.1 Success — `200 OK`

```jsonc
{
  "message": "Invitation declined."
}
```

### 9.2 Errors

| Status | Cause |
|---|---|
| `401` | Token missing / expired |
| `403` | Email mismatch (`{"message":"This invitation is not for your email address.","errors":{"email":["…"]}}`) |
| `404` | Invitation token doesn't exist |
| `422` | Invitation already accepted (cannot be declined after acceptance) |

### 9.3 Sample call

```dart
Future<void> declineInvitation(String token) async {
  await dio.post('/api/v1/me/invitations/$token/decline',
    options: Options(headers: {'Authorization': 'Bearer $token'}),
  );
}
```

---

## 10. Endpoint 9 — Private events

```
GET /api/v1/me/private-events
```

Paginated list of events visible to the user **specifically because** they're an active member of the organization. The filter combines:

- Event status IN `[Published, Private]`
- Event `organization_id` IN orgs where user is `active` member
- Event `visibility` IN `[Private, PrivateProtected]`

### 10.1 Query params

| Param | Type | Default | Constraints | Notes |
|---|---|---|---|---|
| `search` | string | — | max 255 | ILIKE on event `title` |
| `organization_id` | string | — | int OR UUID | Filter to a single org. Must be one the user is active in; otherwise empty result. |
| `per_page` | int | 15 | 1–50 | |
| `page` | int | 1 | ≥ 1 | |

### 10.2 Success — `200 OK`

```jsonc
{
  "success": true,
  "data": [ /* EventResource[] (mobile shape when X-Platform: mobile) */ ],
  "meta": { "total": 24, "page": 1, "per_page": 15, "last_page": 2 }
}
```

The event payload is the same `EventResource` (or `MobileEventResource` with `X-Platform: mobile`) used by other listing endpoints — see `BOOKING_DETAIL_MOBILE_SPEC.md` §4.8 and `MobileEventResource.php` for the field map.

### 10.3 Empty state

If the user has **no** active memberships, the response is `{"success": true, "data": [], "meta": { "total": 0, "page": 1, "per_page": 15, "last_page": 1 }}` (200 OK, not 404). Mobile shows the "Rejoignez des organisations…" empty state.

### 10.4 Errors

| Status | Cause |
|---|---|
| `401` | Token missing / expired |
| `422` | Invalid `per_page` |

---

## 11. Endpoint 10 — Personalized feed

```
GET /api/v1/me/personalized-feed
```

Aggregated "Pour vous" feed. **Not paginated** — returns top N events combining 5 priority strata.

### 11.1 Query params

| Param | Type | Default | Constraints |
|---|---|---|---|
| `limit` | int | 8 | 1–20 |

### 11.2 Strata (in order — server stops appending once the limit is reached)

1. `is_members_only=true` events of orgs where user is `active` member, with future slots
2. Events of bookings where user has a confirmed booking, with future slots
3. Events of reminders the user has set
4. Favorited events (still published)
5. Events of organizers the user follows, with future slots

Deduplication is applied across strata (same event appears at most once).

### 11.3 Success — `200 OK`

```jsonc
{
  "success": true,
  "data": [ /* EventResource[] */ ]
}
```

> **No `meta`** — this endpoint never paginates; the client just consumes the array.

### 11.4 Errors

| Status | Cause |
|---|---|
| `401` | Token missing / expired |
| `422` | `limit` out of range |

---

## 12. Status state machine

```
                ┌─────────────┐
                │  No record  │
                └──────┬──────┘
                       │
   POST /membership-request                  POST /me/invitations/{token}/accept
                       │                                 │
                       ▼                                 ▼
             ┌────────────────┐               ┌────────────────┐
             │    pending     │               │     active     │◀─── (direct via invitation)
             └───┬────────┬───┘               └───┬────────┬───┘
        approve │        │ reject                │        │ leave
        (vendor)│        │(vendor + note)        │        │(DELETE)
                ▼        ▼                       │        ▼
        ┌────────────┐ ┌────────────┐            │  No record
        │   active   │ │  rejected  │            │ (re-applicable)
        └─────┬──────┘ └─────┬──────┘            │
              │              │                   │
              │ leave        │ re-apply          │
              │(DELETE)      │(POST again →      │
              ▼              │  pending)         │
       No record             └──→ pending        │
       (re-applicable)                           │
                                                 │
                                       cancel pending
                                       (DELETE → no record)
```

### Transition table

| From | Trigger (mobile action) | To | Endpoint |
|---|---|---|---|
| no record | request to join | `pending` | POST `/organizations/{slug}/membership-request` |
| no record | accept invitation | `active` | POST `/me/invitations/{token}/accept` |
| `pending` | cancel | (deleted) | DELETE `/organizations/{slug}/membership-request` |
| `pending` | vendor approve | `active` | (server-side; mobile observes via re-fetch / push) |
| `pending` | vendor reject | `rejected` | (server-side; mobile observes via re-fetch / push) |
| `active` | leave | (deleted) | DELETE `/organizations/{slug}/membership-request` |
| `active` | vendor exclude | (deleted) | (server-side; mobile observes via re-fetch) |
| `rejected` | re-apply | `pending` (new row) | POST `/organizations/{slug}/membership-request` |

The `suspended` state exists in the enum but is legacy / vendor-internal and never appears in customer responses.

---

## 13. Mobile screen composition

### 13.1 Memberships screen — `Mes adhésions`

```
┌──────────────────────────────────────────┐
│  ◀  Mes adhésions                  🔍    │ ← AppBar with back + search trigger
├──────────────────────────────────────────┤
│  [Tous] [Actifs (5)] [En attente (2)]    │ ← TabBar with counters
│  [Refusées (1)] [Invitations (3)]        │
├──────────────────────────────────────────┤
│  🔍 Rechercher une organisation...        │ ← optional inline search bar
├──────────────────────────────────────────┤
│                                          │
│  ╭──╮  Bobo Junior          [Actif]      │ ← MembershipCard
│  ╰──╯  Lyon, France                      │
│        Membre depuis le 16/04/2026       │
│        [Voir la fiche] [Quitter]         │
│                                          │
│  ╭──╮  Théâtre de Denain   [En attente] │
│  ╰──╯  Denain, France                    │
│        Demande envoyée le 30/04/2026     │
│        [Voir la fiche] [Annuler]         │
│                                          │
│  ╭──╮  Mairie de ...        [Refusée]    │
│  ╰──╯  Demande du 10/04 — non acceptée   │
│        [Voir la fiche] [Refaire demande] │
│                                          │
└──────────────────────────────────────────┘
```

### 13.2 Invitations tab — `Invitations`

Shown as a sub-tab inside the same screen (see §13.1) when `useMyInvitations()` returns ≥ 1 row.

```
  ╭──╮  Bobo Junior          [Invitation]     ← blue badge
  ╰──╯  Lyon, France
        Invité par Pauline D.
        Expire dans 47 h
        [Décliner]   [Accepter]              ← primary button on the right
```

### 13.3 Private events screen — `Mes événements privés`

```
┌──────────────────────────────────────────┐
│  ◀  Mes événements privés          🔍    │
├──────────────────────────────────────────┤
│  🔍 Rechercher...                         │
│  Filtrer : [Toutes les organisations ▾]  │ ← dropdown with active orgs only
├──────────────────────────────────────────┤
│  ┌────┐ ┌────┐ ┌────┐                   │
│  │ ev │ │ ev │ │ ev │ ← EventCard        │
│  └────┘ └────┘ └────┘   with 🔒 Privé    │
│                          badge           │
└──────────────────────────────────────────┘
```

Empty state:

```
  ┌────────────────────────────────────────┐
  │              🔒                        │
  │                                        │
  │   Aucun événement privé pour          │
  │   l'instant.                          │
  │                                        │
  │   Rejoignez des organisations pour    │
  │   découvrir leurs activités exclusives.│
  │                                        │
  │       [Découvrir les organisations]    │
  └────────────────────────────────────────┘
```

### 13.4 Recommended widget tree

```
MembershipsScreen
├── SliverAppBar(title: 'Mes adhésions')
└── DefaultTabController(length: 4)        // Actifs / En attente / Refusées / Invitations
    ├── TabBar(scrollable, counters per tab)
    └── TabBarView
        ├── _MembershipList(status: active)         // GET /me/memberships?status=active
        ├── _MembershipList(status: pending)
        ├── _MembershipList(status: rejected)
        └── _InvitationsList()                       // GET /me/invitations

PrivateEventsScreen
├── SliverAppBar(title: 'Mes événements privés')
├── _SearchBar
├── _OrganizationFilterDropdown(activeOrgsOnly)
└── _EventGrid                                       // GET /me/private-events
    └── EventCard with 🔒 badge
```

---

## 14. Mobile screen flow

### 14.1 Memberships screen

```
1. User taps "Mes adhésions" in the menu.
2. Screen mounts → fetch in parallel:
     GET /me/memberships          (default = pending+active+rejected)
     GET /me/invitations
3. Render TabBar with counters from each response.
4. On tab tap, switch view (no extra fetch — data already in store).
5. On search input (debounced 300ms): GET /me/memberships?search={q}.
6. On status filter (tab change with status): GET /me/memberships?status={s}.
7. Action buttons (status-driven, see §15 below).
8. On screen focus: re-fetch both endpoints (memberships and invitations)
   so vendor approvals/rejections that landed via push notification show up.
```

### 14.2 Joining an organization

```
1. User opens an organizer profile (see ORGANIZER_PROFILE_MOBILE_SPEC.md).
2. Tap "Rejoindre".
3. If not authenticated → AuthRequired dialog (see §9 of organizer spec).
4. Confirmation dialog: "Rejoindre l'espace privé de {Organization}?"
   "En rejoignant, vous aurez accès aux événements exclusifs..."
5. On confirm:
     POST /organizations/{org.uuid}/membership-request
6. On 201:
     - Update organizer profile button state to "Demande envoyée"
     - Insert the new membership into the local cache (status=pending)
     - Toast "Demande envoyée"
7. On 422 ("already pending/active"): re-fetch /me/memberships and update
   the button to reflect the actual state.
```

### 14.3 Accepting an invitation (deep-link entry)

```
1. User taps email link → app opens with /invitations/{token}.
2. If not authenticated:
     - GET /api/v1/invitations/{token} (public preview)
     - Render invitation card with org info
     - Show "Se connecter pour accepter" button → login flow with deep-link
       restored on success.
3. If authenticated:
     - GET /api/v1/me/invitations/{token}
     - Render invitation card
     - Two buttons: [Décliner] [Accepter]
4. On Accept tap:
     POST /me/invitations/{token}/accept
     - Optimistic state: button disabled + spinner
     - On 200:
         - Toast "Bienvenue dans {Organization}"
         - Invalidate memberships cache and re-fetch via GET /me/memberships
         - Invalidate invitations cache (the row is gone)
         - Navigate to memberships screen with active tab pre-selected
     - On 422 (email mismatch / expired): show inline error, leave card visible.
5. On Decline tap:
     - Confirmation dialog: "Refuser l'invitation de {Organization}?"
     - POST /me/invitations/{token}/decline
     - On 200: remove from invitations list, no further nav.
```

---

## 15. UI guidelines

### 15.1 Status badges

| Membership status | Color | Label (FR) | Sub-text |
|---|---|---|---|
| `pending` | amber `#F59E0B` | En attente | "Demande envoyée le DD/MM/YYYY" |
| `active` | green `#10B981` | Actif | "Membre depuis DD/MM/YYYY" |
| `rejected` | grey `#6B7280` | Refusée | "Demande du DD/MM/YYYY" |
| invitation | blue `#3B82F6` | Invitation | "Expire dans Nh" |
| invitation expired | grey `#9CA3AF` | Expirée | hidden by default; surface only on the deep-link landing screen |

Use the same color tokens consistently across web (already shipped at `frontend/src/app/(dashboard)/dashboard/memberships/page.tsx`) and mobile so users get a visual continuity if they switch devices.

### 15.2 Action button matrix

For each membership card, the action buttons are computed from the row's `status`:

| Status | Primary action | Secondary | Always visible |
|---|---|---|---|
| `pending` | `Annuler la demande` (DELETE) | — | `Voir la fiche` (deep-link to organizer profile) |
| `active` | `Quitter l'organisation` (DELETE, **confirmation required**) | `Voir les événements privés` (deep-link to /me/private-events filtered by this org) | `Voir la fiche` |
| `rejected` | `Refaire une demande` (POST request) | — | `Voir la fiche` |
| invitation `pending` | `Accepter` + `Décliner` (paired) | — | `Voir la fiche` (org profile via deep-link from invitation.organization.slug) |

> **Confirmation dialog wording for "Quitter"**: "Vous ne verrez plus les événements privés de {Organization}. Vous pourrez refaire une demande à tout moment."

### 15.3 Optimistic UI patterns

| Action | Pattern |
|---|---|
| Request to join | Optimistic insert of `pending` row → reconcile from 201 response → on 422 (already exists) re-fetch and replace |
| Cancel pending | Optimistic remove → on success do nothing more → on 4xx restore the row + toast |
| Leave active | Confirmation dialog → optimistic remove → on success refresh `useMyPrivateEvents` cache (now smaller) → on 4xx restore + toast |
| Re-apply rejected | Optimistic transition card from `rejected` to `pending` in place → on 201 reconcile → on 4xx revert |
| Accept invitation | Disable buttons + spinner → on 200 invalidate both `useMyInvitations` and `useMyMemberships` → toast → navigate |
| Decline invitation | Disable + spinner → on 200 remove from local list → no nav |

### 15.4 Counter sources

The TabBar counters come from the **same** `/me/memberships` response used to render the lists — split client-side by status. Don't make 4 separate calls. The invitations counter comes from `/me/invitations.meta.total`.

When a push notification lands while the screen isn't open, increment the counter by 1 client-side (optimistic) and mark the screen as needing a re-fetch on next focus.

### 15.5 Empty states

| Tab | Empty copy |
|---|---|
| Active | "Aucune adhésion active. Rejoignez vos organisations préférées pour ne rien manquer." + CTA "Découvrir les organisations" → opens search/discovery |
| Pending | "Vous n'avez pas de demande en attente." |
| Rejected | "Aucune demande refusée." |
| Invitations | "Aucune invitation pour le moment." |
| Private events (no active membership) | "Rejoignez des organisations pour découvrir leurs événements privés." + CTA |
| Private events (has memberships, none filtered) | "Aucun événement privé correspondant." (depending on search/filter) |

### 15.6 Multi-org

A user can be member of N organizations simultaneously — there's no upper bound and no exclusivity. The `/me/memberships` endpoint returns all of them. The private-events screen aggregates across all their members-only events. The `organization_id` filter dropdown in §13.3 only contains orgs where the user is `active` (not pending).

---

## 16. Push notification payloads

The backend already wires FCM (channels + DB + email) for these notifications. The Flutter app's notification handler should branch on `data.type`:

| `data.type` | Triggered by | Recommended deep-link |
|---|---|---|
| `organization_join_requested` | (vendor-side; participant won't receive) | — |
| `organization_join_approved` | Vendor approves a pending request | `/dashboard/memberships?tab=active&highlight={organization_uuid}` |
| `organization_join_rejected` | Vendor rejects a pending request | `/dashboard/memberships?tab=rejected` |
| `organization_invitation_received` | Vendor sends an invitation to this user's email | `/dashboard/memberships?tab=invitations` |
| `organization_invitation_declined` | (vendor-side) | — |
| `organization_invitation_accepted` | (vendor-side) | — |

### 16.1 Payload shape (FCM `data` object)

All membership push payloads follow the convention established by other notifications (see `PushPayload.php`):

```jsonc
{
  "type": "organization_join_approved",
  "organization_id": "7",
  "organization_uuid": "019d8652-...",
  "organization_slug": "bobo-corp",
  "organization_name": "Bobo Junior",
  "action": "/dashboard/memberships?tab=active"
}
```

**Routing convention — `data.type` is canonical, `data.action` is web-shaped.** The `data.action` value is a **web URL** (`/dashboard/memberships?...`) used by the web client. Mobile must **not** route to it directly. Instead, branch on `data.type` to map to the equivalent Flutter route:

```dart
Route routeForPushType(Map<String, String> data) {
  return switch (data['type']) {
    'organization_join_approved'      => MembershipsRoute(tab: MembershipTab.active),
    'organization_join_rejected'      => MembershipsRoute(tab: MembershipTab.rejected),
    'organization_invitation_received'=> MembershipsRoute(tab: MembershipTab.invitations),
    _ => HomeRoute(),
  };
}
```

This keeps backend payloads platform-agnostic — both web and mobile consume the same `data.type` switch but each owns its own URL space. Mobile may still use `data.organization_uuid`, `data.organization_slug`, or `data.organization_name` to enrich the routed screen (e.g. highlight the matching card).

### 16.2 Behavior on push receipt

1. If app is **foreground on memberships screen**: increment the relevant tab counter, show a subtle banner ("Bonne nouvelle ! Votre demande a été acceptée."), and re-fetch `/me/memberships` after 1s.
2. If app is **foreground elsewhere**: surface the system push in the OS notification tray (don't override).
3. If app is **background / killed**: OS shows the push; on tap, deep-link to the `data.action` path.

---

## 17. Sample data classes (Dart, suggestion)

```dart
enum MembershipStatus { pending, active, rejected }

extension MembershipStatusX on MembershipStatus {
  String get label => switch (this) {
    MembershipStatus.pending => 'En attente',
    MembershipStatus.active => 'Actif',
    MembershipStatus.rejected => 'Refusée',
  };
  Color get color => switch (this) {
    MembershipStatus.pending => const Color(0xFFF59E0B),
    MembershipStatus.active => const Color(0xFF10B981),
    MembershipStatus.rejected => const Color(0xFF6B7280),
  };
}

class Membership {
  final int id;
  final MembershipStatus status;
  final String statusLabel;
  final OrganizationSummary? organization;
  final DateTime? requestedAt;
  final DateTime? approvedAt;
  final DateTime? rejectedAt;

  factory Membership.fromJson(Map<String, dynamic> json) => Membership(
    id: json['id'] as int,
    status: MembershipStatus.values.byName(json['status'] as String),
    statusLabel: json['status_label'] as String,
    organization: json['organization'] == null
        ? null
        : OrganizationSummary.fromJson(json['organization']),
    requestedAt: _parseDate(json['requested_at']),
    approvedAt: _parseDate(json['approved_at']),
    rejectedAt: _parseDate(json['rejected_at']),
  );
}

class OrganizationSummary {
  final int id;
  final String uuid;
  final String slug;
  final String name;
  final String? logoUrl;
  final String? coverUrl;
  final String? address;
}

class Invitation {
  final int id;
  final String email;
  final String role;
  final String roleLabel;
  final bool isValid;
  final bool isExpired;
  final bool isAccepted;
  final String token;
  final OrganizationSummary organization;
  final UserSummary? invitedBy;
  final DateTime expiresAt;
  final DateTime createdAt;

  Duration get expiresIn => expiresAt.difference(DateTime.now());
}

class PaginatedMemberships {
  final List<Membership> items;
  final int page, perPage, total, lastPage;
}
```

---

## 18. Operational notes

| Concern | Note |
|---|---|
| **Cache strategy** | Memberships list and invitations list change in response to vendor actions (push notifications) — re-fetch on screen focus. Cache TTL `5 min` is reasonable as a safety net. |
| **Optimistic + reconcile** | Always reconcile from the server response on action endpoints; never trust client-side state alone for the `status` field, because vendor-side can transition a row at any time. |
| **`/me/invitations` returns invitation token in plaintext** — same domain, HTTPS only — but mobile should treat the token as sensitive: don't log it, don't include in crash reports. The server enforces email match on accept/decline so a leaked token still requires the right account, but the convention is to handle it like a session token. |
| **Re-apply after rejection** | Allowed. The server creates a new `pending` row each time. Mobile may want to cap "remember rejection for 7 days" so users don't immediately retry — but that's a UX choice, not enforced server-side. |
| **Suspended status** | `Suspended` exists in the enum but is **never** in customer responses (controller's default filter excludes it). Mobile types should not include it. |
| **Owner of the organization can't be a member** | If the user is the org's owner, the request endpoint returns 403. Mobile hides the "Rejoindre" button on profile screens when `organization.is_owner == true`. The `is_owner` field is **tri-state** on the organizer profile response: `true` when the authenticated user owns the org, `false` when authenticated and not the owner, `null` when unauthenticated. Same pattern as `is_followed` (see ORGANIZER_PROFILE_MOBILE_SPEC.md §3.3). |
| **Localized labels** | `status_label` is server-rendered in the request's `Accept-Language` locale. Mobile should still keep its own locale-driven labels (color tokens + Dart enum) so UI works offline / when the API call fails. |
| **Path-param flexibility** | Endpoints 1, 2 accept slug or UUID for the org; mobile should send `uuid` for stability across renames. |

---

## 19. Related specs

| Spec | When to read |
|---|---|
| `BOOKING_DETAIL_MOBILE_SPEC.md` | Booking flow on a private event (after acceptance, the user can book like any other event) |
| `BOOKING_CREATE_MOBILE_SPEC.md` | Reserving on a `members_only` event uses the same booking creation route — no special handling required |
| `ORGANIZER_PROFILE_MOBILE_SPEC.md` | The "Rejoindre" button lives on the organizer profile screen; mobile flow §14.2 cross-links to organizer profile UX |

---

## 20. Open questions / future work

| Topic | Note |
|---|---|
| **Members-only badge on event cards** | Mobile event cards display a "Privé 🔒" badge when `event.is_members_only == true`. The field is exposed by both `EventResource` (snake_case + camelCase mirror) and `MobileEventResource` (snake_case only) — confirmed as of this spec. |
| **Members-only event 403 gate** | Direct-link access to a private event by a non-member returns `HTTP 403` with `{"error": "members_only", "organization": {...}}`. Mobile should detect this in the event-detail call and render a gate screen with a "Rejoindre {Organization}" CTA — same flow as §14.2. |
| **Notification topic vs token** | Backend uses per-user device tokens (not topics) — when the user accepts an invitation and becomes a member, no automatic FCM topic subscription is created. If product wants "all members of org X get notified of new private events" via topic, that's a backend addition. |
| **Bulk invite UX preview** | The vendor-side `bulk-invite` endpoint exists but currently sends only email. If vendors want to invite via a shareable link mobile users can paste in-app, that's a separate enhancement. |
| **Membership expiry** | The current schema has no `expires_at` on `OrganizationMember`. If product wants annual memberships (sports clubs etc.), schema + UI changes are needed. |