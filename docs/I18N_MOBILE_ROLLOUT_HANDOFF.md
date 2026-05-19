# Mobile i18n Rollout Handoff

Last updated: 2026-05-15

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
14. Shared Messages new-conversation flow copy.
15. Messages broadcast create/detail/tile copy.
16. Messages support detail and admin report moderation detail copy.
17. Legacy standalone Messages admin/vendor new-conversation screens.
18. Petit Boo chat shell and conversation history copy.
19. Petit Boo brain, quota/limit dialog, and toast copy.
20. Petit Boo tool schemas and shared tool-card copy.
21. Petit Boo event/booking/trip-specific tool cards and provider/API fallback errors.
22. Memberships, private events, invitations, and members-only gate copy.
23. Partner profile and followed-organizer copy.
24. Check-in scanner, manual entry, confirmation/blocked sheets, and vendor organization picker copy.
25. Remaining active UI surfaces: trip plans, reviews, gamification, alerts, favorites/favorite lists, notifications, reminders, onboarding, categories/thematiques, blog chrome, legal links, and shared error fallback copy.
26. Full hard-coded-string audit pass across all feature directories, shared/core widgets, routing shell, and context-free provider/domain fallbacks that can surface in UI.

Most active mobile UI chrome found in the latest audit is now localized. Remaining work should focus on backend/content localization contracts, mock/demo source data, generated-model default cleanup, and release QA.

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

- Shared create-message flow copy is covered in the Messages new-conversation slice below.
- Broadcast detail/create flows are covered in the Messages broadcast slice below.
- Support detail and admin report detail moderation copy are covered in the Messages support/admin-report slice below.
- Legacy standalone vendor/admin new conversation screens are covered in the legacy Messages create slice below.
- Backend-owned conversation subjects, message bodies, event titles, user/org names, participant names, API error response bodies, and system message content remain displayed as returned by their source.

### Messages New Conversation Flow

Migrated:

- `lib/features/messages/presentation/screens/new_conversation_screen.dart`
- `lib/features/messages/presentation/widgets/new_conversation_form.dart`

Covered:

- `/messages/new` booking/org/dashboard entry title, generic error fallback, retry CTA, and fallback organizer label.
- Shared new-conversation sheet title/subtitles, recipient labels, support recipient label, subject/message labels, hints, validation messages, cancel/send actions, and vendor support fallback subject.
- Support subject chips for booking issue, event question, payment issue, refund request, account issue, content report, and other.
- Dashboard organizer picker labels, search hint, empty state, helper text, required-recipient error, and no-result text.
- Admin user/org and vendor participant/partner recipient search sheets: titles, hints, error prefixes, empty states, and no-result text.

Not covered in this slice:

- Legacy standalone `admin_new_conversation_screen.dart` and `vendor_new_conversation_screen.dart`; the active shared `NewConversationForm.show(...)` path was targeted first.
- Support detail and admin report detail moderation copy are covered in the Messages support/admin-report slice below.
- Legacy standalone vendor/admin new-conversation screens are covered in the legacy Messages create slice below.
- Backend-owned subjects, message bodies, event/org/user/participant names, and API error response bodies remain displayed as returned by their source.

### Messages Broadcast Flow

Migrated:

- `lib/features/messages/presentation/screens/create_broadcast_screen.dart`
- `lib/features/messages/presentation/screens/broadcast_detail_screen.dart`
- `lib/features/messages/presentation/widgets/broadcast_tile.dart`

Covered:

- Create broadcast title/step labels, bottom actions, success/error snackbars, event and slot selector labels, loading/error states, recipient preview text, event picker title/search/empty state, subject/message labels/hints/validation, and review labels.
- Locale-aware slot labels in the create flow, including fallback slot names, localized dates, and French/English time formatting.
- Broadcast detail title, retry/error labels, processing banner, sent/in-progress status badge, stats labels, targeted events heading, and message section heading.
- Broadcast list tile sending state.

Not covered in this slice:

- Backend-owned event titles, broadcast subjects, broadcast bodies, and API error response bodies remain displayed as returned by their source.
- `SlotOption.label` still exists as a French-first context-free domain fallback; the migrated broadcast create UI now avoids it in favor of context-aware formatting.
- Support detail and admin report detail moderation copy are covered in the Messages support/admin-report slice below.
- Legacy standalone vendor/admin new-conversation screens are covered in the legacy Messages create slice below.

### Messages Support And Admin Report Detail

Migrated:

- `lib/features/messages/presentation/screens/support_detail_screen.dart`
- `lib/features/messages/presentation/screens/admin_report_detail_screen.dart`
- `lib/features/messages/presentation/providers/conversation_detail_provider.dart`

Covered:

- Support detail retry/error labels, close-conversation dialog/menu, Support title, closed banner, and empty-thread copy.
- Shared conversation send-failure fallback in `conversation_detail_provider.dart`, using the cached app locale outside widget context.
- Admin report detail title, not-found state, untitled conversation fallback, party labels/type labels, report reason section, internal note label/hint/save snackbar, moderation actions/warnings, dismiss/review confirmation dialogs, result snackbars, linked-conversation CTA, status labels, and reason labels.

Not covered in this slice:

- Backend-owned conversation subjects, report comments, user/org names, emails, organization names, and API error response bodies remain displayed as returned by their source.
- Legacy standalone vendor/admin new-conversation screens are covered in the legacy Messages create slice below.

### Legacy Messages Admin/Vendor New Conversation Screens

Migrated:

- `lib/features/messages/presentation/screens/admin_new_conversation_screen.dart`
- `lib/features/messages/presentation/screens/vendor_new_conversation_screen.dart`

Covered:

- Legacy admin create-conversation titles, required recipient/organization labels, optional subject/message labels, create action, validation errors, search sheet titles/search hints/loading/no-result states, and localized error prefixes.
- Legacy vendor create-conversation titles, required participant/partner/subject/message labels, support subject fallback, send action, validation errors, access-denied fallbacks, participant helper text, search sheet titles/search hints/loading/no-result/no-accepted-partners states.

Not covered in this slice:

- Backend-owned user/org/participant/partner names, emails, IDs, organization names, and API error response bodies remain displayed as returned by their source.

### Petit Boo Chat Shell And History

Migrated:

- `lib/features/petit_boo/presentation/screens/petit_boo_chat_screen.dart`
- `lib/features/petit_boo/presentation/screens/conversation_list_screen.dart`

Covered:

- Chat app bar assistant status, history/new-conversation tooltips, service-unavailable banner, retry action, personalized greetings/subtitles, quick action labels/prompts, suggestion section title, and suggestion prompts.
- Conversation history title, retry action, empty state, new-conversation action, delete confirmation sheet, deletion toast, fallback conversation title, relative day labels, and message-count badge.

Not covered in this slice:

- Petit Boo brain, quota/limit, and toast copy are covered in the next Petit Boo slice below.
- Petit Boo tool cards, tool schema fallback titles/descriptions, data-source field labels, and backend/LLM-generated chat content still need follow-up migration.
- Existing `prefer_const_constructors` info-level analyzer noise in the touched Petit Boo screens was left as style debt.

### Petit Boo Brain, Quota, Limit, And Toasts

