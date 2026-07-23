# Système de Dons — Documentation complète

> Référence exhaustive du système de dons volontaires à la plateforme Le Hiboo,
> couvrant le backend (Laravel), le frontend (Next.js), l'intégration Stripe et
> l'app mobile (Flutter). Base de travail pour l'implémentation des dons sur mobile.

---

## 1. Principe

Un **don** est un **soutien volontaire à la plateforme Le Hiboo**, sans contrepartie.

- ✅ **Facultatif** : n'influence jamais l'accès à un événement ou l'obtention d'un billet.
- ✅ **Sans contrepartie** : aucun avantage, service ou priorité.
- ❌ **Pas de reçu fiscal / réduction d'impôt** : Lehiboo SAS est une société commerciale, pas un organisme d'intérêt général. Ne **jamais** utiliser le mot « don » au sens fiscal.
- ❌ **Non remboursable** par principe (le remboursement reste à la libre appréciation de Lehiboo SAS, techniquement possible côté admin).
- 💳 **Paiement 100 % Stripe** : aucune donnée carte ne transite par Le Hiboo (tokenisation Stripe).
- 🌍 Devise unique : **EUR**. Montant libre entre **1 €** et **1000 €**.

Le don appartient **à la plateforme** (pas au vendor/organisation). Dans les checkouts mixtes (commande + don), la part « don » ne va pas au vendor via Stripe Connect ; elle reste chez la plateforme.

---

## 2. Les 4 sources de don

Un don porte toujours une `source` (colonne `donations.source`) qui identifie son origine :

| Source (constante) | Valeur | Origine | Flux de paiement |
|--------------------|--------|---------|------------------|
| `SOURCE_STANDALONE` | `standalone` | Page web « Soutenir » (don seul) | Stripe **Checkout hébergé** (redirect) |
| `SOURCE_MOBILE_STANDALONE` | `mobile_standalone` | App mobile (don seul) | Stripe **PaymentSheet** (PaymentIntent) |
| `SOURCE_ORDER_CHECKOUT` | `order_checkout` | Ajout d'un don à une commande (panier multi-events) | Inclus dans le PaymentIntent de la commande |
| `SOURCE_BOOKING_DRAFT_CHECKOUT` | `booking_draft_checkout` | Ajout d'un don à une réservation simple | Inclus dans le PaymentIntent du booking draft |

La source est déterminée automatiquement côté API :
- Pour les dons « seuls » : par le nom de route (`v1.mobile.donations.*` → `mobile_standalone`, sinon `standalone`). Voir `DonationController::sourceForRequest()`.
- Pour les dons « intégrés » : fixée par `OrderService` / `BookingDraftService` lors de la création.

---

## 3. Statuts

Cycle de vie d'un don (`donations.status`) — constantes sur `App\Models\Donation` :

| Statut | Constante | Signification |
|--------|-----------|---------------|
| `pending` | `STATUS_PENDING` | Don créé, paiement pas encore confirmé |
| `processing` | `STATUS_PROCESSING` | Paiement en cours (async, ex. certains moyens SEPA) |
| `paid` | `STATUS_PAID` | Payé ✅ (état final normal) |
| `failed` | `STATUS_FAILED` | Échec du paiement |
| `canceled` | `STATUS_CANCELED` | PaymentIntent annulé |
| `refunded` | `STATUS_REFUNDED` | Remboursé intégralement |
| `partially_refunded` | `STATUS_PARTIALLY_REFUNDED` | Remboursé partiellement |
| `disputed` | `STATUS_DISPUTED` | Litige Stripe (chargeback) ouvert |

Transitions clés (méthodes du modèle) :
- `markPaid($paymentIntentId)` — idempotent (no-op si déjà `paid`).
- `markFailed($status = failed|canceled)` — no-op si déjà `paid`/`refunded`.
- `markDisputed($disputeId, $amountCents)` — stocke les infos litige dans `meta`.
- `recordRefund($refundId, $amountCents)` — déduplique par `refund_id`, calcule `refunded`/`partially_refunded`.

