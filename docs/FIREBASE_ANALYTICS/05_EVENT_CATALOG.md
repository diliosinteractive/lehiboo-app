# Étape 5 — Catalogue d'events

Objectif : figer **une seule fois** les noms et paramètres des events avant d'instrumenter (étape 6). Toute dérive de nommage rend les rapports GA4 inutilisables.

## 5.1 Conventions de nommage

| Règle | Détail |
|---|---|
| Casse | `snake_case` strict |
| Longueur | nom ≤ 40 chars, paramètre ≤ 40 chars, valeur string ≤ 100 chars |
| Préfixe | éviter `firebase_`, `google_`, `ga_` (réservés) |
| Verbe | passé : `event_viewed` pas `view_event` (cohérent avec GA4 built-in `screen_view`) |
| Domaine | préfixer par domaine quand pertinent : `booking_started`, `petitboo_message_sent` |
| Constantes | toutes les chaînes dans `lib/core/analytics/analytics_event.dart` — **jamais** de littéral dans le code applicatif |

## 5.2 Standard events GA4 à privilégier quand ils matchent

Firebase recommande de réutiliser les noms standards pour bénéficier des rapports e-commerce et engagement out-of-the-box :

| Standard event | Usage Hiboo |
|---|---|
| `screen_view` | géré par l'observer (étape 3) — ne pas logger manuellement |
| `login` | post-login (param `method: email|google|apple`) |
| `sign_up` | post-signup |
| `search` | au submit recherche (param `search_term`) |
| `select_content` | au clic sur une card event/blog (param `content_type`, `item_id`) |
| `share` | au partage natif d'un event |
| `add_to_wishlist` | au tap "favori" (param `item_id`, `item_category`) |
| `begin_checkout` | au lancement d'une réservation (param `value`, `currency`, `items[]`) |
| `add_payment_info` | quand le PaymentSheet Stripe s'ouvre |
| `purchase` | après `confirmBooking` ou `confirmFreeBooking` réussi (param `transaction_id`, `value`, `currency`, `items[]`) |
| `refund` | après annulation de booking |

Ces events alimentent automatiquement les rapports GA4 Monetization et Engagement → **à utiliser systématiquement** quand applicable.

## 5.3 Events custom — par domaine

### Auth

| Event | Quand | Params |
|---|---|---|
| `signup_started` | ouverture écran signup | `source: home|booking|favorite|petitboo` |
| `signup_failed` | erreur création | `reason` |
| `login_failed` | erreur login | `reason: invalid_credentials|network|otp_invalid` |
| `password_reset_requested` | demande reset | — |
| `otp_sent` / `otp_verified` | flow OTP | `channel: sms|email` |

### Search & discovery

| Event | Params |
|---|---|
| `search_submitted` | `query`, `city_slug`, `categories`, `has_date_filter` |
| `search_filter_applied` | `filter_type`, `filter_value` |
| `search_saved` | `enable_push`, `enable_email` (cf. feature Alerts dans [CLAUDE.md](../../CLAUDE.md)) |
| `search_no_results` | `query`, `city_slug` |
| `map_opened` | `source: home|search` |
| `map_pin_tapped` | `event_uuid` |

### Events

| Event | Params |
|---|---|
| `event_viewed` | `event_uuid`, `category`, `city_slug`, `is_free`, `source: home_feed|search|map|petitboo|favorite|deep_link` |
| `event_shared` | `event_uuid`, `channel: native|copy` |
| `add_to_wishlist` *(standard)* | `item_id: event_uuid`, `item_category`, `item_name` |
| `remove_from_wishlist` | idem |

### Booking funnel

| Event | Params |
|---|---|
| `begin_checkout` *(standard)* | `value`, `currency: EUR`, `items[]` |
| `booking_slot_selected` | `event_uuid`, `slot_id` |
| `booking_customer_form_completed` | `event_uuid` |
| `add_payment_info` *(standard)* | `event_uuid`, `value`, `coupon_used: bool` |
| `purchase` *(standard)* | `transaction_id: booking_uuid`, `value`, `currency`, `items[]` |
| `booking_failed` | `event_uuid`, `step: create|payment|confirm`, `reason` |
| `refund` *(standard)* | `transaction_id`, `value` (= cancel) |
| `tickets_displayed` | `booking_uuid`, `poll_attempts` (cf. polling dans [CLAUDE.md](../../CLAUDE.md)) |

### Petit Boo

| Event | Params |
|---|---|
| `petitboo_chat_opened` | `source: voicefab|home|history|cold_start`, `session_uuid?` |
| `petitboo_message_sent` | `length`, `is_voice: bool` |
| `petitboo_tool_used` | `tool_name` (cf. liste des outils MCP dans [CLAUDE.md](../../CLAUDE.md)) |
| `petitboo_quota_reached` | `quota_type: daily|monthly` |
| `petitboo_session_resumed` | `session_uuid` |

### Gamification (Hibons)

| Event | Params |
|---|---|
| `hibons_earned` | `amount`, `source: session|booking|review|share` |
| `hibons_rank_up` | `new_rank` |

### Memberships

| Event | Params |
|---|---|
| `membership_join_started` | `organization_id` |
| `membership_join_completed` | `organization_id` |
| `membership_invite_accepted` | `organization_id` |

### Notifications

| Event | Params |
|---|---|
| `notification_opened` | `type`, `event_uuid?` (au cold start cf. OneSignal handler) |
| `notification_permission_result` | `granted: bool` |

## 5.4 Paramètres réservés à éviter

GA4 réserve certains noms (`firebase_*`, `google_*`, `ga_*`). Aussi éviter de surcharger les params standards (`value`, `currency`, `transaction_id`, `items`) avec des sémantiques différentes.

## 5.5 Limites à garder en tête

| Quota | Limite |
|---|---|
| Events custom distincts par app | 500 |
| Paramètres custom par event | 25 |
| Valeurs distinctes d'un param string (cardinalité) | haute = sampling. Éviter `event_uuid` comme **clé de regroupement** dans un rapport, le garder en param fin. |

→ Le catalogue ci-dessus tient largement sous 500. Marge confortable pour les futurs ajouts.

## 5.6 Livrable de l'étape

Créer **un seul fichier de constantes** : `lib/core/analytics/analytics_event.dart`. Une `class AnalyticsEvent` avec des `static const String` pour chaque event, plus une `class AnalyticsParam` pour les noms de params. Aucun event ne doit être loggé via un littéral en dur dans le reste du code.

## Critères de sortie

- [ ] Catalogue validé par Produit + Marketing (signoff Slack ou doc).
- [ ] `analytics_event.dart` créé avec toutes les constantes.
- [ ] User properties (cf. étape 4) et events custom déclarés dans la console GA4 (Custom Definitions → Dimensions/Metrics) **avant** le rollout, sinon les rapports ne voient pas les params custom.
