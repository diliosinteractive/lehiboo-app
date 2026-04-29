# Messages Mobile — Spécification d'implémentation Flutter

Ce document décrit comment implémenter la fonctionnalité Messages dans l'application mobile Flutter.
Pour le contrat API (endpoints, payloads, erreurs), voir `MOBILE_MESSAGES_API.md`.

---

## Scope

**V1 (rôle participant uniquement)**

| Fonctionnalité | Statut |
|----------------|--------|
| Conversations user ↔ organisateur (`participant_vendor`) | Implémenté |
| Conversations user ↔ support LeHiboo (`user_support`) | Implémenté |
| Signalement de conversation | Implémenté |
| Pièces jointes (images, PDF) | Implémenté |
| Édition / suppression de messages | Implémenté (vendor uniquement) |
| Indicateurs de lecture et livraison | Implémenté |
| Badge unread global dans BottomNav | Implémenté |
| `NewConversationForm` — modal unifié (dashboard / organisateur / support) | Implémenté |
| Sélecteur d'org avec recherche (nouveau message) | Implémenté (filtrage local, `NewConversationForm`) |
| Protection routes `/messages` — accès réservé aux utilisateurs connectés | Implémenté |
| Chat UI refresh (bulles asymétriques, avatars, composer pill) | Implémenté |
| Groupement des conversations par organisation | À implémenter |
| Preview pièces jointes dans ConversationTile | Implémenté |
| Masquer bouton Signaler si déjà signalé | Implémenté |
| Temps réel WebSocket | À implémenter (v2 active) |
| Push FCM nouveaux messages | Backend prêt — voir section dédiée |

---

## Structure de fichiers

```
lib/features/messages/
├── domain/
│   ├── entities/
│   │   ├── conversation.dart
│   │   ├── message.dart
│   │   └── conversation_report.dart
│   └── repositories/
│       └── messages_repository.dart
├── data/
│   ├── datasources/
│   │   ├── messages_api_datasource.dart
│   │   └── messages_polling_datasource.dart
│   ├── models/
│   │   ├── conversation_dto.dart
│   │   ├── message_dto.dart
│   │   ├── attachment_dto.dart
│   │   ├── conversation_organization_dto.dart
│   │   └── unread_count_dto.dart
│   └── repositories/
│       └── messages_repository_impl.dart
└── presentation/
    ├── providers/
    │   ├── conversations_provider.dart
    │   ├── conversation_detail_provider.dart
    │   ├── support_conversations_provider.dart
    │   └── unread_count_provider.dart
    ├── screens/
    │   ├── conversations_list_screen.dart
    │   ├── conversation_detail_screen.dart
    │   ├── new_conversation_screen.dart
    │   └── support_detail_screen.dart
    └── widgets/
        ├── conversation_tile.dart
        ├── message_bubble.dart
        ├── message_composer.dart
        ├── attachment_preview.dart
        ├── org_search_selector.dart        ← à créer
        └── report_conversation_dialog.dart
```

Routes dans `app_router.dart` :

| Route | Écran | Note |
|-------|-------|------|
| `/messages` | `ConversationsListScreen` | BottomNav — onglet Organisateurs |
| `/messages/new` | `NewConversationScreen` | Sélecteur org + formulaire |
| `/messages/new/from-booking/:bookingUuid` | `NewConversationScreen` | Auto-select org via booking |
| `/messages/new/from-organizer/:organizationUuid` | `NewConversationScreen` | Pre-sélectionne l'org |
| `/messages/support/new` | `SupportDetailScreen(isNew: true)` | Formulaire sujet + message |
| `/messages/support/:conversationUuid` | `SupportDetailScreen` | Thread support |
| `/messages/:conversationUuid` | `ConversationDetailScreen` | Thread organisateur |

---

## Architecture écrans

```
┌──────────────────────────────────────────────────────────────────┐
│                 BOTTOM NAV — icône "Messages"                     │
│                 Badge global = vendor_unread + support_unread     │
└────────────────────────────┬─────────────────────────────────────┘
                             │
                             ▼
┌──────────────────────────────────────────────────────────────────┐
│              INBOX  (TabBar 2 onglets)                            │
│                                                                   │
│  [Organisateurs]                   [Support LeHiboo]              │
│  badge = unread vendor             badge = unread support         │
│                                                                   │
│  Barre de recherche (debounce 300ms, filtre local ou param API)   │
│  Chips filtres : Tous / Non lus / Ouverts / Fermés               │
│                                                                   │
│  ┌─────────────────────────────┐                                  │
│  │  ConversationTile           │                                  │
│  │  [logo org]  Nom org        │  ← logo_url ou initiales coloré  │
│  │             Sujet           │                                  │
│  │             Preview msg     │  ← voir règles preview           │
│  │             Temps relatif   │  [badge unread si > 0]           │
│  │             Chip event      │  [chip "Fermé" si closed]        │
│  └─────────────────────────────┘                                  │
│                                                                   │
│  [+] FAB                                                          │
│  Organisateurs : "Nouveau message"                                │
│  Support : "Contacter le support"                                 │
└────────────────────────────┬─────────────────────────────────────┘
                             │ tap tile
                             ▼
┌──────────────────────────────────────────────────────────────────┐
│              THREAD DETAIL                                        │
│                                                                   │
│  AppBar :                                                         │
│  [logo org]  Nom org · chip statut                               │
│  overflow menu : Fermer / Signaler                                │
│                                                                   │
│  ListView inversée (récents en bas) :                             │
│  ● bulles right = is_mine, left = reçus                          │
│  ● messages system : chip centré                                  │
│  ● messages supprimés : placeholder italique                      │
│  ● pièces jointes : inline images / PDF row                       │
│  ● long-press (vendor seulement) : Modifier / Supprimer / Copier │
│  ● ticks livraison/lecture sur dernier message propre             │
│  ● séparateurs de date ("Aujourd'hui", "Hier", "22 avril 2026")  │
│                                                                   │
│  Compose bar :                                                    │
│  TextField multi-lignes (max 2000) + bouton clip + bouton envoi   │
│  Preview chips fichiers sélectionnés (removable)                  │
│  Désactivé + banner si status = closed                            │
└──────────────────────────────────────────────────────────────────┘
```

