# Migration Mobile — Indicative Prices (Additional Services)

**Date**: 23 avril 2026
**Auteur**: Equipe Dev
**Backend branch**: `develop`

---

## Resume

Les **services additionnels indicatifs** (parking, restauration, catering, etc.) crees par les vendors lors de la creation d'evenement sont maintenant exposes dans **tous** les endpoints mobile via le champ `indicative_prices`.

Ce champ existait deja sur les endpoints `GET /events` et `GET /events/{slug}`, mais il etait **absent** de `GET /home-feed` et `GET /events/featured`. Ce correctif comble ce manque.

---

## Contexte : deux concepts distincts

L'API expose deux champs distincts sur le DTO evenement mobile. Il est important de ne pas les confondre :

| Champ | Table DB | Nature | Cree via |
|-------|----------|--------|----------|
| `indicative_prices` | `event_indicative_prices` | **Informatif** — prix indicatifs affiches pour information | Formulaire vendor (etape Tickets) |
| `extra_services` | `extra_services` | **Transactionnel** — add-ons achetables lors du checkout | API CRUD separee (pas encore utilise) |

Ce que le vendor cree dans la section **"Additional services (indicative)"** de l'etape Tickets est stocke comme `indicative_prices`, pas comme `extra_services`.

> **Note** : `extra_services` sera un tableau vide `[]` tant que le module de vente d'add-ons n'est pas active cote vendor.

---

## Endpoints concernes

### Avant ce correctif

| Endpoint | `indicative_prices` present ? |
|----------|-------------------------------|
| `GET /api/v1/events` | Oui |
| `GET /api/v1/events/{slug}` | Oui |
| `GET /api/v1/home-feed` | **Non** (cle absente du JSON) |
| `GET /api/v1/events/featured` | **Non** (cle absente du JSON) |

### Apres ce correctif

| Endpoint | `indicative_prices` present ? |
|----------|-------------------------------|
| `GET /api/v1/events` | Oui |
| `GET /api/v1/events/{slug}` | Oui |
| `GET /api/v1/home-feed` | **Oui** |
| `GET /api/v1/events/featured` | **Oui** |

---

## Format de reponse

### Champ `indicative_prices`

Tableau d'objets inclus dans chaque evenement du DTO mobile. Tableau vide `[]` si aucun service indicatif n'est defini.

```json
{
  "indicative_prices": [
    {
      "uuid": "019db9b3-aea4-72b1-83ab-8c99b2863f5f",
      "label": "Polishing",
      "price": 5.00,
      "currency": "EUR",
      "sort_order": 0
    },
    {
      "uuid": "019db9b3-aea7-725a-8a34-97d10b3cbe01",
      "label": "Catering",
      "price": 10.00,
      "currency": "EUR",
      "sort_order": 1
    }
  ]
}
```

### Schema des champs

| Champ | Type | Nullable | Description |
|-------|------|----------|-------------|
| `uuid` | `string` | Non | Identifiant unique du service indicatif |
| `label` | `string` | Non | Nom du service (ex: "Parking", "Catering") |
| `price` | `float` | Non | Prix indicatif en unite monetaire |
| `currency` | `string` | Non | Devise ISO 4217 (toujours `"EUR"` pour l'instant) |
| `sort_order` | `int` | Non | Ordre d'affichage (0-based) |

---

## Model Dart suggere

```dart
class IndicativePrice {
  final String uuid;
  final String label;
  final double price;
  final String currency;
  final int sortOrder;

  const IndicativePrice({
    required this.uuid,
    required this.label,
    required this.price,
    required this.currency,
    required this.sortOrder,
  });

  factory IndicativePrice.fromJson(Map<String, dynamic> json) {
    return IndicativePrice(
      uuid: json['uuid'] as String,
      label: json['label'] as String,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String,
      sortOrder: json['sort_order'] as int,
    );
  }

  String get formattedPrice =>
      price == 0 ? 'Gratuit' : '${price.toStringAsFixed(2)} $currency';
}
```

### Integration dans le model Event existant

```dart
class Event {
  // ... champs existants ...

  final List<IndicativePrice> indicativePrices;

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      // ... champs existants ...
      indicativePrices: (json['indicative_prices'] as List<dynamic>?)
              ?.map((e) => IndicativePrice.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
```

---

## Suggestion d'affichage

Les prix indicatifs sont **informatifs uniquement**. Ils ne sont pas selectionnables ni ajoutables au panier. Affichage recommande :

```
┌─────────────────────────────────────┐
│  Services additionnels (indicatif)  │
│                                     │
│  Polishing ................. 5,00 € │
│  Catering ................ 10,00 € │
└─────────────────────────────────────┘
```

- Afficher uniquement si `indicative_prices` est non-vide
- Trier par `sort_order`
- Pas de bouton d'ajout — ce ne sont pas des articles achetables
- Contexte : ces informations aident l'utilisateur a anticiper les couts supplementaires eventuels sur place

---

## Distinction avec `extra_services`

Pour reference, voici la difference entre les deux champs :

### `indicative_prices` (a utiliser maintenant)

```json
{
  "indicative_prices": [
    { "uuid": "...", "label": "Catering", "price": 10.00, "currency": "EUR", "sort_order": 0 }
  ]
}
```

- **Pas interactif** : informations purement affichees
- **Cree par le vendor** dans l'etape Tickets du formulaire de creation
- **Toujours present** sur tous les endpoints mobile (apres ce correctif)

### `extra_services` (reserve pour usage futur)

```json
{
  "extra_services": [
    {
      "uuid": "...",
      "name": "Parking VIP",
      "description": "Place de parking reservee",
      "price": 15.00,
      "formatted_price": "15.00 EUR",
      "is_free": false,
      "max_quantity": 5,
      "is_active": true,
      "sort_order": 1
    }
  ]
}
```

- **Interactif** : add-ons selectionnables lors du checkout (futur)
- **Pas encore utilise** par le formulaire vendor — sera toujours `[]`
- Champs supplementaires : `description`, `formatted_price`, `is_free`, `max_quantity`, `is_active`

---

## Checklist migration Flutter

- [ ] Ajouter le model `IndicativePrice` (ou equivalent)
- [ ] Parser `indicative_prices` dans le model `Event`
- [ ] Afficher les prix indicatifs sur la page detail evenement
- [ ] Gerer le cas `indicative_prices: []` (ne rien afficher)
- [ ] Verifier l'affichage sur un evenement avec services : `GET /api/v1/events/piscine-party-1` avec header `X-Platform: mobile`

---

## Test

```bash
# Evenement avec indicative prices
curl -s "https://api.lehiboo.com/api/v1/events/piscine-party-1" \
  -H "X-Platform: mobile" \
  -H "Accept: application/json" \
  | jq '.data.indicative_prices'

# Home feed — verifier que la cle est presente
curl -s "https://api.lehiboo.com/api/v1/home-feed" \
  -H "X-Platform: mobile" \
  -H "Accept: application/json" \
  | jq '.data.tomorrow[0].indicative_prices'
```
