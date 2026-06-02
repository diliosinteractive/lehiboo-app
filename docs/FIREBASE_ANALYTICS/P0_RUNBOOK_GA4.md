# P0 — Runbook d'exécution GA4 (console)

> **Objectif** : rendre exploitables les 38 events déjà instrumentés en
> configurant la console GA4. Tout ici se fait dans **Firebase / GA4 console**
> (projet `lehiboo-77c35`) — **rien à coder**.
>
> ⚠️ Ces étapes ne sont **pas réalisables depuis le repo** (ni code, ni CLI).
> Ce document est un guide clic-par-clic avec les valeurs exactes à saisir.
>
> Pré-requis : avoir un rôle **Éditeur** sur la propriété GA4 liée à
> `lehiboo-77c35`. Réf. events : [TRACKING_ACTUEL.md](TRACKING_ACTUEL.md).

---

## Étape 1 — Déclarer les Custom Definitions

GA4 → **Admin** (roue crantée) → colonne *Propriété* → **Définitions
personnalisées** → onglet **Dimensions personnalisées** → bouton **Créer des
dimensions personnalisées**.

Pour chaque ligne : `Nom de la dimension` = libre (reprendre la colonne 1),
`Champ d'application` = colonne 2, `Paramètre d'événement` ou `Propriété
utilisateur` = colonne 3.

> 💡 Limite : 50 dimensions custom (propriété standard). On en déclare ~24 — OK.

### 1a. Dimensions à champ d'application **Événement**

| Nom dimension | Scope | Paramètre d'événement | Sert à segmenter |
|---------------|-------|-----------------------|------------------|
| Event UUID | Événement | `event_uuid` | Funnel par événement |
| Category | Événement | `category` | Funnel par catégorie |
| City slug | Événement | `city_slug` | Funnel par ville |
| Source | Événement | `source` | Attribution point d'entrée |
| Is free | Événement | `is_free` | Gratuit vs payant |
| Booking step | Événement | `step` | Localiser l'échec booking |
| Reason | Événement | `reason` | Cause d'échec (auth/booking) |
| Channel | Événement | `channel` | Canal de partage |
| Tool name | Événement | `tool_name` | Outil IA utilisé |
| Has date filter | Événement | `has_date_filter` | Comportement de recherche |
| Quota type | Événement | `quota_type` | Type de quota Petit Boo |
| Type | Événement | `type` | Type de notification |
| Slot id | Événement | `slot_id` | Détail booking |
| Booking UUID | Événement | `booking_uuid` | Détail tickets |
| Organization id | Événement | `organization_id` | Funnel membership |
| Cold start | Événement | `cold_start` | Deeplink / notif cold-start |
| UTM source | Événement | `utm_source` | Attribution deeplink |
| Enable push | Événement | `enable_push` | Adoption alertes |
| Enable email | Événement | `enable_email` | Adoption alertes |

> Les paramètres standard GA4 (`value`, `currency`, `transaction_id`,
> `search_term`, `item_id`, `item_name`, `item_category`, `content_type`,
> `method`, `quantity`) **n'ont pas besoin** d'être déclarés — GA4 les gère
> nativement.

### 1b. Dimensions à champ d'application **Utilisateur**

Onglet **Dimensions personnalisées** → `Champ d'application` = **Utilisateur** →
`Propriété utilisateur` = colonne 3.

| Nom dimension | Scope | Propriété utilisateur |
|---------------|-------|------------------------|
| User role | Utilisateur | `user_role` |
| Home city | Utilisateur | `home_city_slug` |
| Hibons rank | Utilisateur | `hibons_rank` |
| Push enabled | Utilisateur | `push_enabled` |
| Notif consent | Utilisateur | `notif_consent` |
| App locale | Utilisateur | `app_locale` |
| Env | Utilisateur | `env` |

> ⏱️ Les dimensions ne se remplissent **qu'à partir de leur création**
> (pas de rétroactif). À faire **avant** le rollout de la collecte.

---

## Étape 2 — Marquer les Key events (conversions)

Dans GA4 récent, "Conversions" s'appelle **Événements clés** (Key events).

