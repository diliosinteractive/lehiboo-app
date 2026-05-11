# Event Password Unlock — Mobile Integration Spec

**Endpoint** : `POST /api/v1/events/{identifier}/verify-password`
**Audience** : Mobile app (Flutter — customer side)
**Status** : Stable contract
**Related** : [HOME_FEED_MOBILE_SPEC.md](./HOME_FEED_MOBILE_SPEC.md)

Used by mobile to **unlock and load** an event whose visibility is `public_protected` (or `private_protected` if accessed via a direct URL share). On success the endpoint **returns the full event payload in one shot** — the mobile UI does not need to call `GET /events/{slug}` afterwards.

This is the recommended path for password-protected events. The legacy `GET /api/v1/events/{slug-or-uuid}?password=…` form still works but transmits the password in the query string and forces clients to keep it for every subsequent fetch.

---

## TL;DR — Quick start

| Aspect | Value |
|---|---|
| Method | `POST` |
| Path | `/api/v1/events/{identifier}/verify-password` |
| `{identifier}` | event slug **or** event UUID (same as `GET /events/{slug}`) |
| Auth | Optional bearer token. Owners and active org members bypass the password gate. |
| Throttle | **6 attempts / minute / IP** (`throttle:6,1`) |
| Body | `{ "password": "<plain>" }` |
| Success response | `200` with `data` = full `MobileEventResource` (same shape as `GET /events/{slug}` with `X-Platform: mobile`) |
| Failure responses | `422` validation, `400` not protected, `403` invalid password, `403` members-only, `404` unknown, `429` rate-limited |

---

## 1. When to use this endpoint

Mobile receives `public_protected` events in `GET /api/v1/home-feed` and `GET /api/v1/events` like any public event — the gating itself only triggers on the detail screen. The list payload **does carry the locked-state flags** so mobile can render a lock badge directly on the card without an extra round-trip:

- `event.visibility == "public_protected"` (or `"private_protected"`)
- `event.is_password_protected == true` (mirror flag exposed by `MobileEventResource`)

Both fields are stable on every list payload (`/home-feed`, `/events`, `/me/personalized-feed`, search). Mobile should branch on `is_password_protected` — it covers both `public_protected` and `private_protected` and survives any future visibility enum additions.

When the user taps a locked event, the recommended flow is:

```
List screen (home-feed / search)
        │
        │ taps locked event
        ▼
Password sheet (collects plain password)
        │
        │ POST /events/{uuid}/verify-password   { password: "…" }
        ▼
   ┌────────────┴────────────┐
   ▼                         ▼
200 OK                  403 invalid_password
data = full event       → reshake sheet, keep counter
        │
        ▼
Navigate to detail screen using the returned payload
(no need to call GET /events/{slug} again)
```

> Do **not** call `GET /events/{slug}?password=…` after a successful verify — you already have the full payload, and re-sending the password on every refresh is what this endpoint was built to avoid.

---

## 2. Deep-link entry — opening a locked event without list context

When the user arrives from a share URL, a push notification deep-link, or any path that lacks a list payload (no `is_password_protected` flag pre-known), the mobile shell calls `GET /api/v1/events/{identifier}` first. The server reveals the locked state there — and intentionally returns enough metadata to render the lock sheet without a second request.

### 2.1 Plain `GET` on a protected event — locked-shell payload

```http
GET /api/v1/events/vernissage-galerie-x HTTP/1.1
Accept: application/json
X-Platform: mobile
Accept-Language: fr
```

```
HTTP/1.1 403 Forbidden
Content-Type: application/json
```

```json
{
  "success": false,
  "error": "password_required",
  "message": "Password required to access this event.",
  "data": {
    "uuid": "019bf01a-0cc3-7099-a238-770523035aa3",
    "slug": "vernissage-galerie-x",
    "title": "Vernissage privé — Galerie X",
    "excerpt": "…",
    "short_description": "…",
    "meta_title": "…",
    "meta_description": "…",
    "featured_image": "https://cdn.lehiboo.com/…",
    "cover_image": "https://cdn.lehiboo.com/…",
    "visibility": "public_protected",
    "is_password_protected": true
  }
}
```

| Field in `data` | Notes |
|---|---|
| `uuid`, `slug`, `title` | Identify the event and navigate to verify-password. |
| `excerpt` / `short_description` | Same value (emitted under both names for snake_case/camelCase compat). Use as the subtitle on the lock card. |
| `featured_image` / `cover_image` | Same URL (dual naming). Use as the lock screen background. |
| `meta_title` / `meta_description` | SEO meta; mobile can render or ignore. |
| `visibility` | `"public_protected"` or `"private_protected"`. |
| `is_password_protected` | Always `true` in this 403. |

