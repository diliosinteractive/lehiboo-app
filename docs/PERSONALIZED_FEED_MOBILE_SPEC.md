# Personalized Feed — Mobile Integration Spec

**Audience** : Mobile app (Flutter — customer side)
**Status** : Stable contract
**Scope** : The "Pour vous" tab — a single, ranked, deduplicated list of events that **already mean something** to the signed-in customer (they're a member of the organising org, they've booked it before, they've set a reminder, favorited it, or follow the publisher). No editorial picks, no popularity boost — just relationship-driven affinity.

The endpoint is **authenticated only**. Unlike `/v1/home-feed`, there is no anonymous fallback.

> **Companion spec**: this endpoint shares the exact same per-event payload (`MobileEventResource`) and per-event eager-loaded relation set as `GET /v1/home-feed`. **Refer to [`HOME_FEED_MOBILE_SPEC.md`](HOME_FEED_MOBILE_SPEC.md) §4 and §5 for the field-level breakdown of every event object** — this spec only covers what differs (envelope, selection logic, auth, caching).

---

## TL;DR — Quick start

| Aspect | Value |
|---|---|
| Method | `GET` |
| Path | `/api/v1/me/personalized-feed` |
| Auth | **Required.** Bearer token (Sanctum). 401 without. |
| Query | `?limit=8` (1-20, default 8) |
| Response shape | `{ success, data: [/* up to `limit` MobileEventResource */] }` |
| Pagination | **None.** `limit` caps the total. Single-shot. |
| Cache | Recommend 60s stale, refetch on foreground / pull-to-refresh / membership-change / booking-change. |
| Per-event payload | Identical to `/v1/home-feed` — see [`HOME_FEED_MOBILE_SPEC.md`](HOME_FEED_MOBILE_SPEC.md) §4. |

---

## 1. Endpoint contract

```
GET /api/v1/me/personalized-feed
GET /api/v1/me/personalized-feed?limit=12
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
| `limit` | integer | `8` | min `1`, max `20` | Caps the **total** size of `data`. Default `8` (vs. `10` on `/home-feed`). The same cap is applied per-stratum during selection (see §2.2). |

> Unlike `/home-feed`, there is **no `city` filter**. The "Pour vous" feed is identity-driven, not location-driven; every event surfaced has an explicit user-relationship signal. Filtering would dilute that contract. If the mobile UI needs city-scoped results for an authenticated user, switch to `GET /v1/events?city=…`.

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
| **Authenticated, account active** | 200 with the user's personalised list (may be empty — see §3.2). |

Two middlewares run on this route, in order: `auth:sanctum` then `account.active` (`EnsureAccountNotSuspended`). 401 means "session expired — prompt re-login". 403 with `error: account_suspended` is **not** a re-login situation — surface a "compte suspendu, contactez le support" screen, since re-authenticating won't help.

Sanctum is the only accepted scheme. Token lifecycle is the same as everywhere else in the API: tokens come from `POST /api/v1/auth/login`, are revoked on `POST /api/v1/auth/logout`, and silently invalidate on a destructive `migrate:fresh` (cf. CLAUDE.md).

### 1.4 No pagination — by design

There is no `page` / `cursor`. The personalised feed is a **single ranked shot of up to `limit` items** (max 20). Mobile clients seeking more should drill down per-strata:

- For "all my upcoming bookings" → `GET /v1/me/bookings`.
- For "all my favourites" → `GET /v1/me/favorites`.
- For "all events from orgs I follow" → `GET /v1/events?organization_id=…` per org.
- For "all members-only events I'm entitled to" → `GET /v1/me/private-events`.

This feed is the **landing surface**, not a browse surface.

---

## 2. The five strata — selection logic

The controller (`MembershipController::personalizedFeed`, `api/app/Http/Controllers/Api/V1/MembershipController.php`) walks **five strata in priority order**, accumulating events into a single ordered list, deduplicating across strata by `uuid`, and **stopping the moment `limit` is reached**.

The strata are not exposed in the response — the client receives a flat array. The ordering of `data` reflects the strata order: items from stratum 1 come first, then 2, etc.

### 2.1 Stratum order & inclusion rules

All strata share the base filter `events.status = 'published'`. The future-slot filter is applied at the **event level** for strata that need it.

| # | Stratum | Inclusion rule | Future-slot filter? |
|---|---|---|---|
| 1 | **Members-only of active orgs** | `is_members_only = true` AND organisation is in the user's `active` memberships set | ✅ At least one slot with `slot_date >= today` |
| 2 | **Confirmed bookings** | The user has at least one `bookings.status = 'confirmed'` row pointing to the event | ✅ At least one slot with `slot_date >= today` |
| 3 | **Reminders** | The user has set an event reminder (`event_reminders` table — `User → HasMany EventReminder`) for the event | ❌ **No future filter** — past reminders surface with their (past) slot list |
| 4 | **Favourites** | The user has favorited the event (`favorites` pivot — M2M `User ↔ Event`) | ❌ **No future filter** — past favourites surface |
| 5 | **Followed organisations** | Event belongs to an organisation the user follows (`organizer_follows` pivot — M2M `User ↔ Organization`) | ✅ At least one slot with `slot_date >= today` |

All strata also enforce `events.status = 'published'`. Note that `EventStatus::Private` is a distinct status (used by `/v1/me/private-events` for member-restricted drafts) and **is excluded here** — even members-only events surfaced in stratum 1 must be `status = published`.

**Order within each stratum**: `events.created_at DESC`. Cap per stratum: `limit`.

> **Slot-`is_active` asymmetry (strata 1, 2, 5)**: the `whereHas('slots', …)` gate matches on `slot_date >= today` only — it does **not** require `is_active = true`. The eager-load that builds `data[*].slots` does filter `is_active = true`. Net effect: an event whose only future slots are inactive can pass the gate and arrive at the client with an empty or past-only `slots` array. Render defensively (no booking CTA when `slots` has no future-and-active row).

> **Why no future-slot filter on strata 3 & 4?** Reminders and favourites are explicit user signals — if the user reminded themselves of an event, the resource may still want to be reachable from "Pour vous" even after the date has passed (e.g. to access tickets, look up the venue address, leave a review). Strata 1, 2, and 5 are *catalogue-driven*; surfacing a past concert from "an org you follow" isn't useful, so they're constrained to upcoming.

### 2.2 Cross-strata deduplication

A single in-memory `seen[uuid]` map is built as the controller walks the strata. **An event appears at most once** in `data`, attributed to the **earliest** stratum that surfaced it. Example: an event the user has both booked and favorited is emitted from stratum 2 (bookings) and is **not re-emitted** from stratum 4 (favourites).

This is different from `/v1/home-feed`, where the same event can appear in `today` **and** `tomorrow`. The personalised feed never duplicates.

### 2.3 Early exit

If stratum 1 alone yields ≥ `limit` events, **strata 2-5 are not queried at all**. This is a deliberate optimisation: a heavily-engaged member of multiple active orgs whose orgs publish lots of members-only events will fill their feed entirely from stratum 1 — and that's the right behaviour (those events are the highest-affinity).

In practical terms with `limit=8`: a "casual" user (no memberships, a few bookings, follows one org) typically fills their list from strata 2 → 4 → 5 and never touches stratum 5. A "power member" fills it entirely from stratum 1. The mobile UI gets a single uniform list either way.

### 2.4 Per-stratum fault tolerance

Each stratum's query is wrapped in `try { … } catch (Throwable $e) { report($e); }`. **A failure in one stratum does not abort the others** — the controller logs the exception and proceeds to the next stratum. The user gets a partial-but-still-useful response rather than a 500.

In practice this matters if:
- A relation table (e.g. `event_reminders`) is mid-migration.
- A user has corrupted state (e.g. orphan `bookings` rows pointing to soft-deleted events — DB integrity should prevent this, but the catch is defensive).

Mobile clients SHOULD NOT detect "partial response" — there's no signal that a stratum was skipped. Trust the response as-is.

### 2.5 Server timezone

The `today` boundary used in strata 1, 2, and 5 is computed against `now()->toDateString()` using the API's configured timezone (`config('app.timezone')` — see `api/config/app.php` for the deployed value). Don't assume UTC. Mobile clients in a different timezone should not re-bucket — trust the server's view of "is this slot in the future".

---

## 3. Response envelope

### 3.1 Top-level structure

```jsonc
{
  "success": true,
  "data": [
    /* MobileEventResource × up to `limit` items
       Ordered by stratum (1→5), then by events.created_at DESC within each stratum.
       Deduplicated by event uuid. */
  ]
}
```

| Field | Type | Notes |
|---|---|---|
| `success` | boolean | Always `true` on 2xx. |
| `data` | array | 0..`limit` event objects. **No nested `events` key, no `meta`, no `pagination`.** Flat array directly. |

> ⚠️ This shape is **different** from `/v1/home-feed`, which returns `{success, data: {today, tomorrow, recommended, location_provided}}`. Don't share a single Dart deserialiser between the two endpoints — type the personalised feed as `List<MobileEvent>` directly.

### 3.2 Empty response

A perfectly valid empty response (a brand-new user with no memberships, no bookings, no reminders, no favourites, no follows):

```json
{
  "success": true,
  "data": []
}
```

Mobile UI should render an empty-state with onboarding hints — e.g. *"Suis tes premières organisations pour personnaliser ton fil"*, with CTAs into `/v1/events` discovery, `/v1/organizations` browse, and the org-following flow. **Never show "no events available"** — there are events; the user just hasn't formed any relationships yet.

### 3.3 Per-event payload

Every entry in `data` is a `MobileEventResource`. **The shape is identical to the events returned by `/v1/home-feed`.** Refer to:

- [`HOME_FEED_MOBILE_SPEC.md`](HOME_FEED_MOBILE_SPEC.md) **§4** — top-level event fields (72 keys discovery / 70 keys booking, snake_case only).
- [`HOME_FEED_MOBILE_SPEC.md`](HOME_FEED_MOBILE_SPEC.md) **§5** — sub-resources (slot, organizer, category, venue, ticket type, extra service, indicative price).

The eager-load list is the **same** as home-feed (`organization`, `organization.establishmentTypes`, `categories.parent`, `eventTag:id,name`, `slots` (active, ordered by date, with booked count), `ticketTypes` (active, ordered by sort_order), `venue`, `extraServices` (active, ordered by sort_order), `indicativePrices` (ordered by sort_order)). The same caveats apply — most notably:

- `target_audiences`, `themes`, `special_events`, `emotions`, and `entry_type` (the resolved object — only the `_id` is returned) are **not** included; they require the event detail call.
- `lat` / `lng` are returned as decimal **strings**, not numbers.
- For `booking_mode === "discovery"` events, `is_available` on slots is unreliable (capacity is typically `null`) — see home-feed §5.1 for the fallback rule.

If the mobile screen needs the same MobileEvent rendering across both feeds, the **same view layer** should serve both — only the surrounding container (sectioned vs. flat) differs.

---

## 4. Affinity ordering — what mobile UX should know

Because strata are not exposed, the UI cannot natively show "this event is in your feed because you follow XYZ". If product wants that hinting, two options:

1. **Server-side opt-in** (preferred when ready): add a `?reason=true` query param that emits `data[*].personalisation_reason` ∈ `{"members_only", "booked", "reminder", "favourite", "followed"}`. Not implemented today — file an issue if you need it.
2. **Client-side reconstruction** (works today): cross-reference each returned `event.uuid` against the user's locally-cached `/v1/me/bookings`, `/v1/me/favorites`, `/v1/me/memberships`, `/v1/me/event-reminders` — and pick whichever signal matches. The matching priority should mirror §2.1: members-only > bookings > reminders > favourites > follows.

Server-side reasons would be cheaper and authoritative; the controller already knows. Until then, the contract is intentionally **opaque** — `data` is "ordered events you care about", and that's all the client is guaranteed to know.

---

## 5. Complete realistic response example

A logged-in user who is an `active` member of "La Boucherie d'Aix", has a confirmed booking for an upcoming concert, and follows two further organisations. With `?limit=4`:

```json
{
  "success": true,
  "data": [
    {
      "uuid": "019d35e0-f585-7286-be2b-a3146b6cef7f",
      "slug": "soiree-degustation-vins-membres",
      "title": "Soirée dégustation vins (réservée aux membres)",
      "is_members_only": true,
      "status": "published",
      "visibility": "private",
      "is_password_protected": false,
      "has_password": false,
      "booking_mode": "booking",
      "is_featured": false,
      "venue_name": "La Boucherie d'Aix",
      "city": "Aix-en-Provence",
      "country": "FR",
      "start_date": "2026-05-10T00:00:00+02:00",
      "dates": {
        "start_date": "2026-05-10",
        "end_date": "2026-05-10",
        "start_time": "19:30:00",
        "end_time": "22:00:00",
        "display": "dimanche 10 mai 2026",
        "duration_minutes": 150,
        "is_recurring": false
      },
      "price_from": 25,
      "is_free": false,
      "pricing": {
        "is_free": false,
        "min": 25,
        "max": 35,
        "currency": "EUR",
        "display": "25,00€"
      },
      "availability": {
        "status": "available",
        "total_capacity": 30,
        "spots_remaining": 12,
        "percentage_filled": 60
      },
      "can_accept_bookings": true,
      "can_accept_discovery": false,
      "is_discovery": false,
      "organizer": { "uuid": "org-aix-…", "name": "La Boucherie d'Aix", "verified": true, "type": "vendor", "is_platform": false, "events_count": 24, "followers_count": 1820, "venue_types": ["Restaurant", "Bar"], "logo": "https://…", "slug": "la-boucherie-aix", "description": "…", "member_since": "2025-08-12T10:00:00+02:00", "allow_public_contact": true },
      "primary_category": { "id": 71, "name": "Œnologie", "slug": "oenologie", "icon": "wine", "color": "#8E2424", "parent": null },
      "categories": [/* … */],
      "slots": [/* … */],
      "ticket_types": [/* Adulte 25€, VIP 35€ */],
      "venue": { "uuid": "…", "name": "La Boucherie d'Aix", "slug": "la-boucherie-aix", "services": {}, "accessibility": {} },
      "extra_services": [],
      "indicative_prices": [],
      "version": 3
      /* …all other MobileEventResource fields per HOME_FEED_MOBILE_SPEC §4… */
    },

    {
      "uuid": "019d3932-eab9-726a-9fad-72accc6c9274",
      "slug": "evermore-hommage-mylene-farmer",
      "title": "Evermore - Hommage à Mylène Farmer",
      "is_members_only": false,
      "status": "published",
      "visibility": "public",
      "booking_mode": "discovery",
      "venue_name": "Théâtre Municipal de Denain",
      "city": "Denain",
      "country": "FR",
      "start_date": "2026-05-07T00:00:00+02:00",
      "dates": { "start_date": "2026-05-07", "end_date": "2026-05-07", "start_time": "20:00:00", "end_time": "22:00:00", "display": "jeudi 07 mai 2026", "duration_minutes": 120, "is_recurring": false },
      "price_from": 22,
      "pricing": { "is_free": false, "min": 22, "max": 0, "currency": "EUR", "display": "22,00€" },
      "availability": { "status": "available", "total_capacity": 0, "spots_remaining": 0, "percentage_filled": 0 },
      "can_accept_bookings": false,
      "can_accept_discovery": true,
      "is_discovery": true,
      "participation_count": 12,
      "is_participating": true,
      "creation_source": "crawler",
      "original_organizer_name": "Théâtre de Denain",
      "organizer": { "uuid": "…", "name": "Théâtre de Denain", "type": "platform", "is_platform": true, "verified": true, /* … */ }
      /* …rest of MobileEventResource fields… */
    },

    {
      "uuid": "019cf1aa-…",
      "slug": "soiree-jazz-le-bistrot",
      "title": "Soirée Jazz au Bistrot",
      "is_members_only": false,
      "status": "published",
      "booking_mode": "booking",
      "city": "Lyon",
      "country": "FR",
      "start_date": "2026-05-15T00:00:00+02:00"
      /* …rest of MobileEventResource fields… surfaced because the user follows the organising org… */
    },

    {
      "uuid": "019cf080-…",
      "slug": "marche-de-printemps",
      "title": "Marché de Printemps",
      "is_members_only": false,
      "status": "published",
      "booking_mode": "discovery",
      "city": "Annecy",
      "country": "FR",
      "start_date": "2026-05-18T00:00:00+02:00"
      /* …rest of MobileEventResource fields… surfaced because the user follows another organising org… */
    }
  ]
}
```

> Per §4, the client cannot tell from the payload alone that the first item came from the members-only stratum and the next three from the booking / following strata. Use `is_members_only`, `is_participating`, and a cross-reference against `/v1/me/bookings` / `/v1/me/favorites` if the UI wants to label "Tu participes" / "Tu y vas" / "Tu suis l'organisateur".

The example above is **illustrative** — values are reconstructed from the resource code. For a verbatim live example of a single `MobileEventResource`, see [`HOME_FEED_MOBILE_SPEC.md`](HOME_FEED_MOBILE_SPEC.md) §6.

---

## 6. Edge cases & error responses

| Situation | Response | Mobile behaviour |
|---|---|---|
| Anonymous call (no bearer) | **401** `{"message": "Unauthenticated.", "error": "unauthenticated"}` | Treat as session-expired — prompt re-login. |
| Bearer expired or invalidated | **401** (same body) | Same — re-auth flow. |
| Authenticated, brand-new user (no memberships / bookings / etc.) | 200 with `data: []` | Onboarding empty-state (§3.2). |
| User has lots of upcoming members-only events | 200 with `data` filled entirely from stratum 1 | Render as a uniform list — the UI doesn't know it's all stratum 1, and that's fine. |
| User favorited an event that has since passed | 200, the past event appears in `data` (stratum 4 has no future-slot filter) | Render normally — past favourites are useful for review/post-event UX. The slots in `data[*].slots` are the past dates; mobile may want to show "Événement passé" instead of a "Book" CTA when `availability.status === "unavailable"` or all slot `is_past === true`. |
| User left an org they were a member of | After membership goes from `active` → cancelled, that org's members-only events disappear on next refetch | **Invalidate cache** on any membership write (`POST /v1/organizations/{slug}/membership-request` / `DELETE …`). |
| User cancels a confirmed booking | The booking's event may disappear from stratum 2 — but the event may still appear via another stratum (favourite, follow) | Invalidate after any booking-status change. |
| `limit=0` or `limit=21` | **422** with `errors.limit` | Clamp client-side to `[1, 20]`. |
| Stratum-internal DB error (e.g. `event_reminders` table issue) | 200 with whatever the other strata produced; the failing stratum is silently skipped (Sentry/log gets the exception via `report()`) | No client-visible signal — trust response. |
| Server timezone differs from device timezone | Future-slot filter uses **server** day boundary | Trust the server. Don't re-filter client-side. |
| Event was edited between two refetches | New `version` integer, new `updated_at` | Use either to invalidate per-event caches in any list view. |

---

## 7. Caching strategy

The personalised feed is **slightly more dynamic** than the home feed: any user-action that changes one of the five signals invalidates the answer. Practical rules:

| TTL / event | Behaviour |
|---|---|
| **60 seconds** stale (foreground) | Serve from cache without refetch. Acceptable staleness for `available_capacity` and `participation_count`. |
| **1 hour** gc | Drop completely if not accessed in an hour. |
| Foreground refresh | Refetch on app return from background. |
| Pull-to-refresh | Refetch immediately, bypass cache. |
| **After login / logout** | **Invalidate.** Different user → entirely different feed. (Logout clears the cache entirely; on login, the previous user's cache MUST not leak.) |
| **After membership change** (request / cancel / approval) | **Invalidate.** Stratum 1 set changes. |
| **After booking creation / cancellation** | **Invalidate.** Stratum 2 set changes. |
| **After event reminder add / remove** | **Invalidate.** Stratum 3 set changes. |
| **After favourite add / remove** | **Invalidate.** Stratum 4 set changes. |
| **After org follow / unfollow** | **Invalidate.** Stratum 5 set changes. |
| When the user changes the active organisation context (vendor mode) | Not applicable — this endpoint is customer-side only and ignores `X-Organization-Id`. |

> Compared to `/v1/home-feed` — which only invalidates on auth-change and on booking-affecting actions — the personalised feed has **strictly more invalidation triggers**. It's worth wiring a single `invalidate('personalized_feed:*')` call into every mutation point, rather than trying to scope per-strata.

The cache key SHOULD be scoped per user — at minimum `personalized_feed:user:<user_uuid>:limit:<limit>`. **Never key on bearer string alone** (token rotation would multiply entries) and **never share a key across users** (privacy: stratum 1 contents differ).

---

## 8. Filtering & what's NOT supported

The personalised feed is **identity-driven**, not query-driven. The following are NOT supported here — use the appropriate dedicated endpoint:

| You want… | Use instead |
|---|---|
| Filter by city / region | `GET /v1/events?city=…` |
| Filter by category / theme / target audience / emotion | `GET /v1/events?category=…` etc. |
| Filter by date range | `GET /v1/events?date_from=…&date_to=…` |
| Filter by price range / free-only | `GET /v1/events?price_type=free` |
| Sort by anything other than affinity (1→5, then `created_at DESC`) | `GET /v1/events?sort=…` |
| Pagination beyond `limit=20` | The dedicated lists per signal: `/v1/me/bookings`, `/v1/me/favorites`, `/v1/me/private-events`, `/v1/me/memberships` |
| Geolocation-based ranking | Not available anywhere yet (cf. `home-feed` §10). |
| **Cross-user feeds** (e.g. "what my friends like") | Not implemented. Out of scope. |

> If the mobile UX adds a "Pour vous → filtrer par ville" picker, treat that as **switching screens** to `/v1/events`, not as parameterising this endpoint. The strata definitions don't compose with arbitrary filters cleanly (e.g. "members-only events in Aix this weekend" is fine to compute server-side, but the strata-priority logic stops being meaningful).

---

## 9. Flutter integration sketch

### 9.1 Type definitions (Dart)

```dart
class PersonalizedFeed {
  final List<MobileEvent> events;

  PersonalizedFeed.fromJson(List<dynamic> data)
      : events = data
            .map((e) => MobileEvent.fromJson(e as Map<String, dynamic>))
            .toList();

  bool get isEmpty => events.isEmpty;
}
```

The `MobileEvent` model is **identical** to the one used for `/v1/home-feed` — share the freezed/json_serializable class across both endpoints.

### 9.2 Fetch with cache & 401 handling

```dart
Future<PersonalizedFeed> fetchPersonalizedFeed({
  required String userUuid,
  required String bearerToken,
  int limit = 8,
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
    return _cache.get<PersonalizedFeed>(cacheKey) ?? PersonalizedFeed.fromJson(const []);
  }

  final body = jsonDecode(res.body) as Map<String, dynamic>;
  final feed = PersonalizedFeed.fromJson(body['data'] as List);
  await _cache.set(cacheKey, feed, ttl: const Duration(hours: 1));
  return feed;
}
```

### 9.3 Display with empty-state onboarding

```dart
final feed = await fetchPersonalizedFeed(...);

if (feed.isEmpty) {
  return _PersonalizedEmptyState(
    onExploreEvents: () => Navigator.pushNamed(context, '/events'),
    onBrowseOrgs: () => Navigator.pushNamed(context, '/organizations'),
  );
}

return ListView(
  children: [
    _SectionHeader('Pour vous'),
    ...feed.events.map((e) => EventCard(event: e)),
  ],
);
```

### 9.4 Invalidate after every signal change

```dart
final _personalizedFeedCachePrefix = 'personalized_feed:';

Future<void> _invalidatePersonalizedFeed() =>
    _cache.invalidate(prefix: _personalizedFeedCachePrefix);

// Wire into every mutation point:
Future<void> onLogin() async   => _invalidatePersonalizedFeed();
Future<void> onLogout() async  => _invalidatePersonalizedFeed();
Future<void> onMembershipChange() async => _invalidatePersonalizedFeed();
Future<void> onBookingChange() async    => _invalidatePersonalizedFeed();
Future<void> onReminderChange() async   => _invalidatePersonalizedFeed();
Future<void> onFavouriteChange() async  => _invalidatePersonalizedFeed();
Future<void> onFollowChange() async     => _invalidatePersonalizedFeed();
```

---

## 10. Versioning & stability commitment

| Aspect | Promise |
|---|---|
| Path `/api/v1/me/personalized-feed` | Stable. Breaking changes go to `/v2`. |
| Top-level shape (`{success, data: []}`) | Stable. New keys (e.g. `meta`) may be added — clients MUST ignore unknown keys. |
| `MobileEventResource` field set | Stable for declared fields. New optional fields may be added. **Mirrors `/home-feed` field set** — the two evolve together. |
| Stratum order (1: members-only → 2: bookings → 3: reminders → 4: favourites → 5: follows) | Stable. New strata, if added, will be appended (e.g. stratum 6: ML personalisation), never inserted between existing ones. |
| Cross-strata UUID dedup | Stable. |
| Early-exit-on-limit | Stable. |
| Per-stratum `created_at DESC` ordering | Stable. |
| `limit` semantics & range | Stable: total cap, max 20. |
| Auth requirement | Stable: 401 for unauthenticated. |

A potential **additive** change to watch for:
- A future `?reason=true` query param exposing `personalisation_reason` per item (§4 option 1).
- A future `?since=<iso>` to power "what's new since I last looked" deltas — not in scope today.

Both would be opt-in; the default response shape stays unchanged.

---

## 11. Out of scope (current version)

- **Personalisation reasoning in the response** — strata are not exposed (§4).
- **ML / collaborative filtering** — no "people like you also liked" signal. Strata are deterministic.
- **Geolocation** — no proximity boost. Use `/home-feed` (when geo-aware variant ships) or `/v1/events?lat=&lng=`.
- **Pagination / cursors** — cap-and-go.
- **Per-strata sort overrides** — server-decided.
- **Filtering by anything** — no `?city=`, no `?category=`, etc. (§8).
- **Cross-user feeds** — "friends are going" or "popular among members" is not modeled.
- **Stories / ads / banners** — own endpoints; compose in parallel on the home screen if the personalised feed is mounted there.
- **Push notifications when new items hit your feed** — not driven from this endpoint. See [`PUSH_NOTIFICATIONS_MOBILE_SPEC.md`](PUSH_NOTIFICATIONS_MOBILE_SPEC.md) for what does drive pushes (alerts, bookings, memberships).

---

## 12. Troubleshooting & FAQ

**Q: Why is my members-only event missing?**
Either (a) you're not authenticated — check `GET /v1/auth/me` returns 200; (b) your `OrganizationMember` row isn't `status=active` (it may still be `pending` after the request) — check `GET /v1/me/memberships`; (c) the event has no future slot — past members-only events are excluded by stratum 1.

**Q: Why is `data` empty even though I have favourites?**
Most likely the bearer is silently invalid — the endpoint returns **401**, not an empty `data`. If you're getting 200 with `data: []` while you have favourites, double-check `GET /v1/me/favorites` actually returns rows for the same user — cache cross-pollination is a common culprit during development.

**Q: Why does an event I've booked also count as a favourite — does it get listed twice?**
No. Cross-strata dedup keeps each event at most once (§2.2), and the **earliest** stratum wins — so a booked-and-favorited event is attributed to stratum 2 (bookings), not stratum 4 (favourites).

**Q: I unfollowed an org but its events still show up in my feed.**
You're hitting the cache. After any signal change (follow, favourite, reminder, booking, membership, login/logout), **invalidate** the personalised feed cache (§7). The server-side response updates immediately on the next call.

**Q: How do I show a "Tu y vas" badge on the events I've booked?**
The simplest path: cross-reference each `event.uuid` in `data` against your locally-cached `/v1/me/bookings`. Server-side reasons aren't returned today (§4).

**Q: Some past events keep showing up.**
Strata 3 (reminders) and 4 (favourites) intentionally include past events (§2.1). If you don't want them on the home screen, filter client-side on `availability.status === "available"` or check whether **all** slots are `is_past === true`.

**Q: I'm getting 401 even with what looks like a valid token.**
Verify with `GET /v1/auth/me` first — Sanctum returns 401 for both expired and never-existed tokens, with the same body. After a `migrate:fresh` on the dev environment, all tokens are nuked (cf. CLAUDE.md "Opérations Base de Données") — re-login.

**Q: `limit=20` still returns fewer than 20 events.**
That's expected. `limit` is a **cap**, not a target. The user genuinely has only N events with affinity signals. To grow the response: book more, favourite more, follow more orgs, join more communities. Or: switch to the discovery feed at `/v1/events`.

**Q: Can I get the same response without `is_members_only` events (e.g. for users who only browse public)?**
Not via a query param. You'd have to filter client-side on `is_members_only === false`. But this defeats the purpose — those events are **highest** affinity.

**Q: The `slots` array contains past dates.**
For events surfaced via reminders / favourites (strata 3 & 4), this is normal — they have no future-slot filter at the event level (§2.1). Within the event, `slots` is filtered to `is_active=true` only, not future-only. Render past slots as informational ("Événement passé") and hide the booking CTA when all slots are `is_past === true`.

**Q: Can two devices for the same user get different responses?**
Only via cache. The server response is deterministic given (`user_id`, `limit`, current time). If two devices show different lists, one is stale — the resolution is identical to web vs. app: pull-to-refresh on the older one.

**Q: Is the response stable enough to use as the source of truth for "next event for the user"?**
For an authenticated user, **yes** — `data[0]` is the highest-affinity upcoming-or-recent event. For a use case like a homescreen widget that needs "next thing on the user's calendar", `GET /v1/me/bookings?status=confirmed&upcoming=true` is more direct and cheaper.

---

## 13. Related endpoints

| Endpoint | Why mention it |
|---|---|
| [`GET /v1/home-feed`](HOME_FEED_MOBILE_SPEC.md) | The non-personalised companion. Today / tomorrow / recommended. Same per-event payload. |
| `GET /v1/me/bookings` | Power the "Mes réservations" tab. Stratum 2 in detail. |
| `GET /v1/me/favorites` | Power the "Favoris" tab. Stratum 4 in detail. |
| `GET /v1/me/reminders` | Stratum 3 in detail. |
| `GET /v1/me/memberships` | Stratum 1 source — the orgs whose members-only events you can see. |
| `GET /v1/me/private-events` | Paginated list of all private events the user is entitled to (members-only superset of stratum 1). |
| `GET /v1/events` | General catalogue with full filtering (city, category, date, price). Use for browse / search after the user finishes with the personalised feed. |
| `POST /v1/auth/login` | Bearer token source. **Required** for this endpoint. |
| `GET /v1/auth/me` | Verify a bearer is still valid before assuming a 401 means "no events". |
