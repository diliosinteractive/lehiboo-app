# Home Feed — Mobile Integration Spec

**Audience** : Mobile app (Flutter — customer side)
**Status** : Stable contract
**Scope** : The first screen the customer sees after launching the app. Returns three pre-grouped lists of events (today / tomorrow / recommended) optimised for vertical scrolling.

The endpoint is **public** (works without authentication) but **auth-aware** — when a bearer token is provided, the response also includes private events from organisations the user is a member of.

---

## TL;DR — Quick start

| Aspect | Value |
|---|---|
| Method | `GET` |
| Path | `/api/v1/home-feed` |
| Auth | Optional bearer token. With token → also returns member-only events. Without → public events only. |
| Query | `?limit=10` (1-20, default 10) `&city=Lyon` (optional, ILIKE substring match) |
| Response shape | `{ success, data: { today, tomorrow, recommended, location_provided } }` |
| Pagination | **None.** `limit` caps each section. Return is a single shot. |
| Cache | Recommend 60s stale, refetch on foreground/pull-to-refresh. |

---

## 1. Endpoint contract

```
GET /api/v1/home-feed
GET /api/v1/home-feed?limit=8&city=Lyon
```

### 1.1 Headers

| Header | Required? | Notes |
|---|---|---|
| `Accept: application/json` | yes | Standard. |
| `Authorization: Bearer <token>` | optional | When present, the user's joined-organisations' private events are included (see §1.4). |
| `Accept-Language: fr` | optional | Sets the locale for translated display fields (`dates.display`, `pricing.display`, `Gratuit` label, organizer-side defaults). Defaults to `fr`. |

### 1.2 Query parameters

| Name | Type | Default | Constraints | Effect |
|---|---|---|---|---|
| `limit` | integer | `10` | min `1`, max `20` | Caps **each** section independently. `limit=10` → up to 10 today, 10 tomorrow, 10 recommended. |
| `city` | string | (none) | max 100 chars | PostgreSQL `ILIKE %city%` substring match against `events.city`. Case-insensitive. `Lyon` matches "Lyon", "lyon", "Saint-Lyon" alike. |

Validation errors return **422** with the standard Laravel validation envelope. Verbatim example for `?limit=0`:

```json
{
  "message": "Le champ limit doit être au moins 1.",
  "errors": {
    "limit": ["Le champ limit doit être au moins 1."]
  }
}
```

The `message` and `errors[*]` strings are **localised** (French by default; respects `Accept-Language`). Mobile clients SHOULD branch on the presence of the `errors.limit` key, **not** on the localised text. The keys (`limit`, `city`) are stable.

### 1.3 Auth model — what changes with a bearer token

The controller calls `Event::accessibleByUser($user)` (`api/app/Models/Event.php:583`). Behaviour:

| Caller | Visible events |
|---|---|
| **Anonymous** (no bearer) | Only `status=published` AND `visibility ∈ {public, public_protected}` |
| **Authenticated** | The above **plus** events from organisations where the user has an `active` membership AND `status ∈ {published, private}` (i.e. private events that the user has been admitted to) |

This means a logged-in member of "La Boucherie d'Aix" sees that org's private members-only events in their home feed. Logged-out users never do.

Tokens come from `POST /api/v1/auth/login`. The endpoint does not require email verification or onboarding completion — once the bearer is valid, member-only events become visible.

### 1.4 No pagination — by design

There is no `page` / `cursor` / continuation token. The home feed is intentionally a **fixed-size hero shot** of up to `3 × limit` events (max 60). Mobile clients seeking more events should:

- For "show more events tomorrow" → call `GET /api/v1/events?date_from=…` with proper pagination.
- For "show all of org X's events" → call `GET /api/v1/events?organization_id=…`.

The home feed is not the right surface for infinite-scroll.

---

## 2. The three sections — selection logic

All three sections share the same base filter: `is_active=true` AND `accessibleByUser=true` AND (optional) `city ILIKE %…%`. They differ in slot-date and ordering.

### 2.1 `today`

Events that have **at least one active slot** with `slot_date = today` (server timezone).

**Order**: `is_featured DESC` (featured events float to the top), then DB-natural for ties.
**Cap**: `limit` (default 10).

### 2.2 `tomorrow`

Events that have **at least one active slot** with `slot_date = today + 1 day`.

**Order**: `is_featured DESC`.
**Cap**: `limit`.

> An event with slots both today and tomorrow appears in **both** sections — the controller does **not** deduplicate across `today` and `tomorrow`. A mobile client showing both sections back-to-back may want to dedupe by `uuid` before rendering, or accept the duplication as a "this event is available both days" signal.

### 2.3 `recommended`

A two-pass query designed to surface editorial picks first, then top up with anything upcoming:

**Pass 1**: `is_featured=true` AND has at least one active slot with `slot_date > tomorrow`. Ordered by `published_at DESC`. Capped at `limit`.

**Pass 2** (only if pass 1 returned fewer than `limit` rows): any event with at least one active slot from `today` onward, **excluding** the events already in `today`, `tomorrow`, and pass 1. Ordered by `published_at DESC`. Capped at `limit - count(pass1)`.

The merged result is up to `limit` items. This guarantees `recommended` is never empty unless there are literally no upcoming events in the catalogue.

> The recommendation is **not personalised** today. It does not consider the user's past bookings, followed organisations, location proximity, saved-search alerts, or any ML signal. If/when that lands, the contract evolves additively (existing fields stay; new ones added).

### 2.4 Server timezone

