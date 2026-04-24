# Mobile Event DTO Migration Guide

**Date:** 2026-04-22
**Audience:** Flutter mobile team
**Backend version:** develop branch, commit after `feat(api): integrate MobileEventResource`

---

## Overview

The API now supports a dedicated mobile event response format. When the Flutter app sends an `X-Platform: mobile` header, event endpoints return a **clean, snake_case-only DTO** with:

- No camelCase duplicate fields
- A unified `organizer` object (replaces `organization`, `vendor`, and `organizer`)
- Venue services included
- Extra services (purchasable add-ons) included
- `creation_source` field for admin-created event detection

**This is opt-in.** Until the mobile app sends the header, responses are unchanged.

---

## Step 1: Add the Header

Add `X-Platform: mobile` to your HTTP client's default headers:

```dart
// Example with Dio
final dio = Dio(BaseOptions(
  baseUrl: 'https://api.lehiboo.com/api/v1',
  headers: {
    'X-Platform': 'mobile',
    'Accept': 'application/json',
    // ... existing headers (Authorization, X-Organization-Id, etc.)
  },
));
```

Once this header is present, the affected endpoints below will return the new format.

---

## Step 2: Affected Endpoints

### Endpoints returning MobileEventResource (with header)

| Endpoint | Behavior |
|----------|----------|
| `GET /api/v1/events` | Returns `MobileEventResource` when `X-Platform: mobile` |
| `GET /api/v1/events/{slug}` | Returns `MobileEventResource` when `X-Platform: mobile` |
| `GET /api/v1/events/{uuid}` | Returns `MobileEventResource` when `X-Platform: mobile` |
| `GET /api/v1/events/featured` | Returns `MobileEventResource` when `X-Platform: mobile` |
| `GET /api/v1/events/{slug}/similar` | Returns `MobileEventResource` when `X-Platform: mobile` |
| `GET /api/v1/trending` | Returns `MobileEventResource` when `X-Platform: mobile` |
| `GET /api/v1/urgency` | Returns `MobileEventResource` (nested in urgency wrapper) when `X-Platform: mobile` |
| `GET /api/v1/stories` | Returns `MobileEventResource` when `X-Platform: mobile` (deprecated endpoint) |
| `GET /api/v1/partners/{uuid}/events` | Returns `MobileEventResource` when `X-Platform: mobile` |
| `GET /api/v1/me/bookings` | `BookingResource` with nested `MobileEventResource` when `X-Platform: mobile` |
| `GET /api/v1/me/bookings/{booking}` | `BookingResource` with nested `MobileEventResource` when `X-Platform: mobile` |
| `GET /api/v1/home-feed` | **Always** returns `MobileEventResource` (no header needed) |

### Endpoints NOT affected (no event data or separate format)

These endpoints do not return event objects or use a separate format and are not impacted:

- `GET /api/v1/events/search` — Custom lightweight format for Petit Boo AI, separate concern
- Auth endpoints (`/auth/*`)
- Favorites (`/favorites/*`) — returns flattened event data, separate format
- Saved searches / Alerts (`/me/alerts/*`)
- Notifications (`/notifications/*`)
- Trip plans (`/me/trip-plans/*`)
- Hibons / Gamification (`/mobile/hibons/*`)
- Chat quota (`/mobile/chat/*`)
- Device tokens (`/auth/device-tokens/*`)
- User profile (`/auth/me`)
- Reviews, Questions, Conversations

---

## Step 3: Response DTO Changes

### Fields Removed

#### CamelCase duplicates (all removed)

These fields no longer appear in the response. Use the snake_case version:

| Removed (camelCase) | Use instead (snake_case) |
|---------------------|--------------------------|
| `coverImage` | `featured_image` |
| `bookingMode` | `booking_mode` |
| `allowCancellation` | `allow_cancellation` |
| `cancelBeforeHours` | `cancel_before_hours` |
| `generateQrCodes` | `generate_qr_codes` |
| `hasPassword` | `has_password` |
| `scheduledPublishAt` | `scheduled_publish_at` |
| `creationSource` | `creation_source` |
| `originalOrganizerName` | `original_organizer_name` |
| `discoveryPricingType` | `discovery_pricing_type` |
| `externalTicketingUrl` | `external_ticketing_url` |
| `canAcceptBookings` | `can_accept_bookings` |
| `canAcceptDiscovery` | `can_accept_discovery` |
| `isDiscovery` | `is_discovery` |
| `isParticipating` | `is_participating` |
| `participationCount` | `participation_count` |
| `otherServices` | `other_services` |
| `entryTypeId` | `entry_type_id` |
| `createdAt` | `created_at` |
| `updatedAt` | `updated_at` |

