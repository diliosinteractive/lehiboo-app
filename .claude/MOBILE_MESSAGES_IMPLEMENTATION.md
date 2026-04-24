# Messages Mobile — Implementation Spec

Ce document decrit comment implementer la fonctionnalite Messages dans l'app mobile Flutter, en miroir de l'implementation web. Il couvre l'architecture ecrans, les patterns UX, le temps reel, et les points d'attention.

Pour le contrat API (endpoints, payloads, erreurs), voir `MOBILE_MESSAGES_API.md`.

## Scope

**V1 (ce document)** : role `user` (participant) uniquement.

| Fonctionnalite | Inclus |
|---|---|
| Conversations user ↔ organisateur | Oui |
| Conversations user ↔ support LeHiboo | Oui |
| Signalement de conversation | Oui |
| Pieces jointes (images, PDF) | Oui |
| Edition / suppression de messages | Oui |
| Indicateurs de lecture et livraison | Oui |
| Temps reel (WebSocket ou polling) | Oui |
| Push FCM pour nouveaux messages | Non (gap backend, voir section dediee) |
| Conversations vendor (vendor_admin, org_org) | Non (v2) |
| Broadcasts | Non (v2) |

---

## Architecture ecrans

```text
┌─────────────────────────────────────────────────────────────┐
│                     NAVIGATION                               │
│  Top right → icon "Messages" (avec badge unread global) next to favorites icon    │
└──────────────────────────┬──────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│              INBOX (TabBar 2 onglets)                         │
│                                                              │
│  [Organisateurs]              [Support LeHiboo]              │
│                                                              │
│  ┌────────────────────┐      ┌────────────────────┐          │
│  │ ConversationTile   │      │ ConversationTile   │          │
│  │ ● org avatar       │      │ ● LeHiboo logo     │          │
│  │ ● org name         │      │ ● subject          │          │
│  │ ● last msg preview │      │ ● last msg preview │          │
│  │ ● time ago         │      │ ● time ago         │          │
│  │ ● unread badge     │      │ ● unread badge     │          │
│  │ ● event chip       │      │ ● signalement tag  │          │
│  └────────────────────┘      └────────────────────┘          │
│                                                              │
│  [+] FAB "Nouveau message"   [+] FAB "Contacter support"    │
│                                                              │
│  Filtres (collapsible) :                                     │
│  ● status: all / open / closed                               │
│  ● unread_only toggle                                        │
│  ● search bar (debounce 300ms)                               │
└──────────────────────────┬──────────────────────────────────┘
                           │ tap on tile
                           ▼
┌─────────────────────────────────────────────────────────────┐
│              THREAD DETAIL                                    │
│                                                              │
│  AppBar :                                                    │
│  ● org avatar + name (tap → org public page)                 │
│  ● status chip (open/closed)                                 │
│  ● overflow menu: close, report                              │
│                                                              │
│  Message list (reverse ListView) :                           │
│  ● own messages: right-aligned, primary color                │
│  ● received messages: left-aligned, surface color            │
│  ● system messages: centered pill                            │
│  ● deleted messages: grey italic placeholder                 │
│  ● attachments: inline image preview / PDF row               │
│  ● long-press: edit / delete / copy                          │
│  ● delivery ticks on last own message                        │
│                                                              │
│  Compose bar (bottom) :                                      │
│  ● TextInput + send button                                   │
│  ● attachment button (image picker + file picker)            │
│  ● attachment preview row (removable chips)                  │
│  ● disabled state if conversation is closed                  │
└─────────────────────────────────────────────────────────────┘
```

### Points d'entree depuis d'autres ecrans

| Ecran source | Action | API |
|---|---|---|
| Detail reservation | Bouton "Contacter l'organisateur" | `POST /user/conversations/from-booking/{bookingUuid}` |
| Page publique organisateur | Bouton "Envoyer un message" | `POST /user/conversations/from-organization/{orgUuid}` |
| Notification in-app (type `new_message`) | Tap → ouvre le thread | Deep link `/messages/{conversationUuid}` |

