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
5. Customer/business multi-step registration form copy.
6. Active Home surface copy.
7. Search and filter user-facing copy.
8. Event browse, core detail, and deep detail subwidget copy.
9. Active booking checkout/cart/order confirmation copy.
10. Booking management list/detail/ticket/QR copy.
11. Legacy booking checkout/success copy.
12. Profile screen, account edit, and saved participants copy.
13. Core Messages inbox/detail/shared-widget copy.

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

### Profile And Account Subpages

Migrated:

- `lib/features/profile/presentation/screens/profile_screen.dart`
- `lib/features/profile/presentation/screens/profile_edit_screen.dart`
- `lib/features/profile/presentation/screens/saved_participants_screen.dart`

Covered:

- Authenticated Profile menu titles/subtitles, unauthenticated prompt, stats labels, profile-completion card labels, logout dialog, FAQ failure snackbar, and avatar upload snackbars.
- Account edit page title, login-required state, personal-info form labels/validators, date picker labels, email read-only helper, save/update copy, and change-password dialog copy.
- Saved participants page title, add/retry/error/empty states, personalization notice, participant create/update/delete snackbars, relationship dropdown labels, form labels/validators, date picker actions, and locale-aware participant date display.

Not covered in this slice:

- Backend-owned user data such as names, emails, rank labels/icons, participant display names, API validation messages, and API error response bodies remain displayed as returned by their source.

### Core Messages Inbox And Detail

Migrated:

- `lib/features/messages/presentation/screens/conversations_list_screen.dart`
- `lib/features/messages/presentation/screens/conversation_detail_screen.dart`
- `lib/features/messages/presentation/widgets/conversation_filters_bar.dart`
- `lib/features/messages/presentation/widgets/conversation_tile.dart`
- `lib/features/messages/presentation/widgets/message_composer.dart`
- `lib/features/messages/presentation/widgets/message_bubble.dart`
- `lib/features/messages/presentation/widgets/report_conversation_sheet.dart`

Covered:

- Messages tab titles, unread badges, new-message/contact/support/broadcast FAB labels, empty states, retry/error labels, report status/reason labels, and admin report list fallback/status labels.
- Conversation filters search hint, reset chip, unread/status/period/reason chips.
- Conversation detail load error, close/reopen/report menus, read-only banner, closed-conversation notice, empty thread copy, and close-confirmation dialog.
- Message composer placeholder and closed state.
- Message bubble deleted/edited copy, edit/copy/delete actions, and locale-aware relative/date labels in conversation tiles.
- Report conversation sheet title/subtitle, reason/comment labels, validation messages, submit/cancel/success copy, and support-ticket follow-up snackbar.

Not covered in this slice:

- The large `new_conversation_form.dart` create-message flow still has hard-coded copy and should get its own focused pass.
- Broadcast detail/create flows, support detail, vendor/admin new conversation screens, and admin report detail moderation copy still need follow-up migration.
- Backend-owned conversation subjects, message bodies, event titles, user/org names, participant names, API error response bodies, and system message content remain displayed as returned by their source.

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

The large customer/business registration forms are covered in the registration slices below.

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

### Customer And Business Registration Forms

Migrated:

- `lib/features/auth/presentation/screens/customer_register_screen.dart`
- `lib/features/auth/presentation/screens/business_register_screen.dart`
- `lib/features/auth/presentation/widgets/personal_info_form.dart`
- `lib/features/auth/presentation/widgets/otp_verification_form.dart`
- `lib/features/auth/presentation/widgets/company_info_form.dart`
- `lib/features/auth/presentation/widgets/usage_mode_form.dart`
- `lib/features/auth/presentation/widgets/terms_acceptance_form.dart`
- `lib/features/auth/presentation/widgets/company_autocomplete.dart`
- `lib/features/auth/presentation/widgets/organization_type_card.dart`
- `lib/features/auth/presentation/widgets/password_strength_indicator.dart`
- `lib/features/auth/presentation/widgets/step_indicator.dart`
- `lib/features/auth/presentation/utils/auth_registration_l10n.dart`

Covered:

- Customer email/code/profile/terms flow labels, validators, step labels, snackbars, and success/errors.
- Business personal info, OTP, organization type, company autocomplete, company details, usage mode, terms summary, success dialog, and cancel dialog.
- Shared registration-specific helpers for localized organization type and usage mode labels/descriptions.
- Locale-aware date display for customer birth dates.

### Active Home Surface

Migrated:

- `lib/features/home/presentation/screens/home_screen.dart`
- `lib/features/home/presentation/screens/city_detail_screen.dart`
- `lib/features/home/presentation/widgets/contextual_hero.dart`
- `lib/features/home/presentation/widgets/home_categories_section.dart`
- `lib/features/home/presentation/widgets/event_card.dart`
- `lib/features/home/presentation/widgets/countdown_event_card.dart`
- `lib/features/home/presentation/widgets/event_stories.dart`
- `lib/features/home/presentation/widgets/ads_banners_section.dart`
- `lib/features/home/presentation/widgets/home_cities_section.dart`
- `lib/features/home/presentation/widgets/category_filter_chips.dart`
- `lib/features/home/presentation/widgets/quick_filters.dart`
- `lib/features/search/presentation/widgets/home_search_pill.dart`
- `lib/features/home/presentation/utils/home_l10n_formatters.dart`

