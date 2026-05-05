# Spec mobile — Compteur permanent, animations & profil détaillé (Plan 05)

Cette spec liste les changements backend du Plan 05 et les modifications correspondantes à faire côté Flutter.

---

## 1. Changements backend (résumé)

| Sujet | Avant | Après |
|-------|-------|-------|
| Récupération du delta après une action récompensée | Repoll de `/v1/mobile/hibons/wallet` ou `/transactions?limit=1` | **Enveloppe `hibons_update` injectée à la racine** de la réponse de toute mutation Hibons-modifying |
| Compteur header / pull-to-refresh | Charger tout `/wallet` (~1.5 KB, calcul rang/quota) | **Nouveau endpoint léger `/balance`** avec cache Redis 30 s |
| Historique des transactions | Champs basiques (uuid, type, amount, source, description) | **Champs enrichis** : `pillar`, `pillar_label`, `pillar_color`, `title` (i18n), `subtitle` (titre event/org), `context` (event/org/booking) |
| Breakdown gains par pilier | Calcul côté mobile | **Fourni dans `meta.earnings_by_pillar`** par le backend |
| Catalogue des actions disponibles | Liste statique hardcodée côté mobile | **Nouveau endpoint `/actions-catalog`** avec montants live + caps restants |
| `rank_label` et autres labels | FR uniquement | **6 langues** (fr, en, es, de, nl, ar) — utilisez `X-Locale` ou `Accept-Language` |

---

## 2. Endpoints affectés

### 2.1 Nouveaux endpoints

| Méthode | Endpoint | Cache | Description |
|---------|----------|-------|-------------|
| `GET` | `/v1/mobile/hibons/balance` | Redis 30 s | Compteur léger pour header / pull-to-refresh |
| `GET` | `/v1/mobile/hibons/actions-catalog` | aucun | Liste des 15 actions v1 avec montants + caps utilisateur |

### 2.2 Modifiés (payload enrichi, rétro-compatible)

| Méthode | Endpoint | Changement |
|---------|----------|-----------|
| `GET` | `/v1/mobile/hibons/transactions` | Champs enrichis (`pillar_label`, `pillar_color`, `title`, `subtitle`, `context`) + `meta.earnings_by_pillar` + `meta.lifetime_earned` + filtre `?pillar=` |

### 2.3 Mutations qui retournent désormais l'enveloppe `hibons_update`

L'enveloppe est ajoutée **au niveau racine** de la réponse JSON, **à côté** de `data` (pas dedans). Les routes concernées :

| Méthode | Endpoint | Action récompensée |
|---------|----------|-------------------|
| `POST` | `/v1/favorites/{event}` | FavoriteEventAdded (5 H) |
| `POST` | `/v1/me/favorites` (alias) | FavoriteEventAdded |
| `POST` | `/v1/me/favorites/{event}/toggle` | FavoriteEventAdded |
| `POST` | `/v1/me/organizers/{slug}/follow` | FavoriteOrganizerAdded (5 H) |
| `POST` | `/v1/events/{event}/reminders/{slot}` | SlotReminderSet (5 H) |
| `POST` | `/v1/events/{slug}/reviews` | ReviewLeft (40 H) |
| `POST` | `/v1/events/{slug}/questions` | QuestionAsked (40 H) |
| `POST` | `/v1/events/{slug}/contact` | OrganizerContacted (10 H) |
| `POST` | `/v1/events/{slug}/track-share` | EventShared (10 H) |
| `POST` | `/v1/categories/{slug}/track-view` | CategoryExplored (20 H) |
| `POST` | `/v1/mobile/hibons/daily` | Daily reward |
| `POST` | `/v1/mobile/hibons/wheel` | Wheel prize |
| `POST` | `/v1/mobile/hibons/session-heartbeat` | DailyLogin3Min (10 H) |
| `PUT\|PATCH` | `/v1/account/profile` | ProfileCompleted (50 H) / NotificationsOptIn (30 H) |

⚠️ **Pas d'enveloppe** sur la confirmation de booking (Stripe webhook) : le crédit booking (50 H) est délibérément différé +10 min côté serveur. Toast à déclencher côté mobile via push notification ou polling notifications.

