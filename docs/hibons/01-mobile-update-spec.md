# Spec mobile — Migration vers le modèle de niveaux v2 (Plan 01)

> Cette spec accompagne l'étape 1 de la refonte Hibons. Côté backend, les changements sont **déployés en mode rétro-compatible** : les anciens champs (`xp`, `level`, `progress_to_next_level`) restent présents dans la réponse mais figés à leurs valeurs au moment du déploiement, et seront supprimés dans une release ultérieure (annoncée séparément).
>
> **Action attendue côté mobile** : consommer les **nouveaux champs**, retirer toute logique XP/niveau, mettre à jour les rangs (5 → 4) et leur affichage. Aucun changement d'authentification ni d'URL.

---

## TL;DR

| Avant | Après |
|---|---|
| 5 rangs : Débutant / Explorateur / Connaisseur / Expert / Maître | 4 rangs : **Curieux / Explorateur / Aventurier / Légende** |
| Rang dérivé d'un niveau (1→50) calculé sur l'XP | Rang dérivé du **cumul lifetime de Hibons gagnés** |
| Une dépense ne change rien (déjà OK) | Une dépense **ne fait jamais rétrograder** (règle figée) |
| Champ `xp`, `level`, `progress_to_next_level` | Champs `lifetime_earned`, `rank`, `next_rank`, `hibons_to_next_rank`, `progress_to_next_rank`, `petit_boo_bonus` |

---

## 1. Contrat API — `GET /api/v1/mobile/hibons/wallet`

### Réponse v2 (champs en gras = nouveaux)

```json
{
  "data": {
    "balance": 250,
    "lifetime_earned": 1430,            // ← NEW
    "rank": "aventurier",                // ← VALEURS CHANGÉES (4 valeurs)
    "rank_label": "Aventurier",          // ← libellé FR (à localiser côté mobile si besoin)
    "rank_icon": "🗺️",                  // ← emoji (peut évoluer)
    "next_rank": "legende",              // ← NEW (null si rang max)
    "next_rank_label": "Légende",        // ← NEW (null si rang max)
    "hibons_to_next_rank": 3570,         // ← NEW (null si rang max)
    "progress_to_next_rank": 28,         // ← NEW (0-100)
    "petit_boo_bonus": 2,                // ← NEW (messages bonus / jour selon le rang)

    "current_streak": 3,
    "max_streak": 12,
    "can_claim_daily": true,
    "can_spin_wheel": false,
    "chat_quota": { /* inchangé */ },
    "daily_rewards": [ /* inchangé */ ],

    // Champs DEPRECATED — figés, retirés dans une release ultérieure
    "xp": 0,
    "level": 1,
    "progress_to_next_level": 0
  }
}
```

### Valeurs possibles pour `rank` (et `next_rank`)

| Valeur | Libellé FR | Seuil `lifetime_earned` |
|---|---|---|
| `curieux` | Curieux | 0 – 399 |
| `explorateur` | Explorateur | 400 – 999 |
| `aventurier` | Aventurier | 1 000 – 4 999 |
| `legende` | Légende | 5 000 + |

⚠️ **`explorateur`** existe dans les deux versions mais correspond à un seuil différent. Ne **pas** mapper l'ancienne enum à la nouvelle — utiliser uniquement la nouvelle.

⚠️ Anciennes valeurs (**ne plus envoyer ni recevoir**) : `debutant`, `connaisseur`, `expert`, `maitre`. Le backend a remappé toute la base existante.

### Contrats inchangés
- `POST /api/v1/mobile/hibons/daily` — la réponse ne doit plus exposer `xp` (le champ XP était inclus côté backend ; il a été retiré). Conserver lecture de `hibons`, `day`, `streak`, `next_rewards`, `new_balance`.
- `POST /api/v1/mobile/hibons/wheel`
- `GET /api/v1/mobile/hibons/transactions`
- `GET /api/v1/mobile/hibons/wheel/config`
- `GET /api/v1/mobile/hibons/packages`
- `POST /api/v1/mobile/hibons/purchase`
- `POST /api/v1/mobile/hibons/purchase/confirm`

