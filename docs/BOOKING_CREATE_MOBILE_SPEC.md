# Booking Creation — Mobile Integration Spec

**Endpoint** : `POST /api/v1/bookings`
**Audience** : Mobile app (Flutter)
**Status** : Legacy single-event contract

This specification defines the strict contract between the mobile app and the booking creation endpoint. The backend accepts looser payloads for backward compatibility, but the mobile app MUST follow this spec.

For the current multi-event / multi-vendor cart flow, use `docs/MOBILE_ORDER_CART_CHECKOUT.md` and the `Order` endpoints instead of extending this direct `Booking` flow.

---

## 1. Contract Summary

| Concept | Cardinality | Notes |
|---|---|---|
| **Buyer** (`customer_*`) | exactly **1** per request | The payer; receives the confirmation email |
| **Items** (`items[]`) | **1..N** | One entry per distinct `TicketType` selected |
| **Quantity** per item | **1..50** | Number of tickets of this type |
| **Participants** per item | **MUST equal `quantity`** | One participant per ticket — strict |

**Golden rule** : `sum(items[].quantity) === sum(items[].attendees[].length)`. The mobile app MUST validate this before sending the request.

---

## 2. Headers

```
POST /api/v1/bookings HTTP/1.1
Host: api.lehiboo.com
Content-Type: application/json
Accept: application/json
Accept-Language: fr           # or en, es, de, nl, ar
Authorization: Bearer <token> # optional — guests allowed
X-Platform: mobile            # set by mobile client
```

Authentication is **optional**. When the user is logged in, the buyer fields are auto-filled from the user profile if not provided.

---

## 3. Request Body

### 3.1 Schema

```json
{
  "event_id": "string (UUID, required)",
  "slot_id":  "string (UUID, required)",

  "items": [
    {
      "ticket_type_id": "string (UUID, required)",
      "quantity":       "integer (1..50, required)",
      "attendees": [
        {
          "first_name":      "string (required)",
          "last_name":       "string (optional)",
          "relationship":    "string (required)",
          "email":           "string (email, optional)",
          "phone":           "string (optional)",
          "birth_date":      "string (YYYY-MM-DD, required)",
          "age":             "integer (0..120, optional)",
          "city":            "string (optional)",
          "membership_city": "string (required)"
        }
      ]
    }
  ],

  "customer_email":      "string (email, required)",
  "customer_first_name": "string (required)",
  "customer_last_name":  "string (required)",
  "customer_phone":      "string (optional)",
  "customer_address":    "string (optional)",
  "customer_birth_date": "string (YYYY-MM-DD, optional, before today)",
  "customer_town":       "string (optional)",

  "promo_code":          "string (optional)",
  "payment_method":      "string (card | free, optional)",
  "accept_terms":        "boolean (optional)",
  "accept_newsletter":   "boolean (optional)",
  "checkout_fields":     "object (optional)",
  "meta":                "object (optional)"
}
```

### 3.2 Field reference

#### Event & slot

| Field | Type | Required | Description |
|---|---|:---:|---|
| `event_id` | UUID | yes | Event UUID. Integer IDs accepted but UUIDs are required from mobile. |
| `slot_id`  | UUID | yes | Time slot UUID. Must belong to `event_id` and not be in the past. |

#### Items

| Field | Type | Required | Description |
|---|---|:---:|---|
| `items[].ticket_type_id` | UUID | yes | Must belong to `event_id`, be active, in stock |
| `items[].quantity`       | int 1..50 | yes | Subject to `ticket_type.min_per_order` / `max_per_order` |
| `items[].attendees`      | array | **yes (mobile)** | MUST contain exactly `quantity` entries |

#### Participant (attendee)

A participant represents **one ticket holder**. The mobile MUST send one entry per ticket.

| Field | Type | Required | Notes |
|---|---|:---:|---|
| `first_name` | string ≤255 | **yes** | |
| `last_name`  | string ≤255 | no | |
| `relationship` | enum | **yes** | `self`, `child`, `spouse`, `family`, `friend`, `other` |
| `email`      | email ≤255 | no | Recommended for ticket transfer / per-attendee notifications |
| `phone`      | string ≤30 | no | |
| `birth_date` | date `YYYY-MM-DD` | **yes** | Required for personalization and age-aware recommendations |
| `age`        | int 0..120 | conditional | Alternative to `birth_date` when only age band matters |
| `city`       | string ≤120 | no | |
| `membership_city` | string ≤120 | **yes** | For personalization and city-based loyalty programs |

