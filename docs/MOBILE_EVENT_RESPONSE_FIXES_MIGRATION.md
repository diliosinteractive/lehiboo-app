# Migration Guide — Event Response Fixes (Verified Flag + Event Tag)

**Date** : 2026-04-27
**Audience** : Mobile team (Flutter)
**Backend PR scope** : Resource and controller fixes. No DB migration, no breaking schema change.

---

## TL;DR

Two bugs fixed in event API responses :

1. **`organizer.verified`** was **always `false`** — now correctly reflects the organization's verification status.
2. **`event_tag`** (the `{ id, name }` object behind the form's "Event Type" / "Type d'événement" field) was **missing** from listing endpoints (`/home-feed`, `/events`, `/events/featured`, `/events/similar`, `/events/trending`) — now eager-loaded and present in every event in those responses.

Both are **non-breaking** : no field is removed or renamed. The mobile can simply start consuming the corrected values.

---

## 1. `organizer.verified` Now Correct

### Before

```json
"organizer": {
  "uuid": "019d8652-64c8-70a4-823c-d37b9ee4c7f9",
  "name": "Bobo Junior",
  "verified": false,        // ← always false, even for verified vendors
  ...
}
```

### After

```json
"organizer": {
  "uuid": "019d8652-64c8-70a4-823c-d37b9ee4c7f9",
  "name": "Bobo Junior",
  "verified": true,         // ← reflects organization.status === 'verified'
  ...
}
```

### Root cause (for context)

`Organization.status` is cast as the `OrganizationStatus` enum (PHP backed enum). The backend was comparing the enum case to the string `'verified'` with `===`, which is always `false` in PHP. Fixed by comparing against the enum case directly.

### Affected fields

The fix applies wherever an organizer/organization block is exposed on event responses:

| Resource | Block | Field |
|---|---|---|
| `EventResource` | `organization` | `verified` |
| `EventResource` | `vendor` (legacy alias) | `verified` |
| `EventResource` | `organizer` (mobile alias) | `verified` |
| `MobileEventResource` | `organizer` | `verified` |

### Mobile impact

- **No code change required** if the mobile already reads `organizer.verified`.
- Verified-badge UI should now light up correctly for verified organizations.
- If the mobile had a workaround (e.g. always hiding the badge, or computing verification client-side), it can be removed.

### Affected endpoints

Every endpoint that returns events with an organizer block, including :

- `GET /v1/home-feed`
- `GET /v1/events`
- `GET /v1/events/{slug-or-uuid}`
- `GET /v1/events/featured`
- `GET /v1/events/similar/{id}`
- `GET /v1/events/trending`
- `GET /v1/me/bookings` (event nested)
- `GET /v1/bookings/{uuid}` (event nested)

---

## 2. `event_tag` Now Present on Listing Endpoints

### Context

The vendor dashboard form labelled **"Event Type"** (FR : *Type d'événement*) is bound to the `event_tag_id` foreign key — **not** the `event_type` enum. Values are user-readable labels like `"Show"`, `"Concert"`, `"Festival"`, etc., stored in the `event_tags` table.

> ⚠️ **Naming trap** : the form label says "Event Type" but the data field is `event_tag`. The unrelated `event_type` enum has values `offline | online | hybrid` and is **not** what the form shows.

### Before

On listing endpoints, only the raw FK was sent ; the relation object was omitted because it wasn't eager-loaded :

```json
{
  "uuid": "...",
  "title": "Waah Papa Show",
  "event_tag_id": 7
  // event_tag missing — could not display "Show" without an extra lookup
}
```

### After

Every event in listing responses now includes the resolved `event_tag` object :

```json
{
  "uuid": "...",
  "title": "Waah Papa Show",
  "event_tag_id": 7,
  "event_tag": {
    "id": 7,
    "name": "Show"
  }
}
```

### Schema

| Field | Type | Nullable | Notes |
|---|---|---|---|
| `event_tag_id` | integer \| null | yes | FK to `event_tags.id` |
| `event_tag` | object \| null | yes | Resolved relation, `null` when no tag is set |
| `event_tag.id` | integer | no | |
| `event_tag.name` | string | no | Display label (e.g. `"Show"`, `"Concert"`) |

`event_tag` is **`null`** when the event has no tag assigned. Mobile code MUST handle that case.

### Affected endpoints

| Endpoint | Status before | Status after |
|---|---|---|
| `GET /v1/home-feed` | ❌ no `event_tag` | ✅ included |
| `GET /v1/events` (list / search) | ❌ no `event_tag` | ✅ included |
| `GET /v1/events/featured` | ❌ no `event_tag` | ✅ included |
| `GET /v1/events/similar/{id}` | ❌ no `event_tag` | ✅ included |
| `GET /v1/events/trending` | ❌ no `event_tag` | ✅ included |
| Stories module (`getEventsWithStories`) | ❌ no `event_tag` | ✅ included |
| `GET /v1/events/{slug-or-uuid}` (detail) | ✅ already worked | ✅ no change |

### Mobile impact

- **Optional consumption** : mobile can now display the event tag (e.g. as a chip / badge) on event cards without an extra round-trip.
- `event_tag_id` is unchanged — clients that only read the ID continue to work.
- Mobile should treat `event_tag` as **optional** (`null` is a valid value).

### Suggested Flutter model

```dart
class EventTag {
  final int id;
  final String name;

  EventTag({required this.id, required this.name});

  factory EventTag.fromJson(Map<String, dynamic> json) => EventTag(
        id: json['id'] as int,
        name: json['name'] as String,
      );
}

// On Event model:
final EventTag? eventTag;            // nullable
final int? eventTagId;               // nullable
```

---

## 3. Backward Compatibility

Both changes are **strictly additive / corrective** :

- ✅ No field renamed
- ✅ No field removed
- ✅ No type change
- ✅ No new required field
- ✅ No new request parameter

Mobile builds released **before** this fix continue to work. They will simply :
- Start receiving `verified: true` for verified organizers (was always `false`).
- Start receiving an additional `event_tag` object on listing endpoints.

---

## 4. Testing Checklist for Mobile

After backend redeploy, verify on a verified vendor with at least one tagged event :

- [ ] `GET /v1/home-feed` → events for that vendor have `organizer.verified === true`
- [ ] `GET /v1/home-feed` → events have `event_tag: { id, name }` populated
- [ ] `GET /v1/events?city=Lyon` → same checks pass on the list
- [ ] `GET /v1/events/featured` → same checks pass
- [ ] `GET /v1/events/trending` → same checks pass
- [ ] `GET /v1/events/{slug}` → no regression, both fields still populated
- [ ] Event with **no tag** → `event_tag === null`, no crash
- [ ] Pending vendor (not yet verified) → `organizer.verified === false`

---

## 5. Quick Curl Smoke Test

```bash
TOKEN="<user_token>"

# Should now return verified=true and a populated event_tag
curl -s "http://api.lehiboo.localhost/api/v1/home-feed?limit=3" \
  -H "Authorization: Bearer $TOKEN" \
  -H "X-Platform: mobile" \
  | jq '.data.today[] | {
      title,
      organizer_verified: .organizer.verified,
      event_tag
    }'
```

Expected output (for events of a verified vendor with a tag) :

```json
{
  "title": "Waah Papa Show",
  "organizer_verified": true,
  "event_tag": { "id": 7, "name": "Show" }
}
```

---

## 6. Related Files (Backend Reference)

| File | Change |
|---|---|
| `api/app/Http/Resources/EventResource.php` | Enum-safe comparison for `verified` |
| `api/app/Http/Resources/Mobile/MobileEventResource.php` | Enum-safe comparison for `verified` |
| `api/app/Http/Controllers/Api/V1/EventController.php` | Eager-load `eventTag` in `homeFeed`, `featured`, `similar` |
| `api/app/Services/EventService.php` | Eager-load `eventTag` in `getPublicEvents` (list / search) |
| `api/app/Services/TrendingService.php` | Eager-load `eventTag` in `getTrendingEvents`, `getEventsWithStories` |

---

## 7. Related Documentation

- `docs/03-guides/BOOKING_API_MOBILE.md` — Booking flow
- `docs/05-reference/BOOKING_CREATE_MOBILE_SPEC.md` — Booking creation contract
- `docs/MOBILE_BOOKING_BIRTH_DATE_TOWN_MIGRATION.md` — Previous migration template
