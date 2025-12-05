# 🗄️ PROMPT_BACKEND_LEHIBOO_WORDPRESS.md
# Prompt complet pour générer toute l’API WordPress Headless LeHiboo

> À donner tel quel à **Google Gemini 3 Pro** pour créer un **plugin WordPress complet**, structuré, sécurisé et conforme au modèle de données LeHiboo.

---

# 🦉 1. CONTEXTE

Le Hiboo est une plateforme hyper-locale permettant :
- aux utilisateurs : de découvrir, filtrer et réserver des activités locales,
- aux partenaires : de gérer activités, créneaux et réservations.

L’application mobile Flutter consommera **exclusivement** une API WordPress Headless via `/wp-json/lehiboo/v1/...`.

Gemini doit produire **un plugin WordPress entièrement fonctionnel**, nommé :

```
lehiboo-core
```

---

# 🎯 2. OBJECTIFS DU PLUGIN

Le plugin doit :

### ✔️ Modéliser les données LeHiboo dans WordPress
À travers **Custom Post Types**, **Taxonomies**, **Meta**, **Rôles**, **Permissions**.

### ✔️ Exposer une API REST propre et moderne
Via :
```
/wp-json/lehiboo/v1/
```

### ✔️ Servir les fonctionnalités :
- listing d’activités,
- gestion des créneaux (slots),
- réservation (bookings),
- billetterie (tickets),
- partenaires & villes,
- articles éditoriaux,
- stats partenaires.

### ✔️ Structurer un backend propre, évolutif, sécurisé.

### ✔️ Générer un plugin **ZIP installable**, dans un dossier unique.

---

# 🧱 3. STRUCTURE DU PLUGIN

Le plugin généré doit respecter une arborescence propre :

```
lehiboo-core/
├── lehiboo-core.php
├── includes/
│   ├── cpt/
│   │   ├── class-activity-cpt.php
│   │   ├── class-slot-cpt.php
│   │   ├── class-booking-cpt.php
│   │   ├── class-ticket-cpt.php
│   │   ├── class-partner-cpt.php
│   │   └── class-city-cpt.php
│   ├── taxonomies/
│   │   ├── class-activity-category.php
│   │   ├── class-activity-tag.php
│   │   ├── class-age-range.php
│   │   └── class-audience.php
│   ├── rest/
│   │   ├── class-rest-activities.php
│   │   ├── class-rest-slots.php
│   │   ├── class-rest-bookings.php
│   │   ├── class-rest-tickets.php
│   │   ├── class-rest-partners.php
│   │   ├── class-rest-cities.php
│   │   └── class-rest-editorial.php
│   ├── roles/
│   │   └── class-roles.php
│   ├── utils/
│   │   ├── class-helpers.php
│   │   └── class-validator.php
└── readme.txt
```

---

# 🏗️ 4. CUSTOM POST TYPES À CRÉER

Gemini doit générer le code complet de `register_post_type` pour :

## 4.1. `activity`
Représente une activité ou type d’événement.

Champs (meta):
- `excerpt`
- `description_full`
- `is_free`
- `price_min`, `price_max`, `currency`
- `duration_minutes`
- `indoor_outdoor` (indoor | outdoor | both)
- `age_range_id`
- `city_id`
- `partner_id`
- `venue_address`, `venue_lat`, `venue_lng`
- `reservation_mode` (lehiboo_free | lehiboo_paid | external_url | phone | email)
- `external_booking_url`, `booking_phone`, `booking_email`
- `is_highlighted`

## 4.2. `slot`
Représente un créneau (horaire) de l’activité.

Champs meta :
- `activity_id`
- `start_datetime`
- `end_datetime`
- `capacity_total`, `capacity_remaining`
- `price_min`, `price_max`, `currency`
- `status` (scheduled | cancelled | sold_out)

## 4.3. `booking`
Champs :
- `user_id`
- `activity_id`
- `slot_id`
- `qty`
- `total_price`, `currency`
- `status`
- `payment_provider`
- `payment_reference`

## 4.4. `ticket`
Champs :
- `booking_id`
- `user_id`
- `slot_id`
- `ticket_type`
- `qr_code_data`
- `status`

## 4.5. `partner`
Champs :
- `logo`
- `city_id`
- `website`
- `email`, `phone`
- `social_links`
- `verified`
- `wp_user_id`

## 4.6. `city`
Champs :
- `name`
- `slug`
- `lat`, `lng`
- `region`

## 4.7. `editorial`
Articles éditoriaux.

---

# 🔖 5. TAXONOMIES

Gemini doit coder :
- `activity_category` (catégories fonctionnelles)
- `activity_tag` (tags libres)
- `age_range` (0–3, 4–6, 7–11, 12–17, adulte...)
- `audience` (famille, ado, senior, tout public…)

---

# 🔐 6. RÔLES & CAPACITÉS

Créer des rôles spécifiques :

## `lehiboo_admin`
Accès total.

## `lehiboo_partner`
- peut créer / éditer **ses** activities & slots,
- peut consulter bookings & tickets liés à ses activités,
- ne peut pas voir celles des autres.

## `lehiboo_user`
- accès limité (réservations personnelles via API seulement).

Gemini doit coder les permissions + les vérifier dans les endpoints REST.

---

# 🌐 7. ENDPOINTS REST À CRÉER

Créer un namespace :
```
/wp-json/lehiboo/v1/
```

## 7.1. ACTIVITÉS

### `GET /activities`
Params :
- `city`, `category`, `age_range`, `date_from`, `date_to`,
- `indoor_outdoor`,
- `free_only`, `max_price`,
- `duration_bucket`,
- `page`, `per_page`.

Retour JSON :
- activité + résumé des créneaux (next_slot, nb_slots,...)

### `GET /activities/{id}`
Retour :
- activité + slots à venir.

---

## 7.2. SLOTS

### `GET /slots`
Filtrable par : activité, ville, date, prix, durée.

---

## 7.3. PARTENAIRES

### `GET /partners`
### `GET /partners/{id}`
### `GET /partners/{id}/stats`
- vue, réservations, taux de remplissage.

---

## 7.4. VILLES

### `GET /cities`
---

## 7.5. ÉDITORIAL

### `GET /editorial`
### `GET /editorial/{id}`

---

# 🎟️ 7.6. BOOKINGS & TICKETS

## Côté utilisateur (auth JWT)

### `POST /bookings`
- body : `slot_id`, `qty`, `buyer_info`, `participants_info`, etc.

### `POST /bookings/{id}/confirm`
- confirme une réservation (après paiement Stripe si payant).

### `POST /bookings/{id}/cancel`

### `GET /me/bookings`

### `GET /me/tickets`

Chaque ticket doit contenir :
- id
- qr_code_data
- statut
- infos créneau

---

# 🧩 8. STRUCTURE JSON DES RÉPONSES

Exemple pour une activité :

```json
{
  "id": 12,
  "title": "Atelier poterie enfants",
  "excerpt": "Atelier ludique pour 4-8 ans",
  "description": "<p>...</p>",
  "category": {"id": 2, "name": "Famille"},
  "tags": [...],
  "age_range": {"id": 1, "label": "4-8 ans"},
  "is_free": false,
  "price": {"min": 8, "max": 12, "currency": "EUR"},
  "duration_minutes": 60,
  "city": {"id": 5, "name": "Valence"},
  "venue": {
    "address": "20 rue des Ormes",
    "lat": 44.9,
    "lng": 4.9
  },
  "reservation_mode": "lehiboo_paid",
  "external_booking_url": null,
  "partner": {
    "id": 7,
    "name": "MJC de Valence",
    "logo_url": "https://..."
  },

