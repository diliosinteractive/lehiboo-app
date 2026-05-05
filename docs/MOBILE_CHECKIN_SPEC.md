# Vendor Ticket Check-in — Mobile Integration Spec

**Audience** : Mobile app (Flutter — vendor side)
**Status** : Stable contract
**Scope** : Vendor scans a ticket QR code at the gate, visually confirms the attendee, and marks the ticket as consumed.

The mobile flow is **two-step**: peek (read-only) → commit (state change). Clients SHOULD use peek before commit so a vendor can abort if the attendee identity looks off.

## TL;DR — Quick start

For a developer who just wants the four endpoints they'll call:

| Step | Endpoint | When |
|---|---|---|
| Sign in | `POST /api/v1/auth/login` | App launch / token expired (returns Sanctum token). |
| Pick org | `GET /api/v1/me/memberships` | Vendor belongs to >1 organization → set `X-Organization-Id`. |
| Peek | `POST /api/v1/vendor/tickets/scan/peek` | Every QR scan, read-only. |
| Commit | `POST /api/v1/vendor/tickets/{ticket_uuid}/check-in` | After visual confirm. |

All check-in calls require `Authorization: Bearer <token>` + `X-Organization-Id: <org_uuid>`.

---

## 1. Flow overview

```
Vendor opens "Scan tickets" screen
  ─→ optional: pick an event filter (event_id) — restricts scans to one event
  ─→ camera reads QR  →  qr_data = "<code>:<secret>"

  ─→ POST /v1/vendor/tickets/scan/peek                       (no state change)
       returns ticket info + can_check_in / would_be_re_entry / blocking_reason

  ─→ UI renders one of:
       ✅ Green   "Valid — first entry"        can_check_in=true,  would_be_re_entry=false
       ⚠️ Amber   "Re-entry — already in N×"   can_check_in=true,  would_be_re_entry=true
       ❌ Red     "{blocking_reason}"          can_check_in=false

  ─→ vendor taps "Confirm entry" (or "Confirm re-entry")
  ─→ POST /v1/vendor/tickets/{ticket_uuid}/check-in
       returns action="check_in" or "re_entry" + check_in_count
```

Re-entry is allowed by default. Each scan increments `check_in_count` and writes a row to the audit log (`checkin_log`).

---

## 2. Endpoints

All routes live under the vendor group. **Auth**: `Authorization: Bearer <user_token>` + `X-Organization-Id: <org_uuid>`.

| # | Verb | Path | Purpose |
|---|---|---|---|
| 1 | `POST` | `/api/v1/vendor/tickets/scan/peek` | Decode QR + return ticket info. No state change. |
| 2 | `POST` | `/api/v1/vendor/tickets/{ticket_uuid}/check-in` | Commit a check-in (or re-entry). |
| 3 | `POST` | `/api/v1/vendor/tickets/scan` | One-tap fallback: decode + commit in one call. Same metadata. |

---

## 3. Endpoint 1 — Peek (read-only)

```
POST /api/v1/vendor/tickets/scan/peek
```

### Request

```json
{
  "qr_data": "ABC123XYZ:k2j4hf...",   // preferred, "code:secret"
  "qr_code": "ABC123XYZ",             // fallback, raw code (manual entry)
  "event_id": 42                      // optional — rejects tickets for other events
}
```

Either `qr_data` or `qr_code` is required.

### 200 response

```json
{
  "success": true,
  "data": {
    "ticket": {
      "uuid": "9f2a-...",
      "status": "active",
      "attendee_first_name": "Lucas",
      "attendee_last_name": "Martin",
      "ticket_type": { "name": "Adulte" },
      "event": { "title": "Tournoi de tennis" },
      "slot": { "start_datetime": "2026-05-12T18:00:00+02:00" },
      "check_in_count": 0,
      "...": "see TicketResource"
    },
    "can_check_in": true,
    "would_be_re_entry": false,
    "blocking_reason": null,
    "slot_check": {
      "slot_start": "2026-05-12T18:00:00+02:00",
      "tolerance_minutes": 60,
      "is_within_window": true
    }
  }
}
```