#### Redundant fields (removed entirely)

| Removed | Reason | Alternative |
|---------|--------|-------------|
| `id` | Was identical to `uuid` | Use `uuid` |
| `internal_id` | Internal integer ID | Use `uuid` |
| `cover_image` | Duplicate of `featured_image` | Use `featured_image` |
| `images` | Duplicate of `gallery` | Use `gallery` |
| `short_description` | Duplicate of `excerpt` | Use `excerpt` |
| `category` | Duplicate of `primary_category` | Use `primary_category` |
| `ticketTypes` (camelCase key) | Duplicate of `ticket_types` | Use `ticket_types` |
| `plain_password` | Security concern | Removed |

#### Vendor dashboard fields (removed — not relevant to mobile users)

| Removed |
|---------|
| `bookings_count` / `bookingsCount` |
| `slots_count` / `slotsCount` |
| `sold_tickets` / `soldTickets` |
| `revenue` |
| `totalCapacity` |
| `nextSlotDate` |
| `completion_percentage` |

---

### Fields Restructured

#### `organizer` replaces `organization` + `vendor` + `organizer`

**Before** (3 separate objects with different shapes):
```json
{
  "organization": { "uuid": "...", "name": "...", "organizationName": "...", ... },
  "vendor": { "uuid": "...", "name": "...", "organizationName": "...", ... },
  "organizer": { "id": 48, "name": "...", "avatar": "...", ... }
}
```

**After** (1 unified object):
```json
{
  "organizer": {
    "uuid": "019d8652-...",
    "name": "Bobo Corp",
    "slug": "bobo-corp",
    "logo": null,
    "type": null,
    "is_platform": false,
    "verified": false,
    "description": null,
    "events_count": 4,
    "followers_count": 0,
    "venue_types": ["Association"],
    "member_since": "2026-01-15T...",
    "allow_public_contact": true
  }
}
```

**Mapping from old fields:**

| Old field path | New field path |
|----------------|----------------|
| `organization.uuid` | `organizer.uuid` |
| `organization.name` or `organization.organizationName` | `organizer.name` |
| `organization.slug` | `organizer.slug` |
| `organization.logo` | `organizer.logo` |
| `organization.verified` | `organizer.verified` |
| `organization.eventsCount` | `organizer.events_count` |
| `organization.venueTypes` | `organizer.venue_types` |
| `organization.memberSince` | `organizer.member_since` |
| `organization.allowPublicContact` | `organizer.allow_public_contact` |
| `organization.isPlatform` | `organizer.is_platform` |
| `vendor.*` | Same as `organizer.*` (vendor was identical to organization) |
| `organizer.id` | Use `organizer.uuid` instead |
| `organizer.avatar` | `organizer.logo` |
| `organizer.profile_url` | Removed — construct client-side: `/organizers/{organizer.slug}` |

---

### Fields Added

#### `venue` object (when event has a linked venue)

```json
{
  "venue": {
    "uuid": "...",
    "name": "Stade Municipal",
    "slug": "stade-municipal",
    "services": {
      "restauration": true,
      "parking": true,
      "wifi": true
    },
    "accessibility": {}
  }
}
```

- `venue` is `null` when no venue is linked to the event
- `venue.services` contains the **venue's** infrastructure services (parking, wifi, etc.)
- This is distinct from the root-level `services` field which contains the **event organizer's** services

#### `extra_services` array (purchasable add-ons — reserved for future use)

- Currently always `[]` — the vendor form does not create these yet
- Will contain purchasable add-ons selectable during checkout (future feature)
- See `indicative_prices` below for the informational services vendors create today

#### `indicative_prices` array (informational additional services)

