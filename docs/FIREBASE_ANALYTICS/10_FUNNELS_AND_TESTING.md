# Funnels instrumentés & guide de test

Récapitulatif de tous les events analytics actuellement posés dans l'app, avec
le **chemin utilisateur exact** qui les déclenche et les **paramètres à
vérifier** dans Firebase DebugView.

> ⚠️ **Important** : la collecte est **désactivée par défaut** au boot
> (`setCollectionEnabled(false)` dans [main.dart](../../lib/main.dart)). Pour
> tester, suivre la section **Activation temporaire** ci-dessous.

---

## 0. Pré-requis pour tester

### 0.1 Activation temporaire de la collecte

Le consent gate (étape 7) n'étant pas encore livré, ajouter
**temporairement** dans `lib/main.dart`, juste après
`await analytics.setCollectionEnabled(false)` :

```dart
// TEMPORAIRE — à retirer avant merge
if (EnvConfig.isDevelopment) await analytics.setCollectionEnabled(true);
```

### 0.2 Activer DebugView

**Android** (depuis un terminal du Mac, device connecté en USB) :
```bash
adb shell setprop debug.firebase.analytics.app com.dilios.lehibooexperience
```
Désactiver : `adb shell setprop debug.firebase.analytics.app .none.`

**iOS** : Xcode → Edit Scheme → Run → Arguments → Arguments Passed On Launch
→ ajouter `-FIRDebugEnabled`.

### 0.3 Ouvrir DebugView

Firebase Console → projet `lehiboo-77c35` → Analytics → **DebugView** → en
haut, sélectionner le device dans le picker. Les events apparaissent en
quasi temps réel (~10 s).

### 0.4 Vérifier user properties

Au début de chaque session de test, dans DebugView, vérifier le panneau
**User properties** du device :

| Property | Valeur attendue |
|---|---|
| `env` | `development` (ou `staging` / `production`) |
| `app_locale` | `fr` ou `en` selon la langue de l'app |
| `user_role` | `subscriber` / `partner` / `admin` après login, vide si non connecté |
| `home_city_slug` | ville du profil après login, vide sinon |
| `hibons_rank` | rang Hibons après login (rempli quand le backend renvoie un `hibons_update`) |
| `push_enabled` | `true` / `false` après le prompt OneSignal |

---

## 1. Funnel Booking (KPI #1 business)

**Le funnel central**. Conversion attendue : `begin_checkout → purchase`.

### Chemin de test complet

1. Ouvrir une fiche événement payant
2. Tap "Réserver" → BookingScreen s'ouvre
3. Sélectionner un créneau
4. Tap "Continuer" → écran participants
5. Remplir le formulaire client
6. Tap "Continuer" → écran paiement
7. Payer en mode test Stripe (carte `4242 4242 4242 4242`)
8. Confirmation s'affiche, billets arrivent
9. Aller sur "Mes réservations" → ouvrir la résa → "Annuler"

### Events attendus, dans l'ordre

| # | Event | Standard ? | Quand | Params critiques |
|---|---|---|---|---|
| 1 | `begin_checkout` | ✓ GA4 | Construction du BookingFlowController (= ouverture BookingScreen) | `event_uuid`, `value`, `currency`, `is_free` |
| 2 | `booking_slot_selected` | custom | Tap sur un créneau | `event_uuid`, `slot_id` |
| 3 | `booking_customer_form_completed` | custom | Tap "Continuer" depuis le form client | `event_uuid` |
| 4 | `add_payment_info` | ✓ GA4 | Avant `Stripe.confirmPayment` (tap "Payer") | `event_uuid`, `value`, `currency` |
| 5 | `purchase` | ✓ GA4 | Après `confirmBooking` OK + tickets récupérés | `transaction_id` (= booking UUID), `value`, `currency`, `event_uuid`, `is_free` |
| 6 | `tickets_displayed` | custom | Quand `tickets.isNotEmpty` | `booking_uuid`, `quantity` |
| 7 | `refund` | ✓ GA4 | Annulation réussie depuis `BookingDetailScreen` | `transaction_id`, `value`, `currency` |

### Cas d'échec à tester

