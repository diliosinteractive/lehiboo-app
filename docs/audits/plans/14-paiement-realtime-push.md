# Plan 14 — Paiement, temps réel & push 🔴 (priorité critique)

Objectif : auditer les flux à fort enjeu : paiement Stripe + réservation, temps réel
(Pusher/Reverb WebSocket, SSE Petit Boo) et notifications push (OneSignal).

## Périmètre
- Booking/paiement : `lib/features/booking/`, `flutter_stripe`, flow `createBooking → paymentIntent → confirm → tickets`
- Realtime : `lib/core/realtime/`, `dart_pusher_channels`, `messages_realtime_provider`, Reverb
- SSE : `lib/features/petit_boo/data/datasources/petit_boo_sse_datasource.dart`
- Push : `onesignal_flutter`, `lib/core/services/push_notification_service.dart`, deep links sur tap

## A. Paiement & réservation (Stripe) 🔴
### Risques connus
- Flow multi-étapes asynchrone + polling des billets (génération async backend).
- Manipulation d'argent → toute erreur = impact direct utilisateur/comptable.
### Checklist
- [ ] **Aucune clé secrète Stripe** côté app ; seul `clientSecret` du PaymentIntent transite (recoupe plan 05).
- [ ] **Idempotence** : pas de double `createBooking`/double paiement en cas de tap multiple ou retry réseau (bouton désactivé, garde côté state).
- [ ] **Machine à états** du flow explicite : `created → payment_pending → confirmed/free_confirmed → tickets_ready` + états d'échec.
- [ ] **UUID** utilisé sur toutes les routes booking (`/bookings/{uuid}/...`) — pas `numericId` (cf. `CLAUDE.md`).
- [ ] **Cas gratuit** (`total_amount == 0` → `confirm-free`) vs payant correctement aiguillés.
- [ ] **Échec paiement** : SCA/3DS, carte refusée, annulation utilisateur → messages clairs, pas d'état incohérent, réconciliation possible.
- [ ] **Polling billets** : délais progressifs (cf. `CLAUDE.md`), timeout borné, fallback « billets en cours de génération » sans bloquer l'UI ni boucler à l'infini.
- [ ] **Annulation** : `/cancel` avec UUID, rafraîchit la liste, gère les non-annulables.
- [ ] **Tickets** : QR généré/affiché (`qr_flutter`), luminosité (`screen_brightness`) restaurée en sortie.
- [ ] **Reprise** : que se passe-t-il si l'app est tuée entre paiement et confirm ? (récupération de l'état booking).
- [ ] **Tests** : ce flux doit être couvert (recoupe plan 07, `booking_flow_test.dart` existant à étendre).

## B. Temps réel (Pusher/Reverb WebSocket)
### Risques connus
- WebSocket Reverb **initialisé eagerly au boot** dès auth ([main.dart:320](../../../lib/main.dart#L320)) + providers conversations selon rôle → connexion permanente.
- `dart_pusher_channels` : maturité de la lib à évaluer.
### Checklist
- [ ] **Cycle de vie** : connexion/déconnexion alignée sur l'auth et le lifecycle (background/foreground) ; pas de socket maintenue inutilement en arrière-plan (batterie).
- [ ] **Reconnexion** : backoff exponentiel, resubscribe aux canaux, resync de l'état (badge non-lus) après reconnexion.
- [ ] **Auth des canaux privés** : `PUSHER_AUTH_ENDPOINT` (`/broadcasting/auth`) appelé avec le token ; échec géré.
- [ ] **TLS** : `pusherUseTLS`/port 443 en prod, jamais de WS en clair en release.
- [ ] **Fuites** : channels et subscriptions fermés (`ref.onDispose`) — recoupe plan 03.
- [ ] **Cohérence** : badge non-lus et liste de conversations resynchronisés via REST après un trou réseau (pas seulement realtime).
- [ ] **Catalogue d'événements** : conforme à `docs/PUSHER_EVENTS_CATALOG.md`.

## C. SSE — Petit Boo (assistant IA)
### Checklist
- [ ] **Streaming** : parsing robuste des events (`session/token/tool_call/tool_result/error/done`), gestion des chunks partiels.
- [ ] **Annulation** : interrompre le stream (navigation, stop user) ferme proprement la connexion.
- [ ] **Timeout / erreurs** : `error` event et coupures réseau gérés sans figer l'UI.
- [ ] **Quota** : `limit_reached_dialog` déclenché correctement ; quota relu.
- [ ] **Tool results** : rendu schema-driven (`DynamicToolResultCard`) tolérant aux formats `data` vs `result` (SSE vs history).

## D. Push (OneSignal)
### Risques connus
- OneSignal initialisé avant `runApp` ; click listener cold-start qui « stashe » le payload puis le rejoue.
### Checklist
- [ ] **Permission** demandée au bon moment (pas au boot brut) ; `POST_NOTIFICATIONS` Android 13+.
- [ ] **Cold start** : payload capturé au lancement par notif puis rejoué une fois le router prêt → vérifier qu'aucun deeplink n'est perdu.
- [ ] **Deep link sur tap** : navigation correcte et **sécurisée** (validation, recoupe plan 05).
- [ ] **External user id** : association/désassociation au login/logout ; pas de fuite entre comptes.
- [ ] **In-app notifications** : `inAppNotificationsProvider` synchronisé, badge cohérent.
- [ ] **Consentement** : `notif_consent` respecté (recoupe plan 11).

## Commandes / mesures
```bash
rg -n "Stripe\.|paymentIntent|confirmPayment|clientSecret|confirm-free" lib --glob '!*.g.dart'
rg -n "PusherChannelsClient|subscribe|/broadcasting/auth|reconnect" lib --glob '!*.g.dart'
rg -n "EventSource|sse|text/event-stream|stream.listen" lib/features/petit_boo --glob '!*.g.dart'
rg -n "OneSignal|addClickListener|externalUserId|login\(|logout\(" lib --glob '!*.g.dart'
```

## Livrable
Diagramme d'états du flux de réservation/paiement avec trous identifiés (idempotence, reprise, échecs), audit du cycle de vie WebSocket (reconnexion/fuites/batterie), robustesse SSE, fiabilité du deep link push cold-start. Tout 🔴 P0 = ticket immédiat.