---

## 4. Modèle de données

### Table `donations`

Migration : `api/database/migrations/2026_05_20_130000_add_platform_donations.php`

| Colonne | Type | Notes |
|---------|------|-------|
| `id` | bigint PK | interne |
| `uuid` | uuid unique | clé de route publique (`getRouteKeyName`) |
| `source` | string(40) | voir §2, index |
| `order_id` | FK nullable → `orders` | `nullOnDelete` |
| `booking_draft_id` | FK nullable → `booking_drafts` | `nullOnDelete` |
| `booking_id` | FK nullable → `bookings` | `nullOnDelete` |
| `user_id` | FK nullable → `users` | don rattaché au compte si authentifié |
| `email` | string nullable | requis si non authentifié ; sert au reçu Stripe |
| `name` | string nullable | facultatif |
| `amount` | decimal(10,2) | montant du don en EUR |
| `currency` | char(3) | `EUR` |
| `status` | string(40) | voir §3, index |
| `payment_intent_id` | string unique nullable | id Stripe `pi_…` |
| `refund_id` | string nullable | dernier `re_…` |
| `refunded_amount` | decimal(10,2) | cumul remboursé |
| `paid_at` / `failed_at` / `refunded_at` | timestamp nullable | horodatages |
| `meta` | json nullable | contexte (`platform`, `locale`, `app_version`, `source_screen`, `context`) + infos litige |
| `timestamps` | | |

### Colonnes ajoutées ailleurs

Pour les dons intégrés à un paiement, le montant est **aussi** dénormalisé sur la transaction porteuse :
- `orders.donation_amount` decimal(10,2) default 0
- `booking_drafts.donation_amount` decimal(10,2) default 0
- `bookings.donation_amount` decimal(10,2) default 0

### Relations (modèle `Donation`)

`order()`, `bookingDraft()`, `booking()`, `user()` (tous `belongsTo`).
Helpers : `amountCents()`, `refundedAmountCents()`, scope `forPaymentIntent($pi)`.

---

## 5. Endpoints API

### 5.1 Dons « seuls » — Web (`source = standalone`)

Toutes ces routes acceptent un Bearer token **optionnel** (rattache le don au compte).

| Méthode | Route | Throttle | Rôle |
|---------|-------|----------|------|
| `POST` | `/v1/donations` | 10/min | Crée un don + PaymentIntent (flux Elements/PaymentSheet) |
| `POST` | `/v1/donations/checkout` | 10/min | Crée un don + **Stripe Checkout hébergé** (redirect) — utilisé par le web |
| `POST` | `/v1/donations/checkout/confirm` | 30/min | Réconcilie après retour Checkout (`session_id`) |
| `GET` | `/v1/donations/{uuid}` | 30/min | Détail d'un don |
| `POST` | `/v1/donations/{uuid}/payment-intent` | 10/min | (Re)crée le PaymentIntent d'un don existant |
| `POST` | `/v1/donations/{uuid}/confirm-payment` | 30/min | Réconcilie via `payment_intent_id` |

### 5.2 Dons « seuls » — Mobile (`source = mobile_standalone`)

Mêmes contrôleur/logique, source différente (déduite du nom de route).

| Méthode | Route | Throttle |
|---------|-------|----------|
| `POST` | `/v1/mobile/donations` | 10/min |
| `GET` | `/v1/mobile/donations/{uuid}` | 30/min |
| `POST` | `/v1/mobile/donations/{uuid}/payment-intent` | 10/min |
| `POST` | `/v1/mobile/donations/{uuid}/confirm-payment` | 30/min |

> 📱 **Pour mobile** : utiliser `POST /v1/mobile/donations` qui retourne directement le bloc `payment_sheet` prêt pour Stripe PaymentSheet. Pas besoin d'appeler `checkout`.

### 5.3 Admin

Préfixe `/v1/admin/donations` (auth admin) :