---

## Modèle de données Dart

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
  final bool userHasReported;        // masquer/griser bouton Signaler
  final ConversationOrganization? organization;
  final ConversationParticipant? participant;
  final ConversationEvent? event;
  final Message? latestMessage;
  final List<Message>? messages;     // uniquement sur le détail
  final DateTime createdAt;
}

class Message {
  final String uuid;
  final int conversationId;
  final SenderType senderType;
  final String senderTypeLabel;
  final bool isSystem;
  final MessageSender? sender;
  final String? content;             // null si is_deleted ou attachments-only
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
  final int size;          // bytes
  final bool isImage;      // true = jpg/png/webp, false = pdf etc.
  final bool isPdf;
}

class ConversationOrganization {
  final String uuid;
  final String companyName;
  final String organizationName;
  final String? logoUrl;   // utiliser pour l'avatar dans tiles ET detail
  final String? avatarUrl; // fallback si logoUrl est null
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

## Spécification — ConversationTile

Le `ConversationTile` doit correspondre exactement au comportement du web (`conversation-item.tsx`).

### Avatar organisation

```dart
// Priorité : logo_url → avatar_url → initiales colorées
Widget buildOrgAvatar(ConversationOrganization? org) {
  final logoUrl = org?.logoUrl ?? org?.avatarUrl;
  if (logoUrl != null) {
    return CircleAvatar(backgroundImage: NetworkImage(logoUrl));
  }
  final initials = (org?.companyName ?? 'O').substring(0, min(2, ...)).toUpperCase();
  final color = avatarColorFromId(org?.id ?? 0); // palette deterministe par id
  return CircleAvatar(backgroundColor: color, child: Text(initials));
}
```

### Texte de preview du dernier message

```dart
String? buildPreviewText(Message? latest) {
  if (latest == null) return null;
  if (latest.content != null) return latest.content; // tronquer à 80 chars dans le widget

  final attachments = latest.attachments;
  if (attachments.isEmpty) return null;

  final imageCount = attachments.where((a) => a.isImage).length;
  final fileCount = attachments.length - imageCount;

  if (fileCount == 0) {
    return imageCount == 1 ? 'Une image envoyée' : '$imageCount images envoyées';
  }
  if (imageCount == 0) {
    return fileCount == 1 ? 'Un fichier envoyé' : '$fileCount fichiers envoyés';
  }
  return '${attachments.length} pièces jointes';
}
// Si retourne null → n'afficher aucun texte de preview (pas "Aucun message")
```

### Affichage de l'icône paperclip

Afficher l'icône `Icons.attach_file` (ou équivalent) devant le texte de preview **uniquement** quand `content == null && attachments.isNotEmpty`.

### Badge statut de la conversation

Le tile affiche **toujours** un badge de statut (aligné sur le web) :

| État | Couleur Flutter équivalent | Icône | Label |
|------|---------------------------|-------|-------|
| Non lus (`unreadCount > 0`) | Orange clair — `orange.shade100` text `orange.shade700` | — | "En attente" |
| Ouvert (`status == open`, 0 non lus) | Vert clair — `green.shade100` text `green.shade700` | — | "Ouvert" |
| Fermé (`status == closed`) | Gris — `grey.shade100` text `grey.shade600` | `Icons.lock` petit | "Fermé" |

### Badge compteur non lus

```dart
if (conversation.unreadCount > 0)
  Badge(
    label: conversation.unreadCount > 99 ? '99+' : '${conversation.unreadCount}',
    backgroundColor: Colors.orange.shade500,
    textColor: Colors.white,
  )
```

### Chips contextuels

| Condition | Chip | Visibilité |
|-----------|------|-----------|
| `event != null` | Titre de l'événement (tronqué) avec icône calendrier | Toujours (participant) |
| `isSignalement == true` | Chip rouge "Signalement" + icône drapeau | **Admin uniquement** — le participant ne voit jamais ce chip |

### Comportement unread

- Fond du tile : `orange.shade50` + bordure `orange.shade200` quand `unreadCount > 0`
- Nom de l'org et sujet : `FontWeight.w600` (semibold) quand `unreadCount > 0`, `FontWeight.w500` sinon
- Point indicateur orange sur l'avatar quand `unreadCount > 0`
- Fond neutre sans surbrillance quand `unreadCount == 0`

---

## Spécification — Groupement par organisation (recommandé)

Le web regroupe les conversations `participant_vendor` par organisation dans un panneau gauche, puis affiche les conversations de l'org sélectionnée à droite.

### Pattern recommandé pour mobile

Sur mobile (écran unique), deux options :

**Option A — Liste plate triée par `last_message_at`** (actuel — simple, standard)
- Toutes les conversations d'un user avec différents orgs dans une seule liste
- Avatar = logo de l'org, titre = nom de l'org, sous-titre = sujet de la conversation

**Option B — Groupement par org (aligné avec le web)**
- Section par org dans la liste (header "Le Hiboo Events — 3 conversations")
- Ou écran intermédiaire : tap sur l'org → liste des conversations avec cette org
- Utile quand un utilisateur a beaucoup de conversations avec le même organisateur (ex: achat multiple)

**Recommandation** : implémenter l'Option B si un utilisateur peut avoir plus de 3 conversations avec le même organisateur. L'API retourne déjà tout ce qu'il faut (`organization.id`, `organization.company_name`, `organization.logo_url`).

**Algorithme de groupement** (calqué sur le web) :

```dart
Map<int, OrgGroup> groupByOrg(List<Conversation> conversations) {
  final groups = <int, OrgGroup>{};
  for (final conv in conversations) {
    final orgId = conv.organization?.id;
    if (orgId == null) continue;
    groups.putIfAbsent(orgId, () => OrgGroup(
      id: orgId,
      name: conv.organization!.companyName,
      logo: conv.organization!.logoUrl ?? conv.organization!.avatarUrl,
      conversations: [],
      unreadCount: 0,
      lastMessageAt: null,
    ));
    groups[orgId]!.conversations.add(conv);
    groups[orgId]!.unreadCount += conv.unreadCount;
    // garder la date la plus récente
    final msgAt = conv.lastMessageAt;
    if (msgAt != null) {
      final current = groups[orgId]!.lastMessageAt;
      if (current == null || msgAt.isAfter(current)) {
        groups[orgId]!.lastMessageAt = msgAt;
      }
    }
  }
  // trier par last_message_at DESC
  return groups;
}
```

---

## Spécification — Nouveau message (sélecteur d'organisateur)

### Depuis le dashboard (FAB "Nouveau message")

**Flow complet** :

1. Appeler `GET /user/conversations/contactable-organizations` (une seule fois au montage)
2. Afficher un dialog/bottom sheet avec `OrgSearchSelector`
3. L'utilisateur tape dans le champ de recherche → filtrage **local** instantané sur `company_name`
4. L'utilisateur sélectionne une org → le sélecteur est remplacé par un bloc destinataire fixe
5. Remplir sujet + message + event optionnel + pièces jointes optionnelles
6. `POST /user/conversations` (JSON ou multipart)
7. Fermer le dialog et naviguer vers le thread créé

### Widget `OrgSearchSelector`

```
┌──────────────────────────────────────────┐
│  Nouveau message                         │  ← Titre du dialog
│  Composez votre message ci-dessous.      │  ← Description
├──────────────────────────────────────────┤
│  🔍 Rechercher par nom...               │  ← TextField debounce 300ms
├──────────────────────────────────────────┤
│  [logo] Le Hiboo Events              ▼  │  ← Combobox avec liste déroulante
│          Jazz Festival                  │
│          Marché de Noël                 │
└──────────────────────────────────────────┘
```

**Comportement du sélecteur** :

- La liste complète est chargée une seule fois depuis `GET /contactable-organizations` — **aucun appel réseau** lors de la saisie
- Filtrage **100% local** : `companyName.toLowerCase().contains(query.toLowerCase())`
- Placeholder du champ : "Rechercher par nom..."
- Chaque entrée affiche : avatar (logo_url → avatar_url → initiales colorées) + `company_name`
- État vide si filtre sans résultat : "Aucun organisateur trouvé"
- État vide si liste API vide : "Vous n'avez pas encore de relation avec un organisateur" + lien "Parcourir les événements"

**Une fois l'org sélectionnée**, le sélecteur est remplacé par un bloc destinataire fixe :

```
┌──────────────────────────────────────────┐
│  [🏢 logo]  Le Hiboo Events             │  ← Fond primary/10, texte primary
└──────────────────────────────────────────┘
```

Puis le formulaire apparaît en dessous (sujet, message, pièces jointes).

### Depuis la page publique d'un organisateur

- L'org est pré-sélectionnée (`organizationUuid` passé en paramètre de route)
- Le sélecteur `OrgSearchSelector` n'est **pas** affiché — le bloc destinataire fixe est affiché directement avec le nom/logo de l'org
- Le champ "Événement" (optionnel) peut être pré-rempli si `eventId` est fourni
- Endpoint : `POST /user/conversations/from-organization/{organizationUuid}`

### Depuis la page de détail d'une réservation

- Aucun formulaire affiché
- Appel direct `POST /user/conversations/from-booking/{bookingUuid}`
- Spinner pendant l'appel puis navigation vers le thread (qu'il soit créé ou existant)
- Si `created = false` : le thread existant s'ouvre avec son historique complet

