# Audit Responsivité des Écrans — Le Hiboo App

> Date : 2026-06-11
> Objet : recensement des écrans non-responsive souffrant de débordements (overflow), d'absence de scroll, de clavier non-fermable ou de mauvais comportement horizontal sur **petits écrans**.

## Contexte

Plusieurs écrans présentent des comportements non-responsive :

- **Débordement vertical** (`BOTTOM OVERFLOWED BY X PIXELS`) sur petit écran — cf. exemple `register_type_screen` (déborde de 62px).
- **Impossible de scroller** : le contenu est dans un `Column`/`Padding` sans `SingleChildScrollView`/`ListView`/`CustomScrollView`.
- **Clavier impossible à fermer** : champs `TextField`/`TextFormField` sans `GestureDetector(onTap: unfocus)` racine ni `keyboardDismissBehavior`.
- **Affichage horizontal cassé** : `Row` avec texte/widgets sans `Expanded`/`Flexible`/`Wrap`.
- **Hauteurs fixes / `Spacer()`** qui ne laissent pas de place quand l'écran rétrécit ou que le clavier s'ouvre.

Méthode : lecture statique des **75 écrans** sous `lib/features/**/presentation/screens/`. Sévérité indicative, à confirmer en test sur device < 600px de haut.

---

## 🔴 Priorité HAUTE (overflow / clavier bloquant confirmés)

| Écran | Problème principal | Détail |
|-------|--------------------|--------|
| [register_type_screen.dart](../../lib/features/auth/presentation/screens/register_type_screen.dart) | **Overflow vertical (bug des 62px)** | `SafeArea + Padding + Column` **sans scroll** (l.~46-164) + `Spacer()` (l.~107) + bouton hauteur fixe 56px. Sur petit écran → débordement garanti. **C'est l'écran de l'exemple.** |
| [order_cart_screen.dart](../../lib/features/booking/presentation/screens/order_cart_screen.dart) | **Clavier non-fermable + padding fixe** | `unfocus()` seulement dans `_onConfirmPressed()` (l.~816), pas au tap. Padding bas hardcodé `fromLTRB(16,16,16,120)` (l.~455) + `bottomNavigationBar` → overflow avec clavier ouvert et plusieurs `ParticipantFormCard`. |
| [profile_edit_screen.dart](../../lib/features/profile/presentation/screens/profile_edit_screen.dart) | **Clavier non-fermable** | `SingleChildScrollView` présent (l.~100) mais **aucun** `GestureDetector(onTap: unfocus)` racine ni `keyboardDismissBehavior`. Le clavier reste collé après saisie. |
| [trip_plan_edit_screen.dart](../../lib/features/trip_plans/presentation/screens/trip_plan_edit_screen.dart) | **Clavier non-fermable + liste imbriquée** | `TextField` titre (l.~168) sans dismiss ; pas de `keyboardDismissBehavior` (l.~160) ; `ReorderableListView` (l.~265) qui peut déborder avec beaucoup d'étapes. |
| [business_register_screen.dart](../../lib/features/auth/presentation/screens/business_register_screen.dart) | **Scroll des forms enfants à vérifier** | `Expanded(child: PageView(...))` (l.~256-290) avec sous-forms externalisés. Risque élevé que les forms internes (`PersonalInfoForm`, `CompanyInfoForm`, etc.) manquent de scroll → overflow au clavier. **À auditer dans les widgets de form.** |

---

## 🟠 Priorité MOYENNE (risque sur petit écran ou clavier ouvert)

| Écran | Problème principal | Détail |
|-------|--------------------|--------|
| [otp_verification_screen.dart](../../lib/features/auth/presentation/screens/otp_verification_screen.dart) | Pas de scroll → overflow clavier | `SafeArea + Padding + Column` sans `SingleChildScrollView` (l.~224). Titre 28px + 6 champs OTP (56px) + boutons : overflow probable quand le clavier s'ouvre. |
| [onboarding_screen.dart](../../lib/features/onboarding/presentation/screens/onboarding_screen.dart) | Pas de SafeArea + positions fixes | `Stack + PageView` sans `SafeArea` (l.~70). Bottom en `Positioned(bottom: 40)` (l.~145) et texte en `Positioned(bottom: 140)` ; hauteur gradient fixe (l.~94). Peut déborder avec notch / petit écran. |
| [checkin_manual_entry_screen.dart](../../lib/features/checkin/presentation/screens/checkin_manual_entry_screen.dart) | Pas de scroll + clavier non-fermable | `SafeArea + Padding + Column` sans scroll (l.~146). `TextField` `autofocus` (l.~200) sans dismiss ni `resizeToAvoidBottomInset` géré → overflow clavier. |
| [checkout_screen.dart](../../lib/features/booking/presentation/screens/checkout_screen.dart) | Clavier non-fermable + padding fixe | `SingleChildScrollView` OK mais pas de dismiss racine. `SizedBox(height: padding.bottom + 100)` hardcodé (l.~204). Overflow possible sur email/téléphone. |
| [create_broadcast_screen.dart](../../lib/features/messages/presentation/screens/create_broadcast_screen.dart) | Clavier non-fermable | `SingleChildScrollView` OK (l.~809) mais `TextFormField` (l.~820, ~848) sans `GestureDetector(onTap: unfocus)` racine. |
| [event_detail_screen.dart](../../lib/features/events/presentation/screens/event_detail_screen.dart) | Padding fixe + clavier | `CustomScrollView` OK mais `SizedBox(height: padding.bottom + 100)` (l.~621) et composants de sélection (date/billets l.~507-530) sans dismiss clavier. |
| [search_screen.dart](../../lib/features/search/presentation/screens/search_screen.dart) | Clavier + padding rigide | `AirbnbSearchBar` (TextField, l.~364) sans unfocus visible ; `Padding 32px` dans `_EmptyResults` (l.~715) serré sur très petit écran. |
| [hibons_transactions_screen.dart](../../lib/features/gamification/presentation/screens/hibons_transactions_screen.dart) | FilterChips horizontaux | Rangée de `FilterChip` (l.~95-145) sans `Wrap`/`Expanded` → débordement horizontal possible sur très petit écran. |

