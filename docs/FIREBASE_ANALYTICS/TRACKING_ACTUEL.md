# Firebase Analytics — Tracking actuel de l'app Le Hiboo

> Document de référence : **ce qui est réellement instrumenté dans le code** au
> 2026-06-02. Généré à partir des call sites `logEvent` / `setUserProperty` /
> `setUserId` présents dans `lib/`.
>
> Catalogue des constantes : [lib/core/analytics/analytics_event.dart](../../lib/core/analytics/analytics_event.dart)
> Service : [lib/core/analytics/analytics_service.dart](../../lib/core/analytics/analytics_service.dart)

---

## 1. Architecture du tracking

Aucun accès direct à `FirebaseAnalytics.instance` dans le code applicatif. Tout
passe par l'abstraction `AnalyticsService`, injectée via le provider Riverpod
`analyticsServiceProvider`.

| Élément | Fichier | Rôle |
|---------|---------|------|
| `AnalyticsService` (interface) | [analytics_service.dart](../../lib/core/analytics/analytics_service.dart) | Contrat `logEvent` / `setUserId` / `setUserProperty` / `setCollectionEnabled` / `createObserver` |
| `FirebaseAnalyticsService` | [analytics_service.dart](../../lib/core/analytics/analytics_service.dart) | Implémentation Firebase + sanitization + try/catch silencieux |
| `NoopAnalyticsService` | [noop_analytics_service.dart](../../lib/core/analytics/noop_analytics_service.dart) | Implémentation inerte (si Firebase échoue à s'init **ou** consentement refusé) |
| `AnalyticsEvent` / `AnalyticsParam` / `AnalyticsUserProperty` | [analytics_event.dart](../../lib/core/analytics/analytics_event.dart) | Catalogue des constantes (snake_case, **aucun littéral dans le code**) |
| `AnalyticsConsentNotifier` | [analytics_consent.dart](../../lib/core/analytics/analytics_consent.dart) | Consentement RGPD → active/désactive la collecte |

### Sanitization automatique (`FirebaseAnalyticsService`)

- Nom d'event > 40 chars → **droppé**.
- Nom de paramètre > 40 chars → **droppé**.
- Valeur string > 100 chars → **tronquée**.
- Valeur user property > 36 chars → **tronquée**.
- `bool` → `"true"`/`"false"`, `DateTime` → ISO8601, `Enum` → `.name`.
- Paramètre `null` → ignoré.
- Toute erreur d'envoi est avalée (log debug uniquement), jamais remontée.

### Consentement RGPD (état actuel)

- Au boot ([main.dart:134](../../lib/main.dart#L134)), la collecte est **désactivée par défaut**
  (`setCollectionEnabled(false)`).
- Elle n'est (ré)activée que si le consentement persisté vaut `granted`
  ([main.dart:192](../../lib/main.dart#L192)).
- Le toggle Settings et le consent gate modal appellent `grant()` / `deny()`
  ([analytics_consent.dart](../../lib/core/analytics/analytics_consent.dart)).
- **Conséquence : tant que l'utilisateur n'a pas consenti, tous les `logEvent`
  ci-dessous sont des no-ops côté Firebase** (les appels partent mais ne sont
  pas collectés).

---

## 2. Screen views (navigation)

Le `screen_view` standard GA4 est émis **automatiquement** par un
`FirebaseAnalyticsObserver` attaché aux Navigators (root GoRouter + ShellRoutes)
via `AnalyticsService.createObserver()`.

- Le `screen_name` provient de `RouteSettings.name`.
- Les routes **sans nom explicite** (modaux, bottom sheets) **n'émettent pas**
  de `screen_view` — comportement voulu pour éviter les écrans parasites.

---

## 3. User properties

Propriétés posées sur la session / l'utilisateur (visibles dans GA4 → Custom
Definitions). Elles doivent être déclarées côté console GA4 pour être
exploitables.

| Propriété | Valeurs | Posée où | Quand |
|-----------|---------|----------|-------|
| `env` | `development` / `staging` / `production` | [main.dart:135](../../lib/main.dart#L135) | Au boot |
| `app_locale` | `fr` / `en` | [main.dart:182](../../lib/main.dart#L182), [app_locale.dart:64](../../lib/core/l10n/app_locale.dart#L64) | Au boot + à chaque changement de langue |
| `notif_consent` | `granted` / `denied` / `unknown` | [main.dart:195](../../lib/main.dart#L195), [analytics_consent.dart](../../lib/core/analytics/analytics_consent.dart) | Au boot + à chaque décision de consentement |
| `user_role` | `visitor` / `subscriber` / `partner` / `admin` | [auth_provider.dart:566](../../lib/features/auth/presentation/providers/auth_provider.dart#L566) | À chaque transition d'utilisateur (login/logout) |
| `home_city_slug` | slug ville ou `none` | [auth_provider.dart:570](../../lib/features/auth/presentation/providers/auth_provider.dart#L570) | À chaque transition d'utilisateur |
| `push_enabled` | `true` / `false` | [push_notification_service.dart:165](../../lib/core/services/push_notification_service.dart#L165) | À la réponse à la demande de permission push |
| `hibons_rank` | `bronze` / `silver` / `gold` / `legend` | [hibons_service.dart:138](../../lib/features/gamification/application/hibons_service.dart#L138) | À chaque montée de rang |

### `user_id`

- **Set** sur `user.id` à chaque login/auth réussie ([auth_provider.dart:565](../../lib/features/auth/presentation/providers/auth_provider.dart#L565)).
- **Reset à `null`** à la déconnexion (purge `user_role` + `home_city_slug`
  pour ne pas coller l'ancien profil au prochain compte).

### Déclarées mais non encore posées

`has_membership` et `ios_att_status` sont définies dans le catalogue
(`AnalyticsUserProperty`) mais **ne sont écrites nulle part** dans le code
actuel.

---

## 4. Events trackés (par domaine)

> Légende : **(GA4)** = event standard GA4 réutilisé tel quel (rapports
> built-in) ; **(custom)** = event maison.

### 4.1 Authentification — [auth_provider.dart](../../lib/features/auth/presentation/providers/auth_provider.dart)

| Event | Type | Paramètres | Déclenché quand |
|-------|------|------------|-----------------|
| `login` | GA4 | `method` (`email`) | Login direct réussi ([L133](../../lib/features/auth/presentation/providers/auth_provider.dart#L133)) ou login OTP réussi ([L296](../../lib/features/auth/presentation/providers/auth_provider.dart#L296)) |
| `login_failed` | custom | `reason` (catégorie d'erreur) | Échec de login ([L151](../../lib/features/auth/presentation/providers/auth_provider.dart#L151)) |
| `sign_up` | GA4 | `method` (`email`) | OTP d'inscription vérifié ([L220](../../lib/features/auth/presentation/providers/auth_provider.dart#L220)) ou auth posée directement (registration business, [L439](../../lib/features/auth/presentation/providers/auth_provider.dart#L439)) |
| `signup_failed` | custom | `reason` (catégorie d'erreur) | Échec d'inscription |
| `password_reset_requested` | custom | — | Demande de reset mot de passe |
| `signup_started` | custom | `method` (`email`) | Soumission du formulaire d'inscription ([L177](../../lib/features/auth/presentation/providers/auth_provider.dart#L177)) — avant l'API |
| `otp_sent` | custom | `type` (`register`/`login`) | OTP envoyé : succès register ([L199](../../lib/features/auth/presentation/providers/auth_provider.dart#L199)), login 2FA ([L124](../../lib/features/auth/presentation/providers/auth_provider.dart#L124)), renvoi manuel ([L290](../../lib/features/auth/presentation/providers/auth_provider.dart#L290)) |
| `otp_verified` | custom | `type` (`register`/`login`) | OTP vérifié : inscription ([L239](../../lib/features/auth/presentation/providers/auth_provider.dart#L239)) ou login 2FA ([L324](../../lib/features/auth/presentation/providers/auth_provider.dart#L324)) |

### 4.2 Recherche & découverte

| Event | Type | Paramètres | Call site |
|-------|------|------------|-----------|
| `search_submitted` | custom | `query`, `city_slug`, `categories` (CSV), `has_date_filter` | [airbnb_search_sheet.dart:124](../../lib/features/search/presentation/widgets/airbnb_search_sheet.dart#L124) |
| `search` | GA4 | `search_term` | [airbnb_search_sheet.dart:135](../../lib/features/search/presentation/widgets/airbnb_search_sheet.dart#L135) (seulement si query non vide) |
| `search_saved` | custom | `enable_push`, `enable_email`, `city_slug` | [alerts_provider.dart:67](../../lib/features/alerts/presentation/providers/alerts_provider.dart#L67) |
| `search_no_results` | custom | `query`, `city_slug`, `categories`, `has_date_filter` | [search_screen.dart:62](../../lib/features/search/presentation/screens/search_screen.dart#L62) — recherche réelle sans résultat, dédupliquée par filtre |
| `map_opened` | custom | `source` (`home` / `deep_link`) | [map_view_screen.dart:67](../../lib/features/events/presentation/screens/map_view_screen.dart#L67) |
| `map_pin_tapped` | custom | `event_uuid`, `quantity` (nb d'events sous le pin) | [map_view_screen.dart:255](../../lib/features/events/presentation/screens/map_view_screen.dart#L255) |

### 4.3 Événements (consultation, favoris, partage)

| Event | Type | Paramètres | Call site |
|-------|------|------------|-----------|
| `event_viewed` | custom | `event_uuid`, `category`, `city_slug`, `is_free` | [event_detail_screen.dart:269](../../lib/features/events/presentation/screens/event_detail_screen.dart#L269) — fire-once par chargement |
| `add_to_wishlist` | GA4 | `item_id`, `item_name`, `item_category` | [favorites_provider.dart:130](../../lib/features/favorites/presentation/providers/favorites_provider.dart#L130) (si ajout) |
| `remove_from_wishlist` | custom | `item_id`, `item_name`, `item_category` | [favorites_provider.dart:130](../../lib/features/favorites/presentation/providers/favorites_provider.dart#L130) (si retrait) |
| `event_shared` | custom | `event_uuid`, `channel` (`native`) | [event_share_sheet.dart:50](../../lib/features/events/presentation/widgets/detail/event_share_sheet.dart#L50) |
| `share` | GA4 | `content_type` (`event`), `item_id` | [event_share_sheet.dart:58](../../lib/features/events/presentation/widgets/detail/event_share_sheet.dart#L58) |

### 4.4 Funnel de réservation — [booking_flow_controller.dart](../../lib/features/booking/presentation/controllers/booking_flow_controller.dart)

| Event | Type | Paramètres | Étape |
|-------|------|------------|-------|
| `begin_checkout` | GA4 | `event_uuid`, `value`, `currency`, `is_free` | Ouverture du BookingScreen ([L46](../../lib/features/booking/presentation/controllers/booking_flow_controller.dart#L46)) |
| `booking_slot_selected` | custom | `event_uuid`, `slot_id` | Sélection d'un créneau ([L66](../../lib/features/booking/presentation/controllers/booking_flow_controller.dart#L66)) |
| `booking_customer_form_completed` | custom | `event_uuid` | Formulaire acheteur validé ([L120](../../lib/features/booking/presentation/controllers/booking_flow_controller.dart#L120)) |
| `add_payment_info` | GA4 | `event_uuid`, `value`, `currency` | Soumission paiement payant ([L159](../../lib/features/booking/presentation/controllers/booking_flow_controller.dart#L159)) |
| `purchase` | GA4 | `transaction_id` (= booking uuid), `value`, `currency`, `event_uuid`, `is_free` | Réservation confirmée ([L221](../../lib/features/booking/presentation/controllers/booking_flow_controller.dart#L221)) |
| `tickets_displayed` | custom | `booking_uuid`, `quantity` (nb billets) | Billets récupérés ([L233](../../lib/features/booking/presentation/controllers/booking_flow_controller.dart#L233)) |
| `booking_failed` | custom | `event_uuid`, `step` (`create`/`payment`/`confirm`), `reason` | Échec dans le flow ([L249](../../lib/features/booking/presentation/controllers/booking_flow_controller.dart#L249)) |
| `refund` | GA4 | `transaction_id` (= booking uuid), `value`, `currency` (`EUR`) | Annulation réussie ([booking_detail_screen.dart:381](../../lib/features/booking/presentation/screens/booking_detail_screen.dart#L381)) |

> `purchase` et `refund` partagent le même `transaction_id` (= `booking.id`)
> pour s'apparier dans les rapports Monetization GA4.

### 4.5 Petit Boo (assistant IA)

| Event | Type | Paramètres | Call site |
|-------|------|------------|-----------|
| `petitboo_chat_opened` | custom | `source` (`voicefab`/`history`/`cold_start`), `session_uuid`* | [petit_boo_chat_screen.dart:52](../../lib/features/petit_boo/presentation/screens/petit_boo_chat_screen.dart#L52) |
| `petitboo_session_resumed` | custom | `session_uuid` | [petit_boo_chat_screen.dart:67](../../lib/features/petit_boo/presentation/screens/petit_boo_chat_screen.dart#L67) |
| `petitboo_message_sent` | custom | `length` (nb chars), `is_voice` (`false`), `session_uuid`* | [petit_boo_chat_provider.dart:319](../../lib/features/petit_boo/presentation/providers/petit_boo_chat_provider.dart#L319) |
| `petitboo_tool_used` | custom | `tool_name` | [petit_boo_chat_provider.dart:415](../../lib/features/petit_boo/presentation/providers/petit_boo_chat_provider.dart#L415) (par tool MCP exécuté) |
| `petitboo_quota_reached` | custom | `quota_type` (`daily`) | [petit_boo_chat_provider.dart:312](../../lib/features/petit_boo/presentation/providers/petit_boo_chat_provider.dart#L312) |

\* paramètre conditionnel (présent seulement si `session_uuid` non null).

### 4.6 Gamification (Hibons) — [hibons_service.dart](../../lib/features/gamification/application/hibons_service.dart)

| Event | Type | Paramètres | Déclenché quand |
|-------|------|------------|-----------------|
| `hibons_earned` | custom | `amount` (delta), `source` | Gain de Hibons (delta > 0 uniquement — les débits manuels sont ignorés) ([L124](../../lib/features/gamification/application/hibons_service.dart#L124)) |
| `hibons_rank_up` | custom | `new_rank` | Montée de rang ([L133](../../lib/features/gamification/application/hibons_service.dart#L133)) — pose aussi la user property `hibons_rank` |

### 4.7 Memberships — [membership_state_providers.dart](../../lib/features/memberships/presentation/providers/membership_state_providers.dart)

| Event | Type | Paramètres | Call site |
|-------|------|------------|-----------|
| `membership_join_started` | custom | `organization_id` | [membership_state_providers.dart:81](../../lib/features/memberships/presentation/providers/membership_state_providers.dart#L81) |
| `membership_join_completed` | custom | `organization_id` | [membership_state_providers.dart:92](../../lib/features/memberships/presentation/providers/membership_state_providers.dart#L92) |
| `membership_invite_accepted` | custom | — | [memberships_screen_providers.dart:63](../../lib/features/memberships/presentation/providers/memberships_screen_providers.dart#L63) |

### 4.8 Notifications push — [push_notification_service.dart](../../lib/core/services/push_notification_service.dart)

| Event | Type | Paramètres | Déclenché quand |
|-------|------|------------|-----------------|
| `notification_permission_result` | custom | `granted` (`true`/`false`) | Réponse à la demande de permission ([L161](../../lib/core/services/push_notification_service.dart#L161)) — pose aussi `push_enabled` |
| `notification_opened` | custom | `type` (type de notif), `source` (`cold_start`)* | Tap sur une notification ([L247](../../lib/core/services/push_notification_service.dart#L247), [L256](../../lib/core/services/push_notification_service.dart#L256), [L270](../../lib/core/services/push_notification_service.dart#L270)) |

\* `source: cold_start` seulement quand l'app est lancée depuis une notif (replay cold-start).

### 4.9 Deeplinks — [deeplink_listener.dart](../../lib/core/deeplinks/deeplink_listener.dart)

| Event | Type | Paramètres | Déclenché quand |
|-------|------|------------|-----------------|
| `deeplink_opened` | custom | `source` (plateforme), `path`, `cold_start`, `utm_source`* | Deeplink mappé vers une route ([L99](../../lib/core/deeplinks/deeplink_listener.dart#L99)) |
| `deeplink_unmapped` | custom | `host`, `path` | Deeplink **non** mappé ([L89](../../lib/core/deeplinks/deeplink_listener.dart#L89)) |

\* `utm_source` présent seulement si dans les query params.

---

## 5. Events déclarés mais NON instrumentés

Définis dans le catalogue `AnalyticsEvent` mais **sans aucun call site** dans
le code actuel (réservés pour usage futur) :

- `select_content` (GA4)
- `search_filter_applied`

> ✅ `signup_started`, `otp_sent`, `otp_verified` et `search_no_results` ont été
> instrumentés (commit `3af9ed4`) — ils sont désormais actifs (cf. §4.1 et §4.2).

User properties déclarées mais non posées : `has_membership`, `ios_att_status`.

---

## 6. Récapitulatif

| Domaine | Events actifs |
|---------|---------------|
| Navigation | 1 (`screen_view` auto) |
| Auth | 8 |
| Recherche & découverte | 6 |
| Événements | 5 |
| Réservation | 8 |
| Petit Boo | 5 |
| Gamification | 2 |
| Memberships | 3 |
| Notifications | 2 |
| Deeplinks | 2 |
| **Total events** | **42** (+ 2 déclarés inactifs) |

| User properties actives | 7 (`env`, `app_locale`, `notif_consent`, `user_role`, `home_city_slug`, `push_enabled`, `hibons_rank`) + `user_id` |
