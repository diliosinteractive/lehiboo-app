// Catalogue des noms d'events, paramètres et user properties Firebase
// Analytics / GA4 pour l'app Le Hiboo.
//
// Règle d'or : aucun littéral d'event name ou de paramètre dans le code
// applicatif. Toujours passer par les constantes définies ici.
//
// Conventions :
// - snake_case strict.
// - Nom d'event ≤ 40 chars, nom de param ≤ 40 chars, valeur string ≤ 100,
//   nom de user property ≤ 24, valeur ≤ 36.
// - Pas de préfixe firebase_, google_ ou ga_ (réservés par GA4).
// - Standard GA4 events (login, sign_up, search, purchase, …) réutilisés
//   tels quels pour bénéficier des rapports Monetization/Engagement
//   out-of-the-box.
//
// Source de vérité du catalogue : docs/FIREBASE_ANALYTICS/05_EVENT_CATALOG.md.
// Toute modification ici doit y être reflétée et validée Produit/Marketing.
//
// Version : 1 (2026-05-18 — création).

/// Noms d'events.
class AnalyticsEvent {
  AnalyticsEvent._();

  // ─── GA4 standard events ────────────────────────────────────────────
  // Réutilisés tels quels pour les rapports built-in.
  static const String screenView = 'screen_view';
  static const String login = 'login';
  static const String signUp = 'sign_up';
  static const String search = 'search';
  static const String selectContent = 'select_content';
  static const String share = 'share';
  static const String addToWishlist = 'add_to_wishlist';
  static const String beginCheckout = 'begin_checkout';
  static const String addPaymentInfo = 'add_payment_info';
  static const String purchase = 'purchase';
  static const String refund = 'refund';

  // ─── Auth (custom) ──────────────────────────────────────────────────
  static const String signupStarted = 'signup_started';
  static const String signupFailed = 'signup_failed';
  static const String loginFailed = 'login_failed';
  static const String passwordResetRequested = 'password_reset_requested';
  static const String otpSent = 'otp_sent';
  static const String otpVerified = 'otp_verified';

  // ─── Search & discovery (custom) ────────────────────────────────────
  static const String searchSubmitted = 'search_submitted';
  static const String searchFilterApplied = 'search_filter_applied';
  static const String searchSaved = 'search_saved';
  static const String searchNoResults = 'search_no_results';
  static const String mapOpened = 'map_opened';
  static const String mapPinTapped = 'map_pin_tapped';

  // ─── Events (custom) ────────────────────────────────────────────────
  static const String eventViewed = 'event_viewed';
  static const String eventShared = 'event_shared';
  static const String removeFromWishlist = 'remove_from_wishlist';

  // ─── Booking funnel (custom) ────────────────────────────────────────
  // begin_checkout / add_payment_info / purchase / refund sont standards
  // (cf. section GA4 ci-dessus).
  static const String bookingSlotSelected = 'booking_slot_selected';
  static const String bookingCustomerFormCompleted =
      'booking_customer_form_completed';
  static const String bookingFailed = 'booking_failed';
  static const String ticketsDisplayed = 'tickets_displayed';

  // ─── Petit Boo (custom) ─────────────────────────────────────────────
  static const String petitbooChatOpened = 'petitboo_chat_opened';
  static const String petitbooMessageSent = 'petitboo_message_sent';
  static const String petitbooToolUsed = 'petitboo_tool_used';
  static const String petitbooQuotaReached = 'petitboo_quota_reached';
  static const String petitbooSessionResumed = 'petitboo_session_resumed';

  // ─── Gamification (custom) ──────────────────────────────────────────
  static const String hibonsEarned = 'hibons_earned';
  static const String hibonsRankUp = 'hibons_rank_up';

  // ─── Memberships (custom) ───────────────────────────────────────────
  static const String membershipJoinStarted = 'membership_join_started';
  static const String membershipJoinCompleted = 'membership_join_completed';
  static const String membershipInviteAccepted = 'membership_invite_accepted';

  // ─── Notifications (custom) ─────────────────────────────────────────
  static const String notificationOpened = 'notification_opened';
  static const String notificationPermissionResult =
      'notification_permission_result';

  // ─── Deeplinks (custom) ─────────────────────────────────────────────
  static const String deeplinkOpened = 'deeplink_opened';
  static const String deeplinkUnmapped = 'deeplink_unmapped';
}

/// Noms de paramètres d'event.
class AnalyticsParam {
  AnalyticsParam._();

  // ─── GA4 standard params ────────────────────────────────────────────
  static const String value = 'value';
  static const String currency = 'currency';
  static const String transactionId = 'transaction_id';
  static const String items = 'items';
  static const String itemId = 'item_id';
  static const String itemName = 'item_name';
  static const String itemCategory = 'item_category';
  static const String quantity = 'quantity';
  static const String price = 'price';
  static const String searchTerm = 'search_term';
  static const String contentType = 'content_type';
  static const String method = 'method';