---

## Modele de donnees Flutter (Dart DTOs)

```dart
enum ConversationType { participantVendor, userSupport }
enum ConversationStatus { open, closed }
enum SenderType { participant, organization, admin, system }

class Conversation {
  final String uuid;
  final String subject;
  final ConversationStatus status;
  final ConversationType conversationType;
  final DateTime? closedAt;
  final DateTime? lastMessageAt;
  final int unreadCount;
  final bool isSignalement;
  final ConversationOrganization? organization;
  final ConversationParticipant? participant;
  final ConversationEvent? event;
  final Message? latestMessage;
  final List<Message>? messages; // only populated on detail
  final DateTime createdAt;
}

class Message {
  final String uuid;
  final int conversationId;
  final SenderType senderType;
  final String senderTypeLabel;
  final bool isSystem;
  final MessageSender? sender;
  final String? content;        // null when is_deleted or attachment-only
  final bool isDeleted;
  final bool isEdited;
  final bool isRead;
  final bool isDelivered;
  final DateTime? readAt;
  final DateTime? deliveredAt;
  final DateTime? editedAt;
  final bool isMine;
  final List<MessageAttachment> attachments;
  final DateTime createdAt;
}

class MessageAttachment {
  final String uuid;
  final String url;
  final String originalName;
  final String mimeType;
  final int size;               // bytes
  final bool isImage;
  final bool isPdf;
}

class ConversationOrganization {
  final String uuid;
  final String companyName;
  final String organizationName;
  final String? logoUrl;
  final String? avatarUrl;
}

class MessageSender {
  final int id;
  final String name;
  final String? avatarUrl;
}

class ConversationEvent {
  final String uuid;
  final String title;
  final String slug;
}
```

---

## Ecrans detailles

### 1. Inbox — onglet Organisateurs

**API** : `GET /api/v1/user/conversations`

**Comportement** :
- Pagination infinie (scroll-to-load, `per_page=20`)
- Tri serveur par `last_message_at` DESC (deja applique par le backend)
- Pull-to-refresh invalide la liste + le unread count
- Chaque tile affiche : avatar org, nom org, subject, dernier message (tronque ~80 chars), temps relatif, badge unread si > 0, chip event optionnel, chip "ferme" si `status = closed`
- Tap → navigation vers thread detail

**Filtres** :
- Barre de recherche en haut (query param `search`, debounce 300ms)
- Chips sous la barre : `Tous` / `Non lus` (toggle `unread_only=true`) / `Ouverts` / `Fermes`
- Les filtres declenchent un nouveau fetch (page 1)

**Etat vide** :
- Aucune conversation : illustration + texte "Aucun message pour le moment" + bouton "Contacter un organisateur"

**FAB "Nouveau message"** :
- Ouvre un bottom sheet ou ecran de selection avec les organisateurs contactables
- API : `GET /api/v1/user/conversations/contactable-organizations`
- Apres selection : formulaire sujet + premier message + fichiers optionnels
- API : `POST /api/v1/user/conversations`
- Redirection vers le thread cree

---

### 2. Inbox — onglet Support LeHiboo

**API** : `GET /api/v1/user/support-conversations`

**Comportement** :
- Meme pattern que l'onglet Organisateurs
- Pas de filtre par event (non pertinent)
- Tile affiche : logo LeHiboo (fixe), subject, dernier message, temps relatif, badge unread
- Si `is_signalement = true` : chip "Signalement" en rouge

**FAB "Contacter le support"** :
- Formulaire sujet + premier message
- API : `POST /api/v1/user/support-conversations`
- Redirection vers le thread cree

---

### 3. Thread detail

**API** : `GET /api/v1/user/conversations/{uuid}` (ou `support-conversations/{uuid}`)

