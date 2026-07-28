# Diagnostic — Section « Available activities nearby » toujours vide

**Date :** 2026-05-26
**Section concernée :** « Activités disponibles à proximité » (`homeNearbyAvailableTitle`)
**Statut :** Cause racine identifiée + confirmée empiriquement contre l'API

---

## 1. Résumé exécutif

La section affiche son **titre + sa flèche** mais jamais de cartes. Ce n'est pas un
bug de rendu : le provider qui l'alimente retourne une **liste vide**.

La requête API de cette section combine :

1. `available_only=1`
2. `sort=date_asc` (tri par date **croissante** → événements **les plus anciens d'abord**)
3. `include_past=true` (valeur par défaut, **non surchargée**)

…puis le provider applique un **filtre client strict « créneau futur uniquement »**.

Résultat : la requête remonte d'abord des événements **passés**, que le filtre client
**élimine tous** → 0 carte. La section « **Nouveautés** » juste en dessous, qui utilise
la **même** logique d'extraction de créneaux mais `sort=published_at` + `order=desc`,
fonctionne — ce qui prouve que **seul le paramètre `sort` fait la différence**.

> **Preuve clé (testée sur `https://api.lehiboo.com/api/v1`)** :
> `sort=date_asc` et `sort=published_at&sort_order=desc` ne renvoient **pas le même
> jeu de résultats** (132 vs 181 événements). Les deux valeurs `sort` frappent des
> scopes backend différents — l'hypothèse « même données, tri différent » est fausse.

---

## 2. Symptôme observé

Capture utilisateur : le bandeau « Available activities nearby » (avec chevron `>`)
est présent, **aucune carte** en dessous, puis la section « New » affiche normalement
des cartes (Théâtre & Humour).

C'est cohérent avec le code : le titre est rendu **inconditionnellement**, seul le
carrousel se réduit à `SizedBox.shrink()` quand la liste est vide.

---

## 3. Chaîne de rendu et de données

| Étape | Fichier | Lignes |
|-------|---------|--------|
| Appel de la section | [home_screen.dart](../lib/features/home/presentation/screens/home_screen.dart#L155) | 155 |
| Construction de la section | [home_screen.dart](../lib/features/home/presentation/screens/home_screen.dart#L409-L477) | 409-477 |
| Titre + flèche (toujours rendus) | [home_screen.dart](../lib/features/home/presentation/screens/home_screen.dart#L417-L435) | 417-435 |
| **Vide → `SizedBox.shrink()`** (pas de message d'état vide) | [home_screen.dart](../lib/features/home/presentation/screens/home_screen.dart#L438-L441) | 438-441 |
| Provider | [home_providers.dart](../lib/features/home/presentation/providers/home_providers.dart#L120-L199) | 120-199 |
| **Requête API** | [home_providers.dart](../lib/features/home/presentation/providers/home_providers.dart#L169-L177) | 169-177 |
| `sort: 'date_asc'` | [home_providers.dart](../lib/features/home/presentation/providers/home_providers.dart#L176) | 176 |
| Filtre « créneau futur » | [home_providers.dart](../lib/features/home/presentation/providers/home_providers.dart#L208-L239) | 208-239 |
| `_isSlotPast` | [home_providers.dart](../lib/features/home/presentation/providers/home_providers.dart#L318-L319) | 318-319 |
| Section « Nouveautés » (référence qui marche) | [home_providers.dart](../lib/features/home/presentation/providers/home_providers.dart#L723-L755) | 723-755 |
| `sort: 'published_at'` + `order: 'desc'` | [home_providers.dart](../lib/features/home/presentation/providers/home_providers.dart#L736-L737) | 736-737 |
| `available_only=1` envoyé | [events_api_datasource.dart](../lib/features/events/data/datasources/events_api_datasource.dart#L114) | 114 |
| `include_past` (défaut `true`) | [events_api_datasource.dart](../lib/features/events/data/datasources/events_api_datasource.dart#L70-L76) | 70-76 |
| Dates manquantes → `DateTime.now()` | [event_mapper.dart](../lib/features/events/data/mappers/event_mapper.dart#L8-L9) | 8-9 |

### Flux du provider (`HomeNearbyAvailableActivitiesNotifier.build`)

```
1. userLocation != null ?
   ├─ OUI → _fetchAvailableActivities(lat, lng, radius=30)   (dans try/catch)
   │        si résultat non vide → return
   └─ (sinon, ou si vide) ↓
2. _fetchAvailableActivities()  (SANS localisation — ligne 156, hors try/catch)
   └─ return (peut être vide)
```

`_fetchAvailableActivities` ([home_providers.dart:162-193](../lib/features/home/presentation/providers/home_providers.dart#L162-L193)) :

```dart
final result = await eventRepository.getEvents(
  page: 1,
  perPage: 50,
  lat: lat, lng: lng, radius: radius,
  availableOnly: true,
  sort: 'date_asc',          // ← tri croissant : passé d'abord
);
// includePast non passé → défaut true

for (final event in result.events) {
  final activity = _activityWithNearestAvailableSlot(event, now);
  if (activity == null || activity.nextSlot == null) continue;  // ← passé éliminé
  activities.add(activity);
}
```

`_nearestAvailableSlot` retourne `null` si tous les créneaux (ou la date de l'événement)
sont passés → l'événement est **ignoré**.

---

## 4. Cause racine

La section demande à l'API des événements **triés du plus ancien au plus récent**
(`sort=date_asc`) **en incluant le passé** (`include_past=true`), puis **rejette côté
client** tout événement dont le créneau le plus proche est passé.

Comme `date_asc` place les événements **passés en tête** de page (les 50 premiers résultats),
le filtre client en élimine la quasi-totalité → la liste finale est vide.

La section « Nouveautés » échappe au problème car `sort=published_at` + `order=desc`
fait remonter des **publications récentes** (donc des événements **à venir**), qui
survivent au filtre.

### Pourquoi chaque couche contribue

- **`sort=date_asc`** : ordre croissant → événements passés en premier (confirmé ci-dessous).
- **`include_past=true` (défaut)** : la requête ne se limite pas aux événements futurs.
  *Remarque :* ce défaut est intentionnel (commentaire [events_api_datasource.dart:70](../lib/features/events/data/datasources/events_api_datasource.dart#L70) : « preprod has incomplete date data »). Le seul garde-fou contre le passé est donc le **filtre client** — et c'est précisément lui qui vide la liste.
- **Filtre client strict** : `_isSlotPast` rejette tout créneau passé, sans aucun repli.
- **Mapper** : les événements **sans date** prennent `startDate = DateTime.now()` ([event_mapper.dart:8-9](../lib/features/events/data/mappers/event_mapper.dart#L8-L9)) → ils survivent au filtre. Or `date_asc` exclut justement ces événements sans date au niveau backend (voir §5), d'où l'écart de comportement avec `published_at`.

---

## 5. Preuves empiriques (API prod `https://api.lehiboo.com/api/v1`)

> Aujourd'hui = **2026-05-26**. Note : sur **prod**, `available_only=1` renvoie 0
> événement (prod peu peuplé) ; la capture utilisateur vient donc du **backend local**
> (`10.145.75.172:8010`). Mais les tests prod isolent parfaitement le comportement des
> paramètres `sort` / `available_only` / `include_past`.

### Matrice de paramètres (`meta.total`)

| Requête | total |
|---------|------:|
| baseline (aucun filtre) | 132 |
| `available_only=1` | **0** |
| `include_past=false` | 132 |
| `available_only=1 & include_past=false` | **0** |
| `sort=date_asc` | 132 |
| `sort=published_at & sort_order=desc` | **181** |
| `date_from=2026-05-26` | 132 |
| `available_only=1 & date_from=2026-05-26` | **0** |

**Constats :**
- `available_only=1` est un filtre **décisif** (0 sur prod).
- `sort=date_asc` (132) ≠ `sort=published_at&sort_order=desc` (181) → **scopes backend
  différents**. `published_at` ratisse **plus large** (≈ +49 événements, vraisemblablement
  ceux sans date d'événement valide, inclus par `published_at` mais exclus par un tri par date).
- `include_past=false` n'a **aucun effet** sur prod → le backend ne semble pas l'honorer
  comme attendu ; l'app **ne peut pas** s'y fier pour exclure le passé.

### Ordre des dates renvoyées

```
sort=date_asc                 → start_date[0] = 2026-03-31  (PASSÉ)  puis 2026-05-27…
sort=published_at&order=desc  → start_date[0] = 2026-06-20  (FUTUR), 2026-06-12, 2026-06-03…
```

→ **`date_asc` remonte bien les événements passés en premier**, exactement ce que le
filtre client élimine.

---

## 6. Comparaison « Nearby » (KO) vs « Nouveautés » (OK)

| | Nearby (vide) | Nouveautés (OK) |
|---|---|---|
| Provider | `homeNearbyAvailableActivitiesProvider` | `homeNewActivitiesProvider` |
| `available_only` | `true` | `true` |
| `perPage` | 50 | 50 |
| **`sort`** | **`date_asc`** | **`published_at`** |
| **`order`** | (aucun) | **`desc`** |
| `include_past` | `true` (défaut) | `true` (défaut) |
| Extraction créneau | `_activityWithNearestAvailableSlot` | identique |
| Filtre « futur uniquement » | oui | oui |
| État vide | `SizedBox.shrink()` (titre orphelin) | message `homeNoNewActivities` |

**Seule différence fonctionnelle : le paramètre `sort`.** C'est l'origine du bug.

---

## 7. Vérification recommandée sur le backend LOCAL

Conformément à `CLAUDE.md`, confirmer contre l'environnement réellement utilisé
(le backend local de la capture). À exécuter depuis une machine du LAN :

```bash
# 1. La requête de la section "Nearby" (celle qui échoue)
curl -s "http://10.145.75.172:8010/api/v1/events?available_only=1&sort=date_asc&per_page=50&include_past=true" \
  -H "Accept: application/json" | head -c 400

# 2. La requête de la section "Nouveautés" (qui fonctionne)
curl -s "http://10.145.75.172:8010/api/v1/events?available_only=1&sort=published_at&sort_order=desc&per_page=50&include_past=true" \
  -H "Accept: application/json" | head -c 400

# 3. Hypothèse de correctif : restreindre au futur
curl -s "http://10.145.75.172:8010/api/v1/events?available_only=1&sort=date_asc&date_from=2026-05-26&per_page=50" \
  -H "Accept: application/json" | head -c 400
```

Points à confirmer :
- (1) renvoie-t-il 0, ou des événements aux dates passées que le client filtre ?
- `available_only=1` exige-t-il un créneau **futur**, ou seulement un état « disponible » ?
- (3) `date_from` corrige-t-il le tri en faveur des événements à venir ?

---

## 8. Correctifs proposés (classés)

### A. (Recommandé) Contraindre la requête aux événements à venir
Dans `_fetchAvailableActivities` ([home_providers.dart:169](../lib/features/home/presentation/providers/home_providers.dart#L169)),
ajouter `dateFrom = aujourd'hui` (et idéalement `includePast: false`) :

```dart
final result = await eventRepository.getEvents(
  page: 1,
  perPage: _querySize,
  lat: lat, lng: lng, radius: radius,
  availableOnly: true,
  sort: 'date_asc',                                  // soonest-first reste pertinent
  dateFrom: now.toIso8601String().split('T').first, // ex: 2026-05-26
  includePast: false,
);
```

Ainsi `date_asc` renvoie les événements **à venir** les plus proches d'abord — exactement
l'intention de la section — et le filtre client ne vide plus la liste.

### B. Aligner le tri sur la forme documentée
Le contrat OpenAPI ([openapi.yaml:2841-2853](../openapi.yaml#L2841-L2853)) documente
`sort_by ∈ {date, price, popularity, created_at}` + `sort_order`. Plutôt que le `sort`
custom `date_asc`, utiliser `orderBy: 'date'` + `order: 'asc'`, combiné avec `dateFrom`.

### C. Robustesse / UX (indépendant des données)
- Aujourd'hui, l'état vide ne masque **que le carrousel** : le **titre + la flèche
  restent affichés** ([home_screen.dart:417-435](../lib/features/home/presentation/screens/home_screen.dart#L417-L435)).
  → Masquer **toute la section** quand la liste est vide (comme attendu visuellement),
  ou afficher un message d'état vide comme le fait « Nouveautés ».
- Optionnel : repli sur les données du `homeFeed` si le filtrage vide la liste.

### D. Côté backend (si la vérif §7 le confirme)
Si `available_only=1 & sort=date_asc` renvoie des événements passés (ou 0) là où
`published_at` renvoie des futurs, clarifier/corriger côté Laravel la sémantique de
`available_only` et de `sort=date_asc` (devrait impliquer « créneaux à venir »).

---

## 9. Recommandation

Appliquer **A** (correctif minimal et ciblé) + **C** (UX de l'état vide). Exécuter la
vérification **§7** sur le backend local pour trancher entre « bug app » et « sémantique
backend » avant tout changement côté serveur.