  // ─── Custom — communs ───────────────────────────────────────────────
  static const String eventUuid = 'event_uuid';
  static const String bookingUuid = 'booking_uuid';
  static const String slotId = 'slot_id';
  static const String category = 'category';
  static const String source = 'source';
  static const String citySlug = 'city_slug';
  static const String reason = 'reason';
  static const String step = 'step';
  static const String channel = 'channel';
  static const String type = 'type';
  static const String length = 'length';
  static const String granted = 'granted';

  // ─── Custom — search ────────────────────────────────────────────────
  static const String query = 'query';
  static const String hasDateFilter = 'has_date_filter';
  static const String categories = 'categories';
  static const String filterType = 'filter_type';
  static const String filterValue = 'filter_value';
  static const String enablePush = 'enable_push';
  static const String enableEmail = 'enable_email';

  // ─── Custom — booking ───────────────────────────────────────────────
  static const String isFree = 'is_free';
  static const String couponUsed = 'coupon_used';
  static const String pollAttempts = 'poll_attempts';

  // ─── Custom — Petit Boo ─────────────────────────────────────────────
  static const String sessionUuid = 'session_uuid';
  static const String toolName = 'tool_name';
  static const String isVoice = 'is_voice';
  static const String quotaType = 'quota_type';

  // ─── Custom — gamification ──────────────────────────────────────────
  static const String amount = 'amount';
  static const String newRank = 'new_rank';

  // ─── Custom — memberships ───────────────────────────────────────────
  static const String organizationId = 'organization_id';

  // ─── Custom — deeplinks ─────────────────────────────────────────────
  static const String path = 'path';
  static const String host = 'host';
  static const String coldStart = 'cold_start';
  static const String utmSource = 'utm_source';
}

/// Valeurs connues pour `AnalyticsParam.source` — d'où vient l'action.
class AnalyticsSource {
  AnalyticsSource._();
  static const String homeFeed = 'home_feed';
  static const String home = 'home';
  static const String search = 'search';
  static const String map = 'map';
  static const String petitboo = 'petitboo';
  static const String favorite = 'favorite';
  static const String deepLink = 'deep_link';
  static const String voicefab = 'voicefab';
  static const String history = 'history';
  static const String coldStart = 'cold_start';
  static const String booking = 'booking';
}

/// Valeurs connues pour `AnalyticsParam.channel` (share, OTP, …).
class AnalyticsChannel {
  AnalyticsChannel._();
  static const String native = 'native';
  static const String copy = 'copy';
  static const String sms = 'sms';
  static const String email = 'email';
}

/// Valeurs connues pour `AnalyticsParam.method` (login / sign_up).
class AnalyticsMethod {
  AnalyticsMethod._();
  static const String email = 'email';
  static const String google = 'google';
  static const String apple = 'apple';
}

/// Valeurs connues pour `AnalyticsParam.type` dans `otp_sent` / `otp_verified`.
class AnalyticsOtpType {
  AnalyticsOtpType._();

  /// OTP de vérification d'inscription.
  static const String register = 'register';

  /// OTP de double authentification au login.
  static const String login = 'login';
}

/// Valeurs connues pour `AnalyticsParam.step` dans `booking_failed`.
class AnalyticsBookingStep {
  AnalyticsBookingStep._();
  static const String create = 'create';
  static const String payment = 'payment';
  static const String confirm = 'confirm';
}

/// Valeurs connues pour `AnalyticsParam.quotaType` (`petitboo_quota_reached`).
class AnalyticsQuotaType {
  AnalyticsQuotaType._();
  static const String daily = 'daily';
  static const String monthly = 'monthly';
}

/// Noms des user properties (set via `AnalyticsService.setUserProperty`).
///
/// Doivent être déclarées dans la console GA4 (Admin → Custom Definitions
/// → User properties) **avant** le rollout, sinon les valeurs partent mais
/// ne sont pas exploitables dans les rapports.
class AnalyticsUserProperty {
  AnalyticsUserProperty._();

  /// `development` | `staging` | `production` — set au boot dans main.dart.
  static const String env = 'env';

  /// `visitor` | `subscriber` | `partner` | `admin`.
  static const String userRole = 'user_role';

  /// `fr` | `en`.
  static const String appLocale = 'app_locale';

  /// `true` | `false` | `unknown`.
  static const String hasMembership = 'has_membership';

  /// Slug ville ou `none`.
  static const String homeCitySlug = 'home_city_slug';

  /// `bronze` | `silver` | `gold` | `legend`.
  static const String hibonsRank = 'hibons_rank';

  /// `true` | `false`.
  static const String pushEnabled = 'push_enabled';

  /// `granted` | `denied` | `unknown` — consentement analytics maison.
  static const String notifConsent = 'notif_consent';

  /// `authorized` | `denied` | `restricted` | `not_determined` (iOS uniquement).
  static const String iosAttStatus = 'ios_att_status';
}

/// Valeurs connues pour `AnalyticsUserProperty.userRole`.
///
/// Mappe sur `UserRole` (`subscriber` | `partner` | `admin`) côté entité
/// `HbUser`. La valeur `visitor` est réservée aux sessions non authentifiées.
class AnalyticsUserRole {
  AnalyticsUserRole._();
  static const String visitor = 'visitor';
  static const String subscriber = 'subscriber';
  static const String partner = 'partner';
  static const String admin = 'admin';
}
