# Spec mobile — Sources de gain Hibons v1 (Plan 02)

> Cette spec accompagne l'étape 2 de la refonte Hibons : **13 nouvelles sources de gain** sont câblées côté backend. La majorité passe par des endpoints **déjà existants** côté mobile (le backend ajoute la récompense de manière transparente) — l'app n'a pas grand-chose à modifier pour les déclencher.
>
> **3 nouveaux endpoints** doivent être appelés explicitement par l'app pour activer ces récompenses (heartbeat session, track-view catégorie, track-share event). Le reste = UI/UX (toasts, écran « comment gagner », états des champs profil).
>
> Compatibilité : aucun champ de réponse existant n'est cassé. L'ajout du champ `pillar` sur les transactions est rétro-compatible (lecture optionnelle).

---

## TL;DR pour l'agent

**À implémenter côté Flutter (par ordre de complexité)** :

1. **Heartbeat session** : 1 timer qui appelle `POST /v1/mobile/hibons/session-heartbeat` une fois passées 3 minutes de session active depuis l'ouverture de l'app (1×/jour).
2. **Track-view catégorie** : appel `POST /v1/categories/{slug}/track-view` à l'ouverture d'une page détail catégorie (pas au scroll de la liste).
3. **Track-share event** : appel `POST /v1/events/{slug}/track-share` au tap du bouton « Partager » (avant ou après le partage natif, peu importe).
4. **Toasts +X Hibons** : afficher un feedback visuel à chaque action récompensée — en lisant `hibons_awarded` dans la réponse OU en repollant le wallet.
5. **Profil 100%** : barre de progression sur l'écran profil basée sur les 5 champs comptés.
6. **Toggle push notifications** : ajouter le champ `push_notifications_enabled` dans le formulaire des préférences.
7. **Écran « Comment gagner des Hibons »** : liste statique des 15 actions v1 avec montants et plafonds (ne PAS exposer les actions v2).

Aucun changement de modèle TypeScript / Dart pour le wallet (toutes les MAJ du wallet ont déjà été spécifiées dans `01-mobile-update-spec.md`).

---

## 1. Nouveaux endpoints à appeler

### 1.1 `POST /v1/mobile/hibons/session-heartbeat`

**Quand l'appeler** : une fois par session, après que l'utilisateur ait été présent au moins **3 minutes** dans l'app après son ouverture/foreground. Ne pas réappeler dans la même journée (le serveur rejette poliment).

**Stratégie Flutter recommandée** :

```dart
Timer? _heartbeatTimer;
DateTime? _sessionStartedAt;
bool _heartbeatSentToday = false;

void onAppForeground() {
  _sessionStartedAt = DateTime.now().toUtc();
  _heartbeatTimer?.cancel();
  if (_heartbeatSentToday) return;
  _heartbeatTimer = Timer(const Duration(minutes: 3), _sendHeartbeat);
}

void onAppBackground() {
  _heartbeatTimer?.cancel();
}

Future<void> _sendHeartbeat() async {
  if (_sessionStartedAt == null) return;
  final response = await api.post(
    '/v1/mobile/hibons/session-heartbeat',
    body: {'session_started_at': _sessionStartedAt!.toIso8601String()},
  );
  if (response.data['awarded'] == true) {
    showHibonsToast(amount: response.data['amount']);
  }
  _heartbeatSentToday = true; // reset à minuit local
}
```

**Body** :
```json
{ "session_started_at": "2026-05-01T14:23:00Z" }
```

**Réponses possibles** :

```json
// Crédité
{ "data": { "awarded": true, "amount": 10, "new_balance": 260, "lifetime_earned": 1440 } }

// Déjà crédité aujourd'hui
{ "data": { "awarded": false, "reason": "already_today", "new_balance": 250 } }

// Session trop courte (< 3 min) — 422
{ "message": "Session must last at least 3 minutes before claiming.",
  "data": { "awarded": false, "reason": "too_short" } }

// Timestamp dans le futur ou trop ancien (> 24h) — 422
{ "message": "session_started_at cannot be in the future." }
```

**Règles** :
- Ne **pas** envoyer un timestamp falsifié (le backend vérifie `now() - session_started_at >= 180s`)
- Tolérer 422 sans crash (UI silencieuse)
- Réinitialiser `_heartbeatSentToday` au passage minuit local

---

### 1.2 `POST /v1/categories/{slug}/track-view`

**Quand l'appeler** : à l'ouverture d'une page détail catégorie (vue qui liste les events de cette catégorie). PAS à chaque scroll, PAS depuis la home si la catégorie n'est qu'un thumbnail.

**Body** : aucun.

