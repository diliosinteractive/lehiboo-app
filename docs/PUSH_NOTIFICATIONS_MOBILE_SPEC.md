# Push Notifications — Mobile Integration Spec

**Audience** : Mobile app (Flutter — both customer and vendor sides)
**Status** : Stable contract
**Scope** : Lifecycle of FCM/APNs tokens (register, refresh, deregister), how the backend dispatches to those tokens, and the data payload contract for client-side deep-link routing.

The backend infrastructure has been shipped (May 2026) and is **waiting for the mobile app to register tokens**. Until the mobile client calls the registration endpoint, no push will arrive — even if every other condition is met.

---

## TL;DR — Quick start

| Step | Endpoint | When |
|---|---|---|
| Register | `POST /api/v1/auth/device-tokens` | Right after every successful `login`/`register*`, plus on FCM token refresh, plus on app foreground |
| List | `GET /api/v1/auth/device-tokens` | Optional — debug / settings UI showing "this device" |
| Deregister one | `DELETE /api/v1/auth/device-tokens/{uuid}` | User removes a specific device from settings |
| Deregister by token | `DELETE /api/v1/auth/device-tokens` (body: `{token}`) | When the device only knows the FCM token, not the row UUID |
| Deregister all | `DELETE /api/v1/auth/device-tokens/all` | On logout from this device |

All endpoints require `Authorization: Bearer <user_token>`. They live under the `auth.*` route group.

---

## 1. The four conditions for a push to arrive

A notification reaches the lock screen **only if all four are true**. If any one fails, silence — and most failures are silent (logged on the backend, never surfaced to the client).

| # | Condition | Owner | Where to check |
|---|---|---|---|
| 1 | Backend FCM is enabled | DevOps | `FCM_ENABLED=true` + Firebase service-account JSON deployed (`storage/firebase/service-account.json` or `FCM_CREDENTIALS_JSON` base64) |
| 2 | User opted in | App settings UI | `users.push_notifications_enabled = true` (default `false`) |
| 3 | An active device token exists for the user | **Mobile app** | One row in `device_tokens` with `is_active=true` for this `user_id + device_id + platform` combo |
| 4 | The notification class wires FCM | Backend dev | The `Notification` class uses the `HasPushNotification` trait, calls `viaWithPush()`, and implements `toFcm()` |

The most common reason a real user "never gets pushes" is **#3** — the mobile app isn't calling the registration endpoint.

---

## 2. Endpoint — Register a device token

```
POST /api/v1/auth/device-tokens
Authorization: Bearer <user_token>
Content-Type: application/json
```

### Request body

```json
{
  "token": "fcm_or_apns_registration_token_here",
  "platform": "ios",                   // "ios" | "android" | "web"
  "device_id": "ABCD-1234-…",          // optional but RECOMMENDED — see §2.3
  "device_name": "iPhone 15 Pro",      // optional, shown in user's device list
  "app_version": "1.0.0"               // optional, useful for debugging
}
```

| Field | Required | Max | Notes |
|---|---|---|---|
| `token` | yes | 512 chars | The FCM registration token from `Firebase.instance.messaging.getToken()` (Android) or the APNs token bridged through Firebase on iOS. |
| `platform` | yes | — | One of `ios`, `android`, `web`. |
| `device_id` | no | 255 chars | Stable identifier for the device. **Strongly recommended** so re-registrations upsert instead of multiplying rows. Use `device_info_plus` or a UUID generated at first launch and persisted in secure storage. |
| `device_name` | no | 255 chars | Human-readable. Surfaced in the user's "manage devices" UI. |
| `app_version` | no | 50 chars | e.g. `"1.4.0+241"`. |

### 201 / 200 response

```json
{
  "success": true,
  "message": "Token de notification enregistré.",
  "data": {
    "uuid": "9f2a-7b3c-…",
    "platform": "ios",
    "device_name": "iPhone 15 Pro",
    "is_active": true
  }
}
```

- **201 Created** when this is a new row.
- **200 OK** when the row was upserted (same `(user_id, device_id, platform)` combo updated, or the same `token` got refreshed for the same user).

The returned `uuid` is the row's identifier — store it in secure storage so you can later DELETE this exact row (e.g. on logout from one device only).

### Error responses