---

## 3. Format de l'enveloppe `hibons_update`

### Position dans la réponse

```json
{
  "success": true,
  "data": { /* payload métier intact, jamais modifié */ },
  "hibons_update": {
    "delta": 5,
    "new_balance": 255,
    "new_lifetime": 1435,
    "lifetime_delta": 5,
    "rank_changed": false,
    "new_rank": null,
    "new_rank_label": null,
    "animation_label": "+5 Hibons",
    "pillar": "discovery"
  }
}
```

### Champs

| Champ | Type | Description |
|-------|------|-------------|
| `delta` | `int` | Variation de balance (positif si crédit, négatif si débit) |
| `new_balance` | `int` | Solde après l'opération |
| `new_lifetime` | `int` | Lifetime cumulé après l'opération |
| `lifetime_delta` | `int` | Variation de lifetime (= `delta` si crédit Earned/Bonus, 0 si Refund/Spent) |
| `rank_changed` | `bool` | `true` uniquement si l'utilisateur a franchi un palier de rang **et** avait déjà un wallet avant la requête |
| `new_rank` | `string\|null` | Valeur enum du nouveau rang si `rank_changed`, sinon `null` |
| `new_rank_label` | `string\|null` | Label localisé du nouveau rang si `rank_changed`, sinon `null` |
| `animation_label` | `string` | Texte prêt à afficher dans le toast (ex : `"+5 Hibons"` ou `"-100 Hibons"`) |
| `pillar` | `string\|null` | Pilier de la transaction (`onboarding`, `engagement`, `discovery`, `participation`, `community`, `system`) — `null` si la mutation n'a pas créé de transaction |

### Règles d'affichage côté mobile

- **`hibons_update` absent** = la requête n'a pas modifié le wallet (cap atteint, route non couverte). Ne rien afficher.
- **`hibons_update.delta === 0`** = balance inchangée mais wallet touché (cas rare, ignorer).
- **`hibons_update.delta > 0`** = afficher le toast `+XX Hibons` avec animation depuis le badge header.
- **`hibons_update.delta < 0`** = afficher un feedback discret (déduction, pas de confettis).
- **`hibons_update.rank_changed === true`** = en plus du toast, afficher l'overlay « Bravo, tu es maintenant {new_rank_label} ! ».

---

## 4. `GET /v1/mobile/hibons/balance`

### Réponse

```json
{
  "data": {
    "balance": 255,
    "lifetime_earned": 1435,
    "rank": "aventurier",
    "rank_label": "Aventurier",
    "rank_icon": "🗺️"
  }
}
```

### Quand l'appeler

- **Au démarrage de l'app** (cold start) pour afficher le badge header avant que `/wallet` arrive.
- **Sur pull-to-refresh** d'un écran qui montre le badge.
- **PAS après chaque mutation** (le middleware backend le fait via `hibons_update`).

### Cache et invalidation

- Backend : Redis 30 s, invalidé automatiquement à chaque crédit/débit (observer sur transaction created).
- Côté mobile : OK de cache local 30 s aussi, mais **toujours mettre à jour depuis `hibons_update`** quand celui-ci arrive (priorité).

### Note locale

Le `rank_label` est résolu **après** la lecture du cache côté backend, donc respecte la locale de la requête. Envoyer `X-Locale: fr` ou `Accept-Language: fr-FR` pour avoir « Curieux » au lieu de « Curious ».

---

## 5. `GET /v1/mobile/hibons/transactions` — payload enrichi

### Nouveaux champs par transaction