**Réponses** :
```json
// 1ère exploration de cette catégorie pour cet user
{ "data": { "awarded": true, "amount": 20 } }

// Catégorie déjà explorée
{ "data": { "awarded": false, "reason": "already_explored" } }

// Daily cap atteint (5 nouvelles catégories/jour max)
{ "data": { "awarded": false, "reason": "daily_cap" } }
```

**UX** : afficher le toast `+20 Hibons` uniquement si `awarded === true`.

---

### 1.3 `POST /v1/events/{slug}/track-share`

**Quand l'appeler** : au tap du bouton Partager, juste avant (ou après — peu importe) l'ouverture du share sheet natif. On fait confiance au tap, on ne peut pas vérifier que l'utilisateur a réellement complété le partage.

**Body** :
```json
{ "channel": "whatsapp" }
```

Valeurs valides pour `channel` : `whatsapp`, `facebook`, `twitter`, `native`, `email`, `link`, `other`. Utiliser `native` pour le share sheet iOS/Android par défaut, `link` pour la copie de lien, `other` en fallback.

**Réponses** :
```json
// Crédité
{ "data": { "awarded": true, "amount": 10, "channel": "whatsapp" } }

// Déjà partagé cet event
{ "data": { "awarded": false, "channel": "whatsapp" } }

// Plafond hebdo (2/sem) atteint
{ "data": { "awarded": false, "channel": "whatsapp" } }
```

> Le serveur logge aussi un `EventView` source `share` pour les analytics — pas d'action mobile requise.

---

## 2. Endpoints existants — effets nouveaux côté serveur

L'app appelle déjà ces endpoints. Aucun changement de payload n'est requis ; le backend ajoute simplement une récompense Hibons. **Cas d'usage côté mobile** : afficher un toast `+X Hibons` après chaque action réussie en repollant le wallet OU en lisant le delta de `balance` / `lifetime_earned`.

