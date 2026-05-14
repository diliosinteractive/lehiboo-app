# Mobile i18n Rollout Handoff

Last updated: 2026-05-14

## Goal

Support French and English in the Flutter mobile app with:

- User-selectable language: French or English.
- First-run default based on the device locale.
- Default to `en` when the device language is English.
- Default to `fr` when the device language is French.
- Fallback to `fr` for every other device language.
- Keep the app functional while translations are migrated incrementally.

French remains the source/fallback language because the app was French-first.

## Current Status

The localization infrastructure is in place and the first rollout slices are complete:

1. App-level localization setup.
2. Locale-aware dates, compact numbers, legal URLs, API language header, bottom nav, Settings language switch, and several shared/high-traffic widgets.
3. Auth entry/access copy for login, forgot password, OTP verification, the guest-restriction dialog, and current guest-guard feature names.
4. Registration entry and post-signup permission onboarding copy.

The app is not fully translated yet. Many screens still contain hard-coded French UI copy, but the app now has the wiring needed to migrate them screen by screen.

## Files And Systems Added

Core localization files:

- `l10n.yaml`
- `lib/l10n/app_fr.arb`
- `lib/l10n/app_en.arb`
- `lib/l10n/generated/app_localizations.dart`
- `lib/l10n/generated/app_localizations_fr.dart`
- `lib/l10n/generated/app_localizations_en.dart`
- `lib/core/l10n/app_locale.dart`
- `lib/core/l10n/l10n.dart`

Test added:

- `test/core/l10n/app_locale_test.dart`

Package/config updates:

- `pubspec.yaml`
  - Added `flutter_localizations`.
  - Added `flutter: generate: true`.
- `pubspec.lock`
  - `flutter_localizations` is now a direct main dependency.

## Implemented Behavior

Locale resolution lives in `lib/core/l10n/app_locale.dart`.

Rules:

- Saved language in `SharedPreferences` wins.
- If there is no saved language:
  - `en_*` device locale resolves to `en`.
  - `fr_*` device locale resolves to `fr`.
  - Anything else resolves to `fr`.

Storage key:

- `AppConstants.keyLanguage`

App root wiring:

- `lib/main.dart`
  - Watches `appLocaleControllerProvider`.
  - Passes `locale`, `supportedLocales`, and `localizationsDelegates` to `MaterialApp.router`.
  - Initializes both `fr_FR` and `en_US` date data.

Settings language switch:

- `lib/features/profile/presentation/screens/settings_screen.dart`
  - Adds a language row under Application.
  - Opens a bottom sheet with French and English.
  - Persists the selected language.
  - Rebuilds the app immediately through Riverpod.

API language:

- `lib/config/dio_client.dart`
  - Adds `LocaleHeaderInterceptor`.
  - Sends `Accept-Language` from `AppLocaleCache.languageCode`.

Legal links:

- `lib/shared/legal/legal_links.dart`
  - Legal labels are localized.
  - URLs now use `/fr/...` or `/en/...`.

Voice and speech:

- `lib/core/widgets/voice_fab/voice_fab.dart`
- `lib/features/petit_boo/presentation/widgets/chat_input_bar.dart`
  - Speech locale now follows the app locale.
  - Voice/Petit Boo input strings migrated for the touched surface.

Formatting helpers:

- `lib/core/l10n/l10n.dart`
  - `context.l10n`
  - `context.appLanguageCode`
  - `context.appLocaleName`
  - `context.appDateFormat(frPattern, enPattern: ...)`
  - `context.appCompactNumberFormat`

## Completed Migration Slices

### App Shell And Settings

Migrated:

- `lib/core/widgets/main_scaffold.dart`
- `lib/features/profile/presentation/screens/settings_screen.dart`
- `lib/shared/legal/legal_links.dart`

Covered:

- Bottom navigation labels.
- Settings section labels.
- Language picker.
- Legal document labels.
- Basic Settings snackbars/dialog strings.

### API And Backend-Facing Locale

Migrated:

- `lib/config/dio_client.dart`
- `lib/features/blog/data/datasources/blog_api_datasource.dart`
- `lib/features/events/data/datasources/events_api_datasource.dart`

Covered:

- Removed per-call forced `Accept-Language: fr`.
- Centralized language header through Dio.

### Locale-Aware Dates And Compact Numbers

Hard-coded French formatter scan is currently clean for these patterns:

```sh
rg -n "DateFormat\([^\n]*(fr_FR|fr)|NumberFormat\.[^\n]*locale:\s*'fr|locale:\s*'fr'|localeId:\s*['\"]fr_FR|Accept-Language': 'fr'" lib/features lib/core lib/shared lib/main.dart
```

