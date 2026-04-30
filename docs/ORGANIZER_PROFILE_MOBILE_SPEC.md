# Organizer Public Profile — Mobile Integration Spec

**Audience** : Mobile app (Flutter)
**Status** : Stable contract
**Reference web implementation** : `frontend/src/app/[locale]/(public)/organizers/[slug]/page.tsx`

This spec defines the mobile equivalent of the web public organizer profile screen. It maps every visible UI block to the API call that powers it, documents the response shape mobile should consume, and lists the mobile-specific UX adaptations.

---

## 1. Screen overview

The web page renders, top-to-bottom:

1. **Hero** — full-width cover image (`organizer.cover_image`) with gradient overlay; back button overlay.
2. **Identity card** — avatar (`organizer.logo`) with verified badge (`organizer.verified`), display name, city badge, stats row (activities count, followers count, average rating + reviews count).
3. **Action bar** — three buttons: **Contact** (auth-gated), **Follow / Unfollow** (auth-gated), **Coordinates** (toggles a sub-bar revealing email / phone / website on demand).
4. **Tabs**:
   - **Activities** — paginated event grid with a secondary toggle "Current & upcoming" vs "Past" (computed from each event's slots).
   - **About** — `description`, list of `establishment_types`, social links.
   - **Reviews** — placeholder (no reviews API yet).

Mobile should reproduce all three blocks plus the activity tab. The reviews tab can be omitted on first iteration (see §10).

---

## 2. Endpoints used by this screen

| # | Method | Route | Purpose | Auth |
|---|---|---|---|---|
| 1 | `GET` | `/api/v1/organizers/{slug_or_uuid}` | Profile data | optional (auth changes `is_followed`) |
| 2 | `GET` | `/api/v1/organizers/{slug_or_uuid}/events` | Paginated events list | none |
| 3 | `POST` | `/api/v1/me/organizers/{slug_or_uuid}/follow` | Follow | required |
| 4 | `DELETE` | `/api/v1/me/organizers/{slug_or_uuid}/follow` | Unfollow | required |
| 5 | `POST` | `/api/v1/me/conversations/from-organization/{organizationUuid}` | Send a message via the contact form | required |
| 6 | `GET` | `/api/v1/me/organizers/following` | List the user's followed organizers (paginated) — **powers a separate "Following" screen, not this profile screen** | required |

> **Slug or UUID** — endpoints 1–4 accept either as the path parameter (recently aligned). Mobile should send `organization.uuid` since that's the field consistently exposed across the rest of the API. Route param is named `{slug}` in the route definition for legacy reasons; the controllers detect UUID format internally.
>
> **Endpoint 5** requires the **UUID** (the route uses `{organizationUuid}` and the controller does `where('uuid', ...)` — slug is not accepted).
>
> **Endpoint 6** is documented in this spec for cohesion (all organizer-related routes in one place) but it powers a different mobile screen — the "Organisateurs suivis" list. See §6bis for details.

---

## 3. Endpoint 1 — Profile

```
GET /api/v1/organizers/{slug_or_uuid}
```

### 3.1 Headers

| Header | Required | Effect |
|---|---|---|
| `Authorization` | optional | When present, response sets `is_followed` to `true`/`false`. When absent, `is_followed` is `null` (mobile must hide the follow button or treat as "not followed"). |
| `Accept-Language` | optional | Drives translated nested fields (descriptions). |

### 3.2 Path Param

Either `organization.slug` (e.g. `theatre-de-denain`) or `organization.uuid`. Recommended: send `uuid` for consistency with the rest of the mobile surface.

### 3.3 Success — `200 OK`

```json
{ "data": { ... } }
```

The fields below are everything the mobile screen needs (the resource exposes more — fields gated by `canViewSettings` are owner/admin-only and irrelevant to public profile).

| Field | Type | UI binding |
|---|---|---|
| `uuid` | string | identifier — pass to follow/contact endpoints |
| `slug` | string | analytics, deep link |
| `name` | string | fallback name |
| `display_name` / `displayName` | string | **primary header title** — fall back to `name` if empty |
| `description` | string \| null | **About tab body** |
| `logo` | string (url) \| null | **avatar** |
| `cover_image` / `coverImage` | string (url) \| null | **hero background** — show gradient placeholder when null |
| `website` | string \| null | Coordinates → website button |
| `email` | string \| null | Coordinates → email button — same as `public_email` server-side |
| `phone` | string \| null | Coordinates → phone button |
| `address` | string \| null | optional details row |
| `city` | string \| null | **city badge** in header |
| `zipCode` | string \| null | optional |
| `country` | string \| null | optional |
| `verified` / `isVerified` | bool | **show "verified" badge on avatar** |
| `allow_public_contact` / `allowPublicContact` | bool | **gate the Contact button** — hide when `false` |
| `eventsCount` / `events_count` | int | **stats row** — "N activities" |
| `followersCount` / `followers_count` | int | **stats row** — "N followers" |
| `is_followed` / `isFollowed` | bool \| null | **Follow button state**. `null` = not authenticated (hide the button). `false` = show "Follow". `true` = show "Following". |
| `reviews_count` | int | **stats row** — "(N reviews)" |
| `average_rating` | float \| null | **stats row** — only render when `> 0` |
| `social_links` | object \| null | **About tab** — keys: `facebook`, `instagram`, `twitter`, `linkedin`, `youtube`. Values are URL strings or null. |
| `establishment_types` / `establishmentTypes` | array | **About tab** — list of `{ uuid, name, slug }` (only present when relation is loaded; this endpoint does load it) |
| `createdAt` / `created_at` | ISO 8601 | "Member since" if displayed |

### 3.4 Errors

| Status | Cause |
|---|---|
| `404 Not Found` | Slug/UUID doesn't exist, **or** organization status is not `verified` (`pending` and `suspended` orgs are hidden from this endpoint). |
| `500` | Server error |

### 3.5 Sample call (Dio)

```dart
Future<OrganizerProfile> fetchOrganizer(String identifier) async {
  final response = await dio.get<Map<String, dynamic>>(
    '/api/v1/organizers/$identifier',
    options: Options(
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    ),
  );
  return OrganizerProfile.fromJson(response.data!['data']);
}
```

---

## 4. Endpoint 2 — Events list

```
GET /api/v1/organizers/{slug_or_uuid}/events
```

Paginated. Powers the **Activities** tab. The web page client-side filters by slot date to split between "current/upcoming" and "past"; mobile should mirror that logic since the API does not split.

### 4.1 Query params

| Param | Type | Default | Notes |
|---|---|---|---|
| `per_page` | int (1–100) | 12 | |
| `page` | int | 1 | Standard Laravel pagination |

### 4.2 Headers

`X-Platform: mobile` is **strongly recommended** so each event in the list embeds the lighter `MobileEventResource` (snake_case, unified `organizer` block, services included). Without it the response defaults to web shape.

### 4.3 Success — `200 OK`

```json
{
  "success": true,
  "data": [ /* array of EventResource (or MobileEventResource) */ ],
  "meta": { "total": 24, "page": 1, "per_page": 12, "last_page": 2 }
}
```

The shape of each event is documented in `MobileEventResource.php`. Fields most relevant for the activities grid:

| Field | Use |
|---|---|
| `uuid`, `slug`, `title` | card title and tap-target |
| `featured_image_url` (web) / `cover_image` (mobile) | card image |
| `slots[]` with `slot_date`, `start_time`, `end_time` | **filter logic** — "current/upcoming" if any slot's end time is `>= now`, else "past" |
| `event_type` | filter to `online` events on web; mobile may choose to show all |
| `city`, `venue_name` | secondary card line |
| `categories[]`, `event_tag` | optional badges |

### 4.4 Mobile filter logic (matches web)

```dart
enum EventTimingBucket { currentUpcoming, past }

EventTimingBucket bucketFor(Event event, DateTime now) {
  if (event.slots.isEmpty) return EventTimingBucket.currentUpcoming;
  final allPast = event.slots.every((s) => s.endDateTime.isBefore(now));
  return allPast ? EventTimingBucket.past : EventTimingBucket.currentUpcoming;
}
```

### 4.5 Errors

| Status | Cause |
|---|---|
| `404` | Organization slug/UUID doesn't exist (note: this endpoint does **not** filter by status, unlike the profile endpoint, so it can return events for non-verified orgs — but those orgs already 404 on endpoint 1) |

---

## 5. Endpoint 3 / 4 — Follow / Unfollow

```
POST   /api/v1/me/organizers/{slug_or_uuid}/follow
DELETE /api/v1/me/organizers/{slug_or_uuid}/follow
```

Both require auth. Optimistic UI is recommended (toggle the button immediately, reconcile from response).

### 5.1 Success — `201 Created` (POST, first time) / `200 OK` (POST repeat, or DELETE)

```json
{
  "message": "Organizer followed successfully.",
  "data": {
    "is_followed": true,
    "followers_count": 1234
  }
}
```

Mobile should update both the button state (`is_followed`) and the displayed `followers_count` in the stats row directly from this response.

### 5.2 Errors

| Status | Cause |
|---|---|
| `401` | Token missing/expired — surface the auth-required dialog (same flow as web, see §9) |
| `404` | Organization not found, not verified, or wrong identifier |

### 5.3 Sample call

```dart
Future<FollowState> follow(String identifier) async {
  final response = await dio.post<Map<String, dynamic>>(
    '/api/v1/me/organizers/$identifier/follow',
    options: Options(headers: {'Authorization': 'Bearer $token'}),
  );
  return FollowState.fromJson(response.data!['data']);
}

Future<FollowState> unfollow(String identifier) async {
  final response = await dio.delete<Map<String, dynamic>>(
    '/api/v1/me/organizers/$identifier/follow',
    options: Options(headers: {'Authorization': 'Bearer $token'}),
  );
  return FollowState.fromJson(response.data!['data']);
}
```

---

## 6. Endpoint 5 — Contact form

```
POST /api/v1/me/conversations/from-organization/{organizationUuid}
```

Requires auth. `{organizationUuid}` **must be the UUID** (not slug) — the controller does `where('uuid', ...)` only.

### 6.1 Request body

```json
{
  "subject": "Question sur l'événement",
  "message": "Bonjour, ...",
  "event_id": "019d35e0-..."           // optional — UUID or integer ID, must belong to this organization
}
```

| Field | Type | Required | Constraints |
|---|---|---|---|
| `subject` | string | yes | min 3, max 255 |
| `message` | string | yes | min 1, max 10 000 |
| `event_id` | string \| int | no | If sent, must reference an event of this organization. UUID accepted. |
| `attachments[]` | file[] | no | Max 3 files, 5 MB each, mimes: `jpg`, `jpeg`, `png`, `webp`, `pdf`. Send as `multipart/form-data` when used. |

### 6.2 Success — `201 Created`

Returns the new conversation envelope (full payload documented separately in `MOBILE_MESSAGES.md`, not yet written). Mobile typically navigates to the new conversation thread on success.

### 6.3 Errors

| Status | Cause |
|---|---|
| `401` | Not authenticated |
| `403` | `organization.allow_public_contact == false` — the org disabled public messaging. **Mobile must hide the Contact button when `allow_public_contact` is false** (the data is in endpoint 1's response). |
| `404` | Organization UUID doesn't exist or is not verified |
| `422` | Validation failure (subject too short, etc.) |

---

## 6bis. Endpoint 6 — User's followed organizers (separate screen)

```
GET /api/v1/me/organizers/following
```

This endpoint powers a **separate mobile screen** — the "Organisateurs suivis" list a user reaches from their profile/menu. It's not used by the profile screen this spec primarily describes, but it's documented here so all organizer-related routes live in one place.

### 6bis.1 Headers

```
GET /api/v1/me/organizers/following HTTP/1.1
Host: api.lehiboo.com
Accept: application/json
Authorization: Bearer <token>      # required
X-Platform: mobile                  # recommended for symmetry
```

### 6bis.2 Query params

| Param | Type | Default | Constraints | Notes |
|---|---|---|---|---|
| `search` | string | — | max 255 | Full-text on org name fields (`organization_name`, `organization_display_name`, `company_name`). Leave empty for full list. |
| `per_page` | int | **100** | 1–100 | Default is intentionally high to preserve "give me everything" semantics for the dashboard's client-side filtering. Pass a smaller value (e.g. `20`) for paginated mobile lists. |
| `page` | int | 1 | ≥ 1 | Standard Laravel page number. |

### 6bis.3 Authorization

Standard `auth:sanctum`. The endpoint scopes to `auth()->user()` automatically — there is no path param. A 401 means token missing or expired.

### 6bis.4 Filters applied server-side

The list is automatically filtered to:
- Organizations with `status = 'verified'` (suspended/pending orgs are hidden — even if the user once followed them).
- Result ordered by `organizer_follows.created_at DESC` (most recently followed first).
- Each item gets `is_followed = true` set explicitly (no need to infer per-row).

### 6bis.5 Success — `200 OK`

```jsonc
{
  "success": true,
  "data": [
    {
      "uuid": "019d35e0-...",
      "slug": "theatre-de-denain",
      "name": "Théâtre de Denain",
      "display_name": "Théâtre de Denain",
      "logo": "https://...",
      "cover_image": "https://...",
      "city": "Denain",
      "verified": true,
      "events_count": 24,           // published events only
      "followers_count": 1234,
      "is_followed": true,           // always true on this endpoint
      "average_rating": 4.6,
      "reviews_count": 128,
      "social_links": { ... },
      "establishment_types": [ ... ]
      // ...full OrganizationResource — see §3.3 for the complete field list
    }
  ],
  "meta": {
    "total": 24,
    "page": 1,
    "per_page": 100,
    "last_page": 1
  }
}
```

Each item is the same `OrganizationResource` shape as endpoint 1 (the profile endpoint), so mobile can reuse the same `OrganizerProfile` data class for parsing.

### 6bis.6 Errors

| Status | Cause |
|---|---|
| `401 Unauthorized` | Token missing/expired |
| `422 Unprocessable Entity` | `per_page` out of range, `search` exceeds 255 chars, etc. — standard Laravel validation envelope |

### 6bis.7 Recommended mobile usage

```
On "Organisateurs suivis" screen mount:
  GET /me/organizers/following?per_page=20&page=1

On scroll near end:
  GET /me/organizers/following?per_page=20&page=N+1
  Append response.data to local list. Stop when meta.page >= meta.last_page.

On search:
  Debounce 250ms, then:
  GET /me/organizers/following?search={query}&per_page=20&page=1
  Replace local list.

On unfollow tap (any item):
  Optimistic remove + DELETE /me/organizers/{uuid}/follow.
  On 4xx, restore the item.
```

### 6bis.8 Sample call (Dio)

```dart
Future<PaginatedFollowed> fetchFollowedOrganizers({
  String? search,
  int page = 1,
  int perPage = 20,
}) async {
  final response = await dio.get<Map<String, dynamic>>(
    '/api/v1/me/organizers/following',
    queryParameters: {
      if (search != null && search.isNotEmpty) 'search': search,
      'page': page,
      'per_page': perPage,
    },
    options: Options(headers: {'Authorization': 'Bearer $token'}),
  );

  final body = response.data!;
  final items = (body['data'] as List)
      .map((j) => OrganizerProfile.fromJson(j))
      .toList();

  return PaginatedFollowed(
    items: items,
    page: body['meta']['page'] as int,
    perPage: body['meta']['per_page'] as int,
    total: body['meta']['total'] as int,
    lastPage: body['meta']['last_page'] as int,
  );
}
```

### 6bis.9 Operational notes

| Concern | Note |
|---|---|
| **Default per_page is 100** | This is a *backwards-compatibility* default chosen so the existing web dashboard (which filters client-side on the full list) keeps working. Mobile should explicitly pass a smaller `per_page` (e.g. 20) for paginated lists — don't rely on the default. |
| **`is_followed` is hard-set to `true`** | Every row on this endpoint is by definition followed, so the field is set explicitly rather than inferred from the pivot. Mobile can trust it without re-querying. |
| **Suspended orgs disappear** | If an organizer the user follows transitions from `verified` to `suspended`, that org will silently drop out of this list — even though the underlying `organizer_follows` row still exists. There's currently no UI signal for "you used to follow this org but it's suspended now"; if that's user-visible behavior is needed, it requires a backend change. |
| **No cursor pagination** | Standard page/per_page pagination only. For very long lists (thousands), cursor pagination on `organizer_follows.created_at` would be more stable, but no user is anywhere near that scale today. |
| **Cache invalidation** | Invalidate this list whenever the user follows or unfollows from any other screen (e.g. the profile screen's Follow button). Both follow endpoints return `is_followed` and `followers_count` for the affected org — but they don't tell you the new ordering, so refetching this list is safest. |

---

## 7. Mobile screen composition

```
┌──────────────────────────────────────────┐
│  ◀          (back button overlay)        │
│  ┌────────────────────────────────────┐  │
│  │   Cover image (16:9 or 40% screen) │  │← organizer.cover_image
│  └────────────────────────────────────┘  │
│                                          │
│   ╭──╮  Display Name                     │← organizer.logo + verified badge
│   ╰──╯                                   │  organizer.display_name
│        📍 Lyon                            │← organizer.city (badge)
│        📅 24 activities                  │← stats from organizer.events_count
│        ❤  1234 followers                  │  organizer.followers_count
│        ⭐ 4.6  (128 reviews)              │  average_rating, reviews_count
│                                          │
│   [Contacter]  [Suivre]  [Coordonnées ▾] │← action bar
│                                          │
│   (when Coordonnées tapped:              │
│   [✉ Email] [📞 Tel] [🌐 Site])           │
│                                          │
│  ──── Activités | À propos | Avis ─────  │← tabs
│                                          │
│  ┌──── tab content scrollable ────┐      │
│  │   En cours (12)  Passés (4)    │      │← sub-toggle for events tab
│  │   ┌────┐ ┌────┐ ┌────┐         │      │← event cards (grid or list)
│  │   │ ev │ │ ev │ │ ev │         │      │
│  │   └────┘ └────┘ └────┘         │      │
│  └────────────────────────────────┘      │
└──────────────────────────────────────────┘
```

### 7.1 Recommended widget tree

```
OrganizerProfileScreen
├── SliverAppBar (collapsing, hosts cover image + back button)
├── SliverToBoxAdapter
│   ├── _IdentityCard (avatar + name + city + stats)
│   └── _ActionBar (Contact, Follow, Coordinates toggle)
│       └── _CoordinatesPanel (revealed on tap)
└── SliverFillRemaining
    └── DefaultTabController(length: 3)
        ├── TabBar(Activities, À propos, Avis)
        └── TabBarView
            ├── _ActivitiesTab(currentUpcoming, past)
            ├── _AboutTab(description, establishmentTypes, socialLinks)
            └── _ReviewsTabPlaceholder
```

---

## 8. Mobile screen flow

```
1. Navigate to OrganizerProfileScreen(identifier).
2. In parallel:
     - GET /organizers/{identifier}             → profile state
     - GET /organizers/{identifier}/events?per_page=24
3. Render hero + identity card from profile.
4. Render activity grid; client-side bucket events into "current/upcoming" vs "past".
5. Wire actions:
     - Tap Follow:
         if not authenticated → show AuthRequired dialog → on login, retry.
         else → optimistic toggle, POST/DELETE follow, reconcile on response.
     - Tap Contact:
         if !organization.allow_public_contact → hide button entirely (preventive).
         if not authenticated → show AuthRequired dialog.
         else → push ContactForm screen.
                On submit: POST /me/conversations/from-organization/{uuid}.
                On 201 → navigate to the new conversation thread.
     - Tap Coordonnées:
         if not authenticated → show AuthRequired dialog.
         else → toggle the panel; on individual coordinate tap, reveal the value
                (already in the profile response — no extra call needed).
6. Pagination on activity grid: when user scrolls near end, fetch next page.
7. Pull-to-refresh: re-call both endpoints.
```

---

## 9. Auth gating — the AuthRequired pattern

Three actions on this screen require authentication: **Follow**, **Contact**, **Coordinates reveal**. The web app shows an `AuthRequiredDialog` as a modal; mobile should mirror this with a native `BottomSheet` or `AlertDialog` containing:

- Title: "Connectez-vous pour accéder à cette action"
- CTA: "Se connecter" → navigate to login flow
- Secondary: "Créer un compte" → navigate to signup
- Cancel: dismiss

After successful login, mobile should return to this screen and re-trigger the action that prompted the dialog (web stores the intent in component state — same approach works on mobile via a `pendingAction` controller).

---

## 10. Mobile-specific simplifications

| Web element | Mobile adaptation |
|---|---|
| Breadcrumb "Events > Organizers > [name]" | Replace with native back button in the AppBar (already in the SliverAppBar). |
| Three-tab structure (Activities, About, Reviews) | Keep, but **omit the Reviews tab** on first iteration — web shows an empty placeholder anyway. Drop or hide until a reviews API exists. |
| Inner sub-tabs "Current & upcoming" vs "Past" | Keep as a single segmented toggle above the event list. |
| Online-only filter (web filters `event_type == 'online'`) | **Drop on mobile** — that filter is a web-specific concern. Show all events of the organizer. |
| Coordinates "click to reveal" (per-field) | Mobile pattern: tap the panel toggle once → all three buttons appear; tap each button → display its value as a `Chip` below. Identical UX is fine. |
| Hover states (e.g. social icons scaling) | Replace with tap feedback (ripple or scale-on-press). |

---

## 11. Sample data classes (Dart, suggestion)

```dart
class OrganizerProfile {
  final String uuid;
  final String slug;
  final String displayName;
  final String? description;
  final String? logo;
  final String? coverImage;
  final String? city;
  final String? website;
  final String? email;
  final String? phone;
  final bool verified;
  final bool allowPublicContact;
  final int eventsCount;
  final int followersCount;
  final int reviewsCount;
  final double? averageRating;
  final bool? isFollowed;                       // null when unauthenticated
  final SocialLinks? socialLinks;
  final List<EstablishmentType> establishmentTypes;

  factory OrganizerProfile.fromJson(Map<String, dynamic> json) =>
      OrganizerProfile(
        uuid: json['uuid'] as String,
        slug: json['slug'] as String,
        displayName: (json['display_name'] ?? json['name']) as String,
        description: json['description'] as String?,
        logo: json['logo'] as String?,
        coverImage: json['cover_image'] as String?,
        city: json['city'] as String?,
        website: json['website'] as String?,
        email: json['email'] as String?,
        phone: json['phone'] as String?,
        verified: (json['verified'] ?? json['isVerified']) as bool? ?? false,
        allowPublicContact: json['allow_public_contact'] as bool? ?? true,
        eventsCount: (json['events_count'] ?? json['eventsCount']) as int? ?? 0,
        followersCount: (json['followers_count'] ?? json['followersCount']) as int? ?? 0,
        reviewsCount: json['reviews_count'] as int? ?? 0,
        averageRating: (json['average_rating'] as num?)?.toDouble(),
        isFollowed: json['is_followed'] as bool?,
        socialLinks: json['social_links'] == null
            ? null
            : SocialLinks.fromJson(json['social_links']),
        establishmentTypes: (json['establishment_types'] as List? ?? [])
            .map((j) => EstablishmentType.fromJson(j))
            .toList(),
      );
}

class SocialLinks {
  final String? facebook, instagram, twitter, linkedin, youtube;
  /* fromJson trivial */
}

class EstablishmentType {
  final String uuid, name, slug;
  /* fromJson trivial */
}

class FollowState {
  final bool isFollowed;
  final int followersCount;
  factory FollowState.fromJson(Map<String, dynamic> json) =>
      FollowState(
        isFollowed: json['is_followed'] as bool,
        followersCount: json['followers_count'] as int,
      );
}
```

---

## 12. Operational notes

| Concern | Note |
|---|---|
| **Identifier choice** | Mobile should consistently send `organization.uuid` to all four organizer endpoints. Slug works too, but using uuid is more stable across the rest of the API and doesn't break if the org renames itself. |
| **Caching** | Profile data changes rarely — cache for ~5 min by `uuid`. Followers count and `is_followed` should be invalidated immediately on a follow/unfollow round-trip (use the response payload to update). |
| **Cover-image fallback** | Use a primary-color gradient (matches web `from-primary-900 via-primary-700 to-primary-500`) when `cover_image` is null. |
| **Stats formatting** | Use locale-aware number formatting (`NumberFormat.compact()`) for `followersCount`/`eventsCount` once they exceed ~1000. |
| **Pagination** | Use cursor-or-page pagination on the events list; `last_page` in `meta` lets mobile know when to stop. Keep `per_page = 12` to match web. |
| **404 on `is_followed=null`** | If the user is unauthenticated, `is_followed` is `null` rather than `false`. Treat null as "show Follow button as if logged-out" — tapping it triggers AuthRequired dialog. |
| **`average_rating` cosmetics** | Web hides the rating row when `average_rating <= 0`. Mobile should mirror — empty 0.0 is misleading for a verified-but-new organizer. |
| **Verified badge asset** | Web uses `/badge_approved.svg`. Mobile should ship an equivalent asset (consistent visual identity). |

---

## 13. Related specs

| Spec | When to read |
|---|---|
| `BOOKING_DETAIL_MOBILE_SPEC.md` | When implementing event card → booking flow tail |
| `BOOKING_CREATE_MOBILE_SPEC.md` | When user books from this organizer's events |
| `BOOKING_TICKETS_CANCELLATION_MOBILE_SPEC.md` | Post-booking management |

---

## 14. Open questions / future work

| Topic | Note |
|---|---|
| **Reviews tab** | Currently empty placeholder on web. Backend has `reviews_count` and `average_rating` aggregates but no per-review fetching endpoint. Track the reviews API addition before implementing this tab on mobile. |
| **Block / report organizer** | Web doesn't expose this yet. Likely a future requirement for moderation. |
| **Share link** | Web has no explicit share button. On mobile, an iOS/Android share sheet using the public URL `https://lehiboo.com/organizers/{slug}` would be a low-effort improvement. |
| **Push notifications** | Following an organizer should subscribe the user to a notification channel. Backend support is present (`OrganizerFollow` model + alert pipeline) but the FCM topic name convention is not yet documented. |
