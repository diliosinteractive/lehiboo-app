# Tickets & Cancellation — Mobile Integration Spec

**Audience** : Mobile app (Flutter)
**Status** : Stable contract
**Companion spec** : `BOOKING_DETAIL_MOBILE_SPEC.md` (read first — this spec assumes the booking detail is already fetched and the mobile app knows its `status`, `tickets[]`, and `cancellation` block.)

This spec covers three actions a user performs on an existing booking:

1. **Download all tickets** as a single bundled PDF (recommended default).
2. **Download a single ticket** as a PDF.
3. **Cancel the booking** as the customer.

All three endpoints require `Authorization: Bearer <token>` and benefit from `X-Platform: mobile`.

---

## Part 1 — Bundle download (all tickets of a booking)

### 1.1 Endpoint

```
GET /api/v1/bookings/{booking_uuid}/tickets/download
```

Streams a single PDF containing every ticket of the booking. **Use this as the default** — one round trip, one file, no client-side concatenation.

### 1.2 Headers

```
GET /api/v1/bookings/{booking_uuid}/tickets/download HTTP/1.1
Host: api.lehiboo.com
Accept: application/pdf
Authorization: Bearer <token>
```

| Header | Required | Notes |
|---|---|---|
| `Authorization` | yes | |
| `Accept` | recommended | `application/pdf`. |

### 1.3 Path Param

| Param | Type | Resolution |
|---|---|---|
| `booking_uuid` | UUID | `Booking::getRouteKeyName() = 'uuid'`. |

### 1.4 Authorization

Enforced by `BookingPolicy::viewTickets()`, which delegates to `view()`. Allowed for: booking creator, guest booking with matching email, the event's vendor, collaborators with booking management permission, admins.

### 1.5 Success — `200 OK`

| Field | Value |
|---|---|
| `Content-Type` | `application/pdf` |
| `Content-Disposition` | `attachment; filename="billets-{booking_reference}.pdf"` (e.g. `billets-A1B2C3D4.pdf`) |
| Body | Binary PDF stream |

The filename uses `booking.reference` (the short human-readable code), not the UUID. Trust the `Content-Disposition` header rather than constructing a name client-side.

### 1.6 Errors

| Status | Cause | Body |
|---|---|---|
| `401` | Token missing/expired | `{"message":"Unauthenticated.","error":"unauthenticated"}` |
| `403` | Not allowed to view this booking | `{"message":"This action is unauthorized."}` |
| `404` | Booking UUID doesn't exist **or** booking exists but no tickets generated yet | `{"message":"No tickets found for this booking."}` |

> **Async generation gotcha** : tickets are created asynchronously after `BookingConfirmed` fires. A 404 immediately after payment confirmation means generation is still in flight. Mobile should not call this endpoint until `tickets[]` in the booking detail response is non-empty (see `BOOKING_DETAIL_MOBILE_SPEC.md` §4.3).

### 1.7 Sample call (Dio)

```dart
Future<File> downloadBookingTickets(String bookingUuid) async {
  final response = await dio.get<List<int>>(
    '/api/v1/bookings/$bookingUuid/tickets/download',
    options: Options(
      responseType: ResponseType.bytes,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/pdf',
      },
      validateStatus: (s) => s != null && s < 500,
    ),
  );

  if (response.statusCode == 200) {
    final filename = _extractFilename(response.headers)
        ?? 'billets-$bookingUuid.pdf';
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(response.data!);
    return file;
  }

  if (response.statusCode == 404) throw TicketsNotReadyException();
  if (response.statusCode == 403) throw NotAuthorizedException();
  throw UnknownException(response.statusCode);
}

String? _extractFilename(Headers headers) {
  final disposition = headers.value('content-disposition');
  if (disposition == null) return null;
  final match = RegExp(r'filename="([^"]+)"').firstMatch(disposition);
  return match?.group(1);
}
```

---

## Part 2 — Single ticket download

### 2.1 Endpoint

```
GET /api/v1/me/tickets/{ticket_uuid}/download
```

Use for "share this one ticket" or "re-download a transferred ticket" flows. The `/me/` prefix is the Flutter alias added explicitly for mobile (`routes/api.php:572`); a non-prefixed alias `GET /api/v1/tickets/{ticket_uuid}/download` exists with identical behavior.