**Mobile-side rule** : the checkout MUST collect `first_name`, `relationship`, `birth_date`, and `membership_city` for every ticket participant. `last_name`, `email`, and `phone` are optional for the ticket participant.

#### Buyer (customer)

The buyer is the single payer for the booking. There is **always exactly one buyer**, even if they are also a participant.

| Field | Type | Required | Description |
|---|---|:---:|---|
| `customer_email`       | email | yes | Recipient of confirmation + ticket emails |
| `customer_first_name`  | string | yes | |
| `customer_last_name`   | string | yes | |
| `customer_phone`       | string ≤20 | no | |
| `customer_address`     | string ≤2000 | no | |
| `customer_birth_date`  | date | no | Must be before today |
| `customer_town`        | string ≤255 | no | |

If the buyer is also a participant, the mobile MUST still include them in the relevant `items[].attendees[]` array. Buyer ≠ participant in the data model.

#### Optional fields

| Field | Type | Description |
|---|---|---|
| `promo_code` | string | Validated against the event |
| `payment_method` | `card` \| `free` | Hint for the next step; not enforcing |
| `accept_terms` | bool | Should be `true` to comply with ToS — UI responsibility |
| `accept_newsletter` | bool | Opt-in flag |
| `checkout_fields` | object | Free-form custom fields configured per event |
| `meta` | object | Free-form metadata stored on the booking |

---

## 4. UI Requirements

The booking screen MUST render **one participant form per ticket**. The number of forms is derived from the total quantity selected — the user cannot proceed without filling one form for each ticket.

### 4.1 Rule

```
Total participant forms displayed === Σ items[].quantity
```

If the user selects **2 adult tickets + 1 child ticket**, the UI MUST render **3 participant forms** (2 under "Adult", 1 under "Child").

### 4.2 Behaviour

| Trigger | UI behaviour |
|---|---|
| User increments ticket quantity | Append a new participant form for that ticket type |
| User decrements ticket quantity | Remove the **last** form for that ticket type (after a confirmation prompt if it contains data) |
| User changes ticket type | Re-render forms grouped by type, preserving entered data when possible |
| User taps "Continue" with empty forms | Block submit; highlight the first incomplete form |

### 4.3 Form layout recommendations

- **Group forms by ticket type** with a section header (e.g. "Adult ticket — Participant 1 / 2").
- **Number each participant** clearly (`Participant 1`, `Participant 2`, …) so users know how many remain to fill.
- **Pre-fill the first participant** with the buyer's data when the buyer is also attending — but allow the user to edit or clear it.
- **Required fields** (`first_name`, `relationship`, `birth_date`, `membership_city`) marked visibly; show inline validation as the user types.
- Explain that these participant fields help personalize Le Hiboo, IA recommendations, offers, and event suggestions.
- **Persist forms across navigation** within the booking flow (e.g. when going back to change the slot, do not lose participant data).
- **Disable the submit button** until every participant form is valid AND `attendees.length === quantity` for every item.

### 4.4 Buyer vs participant in the UI

Even when the buyer is the only attendee, the UI MUST present **a participant form** in addition to the buyer fields (which appear in a separate "Contact details" section). The two are visually distinct but may share data through a "Same as buyer" toggle on the first participant form for convenience.

---

## 5. Mobile-Side Validation (Pre-Submit)

The mobile app MUST run these checks **before** calling the API:

1. **Required fields present** — `event_id`, `slot_id`, at least one item, buyer fields.
2. **Participants match quantity** for every item :
   ```dart
   for (final item in items) {
     assert(item.attendees.length == item.quantity,
       'Each ticket must have exactly one participant');
   }
   ```
3. **Buyer email is valid** RFC 5322.
4. **Each participant has `first_name`, `relationship`, `birth_date`, and `membership_city`** non-empty.
5. **Total quantity ≤ slot capacity** (use cached slot data).
6. **Date constraints** : if the event collects `birth_date` / `age`, ensure the field is filled for every participant.
7. **No duplicate participants** within the same booking (recommended UX check, not enforced server-side).

The "one participant per ticket" rule is a **mobile contract**. The server allows a looser payload for legacy clients, but the mobile app MUST enforce strict 1-to-1.

