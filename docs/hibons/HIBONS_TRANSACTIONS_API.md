# API — Historique des transactions Hibons (Mobile)

Endpoint de lecture de l'historique des transactions Hibons d'un utilisateur, avec métadonnées de solde et répartition par pilier. Supporte **deux modes** : paginé (`page`/`per_page`) ou snapshot legacy (`limit`).

| | |
|---|---|
| **Méthode** | `GET` |
| **URL** | `/api/v1/mobile/hibons/transactions` |
| **Auth** | `Bearer <user_jwt_token>` (requis) |
| **Contrôleur** | `App\Http\Controllers\Api\V1\Mobile\HibonsController@transactions` |
| **Route name** | `mobile.hibons.transactions` |

---

## Paramètres de requête (query)

Tous optionnels.

| Paramètre | Type | Contraintes | Défaut | Description |
|-----------|------|-------------|--------|-------------|
| `page` | integer | `>= 1` | `1` | Numéro de page. **Active le mode paginé.** |
| `per_page` | integer | `1`–`50` | `10` | Nombre de transactions par page. **Active le mode paginé.** |
| `limit` | integer | `1`–`50` | `20` | Mode legacy : renvoie un snapshot non paginé. Ignoré si `page`/`per_page` est présent. |
| `type` | string | `earned`, `spent`, `bonus`, `purchase`, `refund` | — | Filtre par type de transaction. |
| `pillar` | string | `onboarding`, `engagement`, `discovery`, `participation`, `community`, `system` | — | Filtre par pilier. |

### Sélection du mode

- Si **`page` OU `per_page`** est fourni → **mode paginé** : la réponse contient les champs de pagination dans `meta` (`current_page`, `last_page`, `per_page`, `total`).
- Sinon → **mode legacy** : `limit` transactions max, `meta` sans champs de pagination (rétro-compatibilité mobile).

Les transactions sont toujours triées par date décroissante (`created_at DESC`).

---

## Exemples

### Mode paginé
```
GET /api/v1/mobile/hibons/transactions?page=2&per_page=10
Authorization: Bearer <token>
```

### Avec filtres
```
GET /api/v1/mobile/hibons/transactions?page=1&per_page=20&type=earned&pillar=community
Authorization: Bearer <token>
```

### Mode legacy (snapshot)
```
GET /api/v1/mobile/hibons/transactions?limit=50
Authorization: Bearer <token>
```

---

## Réponse `200 OK` (mode paginé)

```json
{
  "data": [
    {
      "uuid": "9b1c2d3e-4f50-6789-abcd-ef0123456789",
      "type": "earned",
      "type_label": "Gagné",
      "amount": 40,
      "formatted_amount": "+40",
      "balance_after": 290,
      "source": "review_left",
      "pillar": "community",
      "pillar_label": "Communauté",
      "pillar_color": "#EC4899",
      "title": "Avis publié",
      "subtitle": "Soirée Stand-up Impro du Carillon",
      "context": {
        "type": "event",
        "uuid": "0a1b2c3d-...",
        "slug": "soiree-stand-up-impro-du-carillon",
        "title": "Soirée Stand-up Impro du Carillon",
        "image_url": "https://.../event.jpg"
      },
      "description": null,
      "created_at": "2026-06-02T18:30:00+00:00"
    }
  ],
  "meta": {
    "current_balance": 290,
    "lifetime_earned": 5000,
    "earnings_by_pillar": [
      { "pillar": "community", "label": "Communauté", "color": "#EC4899", "amount": 320 },
      { "pillar": "participation", "label": "Participation", "color": "#10B981", "amount": 250 }
    ],
    "current_page": 2,
    "last_page": 5,
    "per_page": 10,
    "total": 47
  }
}
```

En **mode legacy**, la structure est identique mais `meta` ne contient **pas** `current_page` / `last_page` / `per_page` / `total`.

---

## Schéma — objet transaction (`data[]`)

| Champ | Type | Description |
|-------|------|-------------|
| `uuid` | string | Identifiant public de la transaction. |
| `type` | string | `earned` \| `spent` \| `bonus` \| `purchase` \| `refund`. |
| `type_label` | string | Libellé traduit du type. |
| `amount` | integer | Montant (positif = crédit, négatif = débit). |
| `formatted_amount` | string | Montant formaté avec signe, ex. `"+40"`, `"-50"`. |
| `balance_after` | integer | Solde après cette transaction. |
| `source` | string | Slug de la source, ex. `review_left`, `booking_created`, `daily_login_3min`. |
| `pillar` | string \| null | Pilier : `onboarding`, `engagement`, `discovery`, `participation`, `community`, `system`. |
| `pillar_label` | string \| null | Libellé traduit du pilier (ex. `"Communauté"`). |
| `pillar_color` | string \| null | Couleur hex du pilier (ex. `"#EC4899"`). |
| `title` | string | Titre lisible (résolu depuis `hibons.sources.{source}`). |
| `subtitle` | string \| null | Sous-titre = titre du contexte (nom d'événement / organisation). |
| `context` | object \| null | Entité liée (voir ci-dessous). |
| `description` | string \| null | Description libre éventuelle. |
| `created_at` | string | Date ISO 8601. |

### Objet `context`

Présent uniquement si la transaction est liée à une entité. Trois formes possibles :

**`event`**
```json
{ "type": "event", "uuid": "...", "slug": "...", "title": "...", "image_url": "..." }
```
**`organization`**
```json
{ "type": "organization", "uuid": "...", "slug": "...", "title": "...", "image_url": "..." }
```
**`booking`**
```json
{ "type": "booking", "uuid": "...", "reference": "A1B2C3D4" }
```

---

## Schéma — `meta`

| Champ | Type | Mode | Description |
|-------|------|------|-------------|
| `current_balance` | integer | toujours | Solde actuel du wallet. |
| `lifetime_earned` | integer | toujours | Total cumulé gagné (jamais décrémenté). |
| `earnings_by_pillar` | array | toujours | Répartition des gains par pilier (`pillar`, `label`, `color`, `amount`). |
| `current_page` | integer | paginé | Page courante. |
| `last_page` | integer | paginé | Dernière page disponible. |
| `per_page` | integer | paginé | Taille de page effective. |
| `total` | integer | paginé | Nombre total de transactions (filtres appliqués). |

---

## Erreurs

| Code | Cas |
|------|-----|
| `401 Unauthorized` | Token absent / invalide / expiré. |
| `422 Unprocessable Entity` | Validation échouée (ex. `per_page > 50`, `type` hors liste). |

---

## Notes d'implémentation

- Les contextes (events / organizations / bookings) sont pré-chargés en **3 requêtes max** via `HibonTransactionResource::preloadContexts()` pour éviter le N+1.
- Pour le mobile, privilégier le **mode paginé** (`page`/`per_page`) afin de scroller l'historique complet ; le mode `limit` reste pour la rétro-compatibilité.
- Le même endpoint est consommé par le dashboard web (`/dashboard/wallet`).