Migrated:

- `lib/features/petit_boo/presentation/screens/petit_boo_brain_screen.dart`
- `lib/features/petit_boo/presentation/widgets/quota_indicator.dart`
- `lib/features/petit_boo/presentation/widgets/limit_reached_dialog.dart`
- `lib/features/petit_boo/presentation/widgets/animated_toast.dart`

Covered:

- Brain screen title, memory toggle labels/descriptions, known-memory heading, empty/disabled states, edit/forget/clear actions, confirmation dialogs, and new-value hint.
- Brain memory display labels for known context keys, localized boolean/value fallbacks for age group, budget, group type, and localized last-updated formatting.
- Quota explanation sheet header, remaining/usage text, renewal period/relative reset copy, tip/why cards, close action, and full quota display reset label.
- Limit-reached dialog title/body, wallet balance, unlock/ad actions, unavailable hint, dismiss action, unlock result toasts, coming-soon toast, and error fallback.
- Petit Boo favorite and Hibons reward toast helper copy, including the overlay-based reward helper.

Not covered in this slice:

- Petit Boo shared tool schemas and common tool cards are covered in the next Petit Boo slice below.
- Petit Boo event/booking/trip-specific tool cards, API/data-source fallback labels, and backend/LLM-generated chat content remain follow-up work.
- Legacy static French helpers in `PetitBooContextStorage` remain in the data layer for now, but the migrated brain screen no longer uses them for visible labels/values.
- Existing `prefer_const_constructors`, `withOpacity`, and `activeColor` info-level analyzer notes in the touched Petit Boo widgets were left as style debt.

### Petit Boo Tool Schemas And Shared Tool Cards

Migrated:

- `lib/features/petit_boo/presentation/providers/tool_schemas_provider.dart`
- `lib/features/petit_boo/presentation/widgets/tool_cards/dynamic_tool_result_card.dart`
- `lib/features/petit_boo/presentation/widgets/tool_cards/generic_list_card.dart`
- `lib/features/petit_boo/presentation/widgets/tool_cards/unknown_tool_card.dart`
- `lib/features/petit_boo/presentation/widgets/tool_cards/brain_memory_card.dart`
- `lib/features/petit_boo/presentation/widgets/tool_cards/profile_card.dart`
- `lib/features/petit_boo/presentation/widgets/tool_cards/action_confirmation_card.dart`
- `lib/features/petit_boo/presentation/widgets/tool_cards/favorite_lists_card.dart`

Covered:

- Default tool schemas now rebuild from the active app language instead of storing French copy in a static fallback map.
- Tool schema fallback descriptions, titles, empty states, badges, stats labels, brain section labels, and trip/favorite/list/action descriptions are localized.
- Dynamic tool-card loading copy, generic/unknown card item counts, empty list fallback, untitled fallback, active/inactive labels, and view-all copy are localized.
- Brain memory tool-card title, empty state, recommendation hint, manage-memory link, default section labels, and known memory key labels are localized.
- Profile tool-card Hibons balance/action labels, stat fallbacks, and default user name are localized.
- Action confirmation card titles, subtitles, toasts, route labels, brain update messages, list create/move/rename/delete copy, and error state are localized.
- Favorite lists tool-card title, count, view-all action, empty state, unnamed-list fallback, and event-count labels are localized.

Not covered in this slice:

- Event, booking, trip-plan, and trip-plans-list tool cards are covered in the next Petit Boo slice below.
- Legacy/context helper labels in `petit_boo_context_storage.dart` still need an audit if a future UI displays them directly.
- Backend-owned event/list/profile values and LLM-generated chat content remain displayed as returned by their source.
- Existing `prefer_const_constructors` and `withOpacity` info-level analyzer notes in the touched tool-card widgets were left as style debt.

### Petit Boo Event/Booking/Trip Tool Cards And Fallback Errors

Migrated:

- `lib/features/petit_boo/presentation/widgets/tool_cards/event_list_card.dart`
- `lib/features/petit_boo/presentation/widgets/tool_cards/event_detail_card.dart`
- `lib/features/petit_boo/presentation/widgets/tool_cards/booking_list_card.dart`
- `lib/features/petit_boo/presentation/widgets/tool_cards/trip_plan_card.dart`
- `lib/features/petit_boo/presentation/widgets/tool_cards/trip_plans_list_card.dart`
- `lib/features/petit_boo/presentation/providers/petit_boo_chat_provider.dart`
- `lib/features/petit_boo/data/datasources/petit_boo_api_datasource.dart`

Covered:

- Event list/detail card item counts, view-all action, empty fallback, event title fallback, date/time joiner, availability CTA, free/from/rate labels, and untitled fallback are localized.
- Booking list card item counts, view-all action, empty fallback, render-error message, ticket count, untitled fallback, and visible booking status labels are localized.
- Trip plan and saved trip-plan list cards now localize saved-plan counts, stop counts, stop/title fallbacks, more-stops text, empty/error states, map expand/collapse actions, save/saved labels, no-coordinate snackbars, tips title, and the save-plan prompt sent back through Petit Boo.
- `petit_boo_chat_provider.dart` now uses the cached app locale for context-free SSE/auth/quota/connection/load fallback errors.
- `petit_boo_api_datasource.dart` now uses the cached app locale for context-free API error fallback text.

Not covered in this slice:

- Backend-owned event titles, descriptions, categories, booking payload values, saved-plan titles, trip recommendations, and LLM-generated chat content remain displayed as returned by their source.
- Status parsing still accepts French backend tokens such as `confirmé`, `annulé`, and `utilisé`; those tokens are not rendered directly.
- Legacy/context helper labels in `petit_boo_context_storage.dart` remain for a later audit if they become visible UI again.
- Existing `prefer_const_constructors` and `withOpacity` info-level analyzer notes in the touched widgets were left as style debt.

### Memberships, Private Events, And Invitations

Migrated:

- `lib/features/memberships/presentation/screens/memberships_screen.dart`
- `lib/features/memberships/presentation/screens/private_events_screen.dart`
- `lib/features/memberships/presentation/screens/invitation_landing_screen.dart`
- `lib/features/memberships/presentation/widgets/organizer_join_button.dart`
- `lib/features/memberships/presentation/widgets/members_only_gate.dart`
- `lib/features/memberships/presentation/widgets/membership_card.dart`
- `lib/features/memberships/presentation/widgets/invitation_card.dart`
- `lib/features/memberships/presentation/widgets/_status_chip.dart`
- `lib/features/memberships/presentation/widgets/personalized_feed_section.dart`

Covered:

- Membership list title, organization search hint, tab count labels, active/pending/rejected/invitation empty states, discover CTA, retry/load error, and status chips are localized.
- Membership card actions, member count label, private-events link, view-organizer link, and primary join/cancel/leave/retry actions are localized.
- Join, cancel-request, and leave-organization confirmation dialogs are localized.
- Private events title, search hint, organization filter label, private badge, load error, empty states, and discover CTA are localized.
- Invitation landing/card copy is localized, including invited-by, expiry labels, active/expired/accepted blurbs, accept/decline actions and dialogs, sign-in/create-account CTA, snackbars, dismissed notices, and not-found state.
- Members-only gate title/body, organizer-profile link, and join CTA are localized.
- Home personalized "For you" section title is localized.