---

## 6. Example Requests

### 5.1 Single buyer, 3 tickets of one type (3 distinct people)

```json
{
  "event_id": "a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d",
  "slot_id":  "b2c3d4e5-f6a7-4b8c-9d0e-1f2a3b4c5d6e",

  "customer_email":      "alice@example.com",
  "customer_first_name": "Alice",
  "customer_last_name":  "Martin",
  "customer_phone":      "+33612345678",

  "items": [
    {
      "ticket_type_id": "c3d4e5f6-a7b8-4c9d-0e1f-2a3b4c5d6e7f",
      "quantity": 3,
      "attendees": [
        {
          "first_name": "Alice",
          "last_name":  "Martin",
          "email":      "alice@example.com",
          "birth_date": "1991-04-12"
        },
        {
          "first_name": "Bob",
          "last_name":  "Dupont",
          "email":      "bob@example.com",
          "birth_date": "1995-09-03"
        },
        {
          "first_name": "Claire",
          "last_name":  "Rey",
          "birth_date": "1992-11-22"
        }
      ]
    }
  ]
}
```

### 5.2 Mixed types (2 adults + 1 child)

```json
{
  "event_id": "a1b2c3d4-...",
  "slot_id":  "b2c3d4e5-...",

  "customer_email":      "alice@example.com",
  "customer_first_name": "Alice",
  "customer_last_name":  "Martin",

  "items": [
    {
      "ticket_type_id": "tt-adult-uuid",
      "quantity": 2,
      "attendees": [
        { "first_name": "Alice", "last_name": "Martin", "birth_date": "1991-04-12" },
        { "first_name": "Bob",   "last_name": "Dupont", "birth_date": "1990-07-19" }
      ]
    },
    {
      "ticket_type_id": "tt-child-uuid",
      "quantity": 1,
      "attendees": [
        { "first_name": "Léa", "last_name": "Martin", "age": 7 }
      ]
    }
  ]
}
```

### 5.3 Solo booking (buyer is the only participant)

```json
{
  "event_id": "a1b2c3d4-...",
  "slot_id":  "b2c3d4e5-...",

  "customer_email":      "alice@example.com",
  "customer_first_name": "Alice",
  "customer_last_name":  "Martin",

  "items": [
    {
      "ticket_type_id": "tt-adult-uuid",
      "quantity": 1,
      "attendees": [
        { "first_name": "Alice", "last_name": "Martin", "email": "alice@example.com" }
      ]
    }
  ]
}
```

Even when the buyer is the only attendee, repeat the data in `attendees[]`.

---

## 7. Successful Response

**HTTP** : `201 Created`

```json
{
  "message": "Booking created successfully.",
  "data": {
    "uuid": "f9a8b7c6-d5e4-4f3a-9b2c-1d0e8f7a6b5c",
    "reference": "LH-A1B2C3",
    "status": "pending",
    "payment_status": "pending",
    "expires_at": "2026-04-27T15:32:00+00:00",
    "subtotal": 90.00,
    "discount_amount": 0.00,
    "tax_amount": 0.00,
    "total_amount": 90.00,
    "currency": "EUR",
    "event": { "uuid": "...", "title": "...", "slug": "..." },
    "slot":  { "uuid": "...", "slot_date": "2026-05-12", "start_time": "20:00:00" },
    "items": [
      {
        "uuid": "...",
        "ticket_type": { "uuid": "...", "name": "Adulte", "price": 30.00 },
        "quantity": 3,
        "unit_price": 30.00,
        "total_price": 90.00,
        "attendee_details": [ /* echo of attendees */ ]
      }
    ]
  }
}
```

### Key fields to consume

| Field | Use |
|---|---|
| `data.uuid` | Used in subsequent calls (`/payment-intent`, `/confirm`, `/cancel`) |
| `data.reference` | Short human-readable code to display (e.g. `LH-A1B2C3`) |
| `data.status` | Always `pending` after creation |
| `data.expires_at` | Show countdown to user; after this, booking expires |
| `data.total_amount` | If `0.00` → call `/confirm-free`. Otherwise → call `/payment-intent` |

---

## 8. Error Responses

### 8.1 Validation errors — `422 Unprocessable Entity`

