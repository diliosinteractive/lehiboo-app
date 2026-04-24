# Rappels Activites (Discovery Reminders) - Guide d'integration Mobile

Ce document sert de reference pour construire la fonctionnalite **Rappels** dans l'application mobile Flutter.

## Vue d'ensemble

Les rappels permettent a un utilisateur de s'abonner a des notifications pour une activite de type **Discovery**. L'utilisateur choisit un ou plusieurs creneaux, et le backend envoie automatiquement :

- un **push FCM** + email a **J-7**
- un **push FCM** + email a **J-1**

```text
Ecran activite Discovery
  -> bouton "Me rappeler" par creneau
  -> toggle ON/OFF

Ecran mes rappels
  -> liste paginee de tous les rappels actifs
  -> swipe-to-delete ou bouton supprimer
```

### Contraintes metier

| Regle | Detail |
|---|---|
| Mode evenement | Seuls les evenements `booking_mode = discovery` acceptent les rappels |
| Statut evenement | L'evenement doit etre `published` et `is_active = true` |
| Granularite | Un rappel = un couple (event, slot). Un event multi-creneaux peut avoir N rappels |
| Idempotence | Appeler `POST` deux fois sur le meme couple (event, slot) retourne le rappel existant (pas de doublon) |
| Notifications | Push FCM (si token enregistre) + email + database. Deux salves : J-7 et J-1 |

---

## Conventions

### Base URL

```text
/api/v1
```

### Auth

Tous les endpoints exigent :

```http
Authorization: Bearer {token}
Accept: application/json
```

### Parametres de route

Les parametres `{event}` et `{slot}` dans les URLs sont des **UUID**.

---

## Endpoints

### 1. Lister mes rappels

```
GET /api/v1/me/reminders
```

Liste paginee de tous les rappels de l'utilisateur connecte, du plus recent au plus ancien.

#### Query params

| Param | Type | Defaut | Description |
|---|---|---|---|
| `per_page` | int | 50 | Nombre par page (min 1, max 200) |
| `page` | int | 1 | Page courante |

#### Reponse `200 OK`

```json
{
  "success": true,
  "data": [
    {
      "id": "a1b2c3d4-...",
      "uuid": "a1b2c3d4-...",
      "created_at": "2026-04-20T10:00:00+00:00",
      "createdAt": "2026-04-20T10:00:00+00:00",
      "notified_7_days_at": null,
      "notified7DaysAt": null,
      "notified_1_day_at": null,
      "notified1DayAt": null,
      "event": {
        "id": "e5f6a7b8-...",
        "uuid": "e5f6a7b8-...",
        "slug": "atelier-poterie-valenciennes",
        "title": "Atelier Poterie",
        "featured_image": "https://cdn.lehiboo.com/events/poterie.jpg",
        "cover_image": "https://cdn.lehiboo.com/events/poterie.jpg",
        "location": {
          "name": "Maison des Arts",
          "address": "12 rue des Ateliers",
          "city": "Valenciennes"
        }
      },
      "slot": {
        "id": "c9d0e1f2-...",
        "uuid": "c9d0e1f2-...",
        "slot_date": "2026-05-01",
        "slotDate": "2026-05-01",
        "start_time": "14:00:00",
        "startTime": "14:00:00",
        "end_time": "16:00:00",
        "endTime": "16:00:00"
      }
    }
  ],
  "meta": {
    "total": 12,
    "page": 1,
    "per_page": 50,
    "last_page": 1
  }
}
```

#### Notes Flutter

- `notified_7_days_at` / `notified_1_day_at` : si non null, le rappel correspondant a deja ete envoye. Utile pour afficher un badge "notifie" dans l'UI.
- Les champs sont exposes en **snake_case** et **camelCase** (dual format). Utiliser la convention de votre choix.

---

### 2. Obtenir les creneaux rappeles pour un evenement

```
GET /api/v1/events/{event}/reminders
```

Retourne la liste des UUID de slots pour lesquels l'utilisateur a un rappel actif sur cet evenement. Utile pour pre-cocher les toggles dans l'ecran de detail.

#### Reponse `200 OK`

```json
{
  "success": true,
  "data": {
    "event_uuid": "e5f6a7b8-...",
    "slot_ids": [
      "c9d0e1f2-...",
      "d0e1f2a3-..."
    ]
  }
}
```

#### Notes Flutter

- `slot_ids` est un tableau de **slot UUID**.
- Si le tableau est vide, l'utilisateur n'a aucun rappel sur cet evenement.
- Appeler cet endpoint au chargement de l'ecran detail d'un evenement Discovery pour initialiser l'etat des toggles.

---

### 3. Creer un rappel

```
POST /api/v1/events/{event}/reminders/{slot}
```

Pas de body requis. Le couple (event, slot) est dans l'URL.

#### Reponse `201 Created` (nouveau rappel)

```json
{
  "success": true,
  "message": "Rappel enregistre.",
  "data": {
    "id": "a1b2c3d4-...",
    "uuid": "a1b2c3d4-...",
    "created_at": "2026-04-23T09:30:00+00:00",
    "createdAt": "2026-04-23T09:30:00+00:00",
    "notified_7_days_at": null,
    "notified7DaysAt": null,
    "notified_1_day_at": null,
    "notified1DayAt": null,
    "event": { "..." : "..." },
    "slot": { "..." : "..." }
  }
}
```