| HTTP | Cause | Mobile action |
|---|---|---|
| 401 | Token expired / invalid | Re-login and retry |
| 422 | `platform` not one of `ios\|android\|web`, or `token` missing/too long | Fix the payload |

### 2.1 Smart upsert behaviour (important)

The controller has three branches — clients should know about them so duplicate-token bugs can be diagnosed:

1. **Same `(user_id, device_id, platform)`** → existing row's `token` is updated, `is_active` reset to `true`, `last_used_at` bumped. Returns 200.
2. **The same `token` already exists under a different user** (e.g. user A logged out, user B logged in on the same device, both got the same FCM token) → user A's row is **deactivated** (`is_active=false`), user B gets a new row. Returns 201.
3. **The same `token` already exists for the same user** (different device_id flow) → row is updated. Returns 200.

**Implication for mobile:** always send the same `device_id` for the same physical device. If you generate a fresh `device_id` per login, you'll create N rows over time and never benefit from branch #1.

### 2.2 When to call

| Lifecycle event | Action |
|---|---|
| Right after `POST /auth/login` succeeds | Get FCM token → POST `/auth/device-tokens`. |
| Right after `POST /auth/register` / `register/vendor` / `register/business` | Same. |
| FCM `onTokenRefresh` callback (token rotated) | POST again with the new `token` and the same `device_id`. |
| App foreground (cheap defensive call) | POST again — server upserts. |
| User toggles "push notifications" ON in settings | If the local `users.push_notifications_enabled` is being flipped server-side, also re-POST to ensure freshness. |

### 2.3 Why `device_id` matters

Without `device_id`, the controller can't distinguish "this is the same iPhone re-registering" from "this is a new iPhone." Over a year of FCM token refreshes, you'd accumulate dozens of inactive rows. Always send a stable `device_id` — typically a UUID you generate at first launch and persist in iOS Keychain / Android Keystore via `flutter_secure_storage`.

---

## 3. Endpoint — List my registered devices

```
GET /api/v1/auth/device-tokens
Authorization: Bearer <user_token>
```

### 200 response

```json
{
  "success": true,
  "data": [
    {
      "uuid": "9f2a-7b3c-…",
      "platform": "ios",
      "device_name": "iPhone 15 Pro",
      "app_version": "1.0.0",
      "is_active": true,
      "last_used_at": "2026-05-04T18:00:00+02:00",
      "created_at": "2026-04-12T09:00:00+02:00"
    }
  ]
}
```

Use this to power a "manage devices" screen in settings. The `token` itself is **not** returned — server keeps it private.

---

## 4. Endpoints — Deregister

### 4.1 Deregister this device on logout

```
DELETE /api/v1/auth/device-tokens/all
Authorization: Bearer <user_token>
```

Removes **every** row for the authenticated user. Suitable when:
- User taps "Logout" on this device
- User taps "Logout from all devices" in security settings

### 4.2 Deregister a specific device (by UUID)

```
DELETE /api/v1/auth/device-tokens/{uuid}
Authorization: Bearer <user_token>
```

Use when the user removes a specific entry from a "manage devices" list. The mobile app should have stored the `uuid` from the original `POST` response.

### 4.3 Deregister by token value (when the UUID is unknown)

```
DELETE /api/v1/auth/device-tokens
Authorization: Bearer <user_token>
Content-Type: application/json

{ "token": "fcm_token_here" }
```

Useful if the mobile app didn't persist the row's UUID but still has the FCM token. Returns 404 if the token isn't found for the current user.

