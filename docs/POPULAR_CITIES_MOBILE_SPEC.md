# Popular Cities — Mobile Integration Spec

**Audience** : Mobile app (Flutter)
**Status** : Draft — see "Open product decisions" at the bottom before implementing client-side
**Scope** : Display the curated list of cities admins highlight on the homepage / city picker. Cities are flagged in the admin dashboard at `/admin/cities` (toggle "Featured"). On mobile, this set is surfaced as "Popular cities".

> **Naming heads-up.** Product/UX calls this "popular cities". The backend column is `cities.is_featured`. They refer to the **same** flag. There is no separate `is_popular` column. Any future "computed popularity" (e.g. by event volume) would be a different endpoint.

---

## TL;DR — Quick start

| Step | Endpoint |
|---|---|
| Fetch | `GET /api/v1/cities?featured_only=1&only_with_upcoming_slots=1` (public, no auth) |
| Cache | 6h stale, 24h gc — cities change at editorial pace |
| Refetch | App foreground + pull-to-refresh on the city picker |
| Empty state | `data.cities: []` → fall back to all active cities sorted by `events_count` (see §5) |

---

## 1. Endpoint

```
GET /api/v1/cities
```

(also reachable as `GET /api/v1/events/cities` — same controller method, identical response.)

- **Auth**: none
- **Headers**: `Accept: application/json`
- **Backed by**: `App\Http\Controllers\Api\V1\EventController::cities` (`api/app/Http/Controllers/Api/V1/EventController.php:844`)
- **No pagination** — typical curated set is 6–20 cities

### Query parameters

| Param | Type | Default | Effect |
|---|---|---|---|
| `featured_only` | bool (`1`/`0`/`true`/`false`) | `false` | When truthy, returns only cities with `is_featured = true`. **Required for "popular cities"**. |
| `only_with_upcoming_slots` | bool | `false` | Excludes cities that have zero published, active, upcoming events. **Strongly recommended** for mobile to avoid showing cities with nothing to book. (`with_upcoming_slots` is accepted as an alias.) |
| `region` | string | — | Filter by `region` value (case-sensitive exact match). |
| `department` | string | — | Filter by `department` value (case-sensitive exact match). |

> **For the "popular cities" surface**, the canonical call is:
>
> ```
> GET /api/v1/cities?featured_only=1&only_with_upcoming_slots=1
> ```

### Server-side ordering

The endpoint returns cities sorted (in order):

1. `is_featured` DESC — featured cities first (always true here when `featured_only=1`)
2. `events_count` DESC — busier featured cities first
3. `sort_order` ASC — admin's manual tie-breaker

> ⚠️ The controller composes this ordering with chained collection `sortBy`/`sortByDesc` calls (PHP `sort` is stable, so subsequent sorts preserve relative order of equal keys). Mobile clients **should trust the array order as returned** and not re-sort client-side. If the admin reorders cities (drag-and-drop in `/admin/cities`), the new `sort_order` is reflected on the next refetch.

### 200 response

```json
{
  "success": true,
  "data": {
    "cities": [
      {
        "id": "9f2a-7b3c-…",
        "uuid": "9f2a-7b3c-…",
        "name": "Lille",
        "slug": "lille",
        "region": "Hauts-de-France",
        "department": "Nord",
        "postal_code": "59000",
        "postalCode": "59000",
        "description": "Capitale des Flandres…",
        "description_translations": { "fr": "…", "en": "…" },
        "descriptionTranslations": { "fr": "…", "en": "…" },
        "meta_title": "Sorties à Lille",
        "metaTitle": "Sorties à Lille",
        "meta_description": "…",
        "metaDescription": "…",
        "image_url": "https://minio.lehiboo.com/cities/9f2a-…/lille.jpg",
        "imageUrl": "https://minio.lehiboo.com/cities/9f2a-…/lille.jpg",
        "thumbnail_url": "https://minio.lehiboo.com/cities/9f2a-…/lille-thumb.jpg",
        "thumbnailUrl": "https://minio.lehiboo.com/cities/9f2a-…/lille-thumb.jpg",
        "latitude": "50.6293",
        "longitude": "3.0573",
        "has_coordinates": true,
        "hasCoordinates": true,
        "is_featured": true,
        "isFeatured": true,
        "is_active": true,
        "isActive": true,
        "sort_order": 1,
        "sortOrder": 1,
        "events_count": 47,
        "eventsCount": 47,
        "metadata": null,
        "created_at": "2026-01-24T14:00:00+01:00",
        "createdAt": "2026-01-24T14:00:00+01:00",
        "updated_at": "2026-04-30T09:15:00+02:00",
        "updatedAt": "2026-04-30T09:15:00+02:00"
      }
    ]
  }
}
```

