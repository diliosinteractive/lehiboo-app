# Spec Mobile — Messages Hibons personnalisés

**Status** : Ready (API en place côté Laravel)
**Audience** : équipe Flutter
**Date** : 2026-05-14

---

## Contexte

L'enveloppe `hibons_update` injectée à la racine de chaque réponse JSON (par le middleware Laravel `AppendHibonsUpdate`) déclare aujourd'hui un `animation_label` générique (`"+20 Hibons"`).

L'API expose désormais **deux nouveaux champs** pour permettre un toast contextualisé selon l'action qui a déclenché la récompense (découverte de catégorie, nouveau favori, réservation, etc.) sans que le mobile ait à dupliquer la logique d'i18n.

---

## Changements API (rétro-compatibles)

### Avant

```json
{
  "hibons_update": {
    "delta": 20,
    "new_balance": 520,
    "new_lifetime": 1270,
    "lifetime_delta": 20,
    "rank_changed": false,
    "new_rank": null,
    "new_rank_label": null,
    "animation_label": "+20 Hibons",
    "pillar": "discovery"
  },
  "data": { ... }
}
```

### Après

```json
{
  "hibons_update": {
    "delta": 20,
    "new_balance": 520,
    "new_lifetime": 1270,
    "lifetime_delta": 20,
    "rank_changed": false,
    "new_rank": null,
    "new_rank_label": null,
    "animation_label": "+20 Hibons",
    "pillar": "discovery",
    "source": "category_explored",
    "reward_message": "Bravo ! Tu viens de gagner 20 Hibons pour la découverte d'une nouvelle catégorie !"
  },
  "data": { ... }
}
```

### Nouveaux champs

| Champ | Type | Nullable | Description |
|---|---|---|---|
| `source` | `string` | oui | Slug de l'action qui a généré la récompense (ex: `category_explored`, `favorite_event_added`, `booking_created`). Permet au mobile de choisir une icône / un son / un tag analytics par action. |
| `reward_message` | `string` | oui | Phrase déjà traduite dans la locale de la requête (header `Accept-Language`), prête à être affichée. Inclut le nombre de Hibons. |

### Quand `reward_message` est `null`