#### Reponse `200 OK` (rappel deja existant)

Meme structure que `201`. Le backend est idempotent : un deuxieme appel retourne le rappel existant sans erreur.

#### Erreurs

| Code | Condition | Body |
|---|---|---|
| `422` | Le slot n'appartient pas a l'evenement | `{"success": false, "message": "Le creneau ne correspond pas a cet evenement."}` |
| `422` | L'evenement n'est pas Discovery, ou inactif, ou non publie | `{"success": false, "message": "Cet evenement n'accepte pas les rappels."}` |
| `401` | Token invalide ou absent | `{"message": "Unauthenticated."}` |

---

### 4. Supprimer un rappel (par slot)

```
DELETE /api/v1/events/{event}/reminders/{slot}
```

Supprime le rappel pour un creneau precis.

#### Reponse `200 OK`

```json
{
  "success": true,
  "message": "Rappel supprime."
}
```

#### Erreurs

| Code | Condition | Body |
|---|---|---|
| `422` | Le slot n'appartient pas a l'evenement | `{"success": false, "message": "Le creneau ne correspond pas a cet evenement."}` |

---

### 5. Supprimer tous les rappels d'un evenement

```
DELETE /api/v1/events/{event}/reminders
```

Supprime tous les rappels de l'utilisateur pour cet evenement (tous creneaux).

#### Reponse `200 OK`

```json
{
  "success": true,
  "message": "Rappels supprimes.",
  "deleted": 3
}
```

---

## Notifications Push (FCM)

Le backend envoie automatiquement des push notifications via FCM aux moments suivants :

| Moment | Condition |
|---|---|
| **J-7** | 7 jours avant le debut du creneau, si `notified_7_days_at` est null |
| **J-1** | 1 jour avant le debut du creneau, si `notified_1_day_at` est null |

Les jobs tournent **toutes les heures** avec une fenetre de 1 heure pour eviter les doublons.

### Payload FCM

```json
{
  "title": "Rappel activite",
  "body": "\"Atelier Poterie\" commence demain.",
  "data": {
    "type": "discovery_reminder",
    "event_uuid": "e5f6a7b8-...",
    "event_slug": "atelier-poterie-valenciennes",
    "action": "/events/atelier-poterie-valenciennes"
  }
}
```

Pour J-7 le body sera : `"\"Atelier Poterie\" commence dans 7 jours."`.

### Deep linking

Le champ `data.action` contient le path relatif vers la fiche evenement. Utiliser ce champ pour naviguer lors du tap sur la notification.

### Notification database (in-app)

En parallele du push, une notification database est creee avec le type `discovery_reminder`. Elle apparait dans l'endpoint `GET /api/v1/notifications` avec cette structure dans `data` :

```json
{
  "type": "discovery_reminder",
  "title": "Rappel activite",
  "message": "\"Atelier Poterie\" commence demain.",
  "action_url": "/events/atelier-poterie-valenciennes",
  "event_uuid": "e5f6a7b8-...",
  "event_slug": "atelier-poterie-valenciennes",
  "event_title": "Atelier Poterie",
  "slot_uuid": "c9d0e1f2-...",
  "slot_date": "2026-05-01",
  "slot_start_time": "14:00:00",
  "days_before": 1,
  "reminded_at": "2026-04-30T10:00:00+00:00"
}
```

---

## Parcours utilisateur recommande

### Ecran detail evenement Discovery

```text
1. GET /api/v1/events/{slug}
   -> Verifier que booking_mode == "discovery"
   -> Si oui, afficher les creneaux avec toggle rappel

2. GET /api/v1/events/{event}/reminders
   -> Recuperer slot_ids pour pre-cocher les toggles

3. Toggle ON  -> POST /api/v1/events/{event}/reminders/{slot}
   Toggle OFF -> DELETE /api/v1/events/{event}/reminders/{slot}
```

### Ecran mes rappels

```text
1. GET /api/v1/me/reminders?per_page=20
   -> Afficher la liste avec event title, image, date du slot

2. Swipe-to-delete ou bouton
   -> DELETE /api/v1/events/{event}/reminders/{slot}
   -> Ou DELETE /api/v1/events/{event}/reminders (tout supprimer pour un event)

3. Tap sur un rappel
   -> Navigation vers /events/{slug}
```

---

## Points d'attention

| Sujet | Detail |
|---|---|
| Mode evenement | Le bouton rappel ne doit apparaitre QUE pour `booking_mode = "discovery"`. Pour les evenements `booking`, le flow est la reservation classique |
| Evenement passe | Si le slot est dans le passe, le backend accepte toujours la creation mais aucune notification ne sera envoyee (la fenetre horaire est depassee). Cote mobile, masquer le toggle pour les creneaux passes |
| Suppression cascade | Si un organisateur supprime un creneau ou desactive un evenement, les rappels restent en base mais les jobs ignorent les events non publies / inactifs |
| Pas de modification | Il n'y a pas d'endpoint PUT/PATCH. Un rappel est soit actif (existe) soit supprime. Pas d'etat intermediaire |
| Rate limiting | Pas de rate limiting specifique sur ces endpoints au-dela du throttle global API |
