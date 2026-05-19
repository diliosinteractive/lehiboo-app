# Étape 8 — Debug & recette

Objectif : valider que chaque event part bien avec les bons paramètres avant le rollout.

## 8.1 Activer DebugView

DebugView est l'outil de référence : il affiche les events en quasi temps réel (≤ 10 s), avec les params et les user properties associées. **Indispensable**, les rapports standards mettent 24-48h à apparaître.

### Android

```bash
adb shell setprop debug.firebase.analytics.app com.dilios.lehibooexperience
```

Vérifier le package name exact dans `android/app/build.gradle` (`applicationId`).

Désactiver :

```bash
adb shell setprop debug.firebase.analytics.app .none.
```

### iOS

Dans Xcode → Edit Scheme → Run → Arguments → Arguments Passed On Launch, ajouter :

```
-FIRDebugEnabled
```

Pour désactiver : remplacer par `-FIRDebugDisabled`. Pas d'équivalent CLI propre pour les builds release.

### Ouvrir DebugView

Console Firebase → Analytics → DebugView → sélectionner le device dans le picker en haut.

## 8.2 Checklist de recette — par event critique

À cocher manuellement, sur un build debug, ATT acceptée, consent accepté :

### Boot
- [ ] App lance sans crash après acceptation consent.
- [ ] User property `env` = `development` arrive dans DebugView.

### Navigation
- [ ] Naviguer Home → Search → fiche événement → revenir. 4 events `screen_view` distincts avec des `screen_name` cohérents.
- [ ] Ouvrir un bottom sheet : vérifier qu'il n'envoie **pas** un `screen_view` parasite (ou qu'il en envoie un nommé exprès, selon décision étape 3).

### Auth
- [ ] Signup nouveau compte → events `signup_started`, `sign_up` avec `method`, user_id passe à l'UUID backend.
- [ ] Logout → user_id passe à `null` dans la prochaine session.
- [ ] Login échec → `login_failed` avec `reason`.

### Funnel booking complet
- [ ] Ouvrir fiche événement → `event_viewed`, `select_content`.
- [ ] Démarrer réservation → `begin_checkout`.
- [ ] Choisir slot → `booking_slot_selected`.
- [ ] Remplir form client → `booking_customer_form_completed`.
- [ ] Ouvrir Stripe sheet → `add_payment_info`.
- [ ] Payer (test mode Stripe) → `purchase` avec `transaction_id`, `value`, `currency`, `items`.
- [ ] Billets affichés → `tickets_displayed` avec `poll_attempts`.
- [ ] Annuler → `refund`.

### Booking gratuit
- [ ] Réserver event gratuit → `purchase` avec `value = 0`, vérifier que GA4 considère bien la transaction (sinon ajouter param `is_free`).

### Petit Boo
- [ ] Ouvrir via VoiceFab → `petitboo_chat_opened` avec `source: voicefab`.
- [ ] Envoyer message → `petitboo_message_sent`.
- [ ] Recevoir tool_result `searchEvents` → `petitboo_tool_used` avec `tool_name: searchEvents`.
- [ ] Atteindre quota → `petitboo_quota_reached`.

### Favoris
- [ ] Tap favori sur card → `add_to_wishlist`.
- [ ] Re-tap → `remove_from_wishlist`.

### Consent
- [ ] Refuser consent au gate → **aucun** event ne part (vérifier 5 min).
- [ ] Toggle off depuis Profil après acceptation → events s'arrêtent en ≤ 1 min.
- [ ] Toggle on → reprennent.

## 8.3 Validation params

GA4 attend des paramètres déclarés en **Custom Definitions** pour les exploiter dans les rapports. Pour chaque param non standard (`event_uuid`, `category`, `source`, `tool_name`, `reason`, `step`, `city_slug`, etc.) :

- Vérifier dans DebugView qu'il arrive bien.
- Le déclarer dans Admin → Custom Definitions → Custom dimensions (event-scoped). 50 max — largement assez.

Sans cette déclaration, le param est envoyé mais **invisible** dans les rapports → bug silencieux classique.

## 8.4 Outils complémentaires

| Outil | Quand |
|---|---|
| **Logcat / Console iOS** | Voir les logs Firebase verbeux (`-FIRAnalyticsVerboseLoggingEnabled` côté iOS, `setprop log.tag.FA VERBOSE` côté Android). Utile pour les events droppés (param trop long, nom invalide). |
| **DebugView export CSV** | Audit a posteriori sur une session précise. |
| **GA4 Realtime** | Vue agrégée temps réel, complémentaire de DebugView (qui est par device). |
| **GA4 → Funnel exploration** | Tester un funnel `begin_checkout → add_payment_info → purchase` dès qu'on a 24h de data. |

## 8.5 Pièges récurrents

| Symptôme | Cause probable |
|---|---|
| Event arrive sans param custom | Param non déclaré en Custom Definition GA4 |
| `user_id` reste à l'ancienne valeur | Logout n'appelle pas `setUserId(null)` |
| Events arrivent en double | Observer GoRouter + `screen_view` loggué manuellement à côté |
| Aucun event pendant 24h puis tout d'un coup | `setCollectionEnabled(false)` actif (consent refusé / oubli de toggle dev) |
| `purchase` n'apparaît pas dans Monetization | Manque `currency` (obligatoire) ou `value` non-numérique |
| iOS : `user_engagement` mais rien d'autre | ATT denied + GA4 en mode modeled, c'est normal mais à confirmer |

## Critères de sortie

- [ ] Checklist 8.2 cochée à 100% en environnement debug.
- [ ] Tous les params custom déclarés en Custom Definitions GA4.
- [ ] Un funnel exploration GA4 `begin_checkout → purchase` créé et fonctionnel.
- [ ] Procédure de DebugView documentée dans le README dev de l'équipe.
