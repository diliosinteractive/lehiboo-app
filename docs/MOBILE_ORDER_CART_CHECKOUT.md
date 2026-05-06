# Panier Mobile, Participants et Order Checkout

Derniere mise a jour : 2026-05-06.

Cette note documente le comportement mobile attendu pour rester aligne avec le SaaS et l'API `Order`.

## Flow cible

Le panier mobile utilise le flow `Order` pour tout achat multi-event, multi-slot, multi-ticket ou multi-vendor.

Endpoints :

```text
POST /api/v1/orders
POST /api/v1/orders/{order}/payment-intent
POST /api/v1/orders/{order}/confirm
POST /api/v1/orders/{order}/cancel
```

Le checkout single-event legacy peut encore utiliser les flows existants, mais les nouveaux achats panier doivent passer par `Order`.

## Timer panier

Avant creation de l'Order serveur, aucun quota n'est reserve. Le timer local indique uniquement que la selection panier est conservee.

Regles :

- le timer local demarre au premier ajout panier ;
- ajouter un nouveau billet ne remet pas le timer a 15 minutes ;
- augmenter ou diminuer une quantite ne remet pas le timer a 15 minutes ;
- vider le panier supprime le timer ;
- expiration du timer local avant paiement : vider le panier et demander de rajouter les billets.

Wording attendu :

- panier local : "Votre selection est conservee encore X. Les places seront bloquees a l'etape paiement." ;
- apres creation de l'Order : "Vos places sont bloquees encore X. Passe ce delai, elles seront liberees."

Implementation :

- `orderCartHoldProvider` stocke l'echeance locale en `SharedPreferences` ;
- `OrderCartNotifier.addSelection()` et `updateQuantity()` appellent `ensureActive()`, qui conserve une echeance encore valide ;
- `OrderCartScreen` affiche le timer local avant paiement.

## Passage a l'Order serveur

Au submit, le mobile doit envoyer l'echeance panier courante :

```json
{
  "expires_at": "2026-05-06T12:12:00.000Z"
}
```

Le backend reprend cette echeance si elle est plus courte que `now() + 15 minutes`. Si le panier etait a 12 minutes restantes, l'Order serveur doit donc rester a 12 minutes, pas repartir a 15.

Apres reponse API :

- mapper `data.expires_at` vers `CreateOrderResponseDto.expiresAt` ;
- synchroniser `orderCartHoldProvider` avec cette echeance serveur ;
- afficher le timer de reservation pendant le PaymentSheet.

## Paiement et abandon

Flow payant :

1. `POST /orders`
2. `POST /orders/{uuid}/payment-intent`
3. `Stripe.instance.initPaymentSheet(...)`
4. `Stripe.instance.presentPaymentSheet()`
5. `POST /orders/{uuid}/confirm`

Si le PaymentSheet est abandonne avant paiement reussi, appeler `/orders/{uuid}/cancel` en best effort pour relacher les quotas. Garder les champs acheteur et participants dans l'ecran panier afin que l'utilisateur n'ait pas a tout ressaisir.

Si le paiement a reussi mais que la confirmation mobile echoue, ne pas annuler l'Order : le webhook Stripe doit pouvoir le finaliser.

## Participants

Le checkout mobile doit afficher un participant par billet.

Champs obligatoires pour acheter :

| Champ UI | Payload |
|---|---|
| Prenom | `first_name` |
| Date de naissance | `birth_date` |
| Ville d'appartenance | `membership_city` |
| Relation | `relationship` |

Le nom, l'email et le telephone du participant ticket restent facultatifs pour l'achat. Le nom peut rester requis pour une fiche sauvegardee "Mes participants" tant que l'API backend le demande.

L'ecran doit expliquer que ces informations servent a personnaliser l'experience Le Hiboo, les recommandations IA et les offres/evenements proposes.

## Fichiers mobiles

| Fichier | Role |
|---|---|
| `lib/features/booking/presentation/providers/order_cart_provider.dart` | Panier et timer local |
| `lib/features/booking/presentation/screens/order_cart_screen.dart` | UI panier, participants, submit Order, PaymentSheet |
| `lib/features/booking/data/datasources/booking_api_datasource.dart` | Appels `/orders` |
| `lib/features/booking/data/models/order_api_dto.dart` | Mapping `expires_at` / `expiresAt` |
| `lib/features/booking/presentation/widgets/participant_form_card.dart` | Formulaire participant |

