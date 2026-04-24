# Migration Plan: ApiResponseHandler Adoption

**Date:** 2026-04-20
**Status:** In progress
**Goal:** Replace all manual response parsing in datasources with `ApiResponseHandler` (`extractObject`, `extractList`, `extractMeta`, `extractError`).

---

## Completed

### auth_api_datasource.dart
- [x] `register()` — `extractObject`
- [x] `registerCustomer()` — `extractObject`
- [x] `registerBusiness()` — `extractObject`
- [x] `login()` — `extractObject`
- [x] `verifyOtp()` / `verifyLoginOtp()` — via `_parseAuthResponse` → `extractObject`
- [x] `refreshToken()` — `extractObject`
- [x] `forgotPassword()` / `resetPassword()` — void, trust HTTP status
- [x] `sendOtpCode()` / `resendOtpCode()` — `extractObject(unwrapRoot: true)`
- [x] `verifyOtpCode()` — `extractObject(unwrapRoot: true)`
- [x] `getOtpStatus()` — `extractObject(unwrapRoot: true)`
- [x] `checkEmailExists()` — `extractObject`
- [x] `resendOtp()` (legacy) — `extractObject(unwrapRoot: true)`

### customer_register_screen.dart
- [x] 4 catch blocks migrated from `e.toString()` → `extractError(e)`

---

## Phase 1 — Straightforward migrations

Simple `data['success'] == true && data['data'] != null` → `extractObject` / `extractList` replacements. Low risk, high volume.

### 1.1 profile_api_datasource.dart
`lib/features/profile/data/datasources/profile_api_datasource.dart`

| Method | Pattern | Handler call |
|--------|---------|-------------|
| `getProfile()` | `data['user']` | `extractObject(unwrapRoot: true)` then `['user']` |
| `updateProfile()` | `data['data']` | `extractObject` |
| `uploadAvatar()` | `data['data']` | `extractObject` |
| `getStats()` | `data['data']` | `extractObject` |
| `updatePassword()` | `data['success']` + `data['message']` | void, trust HTTP status |

### 1.2 blog_api_datasource.dart
`lib/features/blog/data/datasources/blog_api_datasource.dart`

| Method | Pattern | Handler call |
|--------|---------|-------------|
| `getPosts()` | `data['success']` + `data['data']['posts']` | `extractList(key: 'posts')` |
| `getPostById()` | `data['success']` + `data['data']` | `extractObject` |

### 1.3 thematiques_api_datasource.dart
`lib/features/thematiques/data/datasources/thematiques_api_datasource.dart`

| Method | Pattern | Handler call |
|--------|---------|-------------|
| `getThematiques()` | `data['data']['thematiques']` + statusCode check | `extractList(key: 'thematiques')` |

### 1.4 stories_api_datasource.dart
`lib/features/stories/data/datasources/stories_api_datasource.dart`

| Method | Pattern | Handler call |
|--------|---------|-------------|
| `getActiveStories()` | `containsKey('data')` + format detection | `extractList` |

### 1.5 mobile_config_datasource.dart
`lib/features/home/data/datasources/mobile_config_datasource.dart`

| Method | Pattern | Handler call |
|--------|---------|-------------|
| `getConfig()` | `data['data']` with try/catch fallback | `extractObject` (keep try/catch for default fallback) |

---

## Phase 2 — Medium complexity

Multiple methods per file, mix of list/object extraction, some dual-format handling.

### 2.1 gamification_api_datasource.dart
`lib/features/gamification/data/datasources/gamification_api_datasource.dart`

| Method | Pattern | Handler call |
|--------|---------|-------------|
| `getWallet()` | `data['data']` | `extractObject` |
| `claimDailyReward()` | `data['data']` + spread | `extractObject` |
| `getWheelConfig()` | `data['data']` | `extractObject` |
| `spinWheel()` | `data['data']` | `extractObject` |
| `getTransactions()` | `data['data']` + `is List` check | `extractList` |
| `getPackages()` | `data['data']` + `is List` check | `extractList` |
| `createPurchase()` | `data['data']` | `extractObject` |
| `confirmPurchase()` | message string check | void, trust HTTP status |
| `unlockChatMessages()` | message string check | void, trust HTTP status |
| `getAchievements()` | `data['data']` + `is List` check | `extractList` |
| `getChallenges()` | `data['data']` + `is List` check | `extractList` |

