# Hero Slides — Mobile Integration Spec

**Audience** : Mobile app (Flutter)
**Status** : Stable contract
**Scope** : Display the homepage hero carousel — a small set of editorial banner images managed by admins at `/admin/homepage/hero-carousel`.

These are decorative, full-bleed images shown at the top of the homepage. They rotate automatically (web does ~5s/slide). There is currently no click-through link on a slide — they're visual only.

---

## TL;DR — Quick start

| Step | Endpoint |
|---|---|
| Fetch | `GET /api/v1/hero-slides` (public, no auth) |
| Cache | 1h stale, 24h gc (same pattern as `/mobile/config`) |
| Refetch | App foreground + pull-to-refresh |
| Empty state | `data: []` → hide the carousel or show a bundled fallback image |

---

## 1. Endpoint

```
GET /api/v1/hero-slides
```

- **Auth**: none
- **Headers**: `Accept: application/json` (sufficient)
- **Response shape**: returns only `is_active=true` slides, ordered by `sort_order` ascending, with `created_at` ascending as the deterministic tie-breaker. Mobile clients can trust the array order as-returned (recommended) or re-sort locally using the same keys if needed.
- **No pagination** — typical fleet is 3–8 slides

### 200 response

```json
{
  "success": true,
  "data": [
    {
      "uuid": "9f2a-7b3c-…",
      "id": "9f2a-7b3c-…",
      "image_url": "https://minio.lehiboo.com/hero-slides/9f2a-7b3c-…/abc123.jpg",
      "alt_text": "Concerts d'été",
      "sort_order": 1,
      "is_active": true,
      "created_at": "2026-04-12T09:00:00+02:00",
      "updated_at": "2026-04-30T14:22:00+02:00",
      "imageUrl": "https://minio.lehiboo.com/hero-slides/9f2a-7b3c-…/abc123.jpg",
      "altText": "Concerts d'été",
      "sortOrder": 1,
      "isActive": true,
      "createdAt": "2026-04-12T09:00:00+02:00",
      "updatedAt": "2026-04-30T14:22:00+02:00"
    }
  ]
}
```

Both snake_case and camelCase keys are present per the project's dual-format convention. Mobile clients SHOULD pick one style and stick with it.

> **Note on the `id` field.** For historical reasons the response contains an `id` key whose value is the slide's **UUID** (the same value as `uuid`) — it is *not* a numeric primary key and is **not** the column the server uses to break sort ties. Treat `id` as a deprecated alias of `uuid` and prefer `uuid` in new code. Do not attempt to sort by it client-side; the server returns rows in their final order.

### Edge cases

| Situation | Server response | Mobile behaviour |
|---|---|---|
| No active slides | `data: []` (HTTP 200) | Hide the carousel section. Do **not** crash. |
| Network unreachable on cold start | n/a | Show a bundled static fallback image for ~1 frame; refetch on next foreground. |
| Image URL unreachable (MinIO down, broken file) | n/a | Skip that slide silently. Don't block the whole carousel. |
| Slide gets deactivated mid-session | Excluded from next response | Carousel updates on next refetch — no push. |

---

## 2. Caching strategy

Slides change at editorial pace (a handful of times per month, max). The mobile app SHOULD cache aggressively:

| TTL | Behaviour |
|---|---|
| 1 hour stale | Serve from cache without re-fetching |
| 24 hour gc | Drop completely if not seen in 24h |
| Foreground refresh | Refetch when the app returns from background |
| Pull-to-refresh | Refetch immediately, bypass cache |

This mirrors the pattern of `useMediaConstraints` (`/mobile/config`) on the web frontend. There is **no push, no webhook, no websocket** for hero slides — refresh is purely pull-based.

---

## 3. Image guidance

| Aspect | Value |
|---|---|
| Format | jpg / png / webp |
| Max upload size | 5 MB (admin enforcement) |
| Recommended source resolution | ~1920×800 (retina-friendly) |
| Aspect ratio | Not enforced server-side. Confirm with the design system before locking the carousel to a fixed ratio. |
| Storage | MinIO; `image_url` is the full URL — no base-URL concatenation needed |
| Cache-busting | `image_url` filename includes a random suffix (`{random}.jpg`); re-uploads change the URL automatically — safe to use HTTP cache headers |
| `alt_text` | Always present (required at admin creation). Use for screen-reader announcements. |