Not covered in this slice:

- Backend-owned organization names, addresses, cities, event titles, and invited-by user names remain displayed as returned by their source.
- Domain comments/spec references still contain French labels; rendered UI string scans for the touched membership presentation files are clean.

### Partner Profile And Followed Organizers

Migrated:

- `lib/features/partners/presentation/screens/organizer_profile_screen.dart`
- `lib/features/partners/presentation/screens/followed_organizers_screen.dart`
- `lib/features/partners/presentation/widgets/organizer_identity_card.dart`
- `lib/features/partners/presentation/widgets/organizer_action_bar.dart`
- `lib/features/partners/presentation/widgets/organizer_coordinates_panel.dart`
- `lib/features/partners/presentation/widgets/organizer_about_section.dart`
- `lib/features/partners/presentation/widgets/organizer_activities_tab.dart`
- `lib/features/partners/presentation/widgets/organizer_reviews_tab.dart`
- `lib/features/partners/presentation/widgets/organizer_review_row.dart`
- `lib/features/partners/presentation/widgets/followed_organizer_tile.dart`
- `lib/features/partners/presentation/widgets/organizer_follow_button.dart`

Covered:

- Organizer profile invalid-id state, load error, back action, tabs, contact/coordinates actions, no-coordinates fallback, about/establishment/social section headings, and follow/unfollow labels are localized.
- Organizer identity and followed-organizer tiles now localize event/follower/member/review count labels with plural-aware strings while preserving compact number formatting.
- Organizer activities tab load/empty states and current/past segmented labels are localized.
- Organizer reviews tab load/empty states, total review count, verified purchase count, review row fallback user, review-for label, verified/helpful chips, and organizer reply labels are localized.
- Followed organizers screen title, search hint, empty/search-empty states, load error, retry action, and tile unfollow action are localized.

Not covered in this slice:

- Backend-owned organizer names, display names, descriptions, establishment type names, city/address/contact values, event titles, review titles/comments, reviewer names, dates returned as formatted strings, and organizer replies remain displayed as returned by their source.
- Comments/spec references still contain French labels; rendered UI string scans for touched partner presentation files are clean.

### Check-In Scanner And Vendor Organization Picker

Migrated:

- `lib/features/checkin/presentation/screens/checkin_scan_screen.dart`
- `lib/features/checkin/presentation/screens/checkin_manual_entry_screen.dart`
- `lib/features/checkin/presentation/screens/checkin_confirm_sheet.dart`
- `lib/features/checkin/presentation/screens/checkin_blocked_sheet.dart`
- `lib/features/checkin/presentation/screens/organization_picker_sheet.dart`
- `lib/features/checkin/domain/entities/checkin_blocker.dart`
- `lib/features/checkin/domain/repositories/checkin_repository.dart`

Covered:

- Scanner app bar title, camera/torch/more tooltips, switch-organization/manual/gate menu labels, gate dialog copy, gate display label, success snackbars, network warning snackbar, and camera error overlay copy are localized.
- Manual entry title, organization-missing warning, security warning, selected-organization label, helper text, verify action, success snackbars, and network warning snackbar are localized.
- Confirmation sheet valid/re-entry titles, re-entry warning, cancel action, and confirm actions are localized.
- Blocked-ticket sheet titles/body copy now localize through the presentation layer; the domain blocker enum no longer embeds French UI copy.
- Vendor organization picker title/body, role labels, empty state, and refresh action are localized.

Not covered in this slice:

- Backend-owned ticket attendee names, event titles, ticket type names, organization names/addresses/logos, and server-provided extra error messages remain displayed as returned by their source.
- `TicketSummaryCard` already used locale-aware date formatting from an earlier slice and did not need user-visible label migration in this batch.

### Remaining Active UI Surfaces Batch

Migrated:

- `lib/features/trip_plans/presentation/screens/trip_plans_list_screen.dart`
- `lib/features/trip_plans/presentation/screens/trip_plan_edit_screen.dart`
- `lib/features/trip_plans/presentation/widgets/trip_plan_list_card.dart`
- `lib/features/reviews/presentation/screens/event_reviews_full_screen.dart`
- `lib/features/reviews/presentation/screens/my_reviews_screen.dart`
- `lib/features/reviews/presentation/widgets/can_review_message.dart`
- `lib/features/reviews/presentation/widgets/delete_review_dialog.dart`
- `lib/features/reviews/presentation/widgets/event_reviews_section.dart`
- `lib/features/reviews/presentation/widgets/my_review_block.dart`
- `lib/features/reviews/presentation/widgets/report_review_sheet.dart`
- `lib/features/reviews/presentation/widgets/review_card.dart`
- `lib/features/reviews/presentation/widgets/status_badge.dart`
- `lib/features/reviews/presentation/widgets/user_review_card.dart`
- `lib/features/reviews/presentation/widgets/write_review_sheet.dart`
- `lib/features/gamification/presentation/screens/achievements_screen.dart`
- `lib/features/gamification/presentation/screens/gamification_dashboard_screen.dart`
- `lib/features/gamification/presentation/screens/hibon_shop_screen.dart`
- `lib/features/gamification/presentation/screens/how_to_earn_hibons_screen.dart`
- `lib/features/gamification/presentation/screens/lucky_wheel_screen.dart`
- `lib/features/gamification/presentation/widgets/daily_reward_widget.dart`
- `lib/features/gamification/presentation/widgets/earnings_by_pillar_donut.dart`
- `lib/features/gamification/presentation/widgets/hibon_counter_widget.dart`
- `lib/features/gamification/presentation/widgets/hibons_animation_coordinator.dart`
- `lib/features/gamification/presentation/widgets/rank_up_overlay.dart`
- `lib/features/alerts/presentation/screens/alerts_list_screen.dart`
- `lib/features/favorites/presentation/screens/favorites_screen.dart`
- `lib/features/favorites/presentation/widgets/create_list_dialog.dart`
- `lib/features/favorites/presentation/widgets/edit_list_dialog.dart`
- `lib/features/favorites/presentation/widgets/favorite_lists_sidebar.dart`
- `lib/features/favorites/presentation/widgets/favorite_list_picker_sheet.dart`
- `lib/features/favorites/presentation/widgets/favorite_button.dart`
- `lib/features/notifications/presentation/screens/notifications_inbox_screen.dart`
- `lib/features/reminders/presentation/screens/reminders_list_screen.dart`
- `lib/features/onboarding/presentation/screens/onboarding_screen.dart`
- `lib/features/thematiques/presentation/widgets/thematiques_section.dart`
- `lib/features/thematiques/presentation/widgets/categories_chips_section.dart`
- `lib/features/blog/presentation/widgets/blog_section.dart`
- `lib/features/blog/presentation/widgets/blog_post_card.dart`
- `lib/shared/legal/legal_links.dart`
- `lib/core/widgets/feedback/hb_feedback.dart`

Covered:

- Trip plan list/edit/card copy is localized, including list title, empty/error states, delete dialog/snackbar, stop counts, save/discard actions, and localized trip duration text.
- Reviews list/detail widgets are localized, including filters/sort labels, empty states, report/write/edit/delete sheets, validation messages, moderation notices, review status labels, and review-count pluralization.
- Gamification dashboard, achievements, shop, how-to-earn, lucky wheel, daily reward, earnings donut, Hibons counter, Hibons animation toast, and rank-up overlay copy is localized.
- Alerts, favorites, favorite-list dialogs/sidebar/picker/button, notifications inbox, reminders list/delete dialog, onboarding carousel, thematiques/categories sections, blog section/card chrome, legal link labels, and shared `HbErrorView` fallback copy are localized.

Not covered in this slice:

- Backend/source-owned values remain displayed as returned by their source, including notification payloads, blog post fields, category names, favorite list names, event/reminder titles and venues, gamification badge names/rank labels/action catalog labels/wheel results/transactions, user names, organizer names, and review body text.
- No-context utility/provider strings are still a residual audit area when they are not tied to a widget context. The later full pass localized `ApiResponseHandler` fallback messages, auth/business provider fallback messages, event question validation, user review/favorite errors, alert unnamed fallback, and several domain helper labels.
- `lib/features/petit_boo/data/datasources/petit_boo_context_storage.dart` legacy label helpers now use cached app localizations, although current scans still found no UI callers outside that file.
- Comments, backend-error matching strings, IDs, slugs, and data keys were left alone when they were not visible UI copy.

### Full Hard-Coded-String Audit Batch

Migrated after the remaining-surfaces batch:

- Route shell fallback/not-found/recommended labels in `lib/routes/app_router.dart`.
- `lib/features/user_questions` screen/card/status copy.
- Shared `SearchBarWidget`, notifications relative-time badges, reminders relative-day badge.
- Messages support/conversation OK actions and notification open action.
- Petit Boo conversation/provider engagement fallbacks and context-storage memory label helpers.
- Trip-plan DTO fallback labels and domain/provider-fed trip plan UI strings.
- Search/filter chips and filter-provider labels after removing the old context-free `dateFilterLabel` and `priceFilterLabel` getters.
- Auth/auth-business datasource and provider fallback messages.
- API-response network/generic fallback messages.
- Event question validation, user-review provider errors, favorite provider errors, alert unnamed fallback, route/event category helper fallbacks, checkout date fallback, and dormant Home widget chrome.
- Review/partner/event domain display helpers that were not currently used by active widgets but could otherwise leak French if reused.

Final scan residuals are intentionally left because they are not app chrome:

- Comments/docstrings and date-format patterns such as `"d MMMM yyyy 'à' HH:mm"`.
- Brand/product labels and placeholders such as `Le Hiboo`, `Petit Boo`, `Maps`, `Waze`, `EUR`, card-number examples, ticket-code examples, numeric badges, IDs, and star/rating strings.
- Backend/API/source-owned content such as event titles, organizer names, blog/notification payloads, badge/rank/action names, mock/demo data, and diagnostic messages.
- Generated/default model fallback strings in `mobile_app_config` should be revisited with codegen/build-runner cleanup if that generated default path becomes user-visible.

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

Latest focused Messages new-conversation check:

```sh
flutter gen-l10n
dart format lib/features/messages/presentation/widgets/new_conversation_form.dart lib/features/messages/presentation/screens/new_conversation_screen.dart lib/l10n/generated/app_localizations.dart lib/l10n/generated/app_localizations_en.dart lib/l10n/generated/app_localizations_fr.dart
flutter analyze --no-pub --no-fatal-infos --no-fatal-warnings lib/features/messages/presentation/widgets/new_conversation_form.dart lib/features/messages/presentation/screens/new_conversation_screen.dart lib/core/l10n lib/l10n/generated
flutter test --no-pub test/core/l10n/app_locale_test.dart
```

Result:

- Analyzer returned exit code 0.
- No issues found in the focused Messages new-conversation slice.
- Locale tests passed.

Latest focused Messages broadcast flow check:

```sh
flutter gen-l10n
dart format lib/features/messages/presentation/screens/create_broadcast_screen.dart lib/features/messages/presentation/screens/broadcast_detail_screen.dart lib/features/messages/presentation/widgets/broadcast_tile.dart lib/l10n/generated/app_localizations.dart lib/l10n/generated/app_localizations_en.dart lib/l10n/generated/app_localizations_fr.dart
flutter analyze --no-pub --no-fatal-infos --no-fatal-warnings lib/features/messages/presentation/screens/create_broadcast_screen.dart lib/features/messages/presentation/screens/broadcast_detail_screen.dart lib/features/messages/presentation/widgets/broadcast_tile.dart lib/core/l10n lib/l10n/generated
flutter test --no-pub test/core/l10n/app_locale_test.dart
git diff --check
```

Result:

- Analyzer returned exit code 0.
- No issues found in the focused Messages broadcast flow slice.
- Locale tests passed.
- Whitespace check passed.

Latest focused Messages support/admin report detail check:

```sh
flutter gen-l10n
dart format lib/features/messages/presentation/screens/support_detail_screen.dart lib/features/messages/presentation/screens/admin_report_detail_screen.dart lib/features/messages/presentation/providers/conversation_detail_provider.dart lib/l10n/generated/app_localizations.dart lib/l10n/generated/app_localizations_en.dart lib/l10n/generated/app_localizations_fr.dart
flutter analyze --no-pub --no-fatal-infos --no-fatal-warnings lib/features/messages/presentation/screens/support_detail_screen.dart lib/features/messages/presentation/screens/admin_report_detail_screen.dart lib/features/messages/presentation/providers/conversation_detail_provider.dart lib/core/l10n lib/l10n/generated
flutter test --no-pub test/core/l10n/app_locale_test.dart
git diff --check
```

Result:

- Analyzer returned exit code 0.
- No issues found in the focused Messages support/admin report detail slice.
- Locale tests passed.
- Whitespace check passed.

Latest focused legacy Messages admin/vendor new-conversation check:

```sh
flutter gen-l10n
dart format lib/features/messages/presentation/screens/admin_new_conversation_screen.dart lib/features/messages/presentation/screens/vendor_new_conversation_screen.dart lib/l10n/generated/app_localizations.dart lib/l10n/generated/app_localizations_en.dart lib/l10n/generated/app_localizations_fr.dart
flutter analyze --no-pub --no-fatal-infos --no-fatal-warnings lib/features/messages/presentation/screens/admin_new_conversation_screen.dart lib/features/messages/presentation/screens/vendor_new_conversation_screen.dart lib/features/messages/presentation/screens/support_detail_screen.dart lib/features/messages/presentation/screens/admin_report_detail_screen.dart lib/features/messages/presentation/providers/conversation_detail_provider.dart lib/core/l10n lib/l10n/generated
flutter test --no-pub test/core/l10n/app_locale_test.dart
git diff --check
```

Result:

- Analyzer returned exit code 0.
- No issues found in the focused legacy Messages admin/vendor new-conversation slice.
- Locale tests passed.
- Whitespace check passed.
- Remaining Messages French-string scan matches only documented date-format patterns and the context-free `SlotOption.label` domain fallback.

Latest focused Petit Boo chat shell/history check:

```sh
flutter gen-l10n
dart format lib/features/petit_boo/presentation/screens/petit_boo_chat_screen.dart lib/features/petit_boo/presentation/screens/conversation_list_screen.dart lib/l10n/generated/app_localizations.dart lib/l10n/generated/app_localizations_en.dart lib/l10n/generated/app_localizations_fr.dart
flutter analyze --no-pub --no-fatal-infos --no-fatal-warnings lib/features/petit_boo/presentation/screens/petit_boo_chat_screen.dart lib/features/petit_boo/presentation/screens/conversation_list_screen.dart lib/features/petit_boo/presentation/widgets/chat_input_bar.dart lib/core/l10n lib/l10n/generated
flutter test --no-pub test/core/l10n/app_locale_test.dart
git diff --check
```

Result:

- Analyzer returned exit code 0.
- No warning/error issues found in the focused Petit Boo chat shell/history slice.
- Analyzer output still includes existing `prefer_const_constructors` info-level style notes in the touched Petit Boo screens.
- Locale tests passed.
- Whitespace check passed.

Latest focused Petit Boo brain/quota/limit/toast check:

```sh
flutter gen-l10n
dart format lib/features/petit_boo/presentation/screens/petit_boo_brain_screen.dart lib/features/petit_boo/presentation/widgets/quota_indicator.dart lib/features/petit_boo/presentation/widgets/limit_reached_dialog.dart lib/features/petit_boo/presentation/widgets/animated_toast.dart lib/l10n/generated
flutter analyze --no-pub --no-fatal-infos --no-fatal-warnings lib/features/petit_boo/presentation/screens/petit_boo_brain_screen.dart lib/features/petit_boo/presentation/widgets/quota_indicator.dart lib/features/petit_boo/presentation/widgets/limit_reached_dialog.dart lib/features/petit_boo/presentation/widgets/animated_toast.dart lib/core/l10n lib/l10n/generated
flutter test --no-pub test/core/l10n/app_locale_test.dart
git diff --check
```

Result:

- Analyzer returned exit code 0.
- No warning/error issues found in the focused Petit Boo brain/quota/limit/toast slice.
- Analyzer output still includes existing `prefer_const_constructors`, `withOpacity`, and `activeColor` info-level notes in the touched Petit Boo widgets.
- Locale tests passed.
- Whitespace check passed.

Latest focused Petit Boo tool schema/shared-card check:

```sh
flutter gen-l10n
dart format lib/features/petit_boo/presentation/providers/tool_schemas_provider.dart lib/features/petit_boo/presentation/widgets/tool_cards/dynamic_tool_result_card.dart lib/features/petit_boo/presentation/widgets/tool_cards/generic_list_card.dart lib/features/petit_boo/presentation/widgets/tool_cards/unknown_tool_card.dart lib/features/petit_boo/presentation/widgets/tool_cards/brain_memory_card.dart lib/features/petit_boo/presentation/widgets/tool_cards/profile_card.dart lib/features/petit_boo/presentation/widgets/tool_cards/action_confirmation_card.dart lib/features/petit_boo/presentation/widgets/tool_cards/favorite_lists_card.dart lib/l10n/generated
flutter analyze --no-pub --no-fatal-infos --no-fatal-warnings lib/features/petit_boo/presentation/providers/tool_schemas_provider.dart lib/features/petit_boo/presentation/widgets/tool_cards/dynamic_tool_result_card.dart lib/features/petit_boo/presentation/widgets/tool_cards/generic_list_card.dart lib/features/petit_boo/presentation/widgets/tool_cards/unknown_tool_card.dart lib/features/petit_boo/presentation/widgets/tool_cards/brain_memory_card.dart lib/features/petit_boo/presentation/widgets/tool_cards/profile_card.dart lib/features/petit_boo/presentation/widgets/tool_cards/action_confirmation_card.dart lib/features/petit_boo/presentation/widgets/tool_cards/favorite_lists_card.dart lib/core/l10n lib/l10n/generated
flutter test --no-pub test/core/l10n/app_locale_test.dart
git diff --check
```

Result:

- Analyzer returned exit code 0.
- No warning/error issues found in the focused Petit Boo tool schema/shared-card slice.
- Analyzer output still includes existing `prefer_const_constructors` and `withOpacity` info-level notes in the touched tool-card widgets.
- Locale tests passed.
- Whitespace check passed.

Latest focused Petit Boo event/booking/trip card and fallback-error check:

```sh
flutter gen-l10n
dart format lib/features/petit_boo/presentation/widgets/tool_cards/event_list_card.dart lib/features/petit_boo/presentation/widgets/tool_cards/event_detail_card.dart lib/features/petit_boo/presentation/widgets/tool_cards/booking_list_card.dart lib/features/petit_boo/presentation/widgets/tool_cards/trip_plan_card.dart lib/features/petit_boo/presentation/widgets/tool_cards/trip_plans_list_card.dart lib/features/petit_boo/presentation/providers/petit_boo_chat_provider.dart lib/features/petit_boo/data/datasources/petit_boo_api_datasource.dart lib/l10n/generated/app_localizations.dart lib/l10n/generated/app_localizations_en.dart lib/l10n/generated/app_localizations_fr.dart
flutter analyze --no-pub --no-fatal-infos --no-fatal-warnings lib/features/petit_boo/presentation/widgets/tool_cards/event_list_card.dart lib/features/petit_boo/presentation/widgets/tool_cards/event_detail_card.dart lib/features/petit_boo/presentation/widgets/tool_cards/booking_list_card.dart lib/features/petit_boo/presentation/widgets/tool_cards/trip_plan_card.dart lib/features/petit_boo/presentation/widgets/tool_cards/trip_plans_list_card.dart lib/features/petit_boo/presentation/providers/petit_boo_chat_provider.dart lib/features/petit_boo/data/datasources/petit_boo_api_datasource.dart lib/l10n/generated lib/core/l10n
flutter test --no-pub test/core/l10n/app_locale_test.dart
git diff --check
```

Result:

- Analyzer returned exit code 0.
- No warning/error issues found in the focused Petit Boo event/booking/trip card and fallback-error slice.
- Analyzer output still includes existing `prefer_const_declarations`, `prefer_const_constructors`, and `withOpacity` info-level notes in the touched Petit Boo files.
- Locale tests passed.
- Whitespace check passed.

Latest focused memberships/private-events/invitations check:

```sh
flutter gen-l10n
dart format lib/features/memberships/presentation/screens/memberships_screen.dart lib/features/memberships/presentation/screens/private_events_screen.dart lib/features/memberships/presentation/screens/invitation_landing_screen.dart lib/features/memberships/presentation/widgets/organizer_join_button.dart lib/features/memberships/presentation/widgets/members_only_gate.dart lib/features/memberships/presentation/widgets/membership_card.dart lib/features/memberships/presentation/widgets/invitation_card.dart lib/features/memberships/presentation/widgets/_status_chip.dart lib/features/memberships/presentation/widgets/personalized_feed_section.dart lib/l10n/generated/app_localizations.dart lib/l10n/generated/app_localizations_en.dart lib/l10n/generated/app_localizations_fr.dart
flutter analyze --no-pub --no-fatal-infos --no-fatal-warnings lib/features/memberships/presentation/screens/memberships_screen.dart lib/features/memberships/presentation/screens/private_events_screen.dart lib/features/memberships/presentation/screens/invitation_landing_screen.dart lib/features/memberships/presentation/widgets/organizer_join_button.dart lib/features/memberships/presentation/widgets/members_only_gate.dart lib/features/memberships/presentation/widgets/membership_card.dart lib/features/memberships/presentation/widgets/invitation_card.dart lib/features/memberships/presentation/widgets/_status_chip.dart lib/features/memberships/presentation/widgets/personalized_feed_section.dart lib/l10n/generated lib/core/l10n
flutter test --no-pub test/core/l10n/app_locale_test.dart
git diff --check
```

