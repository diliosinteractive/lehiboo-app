# Audit — Axe 14 Paiement, temps réel & push

Date : 2026-05-26 · Branche : `main` · Auditeur : Claude · Plan : [14-paiement-realtime-push.md](../plans/14-paiement-realtime-push.md)

## Synthèse
- **État global : 🟠 Majeur** — le flow de paiement réel est globalement sain, mais deux landmines sérieuses subsistent (paiement **simulé** mort encore routé + messages d'erreur **debug** affichés en prod).
- Constats : **7** (🔴 1 · 🟠 3 · 🟡 2 · ⚪ 1)
- **Top 3 actions** :
  1. **Supprimer le flow de paiement legacy simulé** (`pi_fake_12345`) ou le dé-router.
  2. **Restaurer les messages d'erreur utilisateur** (retirer les `[DEBUG …]` du checkout avant prod).
  3. Ajouter une **garde de ré-entrée** explicite au submit du checkout réel.

---

## A. Paiement & réservation (Stripe)

### Contexte : DEUX flows coexistent
- **Flow réel (production)** : `/cart` → `OrderCartScreen` → `CheckoutScreen`. Vrai Stripe (`initPaymentSheet`/`presentPaymentSheet`). Déclenché depuis le détail event ([event_detail_screen.dart:1330,1360](../../../lib/features/events/presentation/screens/event_detail_screen.dart#L1330)) et la home ([home_screen.dart:353](../../../lib/features/home/presentation/screens/home_screen.dart#L353)).
- **Flow legacy** : `/booking/:activityId` → slot → participants → `BookingPaymentScreen`. **Simulation** : champs carte `readOnly`, `paymentIntentId: 'pi_fake_12345'` codé en dur.

### Constats
| # | Gravité | Constat | Fichier:ligne | Recommandation | Effort |
|---|---------|---------|---------------|----------------|--------|
| A1 | 🔴 P0 | **Paiement simulé encore enregistré comme route.** `BookingPaymentScreen` confirme une réservation avec un faux `pi_fake_12345` sans aucun débit. La route `/booking/:activityId/payment` (`name: 'booking-payment'`) est **toujours déclarée**. Aucune nav UI ne l'atteint aujourd'hui (l'entrée `/booking/:activityId` n'est poussée nulle part), mais c'est une bombe à retardement : un deeplink, un raccourci ou un futur CTA recâblé créerait des réservations confirmées **non payées**. | [booking_payment_screen.dart:11-116](../../../lib/features/booking/presentation/screens/booking_payment_screen.dart#L11-L116) ; route [app_router.dart:650-675](../../../lib/routes/app_router.dart#L650-L675) | Supprimer le flow legacy complet (`BookingPaymentScreen`, `BookingSlotSelectionScreen`, `BookingParticipantScreen`, `BookingFlowController`, routes associées) **ou** au minimum retirer les routes et vérifier qu'aucun deeplink ne mappe `/booking/:activityId`. | M |
| A2 | 🟠 P1 | **Messages d'erreur de debug affichés aux utilisateurs en production.** Le checkout réel remplace le message localisé par `'[DEBUG $checkoutStep] Stripe(...)…'` / `'[DEBUG $checkoutStep] $e'`. Commentaires `// TODO(debug): RETIRER avant prod`. Fuite d'internes (étapes, exceptions brutes) + UX dégradée. 4 occurrences. | [order_cart_screen.dart:1030-1036](../../../lib/features/booking/presentation/screens/order_cart_screen.dart#L1030-L1036), [order_cart_screen.dart:1060-1063](../../../lib/features/booking/presentation/screens/order_cart_screen.dart#L1060-L1063) | Restaurer les lignes commentées (`e.error.localizedMessage` / `ApiResponseHandler.extractError`). Vérifier aussi `checkout_screen.dart`. | S |
| A3 | 🟡 P2 | **Pas de garde de ré-entrée explicite** dans `_submitOrder` : la protection anti-double-soumission repose uniquement sur l'état `_isLoading` du bouton. Un double-tap rapide ou un re-déclenchement programmatique pourrait lancer deux `createOrder`. | [order_cart_screen.dart:908-926](../../../lib/features/booking/presentation/screens/order_cart_screen.dart#L908-L926) | Ajouter `if (_isLoading) return;` en tête de méthode (comme [booking_detail_screen.dart:539](../../../lib/features/booking/presentation/screens/booking_detail_screen.dart#L539)). | S |
| A4 | ⚪ i | **Polling billets** : présent et conforme à `CLAUDE.md` dans le flow legacy (`delays = [1,1,2,2,3,3,4,4]`, [booking_success_screen.dart:106-133](../../../lib/features/booking/presentation/screens/booking_success_screen.dart#L106-L133)). À **confirmer** sur l'écran du flow réel (`/order-confirmation/{uuid}`) qui ne ressort pas dans le grep de polling. | [order_cart_screen.dart:1004](../../../lib/features/booking/presentation/screens/order_cart_screen.dart#L1004) | Vérifier que `OrderSuccessScreen` poll les billets (génération async). | S |

### Points conformes paiement (✅)
- **Compensation transactionnelle** : `shouldCancelOrderOnError` + `_cancelActiveOrderIfNeeded` annulent la commande si l'échec survient **avant** `presentPaymentSheet`. Après débit, l'ordre est conservé pour réconciliation (pas d'annulation aveugle). [order_cart_screen.dart:929-986](../../../lib/features/booking/presentation/screens/order_cart_screen.dart#L929-L986).
- **Contexte de crash précis** : `checkoutStep` (`create_order`→`payment_intent`→`init_payment_sheet`→`present_payment_sheet`→`confirm_order`) envoyé à `CrashReporter`.
- **Annulation utilisateur non polluante** : `FailureCode.Canceled` exclu de Crashlytics.
- **Aucun secret Stripe côté app** : `PaymentIntentResponseDto` ne porte que `clientSecret`/`paymentIntentId`/`amount` ([booking_api_dto.dart:63-73](../../../lib/features/booking/data/models/booking_api_dto.dart#L63-L73)).
- **Timer de réservation** synchronisé sur l'expiration serveur + invalidation des caches « places restantes » post-achat.

---

## B. Temps réel (Pusher / Reverb)

| # | Gravité | Constat | Fichier:ligne | Recommandation |
|---|---------|---------|---------------|----------------|
| B1 | ⚪ i | **Cycle de vie à confirmer** : le WebSocket est initialisé **eagerly au boot** dès l'auth ([main.dart:320](../../../lib/main.dart#L320)). `_disconnect()` est bien appelé sur changement d'auth et dans `dispose()`, mais la **reconnexion avec backoff** et la mise en veille en **arrière-plan** (batterie) ne sont pas confirmées. | [messages_realtime_provider.dart:172-273](../../../lib/features/messages/presentation/providers/messages_realtime_provider.dart#L172-L273) | Vérifier backoff/resubscribe + resync REST du badge non-lus après reconnexion ; envisager déconnexion en background prolongé. |

### Points conformes realtime (✅)
- **Nettoyage** : `_disconnect()` → `_client?.disconnect()` + `_client?.dispose()` dans `dispose()` ([messages_realtime_provider.dart:259-273,556-559](../../../lib/features/messages/presentation/providers/messages_realtime_provider.dart#L259-L273)). Pas de fuite évidente du client.
- **Transport TLS** : `PUSHER_USE_TLS=true` en prod/staging, `PUSHER_AUTH_ENDPOINT` en HTTPS.

---

## C. SSE — Petit Boo

| # | Gravité | Constat | Fichier:ligne | Recommandation |
|---|---------|---------|---------------|----------------|
| C1 | 🟡 P2 | **Fuite potentielle de `http.Client`** : un client est créé par appel `sendMessage` et `client.close()` est appelé sur les chemins nominaux/erreurs identifiés, mais sans `try/finally` global → si une exception survient avant un `close()`, la connexion TCP fuit. (Recoupe le constat P2-07 de l'audit réseau.) | [petit_boo_sse_datasource.dart:86-159](../../../lib/features/petit_boo/data/datasources/petit_boo_sse_datasource.dart#L86-L159) | Encapsuler dans `try { … } finally { client.close(); }`. |

### Points conformes SSE (✅)
- Fermeture explicite du stream (`client.close()`) sur fin/erreur/annulation aux points nominaux.

---

## D. Push (OneSignal)

### Points conformes push (✅)
- **Association/dissociation idempotente** : `bindUser` → `OneSignal.login(externalId)` (commenté « Idempotent — safe to call on every app start ») et `OneSignal.logout()` au logout ([push_notification_service.dart:182-203](../../../lib/core/services/push_notification_service.dart#L182-L203)) → pas de fuite d'identité entre comptes.
- **Cold-start** : listener de clic enregistré **avant** `runApp` qui « stashe » le payload puis le rejoue une fois le router prêt ([main.dart:144-156](../../../lib/main.dart#L144-L156)).
- **Permission au bon moment** : écrans de permission post-signup dédiés (commit `feat(auth): add post-signup permission screens for location and notifications`).
- **Deeplink push** validé via la whitelist `kDeeplinkAllowedHosts` (cf. [audit sécurité](05-securite-audit.md)).

### À surveiller
- ⚪ Logs `OneSignal.login(external_id=$externalId)` ([push_notification_service.dart:188](../../../lib/core/services/push_notification_service.dart#L188)) — non sensible mais non gardé `kDebugMode` (recoupe logging, [plan 11](../plans/11-observabilite-crash-analytics.md)).

---

## Annexes (commandes lancées)
- Localisation des deux flows, vérif nav UI (`/cart` vs `/booking/:activityId`), routes du router.
- Lecture `booking_flow_controller.dart`, `booking_payment_screen.dart` (simulation), `order_cart_screen.dart` (flow réel `_submitOrder`).
- Greps : `presentPaymentSheet`/`initPaymentSheet`, polling billets, `RETIRER avant prod` (4), garde ré-entrée, reconnexion/dispose Pusher, `client.close()` SSE, `OneSignal.login/logout`.