> **Recommended logout flow**: call `DELETE /auth/device-tokens/all` first, **then** call `POST /auth/logout`. If logout happens first, the bearer token is revoked and the device-token DELETE call fails with 401 — leaving an orphaned active row that will continue receiving pushes for the previous user (until eventually deactivated by branch #2 of §2.1, which only fires on the *next* login from someone on that device).

---

## 5. Server → device — what the FCM payload looks like

When the backend dispatches a notification, the FCM message body has two top-level sections: a **notification block** (title/body shown by the OS on the lock screen) and a **data block** (key-value pairs your app reads to deep-link).

### 5.1 Notification block

| Key | Source | Example |
|---|---|---|
| `title` | `PushPayload->title` | `"Réservation confirmée"` |
| `body` | `PushPayload->body` | `"Votre réservation pour Tournoi de tennis est confirmée."` |
| `image` (optional) | `PushPayload->imageUrl` | event poster URL — used as the rich notification image |
| `sound` | `PushPayload->sound` | `"default"` (override per channel) |
| `priority` | `PushPayload->priority` | `"high"` (default) |
| `android.channelId` | `PushPayload->channelId` | One of the values in §5.1.1 below |

#### 5.1.1 Channel ↔ `data.type` map (authoritative, derived from `app/Services/Push/Payloads/PushPayload.php`)

| `channelId` | `data.type` values that target it | Notes |
|---|---|---|
| `bookings` | `booking_confirmed`, `new_booking` | |
| `alerts` | `new_alert_events`, `new_event_from_followed_organization` | |
| `messages` | `new_message` | |
| `organizations` | `organization_invitation_received`, `organization_join_requested`, `organization_join_approved`, `organization_join_rejected` | |
| `general` | Everything else — review/question/discovery/membership notifications that go through `PushPayload::generic` (see §6). | Catch-all. The factory itself adds nothing; each notification class is responsible for its own `data` payload (see §5.2.1 for the `action` caveat). |
| `reminders` | `event_reminder` | **Defined but unused** — `PushPayload::eventReminder` exists; no notification class consumes it today. Will become live once a reminder notification wires the trait. |
| `check_ins` | `ticket_checked_in` | **Defined but unused** — `PushPayload::ticketCheckedIn` exists; `TicketCheckedInNotification` does not currently send FCM. |
| `collaborations` | `collaboration_invite` | **Defined but unused** — factory present, no consumer. |

The mobile app SHOULD pre-create all channels listed (including the unused ones) so the OS doesn't have to lazy-create when the first notification of that kind arrives later.

### 5.2 Data block (the contract for deep-linking)

The `data` map carries the routing signal. **Read this section carefully — there are two keys with different stability guarantees.**

#### 5.2.1 The two keys

| Key | Always present? | Format | Use it for |
|---|---|---|---|
| `type` | **Yes** — every push has one (snake_case, e.g. `booking_confirmed`) | Stable enum, mirrors `frontend/src/types/notification.ts` | **The canonical mobile routing signal. Switch on this.** |
| `action` | **Almost always** — present in every type-specific factory and in nearly every generic-factory notification today. One confirmed exception: `organization_join_rejected`. Future generic-factory notifications may also omit it. | **Web URL path** (e.g. `/bookings/123`, `/organizers/{slug}`) | Informational only on mobile. Useful as a hint or for web push compat. |

**Mobile contract: route on `data.type`. Never navigate to `data.action` directly.**

The reason: `data.action` is the URL the same notification would point to **on the web app**. The mobile app's screen hierarchy doesn't match (e.g. web `/bookings/123` ≈ mobile `BookingDetailScreen(id: 123)`). The Flutter app's `DeepLinkService._getRouteForType()` is the single source of truth for `data.type` → mobile route mapping; this spec defers to that mapping.

#### 5.2.2 Concrete payload examples

The web `action` paths are shown for reference — mobile MUST translate via `data.type`, not navigate to them.

```jsonc
// type=booking_confirmed (channel: bookings)
{
  "type": "booking_confirmed",
  "booking_id": "123",
  "booking_reference": "A1B2C3D4",
  "action": "/bookings/123"          // web URL — mobile translates to its own route
}

// type=new_booking (channel: bookings, vendor side)
{
  "type": "new_booking",
  "booking_id": "123",
  "event_id": "42",
  "action": "/vendor/bookings/123"
}

// type=new_alert_events (channel: alerts)
{
  "type": "new_alert_events",
  "alert_uuid": "abc-…",
  "new_count": "5",
  "action": "/search?alert=abc-…"
}

// type=new_event_from_followed_organization (channel: alerts)
{
  "type": "new_event_from_followed_organization",
  "event_uuid": "xyz-…",
  "event_slug": "concert-jazz-place-bellecour",
  "organization_uuid": "org-…",
  "action": "/events/concert-jazz-place-bellecour"
}

// type=new_message (channel: messages)
{
  "type": "new_message",
  "conversation_uuid": "conv-…",
  "conversation_type": "participant_vendor",
  "action": "/messages/conv-…"
}

// type=organization_join_approved (channel: organizations)
{
  "type": "organization_join_approved",
  "organization_id": "42",
  "organization_slug": "la-boucherie-aix",
  "action": "/organizers/la-boucherie-aix"
}

// type=organization_join_rejected (channel: organizations)
// Note: no `action` — the rejection notification has nowhere meaningful to go.
{
  "type": "organization_join_rejected",
  "organization_id": "42"
}

// type=review_approved (channel: general — generic factory)
// Note: generic payloads carry NO `action` key.
{
  "type": "review_approved"   // plus whatever data the notification class added, if any
}
```

**FCM coercion**: FCM serialises every `data` value to a string at delivery (the backend calls `array_map('strval', $this->data)` in `PushPayload::toFcmFormat()`). Numeric IDs arrive as `"123"`, not `123`. Decode accordingly on the mobile side.

**Stability commitment**: `data.type` values are stable; new ones may be added (clients MUST ignore unknown types — fall back to opening the in-app notification list). Existing types won't be renamed. `data.action`, when present, contains a **web URL** — its presence and value are stable per type, but the spec does not commit to it remaining present in future versions of generic-factory notifications.

### 5.3 Tap → route

The mobile app SHOULD:

1. On notification tap, read `data.type`.
2. Translate via `DeepLinkService._getRouteForType()` to a mobile route.
3. If the type is unknown (newer backend than mobile), open the in-app notifications list — never crash, never blindly navigate to `data.action`.

A minimal Dart helper:

```dart
void handleNotificationTap(Map<String, dynamic> data) {
  final type = data['type'] as String?;
  if (type == null) {
    router.go('/notifications');
    return;
  }
  final route = DeepLinkService.getRouteForType(type, data);
  router.go(route ?? '/notifications');
}
```

Future evolution: if the product wants the backend to send mobile-native routes directly, that's an additive contract change — add a `data.mobile_action` key with mobile route paths, leave `data.action` as the web hint, and have mobile clients prefer `mobile_action` when present. Not built today.

---

## 6. Which notifications send push today

Authoritative list — derived from `grep -l "use HasPushNotification" app/Notifications/*.php` against the current `staging` branch. **20 notification classes** wire FCM. The table below maps each one to its `data.type`, channel, and whether it carries a `data.action`.

| Notification class | `data.type` | Channel | Notes |
|---|---|---|---|
| `BookingConfirmedNotification` | `booking_confirmed` | `bookings` | Customer side. |
| `NewMessageNotification` | `new_message` | `messages` | Customer ↔ vendor + support conversations. |
| `NewAlertEventsNotification` | `new_alert_events` | `alerts` | Saved-search hits. Customer side. |
| `NewEventFromFollowedOrganizationNotification` | `new_event_from_followed_organization` | `alerts` | Customer side. |
| `OrganizationInvitationNotification` | `organization_invitation_received` | `organizations` | Mail-only when notifiable is anonymous (not yet a User). |
| `OrganizationJoinRequestedNotification` | `organization_join_requested` | `organizations` | Vendor receives — customer asked to join. |
| `OrganizationJoinApprovedNotification` | `organization_join_approved` | `organizations` | Customer receives. |
| `OrganizationJoinRejectedNotification` | `organization_join_rejected` | `organizations` | Customer receives. **Confirmed: no `data.action` key** (rejection has no destination). |
| `DiscoveryEventReminderNotification` | `discovery_reminder` | `general` | Uses `PushPayload::generic`. |
| `OrganizationInvitationAcceptedNotification` | `organization_invitation_accepted` | `general` | Generic. |
| `OrganizationInvitationDeclinedNotification` | `organization_invitation_declined` | `general` | Generic. |
| `OrganizationMemberLeftNotification` | `organization_member_left` | `general` | Generic. |
| `OrganizerReviewSubmittedNotification` | `organizer_review_submitted` | `general` | Vendor side. Generic. |
| `OrganizerReviewApprovedNotification` | `organizer_review_approved` | `general` | Vendor side. Generic. |
| `ReviewSubmittedNotification` | `review_submitted` | `general` | Generic. |
| `ReviewApprovedNotification` | `review_approved` | `general` | Generic. |
| `ReviewRejectedNotification` | `review_rejected` | `general` | Generic. |
| `QuestionAnsweredNotification` | `question_answered` | `general` | Generic. |
| `QuestionApprovedNotification` | `question_approved` | `general` | Generic. |
| `QuestionRejectedNotification` | `question_rejected` | `general` | Generic. |

> **About the 12 "generic" rows**: they go through `PushPayload::generic()` which sets `channelId: 'general'` and forwards whatever `data` array the caller provides. In current code each generic-factory notification *does* pass both `type` and `action` in that data array — but the spec does **not** commit to `action` always being present in generic payloads (it's in the notification class, not the factory). Mobile MUST route on `data.type` regardless.

**NOT currently on push** (database/mail only):
- `StoryNotification` (story_submitted / story_submitted_vendor / story_approved / story_rejected) — if product wants vendors to get a push when their story is approved, that's a one-line change: switch `via()` to `viaWithPush()` and add `PushPayload::storySubmitted/Approved/Rejected()` factories.
- `BookingCancelledNotification`, `BookingCancelledOrganiserNotification`, `TicketCheckedInNotification`, `BookingReceivedOrganiserNotification`, `NewSlotsFromFollowedOrganizationNotification` — exist but don't wire FCM. If push is needed, add the trait + `toFcm()`.

**Defined `PushPayload` factories with no current consumer** (dead-code on the backend, but the channelIds will be needed if a notification class is wired later): `eventReminder` → channel `reminders`, `ticketCheckedIn` → channel `check_ins`, `collaborationInvite` → channel `collaborations`, `newBooking` → channel `bookings`.

---

## 7. Flutter integration sketch

### 7.1 At app startup

```dart
Future<void> _initFirebase() async {
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.requestPermission();

  // Get and persist the device_id once per install.
  deviceId = await secureStorage.read(key: 'device_id') ?? () async {
    final id = const Uuid().v4();
    await secureStorage.write(key: 'device_id', value: id);
    return id;
  }();
}
```

### 7.2 After login

```dart
Future<void> registerPushToken({required String userBearer}) async {
  final fcmToken = await FirebaseMessaging.instance.getToken();
  if (fcmToken == null) return; // simulator / iOS without APNs

  final res = await http.post(
    Uri.parse('$apiBase/v1/auth/device-tokens'),
    headers: {
      'Authorization': 'Bearer $userBearer',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'token': fcmToken,
      'platform': Platform.isIOS ? 'ios' : 'android',
      'device_id': deviceId,
      'device_name': await _readableDeviceName(),
      'app_version': await _appVersion(),
    }),
  );

  if (res.statusCode == 201 || res.statusCode == 200) {
    final body = jsonDecode(res.body);
    await secureStorage.write(
      key: 'device_token_uuid',
      value: body['data']['uuid'],
    );
  }
}
```

### 7.3 Handle token refresh

```dart
FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
  // Same device_id → server upserts
  registerPushToken(userBearer: currentBearer);
});
```

### 7.4 At logout

> **Known bug in the current Flutter implementation**: today the app calls `logout` first, then tries to deregister — by which time the bearer has been revoked, so the DELETE returns 401 and the device row stays active. The spec below is the **recommended fix**: deregister first, then logout. Mobile work item: reorder these two calls.

```dart
Future<void> logout() async {
  // 1. Deregister BEFORE revoking the bearer (currently swapped — fix this).
  await http.delete(
    Uri.parse('$apiBase/v1/auth/device-tokens/all'),
    headers: {'Authorization': 'Bearer $bearer'},
  );

  // 2. Now revoke the session.
  await http.post(
    Uri.parse('$apiBase/v1/auth/logout'),
    headers: {'Authorization': 'Bearer $bearer'},
  );

  await secureStorage.delete(key: 'device_token_uuid');
  // Note: keep `device_id` — same physical device, future logins reuse it.
}
```

If the deregister call fails (network error, server 5xx), proceed to the logout step anyway — branch #2 of §2.1 will eventually deactivate the orphaned row when a new user logs in on this device. Don't block the user's logout on a deregister failure.

### 7.5 Foreground vs background

| App state | Behaviour | Mobile responsibility |
|---|---|---|
| Foreground | OS does **not** show the notification by default. | Listen to `FirebaseMessaging.onMessage` and either show an in-app toast or render a local notification. |
| Background | OS shows the notification using the `notification` block. | On tap, `FirebaseMessaging.onMessageOpenedApp` fires — read `data.action` and route. |
| Terminated (cold start from tap) | Same as background. | Read `getInitialMessage()` at startup to capture the tap that launched the app. |

---

## 8. Permissions & platform setup

### 8.1 iOS — `Info.plist`

```xml
<!-- Required for background notification handling -->
<key>UIBackgroundModes</key>
<array>
  <string>remote-notification</string>
  <string>fetch</string>
</array>
```

iOS shows its own system permission prompt for remote push — **no usage-description string is required**. (`NSUserNotificationsUsageDescription` is sometimes seen in older docs but is not a real Info.plist key for remote push permission.)

Plus: enable **Push Notifications** capability in Xcode, upload an APNs auth key (`.p8`) to the Firebase project (recommended over `.p12` certificates), and ensure provisioning profiles include the `aps-environment` entitlement (`development` for Debug builds, `production` for TestFlight/App Store).

### 8.2 Android — `AndroidManifest.xml`

```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
<uses-permission android:name="android.permission.INTERNET" />
```

API 33+ requires runtime permission for `POST_NOTIFICATIONS` — request via `FirebaseMessaging.instance.requestPermission()`.

### 8.3 Notification channels (Android 8+)

Create the channels listed in §5.1.1 on first launch — at minimum the **5 currently-live channels** (`bookings`, `alerts`, `messages`, `organizations`, `general`). Pre-creating the **3 reserved-but-unused channels** (`check_ins`, `collaborations`, `reminders`) is optional; do it if you want the OS to use the right defaults the moment a notification of that type goes live, without an app update.

```dart
// Live channels
const AndroidNotificationChannel('bookings', 'Réservations',
    importance: Importance.high);
const AndroidNotificationChannel('alerts', 'Alertes & nouveautés',
    importance: Importance.high);
const AndroidNotificationChannel('messages', 'Messages',
    importance: Importance.high);
const AndroidNotificationChannel('organizations', 'Organisations',
    importance: Importance.defaultImportance);
const AndroidNotificationChannel('general', 'Notifications générales',
    importance: Importance.defaultImportance);

// Reserved (optional pre-creation)
const AndroidNotificationChannel('check_ins', 'Check-in',
    importance: Importance.high);
const AndroidNotificationChannel('reminders', 'Rappels',
    importance: Importance.high);
const AndroidNotificationChannel('collaborations', 'Collaborations',
    importance: Importance.defaultImportance);
```

---

## 9. Backend prerequisites — what to ask DevOps

Before debugging "push doesn't work" on the mobile side, confirm with the backend team:

| | Check |
|---|---|
| `FCM_ENABLED=true` in deployed `.env` | `docker compose exec api php artisan tinker --execute="echo config('services.fcm.enabled') ? 'on' : 'off';"` |
| Firebase service account JSON deployed | File at `storage/firebase/service-account.json` *or* base64 under `FCM_CREDENTIALS_JSON` env |
| `users.push_notifications_enabled` migrated | Migration `2026_05_01_121000_add_push_notifications_opt_in_to_users.php` ran |
| User has opted in | `select push_notifications_enabled from users where id = …` returns `true` |
| User has device tokens | `select count(*) from device_tokens where user_id = … and is_active = true` returns ≥ 1 |
| FCM driver isn't logging auth failures | `docker compose logs api | grep FcmDriver` — look for "Failed to get FCM access token" or "FCM send failed" |

---

## 10. Versioning & stability commitment

| Aspect | Promise |
|---|---|
| Path prefix | `/api/v1/auth/device-tokens/*` is stable. |
| Request schema | New optional fields may be added; existing fields and validation rules stable. |
| Response shape | The fields listed in §2 / §3 are stable. New fields may be added — clients MUST ignore unknown keys. |
| `data.type` values | Stable. New types added as needed; never renamed. |
| `data.action` paths | Stable for known types. Mobile MUST gracefully fall back on unknown paths. |
| Smart-upsert semantics | Stable — branches in §2.1 will not change without a major version bump. |

---

## 11. Troubleshooting & FAQ

**Q: I'm not getting any notifications on iOS.**
First check the four conditions in §1. If all four are true, look at:
1. iOS simulator can't receive push — only physical devices.
2. The APNs auth key (`.p8`) must be in Firebase, not just locally in Xcode.
3. The provisioning profile must include `aps-environment` (development for Debug builds, production for TestFlight/App Store).

**Q: Why does Firebase return a token but the backend never sees it?**
You're probably calling `POST /auth/device-tokens` with an expired bearer token, or before login completes. Check the response code — 401 means re-login and retry.

**Q: I get notifications, but tapping them does nothing.**
You're not reading `data.action`. The OS shows the title/body from the `notification` block, but routing happens via the `data` block in `FirebaseMessaging.onMessageOpenedApp`.

**Q: After logout, I'm still receiving notifications meant for the previous user.**
You skipped `DELETE /auth/device-tokens/all` before logout. Mitigation today is automatic but lazy: when the **next** user logs in on the same device and registers their FCM token, branch #2 of §2.1 deactivates the old user's row. Until then, push for the old user can still fire.

**Q: My settings UI shows 5 device entries for what's clearly the same iPhone.**
You're not sending a stable `device_id`. Each registration falls through to "create new row" because the controller can't recognise the device. Use a UUID stored in Keychain at first launch (see §7.1).

**Q: Push works in dev but not in production.**
Most common: `FCM_ENABLED=false` in production `.env`, or the production Firebase project isn't the one you're sending tokens for. iOS sandbox vs production APNs is also a frequent culprit (use the production APNs auth key for production builds).

**Q: I want to disable push for a specific user without removing their tokens.**
Set `users.push_notifications_enabled = false`. The `HasPushNotification` trait checks this at dispatch time and skips the FCM channel — no FCM call is made, but the in-app and email notifications still fire.

**Q: Is there a sandbox / test push trigger?**
There's no curl-friendly "send me a test push" endpoint yet. To test, register a token then trigger a real notification (e.g. confirm a booking via the existing booking flow — `BookingConfirmedNotification` fires with FCM). Watch backend logs for `FcmDriver::send()` debug lines. If a dedicated test endpoint would help, file a request.

**Q: Can a single user have tokens on multiple devices?**
Yes — the `(user_id, device_id, platform)` uniqueness lets a user have tokens on iPhone + iPad + Android tablet simultaneously. Notifications fan out to all active rows.

**Q: What happens to inactive/stale tokens?**
Currently: nothing — they accumulate. The `PushNotificationService` logs warnings when FCM rejects a stale token. A periodic cleanup job is a v2 candidate; not urgent at current scale.

---

## 12. Out of scope (current version)

- **APNs direct path** — the backend uses FCM for both iOS and Android. iOS APNs goes via Firebase, not directly. If the product ever needs APNs HTTP/2 directly (e.g. for Apple-only features like critical alerts), that's a new driver.
- **Topic-based subscription** (e.g. "all users following org X get a topic push") — currently the backend sends to *user-scoped tokens*. Topics aren't used.
- **Web push** (browser notifications) — `platform=web` is accepted by the schema but no notification class wires a web-specific payload yet.
- **Test push endpoint** — see FAQ above.
- **Rich media on iOS notification service extensions** — `imageUrl` is sent but iOS requires a Notification Service Extension to render rich media. Not implemented in the current Flutter app.
- **Stale-token cleanup job** — see FAQ above.

---

## 13. Related specs

| Doc | Why mention it |
|---|---|
| `MOBILE_CHECKIN_SPEC.md` | Vendor-side. The `TicketCheckedIn` notification fires push to the customer; useful to understand the trigger. |
| `HERO_SLIDES_MOBILE_SPEC.md` | Carousel-only — no push relationship. |
| `STORY_VIDEO_TRIM_MOBILE_SPEC.md` | Story creation flow. Note that `StoryNotification` does **not** currently send push (see §6). |
| `BOOKING_CREATE_MOBILE_SPEC.md` / `BOOKING_DETAIL_MOBILE_SPEC.md` | Booking lifecycle that drives most customer-facing push events (`booking_confirmed`, `ticket_checked_in`). |