### Champs du formulaire de création (organisateur)

| Champ | Requis | Type | Note |
|-------|--------|------|------|
| Organisation | Oui | Sélecteur → bloc fixe une fois choisi | uuid |
| Sujet | Oui | TextField, max **100** chars, avec compteur | |
| Message | Oui* | TextField multi-lignes, max **2000** chars | *sauf si fichier |
| Événement | Non | Dropdown des events de l'org | uuid ou integer |
| Pièces jointes | Non | Max 3, 5 MB, `jpg/png/webp/pdf` | multipart si présent |

### Formulaire de création support

```text
┌──────────────────────────────────────────┐
│  Nouveau message support                  │
│  Décrivez votre problème…                │
├──────────────────────────────────────────┤
│  Objet *                                 │
│  [                          ] 0/255      │
├──────────────────────────────────────────┤
│  Message *                               │
│  [                                    ]  │
│  [  Textarea multi-lignes             ]  │
│  [                          ] 0/10000    │
├──────────────────────────────────────────┤
│  Pièces jointes (optionnel)              │
│  [📎 Ajouter un fichier]                 │
│  photo.jpg ×   document.pdf ×            │
├──────────────────────────────────────────┤
│              [Annuler]  [Envoyer →]      │
└──────────────────────────────────────────┘
```