Expected remaining match:

- `lib/core/l10n/l10n.dart`, because the helper accepts a `frPattern` argument.

Migrated areas include:

- Booking ticket/detail/QR cards.
- Check-in ticket summary.
- Event map cards and date selector.
- Search date filters.
- Messages date separators and broadcast dates.
- Membership dates and member counts.
- Organizer counts and event dates.
- Trip plans dates.
- Petit Boo tool card dates.

### Auth Entry And Guest Access

Migrated:

- `lib/features/auth/presentation/screens/login_screen.dart`
- `lib/features/auth/presentation/screens/forgot_password_screen.dart`
- `lib/features/auth/presentation/screens/otp_verification_screen.dart`
- `lib/features/auth/presentation/widgets/guest_restriction_dialog.dart`

Covered:

- Login form title, subtitle, labels, hints, validators, CTAs, and guest continue link.
- Forgot-password form and success state.
- OTP verification title, instructions, snackbars, verify/resend labels, and resend countdown.
- Guest-restriction dialog title, subtitle shell, inline login labels, validators, CTAs, close tooltip, and fallback incorrect-credentials message.
- All current `GuestGuard.check(...)` / `GuestRestrictionDialog.show(...)` feature-name values found under `lib/` now come from `context.l10n`.

Remaining in this area:

- Large customer/business multi-step registration forms still contain hard-coded French copy.

### Registration Entry And Permission Onboarding

Migrated:

- `lib/features/auth/presentation/screens/register_type_screen.dart`
- `lib/features/auth/presentation/screens/register_screen.dart`
- `lib/features/auth/presentation/screens/permission_location_screen.dart`
- `lib/features/auth/presentation/screens/permission_audio_screen.dart`
- `lib/features/auth/presentation/screens/permission_notifications_screen.dart`

Covered:

- Active `/register` account-type selector labels, descriptions, disabled badge, CTA, and login link.
- Legacy `/register-simple` labels, hints, validators, terms/privacy sentence, CTA, and login link.
- First-launch/post-signup permission explainer titles, intro copy, bullets, reassurance, CTA, and granted-state labels.

Remaining in this area:

- `lib/features/auth/presentation/screens/customer_register_screen.dart`
- `lib/features/auth/presentation/screens/business_register_screen.dart`
- `lib/features/auth/presentation/widgets/personal_info_form.dart`
- `lib/features/auth/presentation/widgets/otp_verification_form.dart`
- `lib/features/auth/presentation/widgets/company_info_form.dart`
- `lib/features/auth/presentation/widgets/usage_mode_form.dart`
- `lib/features/auth/presentation/widgets/terms_acceptance_form.dart`

## Verification Already Run

Passing:

```sh
flutter gen-l10n
flutter test test/core/l10n/app_locale_test.dart
```

Latest focused access-gate check:

```sh
flutter analyze --no-fatal-infos --no-fatal-warnings <auth/access touched files> lib/l10n/generated lib/core/l10n
```

Result:

- No analyzer errors.
- Remaining warning/info output is pre-existing cleanup debt in broad touched files:
  - Deprecated raw keyboard APIs in `otp_verification_screen.dart`.
  - Unused `isDiscovery` in `event_detail_screen.dart`.
  - Unused `_VendorPartnersTab` in `conversations_list_screen.dart`.
  - Existing `use_build_context_synchronously`, `withOpacity`, and `prefer_const_constructors` info-level notes.

Latest focused registration/onboarding check:

```sh
flutter analyze --no-fatal-infos lib/features/auth/presentation/screens/register_type_screen.dart lib/features/auth/presentation/screens/register_screen.dart lib/features/auth/presentation/screens/permission_location_screen.dart lib/features/auth/presentation/screens/permission_audio_screen.dart lib/features/auth/presentation/screens/permission_notifications_screen.dart lib/l10n/generated lib/core/l10n
```

Result:

- No issues found.

Targeted analyzer checks:

- Booking files no longer have analyzer errors after null-safety cleanup.
- Message/date-chip files no longer have the prior undefined `context` error.
- Remaining targeted analyzer output seen was only existing lint/info noise such as:
  - `withOpacity` deprecations.
  - `prefer_const_constructors`.

Full project analyzer:

```sh
flutter analyze
```

Still expected to fail because of pre-existing unrelated issues, especially stale overrides in:

- `test/features/booking/booking_flow_test.dart`

Earlier full analyzer errors included:

- `MockBookingRepository.createBooking` signature no longer matches `BookingRepository.createBooking`.
- `MockBookingRepository.cancelBooking` signature no longer matches `BookingRepository.cancelBooking`.

Do not treat those as introduced by the i18n work unless they changed since this handoff.

## Dirty Worktree Note

The worktree has unrelated dirty/untracked files. Do not assume everything in `git status` belongs to i18n.

Known unrelated or pre-existing dirty entries observed during this work:

- `.env.development`
- `android/build/`
- Some docs under `docs/`
- Home/thematique files that were already being worked on in the tree

Before committing or refining, review diffs by file instead of using bulk restore/reset commands.

## Where Work Stopped

Stopped after completing the registration entry and permission onboarding copy slice.

Current stable stopping point:

- Locale infrastructure exists.
- Settings switch exists.
- API/legal/speech locale wiring exists.
- Hard-coded French date/number/speech/API locale scan is clean.
- Login, forgot password, OTP verification, and guest-restriction dialog copy is localized.
- Active register type selector, legacy simple register screen, and permission onboarding screens are localized.
- Direct hard-coded `featureName: '...'` / `featureName: "..."` scan under `lib/` is clean.
- Locale unit tests pass.

Next work should continue with the large customer/business registration forms, not more locale plumbing.

## Remaining Task Queue

### 1. Migrate User-Facing Copy Feature By Feature

Recommended order:

1. Customer/business registration forms.
2. Home.
3. Search and filters.
4. Event list/detail.
5. Booking flow.
6. Profile/settings subpages.
7. Messages.
8. Petit Boo chat and tool cards.
9. Memberships/partners/check-in/admin surfaces.

For each screen:

- Move visible strings into `app_fr.arb` and `app_en.arb`.
- Regenerate with `flutter gen-l10n`.
- Use `context.l10n.<key>`.
- Avoid translating backend-owned content unless the backend/API returns localized content.

### 2. Add More Widget Tests

Useful focused tests:

- Settings language switch renders both languages.
- `MaterialApp` locale changes when provider changes.
- Bottom nav labels switch between French and English.
- Date helper formats a known date differently in `fr` vs `en`.

### 3. Audit Backend Content Boundaries

Some displayed text comes from API resources, not app strings.

For those:

- Confirm backend supports `Accept-Language`.
- Avoid duplicating backend content into ARB files.
- If a payload is not localized, keep the UI chrome localized and document the backend gap.

### 4. Optional iOS Native Locale Metadata

Generated localization docs mention declaring supported locales in iOS metadata.

Check whether `ios/Runner/Info.plist` should add localizations for:

- `fr`
- `en`

This was not changed in the current slice.

### 5. Clean Existing Analyzer Debt Separately

The i18n work should not be blocked on unrelated analyzer debt, but before a release branch it is worth fixing:

- Stale booking test mocks.
- Deprecated `withOpacity` uses.
- `prefer_const_*` lints in touched widgets.
- Existing `JsonKey` annotation warnings if the team wants a clean analyzer.

## Development Commands

Regenerate localization files:

```sh
flutter gen-l10n
```

Run focused locale tests:

```sh
flutter test test/core/l10n/app_locale_test.dart
```

Scan for forced French locale usage:

```sh
rg -n "DateFormat\([^\n]*(fr_FR|fr)|NumberFormat\.[^\n]*locale:\s*'fr|locale:\s*'fr'|localeId:\s*['\"]fr_FR|Accept-Language': 'fr'" lib/features lib/core lib/shared lib/main.dart
```

Run targeted analysis for recently touched i18n files instead of full-project analysis when triaging this branch:

```sh
flutter analyze lib/core/l10n lib/l10n/generated lib/main.dart lib/config/dio_client.dart lib/shared/legal/legal_links.dart
```

## Implementation Guidance For Next Agent

- Prefer incremental screen-level PRs over translating the whole app at once.
- Keep French ARB as the template/source file.
- Use descriptive ARB keys by feature, for example `authLoginTitle`, `searchNoResultsTitle`, `bookingPaymentCta`.
- For strings with dynamic values, use ARB placeholders.
- For plural-sensitive strings, prefer ARB plural syntax when counts can vary.
- For dates and compact numbers, use the helpers in `context` instead of calling `DateFormat(..., 'fr_FR')` or `NumberFormat.compact(locale: 'fr')` directly.
- If a formatter is needed outside widget context, use `AppLocaleCache.languageCode` and `AppLocaleCache.localeName`.
- Do not revert unrelated dirty files in the worktree.
