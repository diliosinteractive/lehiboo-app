# Personalized Feed — Mobile Integration Spec

**Audience** : Mobile app (Flutter — customer side)
**Status** : Stable contract (revised — see §10 for breaking-change history)
**Scope** : The "Pour vous" tab — a **grouped** set of seven sections that surface events with which the signed-in customer has an explicit relationship: favourites, reminders, members-only/private events of orgs they belong to, confirmed bookings (all / upcoming / live now), and events from orgs they follow. No editorial picks, no popularity boost — pure relationship-driven affinity.

The endpoint is **authenticated only**. Unlike `/v1/home-feed`, there is no anonymous fallback.

> **Companion spec**: this endpoint shares the exact same per-event payload (`MobileEventResource`) and per-event eager-loaded relation set as `GET /v1/home-feed`. **Refer to [`HOME_FEED_MOBILE_SPEC.md`](HOME_FEED_MOBILE_SPEC.md) §4 and §5 for the field-level breakdown of every event object** — this spec only covers what differs (envelope, selection logic, auth, caching).

---

## TL;DR — Quick start

| Aspect | Value |
|---|---|
| Method | `GET` |
| Path | `/api/v1/me/personalized-feed` |
| Auth | **Required.** Bearer token (Sanctum). 401 without. |
| Query | `?limit=6` (1–20, default **6**) |
| Response shape | `{ success, data: { favorites, reminders, private, booked, upcoming, ongoing, followed } }` — **always all 7 keys**, each an array of up to `limit` `MobileEventResource` items |
| Pagination | **None per section.** `limit` caps each section independently. |
| Cross-section dedup | **None.** Sections may overlap (a favourite that's also booked appears in both). Client dedupes for rendering. |
| Cache | Recommend 60s stale, refetch on foreground / pull-to-refresh / membership-change / booking-change / favourite/reminder/follow change. |
| Per-event payload | Identical to `/v1/home-feed` — see [`HOME_FEED_MOBILE_SPEC.md`](HOME_FEED_MOBILE_SPEC.md) §4. |

---

## 1. Endpoint contract

```
GET /api/v1/me/personalized-feed
GET /api/v1/me/personalized-feed?limit=10
```

### 1.1 Headers

| Header | Required? | Notes |
|---|---|---|
| `Accept: application/json` | yes | Standard. |
| `Authorization: Bearer <token>` | **yes** | Sanctum personal access token from `POST /api/v1/auth/login`. Anonymous calls return **401**. |
| `Accept-Language: fr` | optional | Sets the locale for translated display fields (`dates.display`, `pricing.display`, etc.). Defaults to `fr`. |

### 1.2 Query parameters

| Name | Type | Default | Constraints | Effect |
|---|---|---|---|---|
| `limit` | integer | `6` | min `1`, max `20` | Caps **each section** to `limit` items. The total response can therefore contain up to `7 × limit` events (with overlap allowed across sections). |

> Unlike `/home-feed`, there is **no `city` filter**. The "Pour vous" feed is identity-driven; every event surfaced has an explicit user-relationship signal. If the mobile UI needs city-scoped results for an authenticated user, switch to `GET /v1/events?city=…`.

Validation errors return **422** with the standard Laravel envelope:

```json
{
  "message": "Le champ limit doit être au moins 1.",
  "errors": {
    "limit": ["Le champ limit doit être au moins 1."]
  }
}
```

The `errors.limit` key is stable; the message strings are localised — branch on key presence, not text.

### 1.3 Authentication — required, no fallback

| Caller | Outcome |
|---|---|
| **Anonymous** (no bearer / invalid bearer / expired bearer) | **401 Unauthorized** with `{"message": "Unauthenticated.", "error": "unauthenticated"}` |
| **Authenticated, account suspended** | **403 Forbidden** with `{"message": "Ce compte est suspendu. …", "error": "account_suspended"}`. The current access token is also revoked server-side, so the next call returns 401. |
| **Authenticated, account active** | 200 with the user's grouped sections (each may be empty — see §3.2). |

Two middlewares run on this route, in order: `auth:sanctum` then `account.active` (`EnsureAccountNotSuspended`). 401 means "session expired — prompt re-login". 403 with `error: account_suspended` is **not** a re-login situation — surface a "compte suspendu, contactez le support" screen, since re-authenticating won't help.

Sanctum is the only accepted scheme. Token lifecycle is the same as everywhere else in the API: tokens come from `POST /api/v1/auth/login`, are revoked on `POST /api/v1/auth/logout`, and silently invalidate on a destructive `migrate:fresh` (cf. CLAUDE.md).

### 1.4 No pagination — by design

There is no `page` / `cursor`. Each section is a **single capped slice** (up to 20 items). Mobile clients seeking more should drill down per signal:

- For "all my upcoming bookings" → `GET /v1/me/bookings`.
- For "all my favourites" → `GET /v1/me/favorites`.
- For "all events from orgs I follow" → `GET /v1/events?organization_id=…` per org.
- For "all members-only events I'm entitled to" → `GET /v1/me/private-events`.

This feed is the **landing surface**, not a browse surface.

---

## 2. The seven sections — selection logic

The controller (`MembershipController::personalizedFeed`, `api/app/Http/Controllers/Api/V1/MembershipController.php`) computes **seven independent queries** — one per section. Sections are returned as named keys; nothing is hidden, nothing is merged, nothing is dedup'd across sections. The client decides what to render, in what order, and whether to dedupe across sections for visual purposes.

All sections share the eager-load list defined by `personalizedFeedRelations()` (organization, organization.establishmentTypes, categories.parent, eventTag, slots with booked count, ticket types, venue, extra services, indicative prices) — so every event has the same per-item payload regardless of which section it appears in.

### 2.1 Section definitions

| Section | Inclusion rule | Status filter | Time filter | Order |
|---|---|---|---|---|
| `favorites` | User has favorited the event (`favorites` pivot — `User::favoriteEvents()`) | `events.status = 'published'` | At least one slot with `is_active = true` AND `slot_date >= today` | **Next slot date asc** (soonest upcoming first) |
| `reminders` | User has set a reminder on a future slot (`event_reminders` table — `User::eventReminders()` joined to `slots`) | `events.status = 'published'` | `slots.slot_date >= today` on the *reminder's* slot | **Reminder slot date / start_time asc** |
| `private` | Event belongs to an organization where the user has an `Active` `OrganizationMember`, AND the event is restricted (`is_members_only = true` OR `visibility ∈ {Private, PrivateProtected, Unlisted, PublicProtected}`) | `events.status ∈ {'published', 'private'}` | At least one slot with `is_active = true` AND `slot_date >= today` | **Next slot date asc** |
| `booked` | User has at least one `bookings.status = 'confirmed'` row on the event | _None_ — historical bookings included | _None_ — past slots included | **Most-recent slot desc** (next or most recent first) |
| `upcoming` | Subset of `booked` where the event has **at least one slot strictly in the future** (`slot_date > today` OR `(slot_date = today AND start_time > now)`) | `events.status = 'published'` | Strict future predicate above | **Nearest future slot asc** |
| `ongoing` | Subset of `booked` where the event has **at least one slot live now** (`slot_date = today AND start_time <= now <= end_time`) | `events.status = 'published'` | Live predicate above | **`start_time` asc** |
| `followed` | Event belongs to an org the user follows (`organizer_follows` pivot — `User::followedOrganizers()`), and the event is **publicly listed** (`visibility ∈ {Public, PublicProtected}`, `is_members_only` falsy) | `events.status = 'published'` | At least one slot with `is_active = true` AND `slot_date >= today` | **Next slot date asc** |

> **Why is `private` not in `followed`?** A user can both be a member of an org *and* follow it (or just be a member). The `followed` section is intentionally limited to publicly-listed events to stay "discovery-oriented". Private/members-only events of an org you happen to also follow are surfaced in `private`, not `followed`. That keeps each section's UX intent clear.

> **Why is `private` separate from `members_only` events you might have booked?** Sections are by relationship type, not by event flag. A members-only event you've booked appears in `booked`, `upcoming` (if future), `ongoing` (if live), and `private` (because you're a member of the org). The client is expected to dedupe for rendering — see §4.