GA4 → **Admin** → *Propriété* → **Événements clés** → **Marquer comme
événement clé** (ou activer le toggle sur l'event existant).

| Event | Déjà conversion par défaut ? | Action |
|-------|------------------------------|--------|
| `purchase` | ✅ oui | Rien à faire |
| `sign_up` | ❌ | Marquer comme événement clé |
| `search_saved` | ❌ | Marquer comme événement clé |
| `membership_join_completed` | ❌ | Marquer comme événement clé |
| `begin_checkout` | ❌ | Optionnel (micro-conversion) |
| `add_to_wishlist` | ❌ | Optionnel (micro-conversion) |

> Si un event n'apparaît pas encore dans la liste : il faut qu'il ait été
> reçu **au moins une fois** par GA4. Sinon, le créer manuellement via
> **Admin → Événements → Créer un événement** n'est pas nécessaire — attendre
> qu'il remonte, ou le saisir à la main dans la config Key events.

---

## Étape 3 — Isoler le trafic de production

Objectif : exclure dev/staging des rapports. On a une seule propriété et une
user property `env` (`development` / `staging` / `production`).

> ⚠️ **Important** : les *Data Filters* natifs GA4 ne filtrent que le trafic
> "internal/developer" (via `traffic_type`), **pas** une user property custom.
> On ne peut donc pas exclure `env != production` par un Data Filter standard.

**Méthode recommandée (simple, immédiate)** : appliquer un **filtre
`Env exactly matches production`** dans **chaque exploration** (cf. étape 4,
section *Filtres*). À refaire dans chaque rapport — mais fiable.

**Méthode robuste (long terme, optionnel)** : créer une **propriété GA4
distincte par environnement**, ou router via `traffic_type`. Plus lourd —
à arbitrer plus tard. Pour le P0, la méthode par filtre d'exploration suffit.

---

## Étape 4 — Construire les 2 funnels P0

GA4 → **Explorer** (menu gauche) → **Exploration de l'entonnoir** (Funnel
exploration).

### Réglage commun (à faire dans chaque exploration)

- **Filtres** (panneau *Paramètres* → *Filtres*) : ajouter
  `Env` → `correspond exactement à` → `production`.
- **Plage de dates** : 28 jours glissants pour démarrer.
- **Type d'entonnoir** : voir chaque funnel ci-dessous (fermé vs ouvert).

---

### Funnel 1 — Réservation (KPI n°1) — entonnoir **fermé**

Panneau *Étapes* (icône crayon à côté de "Étapes") → ajouter dans l'ordre :

| Étape | Nom | Condition (Event) |
|-------|-----|-------------------|
| 1 | Checkout démarré | `begin_checkout` |
| 2 | Créneau sélectionné | `booking_slot_selected` |
| 3 | Formulaire complété | `booking_customer_form_completed` |
| 4 | Infos paiement | `add_payment_info` |
| 5 | Achat | `purchase` |

- Cocher **"Rendre l'entonnoir fermé"** (closed funnel) en haut du panneau Étapes.
- **Répartition** (Breakdown) : glisser la dimension `City slug` ou `Category`.
- **Variante gratuite** : dupliquer l'exploration, ajouter le filtre
  `Is free = true`, et **supprimer l'étape 4** (les réservations gratuites
  n'émettent jamais `add_payment_info`).

**Funnel d'échec complémentaire** (table simple, pas un funnel) : rapport libre
sur `booking_failed`, répartition par `Booking step` et `Reason`.

---

### Funnel 2 — Découverte → Réservation — entonnoir **ouvert**

Décocher "Rendre l'entonnoir fermé" (open funnel).

| Étape | Nom | Condition |
|-------|-----|-----------|
| 1 | Découverte | `event_viewed` **OU** `search_submitted` **OU** `map_opened` **OU** `petitboo_chat_opened` |
| 2 | Event consulté | `event_viewed` |
| 3 | Checkout démarré | `begin_checkout` |
| 4 | Achat | `purchase` |

- Étape 1 : dans l'éditeur d'étape, ajouter plusieurs conditions reliées par
  **"OU"** (bouton *Ajouter une condition* → *Ou*).
- **Répartition par `Source`** : c'est l'analyse clé — compare la conversion
  search vs carte vs Petit Boo vs home.

> Astuce : sauvegarder chaque exploration avec un nom clair
> (`P0 — Funnel Réservation`, `P0 — Découverte→Réservation`) et la partager à
> l'équipe via *Partager* (lecture seule).

---

## Checklist de validation P0

- [ ] **24 dimensions** custom créées (19 event-scoped + 7 user-scoped)
- [ ] `sign_up`, `search_saved`, `membership_join_completed` marqués Key events
- [ ] Filtre `Env = production` appliqué dans les explorations
- [ ] Funnel 1 (Réservation, fermé) construit + variante gratuite
- [ ] Funnel 2 (Découverte→Réservation, ouvert) construit avec breakdown `Source`
- [ ] Funnel d'échec `booking_failed` par `step` / `reason`
- [ ] Vérifié dans **DebugView** qu'un parcours réel remplit bien les étapes
      (cf. [10_FUNNELS_AND_TESTING.md](10_FUNNELS_AND_TESTING.md) §0 pour activer DebugView)

---

## ⚠️ Rappel : pré-requis qui conditionne tout

Les funnels ne se remplissent que si **la collecte est active** = l'utilisateur
a accepté le consent gate (`granted`). Le socle est en place
([consent_gate_modal.dart](../../lib/core/analytics/widgets/consent_gate_modal.dart)),
mais sur un device de test il faut avoir tapé **"Accepter"** au 1er launch,
sinon DebugView reste vide même config parfaite.
