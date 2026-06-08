# Étude — Funnels GA4 les plus pertinents pour Le Hiboo

> **Objectif** : à partir des events réellement instrumentés (cf.
> [TRACKING_ACTUEL.md](TRACKING_ACTUEL.md)), définir **quels funnels construire
> dans GA4** (Explore → Funnel exploration), pourquoi, avec quelles étapes,
> quels segments et quels KPIs cibles.
>
> Ce document est **stratégique / analytique** — le guide de recette des events
> est dans [10_FUNNELS_AND_TESTING.md](10_FUNNELS_AND_TESTING.md).
>
> Date : 2026-06-02.

---

## 0. Pré-requis indispensables (à faire AVANT tout funnel)

### 0.1 La collecte doit être active

Rappel : `setCollectionEnabled(false)` par défaut au boot. Aucun funnel ne se
remplit tant que le consent gate ne passe pas la majorité des users en
`granted`. **C'est le pré-requis n°1.**

### 0.2 Déclarer les Custom Definitions GA4

Les paramètres custom ne sont **pas exploitables comme dimensions/breakdowns**
tant qu'ils ne sont pas déclarés dans GA4 → Admin → Custom definitions. Sans
ça, impossible de segmenter un funnel par ville, catégorie, source, etc.

**Custom dimensions (event-scoped) à créer en priorité :**

| Paramètre | Utilisé par | Sert à segmenter |
|-----------|-------------|------------------|
| `event_uuid` | event_viewed, begin_checkout, purchase… | Funnel par événement |
| `category` | event_viewed | Funnel par catégorie d'event |
| `city_slug` | event_viewed, search_submitted, search_saved | Funnel par ville |
| `source` | map_opened, petitboo_chat_opened, deeplink_opened, hibons_earned, notification_opened | Attribution du point d'entrée |
| `is_free` | begin_checkout, purchase, event_viewed | Segmenter gratuit vs payant |
| `step` | booking_failed | Localiser l'échec dans le funnel |
| `reason` | booking_failed, login_failed, signup_failed | Cause d'échec |
| `channel` | event_shared | Canal de partage |
| `tool_name` | petitboo_tool_used | Quel outil IA est utilisé |
| `has_date_filter` | search_submitted | Comportement de recherche |
| `quota_type` | petitboo_quota_reached | Type de quota atteint |

**User properties (user-scoped) à créer comme dimensions :**
`user_role`, `app_locale`, `home_city_slug`, `hibons_rank`, `push_enabled`,
`notif_consent`, `env`.

> ⚠️ Filtre systématique recommandé sur **tous** les rapports :
> `env = production` (sinon les events dev/staging polluent les chiffres).

### 0.3 Marquer les conversions

Dans GA4 → Admin → Events → marquer en **conversion** :
`purchase` (déjà conversion par défaut), `sign_up`, `search_saved`,
`membership_join_completed`. Optionnel : `add_to_wishlist`, `begin_checkout`.

---

## 1. Tableau de priorisation

| # | Funnel | Priorité | Valeur business | Type GA4 |
|---|--------|----------|-----------------|----------|
| 1 | **Réservation (checkout)** | 🔴 P0 | Revenu direct — le KPI n°1 | Funnel fermé |
| 2 | **Découverte → Réservation (macro)** | 🔴 P0 | Mesure la conversion bout-en-bout du produit | Funnel ouvert |
| 3 | **Activation nouvel utilisateur** | 🟠 P1 | Rétention / onboarding | Funnel ouvert |
| 4 | **Inscription (registration)** | 🟠 P1 | Croissance de la base | Funnel fermé |
| 5 | **Notification → Re-engagement** | 🟠 P1 | Rétention / canal owned | Funnel ouvert |
| 6 | **Recherche sauvegardée → retour** | 🟡 P2 | Rétention long terme | Funnel ouvert |
| 7 | **Petit Boo → conversion** | 🟡 P2 | ROI de l'assistant IA | Funnel ouvert |
| 8 | **Favoris → Réservation** | 🟡 P2 | Intention d'achat différée | Funnel ouvert |
| 9 | **Carte → Réservation** | 🟢 P3 | Valeur de la découverte géo | Funnel ouvert |
| 10 | **Adhésion organisateur** | 🟢 P3 | Engagement communautaire | Funnel fermé |

> **Funnel fermé** : l'utilisateur doit franchir les étapes dans l'ordre exact.
> **Funnel ouvert** : il peut entrer à n'importe quelle étape (utile pour les
> parcours multi-entrées).

---

## 2. 🔴 P0 — Funnel Réservation (checkout)

**Question business** : où perd-on les acheteurs entre l'ouverture du checkout
et l'achat ?

| Étape | Event | Condition |
|-------|-------|-----------|
| 1 | `begin_checkout` | — |
| 2 | `booking_slot_selected` | — |
| 3 | `booking_customer_form_completed` | — |
| 4 | `add_payment_info` | (payant uniquement) |
| 5 | `purchase` | — |