### 2.2 Members bypass password

Events with `visibility = PrivateProtected` (or `PublicProtected`) normally require a password to access. **For events surfaced in the `private` section, no password is needed** — membership in the org is the access grant. This mirrors `Event::scopeAccessibleByUser()` and `EventController::show` behaviour: an `Active` `OrganizationMember` skips the password gate. The mobile client can treat events from `private` as fully accessible — no need to prompt for `event.password`.

### 2.3 Time predicates — server-evaluated, time-precise

- **`upcoming`** filters slots with `(slot_date > today) OR (slot_date = today AND start_time > now)`. A slot starting in 5 minutes will not be classified as ongoing yet.
- **`ongoing`** requires `slot_date = today AND start_time <= now AND end_time >= now`. A 14:00–18:00 slot is `ongoing` between 14:00:00 and 18:00:00 server time, then drops out.
- **`favorites`, `private`, `followed`** use the looser `slot_date >= today` (any slot today or later qualifies, regardless of intra-day time).
- **`reminders`** uses `slot_date >= today` on the *reminder's* specific slot, not the event's other slots.

Both `today` and `now` are evaluated against the API's configured timezone (`config('app.timezone')` — see `api/config/app.php`). Don't assume UTC. Mobile clients in a different timezone should not re-bucket — trust the server's view.

### 2.4 Per-section fault tolerance

Each section's query is wrapped in `try { … } catch (Throwable $e) { report($e); }`. **A failure in one section does not abort the others** — the controller logs the exception via `report()` and that section returns `[]`. The user gets a partial-but-still-useful response rather than a 500.

In practice this matters if:
- A relation table (e.g. `event_reminders`) is mid-migration.
- A user has corrupted state (e.g. orphan `bookings` rows pointing to soft-deleted events).

Mobile clients SHOULD NOT detect "partial response" — there's no signal that a section failed. Trust each section as-is. An empty section can mean "you have no data here" *or* "the query failed silently".

### 2.5 Cross-section overlap is intentional

A single event may legitimately appear in multiple sections:

- Favourited + booked + upcoming → appears in `favorites`, `booked`, `upcoming`.
- Booked, multi-slot event with one live slot and one future slot → appears in `booked`, `upcoming`, **and** `ongoing`.
- Members-only event you favourited → appears in `favorites` and `private`.