### 2.2 Headers

Same as bundle download.

### 2.3 Path Param

| Param | Type | Resolution |
|---|---|---|
| `ticket_uuid` | UUID | `Ticket::getRouteKeyName() = 'uuid'`. Send `ticket.uuid` from the booking detail's `tickets[]` array. |

### 2.4 Authorization

Enforced by `TicketPolicy::download()`. Allowed for:

- The ticket owner (`booking.user_id == auth()->id()`)
- The transferee (`ticket.transferred_to_user_id == auth()->id()`)
- Admins

**Refused** when the ticket status is `cancelled` — even for the owner. Mobile must hide the per-ticket download button when `ticket.status == "cancelled"` to avoid the 403 surprise.

### 2.5 Success — `200 OK`

| Field | Value |
|---|---|
| `Content-Type` | `application/pdf` |
| `Content-Disposition` | `attachment; filename="{qr_code}.pdf"` (e.g. `TKT-7F3A9B.pdf`) |
| Body | Binary PDF stream |

### 2.6 Errors

| Status | Cause | Body |
|---|---|---|
| `401` | Token missing/expired | `{"message":"Unauthenticated.","error":"unauthenticated"}` |
| `403` | Not the ticket owner / transferee | `{"message":"Vous ne pouvez telecharger que vos propres billets."}` |
| `403` | Ticket status is `cancelled` | `{"message":"Ce billet a ete annule."}` |
| `404` | Ticket UUID doesn't exist | `{"message":"Resource not found.","error":"not_found"}` |
| `500` | PDF generation failed (logged server-side, rare) | `{"message":"PDF generation failed."}` |

---

## Part 3 — Customer cancellation

### 3.1 Endpoint

```
POST /api/v1/me/bookings/{booking_uuid}/cancel
```

The customer-facing cancel route. Vendor/admin cancellations use `POST /api/v1/bookings/{uuid}/cancel` (same controller method, same payload, but reachable without the `me/` prefix). For mobile, always use `/me/`.

### 3.2 Headers

```
POST /api/v1/me/bookings/{booking_uuid}/cancel HTTP/1.1
Host: api.lehiboo.com
Content-Type: application/json
Accept: application/json
Authorization: Bearer <token>
X-Platform: mobile
```

### 3.3 Path Param

| Param | Type | Resolution |
|---|---|---|
| `booking_uuid` | UUID | `Booking::getRouteKeyName() = 'uuid'`. |

### 3.4 Request body

```json
{
  "reason": "Empechement personnel",
  "notify_customer": true
}
```

| Field | Type | Required | Default | Notes |
|---|---|---|---|---|
| `reason` | string (max 1000) | optional | `""` | Free text shown to the vendor. Stored in `meta.cancellation_reason`. |
| `notify_customer` | boolean | optional | `true` | Whether to send a cancellation email. Mobile typically leaves this `true`. |

Empty body is accepted — `{}` is a valid cancellation request.

### 3.5 Authorization & business rules

Enforced by `BookingPolicy::cancel()`. The customer can self-cancel when **all** of these hold:

1. The user is the booking creator (or a guest booking with matching email).
2. **Either**: `booking.status == "pending"` (unpaid carts are always cancellable by the owner — bypasses event-level rules) **or**: the event allows cancellation (`event.allow_cancellation == true`) **and** now is before the cancellation deadline.
3. The booking status is otherwise cancellable (not already `cancelled` / `refunded` / `expired`).

The **deadline** is `slot.start_datetime - event.cancel_before_hours` (defaults to 24h if unset). It's exposed in the booking detail response as `cancellation.deadline` — mobile should pre-flight against `cancellation.canCancel` from the latest fetch and only call this endpoint when it's `true`.

### 3.6 Success — `200 OK`

```json
{
  "message": "Booking cancelled successfully.",
  "data": {
    "uuid": "...",
    "status": "cancelled",
    "cancelled_at": "2026-04-30T16:12:00+00:00",
    "cancellation_reason": "Empechement personnel",
    "cancellation": { "...": "..." },
    "...": "..."
  }
}
```

`data` is a full `BookingResource` — same shape as `GET /me/bookings/{uuid}`. Mobile can replace its in-memory booking with this response without re-fetching.