```json
{
  "indicative_prices": [
    {
      "uuid": "019db9b3-aea4-...",
      "label": "Polishing",
      "price": 5.00,
      "currency": "EUR",
      "sort_order": 0
    }
  ]
}
```

- Empty array `[]` when no indicative services exist
- Created by vendors in the "Additional services (indicative)" section of the event form
- **Informational only** — not selectable or purchasable, displayed for user awareness
- See `docs/MOBILE_INDICATIVE_PRICES_MIGRATION.md` for full details

---

### Nested Objects Cleaned Up

#### `slots[]` — snake_case only

**Before:**
```json
{
  "id": "019d8c6e-...",
  "uuid": "019d8c6e-...",
  "event_id": 241,
  "eventId": 241,
  "slot_date": "2026-04-23T22:00:00.000000Z",
  "slotDate": "2026-04-24",
  "date": "2026-04-24",
  "start_time": "14:00:00",
  "startTime": "14:00:00",
  "startDate": "2026-04-24T14:00:00+02:00",
  "endDate": "2026-04-24T17:00:00+02:00",
  ...
}
```

**After:**
```json
{
  "uuid": "019d8c6e-...",
  "date": "2026-04-24",
  "start_time": "14:00:00",
  "end_time": "17:00:00",
  "start_datetime": "2026-04-24T14:00:00+02:00",
  "end_datetime": "2026-04-24T17:00:00+02:00",
  "duration_minutes": 180,
  "capacity": 20,
  "available_capacity": 20,
  "is_available": true,
  "is_past": false,
  "is_today": false
}
```

**Key changes:**
- `id` removed (use `uuid`)
- `event_id` / `eventId` removed
- `slot_date` / `slotDate` removed (use `date`)
- All camelCase aliases removed (`startTime`, `endTime`, `startDatetime`, `endDatetime`, `startDate`, `endDate`, `durationMinutes`, `availableCapacity`, `isActive`, `isAvailable`, `isPast`, `isToday`, `isGenerated`, `recurrenceRuleId`, `bookBeforeMinutes`, `createdAt`, `updatedAt`)
- `source`, `recurrence_rule_id`, `is_generated`, `book_before_minutes`, `is_active`, `created_at`, `updated_at` removed (not needed for mobile display)

#### `ticket_types[]` — snake_case only

**Before:**
```json
{
  "id": "019d8c60-...",
  "uuid": "019d8c60-...",
  "event_id": 241,
  "eventId": 241,
  "priceType": "fixed",
  "price_type": "fixed",
  "formattedPrice": "10.00 EUR",
  "formatted_price": "10.00 EUR",
  ...40+ fields with camelCase duplicates...
}
```

**After:**
```json
{
  "uuid": "019d8c60-...",
  "name": "Standard Entry",
  "description": "Full access to the event",
  "price": 10,
  "price_type": "fixed",
  "currency": "EUR",
  "formatted_price": "10.00 EUR",
  "is_free": false,
  "min_per_order": 1,
  "max_per_order": 10,
  "is_available": true,
  "is_sold_out": false,
  "sort_order": 0
}
```

**Key changes:**
- `id` removed (use `uuid`)
- `event_id` / `eventId` removed
- All camelCase aliases removed
- Vendor-only fields removed (`sku`, `visibility`, `is_publicly_visible`, `slot_mode`, `slot_ids`, `quota_total`, `quota_sold`, `quota_pending`, `quota_remaining`, `available_quantity`, `sale_start_at`, `sale_end_at`, `is_on_sale`, `color`, `color_label`, `color_content`, `image_path`, `image_url`, `is_active`, `private_description`, `has_flexible_pricing`, `min_price`)

#### `categories[]` — minimal, snake_case only

**Before:**
```json
{
  "id": 23,
  "parent_id": 14,
  "name": "Festival",
  "description": "Long description...",
  "slug": "festival",
  "icon": "party-popper",
  "color": "#E74C3C",
  "image_url": "https://...",
  "imageUrl": "https://...",
  "meta_title": "...",
  "metaTitle": "...",
  ...20+ fields...
}
```