| Méthode | Route | Description |
|---------|-------|-------------|
| `GET` | `/v1/admin/donations` | Liste paginée (filtres `status`, `source`, `search`, `date_from`, `date_to`, `per_page`) |
| `GET` | `/v1/admin/donations/stats` | Statistiques (totaux, par source, série mensuelle 12 mois) |
| `GET` | `/v1/admin/donations/{donation}` | Détail (avec order/booking/user chargés) |
| `POST` | `/v1/admin/donations/{donation}/refund` | Rembourse (full/partiel) |
| `GET` | `/v1/admin/users/{user}/donations` | Dons d'un utilisateur donné |

---

## 6. Validation (`StoreDonationRequest`)

`authorize() = true` (endpoint public). Règles :

| Champ | Règle |
|-------|-------|
| `amount` | **requis**, numeric, **min 1**, **max 1000** |
| `currency` | optionnel, `in:EUR,eur` (défaut `EUR`) |
| `email` | optionnel/nullable, email, max 255 — *requis en pratique si non authentifié* (fallback sur `user->email`) |
| `name` | optionnel/nullable, string, max 255 |
| `meta` | optionnel, `array` avec **clés autorisées uniquement** : `context`, `platform`, `locale`, `app_version`, `source_screen` |
| `meta.platform` | `in:web,mobile,ios,android` |
| `meta.locale` | string max 12 |
| `meta.app_version` | string max 40 |
| `meta.source_screen` / `meta.context` | string max 80 |

`prepareForValidation()` accepte des alias d'entrée : `donationAmount` ou `donation_amount` → `amount`, et force `currency = EUR` si absent.

---

## 7. Flux détaillés

### 7.1 Mobile — don seul (PaymentSheet) 📱 *(cible de l'implémentation)*

```
App                          API Laravel                 Stripe
 │  POST /v1/mobile/donations   │                          │
 │  {amount, email?, name?, meta}                          │
 │ ───────────────────────────▶ │                          │
 │                              │ crée Donation (pending)   │
 │                              │ createIntentForDonation() │
 │                              │ ─────────────────────────▶│  PaymentIntent
 │                              │ ◀───────────────────────── │  pi_… + client_secret
 │  201 {data, payment_sheet}   │                          │
 │ ◀─────────────────────────── │                          │
 │                                                          │
 │  Stripe PaymentSheet.init(payment_sheet.*)               │
 │  presentPaymentSheet() ─────────────────────────────────▶│  paiement carte
 │                                                          │
 │        (paiement OK)                                     │
 │                              │ ◀── webhook payment_intent.succeeded
 │                              │ markPaid()                │
 │                                                          │
 │  (option) GET /v1/mobile/donations/{uuid} → status: paid │
```

**Réponse `201` de `POST /v1/mobile/donations`** :

```json
{
  "message": "Donation payment intent created.",
  "data": {
    "uuid": "9b8a7c6d-…",
    "source": "mobile_standalone",
    "amount": 3,
    "currency": "EUR",
    "status": "pending",
    "refunded_amount": 0,
    "paid_at": null,
    "refunded_at": null,
    "created_at": "2026-05-24T10:00:00+00:00"
  },
  "paymentIntent": {
    "clientSecret": "pi_…_secret_…",
    "paymentIntentId": "pi_…",
    "amount": 300,
    "currency": "EUR"
  },
  "payment_intent": {
    "id": "pi_…",
    "payment_intent_id": "pi_…",
    "client_secret": "pi_…_secret_…",
    "amount": 300,
    "currency": "EUR",
    "status": "requires_payment_method"
  },
  "payment_sheet": {
    "payment_intent_id": "pi_…",
    "client_secret": "pi_…_secret_…",
    "customer_id": "cus_…",
    "ephemeral_key": "ek_…",
    "publishable_key": "pk_live_…",
    "merchant_display_name": "Le Hiboo",
    "amount": 300,
    "currency": "EUR"
  }
}
```