- `delta < 0` (dépense de Hibons — ex: unlock chat Petit Boo).
- `source` inconnu côté backend (`chat_unlock`, `purchase`, `admin`, ou tout futur slug pas encore traduit).
- Locale demandée sans traduction disponible (la chaîne i18n n'existe ni dans la locale demandée ni dans le fallback `en`).
- Pas de transaction associée à la mutation (cas rare : crédit hors `HibonsService`).

Dans tous ces cas, le mobile doit retomber sur `animation_label`.

---

## Règle d'affichage mobile

```dart
final title = envelope.rewardMessage ?? envelope.animationLabel;

// Toast / snackbar / banner :
showHibonsToast(
  title: title,
  variant: envelope.delta > 0 ? ToastVariant.success : ToastVariant.info,
);
```

**Important** : ne PAS concaténer `reward_message` avec `animation_label`. C'est l'un OU l'autre. Le `animation_label` reste utile pour les overlays "+N Hibons" qui animent une particule de score, mais le toast principal doit privilégier `reward_message` quand il est présent.

---

## Catalogue des slugs `source`

| Slug | Pilier | Montant par défaut |
|---|---|---|
| `account_created` | onboarding | 100 |
| `profile_completed` | onboarding | 50 |
| `notifications_opt_in` | onboarding | 30 |
| `daily_login_3min` | engagement | 10 |
| `wheel_spin` | engagement | 15 |
| `category_explored` | discovery | 20 |
| `favorite_event_added` | discovery | 5 |
| `favorite_organizer_added` | discovery | 5 |
| `trip_plan_created` | participation | 20 |
| `slot_reminder_set` | participation | 5 |
| `booking_created` | participation | 50 |
| `event_shared` | community | 10 |
| `review_left` | community | 40 |
| `question_asked` | community | 40 |
| `organizer_contacted` | community | 10 |
| `daily_reward` | (system) | variable |
| `lucky_wheel` | (system) | variable |
| `chat_unlock` | (system) | dépense, pas de `reward_message` |
| `purchase` | (system) | crédit non gamifié, pas de `reward_message` |
| `admin` | (system) | crédit admin, pas de `reward_message` |

Les montants peuvent être surchargés par l'admin via `GamificationConfigService`. Ne jamais hardcoder un montant côté mobile — toujours lire `delta` (qui reflète la valeur réelle créditée).

---

## Locales supportées (backend)

| Locale | Traduction `reward_message` |
|---|---|
| `fr` | ✅ |
| `en` | ✅ |
| `de` | ✅ |
| `nl` | ✅ |
| `es` | ❌ (fallback → `en`) |
| `ar` | ❌ (fallback → `en`) |

Le mobile doit envoyer `Accept-Language` avec sa locale active comme il le fait déjà — l'API gère le fallback proprement (`reward_message` sera dans la meilleure locale disponible, ou `null` si aucune).

---

## Idées d'amélioration UX (optionnel, à discuter)

Maintenant que `source` est exposé, le mobile peut enrichir le toast :

| Source | Icône suggérée | Sound (optionnel) |
|---|---|---|
| `account_created` | 🎉 | welcome.mp3 |
| `category_explored` | 🧭 | discover.mp3 |
| `favorite_event_added` / `favorite_organizer_added` | ❤️ | favorite.mp3 |
| `booking_created` | 🎟️ | ticket.mp3 |
| `review_left` | ⭐ | review.mp3 |
| `wheel_spin` / `lucky_wheel` | 🎡 | wheel.mp3 |
| `daily_login_3min` / `daily_reward` | 📅 | daily.mp3 |
| (autres) | 🪙 | reward.mp3 |

Le pilier (`pillar`) reste aussi disponible pour colorer le toast selon le code couleur déjà utilisé en frontend (onboarding bleu, discovery violet, etc.).

---

## DTO Flutter (exemple)

```dart
class HibonsUpdateEnvelope {
  final int delta;
  final int newBalance;
  final int newLifetime;
  final int lifetimeDelta;
  final bool rankChanged;
  final String? newRank;
  final String? newRankLabel;
  final String animationLabel;
  final String? pillar;
  final String? source;          // ← nouveau
  final String? rewardMessage;   // ← nouveau

  HibonsUpdateEnvelope({
    required this.delta,
    required this.newBalance,
    required this.newLifetime,
    required this.lifetimeDelta,
    required this.rankChanged,
    this.newRank,
    this.newRankLabel,
    required this.animationLabel,
    this.pillar,
    this.source,
    this.rewardMessage,
  });

  factory HibonsUpdateEnvelope.fromJson(Map<String, dynamic> json) {
    return HibonsUpdateEnvelope(
      delta: json['delta'] as int,
      newBalance: json['new_balance'] as int,
      newLifetime: json['new_lifetime'] as int,
      lifetimeDelta: json['lifetime_delta'] as int,
      rankChanged: json['rank_changed'] as bool,
      newRank: json['new_rank'] as String?,
      newRankLabel: json['new_rank_label'] as String?,
      animationLabel: json['animation_label'] as String,
      pillar: json['pillar'] as String?,
      source: json['source'] as String?,
      rewardMessage: json['reward_message'] as String?,
    );
  }
}
```

---

## Vérification

Endpoint de test rapide en local (avec un user token valide) :

```bash
curl -X POST http://api.lehiboo.localhost/api/v1/mobile/categories/<uuid>/explore \
  -H "Authorization: Bearer <token>" \
  -H "Accept-Language: fr" \
  -H "Accept: application/json" | jq '.hibons_update'
```

Réponse attendue : `reward_message` non null avec la phrase française, `source: "category_explored"`.

Tester aussi :
- `Accept-Language: en` → phrase anglaise.
- Une dépense (`POST /api/v1/mobile/chat/unlock`) → `reward_message: null`.

---

## Checklist mobile

- [ ] Ajouter `source` et `reward_message` au DTO `HibonsUpdateEnvelope`.
- [ ] Modifier le toast Hibons : `title = rewardMessage ?? animationLabel`.
- [ ] (Optionnel) Mapper `source` vers une icône / son par action.
- [ ] Vérifier le rendu en `fr` + `en` (+ fallback sur `es` / `ar` qui doit afficher l'anglais ou le label générique).
- [ ] Vérifier qu'une dépense n'affiche pas de phrase personnalisée trompeuse.
- [ ] Smoke test sur les 5 actions les plus courantes : `category_explored`, `favorite_event_added`, `booking_created`, `review_left`, `event_shared`.