`blocking_reason` is one of `null` / `ticket_cancelled` / `ticket_refunded` / `ticket_transferred` / `slot_not_started`. When non-null, render the red state and disable the confirm CTA.

### Error responses

| HTTP | `error` | Meaning |
|---|---|---|
| 404 | `ticket_not_found` | QR didn't resolve. Show "QR not recognized — try again or enter the code manually." |
| 422 | `wrong_event` | `event_id` was supplied but ticket is for another event. |
| 403 | `unauthorized` | The signed-in vendor is not allowed to check this ticket (wrong org). |

Note: peek does **not** write to `checkin_log` — that's why it's safe to call freely (e.g. on every camera frame stabilization).

---

## 4. Endpoint 2 — Commit check-in / re-entry

```
POST /api/v1/vendor/tickets/{ticket_uuid}/check-in
```

`{ticket_uuid}` is the value returned in `data.ticket.uuid` from peek.

### Request

```json
{
  "device_id": "iPad-042",                  // optional, persisted on checkin_log
  "device_name": "iPad Gate Nord",          // optional, persisted on checkin_log
  "gate": "Nord",                           // optional, free-text label
  "scan_method": "qr_code"                  // optional, one of: qr_code|manual|nfc|barcode (default qr_code)
}
```

All four fields are optional but recommended — they show up in the admin audit dashboard.

### 200 response — first entry

```json
{
  "success": true,
  "message": "Ticket checked in successfully.",
  "data": {
    "ticket": { "...TicketResource..." },
    "action": "check_in",
    "check_in_count": 1
  }
}
```

### 200 response — re-entry

```json
{
  "success": true,
  "message": "Re-entry recorded.",
  "data": {
    "ticket": { "...TicketResource..." },
    "action": "re_entry",
    "check_in_count": 2
  }
}
```

The `action` field is the canonical signal — clients SHOULD branch on `data.action`, not on the message text.

### Error responses

| HTTP | `error` | Meaning | UI hint |
|---|---|---|---|
| 404 | `ticket_not_found` | Ticket UUID doesn't exist. | "Ticket not found — re-scan." |
| 422 | `ticket_cancelled` | Status = Cancelled. | "Cancelled — DO NOT ADMIT." |
| 422 | `ticket_refunded` | Status = Refunded. | "Refunded — DO NOT ADMIT." |
| 422 | `ticket_transferred` | Status = Transferred. | "Transferred to another holder — re-scan their QR." |
| 422 | `slot_not_started` | Slot start is more than `tolerance_minutes` away. Response includes `data.slot_start`. | "Doors open at HH:MM." |
| 403 | `unauthorized` | Policy denies the action. | "You can't check in tickets from this organisation." |

Every non-200 response triggers a `checkin_log` row with `success=false`, `action=denied`, and `failure_reason=<error code>` for the admin audit trail.

---

## 5. Endpoint 3 — One-tap scan (fallback)

```
POST /api/v1/vendor/tickets/scan
```

Decodes the QR and commits in a single call. Body merges Peek's input (`qr_data`/`qr_code`/`event_id`) with Commit's metadata (`device_id`, `device_name`, `gate`, `scan_method`).

Use this only when the two-step UX isn't appropriate (e.g. high-volume turnstile mode where vendors don't visually verify ID). The two-step flow is the recommended default.

---

## 6. Headers

| Header | When | Notes |
|---|---|---|
| `Authorization: Bearer <token>` | always | User token from login. |
| `X-Organization-Id: <uuid>` | always | Active vendor organization. The check-in policy validates the ticket's event belongs to this org. |
| `Content-Type: application/json` | always | |

---

## 7. QR format

Tickets carry two values — `qr_code` (12-char shortcode) and `qr_secret` (64-char). The encoded QR string is:

```
{qr_code}:{qr_secret}
```

