# Migration Guide — Birth Date & Town on Bookings

## What changed

Two new optional fields have been added to the booking creation endpoint:

| Field | DB column | Type | Validation | Required |
|---|---|---|---|---|
| `customer_birth_date` | `bookings.customer_birth_date` | DATE | Valid date, must be before today | No |
| `customer_town` | `bookings.customer_town` | VARCHAR(255) | String, max 255 chars | No |

**Backend PR scope**: migration, model, form request, service, resource. No web frontend changes.

---

## API changes

### Request — `POST /api/v1/bookings`

Two new optional body fields:

```json
{
  "event_id": "uuid-or-int",
  "slot_id": "uuid-or-int",
  "items": [ ... ],
  "customer_email": "jane@example.com",
  "customer_first_name": "Jane",
  "customer_last_name": "Doe",
  "customer_phone": "0612345678",
  "customer_birth_date": "1990-05-15",
  "customer_town": "Valenciennes",
  "promo_code": null,
  "accept_terms": true
}
```

**Format**: `customer_birth_date` must be a valid date string in any format PHP `strtotime` can parse, but we recommend **`YYYY-MM-DD`** (ISO 8601 date). The backend casts it to a DATE column.

**Validation rules**:
- `customer_birth_date`: must be a date **before today** (rejects future dates and today)
- `customer_town`: max 255 characters

**Backward compatible**: Omitting either field is fine — they default to `null`. Existing integrations are not affected.

### Response — BookingResource

New fields appear in every endpoint that returns a `BookingResource`:
- `POST /api/v1/bookings` (creation)
- `GET /api/v1/me/bookings` (list)
- `GET /api/v1/me/bookings/{uuid}` (detail)
- `GET /api/v1/bookings/{uuid}` (detail)
- `GET /api/v1/public/bookings/{uuid}` (public confirmation page)

**New top-level fields**:

```json
{
  "customer_birth_date": "1990-05-15",
  "customerBirthDate": "1990-05-15",
  "customer_town": "Valenciennes",
  "customerTown": "Valenciennes"
}
```

**New fields inside the `customer` nested object**:

```json
{
  "customer": {
    "name": "Jane Doe",
    "email": "jane@example.com",
    "phone": "0612345678",
    "birth_date": "1990-05-15",
    "town": "Valenciennes",
    "is_guest": false
  }
}
```

All new fields return `null` when not provided.

---

## Prefilling from user profile

The user profile already has `birth_date` and `membership_city`. Use these to prefill the booking form.

**Source endpoint**: `GET /api/v1/auth/me` (or wherever you fetch the current user)

**Mapping**:

| User profile field | Booking field | Notes |
|---|---|---|
| `birth_date` (string `YYYY-MM-DD` or null) | `customer_birth_date` | Direct copy |
| `membership_city` (string or null) | `customer_town` | Direct copy |

**Dart prefill logic**:

```dart
// When building the booking request, prefill from user profile
final user = authStore.currentUser;

final bookingData = {
  'event_id': event.uuid,
  'slot_id': selectedSlot.uuid,
  'items': items,
  'customer_email': user.email,
  'customer_first_name': user.firstName,
  'customer_last_name': user.lastName,
  'customer_phone': user.phone,
  // Prefill from profile — user can override in the form
  if (user.birthDate != null) 'customer_birth_date': user.birthDate,
  if (user.membershipCity != null) 'customer_town': user.membershipCity,
  'accept_terms': true,
};
```

---

## UI implementation — Age display

The backend stores `birth_date` (immutable record), but the UI should display **age** to the user. Computing age from birth_date is a client-side concern.

### Age computation (Dart)

```dart
int? computeAge(String? birthDateStr) {
  if (birthDateStr == null) return null;
  final birthDate = DateTime.parse(birthDateStr);
  final today = DateTime.now();
  int age = today.year - birthDate.year;
  if (today.month < birthDate.month ||
      (today.month == birthDate.month && today.day < birthDate.day)) {
    age--;
  }
  return age;
}
```

### Recommended form UX

The booking form should show **two fields** in an optional section:

```text
┌─────────────────────────────────────────────┐
│  Informations complementaires (optionnel)   │
│                                             │
│  Age        [ 34 ]  ← computed, editable    │
│                       as a number input      │
│                                             │
│  Ville      [ Valenciennes ]                │
│                                             │
└─────────────────────────────────────────────┘
```

**Age input behavior**:

1. **Prefill**: If `user.birthDate` exists, compute age and display it. The underlying `customer_birth_date` value is the profile's `birth_date`.
2. **User edits age**: When the user changes the age number, convert it back to an approximate birth_date for the API:
   ```dart
   String ageToBirthDate(int age) {
     final now = DateTime.now();
     // Use Jan 1 as default when only age is known
     final approx = DateTime(now.year - age, 1, 1);
     return approx.toIso8601String().substring(0, 10); // "YYYY-01-01"
   }
   ```
3. **No profile birth_date, no input**: Send neither field (omit from request body).

**Town input behavior**:

1. **Prefill**: Use `user.membershipCity` if available
2. **User edits**: Free text input, no autocomplete required
3. **Empty**: Omit from request body

---

## Dart DTO update

Add the new fields to your `CreateBookingRequest` (or equivalent) DTO:

```dart
class CreateBookingRequest {
  final String eventId;
  final String slotId;
  final List<BookingItem> items;
  final String customerEmail;
  final String customerFirstName;
  final String customerLastName;
  final String? customerPhone;
  final String? customerBirthDate;  // NEW — "YYYY-MM-DD"
  final String? customerTown;       // NEW
  final String? promoCode;
  final bool acceptTerms;

  Map<String, dynamic> toJson() => {
    'event_id': eventId,
    'slot_id': slotId,
    'items': items.map((i) => i.toJson()).toList(),
    'customer_email': customerEmail,
    'customer_first_name': customerFirstName,
    'customer_last_name': customerLastName,
    if (customerPhone != null) 'customer_phone': customerPhone,
    if (customerBirthDate != null) 'customer_birth_date': customerBirthDate,
    if (customerTown != null) 'customer_town': customerTown,
    if (promoCode != null) 'promo_code': promoCode,
    'accept_terms': acceptTerms,
  };
}
```

Update your `Booking` response DTO to parse the new fields:

```dart
class Booking {
  // ... existing fields ...
  final String? customerBirthDate;  // NEW — "YYYY-MM-DD" or null
  final String? customerTown;       // NEW — string or null

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    // ... existing parsing ...
    customerBirthDate: json['customer_birth_date'] as String?,
    customerTown: json['customer_town'] as String?,
  );

  /// Computed age from birth date, or null if not set
  int? get customerAge => computeAge(customerBirthDate);
}
```

---

## Displaying age on booking detail / tickets

On the booking confirmation screen or ticket detail, show the age if available:

```dart
if (booking.customerAge != null) {
  Text('${booking.customerAge} ans');
}
if (booking.customerTown != null) {
  Text(booking.customerTown!);
}
```

On the "My bookings" list, these fields are informational — no action needed unless you want to show them as badges or chips.

---

## Validation errors

If the mobile sends invalid data, the backend returns `422`:

**Birth date in the future**:
```json
{
  "message": "The given data was invalid.",
  "errors": {
    "customer_birth_date": ["The customer birth date field must be a date before today."]
  }
}
```

**Town too long (>255 chars)**:
```json
{
  "message": "The given data was invalid.",
  "errors": {
    "customer_town": ["The customer town field must not be greater than 255 characters."]
  }
}
```

---

## Test plan

### Happy path

1. Create a booking **without** `customer_birth_date` and `customer_town` → succeeds, both fields are `null` in response
2. Create a booking **with** both fields → succeeds, fields appear in response
3. Create a booking with only `customer_birth_date` → succeeds
4. Create a booking with only `customer_town` → succeeds

### Prefill

5. User with `birth_date` and `membership_city` in profile → form shows computed age and city
6. User without profile data → fields are empty, not prefilled
7. User edits prefilled age → `customer_birth_date` updates to approximate date

### Validation

8. Send `customer_birth_date: "2030-01-01"` (future) → `422`
9. Send `customer_birth_date: "not-a-date"` → `422`
10. Send `customer_town` with 300 characters → `422`
11. Send `customer_birth_date: "2026-04-24"` (today) → `422` (rule is `before:today`, not `before_or_equal`)

### Response parsing

12. `GET /api/v1/me/bookings/{uuid}` on a booking with both fields → parse correctly
13. `GET /api/v1/me/bookings/{uuid}` on an old booking (before migration) → both fields are `null`, no crash

---

## Timeline

| Step | Owner | Dependency |
|---|---|---|
| Run migration (`php artisan migrate`) | Backend | Merge of backend PR |
| Update Dart DTOs (request + response) | Mobile | None |
| Add age + town fields to booking form | Mobile | DTOs updated |
| Prefill from user profile | Mobile | DTOs updated |
| Test end-to-end | Mobile | Migration deployed |

No breaking changes. The mobile team can ship this incrementally — DTOs first, then UI.