Result:

- Analyzer returned exit code 0.
- No issues found in the focused memberships/private-events/invitations slice.
- Locale tests passed.
- Whitespace check passed.

Latest focused partner profile/followed-organizer check:

```sh
flutter gen-l10n
dart format lib/features/partners/presentation/screens/organizer_profile_screen.dart lib/features/partners/presentation/screens/followed_organizers_screen.dart lib/features/partners/presentation/widgets/organizer_identity_card.dart lib/features/partners/presentation/widgets/organizer_action_bar.dart lib/features/partners/presentation/widgets/organizer_coordinates_panel.dart lib/features/partners/presentation/widgets/organizer_about_section.dart lib/features/partners/presentation/widgets/organizer_activities_tab.dart lib/features/partners/presentation/widgets/organizer_reviews_tab.dart lib/features/partners/presentation/widgets/organizer_review_row.dart lib/features/partners/presentation/widgets/followed_organizer_tile.dart lib/features/partners/presentation/widgets/organizer_follow_button.dart lib/l10n/generated/app_localizations.dart lib/l10n/generated/app_localizations_en.dart lib/l10n/generated/app_localizations_fr.dart
flutter analyze --no-pub --no-fatal-infos --no-fatal-warnings lib/features/partners/presentation/screens/organizer_profile_screen.dart lib/features/partners/presentation/screens/followed_organizers_screen.dart lib/features/partners/presentation/widgets/organizer_identity_card.dart lib/features/partners/presentation/widgets/organizer_action_bar.dart lib/features/partners/presentation/widgets/organizer_coordinates_panel.dart lib/features/partners/presentation/widgets/organizer_about_section.dart lib/features/partners/presentation/widgets/organizer_activities_tab.dart lib/features/partners/presentation/widgets/organizer_reviews_tab.dart lib/features/partners/presentation/widgets/organizer_review_row.dart lib/features/partners/presentation/widgets/followed_organizer_tile.dart lib/features/partners/presentation/widgets/organizer_follow_button.dart lib/l10n/generated lib/core/l10n
flutter test --no-pub test/core/l10n/app_locale_test.dart
git diff --check
```

Result:

- Analyzer returned exit code 0.
- No issues found in the focused partner profile/followed-organizer slice.
- Locale tests passed.
- Whitespace check passed.

Latest focused check-in scanner/manual/picker check:

```sh
flutter gen-l10n
dart format lib/features/checkin/presentation/screens/checkin_scan_screen.dart lib/features/checkin/presentation/screens/checkin_manual_entry_screen.dart lib/features/checkin/presentation/screens/checkin_confirm_sheet.dart lib/features/checkin/presentation/screens/checkin_blocked_sheet.dart lib/features/checkin/presentation/screens/organization_picker_sheet.dart lib/features/checkin/domain/entities/checkin_blocker.dart lib/features/checkin/domain/repositories/checkin_repository.dart lib/l10n/generated/app_localizations.dart lib/l10n/generated/app_localizations_en.dart lib/l10n/generated/app_localizations_fr.dart
flutter analyze --no-pub --no-fatal-infos --no-fatal-warnings lib/features/checkin/presentation/screens/checkin_scan_screen.dart lib/features/checkin/presentation/screens/checkin_manual_entry_screen.dart lib/features/checkin/presentation/screens/checkin_confirm_sheet.dart lib/features/checkin/presentation/screens/checkin_blocked_sheet.dart lib/features/checkin/presentation/screens/organization_picker_sheet.dart lib/features/checkin/presentation/widgets/ticket_summary_card.dart lib/features/checkin/domain/entities/checkin_blocker.dart lib/features/checkin/domain/repositories/checkin_repository.dart lib/l10n/generated lib/core/l10n
flutter test --no-pub test/core/l10n/app_locale_test.dart
git diff --check
```

Result:

- Analyzer returned exit code 0.
- No issues found in the focused check-in scanner/manual/picker slice.
- Locale tests passed.
- Whitespace check passed.

Latest multi-agent remaining active UI surfaces check:

```sh
flutter gen-l10n
dart format <77 changed Dart files>
flutter analyze --no-pub --no-fatal-infos --no-fatal-warnings $(git diff --name-only -- '*.dart')
flutter test --no-pub test/core/l10n/app_locale_test.dart
git diff --check
rg -n --pcre2 "(['\"])(?:(?!\\1).)*[À-ÿ](?:(?!\\1).)*\\1" lib/features/alerts/presentation lib/features/favorites/presentation lib/features/gamification/presentation lib/features/notifications/presentation lib/features/onboarding/presentation lib/features/reminders/presentation lib/features/reviews/presentation lib/features/thematiques/presentation lib/features/blog/presentation lib/features/trip_plans/presentation lib/core/widgets/feedback lib/shared/legal
```

Result:

- `flutter gen-l10n` passed.
- `dart format` completed successfully after the worker edits and the small integration fixes.
- Focused analyzer returned exit code 0 over all changed Dart files. No analyzer warnings or errors remain in that focused pass; output still includes info-only existing style/deprecation notes such as `prefer_const`, `deprecated_member_use`, `prefer_const_declarations`, and `curly_braces_in_flow_control_structures`.
- Locale tests passed.
- Whitespace check passed.
- Targeted accented-string scan for the newly migrated surfaces only matched comments plus one backend-error matching condition in `gamification_dashboard_screen.dart` (`déjà réclamé`), not visible UI copy.

Latest full hard-coded-string audit check:

```sh
flutter gen-l10n
dart format $(git diff --name-only -- '*.dart')
flutter analyze --no-pub --no-fatal-infos --no-fatal-warnings $(git diff --name-only -- '*.dart')
flutter test --no-pub test/core/l10n/app_locale_test.dart
git diff --check
rg -n --pcre2 "\b(?:Text|SelectableText)\s*\(\s*(['\"])(?:(?!\\1).){2,}\\1" lib -g '*.dart' -g '!lib/l10n/generated/**' -g '!**/*.freezed.dart' -g '!**/*.g.dart'
rg -n --pcre2 "\b(?:labelText|hintText|errorText|helperText|counterText|prefixText|suffixText|semanticLabel|tooltip|message|label|title|content)\s*:\s*(['\"])(?:(?!\\1).){2,}\\1" lib -g '*.dart' -g '!lib/l10n/generated/**' -g '!**/*.freezed.dart' -g '!**/*.g.dart'
rg -n --pcre2 "(['\"])(?:(?!\\1).)*[À-ÿ](?:(?!\\1).)*\\1" lib -g '*.dart' -g '!lib/l10n/generated/**' -g '!**/*.freezed.dart' -g '!**/*.g.dart'
```