Mobile clients decode the QR image, get the `code:secret` string, and pass it as `qr_data`. If the QR is damaged and the vendor types the shortcode by hand, send `qr_code` instead — but be aware that `qr_code`-only lookups don't verify the secret, so they're meant for fallback flows where the vendor has an additional ID check.

---

## 8. Re-entry policy

Re-entry is allowed globally. The semantics:

- The ticket status stays `checked_in` after the first scan; subsequent scans just increment counters.
- `check_in_count` starts at 0, becomes 1 on the first check-in, increments by 1 on every re-entry.
- `last_check_in_at` updates on every scan (first or re-entry).
- The mobile UI SHOULD warn at re-entry — show how many entries have already been recorded so the vendor can decide whether to admit again.

---

## 9. Slot timing

A ticket can be checked in from `slot_start - tolerance_minutes` onwards. The default `tolerance_minutes` is **60**, configurable via the `LEHIBOO_CHECKIN_TOLERANCE_MINUTES` env. Peek surfaces the current value in `slot_check.tolerance_minutes` so the mobile UI can show "Doors open at HH:MM" countdowns.

There is no upper bound — a vendor can still check in tickets after the event starts (and even after it ends, in case latecomers).

---

## 10. Audit trail

Every commit attempt (success or failure) writes to `checkin_log`:

| Column | Source |
|---|---|
| `ticket_id`, `event_id`, `slot_id` | from the ticket |
| `checked_in_by` | `user_id` from token |
| `action` | `check_in` / `re_entry` / `denied` |
| `scan_method` | from request |
| `success` | `true` for check_in/re_entry, `false` for denied |
| `failure_reason` | error code for failures |
| `device_id`, `device_name`, `gate` | from request |
| `ip_address`, `user_agent` | auto-captured |
| `scanned_at` | `now()` |

Admins can query this table to investigate disputes (e.g. a customer claims they were denied entry).

---

## 11. Out of scope (current version)

- **Offline mode** — clients MUST be online during scan. A queued/sync mode is a v2 candidate.
- **GPS coordinates** on scans.
- **Per-event re-entry policy flag** — re-entry is currently global.
- **Bulk batch check-in** (e.g. confirm an entire group in one call).

---

## 12. Authentication & organization context

### 12.1 Sign in

```
POST /api/v1/auth/login
Content-Type: application/json

{
  "email": "vendor@example.com",
  "password": "..."
}
```

**200 response (relevant subset):**

```json
{
  "data": {
    "user": {
      "id": 42,
      "uuid": "aa2f-...",
      "email": "vendor@example.com",
      "first_name": "Sarah",
      "role": "vendor"
    },
    "token": "12|abc123...sanctumToken"
  }
}
```

Persist `data.token` in secure storage (`flutter_secure_storage`). Send it as `Authorization: Bearer <token>` on every subsequent request. Sanctum tokens don't expire automatically — they remain valid until explicitly revoked. On a 401 response, treat the token as invalid, clear storage, and route the user back to the login screen.

### 12.2 Organization context

A vendor user may belong to multiple organizations (e.g. a freelancer running events for several venues). The `X-Organization-Id` header tells the API which one is active for this request. The check-in policy uses it to verify the scanned ticket belongs to an event of that organization.

```
GET /api/v1/me/memberships
Authorization: Bearer <token>
```

**200 response (relevant subset):**

```json
{
  "data": [
    {
      "organization": {
        "uuid": "org-abc-123",
        "organization_name": "La Boucherie d'Aix",
        "slug": "la-boucherie-aix"
      },
      "role": "owner",
      "is_active": true
    },
    {
      "organization": {
        "uuid": "org-xyz-789",
        "organization_name": "Le Bistrot Lyonnais",
        "slug": "le-bistrot-lyonnais"
      },
      "role": "staff",
      "is_active": true
    }
  ]
}
```

The mobile app SHOULD:

1. After login, fetch `/me/memberships` and cache the list.
2. If exactly one organization → silently select it.
3. If more than one → present an organization picker (typically once per session, with a "switch organization" affordance somewhere in settings).
4. Send `X-Organization-Id: <uuid>` on every vendor-scoped call (including check-in).