---

## 2. Modèle Dart à mettre à jour

```dart
class HibonsWallet {
  final int balance;
  final int lifetimeEarned;            // NEW
  final HibonsRank rank;                // NEW enum (4 valeurs)
  final String rankLabel;
  final String rankIcon;
  final HibonsRank? nextRank;           // NEW
  final String? nextRankLabel;          // NEW
  final int? hibonsToNextRank;          // NEW
  final int progressToNextRank;         // NEW (0..100)
  final int petitBooBonus;              // NEW
  final int currentStreak;
  final int maxStreak;
  final bool canClaimDaily;
  final bool canSpinWheel;
  final ChatQuota chatQuota;
  final List<DailyReward> dailyRewards;

  // À supprimer une fois la transition mobile terminée :
  @Deprecated('Use lifetimeEarned')
  final int? xp;
  @Deprecated('Use rank')
  final int? level;
  @Deprecated('Use progressToNextRank')
  final int? progressToNextLevel;
}

enum HibonsRank {
  curieux('curieux'),
  explorateur('explorateur'),
  aventurier('aventurier'),
  legende('legende');

  final String value;
  const HibonsRank(this.value);

  static HibonsRank fromString(String value) =>
      HibonsRank.values.firstWhere((r) => r.value == value);
}
```

**Parsing JSON** : tolérer `next_rank == null` et `hibons_to_next_rank == null` (cas Légende).

---

## 3. Implications UI

### 3.1 Carte / écran wallet

| Avant | Après |
|---|---|
| Carte « XP : 1430 » | Carte **« Hibons gagnés à vie : 1 430 »** (`lifetime_earned`) |
| Carte « Niveau 14 » | **Supprimer** — le rang est déjà affiché ailleurs |
| Barre « Progression niveau 14 → 15 » | Barre **« Progression vers {next_rank_label} »** utilisant `progress_to_next_rank` |
| Légende « Niveau 15 dans 30 XP » | Légende **« Plus que {hibons_to_next_rank} Hibons avant {next_rank_label} »** |

**Cas rang max (`next_rank == null`)** :
- Masquer la barre de progression OU la mettre à 100 %
- Afficher « Rang maximal atteint » à la place du compteur restant

### 3.2 Badge de rang
- 4 badges au lieu de 5 : redessiner / réafficher les nouvelles icônes
- Les emojis renvoyés par l'API (`rank_icon`) : 🔍 🧭 🗺️ 👑 (placeholder, peut évoluer — l'app peut soit les afficher soit utiliser ses propres assets via `rank`)
- Couleurs / styles à proposer côté design

### 3.3 Onboarding / explication des rangs
Si l'app présente un écran d'explication des paliers, mettre à jour avec les 4 nouveaux paliers et leurs seuils en Hibons cumulés.

---

## 4. Localisation

L'API renvoie `rank_label` et `next_rank_label` **en français uniquement** (l'i18n des libellés est gérée côté backend en FR). Recommandation côté mobile :

- **Soit** afficher directement `rank_label` (FR uniquement → UX dégradée pour les autres langues)
- **Soit** (recommandé) utiliser le champ `rank` (enum stable) comme clé de traduction côté Flutter :

```dart
String _localizedRankLabel(HibonsRank rank, BuildContext context) {
  switch (rank) {
    case HibonsRank.curieux: return AppLocalizations.of(context).rankCurieux;
    case HibonsRank.explorateur: return AppLocalizations.of(context).rankExplorateur;
    case HibonsRank.aventurier: return AppLocalizations.of(context).rankAventurier;
    case HibonsRank.legende: return AppLocalizations.of(context).rankLegende;
  }
}
```

Clés à ajouter dans les fichiers ARB / i18n mobile :
- `rankCurieux`, `rankExplorateur`, `rankAventurier`, `rankLegende`
- `progressToRank` : « Progression vers {rank} »
- `maxRankReached` : « Rang maximal atteint »
- `hibonsToGo` : « Plus que {count} Hibons avant {rank} »
- `lifetimeEarned` : « Hibons gagnés à vie »

---

## 5. Effets de bord à vérifier côté mobile