Result:

- `flutter gen-l10n` passed.
- `dart format` completed across the changed Dart set.
- Focused analyzer returned exit code 0 over all changed Dart files. No analyzer errors remain. Output still includes pre-existing warning/info cleanup, especially nullable/dead-code warnings in `event_practical_info.dart`, `invalid_annotation_target` warnings in `mobile_app_config.dart`, and style/deprecation notes such as `prefer_const`, `withOpacity`, and `curly_braces_in_flow_control_structures`.
- Locale tests passed.
- Whitespace check passed.
- Final literal scans show no remaining app-chrome copy. Remaining hits are comments/docstrings, mock/source-owned data, backend/code matching strings, date-format patterns, brand labels, numeric/ID/star labels, and input examples/placeholders.

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
- `pubspec.lock`
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

Messages new-conversation files are now part of the i18n work:

- `lib/features/messages/presentation/screens/new_conversation_screen.dart`
- `lib/features/messages/presentation/widgets/new_conversation_form.dart`

Messages broadcast files are now part of the i18n work:

- `lib/features/messages/presentation/screens/create_broadcast_screen.dart`
- `lib/features/messages/presentation/screens/broadcast_detail_screen.dart`
- `lib/features/messages/presentation/widgets/broadcast_tile.dart`

Messages support/admin report detail files are now part of the i18n work:

- `lib/features/messages/presentation/screens/support_detail_screen.dart`
- `lib/features/messages/presentation/screens/admin_report_detail_screen.dart`
- `lib/features/messages/presentation/providers/conversation_detail_provider.dart`

Legacy Messages admin/vendor create files are now part of the i18n work:

- `lib/features/messages/presentation/screens/admin_new_conversation_screen.dart`
- `lib/features/messages/presentation/screens/vendor_new_conversation_screen.dart`

Petit Boo chat shell/history files are now part of the i18n work:

- `lib/features/petit_boo/presentation/screens/petit_boo_chat_screen.dart`
- `lib/features/petit_boo/presentation/screens/conversation_list_screen.dart`

Petit Boo brain/quota/limit/toast files are now part of the i18n work:

- `lib/features/petit_boo/presentation/screens/petit_boo_brain_screen.dart`
- `lib/features/petit_boo/presentation/widgets/quota_indicator.dart`
- `lib/features/petit_boo/presentation/widgets/limit_reached_dialog.dart`
- `lib/features/petit_boo/presentation/widgets/animated_toast.dart`

Petit Boo tool schema/shared-card files are now part of the i18n work:

- `lib/features/petit_boo/presentation/providers/tool_schemas_provider.dart`
- `lib/features/petit_boo/presentation/widgets/tool_cards/dynamic_tool_result_card.dart`
- `lib/features/petit_boo/presentation/widgets/tool_cards/generic_list_card.dart`
- `lib/features/petit_boo/presentation/widgets/tool_cards/unknown_tool_card.dart`
- `lib/features/petit_boo/presentation/widgets/tool_cards/brain_memory_card.dart`
- `lib/features/petit_boo/presentation/widgets/tool_cards/profile_card.dart`
- `lib/features/petit_boo/presentation/widgets/tool_cards/action_confirmation_card.dart`
- `lib/features/petit_boo/presentation/widgets/tool_cards/favorite_lists_card.dart`

Petit Boo event/booking/trip card and fallback-error files are now part of the i18n work:

- `lib/features/petit_boo/presentation/widgets/tool_cards/event_list_card.dart`
- `lib/features/petit_boo/presentation/widgets/tool_cards/event_detail_card.dart`
- `lib/features/petit_boo/presentation/widgets/tool_cards/booking_list_card.dart`
- `lib/features/petit_boo/presentation/widgets/tool_cards/trip_plan_card.dart`
- `lib/features/petit_boo/presentation/widgets/tool_cards/trip_plans_list_card.dart`
- `lib/features/petit_boo/presentation/providers/petit_boo_chat_provider.dart`
- `lib/features/petit_boo/data/datasources/petit_boo_api_datasource.dart`

Membership files are now part of the i18n work:

- `lib/features/memberships/presentation/screens/memberships_screen.dart`
- `lib/features/memberships/presentation/screens/private_events_screen.dart`
- `lib/features/memberships/presentation/screens/invitation_landing_screen.dart`
- `lib/features/memberships/presentation/widgets/organizer_join_button.dart`
- `lib/features/memberships/presentation/widgets/members_only_gate.dart`
- `lib/features/memberships/presentation/widgets/membership_card.dart`
- `lib/features/memberships/presentation/widgets/invitation_card.dart`
- `lib/features/memberships/presentation/widgets/_status_chip.dart`
- `lib/features/memberships/presentation/widgets/personalized_feed_section.dart`

Partner profile/followed-organizer files are now part of the i18n work:

- `lib/features/partners/presentation/screens/organizer_profile_screen.dart`
- `lib/features/partners/presentation/screens/followed_organizers_screen.dart`
- `lib/features/partners/presentation/widgets/organizer_identity_card.dart`
- `lib/features/partners/presentation/widgets/organizer_action_bar.dart`
- `lib/features/partners/presentation/widgets/organizer_coordinates_panel.dart`
- `lib/features/partners/presentation/widgets/organizer_about_section.dart`
- `lib/features/partners/presentation/widgets/organizer_activities_tab.dart`
- `lib/features/partners/presentation/widgets/organizer_reviews_tab.dart`
- `lib/features/partners/presentation/widgets/organizer_review_row.dart`
- `lib/features/partners/presentation/widgets/followed_organizer_tile.dart`
- `lib/features/partners/presentation/widgets/organizer_follow_button.dart`

Check-in scanner/manual/picker files are now part of the i18n work:

- `lib/features/checkin/presentation/screens/checkin_scan_screen.dart`
- `lib/features/checkin/presentation/screens/checkin_manual_entry_screen.dart`
- `lib/features/checkin/presentation/screens/checkin_confirm_sheet.dart`
- `lib/features/checkin/presentation/screens/checkin_blocked_sheet.dart`
- `lib/features/checkin/presentation/screens/organization_picker_sheet.dart`
- `lib/features/checkin/domain/entities/checkin_blocker.dart`
- `lib/features/checkin/domain/repositories/checkin_repository.dart`

Remaining active UI surface files are now part of the i18n work:

- `lib/features/trip_plans/presentation/screens/trip_plans_list_screen.dart`
- `lib/features/trip_plans/presentation/screens/trip_plan_edit_screen.dart`
- `lib/features/trip_plans/presentation/widgets/trip_plan_list_card.dart`
- `lib/features/reviews/presentation/screens/event_reviews_full_screen.dart`
- `lib/features/reviews/presentation/screens/my_reviews_screen.dart`
- `lib/features/reviews/presentation/widgets/can_review_message.dart`
- `lib/features/reviews/presentation/widgets/delete_review_dialog.dart`
- `lib/features/reviews/presentation/widgets/event_reviews_section.dart`
- `lib/features/reviews/presentation/widgets/my_review_block.dart`
- `lib/features/reviews/presentation/widgets/report_review_sheet.dart`
- `lib/features/reviews/presentation/widgets/review_card.dart`
- `lib/features/reviews/presentation/widgets/status_badge.dart`
- `lib/features/reviews/presentation/widgets/user_review_card.dart`
- `lib/features/reviews/presentation/widgets/write_review_sheet.dart`
- `lib/features/gamification/presentation/screens/achievements_screen.dart`
- `lib/features/gamification/presentation/screens/gamification_dashboard_screen.dart`
- `lib/features/gamification/presentation/screens/hibon_shop_screen.dart`
- `lib/features/gamification/presentation/screens/how_to_earn_hibons_screen.dart`
- `lib/features/gamification/presentation/screens/lucky_wheel_screen.dart`
- `lib/features/gamification/presentation/widgets/daily_reward_widget.dart`
- `lib/features/gamification/presentation/widgets/earnings_by_pillar_donut.dart`
- `lib/features/gamification/presentation/widgets/hibon_counter_widget.dart`
- `lib/features/gamification/presentation/widgets/hibons_animation_coordinator.dart`
- `lib/features/gamification/presentation/widgets/rank_up_overlay.dart`
- `lib/features/alerts/presentation/screens/alerts_list_screen.dart`
- `lib/features/favorites/presentation/screens/favorites_screen.dart`
- `lib/features/favorites/presentation/widgets/create_list_dialog.dart`
- `lib/features/favorites/presentation/widgets/edit_list_dialog.dart`
- `lib/features/favorites/presentation/widgets/favorite_lists_sidebar.dart`
- `lib/features/favorites/presentation/widgets/favorite_list_picker_sheet.dart`
- `lib/features/favorites/presentation/widgets/favorite_button.dart`
- `lib/features/notifications/presentation/screens/notifications_inbox_screen.dart`
- `lib/features/reminders/presentation/screens/reminders_list_screen.dart`
- `lib/features/onboarding/presentation/screens/onboarding_screen.dart`
- `lib/features/thematiques/presentation/widgets/thematiques_section.dart`
- `lib/features/thematiques/presentation/widgets/categories_chips_section.dart`
- `lib/features/blog/presentation/widgets/blog_section.dart`
- `lib/features/blog/presentation/widgets/blog_post_card.dart`
- `lib/shared/legal/legal_links.dart`
- `lib/core/widgets/feedback/hb_feedback.dart`

Before committing or refining, review diffs by file instead of using bulk restore/reset commands.

## Where Work Stopped

Stopped after completing the full multi-agent hard-coded-string audit pass.

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
- Shared Messages new-conversation copy is localized, including `/messages/new`, the modal form, recipient pickers, support subject chips, field validation, actions, and admin/vendor recipient search sheets embedded in the shared form.
- Messages broadcast create/detail/tile copy is localized, including create steps, selectors, recipient preview, review, detail stats/statuses, and sending state.
- Messages support detail and admin report moderation detail copy is localized, including support close/empty states, admin report party/reason/note/actions/status labels, confirmation dialogs, result snackbars, linked-conversation CTA, and the shared send-failure fallback.
- Legacy standalone Messages admin/vendor new-conversation screens are localized, including recipient selectors, form labels, validation, actions, access-denied fallbacks, and search sheets.
- Petit Boo chat shell/history copy is localized, including app bar statuses/tooltips, service banner, personalized greetings/subtitles, quick prompts, suggestions, history empty state, delete confirmation, relative dates, and message-count badge.
- Petit Boo brain/quota/limit/toast copy is localized, including memory labels/actions/dialogs, quota explanation and reset text, limit dialog wallet/actions/toasts, favorite toasts, and Hibons reward toasts.
- Petit Boo default tool schemas and shared tool-card copy are localized, including schema titles/descriptions/empty states, generic/unknown list cards, brain memory card, profile card, action confirmation card, and favorite-lists card.
- Petit Boo event/booking/trip-specific cards are localized, including event/detail counts and pricing labels, booking counts/status labels/error fallbacks, trip stop/map/save/empty/error/no-coordinate copy, and context-free Petit Boo chat/API fallback errors.
- Memberships/private-events/invitations copy is localized, including membership list tabs/search/empty states, membership cards/statuses/actions, join/cancel/leave dialogs, private-events filter/empty states, invitation accept/decline flows, members-only gate copy, and the personalized feed title.
- Partner profile/followed-organizer copy is localized, including profile load/invalid states, tabs, action buttons, contact-detail fallback, section headings, stats/count labels, follow/unfollow labels, activities tab states, reviews summary/empty states, review chips/replies, and followed-organizer search/empty/load states.
- Check-in scanner/manual/picker copy is localized, including scanner chrome, gate dialog/display, success/network/camera states, manual entry warnings/actions, confirmation and blocked-ticket sheets, vendor organization picker roles/empty state, and localized blocker reason copy in the presentation layer.
- Trip plan list/edit/card copy is localized, including list title, empty/error states, delete dialog/snackbar, stop counts, save/discard actions, and localized trip duration text.
- Reviews copy is localized, including event review lists, my reviews, review cards, write/edit/report/delete sheets, status badges, validation errors, empty states, filters/sort labels, moderation notices, and count pluralization.
- Gamification copy is localized, including dashboard, achievements, Hibons shop, how-to-earn, lucky wheel, daily reward, earnings donut, Hibons counter, Hibons animation toast, and rank-up overlay.
- Smaller active surfaces are localized, including alerts, favorites and favorite-list management, notifications inbox, reminders, onboarding, thematiques/categories, blog section/card chrome, legal links, and the shared `HbErrorView` default error fallback.
- Full pass leftovers are localized where they can surface as UI: route shell fallbacks, user questions, shared search widget, notifications/reminders relative-time badges, messages action labels, Petit Boo conversation/context fallbacks, trip-plan DTO fallbacks, search/filter/provider labels, auth/API provider fallback messages, event-question/review/favorite/alert fallbacks, dormant Home widget chrome, and review/partner/event domain display helpers.
- Direct hard-coded `featureName: '...'` / `featureName: "..."` scan under `lib/` is clean.
- Locale unit tests pass.

Next work should be release QA and backend/content localization contracts unless new screens are discovered. The latest audit did not find a `lib/features/admin` directory; the prior admin work was under Messages admin/report screens. Remaining scan hits are documented false positives: comments, mock/source data, generated-model defaults, backend matching strings, date-format patterns, brands, IDs, placeholders, and numeric/rating labels.

## Remaining Task Queue

### 1. Residual Hard-Coded-Copy Audit

Recommended order:

1. Re-run the full literal scans before release and classify new hits as UI chrome, backend/source content, generated defaults, comments, or placeholders.
2. If generated/model defaults such as `mobile_app_config` need to be user-visible in partial API payloads, clean them up with the proper codegen/build-runner path.
3. Audit notification push provider statuses only if a future UI starts rendering those raw provider messages directly.
4. Add any newly discovered visible strings to ARB files screen by screen.

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

### 3. Backend Content And API i18n Contracts

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

Scan a focused surface for accented literal strings:

```sh
rg -n --pcre2 "(['\"])(?:(?!\\1).)*[À-ÿ](?:(?!\\1).)*\\1" <paths>
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