If the header is missing or the user is not a member of the referenced organization, the API responds 403 — handle by re-prompting the picker.

---

## 13. Real-time channels (optional — live gate dashboard)

The check-in commit endpoints fire broadcast events that any subscriber can stream via the Reverb websocket server (Pusher-protocol compatible). This is **optional** — the basic scan flow doesn't require websockets. Use it when you want a live "people admitted" counter on the gate device or in the admin web dashboard.

### 13.1 Connection

| | |
|---|---|
| Host | `wss://reverb.lehiboo.com` (prod) / `ws://reverb.lehiboo.localhost:8080` (dev) |
| Protocol | Pusher v7 |
| Auth | Sanctum bearer token in the channel-auth POST to `/broadcasting/auth` |

Use `pusher_channels_flutter` (Flutter) or `laravel-echo` + `pusher-js` patterns.

### 13.2 Channels relevant to check-in

| Channel | Subscribers | Purpose |
|---|---|---|
| `private-organization.{id}` | Org members + admin | All check-ins across all of the org's events. |
| `private-event.{id}.checkins` | Org members + admin | Check-ins for one specific event (use this on a per-gate dashboard). |

### 13.3 Events

| Broadcast name | Fired when | Payload |
|---|---|---|
| `ticket.checked_in` | First check-in succeeds | `{ ticket_id, ticket_uuid, qr_code, event_id, checked_in_at, scan_location, attendee_name }` |
| `ticket.re_entered` | Re-entry succeeds | `{ ticket_id, ticket_uuid, qr_code, event_id, scanned_at, scan_location, check_in_count, attendee_name }` |

Note: failed scans (denied) **do not** broadcast — they only land in `checkin_log`.

### 13.4 Dart sketch — subscribing to a gate

```dart
final pusher = PusherChannelsFlutter.getInstance();
await pusher.init(
  apiKey: 'your-reverb-key',
  cluster: 'mt1',
  authEndpoint: 'https://api.lehiboo.com/broadcasting/auth',
  onAuthorizer: (channelName, socketId, options) async {
    final res = await http.post(
      Uri.parse('https://api.lehiboo.com/broadcasting/auth'),
      headers: {'Authorization': 'Bearer $token'},
      body: {'channel_name': channelName, 'socket_id': socketId},
    );
    return jsonDecode(res.body);
  },
);
await pusher.connect();
await pusher.subscribe(
  channelName: 'private-event.$eventId.checkins',
  onEvent: (event) {
    if (event.eventName == 'ticket.checked_in') {
      // increment local counter
    }
  },
);
```

---

## 14. Flutter integration sketch

Minimal reference implementation. Production code should use a proper HTTP client (Dio) with interceptors for auth + retry, plus generated request/response models (e.g. `freezed` + `json_serializable`).

### 14.1 Type definitions (Dart)

```dart
// Request
class PeekRequest {
  final String? qrData;       // "code:secret" — preferred
  final String? qrCode;       // raw 12-char fallback
  final int? eventId;         // optional event scope
  Map<String, dynamic> toJson() => { ... };
}

class CheckInRequest {
  final String? deviceId;
  final String? deviceName;
  final String? gate;
  final String scanMethod;    // 'qr_code' | 'manual' | 'nfc' | 'barcode'
  Map<String, dynamic> toJson() => { ... };
}

// Response — peek
class PeekResponse {
  final TicketSummary ticket;
  final bool canCheckIn;
  final bool wouldBeReEntry;
  final String? blockingReason; // null | ticket_cancelled | ticket_refunded | ...
  final SlotCheck slotCheck;
}

// Response — commit
class CheckInResponse {
  final TicketSummary ticket;
  final String action;          // 'check_in' | 're_entry'
  final int checkInCount;
}

// Error envelope
class ApiError {
  final String error;           // 'ticket_cancelled' | ...
  final String message;         // localized human-readable
  final int httpStatus;
}
```