| Endpoint | Action côté user | Reward | Anti-farming |
|---|---|---|---|
| `POST /v1/auth/register` | Création compte | **100 H** + (si `newsletter=true` au signup) **30 H** | 1× lifetime |
| `PUT /v1/me/profile` (ou route équivalente) | Modifier le profil pour atteindre 100% | **50 H** | 1× lifetime, ne se redéclenche pas si l'user vide puis remplit à nouveau |
| `PUT /v1/me/profile` | Activer `newsletter` ou `push_notifications_enabled` (off→on) | **30 H** | 1× lifetime ; toggle off/on multiple ne re-crédite pas |
| `POST /v1/me/organizers/{slug}/follow` | Suivre un organisateur | **5 H** | 3/sem, 1× par organisateur lifetime |
| `POST /v1/events/{event}/reminders/{slot}` | Activer un rappel sur un créneau | **5 H** | 5/sem, 1× par slot |
| `POST /v1/events/{slug}/reviews` | Laisser un avis (booking confirmée requise) | **40 H** | 1× par event lifetime |
| `POST /v1/events/{slug}/questions` | Poser une question | **40 H** | 1× par event lifetime |
| `POST /v1/events/{slug}/contact` | Contacter l'organisateur (subject + message ≥ 20 chars combinés) | **10 H** | 1× par event lifetime |
| `POST /v1/favorites/{event}` | Mettre en favori (déjà existant) | **5 H** | 3/sem, 1× par event lifetime |
| Save trip plan via Petit Boo (`saveTripPlan` tool) | Sauvegarder un plan de sortie | **20 H** | 3/sem |
| Booking confirmé | Réservation payée et validée | **50 H** | 1× par booking ; **delayed +10 min** côté serveur (l'app voit le crédit arriver après) |
| `POST /v1/mobile/hibons/daily` | Bonus quotidien (existant) | 10→50 H selon streak | 1×/jour |
| `POST /v1/mobile/hibons/wheel` | Roue de la fortune (existant) | aléatoire 0–100 H | 1×/jour |

**Stratégie de feedback recommandée** : après chaque appel mutation listé ci-dessus, l'app peut soit :
- **(a)** Lire `wallet.balance` avant/après et afficher le delta
- **(b)** Repoll `GET /v1/mobile/hibons/wallet` après chaque action et lire la dernière transaction (`GET /v1/mobile/hibons/transactions?limit=1`)
- **(c)** Optimiste : si l'action réussit ET l'user n'a pas atteint le plafond connu, afficher la récompense

> ⚠️ Dans le scope de la v1, le backend **ne renvoie pas** systématiquement un objet `hibons_update` avec le delta dans la réponse de chaque mutation (ce sera l'objet du plan 05). Pour cette release, l'option **(b) repoll** est la plus simple.

---

## 3. Champs profil — calcul du 100%

Pour la récompense « Profil complété à 100% » (50 H), le serveur considère **5 champs** :

| Champ User | Type | Notes |
|---|---|---|
| `first_name` | string | |
| `last_name` | string | |
| `avatar_url` | string | URL non vide (image uploadée) |
| `birth_date` | date | format `YYYY-MM-DD` |
| `membership_city` | string | |

**`email` et `password` ne comptent pas** (déjà obligatoires à l'inscription).

**UX recommandée** :
- Sur l'écran profil, afficher une barre de progression `N/5 champs complétés`
- Highlight les champs manquants avec un badge « +Z Hibons quand tu rempliras ça »
- Un seul reward au moment où le 5/5 est atteint (la 1ère fois). Si l'user édite un champ après, pas de débit.

---

## 4. Préférences notifications

Le User a maintenant **deux** booleans de préférences :

| Champ | Avant | Après |
|---|---|---|
| `newsletter` | ✅ existait | inchangé |
| `push_notifications_enabled` | ❌ | **NEW** boolean, default false |

**Endpoint de mise à jour** : `PUT /v1/me/profile` (ou la route que l'app utilise déjà pour modifier le profil) accepte désormais :

```json
{
  "newsletter": true,
  "push_notifications_enabled": true
}
```

Toute première bascule `false → true` sur l'**un OU l'autre** des deux champs déclenche la récompense de 30 H (1× à vie, jamais re-créditée).

**UX** :
- Ajouter un toggle « Notifications push » dans l'écran « Notifications » ou « Préférences »
- Si l'user n'a jamais activé ni l'un ni l'autre, afficher un teaser « Active les notifications pour gagner 30 Hibons »

---

## 5. Écran « Comment gagner des Hibons »

L'app doit présenter à l'utilisateur les 15 actions v1 avec leurs montants et plafonds. Liste à utiliser (pour l'instant — le backend exposera plus tard un endpoint catalog dans le plan 05) :

| Action | Hibons | Plafond | Pilier |
|---|---|---|---|
| Créer son compte | 100 | 1× à vie | Onboarding |
| Compléter son profil (5/5) | 50 | 1× à vie | Onboarding |
| Activer notifications | 30 | 1× à vie | Onboarding |
| Connexion + 3 min sur l'app | 10 | 1×/jour | Engagement |
| Roue de la fortune | aléatoire (0-100) | 1×/jour | Engagement |
| Récompense quotidienne (streak) | 10→50 | 1×/jour | Engagement |
| Explorer une nouvelle catégorie | 20 | 1× par catégorie | Découverte |
| Ajouter un événement aux favoris | 5 | 3/sem | Découverte |
| Suivre un organisateur | 5 | 3/sem | Découverte |
| Créer un planning de sortie | 20 | 3/sem | Participation |
| Activer un rappel sur un créneau | 5 | 5/sem | Participation |
| Réserver un événement | 50 | À chaque réservation | Participation |
| Partager un événement | 10 | 2/sem | Communauté |
| Laisser un avis sur un événement | 40 | 1× par événement | Communauté |
| Poser une question sur un événement | 40 | 1× par événement | Communauté |
| Contacter un organisateur | 10 | 1× par événement | Communauté |

⚠️ **Ne PAS inclure** : « Scanner ton billet à l'entrée » (75 H) et « Parrainer un ami » (150 H). Ces actions sont **v2** et ne sont pas implémentées côté backend. Les afficher créerait de fausses promesses.

---

## 6. Pillar — nouveau champ optionnel sur les transactions

Le payload `GET /v1/mobile/hibons/transactions` retourne désormais un champ `pillar` sur chaque transaction :

```json
{
  "uuid": "...",
  "type": "earned",
  "amount": 5,
  "balance_after": 255,
  "source": "favorite_event_added",
  "pillar": "discovery",        // ← NEW (nullable pour transactions très anciennes)
  "description": "Ajout d'un événement aux favoris",
  "meta": { "event_id": 42, "event_uuid": "..." },
  "created_at": "2026-04-30T10:30:00Z"
}
```

Valeurs possibles pour `pillar` : `onboarding`, `engagement`, `discovery`, `participation`, `community`, `system`.

**Optionnel** : l'app peut grouper l'historique par pilier dans l'écran wallet (donut/onglets), avec ces couleurs renvoyées par le backend (à hardcoder côté app pour l'instant) :

| Pillar | Hex |
|---|---|
| onboarding | `#3B82F6` |
| engagement | `#F59E0B` |
| discovery | `#8B5CF6` |
| participation | `#10B981` |
| community | `#EC4899` |
| system | `#6B7280` |

Si `pillar` est null/absent (transactions pre-migration), traiter comme `system` (ne pas l'inclure dans le breakdown engagement).

---

## 7. ⚠️ Source `favorite_added` renommé `favorite_event_added`

Le backend a migré l'ancien `source = 'favorite_added'` vers `'favorite_event_added'` pour aligner sur l'enum `HibonsRewardAction::FavoriteEventAdded`.

**Impact mobile** : si l'app filtre l'historique des transactions par source (ex: pour grouper les rewards par catégorie), elle doit accepter **les deux valeurs** pendant un cycle release :

```dart
const favoriteEventSources = ['favorite_added', 'favorite_event_added'];
```

L'ancienne valeur ne sera plus émise par le backend, mais peut subsister dans le cache local.

---

## 8. Source values exposées par le backend

Pour identifier la source d'une transaction (utile pour des icônes/labels customs côté mobile), voici les valeurs `source` possibles (toutes en snake_case stable) :

| source | Description |
|---|---|
| `account_created` | Création de compte |
| `profile_completed` | Profil 100% |
| `notifications_opt_in` | Activation newsletter ou push |
| `daily_login_3min` | Heartbeat session 3 min |
| `daily_reward` | Récompense quotidienne (streak) |
| `lucky_wheel` | Roue de la fortune |
| `category_explored` | Catégorie explorée |
| `favorite_event_added` | Favori event |
| `favorite_organizer_added` | Favori organisateur |
| `trip_plan_created` | Planning sauvegardé |
| `slot_reminder_set` | Rappel créneau |
| `booking_created` | Réservation |
| `event_shared` | Partage event |
| `review_left` | Avis publié |
| `question_asked` | Question posée |
| `organizer_contacted` | Contact organisateur |
| `chat_unlock` | (dépense) Déblocage chat Petit Boo |
| `purchase` | (rare) Achat de Hibons (désactivé en v1) |
| `admin` | (rare) Crédit/débit manuel admin |

---

## 9. Critères d'acceptation mobile

- [ ] Heartbeat appelé exactement 1× par session, après ≥ 3 minutes en foreground, et au plus 1× par jour
- [ ] Heartbeat ne plante pas en cas de 422 (réponses `too_short`/`already_today`)
- [ ] Track-view appelé à l'ouverture d'un détail catégorie, pas avant
- [ ] Track-share appelé au tap du bouton Partager (avec un `channel` valide)
- [ ] Toasts `+X Hibons` affichés après chaque action récompensée
- [ ] L'écran profil affiche la progression `N/5 champs` et l'incentive « +50 Hibons » sur les champs manquants
- [ ] Le toggle `push_notifications_enabled` est exposé dans l'écran préférences
- [ ] L'écran « Comment gagner des Hibons » liste les **15 actions v1 uniquement** (pas de check-in QR, pas de parrainage)
- [ ] Le filtrage de l'historique des transactions accepte `favorite_added` ET `favorite_event_added` (transition)
- [ ] L'app n'exige PAS la présence du champ `pillar` (peut être null pour les vieilles transactions)

---

## 10. Tests à prévoir côté mobile

### Tests unitaires
- Timer heartbeat : déclenché à 3 min, pas avant ; annulé en background ; réinitialisé en foreground
- Calcul profil 100% : 5 champs requis, ordre indifférent
- Mapping `source → label/icône/couleur` : exhaustif sur les 16 sources

### Tests d'intégration (mock API)
- Heartbeat à T+3min01 → 200 ; à T+2min59 → 422 silencieux
- Track-view nouvelle catégorie → toast 20 H ; même catégorie → pas de toast
- Track-share whatsapp → toast 10 H ; même event re-partagé → pas de toast

### Tests UI (widget tests)
- Toast +X Hibons s'affiche puis se masque après 2s
- Barre de progression profil 0/5, 3/5, 5/5
- Catalog actions : 15 entrées exactement, aucun « QR » ni « parrainage »

---

## 11. Hors scope (à venir dans des releases ultérieures)

- **Plan 05 — UX mobile** : middleware backend `AppendHibonsUpdate` qui injecte `hibons_update` dans CHAQUE réponse mutation → permettra de retirer le repoll et de connaître `delta`/`new_rank` directement. Endpoint léger `GET /v1/mobile/hibons/balance` avec cache 30s. Endpoint `GET /v1/mobile/hibons/actions-catalog` qui rend obsolète la liste hardcodée de l'écran « Comment gagner ».
- **v2** : Scanner QR check-in (75 H) et Parrainage (150 H). Implémentés plus tard, hors de cette release.
- **Bonus rang Petit Boo** : Curieux/Explorateur/Aventurier/Légende auront des quotas chat différents (Plan 04).

---

## 12. Référence backend

- Spec produit : [`02-sources-de-gain-manquantes.md`](02-sources-de-gain-manquantes.md)
- Plan d'implémentation backend : [`02-plan-implementation.md`](02-plan-implementation.md)
- Enums : `api/app/Enums/HibonsRewardAction.php`, `api/app/Enums/HibonsPillar.php`
- Service : `api/app/Services/HibonsRewardService.php`
- Endpoints : `api/routes/api.php` (chercher `track-view`, `track-share`, `session-heartbeat`)