> Both snake_case and camelCase keys are present per the project's dual-format Resource convention. Mobile clients SHOULD pick one style and stick with it.

### Response-shape caveat (does **not** follow the standard pattern)

This endpoint nests the array under `data.cities` rather than putting it directly in `data`. This breaks the project's "lists go in `data: [...]`" convention (`CLAUDE.md` → "Structure des Réponses API"). It is intentional for legacy reasons and **will not change** without a versioned migration.

| Flutter | TypeScript |
|---|---|
| `(json['data']['cities'] as List)` | `response.data.cities` |

### Field reference (essentials)

| Field | Notes |
|---|---|
| `uuid` | Stable identifier. Use this everywhere. `id` is a deprecated alias holding the same UUID — **not** a numeric PK. |
| `name` | Display name. Always present. |
| `slug` | URL-safe; use for deep links (`/cities/{slug}`) if mobile supports it. |
| `latitude` / `longitude` | Returned as **strings** (Eloquent decimal cast). Parse with `double.parse(...)` / `Number(...)` before use. May be `null` for cities admins haven't geocoded yet. Pair with `has_coordinates` for a quick guard. |
| `image_url` / `thumbnail_url` | Full S3/MinIO URLs. Either can be `null` — provide a placeholder. Use `thumbnail_url` in lists, `image_url` for hero/banner contexts. |
| `events_count` | Count of published, active events (and *upcoming* when `only_with_upcoming_slots=1` is in the query). Only present when the relation was preloaded server-side — for this endpoint it always is. Useful for "X events" badges. |
| `is_featured` / `isFeatured` | Will always be `true` when `featured_only=1`. Surfacing this in the UI is unnecessary, but you may use it as a defensive assertion. |
| `description` / `description_translations` | Long-form HTML. Strip tags before showing on small surfaces. Use the locale-keyed translations map for i18n. |

### Edge cases

| Situation | Server response | Mobile behaviour |
|---|---|---|
| No city flagged as featured yet | `data.cities: []` (HTTP 200) | Fall back to non-featured query — see §5. |
| All featured cities have zero upcoming events | `data.cities: []` (HTTP 200) | Same fallback as above; do **not** show featured-but-empty cities. |
| `cities` table is empty entirely | Legacy fallback path activates and returns cities aggregated from `venues`. In that path `is_featured` is **hardcoded `false`** for every row, so `featured_only=1` yields `[]`. | Treat as the "empty featured set" case (§5). |
| Network unreachable | n/a | Serve stale cache (§3). On a cold start with no cache, show a hardcoded short list (e.g. Lille, Paris, Lyon, Marseille) or hide the section. |
| Image URL 404 | n/a | Skip the image, render a name-only chip/card. Don't block the row. |

---

## 2. Authentication

None. The endpoint is fully public — usable on the onboarding screen before the user logs in.

---

## 3. Caching strategy

| TTL | Behaviour |
|---|---|
| 6 hours stale | Serve from cache without re-fetching |
| 24 hours GC | Purge from cache |
| Pull-to-refresh | Force-refresh, ignore cache |
| App foreground | If stale > 6h, refetch silently in background |

Rationale: admins typically flag/unflag cities a handful of times per month. `events_count` *does* drift more often (every new published event), but a 6h drift is acceptable for a curation surface — the count is illustrative, not transactional.

---

## 4. Suggested Flutter model

```dart
class PopularCity {
  final String uuid;
  final String name;
  final String slug;
  final String? region;
  final String? department;
  final String? imageUrl;
  final String? thumbnailUrl;
  final double? latitude;
  final double? longitude;
  final int eventsCount;
  final bool isFeatured;

  PopularCity({
    required this.uuid,
    required this.name,
    required this.slug,
    required this.eventsCount,
    required this.isFeatured,
    this.region,
    this.department,
    this.imageUrl,
    this.thumbnailUrl,
    this.latitude,
    this.longitude,
  });

  factory PopularCity.fromJson(Map<String, dynamic> json) => PopularCity(
        uuid: json['uuid'] as String,
        name: json['name'] as String,
        slug: json['slug'] as String,
        region: json['region'] as String?,
        department: json['department'] as String?,
        imageUrl: json['image_url'] as String?,
        thumbnailUrl: json['thumbnail_url'] as String?,
        latitude: json['latitude'] == null
            ? null
            : double.tryParse(json['latitude'].toString()),
        longitude: json['longitude'] == null
            ? null
            : double.tryParse(json['longitude'].toString()),
        eventsCount: (json['events_count'] as int?) ?? 0,
        isFeatured: (json['is_featured'] as bool?) ?? false,
      );
}
```