```json
{
  "message": "The given data was invalid.",
  "errors": {
    "items.0.quantity": [
      "Maximum quantity for this ticket is 4."
    ],
    "customer_email": [
      "Email is required."
    ]
  }
}
```

The mobile app SHOULD map `errors` keys to form fields and surface inline messages.

### 8.2 Common error codes

| Status | Cause | Mobile action |
|---|---|---|
| `422` | Validation failure (missing field, invalid format, quantity rules) | Show field-level errors |
| `422` | `slot_id` already passed / inactive | Refresh slot list, ask user to pick again |
| `422` | Quota insufficient (`Not enough tickets available. Available: N`) | Show available count, let user adjust |
| `422` | Promo code invalid / expired / limit reached | Clear field, show specific message |
| `402` | Subscription limit reached (organization) | Generic "booking unavailable" message |
| `401` | Token expired (when authenticated) | Refresh token and retry |
| `500` | Server error | Retry once with idempotency, then show generic error |

### 8.3 Slot capacity error

```json
{
  "errors": {
    "items": ["Not enough availability for this slot. Capacity: 8"]
  }
}
```

The mobile MUST refetch the slot before retrying — capacity may have shrunk due to concurrent bookings.

---

## 9. Post-Creation Flow

After a successful `201`, follow the existing flow documented in `BOOKING_API_MOBILE.md` :

```
total_amount == 0  →  POST /v1/bookings/{uuid}/confirm-free
total_amount  > 0  →  POST /v1/bookings/{uuid}/payment-intent
                      → Stripe SDK (confirmPayment)
                      → POST /v1/bookings/{uuid}/confirm-payment
```

The booking expires after **30 minutes** if no payment is confirmed. The mobile SHOULD display a countdown using `data.expires_at` and abort the flow when it elapses.

---

## 10. Idempotency & Retries

The endpoint is **not idempotent**. Retrying a successful request creates a **second booking**.

The mobile MUST:

1. **Disable the submit button** during the request.
2. **Treat network timeouts** as ambiguous : on retry, first call `GET /v1/me/bookings?status=pending` to check whether a booking was already created with the same parameters before submitting again.
3. **Cancel orphan bookings** : if the user abandons the flow after creation but before payment, the mobile MAY call `POST /v1/bookings/{uuid}/cancel` to release quotas immediately rather than waiting for the 30-minute expiration.

---

## 11. Privacy & RGPD

- **Participant data** is stored as JSON on `BookingItem.attendee_details`.
- The mobile MUST display a clear consent screen before collecting third-party participant info (when buyer ≠ participant).
- Users can request deletion of their bookings via the existing RGPD endpoints — participant data is purged with the booking.
- Do **not** log full participant payloads in mobile telemetry.

---

## 12. Versioning & Backward Compatibility

- This spec is the **mobile contract** as of 2026-04-27.
- The backend accepts an alternative `participants[]` flat array (legacy mobile builds). New mobile builds MUST use the nested `items[].attendees[]` form documented here.
- Field additions are backward compatible — unknown fields in the response should be ignored.
- Field removals or semantic changes will be announced and gated by an `Accept-Version` header.

---

## 13. Quick Checklist for the Mobile Team

Before sending `POST /api/v1/bookings`, verify :

- [ ] `event_id` and `slot_id` are UUIDs and freshly fetched.
- [ ] At least one `items[]` entry.
- [ ] **One participant form rendered per ticket** (total forms = Σ quantities).
- [ ] `attendees.length === quantity` for every item.
- [ ] Every participant has `first_name` and `last_name`.
- [ ] Buyer fields (`customer_email`, `customer_first_name`, `customer_last_name`) are populated.
- [ ] If the event requires `birth_date` or `age`, every participant has it.
- [ ] Submit button is disabled during the request.
- [ ] Countdown to `data.expires_at` is shown after creation.
- [ ] Errors (`422`) are mapped to form fields.

---

## 14. Related Documentation

- `docs/03-guides/BOOKING_API_MOBILE.md` — Full booking flow (payment, tickets retrieval)
- `docs/03-guides/RESERVATION_WORKFLOW.md` — Status lifecycle, cancellation, refund
- `docs/03-guides/BOOKING_MODES.md` — Event modes (booking, participation, showcase)
- `docs/MOBILE_BOOKING_BIRTH_DATE_TOWN_MIGRATION.md` — `customer_birth_date` / `customer_town` rollout notes