- **Booking gratuit** : sauter Stripe — vérifier que `add_payment_info` n'est **pas** envoyé, mais que `purchase` part avec `value: 0` et `is_free: true`.
- **Échec création** : couper le réseau avant `_submitBooking` → `booking_failed` avec `step: create`, `reason: DioException`.
- **Échec confirm** : intercepter `/v1/bookings/{uuid}/confirm` côté backend → `booking_failed` avec `step: confirm`.

### Fichiers
- [lib/features/booking/presentation/controllers/booking_flow_controller.dart](../../lib/features/booking/presentation/controllers/booking_flow_controller.dart)
- [lib/features/booking/presentation/screens/booking_detail_screen.dart](../../lib/features/booking/presentation/screens/booking_detail_screen.dart)

---

## 2. Funnel Auth

### Chemin de test : signup complet

1. Logout si connecté
2. Aller sur `/register/customer`
3. Remplir le formulaire, submit
4. Saisir l'OTP reçu par mail
5. Login OK

| # | Event | Quand | Params |
|---|---|---|---|
| 1 | `sign_up` (✓ GA4) | Après `verifyOtp` réussi en flow registration | `method: email` |
| 2 | `user_id` GA4 | idem | UUID utilisateur |
| 3 | User properties `user_role`, `home_city_slug` | idem | Mises à jour |

### Chemin de test : login

| # | Event | Quand | Params |
|---|---|---|---|
| 1 | `login` (✓ GA4) | Login direct OU verifyLoginOtp success | `method: email` |
| 2 | `login_failed` | Catch dans `login()` | `reason: invalid_credentials|otp_invalid|network|network_timeout|bad_response|dio_unknown|unknown` |

### Chemin de test : signup échec
- Soumettre avec un email déjà utilisé → `signup_failed` avec `reason: user_exists`
- Soumettre avec un mot de passe faible → `signup_failed` avec `reason: weak_password`

### Chemin de test : forgot password
- Tap "Mot de passe oublié" → submit → `password_reset_requested` (pas de params)

### Chemin de test : logout
- Logout → `user_id` repasse à `null`, user properties effacées (visible dans DebugView panneau User properties)

### Fichier
- [lib/features/auth/presentation/providers/auth_provider.dart](../../lib/features/auth/presentation/providers/auth_provider.dart)

---

## 3. Funnel Events & favoris

### Chemin de test

1. Depuis la home, tap une card événement
2. Sur la fiche : tap le bouton partage → partager
3. Tap le cœur → ajouter aux favoris
4. Re-tap le cœur → retirer

| # | Event | Quand | Params |
|---|---|---|---|
| 1 | `event_viewed` | Fire-once quand `EventDetailLoaded` (flag `_loggedView`) | `event_uuid`, `category`, `city_slug`, `is_free` |
| 2 | `event_shared` | Dans `_handleShare` après le partage natif | `event_uuid`, `channel: native` |
| 3 | `share` (✓ GA4) | idem (envoyé en parallèle pour les rapports built-in) | `content_type: event`, `item_id` |
| 4 | `add_to_wishlist` (✓ GA4) | `toggleFavorite` succès avec `result.isFavorite == true` | `item_id` (= event UUID), `item_name`, `item_category` |
| 5 | `remove_from_wishlist` | `toggleFavorite` succès avec `result.isFavorite == false` | idem |

### Anti-régression à vérifier
- Rouvrir 2× la même fiche en quittant et revenant → **un seul** `event_viewed` (flag interne) par instance du screen. Naviguer ailleurs et revenir = nouvelle instance = nouvel event ✓.

### Fichiers
- [lib/features/events/presentation/screens/event_detail_screen.dart](../../lib/features/events/presentation/screens/event_detail_screen.dart)
- [lib/features/events/presentation/widgets/detail/event_share_sheet.dart](../../lib/features/events/presentation/widgets/detail/event_share_sheet.dart)
- [lib/features/favorites/presentation/providers/favorites_provider.dart](../../lib/features/favorites/presentation/providers/favorites_provider.dart)

---

## 4. Funnel Search & carte

### Chemin de test : recherche

1. Depuis la home, tap la pilule de recherche
2. Saisir un terme, sélectionner une ville, choisir une date
3. Tap "Rechercher"
4. Sur l'écran de résultats, tap "Sauvegarder cette recherche"
5. Saisir un nom + activer push, confirmer