| Champ | Requis | Contrainte |
| ----- | ------ | ---------- |
| Sujet | Oui | Libre, max **255** chars — les sujets prédéfinis sont des suggestions, pas une contrainte |
| Message | Oui | Max **10 000** chars (limite backend) |
| Pièces jointes | Non | Max 3, 5 MB, `jpg/png/webp/pdf` — supporté sur la création ET sur les envois dans le thread |

---

## Spécification — Thread detail

### Chargement et mark-as-read

```dart
// À l'ouverture du thread :
final detail = await repository.getConversation(uuid); // GET show — mark-as-read automatique
// Après chargement :
await unreadCountProvider.refresh(); // invalider le badge global
```

### Bulles de message

```dart
Widget buildMessageBubble(Message message) {
  if (message.isSystem) return SystemMessageChip(message);
  if (message.isDeleted) return DeletedMessageBubble(); // "Ce message a été supprimé"
  
  return Align(
    alignment: message.isMine ? Alignment.centerRight : Alignment.centerLeft,
    child: MessageBubble(
      message: message,
      showAvatar: !message.isMine && shouldShowAvatar(message), // voir grouping
    ),
  );
}
```

### Groupement des avatars (aligner sur le web)

Ne pas afficher l'avatar sur chaque bulle consécutive du même expéditeur :

```dart
bool shouldShowAvatar(int index, List<Message> messages) {
  if (index == 0) return true;
  final prev = messages[index - 1];
  final curr = messages[index];
  // clé composite : type + id (car id peut être null pour certains types)
  final prevKey = '${prev.senderType}_${prev.sender?.id}';
  final currKey = '${curr.senderType}_${curr.sender?.id}';
  return prevKey != currKey;
}
```

### Indicateurs de livraison/lecture

Afficher **uniquement sur le dernier message `is_mine = true`** :

| État | Rendu |
|------|-------|
| Envoyé (optimiste, pas encore `is_delivered`) | ✓ simple gris |
| Livré (`is_delivered = true`, `is_read = false`) | ✓✓ double gris |
| Lu (`is_read = true`) | ✓✓ double couleur primaire |

### Séparateurs de date

Insérer un chip de date centré entre les messages quand la date change :
- Aujourd'hui → "Aujourd'hui"
- Hier → "Hier"
- Même année → "22 avril"
- Autre année → "22 avril 2025"

### Long-press menu contextuel

**Uniquement pour les conversations `participant_vendor`** (pas pour `user_support`) :
- Modifier (si `is_mine = true` et `!isDeleted`)
- Supprimer (si `is_mine = true` et `!isDeleted`)
- Copier le texte (si `content != null`)

**Modifier** : remplacer la bulle par un `TextField` inline pré-rempli avec le contenu actuel. Bouton Annuler / Valider. `PATCH .../messages/{messageUuid}`.

**Supprimer** : dialog de confirmation → `DELETE .../messages/{messageUuid}` → remplacer la bulle par le placeholder "Ce message a été supprimé".

### Header AppBar — contenu complet

```
[← Retour]  [Avatar org]  Nom org
             Sujet (tronqué)
             [Badge statut]  [Chip événement si présent]
                                          [🔄] [Fermer] [Signaler / 🚩Signalé]
```

- **Badge statut** : vert "Ouvert" / gris+lock "Fermé" (même logique que le tile)
- **Chip événement** : si `conversation.event != null` → icône calendrier + titre de l'événement, tappable → ouvre la page de l'événement
- **Bouton Rafraîchir** `🔄` : toujours visible, force un `GET show`
- **Bouton Fermer** : visible uniquement si `status == open` → ouvre `CloseConversationDialog`
- **Bouton Signaler** : visible si `conversationType != userSupport` ET `!userHasReported`
- **Badge "Signalé"** `[🚩 Signalé]` : remplace le bouton Signaler quand `userHasReported == true` — non-interactif, style badge secondaire

