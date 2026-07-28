# Mobile Architecture and State Review - 2026-06-03

Scope: review of the Flutter mobile app architecture, Riverpod state
management, auth-scoped state, routing guards, repository boundaries, analyzer
output, and test health.

This file now tracks the findings and the incremental fix status.

## Executive Summary

The app has a generally consistent feature-oriented structure and a clear
Riverpod-based state model. At review time, the highest-risk gaps were around
auth transitions and user-scoped provider lifetime: several providers assumed
logout transitions directly from `authenticated` to `unauthenticated`, while
normal logout passes through `loading`.

The second major pattern was inconsistent use of abstract repository providers.
`main.dart` defined overrides for domain-level repositories, but multiple
presentation providers read concrete implementation providers directly.

All findings below have now been fixed and marked completed.

## Checks Run

Initial review checks:

```bash
flutter analyze
```

Result:

- 0 analyzer errors
- 852 warnings
- 329 infos
- 1181 total issues
- 824 warnings are repeated `invalid_annotation_target` warnings from
  Freezed/`JsonKey` usage

```bash
flutter test
```

Result:

- Fails 2 tests:
  - `test/core/l10n/app_locale_test.dart`
  - `test/widget_test.dart`
- Root cause: `appLocaleControllerProvider` reads `analyticsServiceProvider`,
  but those tests only override `sharedPreferencesProvider`.

Latest validation after fixes:

```bash
flutter analyze --no-pub --no-fatal-infos --no-fatal-warnings <touched Dart files>
```

Result:

- No issues found across 32 touched Dart files.

```bash
flutter test --no-pub
```

Result:

- All tests passed.

## Findings

### 1. High - Normal Logout Can Leave User-Scoped State Mounted

Status: Completed on 2026-06-03.

Evidence:

- `lib/features/auth/presentation/providers/auth_provider.dart`
  - `logout()` sets state to `loading`, then later to `unauthenticated`.
  - `_invalidateUserScopedProviders()` intentionally excludes several providers
    because comments assume those providers self-clear.
- Affected listener pattern:
  - `next == AuthStatus.unauthenticated && previous == AuthStatus.authenticated`

Observed in:

- `lib/features/booking/presentation/controllers/booking_list_controller.dart`
- `lib/features/favorites/presentation/providers/favorites_provider.dart`
- `lib/features/favorites/presentation/providers/favorite_lists_provider.dart`
- `lib/features/alerts/presentation/providers/alerts_provider.dart`
- `lib/features/reminders/presentation/providers/reminders_provider.dart`
- `lib/features/reviews/presentation/providers/user_reviews_provider.dart`
- `lib/features/trip_plans/presentation/providers/trip_plans_provider.dart`
- `lib/features/petit_boo/presentation/providers/petit_boo_chat_provider.dart`
- `lib/features/gamification/application/hibons_auth_sync.dart`

Impact:

- Normal logout path can miss state clearing because the listener sees
  `authenticated -> loading -> unauthenticated`, not
  `authenticated -> unauthenticated`.
- Previous-user data can remain in mounted non-autoDispose providers until
  refresh, invalidation, app restart, or next explicit load.
- The comments in `auth_provider.dart` give a false sense of safety by excluding
  these providers from the manual invalidation list.

Fix applied:

- Added a shared `didTransitionToUnauthenticated` auth transition helper.
- Updated user-scoped self-listeners to reset on the normal logout
  `loading -> unauthenticated` transition while still ignoring cold-start
  `initial -> unauthenticated`.
- Applied the same transition helper to bookings, favorites, favorite lists,
  alerts, reminders, reviews, trip plans, Petit Boo chat, Hibons auth sync, and
  active check-in organization cleanup.
- Added focused auth transition tests for the normal logout loading hop.

### 2. High - `AuthState.copyWith` Cannot Clear Nullable Fields

Status: Completed on 2026-06-03.

Evidence:

- `lib/features/auth/presentation/providers/auth_provider.dart`
  - `copyWith` used nullable parameters and `?? this.field` for several
    nullable fields.
  - `errorMessage` had different semantics from the other nullable fields,
    clearing when omitted instead of preserving the previous value.

Affected fields with the explicit-null clear bug:

- `user`
- `pendingUserId`
- `pendingEmail`

Examples:

- OTP success paths pass `pendingUserId: null` and `pendingEmail: null`, but
  old pending data is preserved.
- `user: null` could not clear the authenticated user through `copyWith`.
- Omitted `errorMessage` did not behave like the other nullable fields, making
  nullable state updates harder to reason about.

Impact:

- OTP metadata can survive after successful auth.
- User and error state mutation semantics were inconsistent.
- This is especially risky because auth state also drives router behavior.

Fix applied:

- `AuthState.copyWith` now distinguishes omitted nullable fields from fields
  explicitly set to `null`.
- Added focused tests covering explicit clears and omitted-field preservation.

### 3. Medium/High - Protected Routes Instantiate Authenticated Providers

Status: Completed on 2026-06-03.

Evidence:

- `lib/routes/app_router.dart`
  - `/messages` returns `null` for unauthenticated users instead of redirecting.
  - User-only routes such as `/alerts`, `/notifications`, `/trip-plans`,
    `/my-reminders`, `/my-questions`, and `/my-reviews` are plain builders.
- `lib/features/messages/presentation/screens/conversations_list_screen.dart`
  watches conversation providers even while unauthenticated.
- `lib/features/notifications/presentation/screens/notifications_inbox_screen.dart`
  calls `inAppNotificationsProvider.notifier.load(refresh: true)` in
  `initState`.
- `lib/features/notifications/presentation/providers/in_app_notifications_provider.dart`
  does not auth-check `load()` before calling protected notification APIs.

Impact:

- Direct deep links can instantiate protected API providers before the UI
  guest state/dialog blocks interaction.
- This can create 401 noise, force logout edge cases, inconsistent error UI, and
  wasted network calls.
- The guard behavior is split between router, screens, and providers.

Fix applied:

- Added a single protected-route guard for messages, notifications, alerts,
  trip plans, reminders, questions, and reviews.
- Unauthenticated direct navigation now redirects to `/login` with the original
  route preserved in the existing `redirect` query parameter.
- Added a defensive auth check to in-app notification `load()`/`loadMore()` so
  protected notification APIs are not called while unauthenticated.
- Added route guard tests and notification provider guard tests.

### 4. Medium - Repository Abstraction Drift

Status: Completed on 2026-06-03.

Evidence:

- `lib/main.dart` defines overrides for abstract/domain repository providers.
- Several presentation providers/screens bypass those abstractions and read
  concrete implementation providers directly.

Examples:

- `lib/features/auth/presentation/providers/auth_provider.dart`
  reads `authRepositoryImplProvider`.
- `lib/features/auth/presentation/providers/business_register_provider.dart`
  reads `authRepositoryImplProvider`.
- `lib/features/auth/presentation/screens/customer_register_screen.dart`
  reads `authRepositoryImplProvider`.
- `lib/features/favorites/presentation/providers/favorites_provider.dart`
  reads `favoritesRepositoryImplProvider`.
- `lib/features/favorites/presentation/providers/favorite_lists_provider.dart`
  reads `favoritesRepositoryImplProvider`.
- `lib/features/alerts/presentation/providers/alerts_provider.dart`
  reads `alertsRepositoryImplProvider`.
- `lib/features/stories/presentation/providers/stories_provider.dart`
  reads `storiesRepositoryImplProvider`.
- `lib/features/trip_plans/presentation/providers/trip_plans_provider.dart`
  reads `tripPlansRepositoryImplProvider`.

Impact:

- Fake/offline mode is partial.
- Tests must override more implementation providers than necessary.
- Domain provider overrides in `main.dart` do not consistently control app
  behavior.
- Architecture is harder to reason about because dependency direction varies by
  feature.

Fix applied:

- Presentation providers/screens now read abstract repository providers for
  auth, favorites, alerts, stories, trip plans, notifications, and message
  creation flows instead of concrete implementation providers.