| # | Event | Quand | Params |
|---|---|---|---|
| 1 | `search_submitted` | Tap "Rechercher" OU submit clavier sur le champ | `query`, `city_slug`, `categories` (csv), `has_date_filter: bool` |
| 2 | `search` (✓ GA4) | Idem, en parallèle, seulement si `query` non vide | `search_term` |
| 3 | `search_saved` | Après `createAlert` succès | `enable_push`, `enable_email`, `city_slug` |

### Chemin de test : carte

1. Depuis la home ou recherche, ouvrir `/map`
2. Tap un pin sur la carte

| # | Event | Quand | Params |
|---|---|---|---|
| 1 | `map_opened` | initState de `MapViewScreen` | `source: home` ou `deep_link` (si lat/lng en query) |
| 2 | `map_pin_tapped` | Tap sur un Marker | `event_uuid`, `quantity` (nb d'events dans le cluster) |

### Différé (non instrumenté ce lot)
- `search_filter_applied` : `FilterBottomSheet` (2835 lignes, nécessite arbitrage produit sur la granularité)
- `search_no_results` : à câbler dans SearchScreen quand les résultats sont vides

### Fichiers
- [lib/features/search/presentation/widgets/airbnb_search_sheet.dart](../../lib/features/search/presentation/widgets/airbnb_search_sheet.dart)
- [lib/features/alerts/presentation/providers/alerts_provider.dart](../../lib/features/alerts/presentation/providers/alerts_provider.dart)
- [lib/features/events/presentation/screens/map_view_screen.dart](../../lib/features/events/presentation/screens/map_view_screen.dart)

---

## 5. Funnel Petit Boo

### Chemin de test

1. Tap VoiceFab → long-press → parler → relâcher (ouvre `/petit-boo?message=...`)
2. Envoyer un message texte depuis le chat
3. Attendre une réponse contenant un tool_result (ex: `searchEvents`)
4. Continuer à envoyer jusqu'à atteindre le quota (ou simuler via toggle backend)
5. Logout puis re-login → ouvrir `/petit-boo/history` → tap une conversation

| # | Event | Quand | Params |
|---|---|---|---|
| 1 | `petitboo_chat_opened` | initState de `PetitBooChatScreen` | `source: voicefab|history|cold_start`, `session_uuid?` |
| 2 | `petitboo_session_resumed` | idem, **uniquement si** `sessionUuid != null` | `session_uuid` |
| 3 | `petitboo_message_sent` | `sendMessage` accepte le message (pas en cours, pas en limite) | `length`, `is_voice: false`, `session_uuid?` |
| 4 | `petitboo_quota_reached` | `sendMessage` refusé par `isLimitReached` | `quota_type: daily` |
| 5 | `petitboo_tool_used` | Event SSE `tool_result` reçu | `tool_name` (ex: `searchEvents`, `addToFavorites`, …) |

### Anti-régression
- Naviguer hors du chat puis revenir via `/petit-boo` direct → `source: cold_start`.
- Reprendre une session via `/petit-boo?session=xxx` → **2 events** : `petitboo_chat_opened` avec `source: history` ET `petitboo_session_resumed`.

### Fichiers
- [lib/features/petit_boo/presentation/screens/petit_boo_chat_screen.dart](../../lib/features/petit_boo/presentation/screens/petit_boo_chat_screen.dart)
- [lib/features/petit_boo/presentation/providers/petit_boo_chat_provider.dart](../../lib/features/petit_boo/presentation/providers/petit_boo_chat_provider.dart)

---

## 6. Funnel Gamification (Hibons)

### Chemin de test

1. Login sur un compte qui peut gagner des Hibons (ex: < 10 ajouts de favoris dans la semaine)
2. Ajouter un événement aux favoris → le backend renvoie une enveloppe `hibons_update` avec `delta > 0`
3. Continuer jusqu'à franchir un palier de rang (ex: bronze → silver)

| # | Event | Quand | Params |
|---|---|---|---|
| 1 | `hibons_earned` | `HibonsService.handleEnvelope` reçoit un `delta > 0` | `amount`, `source` (`favorite`, `booking`, `session`, …) |
| 2 | `hibons_rank_up` | `rankChanged == true` dans la même enveloppe | `new_rank` (`bronze` / `silver` / `gold` / `legend`) |
| 3 | User property `hibons_rank` | idem | Mise à jour |

### Notes
- Les Hibons sont crédités via une **enveloppe à la racine de la réponse API**, pas par un event dédié. Donc tester en faisant une action *qui crédite côté backend* (favori, booking, share, daily reward, etc.).
- Le `source` du `hibons_earned` est ce que le backend a mis dans l'enveloppe — pas une valeur calculée côté app.

### Fichier
- [lib/features/gamification/application/hibons_service.dart](../../lib/features/gamification/application/hibons_service.dart)

---

## 7. Funnel Memberships

### Chemin de test : demande d'adhésion

1. Ouvrir une fiche organisateur (`/organizers/{id}`)
2. Tap "Demander à rejoindre"

| # | Event | Quand | Params |
|---|---|---|---|
| 1 | `membership_join_started` | Avant l'appel API `requestMembership` | `organization_id` |
| 2 | `membership_join_completed` | Après succès de l'API | `organization_id` |

> Note : "completed" = la **demande** est passée côté backend, pas l'approbation admin. L'approbation est async et hors-périmètre côté mobile.

### Chemin de test : acceptation d'invitation

1. Recevoir une invitation, ouvrir l'app → `/me/memberships` onglet "Invitations"
2. Tap "Accepter"

| # | Event | Quand | Params |
|---|---|---|---|
| 1 | `membership_invite_accepted` | Après `acceptInvitation` succès | aucun |

### Fichiers
- [lib/features/memberships/presentation/providers/membership_state_providers.dart](../../lib/features/memberships/presentation/providers/membership_state_providers.dart)
- [lib/features/memberships/presentation/providers/memberships_screen_providers.dart](../../lib/features/memberships/presentation/providers/memberships_screen_providers.dart)

---

## 8. Funnel Notifications

### Chemin de test : permission

1. Logout, puis signup complet
2. Arriver sur `/post-signup/notifications`
3. Accepter (ou refuser) le prompt OneSignal

| # | Event | Quand | Params |
|---|---|---|---|
| 1 | `notification_permission_result` | Après `OneSignal.Notifications.requestPermission` | `granted: bool` |
| 2 | User property `push_enabled` | idem | `'true'` / `'false'` |

### Chemin de test : tap notification (runtime)

1. Avec l'app en foreground/background, déclencher un push depuis le back-office OneSignal (ou un push de test)
2. Tap la notification dans le centre de notifs

| # | Event | Quand | Params |
|---|---|---|---|
| 1 | `notification_opened` | `_handleClick` (app déjà lancée) | `type` (ex: `booking_confirmed`, `event_reminder`) |

### Chemin de test : tap notification cold-start

1. App tuée (force-quit)
2. Déclencher un push → tap dessus

| # | Event | Quand | Params |
|---|---|---|---|
| 1 | `notification_opened` | `_replayPendingClick` au boot après attache du DeepLinkService | `type`, `source: cold_start` |

### Fichier
- [lib/core/services/push_notification_service.dart](../../lib/core/services/push_notification_service.dart)

---

## 9. Navigation (screen_view)

Géré automatiquement par `FirebaseAnalyticsObserver` branché sur le `GoRouter`
racine **et** le `ShellRoute` (cf. [app_router.dart](../../lib/routes/app_router.dart)).

### Chemin de test

Naviguer dans l'app : Home → Explore → Profile → tap event card → back → ouvrir
un bottom sheet (search modal, filter sheet) → fermer.

### Critères
- 1 `screen_view` par route nommée traversée
- `screen_name` cohérent avec le `name:` du `GoRoute` (ex: `home`, `explore`,
  `profile`, `event-detail`, `petit-boo`)
- **Critère bloquant** : les 4 routes de la bottom-nav (`/`, `/explore`,
  `/profile`, `/my-bookings`) doivent **toutes** envoyer un `screen_view` — si
  une seule manque, l'observer n'est pas branché au ShellRoute.
- Les bottom sheets sans `RouteSettings.name` ne doivent pas envoyer de
  `screen_view` parasite (comportement par défaut du `defaultNameExtractor`).

---

## 10. Matrice récap — checklist de recette

Cocher en DebugView après le tour complet :

### Boot & identité
- [ ] User properties `env`, `app_locale` présentes dès le boot
- [ ] `user_id` set après login, vide après logout
- [ ] `user_role`, `home_city_slug` set après login

### Navigation
- [ ] `screen_view` sur les 4 routes bottom-nav
- [ ] `screen_view` sur la fiche événement avec `screen_name: event-detail`
- [ ] Pas de `screen_view` orphelin (screen_name vide)

### Auth
- [ ] `sign_up` après signup OTP-verified
- [ ] `login` après login direct ET via OTP 2FA
- [ ] `login_failed` avec `reason` catégorisée
- [ ] `signup_failed` avec `reason` catégorisée
- [ ] `password_reset_requested` après demande

### Booking funnel (complet)
- [ ] `begin_checkout`
- [ ] `booking_slot_selected`
- [ ] `booking_customer_form_completed`
- [ ] `add_payment_info`
- [ ] `purchase` avec `transaction_id` numérique-string (UUID booking)
- [ ] `tickets_displayed` avec `quantity` ≥ 1
- [ ] `refund` après annulation

### Events & favoris
- [ ] `event_viewed` fire-once par instance d'écran
- [ ] `event_shared` + `share` (standard) en double
- [ ] `add_to_wishlist` / `remove_from_wishlist` selon le toggle

### Search & carte
- [ ] `search_submitted` + `search` (standard si query non vide)
- [ ] `search_saved` avec `enable_push`, `enable_email`
- [ ] `map_opened` au montage
- [ ] `map_pin_tapped` au tap

### Petit Boo
- [ ] `petitboo_chat_opened` avec `source` correct selon l'entrée
- [ ] `petitboo_session_resumed` si reprise via `?session=`
- [ ] `petitboo_message_sent` avec `length`
- [ ] `petitboo_tool_used` à chaque tool_result SSE
- [ ] `petitboo_quota_reached` quand la limite est atteinte

### Gamification
- [ ] `hibons_earned` après une action qui crédite
- [ ] `hibons_rank_up` au franchissement de rang
- [ ] User property `hibons_rank` mise à jour

### Memberships
- [ ] `membership_join_started` + `membership_join_completed` à la demande
- [ ] `membership_invite_accepted` à l'acceptation

### Notifications
- [ ] `notification_permission_result` après le prompt
- [ ] User property `push_enabled` à jour
- [ ] `notification_opened` runtime
- [ ] `notification_opened` cold-start avec `source: cold_start`

### Hygiène
- [ ] Aucun event avec un nom qui n'est pas dans [analytics_event.dart](../../lib/core/analytics/analytics_event.dart) — vérifier la grep :
  ```bash
  grep -rn "logEvent\(" lib/ | grep -v "AnalyticsEvent\." | grep -v "analytics_event.dart"
  # doit ne rien retourner (sauf commentaires/docs)
  ```
- [ ] Aucun crash lié à analytics (logs Xcode/Android Studio clean)
- [ ] Après désactivation de la collecte (`setCollectionEnabled(false)`),
  **aucun** event ne remonte pendant 5 minutes d'usage

---

## 11. Pièges connus

| Symptôme | Cause |
|---|---|
| `purchase` n'apparaît pas dans Monetization GA4 | Param `currency` manquant ou `value` non numérique. Tous nos `purchase` ont `currency: state.currency` ou `'EUR'`. ✓ |
| `event_uuid`, `transaction_id`, `category` non visibles dans les rapports | Param custom **non déclaré** en Custom Definition GA4. Aller dans Admin → Custom Definitions → Custom dimensions → créer chaque param utilisé. |
| `screen_view` arrive 2× | Observer branché à la fois sur le root GoRouter ET sur un screen qui logue manuellement. Notre code ne loggue jamais `screen_view` manuellement — c'est uniquement l'observer. ✓ |
| `user_id` reste à l'ancienne valeur après login d'un autre compte | Logout n'a pas appelé `_syncAuthUser(null)`. Vérifier dans [auth_provider.dart](../../lib/features/auth/presentation/providers/auth_provider.dart) que `logout()` et `forceLogout()` appellent bien `_syncAuthUser(null)`. |
| iOS : seulement `user_engagement` arrive, pas les autres events | ATT denied + GA4 en mode modelé. Normal une fois le consent gate (étape 7) en place. Pour le test debug, accepter ATT. |
| Aucun event pendant des heures, puis tout arrive d'un coup | `setCollectionEnabled(false)` activé silencieusement. Vérifier qu'on est bien sur la build debug avec la ligne d'activation temporaire (§0.1). |