**After:**
```json
{
  "id": 23,
  "name": "Festival",
  "slug": "festival",
  "icon": "party-popper",
  "color": "#E74C3C",
  "is_primary": true,
  "parent": {
    "id": 14,
    "name": "Fêtes & Festivités",
    "slug": "fetes-festivites",
    "icon": "party-popper",
    "color": "#E74C3C"
  }
}
```

**Key changes:**
- SEO fields removed (`image_url`, `image_alt`, `image_title`, `meta_title`, `meta_description`, `long_description`)
- `parent_id` removed (parent object is included inline)
- `description` removed (not needed for mobile cards)
- All camelCase aliases removed
- `is_primary` added from pivot (tells you which category is the main one)

---

## Step 4: Detect Admin-Created Events

Use the `creation_source` field:

| Value | Meaning | Suggested UX |
|-------|---------|-------------|
| `vendor` | Created by the organizer | Default — no special badge |
| `crawler` | Scraped from external source | Show "Source: {original_organizer_name}" |
| `admin_manual` | Created by Le Hiboo admin | Show "Le Hiboo" badge or similar |

```dart
// Example
if (event.creationSource == 'admin_manual') {
  showLeHibooBadge();
} else if (event.creationSource == 'crawler' && event.originalOrganizerName != null) {
  showSourceBadge(event.originalOrganizerName);
}
```

---

## Step 5: Venue Services vs Event Services

Two distinct service concepts:

| Field | Source | What it represents |
|-------|--------|-------------------|
| `services` (root level) | Event model | What the **organizer** provides for this event |
| `venue.services` | Venue model | What the **physical location** offers |

Both may contain keys like `restauration`, `parking`, `wifi`, `vestiaire`, etc. The mobile app can merge them for display or show them separately.

```dart
// Merge both service maps for display
final allServices = {
  ...?event.services,
  ...?event.venue?.services,
};
```

---

## Full Response Example