### 14.2 Two-step flow (Dart)

```dart
Future<void> handleScannedQr(String qrData) async {
  // 1. Peek
  final peekRes = await http.post(
    Uri.parse('$apiBase/v1/vendor/tickets/scan/peek'),
    headers: _vendorHeaders(),
    body: jsonEncode({'qr_data': qrData, if (eventId != null) 'event_id': eventId}),
  );

  if (peekRes.statusCode == 404) {
    showError('QR not recognized — try manual entry.');
    return;
  }
  if (peekRes.statusCode == 403) {
    showError('Not authorised for this organisation.');
    return;
  }

  final peek = PeekResponse.fromJson(jsonDecode(peekRes.body)['data']);

  if (!peek.canCheckIn) {
    showRedState(peek.blockingReason!, peek.ticket);
    return;
  }

  // 2. Visual confirm
  final confirmed = await showConfirmSheet(
    ticket: peek.ticket,
    isReEntry: peek.wouldBeReEntry,
  );
  if (!confirmed) return;

  // 3. Commit
  final commitRes = await http.post(
    Uri.parse('$apiBase/v1/vendor/tickets/${peek.ticket.uuid}/check-in'),
    headers: _vendorHeaders(),
    body: jsonEncode({
      'device_id': await DeviceInfo.id(),
      'device_name': await DeviceInfo.name(),
      'gate': selectedGate,
      'scan_method': 'qr_code',
    }),
  );

  if (commitRes.statusCode != 200) {
    final err = ApiError.fromJson(jsonDecode(commitRes.body));
    showRedState(err.error, peek.ticket);
    return;
  }

  final commit = CheckInResponse.fromJson(jsonDecode(commitRes.body)['data']);
  showSuccess(commit.action == 're_entry' ? 'Re-entry recorded' : 'Welcome!');
}

Map<String, String> _vendorHeaders() => {
  'Authorization': 'Bearer $token',
  'X-Organization-Id': activeOrgUuid,
  'Content-Type': 'application/json',
  'Accept': 'application/json',
};
```

---

## 15. Network behavior — timeouts, retries, idempotency

| Concern | Recommendation |
|---|---|
| **Connect timeout** | 5s — gate networks can be flaky; fail fast. |
| **Read timeout** | 8s — server-side check-in is fast (DB write + audit log). |
| **Retry on 5xx** | Up to 2 retries with 500ms / 1500ms backoff. |
| **Retry on 4xx** | **No** — 4xx are deterministic errors; retrying just spams the audit log. |
| **Retry on network error** (no response) | Up to 2 retries. **Important:** see idempotency below. |

### Idempotency

`POST /check-in` is **not strictly idempotent**: a network-level retry after a successful-but-unacknowledged commit will increment `check_in_count` a second time, recording a re-entry the vendor didn't intend.

Mitigation strategy for v1: on a network error, do **notMOBILE_CHECKIN_SPEC** auto-retry the commit silently. Instead, surface a "Network unstable — re-scan to confirm" message; if the vendor re-scans, the second peek will show `would_be_re_entry=true` and the count, which makes the situation visible. A dedicated `Idempotency-Key` header is a v2 candidate.

---

## 16. Camera permissions

### iOS — `Info.plist`

```xml
<key>NSCameraUsageDescription</key>
<string>Le Hiboo a besoin d'accéder à la caméra pour scanner les billets à l'entrée.</string>
```

### Android — `AndroidManifest.xml`

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-feature android:name="android.hardware.camera" android:required="false" />
```

`android:required="false"` lets the app install on tablets without a rear camera (vendor manager phones used for monitoring rather than scanning). The vendor reaches a "no camera detected — use manual entry" state, which is supported via the `qr_code` field on peek/commit.

Recommended Flutter packages: `mobile_scanner` (modern, MLKit-backed) or `qr_code_scanner` (older, ZXing-backed).

---

## 17. Test data & sandbox

There is no dedicated sandbox environment — the staging API is the test surface. Workflow for the Flutter team:

1. Get staging credentials from `#mobile` Slack channel (vendor account preconfigured with a test event + paid bookings).
2. Generate test tickets:
   ```
   docker compose exec api php artisan tinker
   >>> $booking = App\Models\Booking::where('reference', 'TEST-001')->first();
   >>> App\Services\TicketService::class
        ->generateTickets($booking)->each(fn($t) => print($t->qr_data . "\n"));
   ```