### 2.2 petit_boo_api_datasource.dart
`lib/features/petit_boo/data/datasources/petit_boo_api_datasource.dart`

| Method | Pattern | Handler call |
|--------|---------|-------------|
| `getConversations()` | Manual DTO parsing | `extractList` |
| `getConversation()` | `data['success']` + `data['data']` | `extractObject` |
| `createConversation()` | `data['success']` + `data['data']` | `extractObject` |
| `getQuota()` | `data['success']` + `data['data']` | `extractObject` |
| `getToolSchemas()` | `data['success']` + `data['tools']` | `extractList(key: 'tools')` or `extractObject(unwrapRoot: true)` |

Also: replace local `_extractErrorMessage()` with `extractError` delegation.

### 2.3 favorites_api_datasource.dart
`lib/features/favorites/data/datasources/favorites_api_datasource.dart`

| Method | Pattern | Handler call |
|--------|---------|-------------|
| `getFavorites()` | dual format (Laravel resource + legacy) | `extractList` |
| `addToFavorites()` | `data['success']` + `data['data']['is_favorite']` | `extractObject` |
| `removeFromFavorites()` | `data['success']` | void, trust HTTP status |
| `isFavorite()` | `data['success']` + multiple fallbacks | `extractObject` |
| `toggleFavorite()` | `data['success']` + `data['data']['is_favorite']` | `extractObject` |
| `moveFavoriteToList()` | `data['success']` | void, trust HTTP status |
| `getLists()` | dual format handling | `extractList` |
| `createList()` | `data['success']` + `data['data']` | `extractObject` |
| `getListDetails()` | `data['success']` + dual format | `extractObject` |
| `updateList()` | `data['success']` + dual format | `extractObject` |
| `deleteList()` | `data['success']` | void, trust HTTP status |
| `reorderLists()` | `data['success']` | void, trust HTTP status |

### 2.4 event_social_api_datasource.dart
`lib/features/events/data/datasources/event_social_api_datasource.dart`

| Method | Pattern | Handler call |
|--------|---------|-------------|
| `getEventReviews()` | `data['data']` + `data['meta']` | `extractList` + `extractMeta` |
| `getEventReviewStats()` | `data['data']` with root fallback | `extractObject(unwrapRoot: true)` |
| `createReview()` | `data['data']` with root fallback | `extractObject(unwrapRoot: true)` |
| `canReview()` | `data['data']?['can_review']` with fallback | `extractObject(unwrapRoot: true)` |
| `getEventQuestions()` | `data['data']` + `data['meta']` | `extractList` + `extractMeta` |
| `createQuestion()` | `data['data']` with root fallback | `extractObject(unwrapRoot: true)` |
| `getMyQuestion()` | `data['data']` | `extractObject` |

---

## Phase 3 — Complex migrations

Files with multi-format detection, pagination, retry logic, or heavy branching. Read each method carefully before migrating.

### 3.1 booking_api_datasource.dart
`lib/features/booking/data/datasources/booking_api_datasource.dart`

| Method | Pattern | Handler call | Notes |
|--------|---------|-------------|-------|
| `createBooking()` | `data['data']` | `extractObject` | |
| `getPaymentIntent()` | `data['data']` | `extractObject` | |
| `confirmBooking()` | message `contains('error')` | void, trust HTTP status | |
| `confirmFreeBooking()` | message `contains('error')` | void, trust HTTP status | |
| `getBookingTickets()` | `data['data']` + `is List` | `extractList` | Used in polling loop |
| `getMyBookings()` | `data['data']` + Laravel format | `extractList` | |
| `getBookingById()` | `data['success']` + `data['data']` | `extractObject` | |
| `cancelBooking()` | `data['success']` + multiple error formats | `extractObject` | Error paths need `extractError` |
| `getMyTickets()` | `data['success']` + `data['data']` | `extractList` | |
| `getTicketById()` | `data['success']` + `data['data']` | `extractObject` | |
| `downloadTicketPdf()` | `data['success']` + `data['data']['pdf_url']` | `extractObject` | |