---

## 4. Flutter sketch

### 4.1 Type

```dart
class HeroSlide {
  final String uuid;
  final String imageUrl;
  final String altText;
  final int sortOrder;

  HeroSlide.fromJson(Map<String, dynamic> j)
    : uuid = j['uuid'],
      imageUrl = j['image_url'],
      altText = j['alt_text'],
      sortOrder = j['sort_order'];
}
```

### 4.2 Fetch + cache

```dart
Future<List<HeroSlide>> fetchHeroSlides({bool force = false}) async {
  if (!force && _cache.isFresh()) return _cache.data;

  final res = await http.get(
    Uri.parse('$apiBase/v1/hero-slides'),
    headers: {'Accept': 'application/json'},
  );

  if (res.statusCode != 200) {
    return _cache.data; // serve stale on failure
  }

  final body = jsonDecode(res.body) as Map<String, dynamic>;
  final slides = (body['data'] as List)
    .map((j) => HeroSlide.fromJson(j))
    .toList();

  _cache.set(slides, ttl: const Duration(hours: 1));
  return slides;
}
```

### 4.3 Display

```dart
PageView.builder(
  itemCount: slides.length,
  itemBuilder: (ctx, i) => Image.network(
    slides[i].imageUrl,
    semanticLabel: slides[i].altText,
    fit: BoxFit.cover,
    errorBuilder: (_, __, ___) => const SizedBox.shrink(), // skip broken
  ),
)
```

Auto-rotate with a `Timer.periodic(Duration(seconds: 5), …)` matching the web cadence. If the carousel is paused (vendor scrolling, accessibility focus), don't advance.

---

## 5. Versioning

| Aspect | Promise |
|---|---|
| Path `/v1/hero-slides` | Stable. Breaking changes go to `/v2/`. |
| Field names (`image_url`, `alt_text`, `sort_order`, `is_active`, `uuid`) | Stable. New optional fields may be added — clients MUST ignore unknown keys. |
| Sort behaviour | Stable: `sort_order` asc, then `created_at` asc as a deterministic tie-breaker. Both columns are exposed in the response. |
| `is_active` filter | Stable: only `true` returned. The admin endpoint can request both. |
| `id` alias | The `id` field will continue to be returned as an alias of `uuid` for backwards compatibility. New clients SHOULD ignore it and read `uuid`. |

---

## 6. Out of scope (future candidates)

- **Click-through links** — slides currently have no `target_url`. If marketing wants "tap a hero slide to open an event/page," that's a schema addition. The sibling `/v1/homepage-ads` endpoint already supports click-through if you need that today.
- **Localised slides** — currently one global set; same image shown to all locales. Per-locale slides would need a model change.
- **Scheduling** (start_at / end_at) — currently active is a boolean toggle only. Editorial team manually toggles before/after a campaign. A scheduled active window is a v2 candidate.
- **Per-platform variants** — no field for "show this slide only on mobile" or "only on web." Same payload everywhere.
- **Analytics / impression tracking** — no impression endpoint (unlike Stories). Add if marketing needs hero engagement metrics.

---

## 7. Related endpoints

| Endpoint | What it does | Why mention it here |
|---|---|---|
| `GET /v1/homepage-ads` | Sponsored banners with `target_url` (clickable) | Use this if you need clickable banners — hero slides are decorative only. |
| `GET /v1/auth-slides?context=login\|register` | Onboarding carousel for the auth screens | Different surface — same pattern. |
| `GET /v1/stories/active` | Instagram-style story circles (image or video) | Different surface — see `MOBILE_CHECKIN_SPEC.md`-style spec to be written. |
| `GET /v1/mobile/config` | App-level config including a single static `hero.image` URL | **Not** the carousel — single static fallback only. Do not confuse with this endpoint. |