**Mapping Flutter Stripe PaymentSheet** (à partir de `payment_sheet`) :

| Paramètre PaymentSheet | Champ réponse |
|------------------------|---------------|
| `paymentIntentClientSecret` | `payment_sheet.client_secret` |
| `merchantDisplayName` | `payment_sheet.merchant_display_name` |
| `customerId` | `payment_sheet.customer_id` (si non null) |
| `customerEphemeralKeySecret` | `payment_sheet.ephemeral_key` (si non null) |
| *(publishable key SDK)* | `payment_sheet.publishable_key` |

> `customer_id` / `ephemeral_key` ne sont présents que si le don est fait **par un utilisateur authentifié** (Bearer token) qui a un `stripe_customer_id`. En anonyme, ils sont `null` → PaymentSheet fonctionne en mode invité.

Après succès PaymentSheet, **attendre le webhook Stripe** pour le statut final. Optionnellement relire via `GET /v1/mobile/donations/{uuid}` (polling léger) ou appeler `confirm-payment` pour forcer la réconciliation immédiate.

### 7.2 Web — don seul (Checkout hébergé)

Le web utilise `POST /v1/donations/checkout` → retourne `checkout_url` (page Stripe hébergée), redirige l'utilisateur, puis au retour appelle `POST /v1/donations/checkout/confirm` avec `session_id`. URLs de retour construites côté API vers `/{locale}/soutenir?redirect_status=…`.

### 7.3 Don intégré à une commande / réservation

Le frontend envoie `donation_amount` dans le payload de création de commande (`StoreOrderRequest`) ou de booking draft. Côté service :
- `OrderService::create()` : `donationCents = min(100000, moneyToCents($data['donation_amount']))`, ajouté au `total_amount`, stocké sur `orders.donation_amount`, et crée une `Donation` liée (`source = order_checkout`, statut `pending`).
- Idem `BookingDraftService` (`source = booking_draft_checkout`).

Le montant du don est **ajouté au PaymentIntent global** avec metadata (`donation_uuid`, `donation_source`, `donation_amount`). Au webhook `payment_intent.succeeded`, le don lié est marqué `paid` en même temps que la commande.

---

## 8. Intégration Stripe (`PaymentService`)

Méthodes dédiées aux dons :

| Méthode | Rôle |
|---------|------|
| `createIntentForDonation(Donation)` | PaymentIntent pour don seul (idempotency `donation:{uuid}:payment_intent`) |
| `createCheckoutSessionForDonation(Donation, success, cancel)` | Session Checkout hébergée (idempotency `donation:{uuid}:checkout_session`) |
| `createEphemeralKeyForCustomer($customerId)` | Ephemeral key pour PaymentSheet |
| `getOrCreateCustomerForDonation(Donation)` | Résout/crée le `stripe_customer_id` (uniquement si `user`) |
| `retrieveVerifiedDonationIntent(Donation, $intentId)` | Vérifie montant/currency/uuid avant réconciliation |
| `retrieveDonationCheckoutSession($sessionId)` | Relit la session Checkout |
| `refundDonation(Donation, $amount, $idempotencyKey, $reason)` | Remboursement |

**Metadata Stripe** systématiquement posée sur PaymentIntent / Session :
`type = platform_donation`, `donation_id`, `donation_uuid`, `donation_source`, `donation_amount`. Le champ `type = platform_donation` permet au webhook d'aiguiller le traitement.

Sécurité : `receipt_email` = email du don ; description `"Soutenir Le Hiboo {uuid}"` ; idempotency keys sur toutes les créations.

---

## 9. Webhook (`PaymentWebhookController`)

Aiguillage par `metadata.type` et par event Stripe :