**Variante gratuite** : créer un funnel filtré `is_free = true` qui saute
l'étape 4 (`begin_checkout → slot_selected → form_completed → purchase`). Les
réservations gratuites n'émettent jamais `add_payment_info` — les mélanger
fausse le taux de décrochage à l'étape paiement.

### Points de décrochage à surveiller

- **2 → 3 (slot → formulaire)** : friction de saisie / créneaux indisponibles.
- **3 → 4 (formulaire → paiement)** : abandon à l'écran paiement (prix, confiance).
- **4 → 5 (paiement → achat)** : échecs Stripe → croiser avec `booking_failed`
  (`step = payment`).

### Funnel d'échec complémentaire

Construire un rapport sur `booking_failed` segmenté par `step`
(`create`/`payment`/`confirm`) et `reason`. Permet de distinguer un problème
backend (create/confirm) d'un problème de paiement.

### Segments recommandés
`user_role`, `home_city_slug`, `is_free`, `app_locale`, top `category`.

### KPIs cibles
- Taux `begin_checkout → purchase` global (≥ référence à établir au lancement).
- Taux de complétion paiement `add_payment_info → purchase` (devrait être > 85 % ;
  en dessous = problème Stripe/UX paiement).

---

## 3. 🔴 P0 — Funnel Découverte → Réservation (macro)

**Question business** : le produit transforme-t-il la découverte en réservation ?
Quel point d'entrée convertit le mieux ?

Funnel **ouvert** (entrées multiples) :

| Étape | Event | Rôle |
|-------|-------|------|
| 1 | `screen_view` (home) **ou** `search_submitted` **ou** `map_opened` **ou** `petitboo_chat_opened` | Découverte |
| 2 | `event_viewed` | Intérêt pour un event précis |
| 3 | `begin_checkout` | Intention d'achat |
| 4 | `purchase` | Conversion |

### Analyse clé : breakdown par `source` / point d'entrée

Dupliquer ce funnel segmenté par canal de découverte pour comparer la
conversion **search vs carte vs Petit Boo vs home feed**. C'est l'analyse qui
oriente les investissements produit.

### KPIs cibles
- `event_viewed → begin_checkout` (taux d'intention).
- `event_viewed → purchase` global (conversion produit).
- Comparaison du taux de conversion **par source**.

---

## 4. 🟠 P1 — Funnel Activation nouvel utilisateur

**Question business** : un nouvel inscrit atteint-il son "aha moment"
(1ère réservation / 1er favori) ? Prédicteur de rétention.

Funnel **ouvert**, fenêtre 7 jours après `first_open` :

| Étape | Event | Signification |
|-------|-------|---------------|
| 1 | `first_open` (auto GA4) | Installation |
| 2 | `sign_up` | Création de compte |
| 3 | `event_viewed` | 1ère consultation d'event |
| 4 | `add_to_wishlist` **ou** `begin_checkout` | 1er signal d'engagement |
| 5 | `purchase` | Activation forte |

### Segments recommandés
`app_locale`, `home_city_slug` (les villes peu pourvues en events activent moins),
`notif_consent` (consentement = meilleure rétention ?).

### KPIs cibles
- % de nouveaux users atteignant `event_viewed` en J+1.
- % atteignant `add_to_wishlist` ou `begin_checkout` en J+7.
- Corrélation `push_enabled = true` ↔ activation.

---

## 5. 🟠 P1 — Funnel Inscription (registration)

**Question business** : où abandonne-t-on dans le tunnel d'inscription ?

Funnel **fermé** :

| Étape | Event | Source |
|-------|-------|--------|
| 1 | `screen_view` `screen_name = register` (écran formulaire) | Arrivée sur le form |
| 2 | `sign_up` | OTP vérifié → compte créé |
| (échec) | `signup_failed` (breakdown `reason`) | Erreurs (email existant, mot de passe faible…) |

### ⚠️ Gap d'instrumentation

Le décrochage **formulaire rempli → OTP saisi** n'est **pas mesurable**
aujourd'hui : `signup_started`, `otp_sent`, `otp_verified` sont déclarés mais
**non instrumentés** ([analytics_event.dart](../../lib/core/analytics/analytics_event.dart)).
Pour un vrai funnel d'inscription à 4 étapes (form vu → soumis → OTP envoyé →
OTP vérifié), il faut câbler ces 3 events. **Recommandation : instrumenter
`signup_started` (submit du form) et `otp_verified`** — c'est le chaînon
manquant le plus rentable.

### KPIs cibles
- Taux `register screen_view → sign_up`.
- Top `reason` de `signup_failed` (priorise les correctifs UX/validation).

---

## 6. 🟠 P1 — Funnel Notification → Re-engagement

**Question business** : les push ramènent-ils les users vers une conversion ?

Funnel **ouvert** :

| Étape | Event | Note |
|-------|-------|------|
| 1 | `notification_opened` | breakdown par `type` de notif |
| 2 | `event_viewed` | la notif a mené à un event |
| 3 | `begin_checkout` | intention |
| 4 | `purchase` | conversion attribuée au push |