3. Encode any returned `qr_data` string as a QR PNG (e.g. `qrencode -o ticket.png "ABC123:k2j4hf..."`) and scan it with the app.
4. Verify the audit trail:
   ```
   >>> App\Models\CheckinLog::latest()->first()
   ```

The same flow works locally if the team prefers running the full stack via Docker Compose.

---

## 18. Versioning & stability commitment

| Aspect | Promise |
|---|---|
| **Path prefix** | `/api/v1/` is stable; breaking changes will move to `/api/v2/` with a deprecation period. |
| **Error codes** (the `error` field) | Stable. New codes may be added; existing codes will not be renamed. |
| **Response field names** | Stable for declared fields. New fields may be added — clients MUST ignore unknown keys. |
| **HTTP status codes** | Stable. |
| **Request validation rules** | New optional fields may be added. New required fields will be opt-in via a new endpoint or a versioned payload. |
| **Broadcast event names** (`ticket.checked_in`, `ticket.re_entered`) | Stable. New events may be added on the same channels. |

Watch the changelog at `docs/05-reference/CHANGELOG.md` (TODO) for additions.

---

## 19. Troubleshooting & FAQ

**Q: Peek returns 200 with `blocking_reason: null` but commit returns 422 `slot_not_started`.**
A possible race: peek snapshots the slot timing, then time elapses or the slot gets edited admin-side before the commit. Re-peek to refresh the state.

**Q: Two devices scanning the same ticket simultaneously — what happens?**
The first commit wins (sets status to `CheckedIn`, count=1). The second commit hits the re-entry path (count=2) and returns `action=re_entry`. Both attempts are recorded in `checkin_log`. The second device sees the re-entry warning and the vendor can intervene.

**Q: Vendor scans a QR from a screenshot of someone else's ticket.**
The QR resolves normally (the secret matches). The check-in succeeds for whoever scans first. Subsequent attempts hit `re_entry`. This is a known limitation of static QRs — the same applies to printed PDFs. Mitigation: visual ID confirmation in the peek step (the attendee name is right there on the screen).

**Q: 401 `Unauthenticated` despite having a token.**
Token may have been revoked admin-side, the user may have changed their password, or the token may have been invalidated by a `migrate:fresh` on staging (see CLAUDE.md). Re-login.

**Q: 403 `unauthorized` on peek.**
The signed-in user doesn't have permission to check tickets for this ticket's event. Most common cause: wrong `X-Organization-Id` (e.g. user has multiple orgs and the active one isn't the ticket's owning org). Re-fetch `/me/memberships` and verify.

**Q: How do I test re-entry locally without waiting for a real customer to use a ticket?**
Manually flip the status: `App\Models\Ticket::find($id)->update(['status' => 'checked_in', 'check_in_count' => 1]);` — then the next scan will return `action=re_entry`.

**Q: Can I disable re-entry for a specific event?**
Not in v1 — re-entry is global. Per-event policy flag is a v2 candidate (see "Out of scope").

**Q: My QR scan keeps returning 404 `ticket_not_found`.**
Check whether you're sending `qr_data` (full `code:secret`) or just `qr_code` (12-char shortcode). The `qr_code`-only fallback is meant for manual entry and works only when the code matches a stored ticket; if either character is misread, lookup fails. Prefer `qr_data` whenever the camera read is clean.

**Q: The audit log says my scan succeeded but the customer claims they never got in.**
Check `checkin_log` for `action=denied` rows for the same ticket within ±10 minutes (sometimes a vendor scans, denies entry manually, then re-scans). Cross-reference `device_id` and `gate` to identify which terminal recorded the entry.