Covered:

- Home app bar tooltips, section titles, empty states, web CTA copy, city section fallbacks, and city detail labels.
- Contextual hero greetings/titles/subtitles for time, day, season, and city variants.
- Home category section title and semantics.
- Event card price/date/organizer/private badge copy.
- Countdown urgency labels, remaining-spots labels, CTA, and countdown/date text.
- Stories title, new badge, CTA, booking/discovery labels, and friendly dates.
- Ads section title and fallback banner copy.
- Home search pill placeholders and active-filter labels.

Not covered in this slice:

- Disabled/legacy Home widgets that are not mounted by `home_screen.dart`, such as `recommended_section.dart`, `personalized_section.dart`, `partner_highlight.dart`, and `native_ad_card.dart`.

### Search And Filters

Migrated:

- `lib/features/search/presentation/screens/search_screen.dart`
- `lib/features/search/presentation/screens/filter_screen.dart`
- `lib/features/search/presentation/widgets/active_filter_chips.dart`
- `lib/features/search/presentation/widgets/airbnb_search_bar.dart`
- `lib/features/search/presentation/widgets/airbnb_search_sheet.dart`
- `lib/features/search/presentation/widgets/filter_bottom_sheet.dart`
- `lib/features/search/presentation/widgets/filter_shared_components.dart`
- `lib/features/search/presentation/widgets/home_search_pill.dart`
- `lib/features/search/presentation/widgets/save_search_sheet.dart`
- `lib/features/search/presentation/utils/search_l10n.dart`

Covered:

- Search screen app bar, save-search CTA states, result counts, sorting sheet, empty states, retry/end-of-list copy, alert/save success toasts, and active filter chips.
- Compact and expanded search bars, quick filters, where/when/what panels, category/search hints, location permission errors, geolocation radius labels, and search action labels.
- Filter bottom sheet section titles, search/city/category autocomplete empty states, location/date/budget/audience/format/availability/location-type/sort labels, footer action count, and clear actions.
- Save-search sheet title, subtitle, summary prefix, default name, name validation, notification toggles, cancel/save buttons, and locale-aware date summary.
- Shared search l10n helpers for date, price, sort, location type, radius, and action labels.

Not covered in this slice:

- `lib/features/search/domain/models/event_filter.dart` still has legacy context-free French label getters (`dateFilterLabel`, `priceFilterLabel`). Newly migrated Search UI and the current event list/map batch avoid them, but other older surfaces may still show those values.

### Event Browse And Core Detail

Migrated:

- `lib/features/events/presentation/screens/event_list_screen.dart`
- `lib/features/events/presentation/screens/map_view_screen.dart`
- `lib/features/events/presentation/widgets/map_event_card.dart`
- `lib/features/events/presentation/screens/event_detail_screen.dart`
- `lib/features/events/presentation/widgets/detail/event_compact_header.dart`
- `lib/features/events/presentation/widgets/detail/event_social_proof.dart`
- `lib/features/events/presentation/utils/event_l10n.dart`

Covered:

- Event list title, search hint, quick filter chips, filter count label, empty/error states, end-of-list copy, alert/save success toasts, and retry/clear buttons.
- Map geolocation error, map marker free label, grouped-events sheet title, quick filter chips, loading pill, empty-map Petit Boo helper, map card price label, and active filter chip labels.
- Core detail error state, selected date label, soon-available date notice, about/pricing/characteristics sections, read-more/show-less label, discovery price states, cart choice sheet, booking validation snackbars, all-dates modal title, full/choose slot labels, compact header ticketing/discovery chip, fallback place/category/audience labels, and featured/recommended/new badges.
- Shared event l10n helpers for event categories, audiences, date-at-time, filter count, all-dates count, and map grouped-event count.

### Deep Event Detail Subwidgets

Migrated:

- `lib/features/events/presentation/widgets/detail/event_date_selector.dart`
- `lib/features/events/presentation/widgets/detail/event_ticket_card.dart`
- `lib/features/events/presentation/widgets/detail/event_sticky_booking_bar.dart`
- `lib/features/events/presentation/widgets/detail/event_practical_info.dart`
- `lib/features/events/presentation/widgets/detail/event_accessibility_section.dart`
- `lib/features/events/presentation/widgets/detail/event_location_map.dart`
- `lib/features/events/presentation/widgets/detail/event_indicative_prices.dart`
- `lib/features/events/presentation/widgets/detail/practical_info_card.dart`
- `lib/features/events/presentation/widgets/detail/practical_info_sheet.dart`
- `lib/features/events/presentation/widgets/detail/event_gallery_grid.dart`
- `lib/features/events/presentation/widgets/detail/event_hero_gallery.dart`
- `lib/features/events/presentation/widgets/detail/event_share_sheet.dart`
- `lib/features/events/presentation/widgets/detail/event_password_sheet.dart`
- `lib/features/events/presentation/widgets/detail/event_locked_view.dart`
- `lib/features/events/presentation/widgets/detail/event_organizer_card.dart`
- `lib/features/events/presentation/widgets/detail/event_similar_carousel.dart`
- `lib/features/events/presentation/widgets/detail/event_qa_section.dart`
- `lib/features/events/presentation/screens/event_questions_screen.dart`
- `lib/features/events/presentation/widgets/detail/ask_question_sheet.dart`
- `lib/features/events/presentation/widgets/detail/question_card.dart`
- `lib/features/events/presentation/utils/event_l10n.dart`