1. **Cache local du wallet** : si l'app sérialise `HibonsWallet` (Hive, shared_prefs, etc.), invalider l'ancien cache au démarrage de la version v2. Sinon le parsing échouera sur les anciennes valeurs `rank` ('debutant'…) stockées localement.

2. **Notifications push / in-app** : si elles affichent un niveau ou un rang, vérifier qu'elles consomment `rank` (pas `level`).

3. **BRAIN / Petit Boo** : si l'app envoie le rang utilisateur dans un contexte IA, basculer sur la nouvelle enum.

4. **Achievements / popups de promotion** : un événement « tu as monté de rang » doit déclencher la nouvelle séquence (4 paliers, pas 5). Les libellés et seuils diffèrent — ajuster les copies marketing.

5. **Tests d'intégration** : remettre à jour les fixtures qui hardcodent un rang `'debutant'` / `'maitre'` / etc. → utiliser les nouvelles valeurs.

---

## 6. Critères d'acceptation mobile

- [ ] L'écran wallet n'affiche plus jamais « Niveau X » ni un compteur d'XP
- [ ] L'écran wallet affiche `lifetime_earned`, le rang courant (4 valeurs), la progression vers le prochain rang, et le compteur « X Hibons avant {rank} »
- [ ] À Légende, l'app affiche bien « Rang maximal atteint » sans tenter d'afficher un prochain rang
- [ ] Le parsing JSON tolère `next_rank: null`, `next_rank_label: null`, `hibons_to_next_rank: null`
- [ ] Les anciens champs (`xp`, `level`, `progress_to_next_level`) ne sont **plus lus** par le code (uniquement présents dans le DTO marqués `@Deprecated`)
- [ ] L'app gère correctement le `rank` localisé via i18n (4 clés ajoutées)
- [ ] Le cache local est invalidé / migré pour ne pas planter sur les anciennes valeurs
- [ ] Les tests mobiles (unit + widget) sont mis à jour avec les nouvelles enum / fixtures
- [ ] Une release candidate est validée sur un compte de test avec `lifetime_earned >= 5000` (Légende) **et** un compte fraîchement créé (Curieux)

---

## 7. Timeline / coordination

1. **Backend déployé** : API renvoie déjà nouveaux + anciens champs (rétro-compat active).
2. **Mobile (cette spec)** : développement + QA + soumission stores. Pendant cette phase, les versions actuelles d'app continuent de fonctionner grâce aux champs deprecated.
3. **Release mobile v2** disponible sur stores.
4. **Cleanup backend** (PR séparé, **après** un délai d'adoption — typiquement 30 jours) : suppression des champs `xp`, `level`, `progress_to_next_level` de la réponse + suppression des colonnes en BDD via une migration dédiée. **Cette suppression sera annoncée à l'équipe mobile au moins 1 semaine avant.**

⚠️ Tant que la release mobile v2 n'est pas en production majoritaire, **ne pas** retirer les champs deprecated côté backend.

---

## 8. Questions à clarifier avec produit / design

- Confirmer les emojis / icônes finaux des 4 rangs (les emojis en place sont des placeholders).
- Confirmer les valeurs de `petit_boo_bonus` par rang (placeholders : 0/1/2/5 messages bonus quotidiens).
- Définir l'animation de promotion de rang (apparition d'un badge + toast, ou écran plein ?).
- Le compteur « Hibons gagnés à vie » est-il visible sur l'écran principal ou seulement dans un écran détail ?

---

## 9. Référence backend

chemin racine: `\\wsl.localhost\Ubuntu\home\hp\projects\lehiboo_v2`

- Spec produit : [`01-refonte-modele-niveaux.md`](01-refonte-modele-niveaux.md)
- Plan d'implémentation backend / web : [`01-plan-implementation.md`](01-plan-implementation.md)
- Enum Laravel : `api/app/Enums/HibonsRank.php`
- Controller mobile : `api/app/Http/Controllers/Api/V1/Mobile/HibonsController.php`
- Migration : `api/database/migrations/2026_04_30_120000_add_lifetime_earned_to_hibons_wallets.php`
