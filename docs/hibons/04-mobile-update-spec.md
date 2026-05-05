# Spec mobile — Quota Petit Boo v1 & désactivation achats Hibons (Plan 04)

Cette spec liste les changements backend du Plan 04 et les modifications correspondantes à faire côté Flutter.

---

## 1. Changements backend (résumé)

| Sujet | Avant | Après (v1) |
|-------|-------|-----------|
| Quota gratuit / jour | 5 | **3** |
| Coût déblocage chat | 30 H | **100 H** |
| Messages débloqués / achat | 10 | **2** |
| Bonus rang Petit Boo | aucun | Curieux 0 / Explorateur +1 / Aventurier +2 / Légende +5 |
| Achats Hibons mobile (Stripe) | actifs | **désactivés (404)** |

---

## 2. Endpoints affectés

### 2.1 Désactivés — retournent désormais `404`

| Méthode | Endpoint |
|---------|----------|
| `GET` | `/v1/mobile/hibons/packages` |
| `POST` | `/v1/mobile/hibons/purchase` |
| `POST` | `/v1/mobile/hibons/purchase/confirm` |

### 2.2 Inchangés (mais payload enrichi)

| Méthode | Endpoint | Changement |
|---------|----------|-----------|
| `GET` | `/v1/mobile/hibons/wallet` | Le sous-objet `chat_quota` contient de nouveaux champs (cf. §3) |
| `GET` | `/v1/mobile/chat/quota` | Idem (mêmes champs, endpoint dédié) |
| `POST` | `/v1/mobile/chat/unlock` | Coût et messages ajoutés alignés sur la nouvelle config (100 H → 2 msg). Réponse contient désormais `new_limit` calculé sur la limite effective. |

---

## 3. Nouveau payload `chat_quota`

```json
{
  "base_limit": 3,
  "rank_bonus": 1,
  "unlocked_today": 0,
  "limit": 4,
  "used": 1,
  "remaining": 3,
  "resets_at": "2026-05-06T00:00:00+00:00",
  "can_unlock": false,
  "unlock_cost": 100,
  "unlock_messages": 2,
  "rank": "explorateur"
}
```

| Champ | Type | Statut | Description |
|-------|------|--------|-------------|
| `base_limit` | `int` | **NOUVEAU** | Quota gratuit de base (lu depuis settings, défaut 3) |
| `rank_bonus` | `int` | **NOUVEAU** | Bonus messages liés au rang Hibons |
| `unlocked_today` | `int` | **NOUVEAU** | Messages débloqués aujourd'hui via Hibons (resetté chaque nuit) |
| `rank` | `string` | **NOUVEAU** | `curieux \| explorateur \| aventurier \| legende` |
| `limit` | `int` | sémantique enrichie | Limite effective = `base_limit + rank_bonus + unlocked_today` |
| `used` | `int` | inchangé | Messages consommés aujourd'hui |
| `remaining` | `int` | inchangé | `max(0, limit - used)` |
| `resets_at` | `string ISO 8601` | inchangé | Heure du prochain reset |
| `can_unlock` | `bool` | inchangé | True si `balance >= unlock_cost` |
| `unlock_cost` | `int` | valeur changée | 100 (était 30) |
| `unlock_messages` | `int` | valeur changée | 2 (était 10) |

---

## 4. Modifications à faire côté mobile

### 4.1 Suppression / masquage

- Retirer du router et de la navigation : page boutique de packs Hibons, page checkout Stripe Payment Sheet, écran de confirmation d'achat.
- Retirer tout CTA / bouton « Acheter des Hibons » / « + Recharger » présent dans le wallet, l'écran quota épuisé, l'onboarding ou un deep-link.
- Désactiver les deep-links pointant vers la boutique de packs (rediriger vers l'écran wallet).

Le code peut être conservé sous feature flag pour réactivation v2 (le backend conserve aussi son code).

### 4.2 Mise à jour des constantes / valeurs par défaut

- Quota par défaut affiché avant appel API : `3` (au lieu de `5`).
- Coût et nombre de messages d'un déblocage : **lire dynamiquement** `unlock_cost` et `unlock_messages` depuis la réponse `chat_quota`. Ne pas hardcoder 100 / 2.

### 4.3 Modèle Dart — nouveaux champs

Ajouter au modèle `ChatQuota` les champs : `baseLimit`, `rankBonus`, `unlockedToday`, `rank`. Conserver les anciens (`limit`, `used`, `remaining`, `resetsAt`, `canUnlock`, `unlockCost`, `unlockMessages`).

Utiliser des fallbacks `?? <défaut>` au parsing pour rester tolérant à un build serveur non déployé.

### 4.4 Gestion d'erreur 404 sur les routes purchase

Si l'app appelle l'un des 3 endpoints désactivés (build mobile pas à jour, deep-link périmé) :
- Ne pas crasher, ne pas afficher « Erreur serveur ».
- Afficher un message neutre type « Cette fonctionnalité n'est pas disponible ».
- Logger l'événement en analytics pour identifier les builds non migrés.

### 4.5 Gestion du déblocage

L'endpoint `POST /v1/mobile/chat/unlock` est inchangé mais la sémantique change : les 2 messages débloqués **ne persistent plus** dans `daily_messages_limit` — ils sont stockés dans `bonus_messages_unlocked` qui est resetté à minuit. Conséquence : si l'utilisateur débloque puis revient le lendemain, les messages débloqués ont disparu (et il faut re-débloquer  100 H).

Action mobile : après un déblocage, rafraîchir le wallet ET le quota pour refléter la nouvelle valeur de `unlocked_today`.

### 4.6 Hibons rank — exposition

Le rang Hibons est désormais retourné dans `chat_quota.rank` ET sur `GET /v1/mobile/hibons/wallet`. Si tu utilises déjà le wallet pour l'afficher ailleurs, rien à changer. Sinon, lire `rank` depuis le quota suffit pour l'écran Petit Boo.

---

## 5. Compatibilité / non-régression

- Aucun champ existant n'est supprimé du payload `chat_quota`.
- Les nouveaux champs sont rétro-compatibles : un vieux serveur qui n'envoie pas `base_limit / rank_bonus / unlocked_today` doit pouvoir continuer à fonctionner avec les fallbacks par défaut.
- Aucune migration utilisateur côté backend (aucun pack n'a été vendu en prod).

---

## 6. Checklist

- [ ] Boutique de packs supprimée du router
- [ ] Boutons « Acheter des Hibons » retirés (wallet, quota épuisé, onboarding)
- [ ] Modèle `ChatQuota` enrichi avec `baseLimit / rankBonus / unlockedToday / rank`
- [ ] Fallbacks `??` au parsing pour la rétro-compat
- [ ] Coût et messages du déblocage lus dynamiquement (pas hardcodés)
- [ ] Erreur 404 sur les routes purchase gérée proprement
- [ ] Refresh du quota après un déblocage
- [ ] Test manuel : Curieux → `limit = 3`
- [ ] Test manuel : Explorateur → `limit = 4`, `rank_bonus = 1`
- [ ] Test manuel : déblocage 100 H → `unlocked_today = 2`, `limit` augmenté de 2
- [ ] Test manuel : reset à minuit → `unlocked_today = 0`

---

## 7. Référence backend

- Spec backend : `docs/hibons/04-quota-petitboo-et-achats-v1.md`
- Service : `api/app/Services/HibonsService.php` (méthode `getQuota`)
- Modèle : `api/app/Models/HibonsWallet.php` (accessor `effective_daily_limit`)
- Routes : `api/routes/api.php` (purchase wrappées dans `config('features.hibons_purchase_mobile')`)