### 3.2 events_api_datasource.dart
`lib/features/events/data/datasources/events_api_datasource.dart`

This is the most complex file. Multiple response formats per method.

| Method | Pattern | Handler call | Notes |
|--------|---------|-------------|-------|
| `getEvents()` | 3+ format branches, pins/lightweight modes | `extractList` + `extractMeta` | Preserve pins-specific transform logic after extraction |
| `getEvent()` | `data['success']` + `data['data']` | `extractObject` | |
| `getHomeFeed()` | 3 response structures | `extractObject(unwrapRoot: true)` | Normalize after extraction |
| `getEventAvailability()` | List vs Map branch | `extractList` or `extractObject` depending on shape | May need try/catch around extractList |
| `getCategories()` | `data['data']['categories']` | `extractList(key: 'categories')` | |
| `getThematiques()` | `data['data']['thematiques']` | `extractList(key: 'thematiques')` | |
| `getCities()` | statusCode + `data['data']['cities']` | `extractList(key: 'cities')` | |
| `getFilters()` | `data['data']` | `extractObject` | |

### 3.3 alerts_api_datasource.dart
`lib/features/alerts/data/datasources/alerts_api_datasource.dart`

| Method | Pattern | Handler call | Notes |
|--------|---------|-------------|-------|
| `getAlerts()` | `containsKey('data')` + 2 formats + retry | `extractList` | Keep retry logic, replace parsing inside it |
| `createAlert()` | statusCode check | void or `extractObject` | |

### 3.4 trip_plans_api_datasource.dart
`lib/features/trip_plans/data/datasources/trip_plans_api_datasource.dart`

| Method | Pattern | Handler call | Notes |
|--------|---------|-------------|-------|
| `getTripPlans()` | 3 data structure formats + retry | `extractList` | Keep retry logic, replace the 3 format branches |
| `updateTripPlan()` | `containsKey('data')` | `extractObject(unwrapRoot: true)` | |

---

## Phase 4 — Error handling cleanup

After all datasources are migrated, update screens/providers that still use raw `e.toString()` or duplicated `_parseError` methods.

### 4.1 Replace duplicated _parseError methods
These providers have their own `_parseError` that duplicates `extractError` logic:

| File | Method | Action |
|------|--------|--------|
| `auth_provider.dart` | `_parseError()`, `_parseOtpError()` | Delegate to `ApiResponseHandler.extractError(e)` |
| `business_register_provider.dart` | `_parseError()`, `_parseOtpError()` | Delegate to `ApiResponseHandler.extractError(e)` |

### 4.2 Replace local error handlers
| File | Method | Action |
|------|--------|--------|
| `petit_boo_api_datasource.dart` | `_extractErrorMessage()` | Replace with `extractError` |
| `petit_boo_sse_datasource.dart` | `e.toString().toLowerCase()` error checks | Replace with `extractError` |

### 4.3 Screen catch blocks
Grep for remaining `e.toString()` in screens and replace with `extractError(e)`.

---

## Notes

- **SSE datasource** (`petit_boo_sse_datasource.dart`) uses streaming event parsing, not standard REST responses. Only its error handling benefits from `extractError`; the SSE event parsing stays as-is.
- **Retry logic** in alerts/trip_plans should be preserved — only the response parsing inside the retry loop gets replaced.
- **`_parseLaravelAuthResponse`** in auth_api_datasource stays unchanged — it does field-level DTO mapping, not envelope unwrapping.
- For void endpoints (toggle, delete, confirm), if the method returns no data, just trust the HTTP status and drop the response parsing. Dio throws on 4xx/5xx.
- When a method currently handles 2+ response formats with branching, `extractObject(unwrapRoot: true)` or `extractList` should collapse most of them since the handler already resolves multiple shapes.