Covered:

- Date-selector headers, empty states, view-all count, full/spots-remaining labels, and locale-aware slot date ranges.
- Ticket card price/free/sold-out/low-stock labels, show-more/show-less controls, ticket section title, and selected-ticket summaries.
- Sticky booking bar sold-out state, total label, date/spots/capacity labels, view-dates chip, reminder CTA states, external-booking CTA, and indicative price label.
- Practical-info, accessibility, location-map, quick-action sheet, action labels, service/accessibility feature labels, address-copy snackbar, and Google Maps CTA.
- Gallery empty states, view-video CTA, view-all-photos CTA, share text, password/private-event sheet, members-only sheet, and locked preview fallback copy.
- Organizer card labels, verification status, event/follower counts, contact/profile CTAs, platform attribution, and similar-events carousel copy.
- Event Q&A preview, full questions screen, ask-question sheet, question status labels, official-answer/helpful labels, empty/error/end states, and vote/submit snackbars.
- Shared event l10n helpers for question statuses, backend-coded service/accessibility labels, and locale-aware slot date ranges.

Not covered in this slice:

- Backend-owned event content such as titles, descriptions, ticket names/descriptions, organizer names, venue type labels, API-provided question/answer text, and API-provided relative dates remain displayed as returned by the backend.
- French text that remains in comments or enum/data matching logic was left alone because it is not visible UI copy.

### Active Booking Checkout And Cart

Migrated:

- `lib/features/booking/presentation/screens/checkout_screen.dart`
- `lib/features/booking/presentation/screens/order_cart_screen.dart`
- `lib/features/booking/presentation/screens/order_success_screen.dart`
- `lib/features/booking/presentation/widgets/cart_summary_section.dart`
- `lib/features/booking/presentation/widgets/participant_form_card.dart`
- `lib/features/booking/presentation/widgets/participant_forms_section.dart`
- `lib/features/booking/presentation/widgets/participants_overview_block.dart`
- `lib/features/booking/presentation/utils/booking_l10n.dart`

Covered:

- Checkout/order summary title, buyer/contact form labels, validation errors, terms sentence, participant validation errors, payment CTAs, and Stripe cancel fallback.
- Active cart app bar, cart/seat hold timers, clear-cart dialog, hold-info dialog, empty cart state, participant instructions, saved-participant picker, buyer form, terms, footer total/ticket count, and order submit validation errors.
- Cart summary section title, total labels, per-ticket labels, remove action, and locale-aware slot dates.
- Participant card prefill labels, relationship labels, birth-date picker labels, required-field messages, optional contact section, save-participant label, and status pills.
- Participant overview saved-count/progress labels, profile prefill actions, saved participant action, and incomplete-profile warning.
- Order confirmation title, reference label, created-bookings header, ticket-generation fallback, navigation buttons, and booking fallback title.

Not covered in this slice:

- Booking list/detail/ticket-management surfaces under `lib/features/booking/presentation/screens` and related widgets.
- Backend-owned booking/event/ticket/user content such as event titles, ticket names, UUIDs, and API error messages returned by `ApiResponseHandler`.
- Context-free legacy helpers such as `CheckoutParams.formattedDate`; the migrated UI now uses `context.bookingSlotLabel(...)` where the active flow needs locale-aware display.

### Booking Management And Tickets

Migrated:

- `lib/features/booking/presentation/controllers/booking_list_controller.dart`
- `lib/features/booking/presentation/screens/bookings_list_screen.dart`
- `lib/features/booking/presentation/screens/booking_detail_screen.dart`
- `lib/features/booking/presentation/screens/ticket_detail_screen.dart`
- `lib/features/booking/presentation/widgets/booking_detail_summary_card.dart`
- `lib/features/booking/presentation/widgets/booking_hero_header.dart`
- `lib/features/booking/presentation/widgets/booking_list_card.dart`
- `lib/features/booking/presentation/widgets/booking_status_badge.dart`
- `lib/features/booking/presentation/widgets/event_info_card.dart`
- `lib/features/booking/presentation/widgets/fullscreen_qr_sheet.dart`
- `lib/features/booking/presentation/widgets/quick_qr_bottom_sheet.dart`
- `lib/features/booking/presentation/widgets/ticket_preview_card.dart`
- `lib/features/booking/presentation/utils/booking_l10n.dart`

Covered:

- Bookings list title, sort sheet, filter tabs, load error, empty states, and explore CTA.
- Booking detail not-found state, share text, calendar export description/result snackbars, cancel dialog, cancel errors/success snackbar, download-all ticket snackbars, detail action buttons, additional-info header, and localized age display.
- Ticket detail title/position, not-found state, share text, download snackbars/button, participant labels, ticket/event fallbacks, ticket status labels, localized age display, and QR/fullscreen hints.
- Booking/ticket status badge labels, summary/event section headers, total/free/discount labels, per-ticket pricing text, view-event CTA, and QR bottom-sheet close text.

Not covered in this slice:

- Backend-owned booking/event/ticket/user content such as event titles, ticket names, organizer names, UUIDs, backend error text, and storage display locations remain displayed as returned by their source.

### Legacy Booking Checkout And Success

Migrated:

- `lib/features/booking/presentation/controllers/booking_flow_controller.dart`
- `lib/features/booking/presentation/screens/booking_screen.dart`
- `lib/features/booking/presentation/screens/booking_slot_selection_screen.dart`
- `lib/features/booking/presentation/screens/booking_participant_screen.dart`
- `lib/features/booking/presentation/screens/booking_payment_screen.dart`
- `lib/features/booking/presentation/screens/booking_confirmation_screen.dart`
- `lib/features/booking/presentation/screens/booking_success_screen.dart`
- `lib/features/booking/presentation/widgets/booking_summary_card.dart`
- `lib/features/booking/presentation/widgets/booking_stepper_header.dart`
- `lib/features/booking/presentation/utils/booking_l10n.dart`

Covered:

- Legacy `/booking/:activityId` placeholder screen title/body.
- Slot selection title, empty state, selected-slot date formatting, participant count label, quantity pluralization, and continue CTA.
- Contact-info screen title, section labels, fields, helper note, and free/paid CTA labels.
- Context-free controller validation errors via `bookingCachedL10n()` and `AppLocaleCache`.
- Simulated payment screen title, card labels, pay CTA, mounted navigation guard, and null-safe total amount display.
- Legacy confirmation title/body, ticket ID/status labels, ticket-generation fallback, and home CTA.
- Separate booking success screen title/subtitle, reference label/copy snackbar/tooltip, ticket section/loading/placeholder copy, email notice, navigation buttons, and locale-aware event date display.

Not covered in this slice:

- Legacy checkout still uses its existing mock/legacy slot source behavior. This batch only localized the visible UI and small async/null-safety rough edges.
- Backend-owned booking/event/ticket/user content such as event titles, ticket names, QR/reference values, UUIDs, and backend error text remain displayed as returned by their source.

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

Latest focused customer/business registration check:

```sh
flutter analyze --no-pub --no-fatal-infos lib/features/auth/presentation/screens/customer_register_screen.dart lib/features/auth/presentation/screens/business_register_screen.dart lib/features/auth/presentation/widgets/personal_info_form.dart lib/features/auth/presentation/widgets/otp_verification_form.dart lib/features/auth/presentation/widgets/company_info_form.dart lib/features/auth/presentation/widgets/usage_mode_form.dart lib/features/auth/presentation/widgets/terms_acceptance_form.dart lib/features/auth/presentation/widgets/password_strength_indicator.dart lib/features/auth/presentation/widgets/organization_type_card.dart lib/features/auth/presentation/widgets/company_autocomplete.dart lib/features/auth/presentation/widgets/step_indicator.dart lib/features/auth/presentation/utils/auth_registration_l10n.dart lib/l10n/generated lib/core/l10n
flutter test --no-pub test/core/l10n/app_locale_test.dart
```

Result:

- No analyzer issues found.
- Locale tests passed.

Latest focused active Home check:

```sh
flutter analyze --no-pub --no-fatal-infos lib/features/home/presentation/screens/home_screen.dart lib/features/home/presentation/screens/city_detail_screen.dart lib/features/home/presentation/widgets/contextual_hero.dart lib/features/home/presentation/widgets/home_categories_section.dart lib/features/home/presentation/widgets/event_card.dart lib/features/home/presentation/widgets/countdown_event_card.dart lib/features/home/presentation/widgets/event_stories.dart lib/features/home/presentation/widgets/ads_banners_section.dart lib/features/home/presentation/widgets/quick_filters.dart lib/features/home/presentation/widgets/category_filter_chips.dart lib/features/home/presentation/widgets/home_cities_section.dart lib/features/search/presentation/widgets/home_search_pill.dart lib/features/home/presentation/utils/home_l10n_formatters.dart lib/l10n/generated lib/core/l10n
flutter test --no-pub test/core/l10n/app_locale_test.dart
```

Result:

- Analyzer returned exit code 0.
- Analyzer output is only info-level existing style/deprecation notes in touched Home files, mainly `withOpacity`, `prefer_const_*`, and `sized_box_for_whitespace`.
- Locale tests passed.

Latest focused Search/filter check:

```sh
flutter gen-l10n
dart format lib/features/search/presentation/utils/search_l10n.dart lib/features/search/presentation/widgets/active_filter_chips.dart lib/features/search/presentation/widgets/home_search_pill.dart lib/features/search/presentation/screens/search_screen.dart lib/features/search/presentation/widgets/airbnb_search_bar.dart lib/features/search/presentation/widgets/filter_bottom_sheet.dart lib/features/search/presentation/widgets/save_search_sheet.dart lib/features/search/presentation/widgets/airbnb_search_sheet.dart lib/features/search/presentation/widgets/filter_shared_components.dart lib/features/search/presentation/screens/filter_screen.dart lib/l10n/generated/app_localizations.dart lib/l10n/generated/app_localizations_en.dart lib/l10n/generated/app_localizations_fr.dart
flutter analyze --no-pub --no-fatal-infos lib/features/search/presentation lib/l10n/generated lib/core/l10n
flutter test --no-pub test/core/l10n/app_locale_test.dart
```

Result:

- Analyzer returned exit code 0.
- Analyzer output is only info-level `prefer_const_constructors` notes in `airbnb_search_bar.dart`.
- Locale tests passed.

Latest focused Event browse/core-detail check:

```sh
flutter gen-l10n
dart format lib/features/events/presentation/utils/event_l10n.dart lib/features/events/presentation/screens/event_list_screen.dart lib/features/events/presentation/screens/map_view_screen.dart lib/features/events/presentation/widgets/map_event_card.dart lib/features/events/presentation/screens/event_detail_screen.dart lib/features/events/presentation/widgets/detail/event_compact_header.dart lib/features/events/presentation/widgets/detail/event_social_proof.dart lib/l10n/generated/app_localizations.dart lib/l10n/generated/app_localizations_en.dart lib/l10n/generated/app_localizations_fr.dart
flutter analyze --no-pub --no-fatal-infos lib/features/events/presentation/screens/event_list_screen.dart lib/features/events/presentation/screens/map_view_screen.dart lib/features/events/presentation/widgets/map_event_card.dart lib/features/events/presentation/screens/event_detail_screen.dart lib/features/events/presentation/widgets/detail/event_compact_header.dart lib/features/events/presentation/widgets/detail/event_social_proof.dart lib/features/events/presentation/utils/event_l10n.dart lib/l10n/generated lib/core/l10n
flutter test --no-pub test/core/l10n/app_locale_test.dart
```

Result:

- Analyzer returned exit code 0.
- Analyzer output is only info-level existing lint/style debt in touched event files: `prefer_const_constructors`, `withOpacity`, and `use_build_context_synchronously`.
- Locale tests passed.

Latest focused Deep Event detail check:

```sh
flutter gen-l10n
dart format lib/features/events/presentation/utils/event_l10n.dart lib/features/events/presentation/widgets/detail/event_date_selector.dart lib/features/events/presentation/widgets/detail/event_ticket_card.dart lib/features/events/presentation/widgets/detail/event_sticky_booking_bar.dart lib/features/events/presentation/widgets/detail/event_practical_info.dart lib/features/events/presentation/widgets/detail/event_accessibility_section.dart lib/features/events/presentation/widgets/detail/practical_info_sheet.dart lib/features/events/presentation/widgets/detail/practical_info_card.dart lib/features/events/presentation/widgets/detail/event_location_map.dart lib/features/events/presentation/widgets/detail/event_indicative_prices.dart lib/features/events/presentation/widgets/detail/event_gallery_grid.dart lib/features/events/presentation/widgets/detail/event_hero_gallery.dart lib/features/events/presentation/widgets/detail/event_share_sheet.dart lib/features/events/presentation/widgets/detail/event_password_sheet.dart lib/features/events/presentation/widgets/detail/event_locked_view.dart lib/features/events/presentation/widgets/detail/event_organizer_card.dart lib/features/events/presentation/widgets/detail/event_similar_carousel.dart lib/features/events/presentation/widgets/detail/event_qa_section.dart lib/features/events/presentation/screens/event_questions_screen.dart lib/features/events/presentation/widgets/detail/ask_question_sheet.dart lib/features/events/presentation/widgets/detail/question_card.dart lib/l10n/generated/app_localizations.dart lib/l10n/generated/app_localizations_en.dart lib/l10n/generated/app_localizations_fr.dart
flutter analyze --no-pub --no-fatal-infos --no-fatal-warnings lib/features/events/presentation/utils/event_l10n.dart lib/features/events/presentation/widgets/detail/event_date_selector.dart lib/features/events/presentation/widgets/detail/event_ticket_card.dart lib/features/events/presentation/widgets/detail/event_sticky_booking_bar.dart lib/features/events/presentation/widgets/detail/event_practical_info.dart lib/features/events/presentation/widgets/detail/event_accessibility_section.dart lib/features/events/presentation/widgets/detail/practical_info_sheet.dart lib/features/events/presentation/widgets/detail/practical_info_card.dart lib/features/events/presentation/widgets/detail/event_location_map.dart lib/features/events/presentation/widgets/detail/event_indicative_prices.dart lib/features/events/presentation/widgets/detail/event_gallery_grid.dart lib/features/events/presentation/widgets/detail/event_hero_gallery.dart lib/features/events/presentation/widgets/detail/event_share_sheet.dart lib/features/events/presentation/widgets/detail/event_password_sheet.dart lib/features/events/presentation/widgets/detail/event_locked_view.dart lib/features/events/presentation/widgets/detail/event_organizer_card.dart lib/features/events/presentation/widgets/detail/event_similar_carousel.dart lib/features/events/presentation/widgets/detail/event_qa_section.dart lib/features/events/presentation/screens/event_questions_screen.dart lib/features/events/presentation/widgets/detail/ask_question_sheet.dart lib/features/events/presentation/widgets/detail/question_card.dart lib/l10n/generated lib/core/l10n
flutter test --no-pub test/core/l10n/app_locale_test.dart
```

Result:

- Analyzer returned exit code 0.
- Analyzer output is warning-level existing nullability/dead-code cleanup in `event_location_map.dart`, `event_practical_info.dart`, and `event_similar_carousel.dart`.
- Locale tests passed.

Latest focused Active Booking checkout/cart check:

```sh
flutter gen-l10n
dart format lib/features/booking/presentation/utils/booking_l10n.dart lib/features/booking/presentation/screens/checkout_screen.dart lib/features/booking/presentation/screens/order_cart_screen.dart lib/features/booking/presentation/screens/order_success_screen.dart lib/features/booking/presentation/widgets/cart_summary_section.dart lib/features/booking/presentation/widgets/participant_form_card.dart lib/features/booking/presentation/widgets/participant_forms_section.dart lib/features/booking/presentation/widgets/participants_overview_block.dart
flutter analyze --no-pub --no-fatal-infos --no-fatal-warnings lib/features/booking/presentation/utils/booking_l10n.dart lib/features/booking/presentation/screens/checkout_screen.dart lib/features/booking/presentation/screens/order_cart_screen.dart lib/features/booking/presentation/screens/order_success_screen.dart lib/features/booking/presentation/widgets/cart_summary_section.dart lib/features/booking/presentation/widgets/participant_form_card.dart lib/features/booking/presentation/widgets/participant_forms_section.dart lib/features/booking/presentation/widgets/participants_overview_block.dart lib/l10n/generated lib/core/l10n
flutter test --no-pub test/core/l10n/app_locale_test.dart
```

Result:

- Analyzer returned exit code 0.
- No issues found in the focused booking slice.
- Locale tests passed.

Latest focused Booking management/tickets check:

```sh
flutter gen-l10n
dart format lib/features/booking/presentation/utils/booking_l10n.dart lib/features/booking/presentation/controllers/booking_list_controller.dart lib/features/booking/presentation/screens/bookings_list_screen.dart lib/features/booking/presentation/screens/booking_detail_screen.dart lib/features/booking/presentation/screens/ticket_detail_screen.dart lib/features/booking/presentation/widgets/booking_detail_summary_card.dart lib/features/booking/presentation/widgets/ticket_preview_card.dart lib/features/booking/presentation/widgets/quick_qr_bottom_sheet.dart lib/features/booking/presentation/widgets/fullscreen_qr_sheet.dart lib/features/booking/presentation/widgets/event_info_card.dart lib/features/booking/presentation/widgets/booking_hero_header.dart lib/features/booking/presentation/widgets/booking_status_badge.dart lib/l10n/generated/app_localizations.dart lib/l10n/generated/app_localizations_en.dart lib/l10n/generated/app_localizations_fr.dart
flutter analyze --no-pub --no-fatal-infos --no-fatal-warnings lib/features/booking/presentation/utils/booking_l10n.dart lib/features/booking/presentation/controllers/booking_list_controller.dart lib/features/booking/presentation/screens/bookings_list_screen.dart lib/features/booking/presentation/screens/booking_detail_screen.dart lib/features/booking/presentation/screens/ticket_detail_screen.dart lib/features/booking/presentation/widgets/booking_detail_summary_card.dart lib/features/booking/presentation/widgets/ticket_preview_card.dart lib/features/booking/presentation/widgets/quick_qr_bottom_sheet.dart lib/features/booking/presentation/widgets/fullscreen_qr_sheet.dart lib/features/booking/presentation/widgets/event_info_card.dart lib/features/booking/presentation/widgets/booking_hero_header.dart lib/features/booking/presentation/widgets/booking_status_badge.dart lib/l10n/generated lib/core/l10n
flutter test --no-pub test/core/l10n/app_locale_test.dart
```

Result:

- Analyzer returned exit code 0.
- No issues found in the focused booking management/tickets slice.
- Locale tests passed.

Latest focused Legacy Booking checkout/success check:

```sh
flutter gen-l10n
dart format lib/features/booking/presentation/controllers/booking_flow_controller.dart lib/features/booking/presentation/screens/booking_screen.dart lib/features/booking/presentation/screens/booking_slot_selection_screen.dart lib/features/booking/presentation/screens/booking_participant_screen.dart lib/features/booking/presentation/screens/booking_payment_screen.dart lib/features/booking/presentation/screens/booking_confirmation_screen.dart lib/features/booking/presentation/screens/booking_success_screen.dart lib/features/booking/presentation/widgets/booking_summary_card.dart lib/features/booking/presentation/widgets/booking_stepper_header.dart lib/features/booking/presentation/utils/booking_l10n.dart lib/l10n/generated/app_localizations.dart lib/l10n/generated/app_localizations_en.dart lib/l10n/generated/app_localizations_fr.dart
flutter analyze --no-pub --no-fatal-infos --no-fatal-warnings lib/features/booking/presentation/controllers/booking_flow_controller.dart lib/features/booking/presentation/screens/booking_screen.dart lib/features/booking/presentation/screens/booking_slot_selection_screen.dart lib/features/booking/presentation/screens/booking_participant_screen.dart lib/features/booking/presentation/screens/booking_payment_screen.dart lib/features/booking/presentation/screens/booking_confirmation_screen.dart lib/features/booking/presentation/screens/booking_success_screen.dart lib/features/booking/presentation/widgets/booking_summary_card.dart lib/features/booking/presentation/widgets/booking_stepper_header.dart lib/features/booking/presentation/utils/booking_l10n.dart
flutter test --no-pub test/core/l10n/app_locale_test.dart
```

Result:

- Analyzer returned exit code 0.
- No issues found in the focused legacy booking checkout/success slice.
- Locale tests passed.

Latest focused Profile/account subpages check:

```sh
flutter gen-l10n
dart format lib/features/profile/presentation/screens/profile_screen.dart lib/features/profile/presentation/screens/profile_edit_screen.dart lib/features/profile/presentation/screens/saved_participants_screen.dart lib/l10n/generated/app_localizations.dart lib/l10n/generated/app_localizations_en.dart lib/l10n/generated/app_localizations_fr.dart
flutter analyze --no-pub --no-fatal-infos --no-fatal-warnings lib/features/profile/presentation/screens/profile_screen.dart lib/features/profile/presentation/screens/profile_edit_screen.dart lib/features/profile/presentation/screens/saved_participants_screen.dart lib/l10n/generated lib/core/l10n
flutter test --no-pub test/core/l10n/app_locale_test.dart
git diff --check
```

Result:

- Analyzer returned exit code 0.
- No issues found in the focused profile/account subpages slice.
- Locale tests passed.
- Whitespace check passed.

Latest focused Core Messages inbox/detail check:

```sh
flutter gen-l10n
dart format lib/features/messages/presentation/screens/conversations_list_screen.dart lib/features/messages/presentation/screens/conversation_detail_screen.dart lib/features/messages/presentation/widgets/conversation_filters_bar.dart lib/features/messages/presentation/widgets/conversation_tile.dart lib/features/messages/presentation/widgets/message_composer.dart lib/features/messages/presentation/widgets/message_bubble.dart lib/features/messages/presentation/widgets/report_conversation_sheet.dart lib/l10n/generated/app_localizations.dart lib/l10n/generated/app_localizations_en.dart lib/l10n/generated/app_localizations_fr.dart
flutter analyze --no-pub --no-fatal-infos --no-fatal-warnings lib/features/messages/presentation/screens/conversations_list_screen.dart lib/features/messages/presentation/screens/conversation_detail_screen.dart lib/features/messages/presentation/widgets/conversation_filters_bar.dart lib/features/messages/presentation/widgets/conversation_tile.dart lib/features/messages/presentation/widgets/message_composer.dart lib/features/messages/presentation/widgets/message_bubble.dart lib/features/messages/presentation/widgets/report_conversation_sheet.dart lib/l10n/generated lib/core/l10n
flutter test --no-pub test/core/l10n/app_locale_test.dart
git diff --check
```

Result:

- Analyzer returned exit code 0.
- No issues found in the focused core Messages inbox/detail slice.
- Locale tests passed.
- Whitespace check passed.

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
- Unrelated docs under `docs/`:
  - `docs/BLOG_API_MOBILE.md`
  - `docs/MOBILE_EVENT_FILTERS_INTEGRATION.md`
- Events/search files not touched by the active Home i18n slice were also observed dirty:
  - `lib/features/events/data/datasources/events_api_datasource.dart`
  - `lib/features/events/data/models/event_reference_data_dto.dart`
  - `lib/features/events/data/repositories/event_repository_impl.dart`
  - `lib/features/events/domain/repositories/event_repository.dart`
  - `lib/features/events/presentation/providers/event_providers.dart`
  - Event browse/core-detail and deep-detail files are now part of the i18n work:
    - `lib/features/events/presentation/screens/event_detail_screen.dart`
    - `lib/features/events/presentation/screens/event_list_screen.dart`
    - `lib/features/events/presentation/screens/map_view_screen.dart`
    - `lib/features/events/presentation/screens/event_questions_screen.dart`
    - `lib/features/events/presentation/widgets/detail/event_compact_header.dart`
    - `lib/features/events/presentation/widgets/detail/event_social_proof.dart`
    - `lib/features/events/presentation/widgets/detail/event_date_selector.dart`
    - `lib/features/events/presentation/widgets/detail/event_ticket_card.dart`
    - `lib/features/events/presentation/widgets/detail/event_sticky_booking_bar.dart`
    - `lib/features/events/presentation/widgets/detail/event_practical_info.dart`
    - `lib/features/events/presentation/widgets/detail/event_accessibility_section.dart`
    - `lib/features/events/presentation/widgets/detail/event_location_map.dart`
    - `lib/features/events/presentation/widgets/detail/event_indicative_prices.dart`
    - `lib/features/events/presentation/widgets/detail/practical_info_card.dart`
    - `lib/features/events/presentation/widgets/detail/practical_info_sheet.dart`
    - `lib/features/events/presentation/widgets/detail/event_gallery_grid.dart`
    - `lib/features/events/presentation/widgets/detail/event_hero_gallery.dart`
    - `lib/features/events/presentation/widgets/detail/event_share_sheet.dart`
    - `lib/features/events/presentation/widgets/detail/event_password_sheet.dart`
    - `lib/features/events/presentation/widgets/detail/event_locked_view.dart`
    - `lib/features/events/presentation/widgets/detail/event_organizer_card.dart`
    - `lib/features/events/presentation/widgets/detail/event_similar_carousel.dart`
    - `lib/features/events/presentation/widgets/detail/event_qa_section.dart`
    - `lib/features/events/presentation/widgets/detail/ask_question_sheet.dart`
    - `lib/features/events/presentation/widgets/detail/question_card.dart`
    - `lib/features/events/presentation/widgets/map_event_card.dart`
    - `lib/features/events/presentation/utils/event_l10n.dart`
  - `lib/features/events/data/models/search_suggestions_dto.dart`
  - `lib/features/search/domain/models/event_filter.dart`
  - `lib/features/search/presentation/providers/filter_provider.dart`
  - `lib/features/search/presentation/widgets/filter_bottom_sheet.dart`
  - `test/features/search/widgets/active_filter_chips_provider_test.dart`

Booking checkout/cart files are now part of the i18n work:

- `lib/features/booking/presentation/screens/checkout_screen.dart`
- `lib/features/booking/presentation/screens/order_cart_screen.dart`
- `lib/features/booking/presentation/screens/order_success_screen.dart`
- `lib/features/booking/presentation/widgets/cart_summary_section.dart`
- `lib/features/booking/presentation/widgets/participant_form_card.dart`
- `lib/features/booking/presentation/widgets/participant_forms_section.dart`
- `lib/features/booking/presentation/widgets/participants_overview_block.dart`
- `lib/features/booking/presentation/utils/booking_l10n.dart`

Booking management/ticket files are now part of the i18n work:

- `lib/features/booking/presentation/controllers/booking_list_controller.dart`
- `lib/features/booking/presentation/screens/bookings_list_screen.dart`
- `lib/features/booking/presentation/screens/booking_detail_screen.dart`
- `lib/features/booking/presentation/screens/ticket_detail_screen.dart`
- `lib/features/booking/presentation/widgets/booking_detail_summary_card.dart`
- `lib/features/booking/presentation/widgets/booking_hero_header.dart`
- `lib/features/booking/presentation/widgets/booking_list_card.dart`
- `lib/features/booking/presentation/widgets/booking_status_badge.dart`
- `lib/features/booking/presentation/widgets/event_info_card.dart`
- `lib/features/booking/presentation/widgets/fullscreen_qr_sheet.dart`
- `lib/features/booking/presentation/widgets/quick_qr_bottom_sheet.dart`
- `lib/features/booking/presentation/widgets/ticket_preview_card.dart`

Legacy booking checkout/success files are now part of the i18n work:

- `lib/features/booking/presentation/controllers/booking_flow_controller.dart`
- `lib/features/booking/presentation/screens/booking_screen.dart`
- `lib/features/booking/presentation/screens/booking_slot_selection_screen.dart`
- `lib/features/booking/presentation/screens/booking_participant_screen.dart`
- `lib/features/booking/presentation/screens/booking_payment_screen.dart`
- `lib/features/booking/presentation/screens/booking_confirmation_screen.dart`
- `lib/features/booking/presentation/screens/booking_success_screen.dart`
- `lib/features/booking/presentation/widgets/booking_summary_card.dart`
- `lib/features/booking/presentation/widgets/booking_stepper_header.dart`

Profile/account files are now part of the i18n work:

- `lib/features/profile/presentation/screens/profile_screen.dart`
- `lib/features/profile/presentation/screens/profile_edit_screen.dart`
- `lib/features/profile/presentation/screens/saved_participants_screen.dart`

Core Messages inbox/detail files are now part of the i18n work:

- `lib/features/messages/presentation/screens/conversations_list_screen.dart`
- `lib/features/messages/presentation/screens/conversation_detail_screen.dart`
- `lib/features/messages/presentation/widgets/conversation_filters_bar.dart`
- `lib/features/messages/presentation/widgets/conversation_tile.dart`
- `lib/features/messages/presentation/widgets/message_composer.dart`
- `lib/features/messages/presentation/widgets/message_bubble.dart`
- `lib/features/messages/presentation/widgets/report_conversation_sheet.dart`

Before committing or refining, review diffs by file instead of using bulk restore/reset commands.

## Where Work Stopped

Stopped after completing the core Messages inbox/detail slice.

Current stable stopping point:

- Locale infrastructure exists.
- Settings switch exists.
- API/legal/speech locale wiring exists.
- Hard-coded French date/number/speech/API locale scan is clean.
- Login, forgot password, OTP verification, and guest-restriction dialog copy is localized.
- Active register type selector, legacy simple register screen, and permission onboarding screens are localized.
- Customer and business multi-step registration forms are localized.
- Active Home surface chrome, hero, cards, stories, ads fallback, city detail, and Home search pill copy are localized.
- Search screen, search sheets, filter sheet, active chips, and save-search sheet copy are localized.
- Event list, map, map cards, core detail sections, core detail booking/cart sheet, compact header, and event badges are localized.
- Deep Event detail subwidgets are localized, including date/ticket/sticky booking controls, practical info, accessibility, location, gallery, share, password/private access, organizer/similar sections, Q&A preview, full questions screen, ask-question sheet, and question cards.
- Active Booking checkout, cart, cart summary, participant forms/overview, saved-participant picker, and order confirmation copy are localized.
- Booking management list/detail/ticket/QR copy is localized, including booking/ticket statuses, cancel/download/calendar/share UI, QR hints, and summary/event/tickets section chrome.
- Legacy Booking slot selection, contact details, simulated payment, confirmation, and success screens are localized.
- Profile screen, account edit, and saved participants copy is localized.
- Core Messages inbox/detail/shared-widget copy is localized, including filters, conversation tiles, composer, message bubble actions, report sheet, and admin report list labels.
- Direct hard-coded `featureName: '...'` / `featureName: "..."` scan under `lib/` is clean.
- Locale unit tests pass.

Next work should continue with either the remaining Messages create/admin/vendor/broadcast flows or Petit Boo chat/tool cards, not more locale plumbing.

## Remaining Task Queue

### 1. Migrate User-Facing Copy Feature By Feature

Recommended order:

1. Remaining Messages create/admin/vendor/broadcast flows.
2. Petit Boo chat and tool cards.
3. Memberships/partners/check-in/admin surfaces.

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