| Event Stripe | Traitement don |
|--------------|----------------|
| `payment_intent.succeeded` | `handleDonationPaymentSucceeded()` → `markPaid()` |
| `payment_intent.payment_failed` / `canceled` | `markFailed(failed|canceled)` |
| `checkout.session.completed` (type `platform_donation`) | `handleDonationCheckout()` → `markPaid()` + capte l'email client |
| `charge.refunded` | don seul → `recordRefund()` ; don lié à order/booking → `recordDonationRefundShare()` (prorata) |
| `charge.dispute.created` | `markDisputed()` |

**Résolution du don** (`findDonationForStripePayload`) : priorité à `metadata.donation_uuid`, sinon `Donation::forPaymentIntent($pi)`.

**Prorata de remboursement partagé** (`recordDonationRefundShare`) : quand un paiement contient commande + don et qu'un remboursement partiel intervient, la part imputée au don = `refundAmount × (donationCents / paymentAmountCents)`, plafonnée au reliquat remboursable du don.

---

## 10. Admin

### Liste (`GET /v1/admin/donations`)
Filtres : `status`, `source` (`all` = pas de filtre), `search` (uuid/email/name/payment_intent_id/order uuid/booking uuid), `date_from`, `date_to`, `per_page` (10–100, défaut 20). Format standard `data[] + meta`.

### Stats (`GET /v1/admin/donations/stats`)
Retourne : `total_count`, `pending_count`, `paid_count`, `refunded_count`, `failed_count`, `gross_amount`, `paid_amount`, `refunded_amount`, `net_amount`, `by_source[]` (les 4 sources), `timeseries[]` (12 mois glissants, mois vides à zéro). Les montants « gross » incluent paid + refunded + partially_refunded + disputed.

### Remboursement (`POST /v1/admin/donations/{donation}/refund`)
Body : `amount?` (partiel, sinon reliquat total), `reason?`, `mode?` (`full|partial`). Vérifie qu'un `payment_intent_id` existe et qu'il reste du montant remboursable. Idempotency key dérivée de uuid + montants.

`AdminDonationResource` expose en plus : `remaining_amount`, `can_refund`, `stripe_dashboard_url`, et les relations imbriquées (order/booking_draft/booking/user) + `meta`.

Pages frontend admin : `frontend/src/app/(dashboard)/admin/donations/page.tsx` (liste) et `.../donations/stats/page.tsx` (stats). Hooks : `use-admin-donations.ts`. Service : `admin-donations.ts`.

---

## 11. Frontend Web (référence UX à répliquer sur mobile)

| Composant | Fichier | Rôle |
|-----------|---------|------|
| `DonationSelector` | `components/features/checkout/donation-selector.tsx` | Sélecteur montant : presets **1/2/5 €** (2 € = « populaire »), montant custom, max 1000 € |
| `DonationForm` | `app/[locale]/(public)/soutenir/_components/donation-form.tsx` | Formulaire page « Soutenir » (email/nom + Checkout Stripe + confetti succès) |
| `DonationInlineCard` | `components/features/checkout/donation-inline-card.tsx` | Carte don intégrée au checkout |
| `DonationSupportModal` | `components/features/checkout/donation-support-modal.tsx` | Modale de sollicitation (après réservation gratuite) |
| Prompt discrétion | `lib/stores/donation-prompt.ts` | Cookie anti-« nag » : ~45 jours de silence après un rejet de la modale auto |
| Service | `lib/services/donations.ts` | Appels API (`createDonation`, `createDonationCheckout`, `confirmCheckout`, etc.) |

Presets et bornes à respecter côté mobile : **presets 1/2/5 €**, mise en avant de **2 €**, montant libre borné **1 €–1000 €**, devise **EUR**.

Textes i18n existants (namespaces à réutiliser) : `donate`, `public.support.form`, `booking.checkout.donation` — dans `frontend/src/messages/{fr,en,es,de,nl,ar}.json`.

---

## 12. Légal & RGPD

- Doc clauses : `docs/07-legal/clauses-dons.md` (CGU/CGV, confidentialité, rétractation).
- Registre RGPD : traitement **B6 / LB-DON-044**, conservation **10 ans** (Code de commerce L123-22).
- À la suppression de compte : les dons sont **pseudonymisés** (nom/email neutralisés), pas supprimés — voir `AccountDeletionService`.
- Communication : toujours « soutien volontaire sans contrepartie », **jamais** « déductible » / « reçu fiscal ».