**Important** : `user_has_reported` est disponible dans la réponse `GET show` — ne pas faire d'appel supplémentaire.

### Overflow menu AppBar

| Option | Condition d'affichage | Action |
|--------|----------------------|--------|
| Fermer la conversation | `status == open` | Dialog confirmation → `POST .../close` |
| Signaler | `conversationType != userSupport` et `!userHasReported` | Dialog signalement |
| Badge "🚩 Signalé" | `userHasReported == true` | Non-interactif, remplace le bouton |

### Conversation fermée

- Compose bar entièrement remplacée par une bannière (fond `Colors.grey.shade100`, texte centré) :

  > 🔒  Cette conversation est fermée

  Non-focusable, aucun champ de saisie visible.
- Bouton "Fermer" masqué dans le header
- "Signaler" conservé si `!userHasReported` (on peut signaler une conv fermée)
- Long-press edit/delete désactivés (les callbacks sont `null`)
- Les messages restent lisibles et scrollables

### Dialog de signalement

Aucune pièce jointe dans ce dialog.

```
┌─────────────────────────────────────┐
│ Signaler cette conversation         │
├─────────────────────────────────────┤
│ Raison :                            │
│ ● (Dropdown)                        │
│   - Contenu inapproprié             │
│   - Harcèlement                     │
│   - Spam                            │
│   - Autre                           │
├─────────────────────────────────────┤
│ Commentaire * :                     │
│ [                              ]    │
│ [  Textarea 4 lignes, min 10   ]    │
│ [  chars, max 2000 chars       ]    │
├─────────────────────────────────────┤
│          [Annuler] [Signaler]       │
└─────────────────────────────────────┘
```

**Validation côté client** :

- Raison : obligatoire
- Commentaire : obligatoire, `comment.trim().length >= 10`

**État de succès** (affiché dans le même dialog, remplace le formulaire) :

```
┌─────────────────────────────────────┐
│           [🚩 icône]                │
│   Signalement transmis              │
│   Votre signalement a bien été      │
│   transmis à l'équipe LeHiboo.      │
│                                     │
│              [OK]                   │
└─────────────────────────────────────┘
```

Après fermeture du dialog de succès :

- Le bouton "Signaler" dans l'overflow est remplacé par un **badge non-interactif** `[🚩 Signalé]`
- Ce badge est permanent — `user_has_reported = true` persiste depuis la réponse API
- Ne pas proposer de navigation vers le thread support (la réponse API retourne `support_conversation_uuid` mais le web ne redirige pas automatiquement)

---

## Spécification — Compose bar

```
┌──────────────────────────────────────────────┐
│ [📎] [________________________] [Envoyer ➤]  │
├──────────────────────────────────────────────┤
│  photo.jpg ×    document.pdf ×               │  ← chips pièces jointes (si sélectionnées)
└──────────────────────────────────────────────┘
```

| Règle | Valeur |
|-------|--------|
| Max 2000 chars | TextField avec compteur |
| Bouton envoi | Désactivé si texte vide ET aucun fichier |
| Bouton clip | Ouvre bottom sheet : "Photo/Vidéo" (image_picker) + "Document" (file_picker) |
| Max fichiers | 3 |
| Max taille | 5 MB par fichier |
| Types | `jpg`, `jpeg`, `png`, `webp`, `pdf` |
| Envoi | `multipart/form-data` si fichiers, `application/json` sinon |
| Conversations `participant_vendor` | Bouton clip activé — pièces jointes supportées |
| Conversations `user_support` | Bouton clip activé — pièces jointes **aussi supportées** (backend vérifié) |

**Validation côté client** : toujours valider avant l'upload (taille, type, nombre) pour éviter un round-trip inutile.

---

## Envoi optimiste

```dart
// 1. Créer un message temporaire
final tempMessage = Message(
  uuid: 'temp-${DateTime.now().millisecondsSinceEpoch}',
  content: content,
  isMine: true,
  isDelivered: false,
  isRead: false,
  sender: currentUser.toMessageSender(),
  createdAt: DateTime.now(),
  attachments: [],
);

// 2. Ajouter immédiatement à l'état local (spinner à la place du timestamp)
state.addMessage(tempMessage);

// 3. Appeler l'API en background
try {
  final realMessage = await repository.sendMessage(conversationUuid, content, files);
  state.replaceMessage('temp-...', realMessage); // remplacer par la vraie réponse
} catch (e) {
  state.markMessageError('temp-...'); // icône erreur rouge + bouton "Réessayer"
}
```

Pour les fichiers en cours d'upload : afficher un placeholder avec barre de progression dans la bulle.

---

## Badge unread global

Le badge dans la BottomNav reflète **toutes** les conversations non lues.

```dart
int getTotalUnread(int vendorUnread, List<Conversation> supportConversations) {
  final supportUnread = supportConversations.fold(0, (sum, c) => sum + c.unreadCount);
  return vendorUnread + supportUnread;
}
```