Parse the outer envelope as `(json['data']['cities'] as List).map(PopularCity.fromJson).toList()`.

---

## 5. Empty-state fallback (recommended UX)

If `featured_only=1` returns an empty list, do **not** show "no cities available" — the admin team may simply not have curated the list yet, while there are still active cities with events. Issue a second call:

```
GET /api/v1/cities?only_with_upcoming_slots=1
```

Take the **first 6** cities of the response (already sorted by `is_featured` DESC, then `events_count` DESC, then `sort_order`). Display them with a slightly different header — e.g. "Where it's happening" vs. "Popular cities" — to keep the editorial distinction explicit, but do not surface the fallback to the user as an error.

Cache the fallback result under a separate key from the primary result so the next foreground refetch can re-attempt the curated query.

---

## 6. Analytics / telemetry hooks

Suggested events for product:

| Event | When | Properties |
|---|---|---|
| `popular_cities_viewed` | Section rendered | `count`, `is_fallback` (true if §5 path) |
| `popular_city_tapped` | User taps a city card | `city_uuid`, `city_slug`, `position` (1-indexed), `events_count` |
| `popular_cities_empty` | Both primary and fallback returned `[]` | — |

These let product/marketing measure whether the curation drives clicks vs. organic ordering.

---

## 7. Admin counterpart (for context, not implementation)

These admin endpoints power the dashboard that produces this list — mobile **does not** call them directly:

| Action | Endpoint |
|---|---|
| Toggle a city as featured/popular | `POST /api/v1/admin/cities/{uuid}/toggle-featured` |
| Reorder featured cities | `POST /api/v1/admin/cities/reorder` |
| Toggle active | `POST /api/v1/admin/cities/{uuid}/toggle-active` |

Once an admin toggles a city, the change is visible on the public endpoint immediately on the next request (no scheduled job).

---

## 8. Backend files (for cross-team debugging)

| File | Role |
|---|---|
| `api/routes/api.php:275, :282` | Public route declarations (`events/cities`, `cities`) |
| `api/routes/api.php:2092-2106` | Admin city management routes |
| `api/app/Http/Controllers/Api/V1/EventController.php:844` | `cities()` method — filters, ordering, response shape |
| `api/app/Http/Resources/CityResource.php` | Per-city field mapping (dual-format) |
| `api/app/Models/City.php:152` | `scopeFeatured()` and `scopeOrdered()` |
| `api/database/migrations/2026_01_24_140000_create_cities_table.php` | Schema (`is_featured`, `is_active`, `sort_order`) |

---

## 9. Open product decisions

> These should be resolved **before** the mobile team ships this section. Each one changes either the contract or the UX.

1. **Naming on mobile UI.** Product says "popular cities". Backend says "featured". Confirm the user-facing string per locale (`messages/*.json` namespace, key suggestion: `cities.popular.title`). All six locales need a value.
2. **Card vs. chip layout.** Image-led cards require `image_url`/`thumbnail_url` to be populated for every featured city — admins currently *can* publish a featured city without an image. Decide: enforce on backend (validation on `toggle-featured`), or tolerate on frontend with a name-only fallback chip.
3. **Max cards to show.** Is the list capped on mobile (e.g. first 6) or fully scrollable? If capped, mobile slices `data.cities.take(N)` — backend does not enforce a limit.
4. **Empty-state copy.** Section 5 recommends a silent fallback. Confirm that's the desired UX, or whether the section should hide entirely when the curated set is empty.
5. **Deep-link behaviour.** Tapping a popular city should land where — the city detail page, or a pre-filtered events list (`/events?city=<slug>`)? This affects both the navigation stack and the analytics `popular_city_tapped` `destination` property.

Resolve and either remove this section or move resolutions into the relevant numbered sections above.