The shell is enough to render the lock screen with the same visual as if the user had arrived from a list — without leaking slots, tickets, or the full description.

### 2.2 Wrong password on the legacy `GET ?password=…` form

If a stale share URL carries `?password=…` and the value is wrong, GET returns a **bare 403 with no preview**:

```json
{
  "success": false,
  "error": "invalid_password",
  "message": "Invalid password for this event."
}
```

No `data` block — distinct from the `password_required` shape above. Mobile should never end up here on a fresh deep-link; **strip `?password=` from any incoming URL** before issuing the GET and use the dedicated verify endpoint (§3 onwards) for the actual password attempt.

### 2.3 Recommended deep-link flow

```
Deep link (share URL / push / mobile://)
        │
        │ GET /events/{id}        (no password in URL)
        ▼
   ┌────────────┴────────────┐
   ▼                         ▼
200 OK                  403 password_required
data = full event       data = locked shell
        │                         │
        ▼                         ▼
Detail screen           Lock sheet renders from `data`
                                  │
                                  │ POST /events/{id}/verify-password { password }
                                  ▼
                            ┌─────┴─────┐
                            ▼           ▼
                          200 OK   403 invalid_password
                          data =   → reshake sheet
                          full
                            │
                            ▼
                          Detail screen
```

**Rule**: never pass the password as a query parameter. The plain GET stays clean for routing / logging / Sentry traces; the password only travels in the `POST` body to verify-password.

---

## 3. Request

### 3.1 Path parameter

| Param | Type | Resolution |
|---|---|---|
| `identifier` | string | Either the event's **slug** (`yoga-paris-2026`) or its **UUID v7** (`019bf01a-…`). The controller auto-detects via regex; mobile clients typically pass the UUID from the list payload. |

### 3.2 Headers

```
POST /api/v1/events/{identifier}/verify-password HTTP/1.1
Host: api.lehiboo.com
Accept: application/json
Content-Type: application/json
Accept-Language: fr             # optional, default fr
X-Platform: mobile              # REQUIRED — triggers MobileEventResource on success
Authorization: Bearer <token>   # optional — see §4
```

| Header | Required | Effect |
|---|---|---|
| `Accept: application/json` | yes | Standard. |
| `Content-Type: application/json` | yes | Body is JSON. |
| `X-Platform: mobile` | **strongly recommended** | Without it, the server returns the heavier web-shaped `EventResource` (more fields, sub-resources, no `venue` / `extra_services` eager-loading tuned for mobile). Set it to `mobile` to receive the same payload shape your detail screen already parses for `GET /events/{slug}` with `X-Platform: mobile`. |
| `Authorization` | optional | Read if present. **The password is always validated on this endpoint** — there is no owner/member bypass. Auth only matters for the members-only gate in §5.5. See §4 for the full table. |
| `Accept-Language` | optional | Drives translated fields in the success payload. Defaults to `fr`. |

### 3.3 Body

```json
{
  "password": "secret123"
}
```

| Field | Type | Constraints |
|---|---|---|
| `password` | string | required, `max:255` |

Any other body fields are ignored.

---

## 4. Auth semantics

The route uses `auth.optional` — the bearer is read if present but not required. **The password is always checked**, regardless of authentication. There is no owner/member bypass on this specific endpoint: it is a pure "is this password valid for this event?" check.

| Caller | Behaviour |
|---|---|
| Anonymous (no bearer) | Must send the correct password. |
| Authenticated, not org member | Must send the correct password. |
| Authenticated, org owner / active member | Must still send the correct password to use this endpoint. *(They can also call `GET /events/{slug}` directly without a password — that path bypasses the gate. Mobile should not rely on that — use `verify-password` uniformly.)* |

A `members_only` event additionally requires org membership **after** the password is validated — see §5.5.

---

## 5. Responses

### 5.1 `200 OK` — password accepted

Top-level wrapper follows the project standard for `JsonResource`-based responses:

```json
{
  "data": { /* MobileEventResource — identical shape to GET /events/{slug} with X-Platform: mobile */ }
}
```

The `data` object is **the exact same `MobileEventResource` payload** documented in [HOME_FEED_MOBILE_SPEC.md §4](./HOME_FEED_MOBILE_SPEC.md) for the event card, **plus** the heavier detail-screen relations:

- `slots` (all upcoming active slots, with `booked_count`)
- `ticket_types` (active only, ordered by `sort_order`)
- `indicative_prices`
- `related_events` (filtered by `accessibleByUser`)
- `venue` (full venue object)
- `extra_services` (active only)
- `organization` (with `establishment_types`)
- `categories.parent`
- `target_audiences`, `themes`, `special_events`, `emotions`, `event_tag`, `entry_type`
- `participations_count`
- `is_participating` (boolean, only meaningful for `booking_mode = discovery`)