- Added domain provider stubs for trip plans and in-app notifications.
- `main.dart` now wires those abstractions to the real API implementations at
  the app composition root.
- Added a focused provider override test for stories to prove presentation code
  respects the abstract repository override.

### 5. Medium - Test Suite Fails Due Missing Analytics Override

Status: Completed on 2026-06-03.

Evidence:

- `lib/core/l10n/app_locale.dart` reads `analyticsServiceProvider`.
- `lib/core/analytics/analytics_provider.dart` throws unless overridden.
- `test/core/l10n/app_locale_test.dart` only overrides
  `sharedPreferencesProvider`.
- `test/widget_test.dart` only overrides `sharedPreferencesProvider`.

Impact:

- `flutter test` is currently red.
- Tests are tightly coupled to app-level infrastructure.
- Locale tests should not require Firebase analytics wiring unless the test is
  explicitly checking analytics side effects.

Fix applied:

- Locale/app tests now override `analyticsServiceProvider` with
  `NoopAnalyticsService`.

### 6. Medium/Low - Voice FAB State Has Same Nullable `copyWith` Clear Bug

Status: Completed on 2026-06-03.

Evidence:

- `lib/core/widgets/voice_fab/voice_fab_state.dart`
  - `copyWith` uses nullable parameters and `?? this.field`.
  - `startListening()` and `reset()` pass `transcription: null` and
    `errorMessage: null` expecting to clear them.

Impact:

- Old transcription/error text can survive a new recording session or reset.
- This is lower risk than auth state but user-visible.

Fix applied:

- `VoiceFabState.copyWith` now supports explicitly clearing nullable fields.
- Added focused tests for `startListening()` and `reset()`.

### 7. Low - Analyzer Signal Is Noisy

Status: Completed on 2026-06-03.

Evidence:

- `flutter analyze` reports 824 `invalid_annotation_target` warnings.
- These are concentrated around Freezed models using `@JsonKey` on constructor
  parameters.

Impact:

- Real warnings are harder to spot.
- CI/editor signal becomes less useful.
- The remaining non-Freezed warnings include null-safety noise and unused code
  in event detail widgets.

Fix applied:

- `analysis_options.yaml` now suppresses the known Freezed/`JsonKey`
  `invalid_annotation_target` noise while leaving other analyzer warnings
  visible.

### 8. Low/Security - Debug Logs Print Full Bearer Tokens

Status: Completed on 2026-06-03.

Evidence:

- `lib/config/dio_client.dart` logs the full bearer token in debug mode.

Impact:

- Release builds are not affected.
- Shared debug logs, screenshots, or support captures can leak credentials.

Fix applied:

- Debug auth logging now masks bearer tokens by keeping only the first and last
  four characters.
- Added focused tests for token masking.

## Proposed Fix Plan

### Phase 1 - Stabilize User-Scoped State Boundaries

Goal: prevent same-session data leakage after logout/account switch.

1. Define a single auth-transition helper or convention.
   - Treat any transition to `unauthenticated` from a non-`initial` state as a
     logout boundary, including `loading -> unauthenticated`.
   - Consider comparing user IDs instead of only statuses where possible.

2. Update self-clearing providers.
   - Booking list
   - Favorites
   - Favorite lists
   - Alerts
   - Reminders
   - User reviews
   - Trip plans
   - Petit Boo chat
   - Hibons auth sync

3. Revisit `_invalidateUserScopedProviders()`.
   - Either rely on fixed self-listeners and document the invariant clearly, or
     explicitly invalidate high-risk providers on logout.
   - Avoid duplicate logic only after tests prove the listener path works.

4. Add focused tests.
   - Simulate `authenticated -> loading -> unauthenticated`.
   - Assert each user-scoped provider clears.
   - Simulate account switch and assert new account does not see old state.

### Phase 2 - Fix Clearable State `copyWith` Implementations

Goal: make nullable fields safely clearable.