```json
{
  "data": [
    {
      "uuid": "01h...",
      "type": "earned",
      "type_label": "Gagné",
      "amount": 5,
      "formatted_amount": "+5",
      "balance_after": 255,
      "source": "favorite_event_added",
      "pillar": "discovery",                     // existant (Plan 02)
      "pillar_label": "Découverte",              // NEW (i18n)
      "pillar_color": "#8B5CF6",                 // NEW (hex)
      "title": "Événement ajouté en favori",     // NEW (titre principal i18n)
      "subtitle": "Concert de jazz au Sunset",   // NEW (titre du contexte si event/org)
      "context": {                               // NEW (nullable)
        "type": "event",
        "uuid": "evt-xxx",
        "slug": "concert-jazz-sunset",
        "title": "Concert de jazz au Sunset",
        "image_url": "https://..."
      },
      "description": "Ajout d'un événement aux favoris",
      "created_at": "2026-04-30T10:30:00Z"
    }
  ],
  "meta": {
    "current_balance": 255,
    "lifetime_earned": 1435,                     // NEW
    "earnings_by_pillar": [                      // NEW
      { "pillar": "onboarding",    "label": "Onboarding",    "color": "#3B82F6", "amount": 180 },
      { "pillar": "engagement",    "label": "Engagement",    "color": "#F59E0B", "amount": 450 },
      { "pillar": "discovery",     "label": "Découverte",    "color": "#8B5CF6", "amount": 305 },
      { "pillar": "participation", "label": "Participation", "color": "#10B981", "amount": 350 },
      { "pillar": "community",     "label": "Communauté",    "color": "#EC4899", "amount": 150 },
      { "pillar": "system",        "label": "Système",       "color": "#6B7280", "amount": 0 }
    ]
  }
}
```

### Champ `context`

Forme variable selon `meta` de la transaction. Toujours nullable.

| Type contexte | Champs |
|---|---|
| `event` | `type`, `uuid`, `slug`, `title`, `image_url` |
| `organization` | `type`, `uuid`, `slug`, `title`, `image_url` |
| `booking` | `type`, `uuid`, `reference` |
| absent | `null` (transactions sans meta linkable, ex: `daily_reward`, `lucky_wheel`) |

### Nouveau filtre

`GET /v1/mobile/hibons/transactions?pillar=discovery` — filtre par pilier (valeurs : `onboarding`, `engagement`, `discovery`, `participation`, `community`, `system`).

### `meta.earnings_by_pillar`

- Toujours **6 entrées** (les 6 piliers, dans cet ordre fixe).
- `amount` est le cumul lifetime de transactions `Earned` + `Bonus` (positives uniquement) sur ce pilier.
- Cache backend 60 s, invalidé sur chaque transaction.
- Le pilier `system` est inclus mais sera typiquement à 0 ou non significatif (achats, admin) — l'app peut l'exclure du donut.

---

## 6. `GET /v1/mobile/hibons/actions-catalog`

### Réponse

```json
{
  "data": [
    {
      "action": "favorite_event_added",
      "title": "Ajouter un événement en favori",
      "description": "Découvre des événements et ajoute-les à tes favoris",
      "amount": 5,
      "pillar": "discovery",
      "pillar_label": "Découverte",
      "pillar_color": "#8B5CF6",
      "icon": "heart",
      "cap_text": "Max 3 par semaine",
      "completed_this_week": 1,
      "remaining_this_week": 2,
      "reachable": true
    },
    {
      "action": "account_created",
      "title": "Créer son compte",
      "description": "Bienvenue ! Crée ton compte et reçois tes premiers Hibons.",
      "amount": 100,
      "pillar": "onboarding",
      "pillar_label": "Bienvenue",
      "pillar_color": "#3B82F6",
      "icon": "user-plus",
      "cap_text": "1× à vie",
      "completed_lifetime": 1,
      "remaining_lifetime": 0,
      "reachable": false
    }
  ]
}
```

### Champs présents selon le scope du cap

| Scope du cap | Champs additionnels |
|---|---|
| `lifetime` | `completed_lifetime`, `remaining_lifetime` |
| `lifetime_per_context` | `completed_lifetime` |
| `daily` | `completed_today`, `remaining_today` |
| `weekly` ou `weekly_per_context` | `completed_this_week`, `remaining_this_week` |
| `none` | aucun (toujours `reachable: true`) |

### Champs constants