```json
{
  "uuid": "019d8c60-4835-7376-9ddf-58b3218fab61",
  "slug": "piscine-party-1",
  "title": "Piscine Party",
  "description": "Full description...",
  "excerpt": "Fun is here",
  "featured_image": "https://storage.lehiboo.com/...",
  "gallery": [],
  "event_type": "offline",
  "calendar_mode": "manual",
  "timezone": "Europe/Paris",
  "booking_mode": "booking",
  "venue_name": "Stade Municipal",
  "venue_address": "12 Rue du Sport",
  "city": "Valenciennes",
  "postal_code": "59300",
  "country": "FR",
  "address_source": "venue",
  "venue_id": "019d8652-abcd-...",
  "location": {
    "name": "Stade Municipal",
    "address": "12 Rue du Sport",
    "city": "Valenciennes",
    "postal_code": "59300",
    "country": "FR",
    "lat": 50.3570,
    "lng": 3.5235
  },
  "start_date": "2026-04-24T00:00:00+02:00",
  "end_date": null,
  "dates": {
    "start_date": "2026-04-24",
    "end_date": "2026-04-24",
    "start_time": "14:00:00",
    "end_time": "17:00:00",
    "display": "vendredi 24 avril 2026",
    "duration_minutes": 180,
    "is_recurring": false
  },
  "price_from": 10,
  "is_free": false,
  "pricing": {
    "is_free": false,
    "min": 10,
    "max": 10,
    "currency": "EUR",
    "display": "10,00€"
  },
  "capacity_global": null,
  "availability": {
    "status": "available",
    "total_capacity": 20,
    "spots_remaining": 20,
    "percentage_filled": 0
  },
  "sale_start_at": null,
  "sale_end_at": null,
  "allow_cancellation": false,
  "cancel_before_hours": 24,
  "generate_qr_codes": true,
  "status": "published",
  "creation_source": "vendor",
  "original_organizer_name": null,
  "visibility": "public",
  "is_password_protected": false,
  "has_password": false,
  "published_at": "2026-04-14T16:39:33+02:00",
  "scheduled_publish_at": null,
  "is_featured": false,
  "is_active": true,
  "is_on_sale": true,
  "is_live": true,
  "can_accept_bookings": true,
  "can_accept_discovery": false,
  "is_discovery": false,
  "discovery_pricing_type": null,
  "external_ticketing_url": null,
  "services": {
    "restauration": true,
    "parking": true
  },
  "other_services": null,
  "entry_type_id": null,
  "entry_type": null,
  "event_tag_id": 19,
  "event_tag": { "id": 19, "name": "Sortie" },
  "venue_type": "indoor",
  "target_audiences": [
    { "id": 1, "name": "Familles", "slug": "familles" }
  ],
  "themes": [
    { "id": 4, "name": "Sport" }
  ],
  "special_events": [
    { "id": 2, "name": "Week-end" }
  ],
  "emotions": [
    { "id": 4, "name": "Adrénaline" }
  ],
  "organizer": {
    "uuid": "019d8652-64c8-70a4-823c-d37b9ee4c7f9",
    "name": "Bobo Corp",
    "slug": "bobo-corp",
    "logo": null,
    "type": null,
    "is_platform": false,
    "verified": false,
    "description": null,
    "events_count": 4,
    "followers_count": 0,
    "venue_types": ["Association"],
    "member_since": "2026-01-15T10:30:00+01:00",
    "allow_public_contact": true
  },
  "primary_category": {
    "id": 23,
    "name": "Festival",
    "slug": "festival",
    "icon": "party-popper",
    "color": "#E74C3C",
    "parent": {
      "id": 14,
      "name": "Fêtes & Festivités",
      "slug": "fetes-festivites",
      "icon": "party-popper",
      "color": "#E74C3C"
    }
  },
  "categories": [
    {
      "id": 23,
      "name": "Festival",
      "slug": "festival",
      "icon": "party-popper",
      "color": "#E74C3C",
      "is_primary": true,
      "parent": {
        "id": 14,
        "name": "Fêtes & Festivités",
        "slug": "fetes-festivites",
        "icon": "party-popper",
        "color": "#E74C3C"
      }
    }
  ],
  "slots": [
    {
      "uuid": "019d8c6e-ec70-73ce-a44a-e1d0232bd4be",
      "date": "2026-04-24",
      "start_time": "14:00:00",
      "end_time": "17:00:00",
      "start_datetime": "2026-04-24T14:00:00+02:00",
      "end_datetime": "2026-04-24T17:00:00+02:00",
      "duration_minutes": 180,
      "capacity": 20,
      "available_capacity": 20,
      "is_available": true,
      "is_past": false,
      "is_today": false
    }
  ],
  "ticket_types": [
    {
      "uuid": "019d8c60-4843-70c6-92cc-459d31ac3143",
      "name": "Standard Entry",
      "description": "Full access to the event",
      "price": 10,
      "price_type": "fixed",
      "currency": "EUR",
      "formatted_price": "10.00 EUR",
      "is_free": false,
      "min_per_order": 1,
      "max_per_order": 10,
      "is_available": true,
      "is_sold_out": false,
      "sort_order": 0
    }
  ],
  "venue": {
    "uuid": "019d8652-abcd-...",
    "name": "Stade Municipal",
    "slug": "stade-municipal",
    "services": {
      "parking": true,
      "wifi": true
    },
    "accessibility": {}
  },
  "extra_services": [],
  "indicative_prices": [
    {
      "uuid": "019db9b3-aea4-72b1-83ab-8c99b2863f5f",
      "label": "Polishing",
      "price": 5.00,
      "currency": "EUR",
      "sort_order": 0
    },
    {
      "uuid": "019db9b3-aea7-725a-8a34-97d10b3cbe01",
      "label": "Catering",
      "price": 10.00,
      "currency": "EUR",
      "sort_order": 1
    }
  ],
  "meta_title": null,
  "meta_description": null,
  "meta": null,
  "version": 2,
  "created_at": "2026-04-14T16:23:33+02:00",
  "updated_at": "2026-04-14T16:39:33+02:00"
}
```

---

## Rollback

If issues arise, simply remove the `X-Platform: mobile` header from the HTTP client. The API will revert to returning the old `EventResource` format. No backend changes needed.

---

## Migration Status

All event-returning endpoints now support `X-Platform: mobile`. The migration is complete.

**Note on `BookingResource`:** When `X-Platform: mobile` is set, the nested `event` and `slot` inside booking responses also use mobile resources (`MobileEventResource`, `MobileSlotResource`). The booking wrapper fields themselves are unchanged.