1. Replace `AuthState.copyWith` nullable clear semantics.
   - Use sentinel parameters, explicit `clearX` booleans, or Freezed.
   - Ensure `user`, `errorMessage`, `pendingUserId`, and `pendingEmail` can be
     intentionally set to null.

2. Add tests for auth state.
   - `clearError()` clears error.
   - successful OTP clears pending metadata.
   - starting login/register clears previous error.
   - logout/forceLogout leaves a fully empty unauthenticated state.

3. Fix `VoiceFabState.copyWith`.
   - Use sentinel or explicit clear flags for `transcription` and
     `errorMessage`.
   - Add a small unit test for `startListening()` and `reset()`.

### Phase 3 - Centralize Protected Route/Provider Guarding

Goal: authenticated-only screens should not instantiate protected providers for
guests.

1. Create a route-level policy for protected paths.
   - Options:
     - redirect to `/login?redirect=...`
     - show a shell-level auth gate screen
     - keep guest modal UX but prevent provider construction until auth is true

2. Apply policy to:
   - `/messages`
   - `/notifications`
   - `/alerts`
   - `/trip-plans`
   - `/my-reminders`
   - `/my-questions`
   - `/my-reviews`
   - booking/account/profile subroutes as needed

3. Make protected providers auth-aware.
   - For providers that fetch `/me/...`, return empty/guest state when
     unauthenticated.
   - Avoid protected API calls from `initState` unless auth is true.

4. Add route/provider tests.
   - Unauthenticated deep link does not call protected repository.
   - Authenticated deep link loads expected data.

### Phase 4 - Restore Repository Boundary Consistency

Goal: presentation should depend on domain repository providers, not concrete
implementation providers.

1. Replace direct `*ImplProvider` reads in presentation code with abstract
   providers.
2. Keep implementation providers inside data layer only.
3. Add provider override tests for at least auth, favorites, alerts, stories,
   and trip plans.
4. Re-evaluate fake/offline mode after cleanup.

### Phase 5 - Fix Current Test Failures

Goal: get `flutter test` green.

1. Override `analyticsServiceProvider` with `NoopAnalyticsService` in tests that
   construct locale/app providers.
2. Consider a shared test helper for common provider overrides:
   - shared preferences
   - analytics
   - repositories/fakes
   - Dio/client mocks

### Phase 6 - Reduce Analyzer Noise

Goal: make analyzer output actionable.

1. Decide whether the `invalid_annotation_target` warnings are acceptable for
   this Freezed/json_annotation version.
2. Preferred fixes:
   - adjust annotations to generated-field-compatible syntax where possible, or
   - configure analyzer exclusions/suppression for generated/model patterns if
     the codegen output is valid and warnings are purely tooling noise.
3. Clean the smaller warning classes after the big noise is reduced:
   - unnecessary null comparisons
   - unnecessary non-null assertions
   - dead null-aware expressions
   - unused elements/imports

### Phase 7 - Reduce Debug Credential Exposure

Goal: avoid leaking bearer tokens in local/debug logs.

1. Replace full bearer logging with masked token output.
2. Keep a targeted opt-in debug flag for replaying requests if needed.
3. Ensure logs never include full credentials by default.

## Suggested Priority Order

1. Fix auth logout/user-scoped provider clearing.
2. Fix `AuthState.copyWith`.
3. Get `flutter test` green with analytics test overrides.
4. Guard protected routes/providers.
5. Normalize repository abstraction usage.
6. Reduce analyzer noise.
7. Mask debug bearer logs.

## Validation Plan

After fixes, run:

```bash
flutter analyze
flutter test
```

Add or update tests for:

- auth state clear semantics
- logout transition with `loading` hop
- protected route/provider guest behavior
- repository override behavior
- voice FAB state reset

## Current Worktree Note

At review time, the mobile worktree already had unrelated local changes:

- `pubspec.lock`
- `android/build/`
- `docs/BLOG_API_MOBILE.md`
- `docs/MOBILE_EVENT_FILTERS_INTEGRATION.md`

Those were not part of this review and were not modified.