### 3.7 Errors

| Status | Cause | Body |
|---|---|---|
| `401` | Token missing/expired | `{"message":"Unauthenticated.","error":"unauthenticated"}` |
| `403` | Not the booking owner | `{"message":"Vous ne pouvez pas annuler cette reservation."}` |
| `403` | Event disallows cancellation | `{"message":"L'organisateur n'autorise pas les annulations pour cet evenement."}` |
| `403` | Past the cancellation deadline | `{"message":"L'annulation n'est plus possible moins de {N}h avant l'evenement."}` |
| `404` | Booking UUID doesn't exist | `{"message":"Resource not found.","error":"not_found"}` |
| `422` | `reason` exceeds 1000 chars | Standard Laravel validation envelope |

### 3.8 Side effects

After a successful cancellation:

- `booking.status` → `cancelled`, `cancelled_at` set
- All tickets on the booking transition to `cancelled` — single-ticket downloads will return 403 from now on
- The bundle download endpoint **still works** (returns whatever PDFs are generated), but the tickets inside are marked invalid
- If the booking was paid, refund handling is **not** automatic — the vendor or admin must trigger a refund via `POST /api/v1/bookings/{uuid}/refund` (vendor/admin only). Mobile should present a "Refund will be processed by the organizer" message rather than promise immediate refunds.
- `notify_customer = true` triggers `BookingCancelled` event → `SendBookingCancellationEmail` listener.

### 3.9 Sample call (Dio)

```dart
Future<BookingDetail> cancelBooking(String bookingUuid, {String? reason}) async {
  final response = await dio.post<Map<String, dynamic>>(
    '/api/v1/me/bookings/$bookingUuid/cancel',
    data: {
      if (reason != null && reason.isNotEmpty) 'reason': reason,
      'notify_customer': true,
    },
    options: Options(
      headers: {
        'Authorization': 'Bearer $token',
        'X-Platform': 'mobile',
        'Content-Type': 'application/json',
      },
    ),
  );

  final data = response.data!['data'] as Map<String, dynamic>;
  return BookingDetail.fromJson(data);
}
```

---

## 4. Mobile UX flow — full action lifecycle

Putting it all together, the mobile booking detail screen drives three buttons off a single `BookingDetail` object:

```
fetched = GET /me/bookings/{uuid} with X-Platform: mobile

UI state:
  - "Download tickets" button:
      shown when fetched.tickets is non-empty AND status == "confirmed"
      tap → GET /bookings/{uuid}/tickets/download (Part 1)

  - "Download single ticket" button (per ticket row):
      shown when ticket.status != "cancelled"
      tap → GET /me/tickets/{ticket_uuid}/download (Part 2)

  - "Cancel booking" button:
      shown when fetched.cancellation.canCancel == true
      tap → confirmation dialog → POST /me/bookings/{uuid}/cancel (Part 3)
              on success: replace local booking with response.data, no re-fetch needed
              on 403: re-fetch booking detail (deadline likely passed since last fetch)
```

Always re-fetch the booking detail on screen focus — `cancellation.canCancel` is time-sensitive and a stale `true` will produce a 403 surprise at action time.

---

## 5. Operational notes

| Concern | Note |
|---|---|
| **PDF size** | Bundle PDFs grow linearly (~80–150 KB per ticket). For 10-ticket bookings expect ~1 MB. Stream to disk; do not hold in memory. |
| **Caching PDFs** | Server regenerates the PDF on each request. Don't rely on `ETag`. Cache the bytes locally keyed on `booking.updated_at` or `ticket.updated_at`. |
| **Offline** | Download once on confirmation, cache locally, present from cache offline. The QR is verified server-side at scan time so a slightly stale local copy is fine. |
| **i18n of PDF content** | The PDF rendering itself is currently FR-only. If multi-locale PDFs are needed, file a backend request — not implemented yet. |
| **Refund flow** | Customer cancellation does **not** trigger an automatic refund. Surface a "the organizer will process your refund" message rather than promising immediate funds back. |
| **Cancellation idempotency** | Calling cancel twice on an already-cancelled booking returns 403 (status is no longer cancellable). Mobile should disable the button after the first 200. |
