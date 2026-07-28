# Analyse — Erreur 422 sur `create_order` (panier / checkout)

> Date : 2026-06-08
> Écran : [order_cart_screen.dart](../../../lib/features/booking/presentation/screens/order_cart_screen.dart)
> Endpoint : `POST /api/v1/orders`
> Symptôme : badge rouge `[DEBUG create_order] DioException [bad response] ... status code of 422`

---

## 1. Ce que dit réellement l'erreur

```
[DEBUG create_order] DioException [bad response]:
status code of 422 ... "Client error - the request contains bad syntax or cannot be fulfilled"
```

- **422 = Unprocessable Entity** → le backend Laravel a **reçu** la requête (donc URL, auth, réseau OK) mais a **rejeté la validation** du payload `/orders`.
- `create_order` = la 1ʳᵉ étape du checkout ([order_cart_screen.dart:1009-1023](../../../lib/features/booking/presentation/screens/order_cart_screen.dart#L1009-L1023)). On échoue donc **avant** Stripe — c'est un problème de **contenu de payload**, pas de paiement.
- Le panier affiché est **« Gratuit / 1 billet »** → flux gratuit, pas un échec carte.

## 2. ⚠️ Le vrai motif du 422 est masqué

C'est le point central. Le message affiché est le `toString()` **générique de Dio**, pas le corps de la réponse Laravel.

[order_cart_screen.dart:1138-1141](../../../lib/features/booking/presentation/screens/order_cart_screen.dart#L1138-L1141) :

```dart
// TODO(debug): RETIRER avant prod — affichage de l'erreur brute au lieu
// du message générique pour diagnostiquer l'échec de paiement TestFlight.
// Restaurer: _errorMessage = ApiResponseHandler.extractError(e) ?? context.l10n.bookingPaymentFailed;
_errorMessage = '[DEBUG $checkoutStep] $e';   // ← n'affiche PAS error.response.data
```

Or un 422 Laravel renvoie **les champs fautifs** dans le corps, ex. :

```json
{ "error": { "details": { "customer_birth_date": ["The customer birth date field is required."] } } }
```

Et [`ApiResponseHandler.extractError`](../../../lib/core/utils/api_response_handler.dart#L172) sait déjà parser ce format (`error.details` → premier message). **Le code debug court-circuite cette extraction**, on perd donc l'info la plus utile.

### Action n°1 (prioritaire) — révéler le corps du 422

Remplacer temporairement le message debug par le contenu de la réponse :

```dart
} catch (e, stack) {
  // ...
  final body = e is DioException ? e.response?.data : null;
  _errorMessage = '[DEBUG $checkoutStep] ${body ?? e}';
}
```

ou restaurer directement `ApiResponseHandler.extractError(e)`. **Sans ce corps, tout le reste n'est qu'hypothèse.**

---

## 3. Candidats probables du rejet (à confronter au corps une fois révélé)

Payload réellement envoyé ([datasource:190-208](../../../lib/features/booking/data/datasources/booking_api_datasource.dart#L190-L208) + [items:1260-1286](../../../lib/features/booking/presentation/screens/order_cart_screen.dart#L1260-L1286)) :

```jsonc
{
  "items": [{
    "event_id": "...",        // item.event.id
    "slot_id": "...",         // item.slotId
    "ticket_type_id": "...",  // item.ticket.id
    "quantity": 1,
    "attendees": [{
      "first_name": "...", "last_name": "...", "relationship": "...",
      "birth_date": "...", "membership_city": "..."
    }]
  }],
  "customer_email": "pauline@dilios.fr",
  "customer_first_name": "Pauline",
  "customer_last_name": "Admin LeHiboo",
  "customer_phone": "+3306...",
  // "customer_birth_date": ABSENT si le profil n'a pas de date de naissance
  "customer_town": "Marly",
  "accept_refund_policy": false,
  "meta": { "source": "mobile_cart_checkout" }
}
```

### Suspect n°1 — `customer_birth_date` absent (le plus probable)

- `_customerBirthDate` n'est alimenté **que** depuis `user.birthDate` ([screen:113-116](../../../lib/features/booking/presentation/screens/order_cart_screen.dart#L113-L116)).
- **Aucun champ de saisie de date de naissance acheteur** sur l'écran panier (le formulaire ne montre que Prénom / Nom / Email / Téléphone / Ville — cf. capture).
- Si le compte connecté (Pauline) n'a pas de date de naissance, le champ est **omis** (`if (customerBirthDate != null && ...)`).
- → Si la validation `/orders` exige `customer_birth_date`, c'est un 422 garanti, **non corrigeable par l'utilisateur depuis cet écran**.

### Suspect n°2 — chaînes vides dans `attendees`

`_buildOrderItemsPayload` envoie des `''` plutôt que d'omettre les clés :

```dart
'relationship': attendee.relationship ?? '',
'birth_date':   attendee.birthDate ?? '',
'membership_city': attendee.membershipCity ?? attendee.city ?? '',
'last_name':    attendee.lastName ?? '',
```

- `birth_date: ''` échoue sur une règle `date` (une chaîne vide n'est pas une date valide, selon la config `ConvertEmptyStringsToNull`).
- Note : `ParticipantInfo.isComplete` ([booking_flow_state.dart:34-47](../../../lib/features/booking/domain/models/booking_flow_state.dart#L34-L47)) exige `firstName`, `relationship`, `birthDate`, `town` — **mais pas `lastName` ni `email`**. Un attendee « complet » côté client peut donc partir avec `last_name: ''`, ce que le backend peut refuser.

### Suspect n°3 — désynchro de schéma `/orders`

- Le flux historique `/bookings` utilise `BookingTicketRequestDto.toJson()`, alors que `/orders` envoie des **maps brutes** construites à la main, avec `attendees` imbriqués.
- À vérifier : le backend `/orders` attend-il bien `event_id` / `slot_id` / `ticket_type_id` / `attendees[]` sous cette forme, ou des noms différents (`event_uuid`, `slot_uuid`, `tickets[]`…) ?

### Suspect n°4 — identifiants (UUID vs ID numérique)

- Rappel CLAUDE.md : les routes attendent l'**UUID**. Ici on passe `item.event.id`, `item.slotId`, `item.ticket.id` dans le **corps** (pas l'URL).
- À vérifier dans le corps du 422 : si un message du type `selected items.0.event_id is invalid`, c'est qu'un de ces champs porte un ID numérique au lieu de l'UUID attendu.

---

## 4. Plan de diagnostic (ordre recommandé)

1. **Révéler le corps 422** (Action n°1) → relancer la réservation et lire le `details`.
2. Identifier le(s) champ(s) listé(s) dans `error.details`.
3. Selon le champ :
   - `customer_birth_date` → ajouter un champ date de naissance acheteur sur l'écran panier, ou rendre le champ facultatif côté API.
   - `attendees.*.birth_date` / `*.last_name` → omettre les clés vides au lieu d'envoyer `''` dans `_buildOrderItemsPayload`.
   - `event_id` / `slot_id` / `ticket_type_id` → vérifier qu'on envoie bien des UUID.
4. Confronter le payload au **schéma de validation Laravel** de `POST /orders` (côté backend).

## 5. Correctifs candidats côté app (après confirmation du corps)

- **Nettoyer le payload attendees** : ne pas sérialiser les champs vides.

  ```dart
  // au lieu de 'birth_date': attendee.birthDate ?? '',
  if ((attendee.birthDate ?? '').isNotEmpty) 'birth_date': attendee.birthDate,
  ```

- **Buyer birth date** : si requise par l'API, ajouter un champ de saisie (et un fallback de validation client) sur l'écran panier.
- **Restaurer la gestion d'erreur propre** : remettre `ApiResponseHandler.extractError(e)` (qui affiche déjà le message Laravel localisé) une fois le diagnostic terminé — le `[DEBUG …]` ne doit pas partir en prod.

---

### Résumé en une ligne

> Le 422 est un **rejet de validation backend sur `POST /orders`**, et son motif exact est **caché par le code debug** ([screen:1141](../../../lib/features/booking/presentation/screens/order_cart_screen.dart#L1141)). Suspect principal : **`customer_birth_date` manquant** (aucun champ de saisie sur l'écran + profil sans date de naissance) ; suspects secondaires : **chaînes vides dans `attendees`** et **désynchro de schéma `/orders`**. Première action : afficher `e.response?.data` pour lire `error.details`.