The server makes no attempt to deduplicate. **The client decides** whether to dedupe (e.g., show each event card only once across the screen) or to repeat (e.g., show the same event in a "Live now" carousel and again in a "Mes favoris" row). See §4 for a recommended dedup strategy.

---

## 3. Response envelope

### 3.1 Top-level structure

```jsonc
{
  "success": true,
  "data": {
    "favorites": [/* 0..limit MobileEventResource — Published, future slot, sorted by next slot asc */],
    "reminders": [/* 0..limit MobileEventResource — reminders on future slots, sorted by slot date asc */],
    "private":   [/* 0..limit MobileEventResource — restricted events of member orgs (password bypassed), future slot */],
    "booked":    [/* 0..limit MobileEventResource — Confirmed bookings, any time, sorted by most recent slot desc */],
    "upcoming":  [/* 0..limit MobileEventResource — Confirmed booking + strict future slot */],
    "ongoing":   [/* 0..limit MobileEventResource — Confirmed booking + slot live now */],
    "followed":  [/* 0..limit MobileEventResource — followed orgs' public events with future slot */]
  }
}
```

| Field | Type | Notes |
|---|---|---|
| `success` | boolean | Always `true` on 2xx. |
| `data` | object | **Always contains all 7 keys**, even when each is empty. |
| `data.<section>` | array | 0..`limit` event objects per section. Empty array if the user has no relevant events for that section (or if the section's query failed — §2.4). |

> ⚠️ This shape is **different** from `/v1/home-feed`, which returns `{success, data: {today, tomorrow, recommended, location_provided}}`. Don't share a single Dart deserialiser between the two endpoints — type the personalised feed as `PersonalizedFeed { favorites, reminders, private_events, booked, upcoming, ongoing, followed }` (the JSON key `private` is a Dart reserved word; rename in the Dart class).

> ⚠️ This shape is **a breaking change** vs. the previous flat list (`data: [...]`). Any v1 client built before 2026-05 must be updated. See §10.

### 3.2 Empty response

A perfectly valid empty response (a brand-new user with no memberships, no bookings, no reminders, no favourites, no follows):

```json
{
  "success": true,
  "data": {
    "favorites": [],
    "reminders": [],
    "private":   [],
    "booked":    [],
    "upcoming":  [],
    "ongoing":   [],
    "followed":  []
  }
}
```

All 7 keys are present. Mobile UI should detect **the global empty state** as "every section is `[]`" and render an onboarding empty-state — e.g. *"Suis tes premières organisations pour personnaliser ton fil"*, with CTAs into `/v1/events` discovery, `/v1/organizations` browse, and the org-following flow.

If only **some** sections are empty (e.g. `ongoing: []` and `upcoming: []` but `favorites: [...]`), render the non-empty sections and quietly hide the empty ones. Don't surface "no live events" copy unless the screen is dedicated to ongoing.

### 3.3 Per-event payload

Every entry in any section is a `MobileEventResource`. **The shape is identical to the events returned by `/v1/home-feed`.** Refer to:

- [`HOME_FEED_MOBILE_SPEC.md`](HOME_FEED_MOBILE_SPEC.md) **§4** — top-level event fields (snake_case only).
- [`HOME_FEED_MOBILE_SPEC.md`](HOME_FEED_MOBILE_SPEC.md) **§5** — sub-resources (slot, organizer, category, venue, ticket type, extra service, indicative price).

The same caveats apply — most notably:

- `target_audiences`, `themes`, `special_events`, `emotions`, and `entry_type` (the resolved object — only the `_id` is returned) are **not** included; they require the event detail call.
- `lat` / `lng` are returned as decimal **strings**, not numbers.
- For `booking_mode === "discovery"` events, `is_available` on slots is unreliable (capacity is typically `null`) — see home-feed §5.1 for the fallback rule.
- The `slots` array on each item is filtered to `is_active = true` slots only (regardless of date). For sections with a future-slot filter (`favorites`, `private`, `followed`, `upcoming`, `ongoing`) the event has at least one matching slot, but `slots` may also include past slots from the same event. Filter client-side if you only want the relevant slot.
- **No "user-relationship" flags on the event payload.** `MobileEventResource` does **not** emit `is_favorite`, `is_favorited`, `is_followed`, `is_reminded`, `is_booked`, or any equivalent. The single field in this family is `is_participating`, and it's emitted *only* for `booking_mode === "discovery"` events (see home-feed §4.9). A mobile DTO that maps `json['is_favorite']` will get `null`/`false` for every event. For the personalised feed, the **section attribution is the source of truth** — see §4.2 and §4.3.

---

## 4. Recommended client-side rendering

The seven sections each carry a clear UX intent. A typical "Pour vous" home screen renders them like this:

| Section | Suggested UI surface | Priority |
|---|---|---|
| `ongoing` | "En direct" banner / sticky carousel at top | Highest — these events are happening now and the user has a ticket |
| `upcoming` | "Vos prochaines sorties" horizontal scroller | Very high — actionable |
| `private` | "Réservé aux membres" section with a lock icon | Member-exclusive — adds value |
| `favorites` | "Vos favoris" carousel | Personal selection |
| `reminders` | "Vos rappels" — small card list, often above favourites | Explicit user signal — high recall |
| `followed` | "Des organisateurs que vous suivez" — feed-style list | Discovery within trusted orgs |
| `booked` | "Mes réservations" — drawer or secondary tab | Historical / catch-all (overlaps with `upcoming` and `ongoing`) |

### 4.1 Cross-section dedup for the home screen

Because the same event can appear in multiple sections, a typical "single scrollable list" treatment needs deduplication. The recommended priority (most actionable first):

1. `ongoing` — show first, suppress the same event from any other section
2. `upcoming` — show next, suppress from `booked` / `favorites` / `private` / `followed`
3. `private` — show next, suppress from `favorites` / `followed`
4. `favorites` — show next, suppress from `followed`
5. `reminders` — show in parallel (rarely overlaps after the above)
6. `followed` — show last
7. `booked` — typically a separate tab; on the home screen, only show if the event isn't already in `upcoming` or `ongoing`

```dart
final shown = <String>{};                         // event UUIDs already rendered
List<MobileEvent> dedupe(List<MobileEvent> list) =>
    list.where((e) => shown.add(e.uuid)).toList();

final sections = <String, List<MobileEvent>>{
  'En direct':            dedupe(feed.ongoing),
  'Vos prochaines sorties': dedupe(feed.upcoming),
  'Réservé aux membres':  dedupe(feed.privateEvents),
  'Vos favoris':          dedupe(feed.favorites),
  'Vos rappels':          dedupe(feed.reminders),
  'Organisateurs suivis': dedupe(feed.followed),
};
```

If product wants "the same event can appear in two sections" (e.g. live now AND in favourites), simply skip the dedup pass.

### 4.2 Personalisation labels are now trivial

The previous flat-list version required cross-referencing `data` against `/v1/me/bookings`, `/v1/me/favorites`, etc. to know *why* an event was surfaced. With the new grouped shape, **the section name is the reason**:

| Section | Suggested badge / label |
|---|---|
| `ongoing` | "🔴 En direct maintenant" |
| `upcoming` | "Vous y allez" |
| `booked` | "Tu y vas" / "Vous y êtes allé(e)" (depending on whether the slot is past) |
| `private` | "🔒 Réservé aux membres" |
| `favorites` | "❤️ En favori" |
| `reminders` | "⏰ Rappel programmé" |
| `followed` | "👤 Vous suivez {organizer.name}" |

No client-side cross-referencing required.

### 4.3 Anti-patterns to avoid

The mobile codebase tends to grow toward "render based on a per-event flag". For this endpoint, that pattern doesn't fit the contract. Two specific traps that have already cost UI bugs:

- **Don't read `is_favorite` from the event payload to fill the favourite-heart icon.** The field is **not** on `MobileEventResource` — it's always absent / falsy regardless of section. **Fill the heart iff the event was delivered in `data.favorites`** (or, in a dedup'd flat list, iff its UUID is in the favourites set you built locally). When the user taps the heart, mutate local state for instant feedback and rely on the next refetch (after invalidating, see §7) to re-confirm via section membership.

- **Don't read `is_members_only` (or `visibility`) from the event payload to render a "Privé" / "Réservé aux membres" badge.** The `private` section's inclusion predicate is broader than `is_members_only` alone — it also surfaces events with `visibility ∈ {Unlisted, PublicProtected, Private, PrivateProtected}` from orgs the user is an `Active` member of, **regardless of the `is_members_only` flag**. Keying the badge on a field silently misses events that the section correctly surfaces. **Render the badge iff the event was delivered in `data.private`.**

The general rule: **for any "user-relationship" UI affordance (heart, "Privé" badge, "Vous y allez", "Vous suivez"), source it from the section the event arrived in — not from a per-event field.** The controller is the source of truth; the field is either absent, or present but evaluated against a narrower predicate than the section.

---

## 5. Complete realistic response example

A logged-in user who is an `Active` member of "La Boucherie d'Aix", has a confirmed booking for an upcoming concert this Saturday, follows two further organisations, has favourited two events, and is currently attending one ongoing tasting. With `?limit=3`:

```json
{
  "success": true,
  "data": {
    "favorites": [
      {
        "uuid": "019d3932-eab9-726a-9fad-72accc6c9274",
        "slug": "evermore-hommage-mylene-farmer",
        "title": "Evermore - Hommage à Mylène Farmer",
        "is_members_only": false,
        "status": "published",
        "visibility": "public",
        "booking_mode": "booking",
        "city": "Denain",
        "country": "FR",
        "start_date": "2026-05-09T00:00:00+02:00",
        "dates": { "start_date": "2026-05-09", "end_date": "2026-05-09", "start_time": "20:00:00", "end_time": "22:00:00", "display": "samedi 09 mai 2026", "duration_minutes": 120, "is_recurring": false },
        "price_from": 22,
        "pricing": { "is_free": false, "min": 22, "max": 22, "currency": "EUR", "display": "22,00€" },
        "availability": { "status": "available", "total_capacity": 240, "spots_remaining": 78, "percentage_filled": 67 }
        /* …rest of MobileEventResource fields… */
      }
      /* +1 more favorite ordered by next slot asc */
    ],

    "reminders": [
      {
        "uuid": "019d4a01-…",
        "slug": "festival-jazz-juan-2026",
        "title": "Jazz à Juan 2026",
        "start_date": "2026-07-12T00:00:00+02:00"
        /* … */
      }
    ],

    "private": [
      {
        "uuid": "019d35e0-f585-7286-be2b-a3146b6cef7f",
        "slug": "soiree-degustation-vins-membres",
        "title": "Soirée dégustation vins (réservée aux membres)",
        "is_members_only": true,
        "status": "published",
        "visibility": "private_protected",
        "is_password_protected": true,
        "has_password": true,
        "booking_mode": "booking",
        "venue_name": "La Boucherie d'Aix",
        "city": "Aix-en-Provence",
        "country": "FR",
        "start_date": "2026-05-10T00:00:00+02:00",
        "organizer": { "uuid": "org-aix-…", "name": "La Boucherie d'Aix", "verified": true, /* … */ }
        /* …rest of MobileEventResource fields… password is set on the event, but the client should NOT prompt for it: membership grants access. */
      }
    ],

    "booked": [
      {
        "uuid": "019d35e0-f585-7286-be2b-a3146b6cef7f",
        "title": "Soirée dégustation vins (réservée aux membres)"
        /* same event as in `private`. The client may dedupe (§4.1). */
      },
      {
        "uuid": "019d4990-…",
        "title": "Concert du samedi soir"
        /* booked & in the future — appears here AND in `upcoming` */
      },
      {
        "uuid": "019d4a55-…",
        "title": "Atelier dégustation (en cours)"
        /* booked & live now — appears here AND in `ongoing` */
      }
    ],

    "upcoming": [
      {
        "uuid": "019d4990-…",
        "title": "Concert du samedi soir",
        "start_date": "2026-05-09T20:00:00+02:00"
        /* ordered by nearest future slot asc */
      }
    ],

    "ongoing": [
      {
        "uuid": "019d4a55-…",
        "title": "Atelier dégustation",
        "dates": { "start_date": "2026-05-07", "start_time": "14:00:00", "end_time": "18:00:00", "display": "jeudi 07 mai 2026", "duration_minutes": 240, "is_recurring": false }
        /* live right now — server time between 14:00 and 18:00 today */
      }
    ],

    "followed": [
      {
        "uuid": "019cf1aa-…",
        "slug": "soiree-jazz-le-bistrot",
        "title": "Soirée Jazz au Bistrot",
        "city": "Lyon",
        "start_date": "2026-05-15T00:00:00+02:00"
        /* surfaced because the user follows the organising org */
      }
      /* + up to 2 more from other followed orgs */
    ]
  }
}
```

> The `Soirée dégustation vins` event appears in both `private` and `booked` because the user is a member of the host org **and** has a confirmed booking. The `Atelier dégustation` appears in `booked` and `ongoing`. The `Concert du samedi soir` appears in `booked` and `upcoming`. This overlap is **expected**; the client decides how to render (§4).

The example is **illustrative**. For a verbatim live `MobileEventResource`, see [`HOME_FEED_MOBILE_SPEC.md`](HOME_FEED_MOBILE_SPEC.md) §6.

---

## 6. Edge cases & error responses

| Situation | Response | Mobile behaviour |
|---|---|---|
| Anonymous call (no bearer) | **401** `{"message": "Unauthenticated.", "error": "unauthenticated"}` | Treat as session-expired — prompt re-login. |
| Bearer expired or invalidated | **401** (same body) | Same — re-auth flow. |
| Authenticated, brand-new user (no memberships / bookings / etc.) | 200 with all 7 sections `= []` | Onboarding empty-state (§3.2). |
| User has a confirmed booking but its slot is in the past | Event appears in `booked` only — **not** in `upcoming` or `ongoing` | Render with "Vous y êtes allé(e)" badge and a CTA to leave a review. |
| User's booking is on a multi-slot event — one slot live, one future | Event appears in `booked`, `upcoming`, **AND** `ongoing` | Either dedupe (§4.1) or surface in both contexts. |
| User left an org they were a member of | After membership goes from `Active` → cancelled, that org's events disappear from `private` on next refetch | **Invalidate cache** on any membership write. |
| User cancels a confirmed booking | The booking's event may disappear from `booked` / `upcoming` / `ongoing` — but the event may still appear via another section (favourite, follow) | Invalidate after any booking-status change. |
| Members-only event is `PrivateProtected` (password set) | Event appears in `private` regardless — password is bypassed for members | Don't prompt for password. The mobile API client can call `GET /v1/events/{slug}` for that event without sending `event_password`. |
| `limit=0` or `limit=21` | **422** with `errors.limit` | Clamp client-side to `[1, 20]`. |
| Section-internal DB error (e.g. `event_reminders` table issue) | 200 with the failing section as `[]`; other sections respond normally; Sentry/log gets the exception via `report()` | No client-visible signal — trust each section as-is. |
| Server timezone differs from device timezone | Time predicates use **server** day boundary | Trust the server. Don't re-filter client-side. |
| Event was edited between two refetches | New `version` integer, new `updated_at` | Use either to invalidate per-event caches in any list view. |
| User is a member of zero orgs | `private` is `[]` | Render the section header only if non-empty. |
| User follows zero orgs | `followed` is `[]` | Same. |
| User is currently between two slots of the same multi-slot event (no slot live now, but next one starts in 2 hours) | Event in `booked` + `upcoming`, **not** `ongoing` | Correct — `ongoing` strictly checks `start_time <= now <= end_time`. |

---

## 7. Caching strategy

The personalised feed is **highly dynamic**: any user-action that changes one of the seven signals (favourite, reminder, booking, membership, follow) invalidates the answer. Practical rules:

| TTL / event | Behaviour |
|---|---|
| **60 seconds** stale (foreground) | Serve from cache without refetch. Acceptable staleness for `available_capacity` and `participation_count`. |
| **1 hour** gc | Drop completely if not accessed in an hour. |
| Foreground refresh | Refetch on app return from background. Especially important because `ongoing` is time-sensitive — a slot may have ended in the background. |
| Pull-to-refresh | Refetch immediately, bypass cache. |
| **After login / logout** | **Invalidate.** Different user → entirely different feed. |
| **After membership change** (request / cancel / approval) | **Invalidate.** `private` set changes. |
| **After booking creation / cancellation** | **Invalidate.** `booked` / `upcoming` / `ongoing` sets change. |
| **After event reminder add / remove** | **Invalidate.** `reminders` set changes. |
| **After favourite add / remove** | **Invalidate.** `favorites` set changes. |
| **After org follow / unfollow** | **Invalidate.** `followed` set changes. |
| **Crossing a slot boundary** (e.g. 14:00:00 — slot start) | Cache may report `upcoming` for an event that's now `ongoing`. Consider a 60s TTL to bound the lag. | 
| When the user changes the active organisation context (vendor mode) | Not applicable — this endpoint is customer-side only and ignores `X-Organization-Id`. |

> Compared to `/v1/home-feed`, the personalised feed has **strictly more invalidation triggers**. It's worth wiring a single `invalidate('personalized_feed:*')` call into every mutation point, rather than trying to scope per-section.

The cache key SHOULD be scoped per user — at minimum `personalized_feed:user:<user_uuid>:limit:<limit>`. **Never key on bearer string alone** (token rotation would multiply entries) and **never share a key across users** (privacy: `private` contents differ).

---

## 8. Filtering & what's NOT supported

The personalised feed is **identity-driven**, not query-driven. The following are NOT supported here — use the appropriate dedicated endpoint:

| You want… | Use instead |
|---|---|
| Filter by city / region | `GET /v1/events?city=…` |
| Filter by category / theme / target audience / emotion | `GET /v1/events?category=…` etc. |
| Filter by date range | `GET /v1/events?date_from=…&date_to=…` |
| Filter by price range / free-only | `GET /v1/events?price_type=free` |
| Sort the response | Order is fixed per-section (see §2.1) |
| Pagination beyond `limit=20` per section | The dedicated lists per signal: `/v1/me/bookings`, `/v1/me/favorites`, `/v1/me/private-events`, `/v1/me/memberships` |
| Geolocation-based ranking | Not available anywhere yet (cf. `home-feed` §10). |
| **Cross-user feeds** (e.g. "what my friends like") | Not implemented. Out of scope. |
| Toggle individual sections off | Filter client-side. The server always returns all 7. |

---

## 9. Flutter integration sketch

### 9.1 Type definitions (Dart)

```dart
class PersonalizedFeed {
  final List<MobileEvent> favorites;
  final List<MobileEvent> reminders;
  final List<MobileEvent> privateEvents;   // 'private' is reserved in Dart
  final List<MobileEvent> booked;
  final List<MobileEvent> upcoming;
  final List<MobileEvent> ongoing;
  final List<MobileEvent> followed;

  PersonalizedFeed.fromJson(Map<String, dynamic> data)
      : favorites     = _parse(data['favorites']),
        reminders     = _parse(data['reminders']),
        privateEvents = _parse(data['private']),
        booked        = _parse(data['booked']),
        upcoming      = _parse(data['upcoming']),
        ongoing       = _parse(data['ongoing']),
        followed      = _parse(data['followed']);

  static List<MobileEvent> _parse(dynamic raw) =>
      (raw as List? ?? const [])
          .map((e) => MobileEvent.fromJson(e as Map<String, dynamic>))
          .toList();

  bool get isCompletelyEmpty =>
      favorites.isEmpty && reminders.isEmpty && privateEvents.isEmpty &&
          booked.isEmpty && upcoming.isEmpty && ongoing.isEmpty && followed.isEmpty;
}
```

The `MobileEvent` model is **identical** to the one used for `/v1/home-feed` — share the freezed/json_serializable class across both endpoints.

### 9.2 Fetch with cache & 401 handling

```dart
Future<PersonalizedFeed> fetchPersonalizedFeed({
  required String userUuid,
  required String bearerToken,
  int limit = 6,
  bool forceRefresh = false,
}) async {
  final cacheKey = 'personalized_feed:user:$userUuid:limit:$limit';

  if (!forceRefresh && await _cache.isFresh(cacheKey, ttl: const Duration(seconds: 60))) {
    return _cache.get<PersonalizedFeed>(cacheKey)!;
  }

  final uri = Uri.parse('$apiBase/v1/me/personalized-feed')
      .replace(queryParameters: {'limit': '$limit'});

  final res = await http.get(uri, headers: {
    'Accept': 'application/json',
    'Authorization': 'Bearer $bearerToken',
    'Accept-Language': 'fr',
  });

  if (res.statusCode == 401) {
    await _auth.handleSessionExpired();   // triggers re-login flow
    throw const SessionExpiredException();
  }

  if (res.statusCode != 200) {
    return _cache.get<PersonalizedFeed>(cacheKey) ??
        PersonalizedFeed.fromJson(const {});  // empty-but-valid feed
  }

  final body = jsonDecode(res.body) as Map<String, dynamic>;
  final feed = PersonalizedFeed.fromJson(body['data'] as Map<String, dynamic>);
  await _cache.set(cacheKey, feed, ttl: const Duration(hours: 1));
  return feed;
}
```

### 9.3 Display with empty-state onboarding

```dart
final feed = await fetchPersonalizedFeed(...);

if (feed.isCompletelyEmpty) {
return _PersonalizedEmptyState(
onExploreEvents: () => Navigator.pushNamed(context, '/events'),
onBrowseOrgs: () => Navigator.pushNamed(context, '/organizations'),
);
}

return ListView(children: [
if (feed.ongoing.isNotEmpty)       _OngoingCarousel(events: feed.ongoing),
if (feed.upcoming.isNotEmpty)      _SectionRow('Vos prochaines sorties', feed.upcoming),
if (feed.privateEvents.isNotEmpty) _SectionRow('Réservé aux membres',  feed.privateEvents),
if (feed.favorites.isNotEmpty)     _SectionRow('Vos favoris',          feed.favorites),
if (feed.reminders.isNotEmpty)     _SectionRow('Vos rappels',          feed.reminders),
if (feed.followed.isNotEmpty)      _SectionRow('Organisateurs suivis', feed.followed),
// `booked` typically lives in a dedicated tab — show only if relevant on the home screen.
]);
```

### 9.4 Invalidate after every signal change

```dart
const _personalizedFeedCachePrefix = 'personalized_feed:';

Future<void> _invalidatePersonalizedFeed() =>
    _cache.invalidate(prefix: _personalizedFeedCachePrefix);

// Wire into every mutation point:
Future<void> onLogin() async              => _invalidatePersonalizedFeed();
Future<void> onLogout() async             => _invalidatePersonalizedFeed();
Future<void> onMembershipChange() async   => _invalidatePersonalizedFeed();
Future<void> onBookingChange() async      => _invalidatePersonalizedFeed();
Future<void> onReminderChange() async     => _invalidatePersonalizedFeed();
Future<void> onFavouriteChange() async    => _invalidatePersonalizedFeed();
Future<void> onFollowChange() async       => _invalidatePersonalizedFeed();
```

---

## 10. Versioning & breaking-change history

### 10.1 Stability commitment going forward

| Aspect | Promise |
|---|---|
| Path `/api/v1/me/personalized-feed` | Stable. Breaking changes go to `/v2`. |
| Top-level shape (`{success, data: { favorites, reminders, private, booked, upcoming, ongoing, followed } }`) | Stable. New section keys may be added; **clients MUST handle unknown keys gracefully** by ignoring them. Existing keys will not be removed within `/v1`. |
| `MobileEventResource` field set | Stable for declared fields. New optional fields may be added. **Mirrors `/home-feed` field set** — the two evolve together. |
| Per-section ordering rule | Stable per §2.1. |
| Per-section query semantics | Stable. Inclusion rules will not be tightened (no events removed from a section between minor revisions); they may be loosened (more events surfaced). |
| Cross-section dedup behaviour | Stable: **none**. The server will not start dedup'ing across sections. |
| `limit` semantics & range | Stable: per-section cap, default 6, max 20. |
| Auth requirement | Stable: 401 for unauthenticated. |

### 10.2 Breaking change — flat list → grouped sections (2026-05)

Prior to revision 2026-05, this endpoint returned a **flat top-N stratified list** with a different shape:

```jsonc
// OLD — pre-2026-05
{ "success": true, "data": [/* up to limit MobileEventResource */] }
```

It walked five strata in priority order (members-only → bookings → reminders → favourites → followed orgs), deduped across strata, and stopped at `limit`.

**The new shape is incompatible** with clients written against the old contract. Clients that hit the new endpoint with the old deserialiser will see:

- A type error (`data` is now an `object`, not an `array`) — the old `data.map()` / `data is List` check fails.
- Or, if the deserialiser is permissive, an empty list (since `data.values` is not the same as `data` itself).

The mobile team must ship a coordinated update before the new server is deployed. There is no v2 path; revision is in-place under `/v1`.

### 10.3 Future additive changes

Both opt-in, neither breaks the contract:

- `?since=<iso>` to power "what's new since I last looked" deltas — not in scope today.
- Additional sections (e.g. `recommended_for_you` driven by ML) — would be appended; existing keys unchanged.

---

## 11. Out of scope (current version)

- **ML / collaborative filtering** — sections are deterministic, relationship-driven.
- **Geolocation** — no proximity boost. Use `/home-feed` (when geo-aware variant ships) or `/v1/events?lat=&lng=`.
- **Pagination / cursors per section** — cap-and-go.
- **Per-section sort overrides** — server-decided.
- **Filtering by anything** — no `?city=`, no `?category=`, etc. (§8).
- **Cross-user feeds** — "friends are going" or "popular among members" is not modeled.
- **Stories / ads / banners** — own endpoints; compose in parallel on the home screen.
- **Push notifications when new items hit your feed** — not driven from this endpoint. See [`PUSH_NOTIFICATIONS_MOBILE_SPEC.md`](PUSH_NOTIFICATIONS_MOBILE_SPEC.md) for what does drive pushes.
- **Server-side dedup across sections** — by design, sections may overlap.

---

## 12. Troubleshooting & FAQ

**Q: Why are all 7 sections empty even though I have a confirmed booking?**
The 401 case: your bearer is silently invalid — the endpoint returns **401**, not an empty `data`. If you genuinely got 200 with all sections empty while you have data, double-check `GET /v1/me/bookings` returns rows for the same user — cache cross-pollination is a common culprit during development.

**Q: An event I booked and favourited appears in both `booked` and `favorites`. Is that a bug?**
No. Cross-section overlap is **intentional** (§2.5). The server returns each event in every section that semantically applies. The client decides whether to dedupe (§4.1).

**Q: My members-only event is missing from `private`.**
Either (a) you're not authenticated; (b) your `OrganizationMember` row isn't `status=Active` (it may still be `Pending` after the request) — check `GET /v1/me/memberships`; (c) the event has no future slot — past events are excluded from `private`; (d) the event is `Public` and not flagged `is_members_only` — public events of your member orgs land in `followed` (if you follow), not `private`.

**Q: My `PrivateProtected` event appears in `private` but the password isn't supplied. Do I need to prompt the user for it?**
**No.** Membership in the org grants access — the password is bypassed for members. The mobile client can call `GET /v1/events/{slug}` for that event without sending a password. If you do prompt and submit a password, the server will accept it (no harm), but it's unnecessary UX friction.

**Q: An event I have a future booking for is not in `upcoming`.**
Three things to check: (a) the booking's `status` must be `confirmed` — `pending`, `cancelled`, etc. don't count; (b) the event itself must be `status = published` — if it was unpublished, it drops out; (c) the slot tied to the booking must have `is_active = true` AND `(slot_date > today OR (slot_date = today AND start_time > now))`. If `start_time` has passed and `end_time` hasn't, the event is in `ongoing`, not `upcoming`.

**Q: An event I'm currently attending isn't in `ongoing`.**
Check the slot's `start_time` / `end_time`: `ongoing` requires `start_time <= now <= end_time` against **server time**. A 14:00–15:00 slot drops out of `ongoing` at 15:00:00 sharp. Foreground-refresh the cache if you crossed a boundary while the app was in the background.

**Q: I unfollowed an org but its events still show up in `followed`.**
You're hitting the cache. Invalidate the personalised feed cache after any signal change (§7).

**Q: How do I show a "Tu y vas" badge?**
Look at the section name: events in `booked`/`upcoming`/`ongoing` get the badge; events only in `favorites`/`followed` don't. No cross-referencing required (§4.2).

**Q: Some past events show up in `booked`.**
Yes, by design — `booked` includes any confirmed booking regardless of slot date, so users can see their history. If you want only future bookings on the home screen, render `upcoming` instead. Use `booked` for a "Mes réservations" tab that includes past attendances.

**Q: I'm getting 401 even with what looks like a valid token.**
Verify with `GET /v1/auth/me` first — Sanctum returns 401 for both expired and never-existed tokens, with the same body. After a `migrate:fresh` on the dev environment, all tokens are nuked (cf. CLAUDE.md "Opérations Base de Données") — re-login.

**Q: `limit=20` and the user has 50 confirmed bookings — which 20 do I get in `booked`?**
The 20 with the most-recent slot date (next or most recent first). For `upcoming`, the 20 with the **soonest** future slot. For `ongoing`, the 20 with the soonest `start_time` (if you have 20 events live at the same instant, you have other problems).

**Q: Can two devices for the same user get different responses?**
Only via cache. The server response is deterministic given (`user_id`, `limit`, current time). If two devices show different lists, one is stale — pull-to-refresh resolves it.

**Q: Is `data[ongoing][0]` stable enough to use as the source of truth for "what is the user attending right now"?**
For an authenticated user, yes — but the time horizon is short. Refresh on app-foreground.

**Q: Total response size — what's the worst case?**
`7 × limit` events. With `limit=20`, that's up to 140 `MobileEventResource` items. Per-event size is roughly the same as `/home-feed` (~3-5 KB depending on relations). Worst case ~700 KB uncompressed; Gzip brings it well under 200 KB. For typical usage with `limit=6`, expect 5–25 KB.

---

## 13. Related endpoints

| Endpoint | Why mention it |
|---|---|
| [`GET /v1/home-feed`](HOME_FEED_MOBILE_SPEC.md) | The non-personalised companion. Today / tomorrow / recommended. Same per-event payload. |
| `GET /v1/me/bookings` | Power the "Mes réservations" tab. Section `booked` in detail. |
| `GET /v1/me/favorites` | Power the "Favoris" tab. Section `favorites` in detail. |
| `GET /v1/me/reminders` | Section `reminders` in detail. |
| `GET /v1/me/memberships` | Source for section `private` — the orgs you're an active member of. |
| `GET /v1/me/private-events` | Paginated list of all private events the user is entitled to (superset of section `private`). |
| `GET /v1/events` | General catalogue with full filtering (city, category, date, price). Use for browse / search after the user finishes with the personalised feed. |
| `POST /v1/auth/login` | Bearer token source. **Required** for this endpoint. |
| `GET /v1/auth/me` | Verify a bearer is still valid before assuming a 401 means "no events". |