### Analyses clés
- Breakdown par `type` : quel **type de notification** convertit (rappel
  d'event, confirmation, promo…).
- Comparer `source = cold_start` vs runtime : un tap cold-start convertit-il
  autant qu'un tap app ouverte ?

### KPIs cibles
- `notification_opened → purchase` par `type`.
- Volume `notification_opened` rapporté à `push_enabled = true` (taux de tap).

---

## 7. 🟡 P2 — Funnel Recherche sauvegardée → retour

**Question business** : sauvegarder une recherche augmente-t-il la rétention ?

Funnel **ouvert**, fenêtre longue (14–30 j) :

| Étape | Event |
|-------|-------|
| 1 | `search_submitted` |
| 2 | `search_saved` (`enable_push = true`) |
| 3 | `notification_opened` (alerte déclenchée plus tard) |
| 4 | `event_viewed` puis `purchase` |

### Analyse clé
Comparer la rétention/conversion des users **avec** au moins un `search_saved`
vs sans. Si les "savers" convertissent nettement mieux, pousser la
sauvegarde dans l'UX devient une priorité produit.

### KPIs cibles
- `search_submitted → search_saved` (taux d'adoption de la sauvegarde).
- Conversion différée des savers (D7/D30).

---

## 8. 🟡 P2 — Funnel Petit Boo → conversion

**Question business** : l'assistant IA produit-il de la valeur (conversions) ou
juste de l'engagement ?

Funnel **ouvert** :

| Étape | Event | Note |
|-------|-------|------|
| 1 | `petitboo_chat_opened` | breakdown `source` (voicefab/history/cold_start) |
| 2 | `petitboo_message_sent` | engagement réel |
| 3 | `petitboo_tool_used` | breakdown `tool_name` (searchEvents, addToFavorites…) |
| 4 | `event_viewed` | l'IA a mené à un event |
| 5 | `begin_checkout` / `purchase` | conversion assistée par l'IA |

### Analyses clés
- **Friction quota** : rapport `petitboo_quota_reached` / `petitboo_message_sent`.
  Un ratio élevé = le quota bride des users engagés → arbitrage produit.
- Quels `tool_name` précèdent une conversion (ex: `searchEvents` → `event_viewed`).

### KPIs cibles
- `petitboo_chat_opened → petitboo_message_sent` (taux d'activation du chat).
- % de sessions Petit Boo suivies d'un `event_viewed` / `purchase`.

---

## 9. 🟡 P2 — Funnel Favoris → Réservation

**Question business** : le favori est-il un signal d'achat différé ?

| Étape | Event |
|-------|-------|
| 1 | `add_to_wishlist` |
| 2 | `event_viewed` (retour sur l'event) |
| 3 | `begin_checkout` |
| 4 | `purchase` |

### Analyse clé
Délai médian `add_to_wishlist → purchase`. S'il est long, déclencher un push de
rappel sur les favoris non convertis (croise avec le funnel notifications).

---

## 10. 🟢 P3 — Funnel Carte → Réservation

| Étape | Event |
|-------|-------|
| 1 | `map_opened` (breakdown `source`) |
| 2 | `map_pin_tapped` |
| 3 | `event_viewed` |
| 4 | `begin_checkout` / `purchase` |

Mesure si la découverte géographique convertit. Utile pour décider d'investir
ou non dans la carte.

---

## 11. 🟢 P3 — Funnel Adhésion organisateur

Funnel **fermé**, court :

| Étape | Event |
|-------|-------|
| 1 | `membership_join_started` |
| 2 | `membership_join_completed` |

Le décrochage entre les deux = échecs API / abandons. Suivre aussi
`membership_invite_accepted` comme conversion isolée.

---

## 12. Funnels impossibles aujourd'hui (gaps à instrumenter)

Funnels à forte valeur **bloqués** par un manque d'instrumentation :

| Funnel souhaité | Event manquant | Effort | Valeur |
|-----------------|----------------|--------|--------|
| Inscription 4 étapes (form → OTP) | `signup_started`, `otp_verified` | Faible | 🟠 Haute |
| Qualité de recherche (recherches sans résultat) | `search_no_results` | Faible | 🟠 Haute |
| Usage des filtres | `search_filter_applied` | Moyen (arbitrage granularité) | 🟡 Moyenne |
| Promotion de contenu (carrousels home) | `select_content` | Moyen | 🟡 Moyenne |

> Ces 4 events sont **déjà déclarés** dans `AnalyticsEvent` mais sans call site.
> `signup_started` + `otp_verified` et `search_no_results` sont les plus
> rentables à câbler en premier.

---

## 13. Synthèse — plan de mise en place recommandé

1. **Débloquer la collecte** (consent gate) — sinon tout le reste est vide.
2. **Créer les Custom Definitions** (§0.2) — sinon pas de segmentation.
3. **Marquer les conversions** (§0.3).
4. **Construire les 2 funnels P0** (Réservation + Découverte→Réservation) — ils
   couvrent 80 % de la valeur décisionnelle.
5. **Ajouter les 3 funnels P1** (Activation, Inscription, Notification).
6. **Instrumenter les gaps rentables** : `signup_started`, `otp_verified`,
   `search_no_results`.
7. **Funnels P2/P3** selon les priorités produit du trimestre.
