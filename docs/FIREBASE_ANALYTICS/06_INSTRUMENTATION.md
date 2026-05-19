# Étape 6 — Instrumentation feature par feature

Objectif : poser les `analytics.logEvent(...)` dans le code, en cohérence avec le catalogue de l'[étape 5](05_EVENT_CATALOG.md).

## 6.1 Règles transverses

- **Toujours** passer par `ref.read(analyticsServiceProvider)`. Aucun `FirebaseAnalytics.instance` direct.
- **Fire-and-forget** : pas d'`await` dans le flow utilisateur. Si l'event échoue, on s'en fiche.
- **Nom & params via constantes** : `AnalyticsEvent.eventViewed`, `AnalyticsParam.eventUuid`. Jamais de string littérale.
- **Pas de PII** : ne jamais logger email/nom/tel.
- **Pas dans `build()`** : un event = une action utilisateur ou un résultat asynchrone, jamais un side-effect de rebuild.

## 6.2 Plan d'instrumentation par feature

Pour chaque feature ci-dessous : fichier(s) cible(s) + events à poser. Cocher au fur et à mesure.

### Auth — `lib/features/auth/`

Fichier principal : [auth_provider.dart](../../lib/features/auth/presentation/providers/auth_provider.dart)

- [ ] `login` (standard) — après succès login, param `method`.
- [ ] `login_failed` — dans le catch, avec `reason` normalisé.
- [ ] `sign_up` (standard) — après succès signup.
- [ ] `signup_failed` — dans le catch.
- [ ] `setUserId(user.id)` + reset properties (cf. étape 4).
- [ ] `otp_sent`, `otp_verified`, `password_reset_requested`.

Écrans signup à instrumenter pour `signup_started` (params `source`) :

- [ ] Bouton login/signup depuis la home.
- [ ] Modal de connexion forcée au tap "réserver" / "ajouter aux favoris" si non connecté.

### Search & filtres — `lib/features/search/` et widgets de recherche (cf. [CLAUDE.md](../../CLAUDE.md))

- [ ] `search_submitted` au submit de `AirbnbSearchSheet`.
- [ ] `search` (standard) en miroir, avec `search_term`.
- [ ] `search_filter_applied` à chaque toggle dans `FilterBottomSheet`.
- [ ] `search_no_results` après réponse API vide.
- [ ] `search_saved` dans `alertsProvider.createAlert(...)`.
- [ ] `map_opened` dans le screen `MapViewScreen`.
- [ ] `map_pin_tapped` dans le handler de pin.

### Events — fiches détail & cartes

- [ ] `event_viewed` dans `initState` de l'écran de détail (param `source` passé via `extra` du GoRoute).
- [ ] `select_content` (standard) au tap d'une card event sur la home / search / map.
- [ ] `event_shared` dans le handler `share_plus`.

### Favoris — `lib/features/favorites/`

Fichier : [favorites_repository_impl.dart](../../lib/features/favorites/data/repositories/favorites_repository_impl.dart)

- [ ] `add_to_wishlist` (standard) après `toggle` qui passe à favori.
- [ ] `remove_from_wishlist` après `toggle` qui retire.

⚠️ Logger côté **provider/use-case** plutôt que repository si l'event doit refléter une action utilisateur (et pas une sync programmatique).

### Booking — `lib/features/booking/`

Fichier central : [booking_flow_controller.dart](../../lib/features/booking/presentation/controllers/booking_flow_controller.dart)

- [ ] `begin_checkout` (standard) au lancement du flow (`createBooking` côté provider, **pas** dans le repository).
- [ ] `booking_slot_selected` au choix du créneau.
- [ ] `booking_customer_form_completed` au submit du form client.
- [ ] `add_payment_info` (standard) avant `Stripe.confirmPayment`.
- [ ] `purchase` (standard) après `confirmBooking` ou `confirmFreeBooking` OK — params `transaction_id = booking_uuid`, `value`, `currency: 'EUR'`, `items: [{item_id, item_name, quantity, price}]`.
- [ ] `booking_failed` à chaque étape qui échoue (param `step`, `reason`).
- [ ] `tickets_displayed` quand le polling retourne ≥ 1 ticket (param `poll_attempts`).
- [ ] `refund` (standard) après annulation réussie.

### Petit Boo — `lib/features/petit_boo/`

- [ ] `petitboo_chat_opened` dans `PetitBooChatScreen.initState` ou au montage du provider — détecter `source` via `state.uri.queryParameters`.
- [ ] `petitboo_message_sent` dans `petit_boo_chat_provider.sendMessage(...)`.
- [ ] `petitboo_tool_used` dans le handler SSE `tool_result` (`petit_boo_sse_datasource.dart`) — param `tool_name`.
- [ ] `petitboo_quota_reached` quand `LimitReachedDialog` s'affiche.
- [ ] `petitboo_session_resumed` quand l'URL contient `?session=xxx`.

### Hibons — `lib/features/gamification/`

Fichier : [hibons_service.dart](../../lib/features/gamification/application/hibons_service.dart)

- [ ] `hibons_earned` à chaque crédit (param `amount`, `source`).
- [ ] `hibons_rank_up` au passage de rang.

### Memberships — `lib/features/memberships/`

- [ ] `membership_join_started`, `membership_join_completed`, `membership_invite_accepted`.

### Notifications — `lib/features/notifications/` + [push_notification_service.dart](../../lib/core/services/push_notification_service.dart)

- [ ] `notification_permission_result` après prompt OneSignal.
- [ ] `notification_opened` dans le click listener OneSignal (déjà capturé en cold start, voir `oneSignalColdStartClickListener` dans `main.dart` ligne 123).

## 6.3 Ordre d'attaque conseillé

1. **Auth** (étape 4 déjà branchée → ajouter juste les events).
2. **Booking funnel** (KPI #1 business).
3. **Event view + favoris** (deuxième brique du funnel).
4. **Search**.
5. **Petit Boo**.
6. **Hibons, memberships, notifications**.

Cette séquence donne déjà 80% de la valeur métier après les 3 premières features.

## 6.4 Tests

Pas de test unitaire spécifique par event (couplage trop fort). À la place :

- **Test du service** : `AnalyticsService` mockable, vérifier que sanitization/no-op marchent.
- **Tests d'intégration manuels** via DebugView (cf. [08_DEBUG_QA.md](08_DEBUG_QA.md)).
- Optionnel : ajouter un widget test qui vérifie qu'un tap sur "favori" appelle `analytics.logEvent(AnalyticsEvent.addToWishlist, ...)` via un mock.

## Critères de sortie

- [ ] Toutes les cases cochées dans la section 6.2.
- [ ] Aucun littéral d'event name dans `lib/features/**` (vérification : `grep "logEvent('"` doit ne ramener que `analytics_event.dart`).
- [ ] DebugView montre les events critiques du funnel booking de bout en bout.