This matches **byte-for-byte** what the detail screen receives today from `GET /events/{slug}` with `X-Platform: mobile` and a valid password — there's no divergence to handle.

### 5.2 `422 Unprocessable Entity` — body validation

Standard Laravel envelope:

```json
{
  "message": "Le champ password est obligatoire.",
  "errors": {
    "password": ["Le champ password est obligatoire."]
  }
}
```

Mobile clients SHOULD branch on the presence of `errors.password`, not on the localised text.

Triggered by: empty body, missing `password` key, non-string value, or `password` longer than 255 chars.

### 5.3 `400 Bad Request` — event is not password-protected

```json
{
  "success": false,
  "error": "event_not_protected",
  "message": "This event is not password protected."
}
```

Returned when the event exists and is published, but its `visibility` is not `public_protected` / `private_protected` (e.g. it's a regular `public` event). This indicates a **client bug** — the password sheet should never be shown for non-protected events. Mobile should log this and route the user to the standard detail screen.

### 5.4 `403 Forbidden` — invalid password

```json
{
  "success": false,
  "error": "invalid_password",
  "message": "Invalid password for this event."
}
```

The event is protected but the supplied password does not match. The mobile sheet should:

- shake / reshake the input
- clear the password field
- keep an internal counter and warn the user at e.g. 3 attempts that brute-forcing will be rate-limited (see §5.7)

### 5.5 `403 Forbidden` — members-only event

```json
{
  "success": false,
  "error": "members_only",
  "message": "Cet événement est réservé aux membres de l'organisateur.",
  "organization": {
    "uuid": "019bf01a-…",
    "slug": "la-boucherie-d-aix",
    "name": "La Boucherie d'Aix"
  }
}
```

The password was correct, **but** the event is additionally flagged `is_members_only` and the caller is neither an owner nor an active member of the organisation. The mobile UI should display a "Join the organizer's community to access this event" affordance pointing at the organization page identified by `organization.slug` / `organization.uuid`.

Anonymous callers will receive this response even if they enter the right password — they must log in first, then join the organization.

### 5.6 `404 Not Found` — unknown identifier

Empty body or Laravel default `firstOrFail` response. Triggered when:

- the slug/UUID does not exist, or
- the event status is not `published` or `private` (e.g. `draft`, `archived`).

Mobile should treat this the same way as opening a deleted event from any other surface.

### 5.7 `429 Too Many Requests` — rate-limited

Standard Laravel throttle envelope. The route is throttled at **6 requests per minute, per IP, per route** (`throttle:6,1`):

```
HTTP/1.1 429 Too Many Requests
Retry-After: 38
X-RateLimit-Limit: 6
X-RateLimit-Remaining: 0
X-RateLimit-Reset: 1714657238
```

```json
{
  "message": "Too Many Attempts."
}
```

Mobile should read `Retry-After` (seconds) and disable the submit button for that duration, surfacing a countdown to the user. The throttle key is the IP; legitimate users behind shared NAT may be hit faster than the literal "6 per user".

---

## 6. Flutter — recommended client shape

```dart
class EventUnlockResult {
  final MobileEvent? event;
  final EventUnlockError? error;
  final int? retryAfterSeconds;

  bool get ok => event != null;
}

enum EventUnlockError {
  invalidPassword,
  membersOnly,
  notProtected,
  rateLimited,
  validation,
  notFound,
  network,
}

Future<EventUnlockResult> verifyEventPassword({
  required String identifier,           // slug or UUID
  required String password,
}) async {
  final res = await dio.post(
    '/api/v1/events/$identifier/verify-password',
    data: {'password': password},
    options: Options(
      headers: {
        'X-Platform': 'mobile',
        'Accept-Language': locale.languageCode,
      },
      validateStatus: (s) => s != null && s < 500,
    ),
  );

  switch (res.statusCode) {
    case 200:
      return EventUnlockResult(event: MobileEvent.fromJson(res.data['data']));
    case 422:
      return EventUnlockResult(error: EventUnlockError.validation);
    case 400:
      return EventUnlockResult(error: EventUnlockError.notProtected);
    case 403:
      final code = res.data?['error'];
      return EventUnlockResult(
        error: code == 'members_only'
            ? EventUnlockError.membersOnly
            : EventUnlockError.invalidPassword,
      );
    case 404:
      return EventUnlockResult(error: EventUnlockError.notFound);
    case 429:
      final retry = int.tryParse(res.headers.value('retry-after') ?? '');
      return EventUnlockResult(
        error: EventUnlockError.rateLimited,
        retryAfterSeconds: retry,
      );
    default:
      return EventUnlockResult(error: EventUnlockError.network);
  }
}
```

The `MobileEvent.fromJson` parser is the **same** one used for `GET /events/{slug}` — no separate model is needed.

---

## 7. UX guidelines

| Concern | Recommendation |
|---|---|
| Where to surface "locked" state | List card badge + lock icon next to the title when `event.is_password_protected == true`. |
| Sheet copy | "Cet événement est privé. Entre le mot de passe communiqué par l'organisateur." — localise via `Accept-Language`. |
| Password persistence | **Do not store** the password on device after a successful unlock. The full event payload is returned in the same call, so there is no second fetch that needs the password. Re-prompt only if the user navigates away and back, or pull-to-refreshes the detail screen. |
| Caching the unlocked event | Cache the returned `data` like any other event detail (by `uuid` + `version`). `version` increments on edits, so a stale cached "unlocked" payload is automatically invalidated when the organizer republishes. |
| Failed attempts | Show invalid-password shake on `403 invalid_password`. After 3 client-side failures, prepend a warning "Encore 3 essais avant un délai de 1 minute." (server still has authority; client counter is just UX). |
| Throttled (`429`) | Disable submit button, show countdown using `Retry-After`. Do not retry automatically. |
| Members-only fallback | When `error == "members_only"`, replace the sheet with a CTA card linking to the organizer page (`organization.slug`). |
| Logout / token refresh | The endpoint accepts anonymous calls; logout does not affect ability to unlock public_protected events. |

---

## 8. Example calls

### 8.1 Successful unlock by UUID (mobile shape)

```bash
curl -s -X POST "https://api.lehiboo.com/api/v1/events/019bf01a-0cc3-7099-a238-770523035aa3/verify-password" \
  -H "Content-Type: application/json" \
  -H "X-Platform: mobile" \
  -H "Accept-Language: fr" \
  -d '{"password":"secret123"}' | jq '.data | {uuid, title, visibility, is_password_protected, slots: (.slots | length)}'
```

```json
{
  "uuid": "019bf01a-0cc3-7099-a238-770523035aa3",
  "title": "Vernissage privé — Galerie X",
  "visibility": "public_protected",
  "is_password_protected": true,
  "slots": 3
}
```

### 8.2 Wrong password

```bash
curl -i -X POST "https://api.lehiboo.com/api/v1/events/vernissage-galerie-x/verify-password" \
  -H "Content-Type: application/json" \
  -d '{"password":"wrong"}'
```

```
HTTP/1.1 403 Forbidden
Content-Type: application/json

{"success":false,"error":"invalid_password","message":"Invalid password for this event."}
```

### 8.3 Non-protected event (client bug)

```bash
curl -i -X POST "https://api.lehiboo.com/api/v1/events/yoga-paris-public/verify-password" \
  -H "Content-Type: application/json" \
  -d '{"password":"whatever"}'
```

```
HTTP/1.1 400 Bad Request
Content-Type: application/json

{"success":false,"error":"event_not_protected","message":"This event is not password protected."}
```

### 8.4 Rate limit reached

```bash
# After 6 attempts in the same minute from the same IP
curl -i -X POST "https://api.lehiboo.com/api/v1/events/vernissage-galerie-x/verify-password" \
  -H "Content-Type: application/json" \
  -d '{"password":"wrong"}'
```

```
HTTP/1.1 429 Too Many Requests
Retry-After: 41
X-RateLimit-Limit: 6
X-RateLimit-Remaining: 0

{"message":"Too Many Attempts."}
```

---

## 9. Source of truth

| Concern | File |
|---|---|
| Route | `api/routes/api.php:293-295` (name `v1.events.verify-password`) |
| Controller | `api/app/Http/Controllers/Api/V1/EventController.php` — `verifyPassword()` |
| Password check | `api/app/Models/Event.php` — `verifyPassword()` (Bcrypt via `Hash::check`) |
| Visibility predicate | `api/app/Enums/EventVisibility.php` — `requiresPassword()` returns true for `public_protected` and `private_protected` |
| Members-only gate | `api/app/Models/Event.php` — `isMembersOnly()` |
| Platform detection (`X-Platform`) | `api/app/Http/Middleware/DetectPlatform.php` |
| Response shape | `api/app/Http/Resources/Mobile/MobileEventResource.php` (mobile) / `api/app/Http/Resources/EventResource.php` (web fallback when `X-Platform` is absent) |

---

## 10. Versioning & deprecation

This endpoint is additive — it does **not** deprecate the legacy `GET /events/{slug}?password=…` path. The query-string form remains supported for backwards compatibility with the web frontend. The web frontend may be migrated in a later iteration; mobile should adopt `verify-password` for all new code.

No breaking changes are planned for the response envelope. Field additions to `MobileEventResource` will follow the same additive policy applied to `GET /events/{slug}` and `GET /home-feed`.