---

## 🟢 Priorité BASSE / OK

Ces écrans utilisent correctement `SingleChildScrollView` / `ListView` / `CustomScrollView` et n'ont pas de problème majeur identifié. Quelques hauteurs fixes mineures (carousels, SliverAppBar) à surveiller mais non bloquantes.

**Auth :** `auth_bootstrap_screen`, `forgot_password_screen`, `login_screen` (unfocus présent), `register_screen`, `customer_register_screen` (3× scroll), `permission_audio/location/notifications_screen` (délèguent à `PermissionExplainerScaffold`).

**Booking :** `booking_confirmation_screen`, `booking_participant_screen`, `booking_payment_screen` (champs read-only), `booking_screen`, `booking_slot_selection_screen`, `booking_success_screen`, `order_success_screen`, `ticket_detail_screen`, `bookings_list_screen`, `booking_detail_screen`, `refund_policy_screen`.

**Events / Home / Search :** `map_view_screen` (carousel 200px à surveiller), `event_list_screen`, `event_questions_screen`, `home_screen` (carousels 360px), `city_detail_screen`, `filter_screen` (placeholder).

**Reviews / Questions :** `event_reviews_full_screen`, `my_reviews_screen`, `user_questions_screen`.

**Messages / Notifications :** `admin_new_conversation_screen`, `admin_report_detail_screen`, `broadcast_detail_screen`, `new_conversation_screen`, `support_detail_screen`, `vendor_new_conversation_screen`, `conversation_detail_screen`, `conversations_list_screen`, `notifications_inbox_screen`, `alerts_list_screen`, `reminders_list_screen`.

**Gamification / Profile :** `achievements_screen`, `how_to_earn_hibons_screen`, `lucky_wheel_screen`, `hibon_shop_screen`, `gamification_dashboard_screen`, `saved_participants_screen` (gestion clavier OK), `profile_screen`, `settings_screen`.

**Check-in / Memberships / Partners / Petit Boo / Trip Plans :** `checkin_blocked_sheet`, `checkin_confirm_sheet`, `checkin_scan_screen`, `organization_picker_sheet`, `favorites_screen`, `invitation_landing_screen`, `memberships_screen`, `private_events_screen`, `followed_organizers_screen`, `organizer_profile_screen`, `conversation_list_screen`, `petit_boo_brain_screen`, `petit_boo_chat_screen`, `trip_plans_list_screen`.

---

## Recommandations transverses (patterns de correction)

1. **Fermeture du clavier au tap** — envelopper le `Scaffold.body` des écrans à formulaire :
   ```dart
   GestureDetector(
     onTap: () => FocusScope.of(context).unfocus(),
     behavior: HitTestBehavior.opaque,
     child: /* contenu */,
   )
   ```
2. **Scroll systématique sur les écrans à contenu fixe** — remplacer `Column` racine par `SingleChildScrollView(child: Column(...))`, et préférer `Spacer()` → `ConstrainedBox` + `IntrinsicHeight` quand on veut « pousser » un bouton en bas tout en restant scrollable.
3. **Dismiss au scroll** — ajouter `keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag` sur les `SingleChildScrollView`/`ListView` des formulaires.
4. **Bottom padding adaptatif** — remplacer les `SizedBox(height: ...100/120)` hardcodés par `MediaQuery.of(context).viewInsets.bottom` + safe area, ou un `bottomNavigationBar`/`Padding` dédié.
5. **Rangées horizontales** — `Row` → `Expanded`/`Flexible` sur les enfants texte, ou `Wrap` pour les chips/badges.
6. **Cas `register_type_screen` (le bug exemple)** — wrapper dans `SingleChildScrollView` + remplacer `Spacer()` par un `LayoutBuilder` / `ConstrainedBox(minHeight: constraints.maxHeight)` + `Column(mainAxisAlignment: spaceBetween)`.

### Ordre de traitement suggéré

1. `register_type_screen` (bug visible signalé)
2. Formulaires HAUTE : `order_cart_screen`, `profile_edit_screen`, `trip_plan_edit_screen`, `business_register_screen`
3. MOYENNE : `otp_verification_screen`, `checkin_manual_entry_screen`, `checkout_screen`, `create_broadcast_screen`, `onboarding_screen`, puis le reste.