| Champ | Type | Description |
|-------|------|-------------|
| `action` | `string` | Slug stable (= valeur source de la transaction) |
| `title` | `string` | Titre court i18n |
| `description` | `string` | Description longue i18n |
| `amount` | `int` | Montant en Hibons (lu depuis `gamification_settings`, peut être ajusté par admin) |
| `pillar` / `pillar_label` / `pillar_color` | | Pour grouper visuellement |
| `icon` | `string` | Slug Lucide (`heart`, `ticket`, `user-plus`, etc.) |
| `cap_text` | `string` | Texte humain prêt à afficher (« Max 3 par semaine », « 1× à vie », etc.) |
| `reachable` | `bool` | `false` si le cap est atteint (UX : griser l'entrée) |

### Liste exhaustive (15 actions v1)

`account_created`, `profile_completed`, `notifications_opt_in`, `daily_login_3min`, `wheel_spin`, `category_explored`, `favorite_event_added`, `favorite_organizer_added`, `trip_plan_created`, `slot_reminder_set`, `booking_created`, `event_shared`, `review_left`, `question_asked`, `organizer_contacted`.

⚠️ **`ticket_checked_in` (75 H) et `referral_validated` (150 H) ne sont PAS exposés** — actions v2 non implémentées. Ne pas les ajouter à la main côté mobile.

### Quand l'appeler

- À l'ouverture de l'écran « Comment gagner des Hibons ? » / « Mes objectifs ».
- Après avoir effectué une action, pour rafraîchir les compteurs `completed_…` (optionnel : peut aussi être calculé localement à partir des `hibons_update`).

→ **Remplace** la liste statique recommandée dans `02-mobile-update-spec.md` §5. La liste hardcodée peut être supprimée.

---

## 7. i18n — fichiers backend

Le backend dispose désormais des traductions pour 6 langues : `fr`, `en`, `es`, `de`, `nl`, `ar`.

### Clés exposées dans les réponses

- `hibons.ranks.{value}` → utilisé par `rank_label`, `next_rank_label`, `new_rank_label`
- `hibons.pillars.{value}` → utilisé par `pillar_label`
- `hibons.sources.{value}` → utilisé par `title` des transactions (fallback sur `defaultDescription` PHP)
- `hibons.actions.{action}.{title,description,icon,cap_text}` → utilisé par `/actions-catalog`

### Comment piloter la locale depuis l'app

L'app envoie déjà l'un de ces headers (selon ce qui est en place) :
- `X-Locale: fr` (recommandé, prioritaire)
- `Accept-Language: fr-FR` (fallback standard)

Pas de nouveau paramètre à câbler — les nouveaux endpoints respectent automatiquement la locale envoyée.

### Si vous gardez vos traductions Flutter

L'app peut continuer d'utiliser ses propres `.arb` pour les libellés UX (boutons, écrans, etc.). Les seuls champs **localisés côté serveur** sont ceux listés ci-dessus, et l'app peut les afficher tels quels.

---

## 8. Modifications à faire côté mobile

### 8.1 Service global Hibons

- Ajouter un intercepteur HTTP qui lit `response.data['hibons_update']` après **toute** réponse JSON et appelle un `HibonsService.applyUpdate(...)`.
- `HibonsService` met à jour le state global (Provider/Riverpod/Bloc) : `balance`, `lifetimeEarned`, `rank`.
- Si `delta != 0` → déclencher l'animation toast.
- Si `rank_changed` → déclencher l'overlay rank-up.

### 8.2 Modèle Dart `HibonsTransaction` enrichi

Ajouter les champs : `pillar`, `pillarLabel`, `pillarColor`, `title`, `subtitle`, `context` (typé `HibonsTransactionContext?`).

```dart
class HibonsTransactionContext {
  final String type;        // event | organization | booking
  final String uuid;
  final String? slug;
  final String? title;
  final String? imageUrl;
  final String? reference;  // bookings only
}
```

Tous nullable au parsing pour rétro-compat.

### 8.3 Modèle Dart `HibonsActionsCatalogEntry` (nouveau)

```dart
class HibonsActionsCatalogEntry {
  final String action;
  final String title;
  final String description;
  final int amount;
  final String pillar;
  final String pillarLabel;
  final String pillarColor;
  final String icon;
  final String capText;
  final bool reachable;
  // optional cap counters (selon scope)
  final int? completedThisWeek;
  final int? remainingThisWeek;
  final int? completedToday;
  final int? remainingToday;
  final int? completedLifetime;
  final int? remainingLifetime;
}
```

### 8.4 Suppressions / nettoyage

- **Supprimer** la liste hardcodée des 15 actions v1 (ex : dans l'écran « Comment gagner des Hibons »).
  → Remplacer par un appel à `/actions-catalog`.
- **Supprimer** le repoll systématique de `/wallet` après chaque mutation (favoris, follow, reviews, etc.).
  → Le `hibons_update` injecté suffit.
- **Conserver** `/wallet` pour l'écran wallet complet (rang, streak, daily rewards preview, chat_quota détaillé).

### 8.5 Page profil — utiliser le breakdown serveur

L'app peut afficher le donut « répartition par pilier » directement avec `meta.earnings_by_pillar` retourné par `/transactions` (plus besoin de calculer côté client).

### 8.6 Catalogue actions sur l'écran « Comment gagner »

Remplacer le rendu statique par un appel à `/actions-catalog`. Pour chaque entrée :
- Si `reachable === false` → griser + afficher « Atteint »
- Sinon afficher `cap_text` + `completed_… / remaining_…` selon ce qui est présent

---

## 9. Compatibilité / non-régression

- Aucun champ existant n'est supprimé.
- Les nouveaux champs sur `/transactions` sont additifs : un parser tolérant aux nouvelles clés continue de fonctionner.
- L'enveloppe `hibons_update` est **absente** quand pas de mutation Hibons (les builds qui ne la lisent pas restent OK).
- Les anciens endpoints `/wallet`, `/transactions` (sans les nouveaux champs s'ils sont ignorés), `/daily`, `/wheel`, `/session-heartbeat`, `/wheel/config` sont **inchangés en comportement**.

---

## 10. Checklist mobile

- [ ] Intercepteur HTTP qui lit `hibons_update` à la racine de toute réponse
- [ ] `HibonsService.applyUpdate(...)` met à jour le state et déclenche les animations
- [ ] Toast `+XX Hibons` (2 s) déclenché sur `delta > 0`
- [ ] Overlay rank-up déclenché sur `rank_changed === true`
- [ ] Modèle `HibonsTransaction` enrichi avec `pillar_label`, `pillar_color`, `title`, `subtitle`, `context`
- [ ] Donut profil consomme `meta.earnings_by_pillar` au lieu de calculer côté client
- [ ] Filtre `?pillar=` câblé sur l'historique des transactions
- [ ] Endpoint `/balance` consommé au démarrage / pull-to-refresh
- [ ] Endpoint `/actions-catalog` consommé sur l'écran « Comment gagner »
- [ ] Liste statique des actions v1 supprimée du code mobile
- [ ] Repoll systématique de `/wallet` après mutation supprimé
- [ ] Tests : favori → toast +5 Hibons s'affiche, badge incrémenté, pas d'appel `/wallet`
- [ ] Tests : franchissement du seuil 1 000 Hibons → overlay « Aventurier »
- [ ] Tests : `/balance` au démarrage est cohérent avec `/wallet` complet

---

## 11. Hors scope (ne PAS faire dans cette release)

- Ne pas câbler les actions v2 (`ticket_checked_in`, `referral_validated`) — pas exposées par le backend.
- Ne pas afficher de toast Hibons sur la confirmation de booking côté webhook Stripe — le crédit est différé +10 min côté serveur. Compter sur la push notification ou le repoll des notifications.
- Pas de Sentry / analytics côté mobile pour les nouvelles actions — release séparée.

---

## 12. Référence backend

- Spec produit : [`05-ux-mobile-compteur-animations.md`](05-ux-mobile-compteur-animations.md)
- Middleware : `api/app/Http/Middleware/AppendHibonsUpdate.php`
- Resource transactions : `api/app/Http/Resources/HibonTransactionResource.php`
- Observer cache : `api/app/Observers/HibonTransactionObserver.php`
- Routes : `api/routes/api.php` (chercher `balance`, `actions-catalog`, `hibons.update`)
- i18n : `api/lang/{fr,en,es,de,nl,ar}/hibons.php`
- Tests Feature : `api/tests/Feature/Hibons/` (4 nouveaux fichiers, 22 tests verts)