**Chargement** :
- Le GET marque automatiquement les messages comme lus cote backend (pas besoin d'appel separe)
- Apres chargement, invalider le cache du unread count global

**Affichage des messages** :
- `ListView` inverse (messages recents en bas, scroll vers le haut pour l'historique)
- Grouper par date (separateur "Aujourd'hui", "Hier", "22 avril 2026")
- Messages `system` : centrer dans un chip gris avec icone info

**Bulles de message** :

| Condition | Rendu |
|---|---|
| `is_mine = true` | Bulle droite, couleur primaire |
| `is_mine = false` | Bulle gauche, couleur surface, avatar sender |
| `is_deleted = true` | Bulle grise italique : "Message supprime" |
| `is_system = true` | Chip centre, pas de bulle |
| `is_edited = true` | Label "(modifie)" sous le timestamp |
| Avec `attachments` | Images inline (tap → viewer plein ecran), PDF en row cliquable |

**Indicateurs de livraison/lecture** (dernier message `is_mine = true` seulement) :

| Etat | Icone |
|---|---|
| Envoye (pas encore `is_delivered`) | ✓ simple gris |
| Livre (`is_delivered = true`, `is_read = false`) | ✓✓ double gris |
| Lu (`is_read = true`) | ✓✓ double bleu/primaire |

**Long-press sur un message propre** :
- Menu contextuel : Modifier, Supprimer, Copier le texte
- Modifier : remplace la bulle par un TextInput inline, bouton Annuler/Valider
- API edit : `PATCH .../messages/{messageUuid}`
- API delete : `DELETE .../messages/{messageUuid}` → remplacer la bulle par placeholder

**Compose bar** :
- `TextField` multi-lignes (max 2000 chars)
- Bouton envoi desactive si texte vide ET pas de fichiers
- Bouton clip : ouvre un bottom sheet avec "Photo/Video" (camera ou galerie) et "Document" (file picker)
- Preview des fichiers selectionnes au-dessus du TextField (chips avec nom + bouton X)
- Limites : max 3 fichiers, max 5 MB chacun, types : jpg, jpeg, png, webp, pdf
- Envoi en `multipart/form-data` si fichiers, sinon `application/json`
- API : `POST .../messages`
- Si `status = closed` : composer desactive, banner "Cette conversation est fermee"

**AppBar overflow menu** :
- "Fermer la conversation" : dialog de confirmation → `POST .../close`
- "Signaler" : dialog avec choix de raison + commentaire (min 10 chars) → `POST .../report`
- Apres signalement : snackbar succes + optionnellement naviguer vers le thread support cree (`support_conversation_uuid` dans la reponse)

---

### 4. Nouveau message depuis une reservation

**Declenchement** : Bouton sur l'ecran detail de reservation

**Flow** :
1. `POST /api/v1/user/conversations/from-booking/{bookingUuid}`
2. Reponse contient `created: true|false` et `uuid`
3. Naviguer vers `/messages/{uuid}`
4. Si `created = true` : le thread est vide, l'utilisateur ecrit le premier message
5. Si `created = false` : le thread existant s'ouvre avec son historique

---

### 5. Nouveau message depuis une page publique organisateur

**Declenchement** : Bouton "Contacter" sur la page organisateur

**Pre-condition** : L'organisateur doit avoir `allow_public_contact = true`. Si `false`, le bouton est masque ou desactive.

**Flow** :
1. Formulaire bottom sheet : sujet (requis) + message (requis) + event optionnel (select parmi les events de l'org) + fichiers optionnels
2. `POST /api/v1/user/conversations/from-organization/{orgUuid}`
3. Naviguer vers le thread cree

**Erreur 403** : "Cet organisateur n'accepte pas les messages depuis sa page publique." → afficher un snackbar, ne pas naviguer.

---

## Strategie temps reel

### Etat actuel backend

Le backend broadcast 3 events via Pusher/Reverb sur des channels prives :

| Event | Channel | Payload cle |
|---|---|---|
| `message.received` | `private-user.{userId}` | `message_uuid`, `conversation_uuid`, `sender_name`, `content_preview` |
| `message.delivered` | `private-user.{userId}` | `message_uuid`, `conversation_uuid`, `delivered_at` |
| `conversation.read` | `private-user.{userId}` | `conversation_uuid`, `reader_name`, `messages_read_count`, `read_at` |

### Option A — WebSocket (recommande si infra Pusher/Reverb deja active)

Utiliser le package `pusher_channels_flutter` :

```dart
// Auth channel: private-user.{userId}
// Auth endpoint: POST /broadcasting/auth (avec Bearer token)

channel.bind('message.received', (event) {
  // 1. Si on est dans le thread concerne → append le message, faire GET detail pour refresh complet
  // 2. Sinon → incrementer le unread count local, mettre a jour le latest_message dans la liste
  // 3. Optionnel: afficher une notification locale si app en background
});

channel.bind('message.delivered', (event) {
  // Mettre a jour is_delivered sur le message concerne dans le cache local
});

channel.bind('conversation.read', (event) {
  // Mettre a jour is_read sur les messages propres dans le cache local
  // Passer les ticks de gris a bleu
});
```

**Auth WebSocket** : Le channel `private-user.{userId}` necessite une auth via `POST /broadcasting/auth` (standard Laravel Broadcasting). Le endpoint est deja configure dans `routes/channels.php` et verifie que `$user->id == $userId`.

### Option B — Polling (fallback si pas de WebSocket)

| Surface | Intervalle | Endpoint |
|---|---|---|
| Thread detail (ecran actif) | 10 secondes | `GET /user/conversations/{uuid}` |
| Badge unread (global) | 30 secondes | `GET /user/conversations/unread-count` |
| Liste conversations | Pas de poll, refresh au retour sur l'ecran | `GET /user/conversations` |

**Important** : Le polling du detail thread marque automatiquement les messages comme lus (effet de bord du `GET show`). Pas besoin d'un appel `POST /read` separe — il n'existe d'ailleurs pas sur les routes participant.

### Recommandation

Commencer par le **polling** (simple, pas de dependance infra). Migrer vers **WebSocket** quand le volume de messages le justifie. Les deux approches sont compatibles avec le backend actuel.

---

## Push notifications (FCM)

### Etat actuel

`NewMessageNotification` envoie uniquement sur les channels `database` + `mail`. Il n'y a **pas de push FCM** pour les nouveaux messages. C'est un gap backend.

### Impact mobile

Sans push FCM, l'utilisateur ne recoit pas de notification quand l'app est en arriere-plan ou fermee. Deux options :

**Option 1 — Backend fix (recommande)** : Ajouter le trait `HasPushNotification` a `NewMessageNotification` et implementer `toFcm()`, comme c'est deja fait pour `DiscoveryEventReminderNotification`. Payload suggere :

```json
{
  "title": "Nouveau message de {senderName}",
  "body": "{contentPreview}",
  "data": {
    "type": "new_message",
    "conversation_uuid": "...",
    "action": "/messages/{conversationUuid}"
  }
}
```

**Option 2 — Notification locale depuis WebSocket** : Si le WebSocket reste connecte en background, declencher une notification locale Flutter. Moins fiable (killed par l'OS).

### Deep link

Quel que soit le mecanisme, le payload `data.action` ou `data.conversation_uuid` permet de naviguer directement vers le thread au tap.

### Notification in-app (database)

Les notifications `new_message` existent deja dans `GET /api/v1/notifications`. Payload :

```json
{
  "type": "new_message",
  "sender_name": "Le Hiboo Events",
  "subject": "Question sur ma reservation",
  "conversation_uuid": "...",
  "content_preview": "Bonjour, voici la confirmation...",
  "message": "Nouveau message de Le Hiboo Events : Bonjour...",
  "received_at": "2026-04-23T10:31:00+00:00"
}
```

Le tap sur cette notification dans le centre de notifications in-app doit naviguer vers `/messages/{conversation_uuid}`.

---

## Envoi optimiste

Le web utilise un pattern d'envoi optimiste avec TanStack Query. Reproduire ce pattern en Flutter :

```text
1. User tape "Envoyer"
2. Immediatement : ajouter le message au state local avec un uuid temporaire (ex: "temp-{timestamp}")
   → afficher la bulle avec un spinner a la place du timestamp
3. Appeler POST /messages en background
4. Succes : remplacer le message temporaire par la reponse API (vrai uuid, timestamps)
5. Echec : marquer la bulle en erreur (icone rouge, bouton "Reessayer")
```

Pour les fichiers joints en cours d'upload, afficher un placeholder avec barre de progression au lieu de l'image/PDF.

---

## Badge unread global

Le badge dans la barre de navigation doit refleter le total de messages non lus **toutes conversations confondues**.

**Attention** : L'endpoint `GET /user/conversations/unread-count` ne compte que les conversations `participant_vendor`. Il n'inclut pas les `user_support`.

Pour un badge global complet, deux options :
1. Appeler les deux endpoints en parallele et sommer
2. Accepter le gap (les conversations support sont rares)

Recommandation : option 1, car le support peut envoyer des messages importants.

---

## Gestion des pieces jointes

### Selection

Utiliser `image_picker` pour les images (camera + galerie) et `file_picker` pour les PDF.

### Validation cote client

| Regle | Valeur |
|---|---|
| Nombre max | 3 fichiers par message |
| Taille max | 5 MB par fichier |
| Types acceptes | jpg, jpeg, png, webp, pdf |

Valider AVANT l'upload pour eviter un round-trip inutile (le backend retourne `422` si les regles sont violees).

### Envoi

Utiliser `multipart/form-data` avec le champ `attachments[]` (array de fichiers). Le champ `content` reste un champ texte dans le meme form-data.

### Affichage

| Type | Rendu |
|---|---|
| Image (jpg, png, webp) | Thumbnail inline dans la bulle (max ~220px largeur), tap → viewer plein ecran avec zoom/pan |
| PDF | Row avec icone PDF + nom du fichier + taille, tap → ouvrir dans le viewer PDF in-app ou externe |

### Telechargement

Les URLs des fichiers pointent vers MinIO (`Storage::disk('minio')->url()`). Ces URLs sont publiques ou pre-signees selon la config. Si pre-signees, elles expirent — ne pas les mettre en cache longue duree.

---

## Gestion des etats edge-case

### Conversation fermee

- Le composer est desactive
- Une banner en haut du thread indique "Cette conversation est fermee"
- L'overflow menu n'affiche plus "Fermer"
- L'utilisateur ne peut pas rouvrir (seul un admin peut rouvrir)
- Les messages restent lisibles

### Message supprime

- `is_deleted = true` + `content = null`
- Afficher : bulle grise avec texte italique "Ce message a ete supprime"
- Les pieces jointes sont egalement masquees

### Message modifie

- `is_edited = true` + `edited_at` renseigne
- Afficher : label "(modifie)" sous le timestamp de la bulle
- Le contenu est deja le contenu mis a jour

### Message sans texte (fichiers uniquement)

- `content = null` mais `attachments` non vide
- Afficher uniquement les fichiers dans la bulle, pas de texte

### Signalement existant

- Si l'utilisateur a deja signale cette conversation : le backend retourne `422` "Vous avez deja signale cette conversation"
- Cote UI : griser le bouton ou le masquer si un signalement est en cours (verifier `is_signalement` du thread support lie)

### Organisateur contact public desactive

- `POST /user/conversations/from-organization/{uuid}` retourne `403`
- Cote UI : masquer le bouton "Contacter" sur la page publique si l'info est disponible (champ `allow_public_contact` dans l'OrganizationResource)

---

## Navigation et deep links

| Deep link | Ecran cible | Source |
|---|---|---|
| `/messages` | Inbox onglet Organisateurs | BottomNav |
| `/messages/{conversationUuid}` | Thread detail | Notification tap, liste conversations |
| `/messages/support` | Inbox onglet Support | BottomNav (si onglet separe) |
| `/messages/support/{conversationUuid}` | Thread detail support | Notification tap, liste support |

**Depuis une notification push/locale** : Extraire `conversation_uuid` du payload, determiner le type (stocke localement ou via un fetch rapide), naviguer vers le bon ecran.

---

## Resume des endpoints utilises

### Conversations organisateur

| Action | Methode | Endpoint |
|---|---|---|
| Lister | GET | `/user/conversations` |
| Badge non lus | GET | `/user/conversations/unread-count` |
| Filtrer par event | GET | `/user/conversations/events` |
| Orgs contactables | GET | `/user/conversations/contactable-organizations` |
| Creer (depuis dashboard) | POST | `/user/conversations` |
| Creer (depuis reservation) | POST | `/user/conversations/from-booking/{bookingUuid}` |
| Creer (depuis page org) | POST | `/user/conversations/from-organization/{orgUuid}` |
| Detail + mark as read | GET | `/user/conversations/{uuid}` |
| Envoyer message | POST | `/user/conversations/{uuid}/messages` |
| Editer message | PATCH | `/user/conversations/{uuid}/messages/{messageUuid}` |
| Supprimer message | DELETE | `/user/conversations/{uuid}/messages/{messageUuid}` |
| Fermer | POST | `/user/conversations/{uuid}/close` |
| Signaler | POST | `/user/conversations/{uuid}/report` |

### Conversations support

| Action | Methode | Endpoint |
|---|---|---|
| Lister | GET | `/user/support-conversations` |
| Creer | POST | `/user/support-conversations` |
| Detail + mark as read | GET | `/user/support-conversations/{uuid}` |
| Envoyer message | POST | `/user/support-conversations/{uuid}/messages` |

---

## Hors scope V1

Ces fonctionnalites existent sur le web mais ne sont pas couvertes dans cette spec mobile :

| Fonctionnalite | Role web | Raison de l'exclusion |
|---|---|---|
| Conversations `vendor_admin` | Vendor | Pas de dashboard vendor mobile |
| Conversations `organization_organization` | Vendor | Pas de dashboard vendor mobile |
| Broadcasts (diffusion masse) | Vendor | Pas de dashboard vendor mobile |
| Gestion des signalements | Admin | Pas de dashboard admin mobile |
| Reouverture de conversation | Admin | Privilege admin uniquement |
| Recherche participants interages | Vendor | Pas de dashboard vendor mobile |

---

## Checklist avant livraison

- [ ] Inbox 2 onglets (Organisateurs + Support) avec pagination infinie
- [ ] Badge unread dans la BottomNav (poll 30s ou WebSocket)
- [ ] Filtres : status, unread_only, search
- [ ] Thread detail avec bulles alignees par `is_mine`
- [ ] Messages systeme centres
- [ ] Messages supprimes : placeholder
- [ ] Messages edites : label "(modifie)"
- [ ] Indicateurs livraison/lecture (ticks) sur dernier message propre
- [ ] Compose bar avec envoi texte + fichiers (multipart)
- [ ] Validation fichiers cote client (3 max, 5 MB, types)
- [ ] Images inline avec viewer plein ecran
- [ ] PDF cliquable avec ouverture externe
- [ ] Long-press : editer / supprimer / copier
- [ ] Envoi optimiste avec spinner et gestion erreur
- [ ] Etat ferme : composer desactive + banner
- [ ] Creation depuis reservation (`from-booking`)
- [ ] Creation depuis page organisateur (`from-organization`)
- [ ] Creation depuis dashboard (selection org contactable)
- [ ] Creation conversation support
- [ ] Signalement avec choix raison + commentaire
- [ ] Deep link depuis notifications in-app
- [ ] Pull-to-refresh sur la liste
- [ ] Etat vide avec illustration