---

## 13. Guide d'implémentation Mobile (Flutter)

Checklist pour ajouter les dons dans l'app mobile :

1. **Écran de don** : reprendre l'UX web — presets 1/2/5 € (2 € « populaire »), champ montant libre (1–1000 €), champ email (pré-rempli si connecté), nom facultatif.
2. **Créer le don** : `POST /v1/mobile/donations` avec Bearer token si connecté. Payload :
   ```json
   {
     "amount": 3,
     "currency": "EUR",
     "email": "parent@example.com",
     "name": "Parent Test",
     "meta": { "platform": "ios", "locale": "fr-FR", "app_version": "1.2.3", "source_screen": "support" }
   }
   ```
3. **PaymentSheet** : init depuis le bloc `payment_sheet` (voir mapping §7.1), puis `presentPaymentSheet()`.
4. **Confirmation** : après succès, soit attendre le webhook et faire un `GET /v1/mobile/donations/{uuid}` (polling court), soit appeler `POST /v1/mobile/donations/{uuid}/confirm-payment` avec le `payment_intent_id` pour forcer la réconciliation.
5. **États** : gérer `pending` (paiement en cours), `paid` (succès → écran de remerciement), échecs (`failed`/`canceled`).
6. **Erreurs API** : `422` (montant/email/meta invalide), `429` (rate limit — throttle 10/min sur la création), `503` (Stripe non configuré), `500` (échec création PaymentIntent).
7. **i18n / disclaimer** : afficher la mention « soutien volontaire sans contrepartie, sans reçu fiscal ».

---

## 14. Fichiers clés (récapitulatif)

### Backend
| Fichier | Rôle |
|---------|------|
| `api/app/Models/Donation.php` | Modèle + statuts/sources + transitions |
| `api/app/Http/Controllers/Api/V1/DonationController.php` | Endpoints publics/mobile |
| `api/app/Http/Controllers/Api/V1/Admin/DonationController.php` | Admin (liste, stats, refund) |
| `api/app/Http/Requests/Api/V1/Donation/StoreDonationRequest.php` | Validation |
| `api/app/Http/Resources/DonationResource.php` | Resource publique |
| `api/app/Http/Resources/Admin/AdminDonationResource.php` | Resource admin |
| `api/app/Services/PaymentService.php` | Intégration Stripe (dons) |
| `api/app/Services/OrderService.php` / `BookingDraftService.php` | Dons intégrés au checkout |
| `api/app/Http/Controllers/Api/V1/PaymentWebhookController.php` | Réconciliation webhook |
| `api/database/migrations/2026_05_20_130000_add_platform_donations.php` | Schéma |
| `api/routes/api.php` | Routes (≈ lignes 500–530, 2027–2034, 2146) |

### Frontend
| Fichier | Rôle |
|---------|------|
| `frontend/src/lib/services/donations.ts` | Service API don |
| `frontend/src/lib/services/admin-donations.ts` | Service admin |
| `frontend/src/lib/hooks/use-admin-donations.ts` | Hooks admin |
| `frontend/src/lib/stores/donation-prompt.ts` | Cookie anti-nag |
| `frontend/src/components/features/checkout/donation-*.tsx` | Composants UI |
| `frontend/src/app/[locale]/(public)/soutenir/` | Page « Soutenir » |
| `frontend/src/app/(dashboard)/admin/donations/` | Admin UI |

### Docs
| Fichier | Rôle |
|---------|------|
| `docs/05-reference/DONATIONS_API_MOBILE.md` | Spec API mobile (existante) |
| `docs/07-legal/clauses-dons.md` | Clauses légales |
| `docs/superpowers/specs/2026-05-24-page-soutenir-design.md` | Design page Soutenir |