**Sources** :
- Vendor : `GET /user/conversations/unread-count` → `count`
- Support : sommer les `unread_count` de `GET /user/support-conversations` (pas d'endpoint dédié)

**Rafraîchissement** :
- Polling toutes les 30 secondes
- Invalider immédiatement après `GET show` d'une conversation
- Invalider après événement realtime `message.received`

---

## Temps réel — Stratégie

### Polling (actuel)

| Surface | Intervalle | Endpoint |
|---------|------------|----------|
| Thread actif | 10 secondes | `GET /user/conversations/{uuid}` |
| Badge unread | 30 secondes | `GET /user/conversations/unread-count` + support |
| Liste | Au retour sur l'écran | `GET /user/conversations` |

### WebSocket (à implémenter — priorité haute)

Package recommandé : `pusher_channels_flutter`.

Auth channel : `POST /broadcasting/auth` avec `Authorization: Bearer {token}`.

```dart
// Se connecter au channel privé de l'utilisateur
final channel = pusher.subscribe('private-user.$userId');

channel.bind('message.received', (event) {
  final data = jsonDecode(event.data);
  if (currentConversationUuid == data['conversation_uuid']) {
    // Thread ouvert : refetch detail pour obtenir le message complet
    conversationDetailProvider.refresh();
  } else {
    // Thread fermé : incrémenter badge, maj latest_message dans la liste
    unreadCountProvider.increment();
    conversationsProvider.updateLatestMessage(data);
  }
});

channel.bind('message.delivered', (event) {
  // Passer is_delivered = true sur le message → ticks gris simple → double
  final data = jsonDecode(event.data);
  conversationDetailProvider.markDelivered(data['message_uuid']);
});

channel.bind('message.edited', (event) {
  final data = jsonDecode(event.data);
  conversationDetailProvider.updateMessage(
    data['message_uuid'],
    content: data['content'],
    isEdited: true,
    editedAt: DateTime.parse(data['edited_at']),
  );
});

channel.bind('message.deleted', (event) {
  final data = jsonDecode(event.data);
  conversationDetailProvider.markDeleted(data['message_uuid']);
});

channel.bind('conversation.read', (event) {
  // Ticks doubles gris → bleu/primaire
  final data = jsonDecode(event.data);
  conversationDetailProvider.markMessagesRead(data['conversation_uuid']);
});

channel.bind('conversation.created', (event) {
  // Nouvelle conversation initiée par vendor ou admin
  conversationsProvider.refresh();
  unreadCountProvider.refresh();
});

channel.bind('conversation.closed', (event) {
  // Verrouiller le composer
  final data = jsonDecode(event.data);
  conversationDetailProvider.markClosed(data['conversation_uuid']);
  conversationsProvider.updateStatus(data['conversation_uuid'], 'closed');
});

channel.bind('conversation.reopened', (event) {
  // Déverrouiller le composer (réouvert par admin)
  final data = jsonDecode(event.data);
  conversationDetailProvider.markReopened(data['conversation_uuid']);
  conversationsProvider.updateStatus(data['conversation_uuid'], 'open');
});
```

---

## Push notifications (FCM)

### État actuel — backend implémenté

`NewMessageNotification` envoie maintenant sur `database` + `mail` + **FCM** via `HasPushNotification` + `PushPayload::newMessage()`. Le canal FCM est conditionnel : il n'est ajouté que si `FCM_ENABLED=true` ET que l'utilisateur a au moins un `DeviceToken` actif.

### Payload FCM reçu par l'app mobile

```json
{
  "title": "Nouveau message de Le Hiboo Events",
  "body": "Bonjour, voici la confirmation...",
  "data": {
    "type": "new_message",
    "conversation_uuid": "2c83f27f-d6f7-4300-bfbf-9ee5f48e43fd",
    "conversation_type": "participant_vendor",
    "action": "/messages/2c83f27f-d6f7-4300-bfbf-9ee5f48e43fd"
  }
}
```

**Routing mobile depuis le payload FCM** :

```dart
void handleFcmMessage(RemoteMessage message) {
  final data = message.data;
  if (data['type'] != 'new_message') return;

  final uuid = data['conversation_uuid'] as String;
  final type = data['conversation_type'] as String? ?? 'participant_vendor';

  final route = type == 'user_support'
      ? '/messages/support/$uuid'
      : '/messages/$uuid';

  router.push(route);
}
```

`conversation_type` peut valoir `participant_vendor` ou `user_support` — utiliser ce champ pour router vers le bon écran.

### Enregistrement du token device (requis)

L'app doit enregistrer le token FCM après login :

```http
POST /api/v1/device-tokens
Authorization: Bearer {token}
Content-Type: application/json
```

```json
{
  "token": "<FCM_DEVICE_TOKEN>",
  "platform": "android",
  "device_id": "unique-device-id",
  "device_name": "Pixel 8",
  "app_version": "1.0.0"
}
```

`platform` : `android` | `ios` | `web`. Si `device_id + platform` existe déjà pour cet utilisateur, le token est mis à jour (pas de doublon).

Supprimer le token au logout :

```http
DELETE /api/v1/device-tokens
Authorization: Bearer {token}
Content-Type: application/json
{ "token": "<FCM_DEVICE_TOKEN>" }
```

### Variables d'environnement backend à configurer

```env
FCM_ENABLED=true
FCM_PROJECT_ID=lehiboo-app
# Soit le chemin vers le fichier JSON :
FCM_CREDENTIALS_PATH=/var/www/storage/firebase/service-account.json
# Soit le JSON encodé en base64 :
FCM_CREDENTIALS_JSON=<base64_encoded_service_account_json>
```

### Notifications in-app (database — disponibles maintenant)

Les notifications `new_message` existent dans `GET /api/v1/notifications`. Payload (inclut maintenant `conversation_type`) :

```json
{
  "type": "new_message",
  "sender_name": "Le Hiboo Events",
  "subject": "Question sur ma réservation",
  "conversation_uuid": "...",
  "conversation_type": "participant_vendor",
  "content_preview": "Bonjour, voici la confirmation...",
  "message": "Nouveau message de Le Hiboo Events : Bonjour...",
  "received_at": "2026-04-23T10:31:00+00:00"
}
```

Tap sur cette notification → router via `conversation_type` vers `/messages/{uuid}` ou `/messages/support/{uuid}`.

---

## Protection — Accès réservé aux utilisateurs connectés

Toutes les routes `/messages` sont protégées par le redirect global du `GoRouter`.

### Redirect router (`app_router.dart`)

```dart
// Dans le redirect global, après les vérifications onboarding / OTP :
if (state.matchedLocation.startsWith('/messages') &&
    authState.status == AuthStatus.unauthenticated) {
  return '/login';
}
```

**Couverture** :
- `/messages` (inbox)
- `/messages/:conversationUuid` (thread)
- `/messages/new`, `/messages/new/from-booking/:uuid`, `/messages/new/from-organizer/:uuid`
- `/messages/support/new`, `/messages/support/:conversationUuid`
- Deep links FCM → mêmes routes → redirect automatique

### GuestGuard sur les points d'entrée modaux

Les appels à `NewConversationForm.show()` depuis d'autres écrans (hors navigation) doivent être précédés d'un `GuestGuard.check()` pour éviter d'ouvrir un formulaire vide à un utilisateur non connecté.

**Implémenté** :
- `EventOrganizerCard._buildContactButton` — bouton "Contacter" sur la fiche organisateur

**Pattern** :

```dart
onPressed: () async {
  final allowed = await GuestGuard.check(
    context: context,
    ref: ref,
    featureName: 'contacter un organisateur',
  );
  if (!allowed || !context.mounted) return;
  NewConversationForm.show(context, conversationContext: ...);
},
```

`GuestGuard.check()` affiche le `GuestRestrictionDialog` si l'utilisateur n'est pas connecté, et retourne `false`. Aucun appel API n'est effectué dans ce cas.

---

## Points d'entrée depuis d'autres écrans

| Écran source | Bouton | Flow |
|---|---|---|
| Détail réservation | "Contacter l'organisateur" | `POST /user/conversations/from-booking/{bookingUuid}` → thread |
| Page publique organisateur | "Envoyer un message" | Bottom sheet formulaire → `POST /user/conversations/from-organization/{orgUuid}` |
| Page publique événement | "Contacter l'organisateur" | Même flow que page organisateur, avec `event_id` pré-rempli |
| Notification in-app (new_message) | Tap | Deep link `/messages/{conversationUuid}` |
| Résultat signalement | "Voir le suivi" | `/messages/support/{supportConversationUuid}` |

---

## Gestion des pièces jointes

### Sélection

- `image_picker` pour les images (caméra + galerie)
- `file_picker` pour les PDF

### Affichage dans les bulles

| Type | Rendu |
|------|-------|
| Image (jpg, png, webp) | Thumbnail inline (~220px largeur), tap → viewer plein écran |
| PDF | Icône + nom + taille formatée, tap → viewer externe |

### URLs MinIO

Les URLs pointent vers MinIO et peuvent être pré-signées (expiration). Ne pas mettre en cache longue durée.

---

## Sujets prédéfinis pour le support

Utiliser une liste locale (pas d'endpoint dédié) :

```dart
const supportSubjects = [
  'Problème de réservation',
  'Question sur un événement',
  'Problème de paiement',
  'Demande de remboursement',
  'Problème de compte',
  'Signalement d\'un contenu',
  'Autre',
];
```

---

## Navigation et deep links

| Deep link | Écran cible | Source |
|-----------|-------------|--------|
| `/messages` | Inbox onglet Organisateurs | BottomNav |
| `/messages/{conversationUuid}` | Thread detail | Notification tap, liste |
| `/messages/support` | Inbox onglet Support | BottomNav |
| `/messages/support/{conversationUuid}` | Thread support | Notification tap, liste |

Depuis une notification : extraire `conversation_uuid` + `conversation_type` du payload FCM ou in-app, router vers le bon écran.

---

## Résumé des endpoints utilisés

### Conversations organisateur

| Action | Méthode | Endpoint |
|--------|---------|----------|
| Lister | GET | `/user/conversations` |
| Badge non lus | GET | `/user/conversations/unread-count` |
| Filtrer par événement | GET | `/user/conversations/events` |
| Orgs contactables | GET | `/user/conversations/contactable-organizations` |
| Créer (dashboard) | POST | `/user/conversations` |
| Créer (réservation) | POST | `/user/conversations/from-booking/{bookingUuid}` |
| Créer (page org) | POST | `/user/conversations/from-organization/{orgUuid}` |
| Détail + mark-as-read | GET | `/user/conversations/{uuid}` |
| Envoyer message | POST | `/user/conversations/{uuid}/messages` |
| Éditer message | PATCH | `/user/conversations/{uuid}/messages/{messageUuid}` |
| Supprimer message | DELETE | `/user/conversations/{uuid}/messages/{messageUuid}` |
| Fermer | POST | `/user/conversations/{uuid}/close` |
| Signaler | POST | `/user/conversations/{uuid}/report` |

### Conversations support

| Action | Méthode | Endpoint |
|--------|---------|----------|
| Lister | GET | `/user/support-conversations` |
| Créer | POST | `/user/support-conversations` |
| Détail + mark-as-read | GET | `/user/support-conversations/{uuid}` |
| Envoyer message | POST | `/user/support-conversations/{uuid}/messages` |

Note : pas d'édition, suppression, fermeture ou signalement disponibles pour le participant sur les conversations support.

---

## Checklist de livraison

### Fonctionnalités de base
- [x] Inbox 2 onglets (Organisateurs + Support) avec pagination infinie
- [x] Badge unread dans la BottomNav (poll 30s)
- [x] Filtres : status, unread_only, search
- [x] Thread detail avec bulles alignées par `is_mine`
- [x] Messages système centrés
- [x] Messages supprimés : placeholder
- [x] Messages édités : label "(modifié)"
- [x] Indicateurs livraison/lecture (ticks) sur dernier message propre
- [x] Compose bar avec envoi texte + fichiers (multipart)
- [x] Validation fichiers côté client (3 max, 5 MB, types)
- [x] Images inline avec viewer plein écran
- [x] PDF cliquable avec ouverture externe
- [x] Long-press : éditer / supprimer / copier (vendor uniquement)
- [x] Envoi optimiste avec spinner et gestion erreur
- [x] Conversation fermée : composer désactivé + banner
- [x] Création depuis réservation (`from-booking`)
- [x] Création depuis page organisateur (`from-organization`)
- [x] Création depuis dashboard (sélection org contactable)
- [x] Création conversation support avec sujets prédéfinis
- [x] Deep link depuis notifications in-app
- [x] Pull-to-refresh sur la liste
- [x] État vide avec illustration

### Sécurité / Auth
- [x] **Router guard** : routes `/messages` redirigent vers `/login` si `status == unauthenticated`
- [x] **GuestGuard** : bouton "Contacter" sur `EventOrganizerCard` vérifie l'auth avant d'ouvrir le formulaire

### À corriger / compléter
- [x] **ConversationTile** : afficher `organization.logo_url` dans l'avatar (actuellement initiales colorées uniquement)
- [x] **ConversationTile** : preview pièces jointes avec comptage `is_image` ("Une image envoyée" etc.) au lieu de "(Fichier joint)" générique
- [x] **ConversationTile** : ne rien afficher (pas "Aucun message") quand `latest_message == null`
- [x] **ConversationTile** : badge statut 3 états — orange "En attente" / vert "Ouvert" / gris+lock "Fermé"
- [x] **ConversationTile** : fond orange (`orange.shade50`) + sujet en gras quand `unreadCount > 0`
- [x] **ConversationTile** : compteur non lus affiché en `99+` au lieu de `9+`
- [x] **Bouton Signaler** : remplacé par badge non-interactif `🚩 Signalé` si `user_has_reported = true`
- [x] **Dialog signalement** : commentaire requis (min 10 chars), état succès in-dialog avant fermeture
- [x] **Thread header** : chip événement cliquable si `conversation.event != null`
- [x] **Thread header** : bouton Fermer visible uniquement si `status == open`
- [x] **Thread detail** : séparateurs de date positionnés au-dessus de leur groupe de messages (fix reverse ListView)
- [ ] **Groupement par org** : implémenter le pattern Option B (sidebar org → liste conversations) pour aligner avec le web

### WebSocket (v2 — priorité haute)
- [ ] Connexion au channel `private-user.{userId}` via pusher_channels_flutter
- [ ] Handler `message.received` → refetch ou append selon le thread actif
- [ ] Handler `message.delivered` → maj ticks
- [ ] Handler `message.edited` → maj bulle en local
- [ ] Handler `message.deleted` → placeholder en local
- [ ] Handler `conversation.read` → ticks bleus
- [ ] Handler `conversation.created` → invalider liste
- [ ] Handler `conversation.closed` → verrouiller composer
- [ ] Handler `conversation.reopened` → déverrouiller composer
- [ ] Désactiver le polling quand WebSocket connecté

### Push FCM

- [x] Backend : `NewMessageNotification` implémente `HasPushNotification` + `toFcm()` via `PushPayload::newMessage()`
- [x] Backend : `conversationType` ajouté au payload database et FCM pour router correctement
- [ ] Backend ops : configurer `FCM_ENABLED=true` + credentials Firebase en env
- [ ] App mobile : enregistrer le token via `POST /api/v1/device-tokens` après login
- [ ] App mobile : supprimer le token via `DELETE /api/v1/device-tokens` au logout
- [ ] App mobile : handler FCM foreground/background → router via `conversation_type` vers le bon écran