`today` and `tomorrow` are computed against `now()` on the API server (default `UTC` in Laravel; check `config/app.php` for the deployed value). Mobile clients in a different timezone should **not** re-compute these labels client-side — trust the server's grouping. The actual `dates.start_time` on each slot is in the event's own `timezone` field (see §4.2).

---

## 3. Response envelope

### 3.1 Top-level structure

```jsonc
{
  "success": true,
  "data": {
    "today": [/* array of MobileEventResource */],
    "tomorrow": [/* array of MobileEventResource */],
    "recommended": [/* array of MobileEventResource */],
    "location_provided": false
  }
}
```

| Field | Type | Notes |
|---|---|---|
| `success` | boolean | Always `true` on 2xx. |
| `data.today` | array | Up to `limit` event objects. May be empty. |
| `data.tomorrow` | array | Up to `limit` event objects. May be empty. |
| `data.recommended` | array | Up to `limit` event objects. Empty only if catalogue has no upcoming events. |
| `data.location_provided` | boolean | **Hardcoded `false` in current implementation.** Reserved for a future location-aware variant; mobile clients SHOULD ignore the value and treat this as informational only. See §10. |

### 3.2 Empty response

A valid empty response (off-season, no upcoming events at all):

```json
{
  "success": true,
  "data": {
    "today": [],
    "tomorrow": [],
    "recommended": [],
    "location_provided": false
  }
}
```

The mobile UI should render an empty-state for each section independently. **All three sections empty simultaneously** is the cue to show "Aucun événement à proximité — découvre la programmation à venir" or similar.

---

## 4. Event item — `MobileEventResource` breakdown

Each entry in `data.today / tomorrow / recommended` is a `MobileEventResource` (`api/app/Http/Resources/Mobile/MobileEventResource.php`). Snake_case only — there is **no** dual snake/camel format on this resource (unlike the dual-format admin resources). Mobile clients should adopt snake_case throughout for these fields.

The shape is **72 keys** (verified against a live `staging` response — see §6.1). A complete realistic example is at §6.

### 4.0 Field summary — verified field count per nested object

| Field path | Key count | Verified? |
|---|---|---|
| Top-level event (discovery mode) | 72 keys | ✅ Live response |
| Top-level event (booking mode) | 70 keys | ✅ — see note below |
| `availability` | 4 keys | ✅ |
| `dates` | 7 keys | ✅ |
| `pricing` | 5 keys | ✅ |
| `location` | 7 keys | ✅ |
| `primary_category` | 6 keys | ✅ |
| `organizer` | 13 keys | ✅ |
| `venue` (when not null) | 5 keys | ✅ |

> The 2-key delta between modes is `participation_count` and `is_participating` — both are emitted **only when `booking_mode === "discovery"`** (gated via `$this->when(...)` in `MobileEventResource`). Booking-mode events strip both keys entirely (not present, not `null`). The §6 example is a discovery event, hence 72 keys.

If a future backend change adds or removes top-level fields, the diff will show up against this table — useful for spec maintenance.

### 4.1 Identification & content

| Field | Type | Notes |
|---|---|---|
| `uuid` | string | Stable public ID. Use this for navigation, caching keys, etc. |
| `slug` | string | URL-friendly identifier. Used in `data.action` deep-links from push notifications. |
| `title` | string | Localised. |
| `description` | string \| null | Long form. **Plain text** — typically contains `\r\n` (Windows-style) or `\n` line breaks; preserve them when rendering. Not HTML in observed responses. |
| `excerpt` | string \| null | Short summary, plain text. |
| `featured_image` | string \| null | Full URL to the cover image. |
| `gallery` | array<string> \| null | Array of full URLs. |
| `version` | integer | Increments on edit; useful for invalidating mobile caches per event. |

### 4.2 Type, scheduling & timezone

| Field | Type | Notes |
|---|---|---|
| `event_type` | string | One of `"offline"`, `"online"`, `"hybrid"` (per `App\Enums\EventType`). |
| `calendar_mode` | string | One of `"manual"`, `"recurrence"` (per `App\Enums\CalendarMode`). Affects how slots should be rendered. |
| `timezone` | string | IANA tz identifier, e.g. `"Europe/Paris"`. **Caveat**: the slot times in `start_datetime` / `end_datetime` are formatted using the **server's** default timezone (Carbon `parse` without an explicit zone), not necessarily this field. For a French-hosted server with `Europe/Paris` events, the two coincide; for events in other zones, expect the server-zone interpretation of the wall-clock time. |
| `booking_mode` | string | One of `"booking"` or `"discovery"` (per `App\Enums\BookingMode`). Drives which CTAs the mobile UI shows. (CLAUDE.md mentions a third `"showcase"` value — that's stale; the enum has only the two.) |

### 4.3 Venue & location

Two parallel representations are returned for client convenience:

**Flat fields** (use these for quick rendering):

| Field | Notes |
|---|---|
| `venue_name`, `venue_address`, `city`, `postal_code`, `country` | Plain strings. |
| `address_source` | `"custom"` (free-typed) or `"venue"` (linked to a venue record). |
| `venue_id` | UUID of the linked `MobileVenueResource` (if `address_source=venue`), else `null`. |

**Structured `location` object** (use for maps):

```json
"location": {
  "name": "Stade Municipal",
  "address": "12 rue des Sports",
  "city": "Valenciennes",
  "postal_code": "59300",
  "country": "FR",
  "lat": "50.3266860",
  "lng": "3.3944760"
}
```

| Field | Type | Notes |
|---|---|---|
| `country` | string | **Top-level (flat) `country`** is the raw column — ISO 3166-1 alpha-2 (e.g. `"FR"`, `"BE"`) or `null` when the column is unset. **`location.country`** is *not* nullable: it falls back to the literal string `"France"` when `events.country` is null (resource code: `$this->country ?? 'France'`). In production virtually every event has the alpha-2 code set, so this fallback is rarely observed — but mobile clients that branch on `location.country == null` will never trigger, and clients that assume a 2-character code must tolerate the `"France"` fallback string. Treat the flat `country` as the source of truth for ISO codes. |
| `lat`, `lng` | **string \| null** | Returned as decimal **strings** (PostgreSQL `decimal:7` cast through Eloquent — `Event.php:1361-1362`), not as JSON numbers. Mobile clients MUST `double.parse()` / `Double(value)` before passing to a map widget. May be `null` when neither the event row nor the linked venue carries coordinates — the mobile UI should fall back gracefully (e.g. hide the "Open in Maps" CTA). |

### 4.4 Dates

```json
"start_date": "2026-05-08T00:00:00+02:00",
"end_date": null,
"dates": {
  "start_date": "2026-05-08",
  "end_date": "2026-05-08",
  "start_time": "18:00:00",
  "end_time": "20:00:00",
  "display": "vendredi 08 mai 2026",
  "duration_minutes": 120,
  "is_recurring": false
}
```

| Field | Notes |
|---|---|
| `start_date` (top-level) | ISO 8601 of the **first slot's date** (midnight, in event timezone). May be `null` if no slots loaded. |
| `end_date` (top-level) | Currently always `null` — reserved for multi-day events; not populated by the resource yet. |
| `dates.display` | Human-readable, in `Accept-Language` locale (`vendredi 08 mai 2026` for `fr`). |
| `dates.duration_minutes` | Integer in practice. Computed as `(strtotime(end_time) − strtotime(start_time)) / 60` — for HH:MM:SS times the difference is always a multiple of 60, so PHP returns an int and the JSON value is unquoted. **No explicit `(int)` cast** is applied here (unlike `slots[*].duration_minutes` which casts), so a future change to sub-minute granularity would silently emit a float. May be `null` if either time is missing. |
| `dates.is_recurring` | Currently always `false` — reserved. |

For events with multiple slots, `dates` describes only the **first upcoming** slot. The full list is in `slots` (§5.1).

### 4.5 Pricing

```json
"price_from": 12.5,
"is_free": false,
"pricing": {
  "is_free": false,
  "min": 12.5,
  "max": 25.0,
  "currency": "EUR",
  "display": "12,50€"
}
```

| Field | Type | Notes |
|---|---|---|
| `price_from` | number | Cheapest paid ticket type (or `0` if all are free). For `discovery` mode, derived from `indicative_prices` or `base_price`. **JSON serialisation**: PHP casts to `(float)`, but `json_encode` strips trailing zeroes — `22.00` becomes `22`, `12.50` stays `12.5`. Mobile clients MUST accept both `int` and `float` and parse as `double` defensively. |
| `is_free` | boolean | `true` only if all active ticket types are free. |
| `pricing.min` / `pricing.max` | number | Same int-or-float JSON serialisation as `price_from`. Range across active ticket types — equal when there's only one type. **Edge case (discovery mode)**: when `booking_mode === "discovery"` and the event has no `ticket_types` (typical), `pricing.min` is derived from `indicative_prices` while `pricing.max` defaults to `0`. So `pricing.max < pricing.min` is a normal observable state for discovery events — do not surface "from X to 0€". For discovery events, prefer rendering `pricing.display` (which uses `min` only) rather than computing your own range. |
| `pricing.display` | string | Localised. `"Gratuit"` when free, otherwise `"12,50€"` style with the configured `currency`. |

### 4.6 Capacity & availability

```json
"capacity_global": 100,
"availability": {
  "status": "available",
  "total_capacity": 100,
  "spots_remaining": 73,
  "percentage_filled": 27
}
```

| Field | Type | Notes |
|---|---|---|
| `capacity_global` | integer \| null | Often `null` — many events (especially discovery-mode and crawler-imported) have no global cap configured. Don't render "0 spots" when this is null; use `availability.total_capacity` instead. |
| `availability.status` | string | `"available"` (event accepts bookings now) or `"unavailable"` (sale not started, sold out, paused). The mobile UI gates the "Book" CTA on this. |
| `availability.total_capacity` | integer | Sum across loaded slots. Returns `0` when no slot has a `capacity` set (common for discovery events — capacity is not a meaningful concept there). Treat `0` as "uncapped/N-A", not "sold out". |
| `availability.spots_remaining` | integer | `total_capacity − sum(booked)`, clamped at zero. With `total_capacity=0`, this is also `0` — see note above. |
| `availability.percentage_filled` | integer | 0-100. Useful for "Almost sold out" badges (`> 80`). When `total_capacity=0`, this is `0` — meaningless, don't render. |

### 4.7 Sale period & cancellation

| Field | Notes |
|---|---|
| `sale_start_at` / `sale_end_at` | ISO 8601 or `null`. The booking window. Mobile shows "Sale opens in 3 days" UI when `now < sale_start_at`. |
| `allow_cancellation` | boolean. Drives whether the customer's "Cancel booking" UI is enabled later. |
| `cancel_before_hours` | integer. Cutoff in hours before slot start. |
| `generate_qr_codes` | boolean. Whether tickets carry QR (vendor's choice). |

### 4.8 Status & flags

| Field | Notes |
|---|---|
| `status` | `"published"` or `"private"` (only the latter when shown to a member). |
| `creation_source` | One of `"vendor"` (created in the dashboard), `"crawler"` (imported by the scraping pipeline), `"admin_manual"` (created admin-side). Per `App\Enums\EventCreationSource`. |
| `original_organizer_name` | For crawler-imported events: the original publisher's name (from the scraping source). Use it as a sub-credit on the card. `null` for vendor / admin-manual events. |
| `visibility` | One of `"public"`, `"unlisted"`, `"public_protected"`, `"private"`, `"private_protected"` (per `App\Enums\EventVisibility`). |
| `is_password_protected` | Boolean. **Drives the password prompt UX** — true only when the event's `visibility` is `public_protected` or `private_protected` (computed via `Event::requiresPassword()`). Mobile clients SHOULD gate the password modal on this field. |
| `has_password` | Boolean. Reflects whether the `password` column is non-null, **independent of visibility**. The two flags can diverge: an event with `visibility=public` and a password set returns `has_password=true` but `is_password_protected=false` — the UI must NOT prompt in that case. Treat `has_password` as informational; do not use it for gating. |
| `published_at`, `scheduled_publish_at` | ISO 8601 \| `null`. |
| `is_featured` | Editorial flag — used for sorting (§2). Mobile UI may render a "À la une" badge. |
| `is_active`, `is_members_only`, `is_on_sale`, `is_live` | Booleans. Note `is_members_only` is **derived** (`Event::isMembersOnly()`), not the raw column — use this. |

### 4.9 Booking capabilities

| Field | Notes |
|---|---|
| `can_accept_bookings` | True for `booking` mode + active + on sale. |
| `can_accept_discovery` | True for `discovery` mode + active. The customer presses "Je participe" rather than buying a ticket. |
| `is_discovery` | Convenience boolean. |
| `participation_count` | Only present when `booking_mode === "discovery"`. The current RSVP count. |
| `is_participating` | Only present when `booking_mode === "discovery"` AND the user is authenticated. Whether the current user has RSVPed. |
| `discovery_pricing_type` | `"free"` or `"paid"` (for discovery mode). |
| `external_ticketing_url` | Optional — when set, the mobile UI opens this URL instead of the in-app booking flow. |

### 4.10 Services & attributes

| Field | Notes |
|---|---|
| `services`, `other_services` | Free-form per-event service flags (parking, accessibility, etc.). May be a JSON object (`{services: {…}, accessibility: {…}}`) or `null`. Format depends on the editorial form. |
| `entry_type_id` | The key is always present; the value is the integer ID of a seeded entry type, or `null` when no entry type has been set on the event (the column is nullable). The §6 example shows the `null` case. |
| `event_tag_id` / `event_tag` | Reference to a tag. `event_tag` returns `{id, name}` (eager-loaded). |
| `venue_type` | Free-string or seeded value (e.g. `"indoor"`). May be `null`. |

> ⚠️ **Not present in `/home-feed` responses** (defined on `MobileEventResource` but **not eager-loaded** by `EventController::homeFeed`):
> `target_audiences`, `themes`, `special_events`, `emotions`, `entry_type` (the resolved object — only the `_id` is returned).
>
> These fields appear on **other** endpoints that load the corresponding relations (typically the event detail endpoint `/v1/events/{slug}`). Mobile clients that need them on the home screen would have to either (a) fetch detail per event, or (b) ask the backend to add them to the home-feed eager-load list. Filing the latter as a small follow-up is preferable to N detail calls.

### 4.11 Relations (nested resources — see §5)

| Field | Resource |
|---|---|
| `organizer` | Inline organizer object (see §5.2). |
| `primary_category` | Inline category object with `parent`. |
| `categories` | Array of `MobileCategoryResource`. |
| `slots` | Array of `MobileSlotResource`. |
| `ticket_types` | Array of `MobileTicketTypeResource`. |
| `venue` | Inline `MobileVenueResource` when `address_source=venue`. **Explicitly `null`** (not absent, not `{}`) when `address_source=custom`. |
| `extra_services` | Array of `MobileExtraServiceResource`. |
| `indicative_prices` | Array of `MobileIndicativePriceResource` (used in `discovery` mode). |

### 4.12 SEO & metadata

| Field | Notes |
|---|---|
| `meta_title`, `meta_description` | Used for share previews. |
| `meta` | Free-form JSON for vendor-specific extensions. |
| `created_at`, `updated_at` | ISO 8601. |

---

## 5. Sub-resources — exact shapes

### 5.1 Slot — `MobileSlotResource`

```json
{
  "uuid": "slot-9f2a-…",
  "date": "2026-05-08",
  "start_time": "18:00:00",
  "end_time": "20:00:00",
  "start_datetime": "2026-05-08T18:00:00+02:00",
  "end_datetime": "2026-05-08T20:00:00+02:00",
  "duration_minutes": 120,
  "capacity": 50,
  "available_capacity": 37,
  "is_available": true,
  "is_past": false,
  "is_today": true
}
```

| Field | Notes |
|---|---|
| `capacity` | integer \| null. **Often `null` for discovery-mode events** (no capacity tracking). |
| `available_capacity` | integer. `max(0, capacity − booked_count)`. When `capacity` is `null`, this is `0`. |
| `is_available` | boolean. Computed as `is_active && !is_past && available_capacity > 0`. **⚠️ Caveat for discovery events**: because `capacity` is typically `null` for discovery slots, `available_capacity` evaluates to `0` and `is_available` therefore returns `false` for every future-dated discovery slot. **Mobile UIs MUST NOT gate the slot picker on `is_available` alone for discovery events** — for `booking_mode === "discovery"`, treat all `!is_past` slots as selectable regardless. For `booking_mode === "booking"`, `is_available` is reliable. |
| `is_past` / `is_today` | Computed against the server clock — trust them rather than re-computing. |

### 5.2 Organizer — inline object

```json
"organizer": {
  "uuid": "org-abc-123",
  "name": "La Boucherie d'Aix",
  "slug": "la-boucherie-aix",
  "logo": "https://minio.lehiboo.com/orgs/.../logo.png",
  "type": "venue",
  "is_platform": false,
  "verified": true,
  "description": "...",
  "events_count": 24,
  "followers_count": 1820,
  "venue_types": ["Restaurant", "Bar"],
  "member_since": "2025-08-12T10:00:00+02:00",
  "allow_public_contact": true
}
```

| Field | Notes |
|---|---|
| `type` | One of `"vendor"`, `"business"`, `"platform"` (per `App\Enums\OrganizationType`). May be `null`. |
| `verified` | True only when the organisation status is `Verified`. Drives the verified-checkmark badge. |
| `is_platform` | True for the in-house "Le Hiboo" account that owns scraped/imported events (`type === "platform"`). Crawler-imported events are owned by such an account; the visible publisher name is in `original_organizer_name` on the event row. |
| `events_count` | Count of `published` events for this org. |
| `allow_public_contact` | Whether the "Contact" CTA on the org page should be visible. |

### 5.3 Category — `MobileCategoryResource`

```json
{
  "id": 12,
  "name": "Concerts",
  "slug": "concerts",
  "icon": "music",
  "color": "#FF4444",
  "is_primary": true,
  "parent": {
    "id": 3,
    "name": "Musique",
    "slug": "musique",
    "icon": "music-2",
    "color": "#FF4444"
  }
}
```

| Field | Notes |
|---|---|
| `is_primary` | Only present when the pivot is loaded. `true` for the canonical category of the event (mirrors `primary_category`). |
| `parent` | Loaded for tree-aware UI (breadcrumbs, parent badges). May be `null` for top-level categories. |

### 5.4 Venue — `MobileVenueResource`

```json
{
  "uuid": "venue-…",
  "name": "Stade Municipal",
  "slug": "stade-municipal",
  "services": {},
  "accessibility": {}
}
```

`services` and `accessibility` are JSON objects whose schema varies per venue. Mobile clients should treat them as free-form key/value maps and only render keys they recognise.

### 5.5 Ticket type — `MobileTicketTypeResource`

```json
{
  "uuid": "tt-…",
  "name": "Adulte",
  "description": "Tarif standard",
  "price": 12.5,
  "price_type": "fixed",
  "currency": "EUR",
  "formatted_price": "12,50€",
  "is_free": false,
  "min_per_order": 1,
  "max_per_order": 10,
  "is_available": true,
  "is_sold_out": false,
  "sort_order": 0
}
```

### 5.6 Extra service — `MobileExtraServiceResource`

```json
{
  "uuid": "es-…",
  "name": "Boisson",
  "description": "Une boisson au choix",
  "price": 4.0,
  "formatted_price": "4,00€",
  "is_free": false,
  "max_quantity": 5,
  "is_active": true,
  "sort_order": 0
}
```

### 5.7 Indicative price — `MobileIndicativePriceResource`

Used in `discovery` mode where the event isn't ticketed in-app but the vendor wants to advertise reference prices.

```json
{
  "uuid": "ip-…",
  "label": "Adulte",
  "price": 12.0,
  "currency": "EUR",
  "sort_order": 0
}
```

---

## 6. Complete realistic response example

Truncated to one event per section for readability (real responses contain up to `limit` per section). Values are **verified against an actual `staging` server response** — see §6.1 below for a verbatim curl reproduction.

```json
{
  "success": true,
  "data": {
    "today": [
      {
        "uuid": "019d35e0-f585-7286-be2b-a3146b6cef7f",
        "slug": "evermore-hommage-a-mylene-farmer",
        "title": "Evermore - Hommage à Mylène Farmer",
        "description": "Evermore est l'hommage scénique incontournable à Mylène Farmer…",
        "excerpt": "Musiciens, danseurs, costumes et lumières immersives pour un hommage sombre et poétique à Mylène Farmer au Théâtre de Denain.",
        "featured_image": "https://storage-staging.lehiboo.com/lehiboo-media/organizations/019d35e0-…/media/cf283368-….webp",
        "gallery": [],

        "event_type": "offline",
        "calendar_mode": "manual",
        "timezone": "Europe/Paris",
        "booking_mode": "discovery",

        "venue_name": "Théâtre Municipal de Denain",
        "venue_address": "Rue Villars 59220 Denain",
        "city": "Denain",
        "postal_code": "59220",
        "country": "FR",
        "address_source": "venue",
        "venue_id": "019d35e8-38ca-7366-95de-d002fea42735",

        "location": {
          "name": "Théâtre Municipal de Denain",
          "address": "Rue Villars 59220 Denain",
          "city": "Denain",
          "postal_code": "59220",
          "country": "FR",
          "lat": "50.3266860",
          "lng": "3.3944760"
        },

        "start_date": "2026-05-07T00:00:00+02:00",
        "end_date": null,
        "dates": {
          "start_date": "2026-05-07",
          "end_date": "2026-05-07",
          "start_time": "20:00:00",
          "end_time": "22:00:00",
          "display": "jeudi 07 mai 2026",
          "duration_minutes": 120,
          "is_recurring": false
        },

        "price_from": 22,
        "is_free": false,
        "pricing": {
          "is_free": false,
          "min": 22,
          "max": 0,
          "currency": "EUR",
          "display": "22,00€"
        },

        "capacity_global": null,
        "availability": {
          "status": "available",
          "total_capacity": 0,
          "spots_remaining": 0,
          "percentage_filled": 0
        },

        "sale_start_at": null,
        "sale_end_at": null,
        "allow_cancellation": true,
        "cancel_before_hours": 24,
        "generate_qr_codes": true,

        "status": "published",
        "creation_source": "crawler",
        "original_organizer_name": "Théâtre de Denain",
        "visibility": "public",
        "is_password_protected": false,
        "has_password": false,
        "published_at": "2026-03-29T11:57:23+02:00",
        "scheduled_publish_at": null,
        "is_featured": false,
        "is_active": true,
        "is_members_only": false,
        "is_on_sale": true,
        "is_live": true,

        "can_accept_bookings": false,
        "can_accept_discovery": true,
        "is_discovery": true,
        "participation_count": 0,
        "is_participating": false,
        "discovery_pricing_type": "paid",
        "external_ticketing_url": null,

        "services": {
          "services": { "transport": true, "parking": true },
          "accessibility": { "pmr": true }
        },
        "other_services": null,
        "entry_type_id": null,
        "event_tag_id": 11,
        "event_tag": { "id": 11, "name": "Concert" },
        "venue_type": "indoor",

        "organizer": {
          "uuid": "019d35e0-df2b-71a9-b8b9-5f8eaf7b3cc4",
          "name": "Théâtre de Denain",
          "slug": "theatre-de-denain",
          "logo": null,
          "type": "platform",
          "is_platform": true,
          "verified": true,
          "description": null,
          "events_count": 8,
          "followers_count": 0,
          "venue_types": [],
          "member_since": "2026-03-28T20:17:02+01:00",
          "allow_public_contact": true
        },

        "primary_category": {
          "id": 59,
          "name": "Concert & Musique",
          "slug": "concert-musique",
          "icon": "theater",
          "color": "#E91E63",
          "parent": {
            "id": 57,
            "name": "Spectacles & Événements",
            "slug": "spectacles-evenements",
            "icon": "theater",
            "color": "#E91E63"
          }
        },
        "categories": [
          {
            "id": 59,
            "name": "Concert & Musique",
            "slug": "concert-musique",
            "icon": "theater",
            "color": "#E91E63",
            "is_primary": true,
            "parent": {
              "id": 57,
              "name": "Spectacles & Événements",
              "slug": "spectacles-evenements",
              "icon": "theater",
              "color": "#E91E63"
            }
          }
        ],

        "slots": [
          {
            "uuid": "019d3932-eab9-726a-9fad-72accc6c9274",
            "date": "2026-05-07",
            "start_time": "20:00:00",
            "end_time": "22:00:00",
            "start_datetime": "2026-05-07T20:00:00+02:00",
            "end_datetime": "2026-05-07T22:00:00+02:00",
            "duration_minutes": 120,
            "capacity": null,
            "available_capacity": 0,
            "is_available": false,
            "is_past": false,
            "is_today": true
          }
        ],

        "ticket_types": [],
        "venue": {
          "uuid": "019d35e8-38ca-7366-95de-d002fea42735",
          "name": "Théâtre Municipal de Denain",
          "slug": "theatre-municipal-de-denain",
          "services": { "transport": true, "parking": true },
          "accessibility": { "pmr": true }
        },
        "extra_services": [],
        "indicative_prices": [
          {
            "uuid": "019d3905-67cb-710a-8863-c006fdccb829",
            "label": "Tarif unique",
            "price": 22,
            "currency": "EUR",
            "sort_order": 0
          }
        ],

        "meta_title": "Evermore – Hommage à Mylène Farmer | Concert à Denain | LeHi",
        "meta_description": "Musiciens, danseurs et lumières immersives pour un hommage sombre et poétique à Mylène Farmer. Théâtre de Denain, 7 mai 2026.",
        "meta": null,
        "version": 14,
        "created_at": "2026-03-28T20:17:08+01:00",
        "updated_at": "2026-03-29T12:45:31+02:00"
      }
    ],

    "tomorrow": [/* same shape, may be empty */],
    "recommended": [/* same shape, may be empty */],

    "location_provided": false
  }
}
```

> Notice in the example above:
> - **`country: "FR"`** — ISO 3166-1 alpha-2, not full name.
> - **`location.lat: "50.3266860"`** — string, not number.
> - **`pricing.max: 0`** while `pricing.min: 22` — the discovery-mode edge case described in §4.5. Render `pricing.display` only.
> - **`capacity_global: null`**, **`availability.total_capacity: 0`** — discovery events frequently have neither set. Don't surface "0 spots".
> - **`creation_source: "crawler"`** — imported from the scraping pipeline; `original_organizer_name` carries the source's name.
> - **`participation_count` and `is_participating` present** — only because `booking_mode === "discovery"`.
> - **`ticket_types: []`** for a discovery event — they live in `indicative_prices` instead.
> - **No `target_audiences`, `themes`, `special_events`, `emotions`, or `entry_type` keys** — these are not eager-loaded for the home feed (see §4.10 callout).

### 6.1 Reproducible curl

```bash
curl -s -H "Accept: application/json" \
  'http://api.lehiboo.localhost/api/v1/home-feed?limit=2' \
  | python3 -m json.tool
```

The response shape above is verbatim from a `staging` server snapshot taken on 2026-05-07. Mobile teams running their own local Le Hiboo stack can reproduce it directly.

---

## 7. Edge cases & error responses

| Situation | Response | Mobile behaviour |
|---|---|---|
| No upcoming events at all | 200, all three arrays empty, `location_provided: false` | Render an empty-state for the whole feed. |
| Catalogue has events but none today/tomorrow | 200, `today: []`, `tomorrow: []`, `recommended` populated | Hide the empty section headers; show only "À venir" with the recommended list. |
| Same event has slots both today and tomorrow | Returned in **both** sections | Dedupe client-side by `uuid` if undesired. |
| `city=NonExistent` | 200, all arrays empty (no event matches the ILIKE) | Show "Aucun événement pour cette ville." Suggest clearing the filter. |
| `limit=0` or `limit=21` | 422 with `errors.limit` | Validation error. Clamp on the client to avoid this. |
| Bearer expired / invalid | 200 (the controller treats invalid bearer as anonymous via `$request->user()` returning null) | The user silently loses access to their member-only events. Mobile should periodically validate the bearer via `GET /auth/me`. |
| Server timezone differs from device timezone | `today` and `tomorrow` reflect the **server** day | Trust server grouping. Don't re-bucket client-side. |
| The event was edited between two refetches | New `version` integer, new `updated_at` | Use either to invalidate per-event caches. |

There are no specific error codes for this endpoint — only the standard 422 (validation) and the generic 5xx for infrastructure failures.

---

## 8. Caching strategy

The home feed is **slightly dynamic** — slot bookings change `available_capacity` constantly, but the editorial composition (which events are featured, which are upcoming) changes at human pace.

| TTL | Behaviour |
|---|---|
| **60 seconds** stale (foreground) | Serve from cache without refetch. Acceptable staleness for `available_capacity`. |
| **1 hour** gc | Drop completely if not accessed in an hour. |
| Foreground refresh | Refetch on app return from background. |
| Pull-to-refresh | Refetch immediately, bypass cache. |
| After a successful booking | **Invalidate** — capacity changed and the user expects to see it. |
| On `Authorization` change (login/logout) | **Invalidate** — visible event set may change (member-only events). |
| When the user changes the active organisation context | Invalidate (same reason). |

Per-event caches (e.g. on the event detail screen) can use `version` or `updated_at` from the home-feed payload to know whether to refetch the detail.

---

## 9. Filtering & what's NOT supported

The home feed is intentionally a **fixed, opinionated layout**. The only supported filter is `?city=`. The following are **NOT supported** here — use `GET /api/v1/events` for full filtering:

- Filter by category, theme, target audience, emotion, special event, tag.
- Filter by date range.
- Filter by price range / free-only.
- Filter by booking mode.
- Sort by anything other than the built-in (featured-first / published-at).
- Pagination beyond the `limit` cap.
- Geolocation-based ranking — see §10.

If the mobile UX needs any of those, switch the screen from "home feed" to "event search" and call `/v1/events` (or `/v1/events/search` for Meilisearch-backed full-text).

---

## 10. The `location_provided` field — current state

**Today**: hardcoded `false` in `EventController::homeFeed()`. The endpoint does **not** read GPS coordinates from the client and does not boost nearby events.

**Why it exists**: forward-compat. When location-aware ranking lands, the contract evolves additively:

- A new `?lat=&lng=` (or header) accepted on this endpoint.
- When provided, the response sets `location_provided: true` and the `recommended` section is re-ranked by proximity to the user.
- Today's behaviour (no location → `location_provided: false`) remains the default.

Mobile clients SHOULD ignore the value of `location_provided` for now — there's nothing actionable to do with it. When location-awareness ships, the mobile team can opt in by sending coordinates and reading `location_provided: true`.

---

## 11. Flutter integration sketch

### 11.1 Type definitions (Dart)

```dart
class HomeFeed {
  final List<MobileEvent> today;
  final List<MobileEvent> tomorrow;
  final List<MobileEvent> recommended;
  final bool locationProvided;

  HomeFeed.fromJson(Map<String, dynamic> data)
    : today = (data['today'] as List).map((e) => MobileEvent.fromJson(e)).toList(),
      tomorrow = (data['tomorrow'] as List).map((e) => MobileEvent.fromJson(e)).toList(),
      recommended = (data['recommended'] as List).map((e) => MobileEvent.fromJson(e)).toList(),
      locationProvided = data['location_provided'] as bool;
}
```

For the full `MobileEvent` shape, generate via `freezed` + `json_serializable` from the JSON example in §6.

### 11.2 Fetch with cache

```dart
Future<HomeFeed> fetchHomeFeed({
  String? city,
  int limit = 10,
  String? bearerToken,
  bool forceRefresh = false,
}) async {
  final cacheKey = 'home_feed:${city ?? "all"}:$limit:${bearerToken != null ? "auth" : "anon"}';
  if (!forceRefresh && await _cache.isFresh(cacheKey, ttl: const Duration(seconds: 60))) {
    return _cache.get<HomeFeed>(cacheKey)!;
  }

  final uri = Uri.parse('$apiBase/v1/home-feed').replace(queryParameters: {
    'limit': '$limit',
    if (city != null) 'city': city,
  });

  final res = await http.get(uri, headers: {
    'Accept': 'application/json',
    if (bearerToken != null) 'Authorization': 'Bearer $bearerToken',
    'Accept-Language': 'fr',
  });

  if (res.statusCode != 200) {
    return _cache.get<HomeFeed>(cacheKey) ?? HomeFeed.empty();
  }

  final body = jsonDecode(res.body) as Map<String, dynamic>;
  final feed = HomeFeed.fromJson(body['data']);
  await _cache.set(cacheKey, feed, ttl: const Duration(hours: 1));
  return feed;
}
```

### 11.3 Display three sections

```dart
ListView(
  children: [
    if (feed.today.isNotEmpty) _SectionHeader('Aujourd\'hui'),
    ...feed.today.map((e) => EventCard(event: e)),

    if (feed.tomorrow.isNotEmpty) _SectionHeader('Demain'),
    ...feed.tomorrow.map((e) => EventCard(event: e)),

    if (feed.recommended.isNotEmpty) _SectionHeader('À venir'),
    ...feed.recommended.map((e) => EventCard(event: e)),

    if (feed.today.isEmpty && feed.tomorrow.isEmpty && feed.recommended.isEmpty)
      const _EmptyState(),
  ],
)
```

### 11.4 Invalidate after booking

```dart
Future<void> onBookingCreated() async {
  await _cache.invalidate(prefix: 'home_feed:');
  // Subsequent fetches see fresh capacity numbers.
}
```

---

## 12. Versioning & stability commitment

| Aspect | Promise |
|---|---|
| Path `/api/v1/home-feed` | Stable. Breaking changes go to `/v2`. |
| Top-level keys (`today`, `tomorrow`, `recommended`, `location_provided`) | Stable. New keys may be added (e.g. `nearby` or `for_you` once personalisation lands). |
| `MobileEventResource` field set | Stable for declared fields. New optional fields may be added — clients MUST ignore unknown keys. |
| Section selection logic | The `today`/`tomorrow` definitions are stable. `recommended` may evolve to include personalisation; the field itself stays. |
| Sort order within each section | Stable: featured first, then DB-natural for today/tomorrow; `published_at DESC` for recommended. |
| `limit` semantics | Stable: per-section cap, max 20. |
| `city` semantics | Stable: ILIKE substring. |
| Anonymous vs authenticated visibility | Stable per `accessibleByUser` scope. |

---

## 13. Out of scope (current version)

- **Personalised recommendations** — no ML, no past-booking signal, no followed-org boost. `recommended` is editorial (`is_featured`) + recency.
- **Geolocation** — `location_provided` reserved (see §10). No proximity ranking.
- **Date-range queries on the feed itself** — use `/v1/events?date_from=&date_to=` for arbitrary ranges. The home feed only knows today / tomorrow / future.
- **Pagination / continuation tokens** — the feed is a fixed-size hero (max 60 items). Use `/v1/events` for browse-style pagination.
- **Per-section sorting overrides** — sort is server-decided.
- **Multi-city query** — `?city=` is single-value. Pass-through your city-picker on the client; the server doesn't accept comma-separated cities.
- **Stories / ads / banners** — these have their **own** endpoints (`/stories/active`, `/homepage-ads`, `/hero-slides`). The mobile home screen typically composes the home-feed call **with** those other calls in parallel; this spec only covers `/home-feed`.

---

## 14. Troubleshooting & FAQ

**Q: Why is my member-only event missing from `recommended`?**
Either (a) you're not authenticated (no bearer), (b) your bearer is expired and the controller silently treated you as anonymous, or (c) your `OrganizationMember` row isn't `status=active` (e.g. still pending approval). Check `/auth/me` and `/me/memberships`.

**Q: Why does the same event appear in `today` AND `tomorrow`?**
It has slots on both days. The controller does not deduplicate across sections. Dedupe client-side by `uuid` if your UX requires it.

**Q: Why is `dates.display` wrong for my locale?**
Send `Accept-Language: en` (or another supported locale). The default is `fr`. If `display` still doesn't match, the locale isn't supported by the backend translator — the field falls back to French.

**Q: `available_capacity` doesn't match what I see on the event detail page.**
The home feed caches for 60s on the mobile side. Pull-to-refresh, or force-refetch after the customer hits the detail screen.

**Q: Why is `recommended` showing past events?**
It shouldn't. Each pass filters `slot_date >= today`. If you see a past event, its slot dates were edited after the response was cached — refresh.

**Q: How do I show "X spots left" badges?**
Use `availability.spots_remaining` for the count and `availability.percentage_filled` for thresholds (e.g. ≥ 80 → "Almost full"). `availability.status === "unavailable"` means don't show a "Book" CTA at all.

**Q: My city filter `?city=Saint Étienne` returns zero results but the city exists.**
URL-encode the space: `?city=Saint%20%C3%89tienne` or `?city=Saint+Étienne`. The ILIKE is otherwise case-insensitive and substring-based.

**Q: Why does the response have no `version` or `meta` for some events?**
The `meta` field is nullable and is populated by some vendor-specific extensions only. `version` is always present (default 1) — if it's missing, you may be reading from a stale cache that pre-dates the version-column migration.

**Q: How do I detect that the user has lost access to a member-only event (e.g. they left the org)?**
Refetch the home feed after any membership change. Events they've lost access to silently disappear from the response.

**Q: Can I get a "for you" section without sending location?**
Not yet. Personalisation (followed-orgs boost, past-bookings affinity) is a v2 candidate. Today, every authenticated user sees the same `recommended` list (modulo the member-only events they're entitled to).

---

## 15. Related endpoints

| Endpoint | Why mention it |
|---|---|
| `GET /v1/events` | Full filtering, pagination, search. Use this when the user wants more than the home feed shows. |
| `GET /v1/events/search` | Meilisearch-backed full-text. Same response shape. |
| `GET /v1/stories/active` | Instagram-style story circles displayed above the home feed. Compose in parallel. |
| `GET /v1/hero-slides` | Top-of-screen rotating banner. Compose in parallel. See `HERO_SLIDES_MOBILE_SPEC.md`. |
| `GET /v1/homepage-ads` | Sponsored ad banners between sections. Compose in parallel. |
| `GET /v1/mobile/config` | App-level config (hero static image, ads enabled, video duration cap). Compose at app boot. |
| `GET /v1/filters` | Available categories / themes / cities / price range — for the search/filter screen. |
| `GET /v1/auth/login` | Bearer token source. With bearer, member-only events appear in this feed. |