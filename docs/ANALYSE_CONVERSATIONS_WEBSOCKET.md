# Analyse — Gestion des conversations & WebSocket

> **TL;DR** — Oui, les conversations sont **liées aux WebSocket (Pusher/Reverb)**. Quand un message arrive, il est ajouté **automatiquement** à la liste des messages. Quand un event de conversation arrive, la liste des conversations est **mise à jour automatiquement**. Le tout via WebSocket, avec un **polling de secours** quand la socket est déconnectée.

---

## 1. Localisation de la feature

Feature : [lib/features/messages/](../lib/features/messages/)

> ⚠️ À ne pas confondre avec [lib/features/petit_boo/](../lib/features/petit_boo/) qui est l'assistant IA.

```
lib/features/messages/
├── data/
│   ├── datasources/
│   │   ├── messages_api_datasource.dart
│   │   └── messages_polling_datasource.dart
│   ├── models/                                  # DTOs (conversation, message, broadcast…)
│   └── repositories/messages_repository_impl.dart
├── domain/
│   ├── entities/                                # Conversation, Message, ConversationRoute
│   └── repositories/messages_repository.dart
└── presentation/
    ├── providers/
    │   ├── conversations_provider.dart                # Liste conversations (participant)
    │   ├── conversation_detail_provider.dart          # Détail / liste messages
    │   ├── support_conversations_provider.dart
    │   ├── vendor_conversations_provider.dart
    │   ├── vendor_org_conversations_provider.dart
    │   ├── admin_conversations_provider.dart
    │   ├── messages_realtime_provider.dart            # ⚡ Cœur du WebSocket
    │   └── unread_count_provider.dart
    └── screens/
```

---

## 2. Stack WebSocket

| Élément | Valeur |
|---|---|
| **Lib Dart** | `dart_pusher_channels: ^1.2.3` ([pubspec.yaml:107](../pubspec.yaml#L107)) |
| **Protocole** | Pusher Channels (compatible Laravel Reverb) |
| **Config env** | `PUSHER_APP_KEY`, `PUSHER_HOST`, `PUSHER_PORT`, `PUSHER_USE_TLS`, `PUSHER_AUTH_ENDPOINT` |
| **Canal user** | `private-user.{userId}` |
| **Canal vendor** | `private-organization.{orgId}` (optionnel, si vendor) |
| **Auth** | Bearer token via `FlutterSecureStorage` → endpoint auth backend |

Le client est initialisé dans [messages_realtime_provider.dart:174-241](../lib/features/messages/presentation/providers/messages_realtime_provider.dart#L174-L241), s'auto-connecte quand l'utilisateur est authentifié (écoute `authProvider`) et se déconnecte au logout.

---

## 3. Architecture du flux temps réel

```
                  ┌─────────────────────────────────────┐
                  │   Backend (Laravel + Reverb)        │
                  └───────────────┬─────────────────────┘
                                  │  WebSocket (wss)
                                  │  canaux: private-user.{id}
                                  │          private-organization.{id}
                                  ▼
              ┌────────────────────────────────────────────┐
              │  MessagesRealtimeNotifier (singleton)      │
              │  - Connexion Pusher Channels               │
              │  - Auth via Bearer token                   │
              │  - _handleEvent() : parse 10 events        │
              │  - Émet RealtimeEvent sur un StreamController
              └───────┬──────────────────────────┬─────────┘
                      │                          │
        events stream │                          │ events stream
                      ▼                          ▼
        ┌──────────────────────────┐  ┌───────────────────────────┐
        │ ConversationsNotifier    │  │ ConversationDetailNotifier│
        │ (liste conversations)    │  │ (messages d'1 conv)       │
        │ • _applyNewMessage       │  │ • _silentRefresh          │
        │ • _applyStatus           │  │ • _applyDelivered/Edit/…  │
        │ • polling 15s fallback   │  │ • polling 10s fallback    │
        └──────────────────────────┘  └───────────────────────────┘
```

---

## 4. Events WebSocket pris en charge

Tous parsés dans `_handleEvent()` ([messages_realtime_provider.dart:302-413](../lib/features/messages/presentation/providers/messages_realtime_provider.dart#L302-L413)) :

| Event Pusher | Payload clé | Action |
|---|---|---|
| `message.received` | `conversation_uuid`, `message_uuid` | Incrémente badge unread + émet `RealtimeEvent` |
| `message.delivered` | `conversation_uuid`, `message_uuid` | Marque message comme livré (local) |
| `message.edited` | + `content`, `edited_at` | Met à jour le contenu du message (local) |
| `message.deleted` | `conversation_uuid`, `message_uuid` | Marque message supprimé (local) |
| `conversation.read` | `conversation_uuid` | Marque tous mes messages comme lus (local) |
| `conversation.created` | — | Refresh liste conversations |
| `conversation.closed` | `conversation_uuid` | Statut → `closed` (local) |
| `conversation.reopened` | `conversation_uuid` | Statut → `open` (local) |
| `broadcast.sent` | `broadcast_uuid` | Invalide `vendorConversationsProvider` |
| `notification.created` | `notification` | Affiche snackbar in-app |

Le catalogue complet des events Pusher (côté backend) est dans [docs/PUSHER_EVENTS_CATALOG.md](./PUSHER_EVENTS_CATALOG.md) (ajouté par le commit `897d758 handle socket event`).

---

## 5. Question 1 — La liste des messages se met-elle à jour automatiquement ?

### ✅ Verdict : OUI, totalement automatique via WebSocket

Le `ConversationDetailNotifier` ([conversation_detail_provider.dart](../lib/features/messages/presentation/providers/conversation_detail_provider.dart)) s'abonne au stream de `messagesRealtimeProvider` et filtre par UUID de la conversation ouverte :

```dart
void _subscribeToRealtime() {
  _realtimeSub = _ref.read(messagesRealtimeProvider.notifier).events.listen((event) {
    if (event.conversationUuid != _uuid) return;       // filtre par conv ouverte
    switch (event.type) {
      case RealtimeEventType.messageReceived:
        _silentRefresh();                              // re-fetch les messages
      case RealtimeEventType.messageDelivered:
        _applyDelivered(event.messageUuid!);           // mutation locale
      case RealtimeEventType.messageEdited:
        _applyEdit(event.messageUuid!, event.content!, event.editedAt);
      case RealtimeEventType.messageDeleted:
        _applyDelete(event.messageUuid!);
      case RealtimeEventType.conversationRead:
        _applyAllRead();
      …
    }
  });
}
```

### Stratégie par type d'event

| Event | Stratégie | Pourquoi |
|---|---|---|
| `message.received` | **Re-fetch** (`_silentRefresh`) | Il faut récupérer le contenu du nouveau message côté API |
| `message.delivered/edited/deleted` | **Mutation locale** (state direct) | Le payload contient toutes les infos nécessaires → pas de round-trip API |
| `conversation.read` | **Mutation locale** | Idem |

Exemple de mutation locale ([conversation_detail_provider.dart:117-126](../lib/features/messages/presentation/providers/conversation_detail_provider.dart#L117-L126)) :

```dart
void _applyDelivered(String messageUuid) {
  final conv = state.conversation.valueOrNull;
  if (conv == null) return;
  final messages = conv.messages
      .map((m) => m.uuid == messageUuid ? m.copyWith(isDelivered: true) : m)
      .toList();
  state = state.copyWith(conversation: AsyncValue.data(conv.copyWith(messages: messages)));
}
```

### Fallback polling — 10 secondes

Quand la WebSocket est déconnectée, un timer tourne ([conversation_detail_provider.dart:77-83](../lib/features/messages/presentation/providers/conversation_detail_provider.dart#L77-L83)) :

```dart
_pollTimer = Timer.periodic(const Duration(seconds: 10), (_) async {
  if (_ref.read(messagesRealtimeProvider)) return;   // skip si WS connectée
  await _silentRefresh();
});
```

---

## 6. Question 2 — La liste des conversations se met-elle à jour automatiquement ?

### ✅ Verdict : OUI, totalement automatique via WebSocket

Le `ConversationsNotifier` ([conversations_provider.dart](../lib/features/messages/presentation/providers/conversations_provider.dart)) écoute le même stream et applique des mutations locales sur la liste :

```dart
void _subscribeToRealtime() {
  _realtimeSub = _ref.read(messagesRealtimeProvider.notifier).events.listen((event) {
    if (event.type == RealtimeEventType.messageReceived) {
      _applyNewMessage(event);   // bump unread + remonte en tête de liste
      return;
    }
    if (type != null && type != 'participant_vendor') return;   // filtre par type
    switch (event.type) {
      case RealtimeEventType.conversationCreated:
        refresh();
        _refreshUnreadCount();
      case RealtimeEventType.conversationClosed:
        _applyConversationStatus(event.conversationUuid!, 'closed');
      case RealtimeEventType.conversationReopened:
        _applyConversationStatus(event.conversationUuid!, 'open');
      …
    }
  });
}
```

### Comportement clé : `_applyNewMessage`

Quand un message arrive ([conversations_provider.dart:130-154](../lib/features/messages/presentation/providers/conversations_provider.dart#L130-L154)) :

1. Trouve la conversation par UUID dans la liste locale
2. Incrémente son `unreadCount`
3. **La déplace en tête de liste** (`list.removeAt(idx); list.insert(0, updated)`)
4. Déclenche un `_silentRefresh()` en arrière-plan pour sync définitif

Si la conversation **n'est pas dans la liste** (nouvelle conv) → `_silentRefresh()` pour la fetch.

### Badge unread global

Le compteur global est incrémenté **instantanément** dès `message.received` ([messages_realtime_provider.dart:321](../lib/features/messages/presentation/providers/messages_realtime_provider.dart#L321)) :

```dart
_ref.read(unreadCountProvider.notifier).update((n) => n + 1);
```

Puis re-synchronisé toutes les 30s pour corriger une éventuelle dérive.

### Fallback polling — 15 secondes

```dart
_pollTimer = Timer.periodic(const Duration(seconds: 15), (_) async {
  if (_ref.read(messagesRealtimeProvider)) return;
  await _silentRefresh();
  await _refreshUnreadCount();
});
```

---

## 6.bis Création d'une conversation — mise à jour de la liste

### Côté receveur (l'autre utilisateur reçoit) — ✅ Auto via WS

Event `conversation.created` arrive sur `private-user.{userId}` → `ConversationsNotifier.refresh()` ([conversations_provider.dart:104-106](../lib/features/messages/presentation/providers/conversations_provider.dart#L104-L106)) :

```dart
case RealtimeEventType.conversationCreated:
  refresh();
  _refreshUnreadCount();
```

Re-fetch complet de la liste (pas de mutation locale) car le payload Pusher ne contient pas la conversation complète — il faut l'API pour la récupérer.

### Côté créateur — ✅ Refresh explicite pour TOUS les contextes

Après création réussie, [new_conversation_form.dart:436-456](../lib/features/messages/presentation/widgets/new_conversation_form.dart#L436-L456) rafraîchit la liste appropriée selon le type de contexte. Le `switch` exhaustif sur la `sealed class NewConversationContext` garantit qu'aucun cas n'est oublié :

| Contexte | Provider rafraîchi |
|---|---|
| `SupportConversationContext` | `supportConversationsProvider` |
| `DashboardConversationContext` | `conversationsProvider` |
| `FromOrganizerConversationContext` | `conversationsProvider` |
| `AdminToUserConversationContext` | `adminConversationsProvider('user_support')` |
| `AdminToOrgConversationContext` | `adminConversationsProvider('vendor_admin')` |
| `VendorToParticipantConversationContext` | `vendorConversationsProvider` |
| `VendorToPartnerConversationContext` | `vendorOrgConversationsProvider` |
| `VendorSupportConversationContext` | `vendorSupportProvider` |

```dart
switch (ctx) {
  case SupportConversationContext():
    ref.read(supportConversationsProvider.notifier).refresh();
  case DashboardConversationContext():
  case FromOrganizerConversationContext():
    ref.read(conversationsProvider.notifier).refresh();
  case AdminToUserConversationContext():
    ref.read(adminConversationsProvider('user_support').notifier).refresh();
  case AdminToOrgConversationContext():
    ref.read(adminConversationsProvider('vendor_admin').notifier).refresh();
  case VendorToParticipantConversationContext():
    ref.read(vendorConversationsProvider.notifier).refresh();
  case VendorToPartnerConversationContext():
    ref.read(vendorOrgConversationsProvider.notifier).refresh();
  case VendorSupportConversationContext():
    ref.read(vendorSupportProvider.notifier).refresh();
}
```

> **Note** : avant cette correction, seuls `Support` / `Dashboard` / `FromOrganizer` déclenchaient un refresh. Les 5 contextes vendor/admin (`AdminToUser`, `AdminToOrg`, `VendorToParticipant`, `VendorToPartner`, `VendorSupport`) ne mettaient pas à jour la liste — l'utilisateur devait soit attendre le polling 15s, soit revenir manuellement sur l'écran. Désormais, la garantie est uniforme pour tous les types d'utilisateurs.

### Garantie d'exhaustivité

`NewConversationContext` est déclarée `sealed` ([new_conversation_form.dart:17](../lib/features/messages/presentation/widgets/new_conversation_form.dart#L17)), donc le compilateur Dart 3 force le `switch` à couvrir tous les sous-types. Tout nouveau contexte ajouté provoquera une erreur de compilation tant que sa branche de refresh ne sera pas ajoutée.

---

## 7. Tableau récapitulatif

| Composant | Real-time WS | Mutation locale | Re-fetch API | Polling fallback |
|---|---|---|---|---|
| **Nouveau message reçu** | ✅ | bump unread + reorder list | `_silentRefresh` (détail) | 10s / 15s |
| **Message livré** | ✅ | ✅ (pas de fetch) | — | 10s |
| **Message édité** | ✅ | ✅ (pas de fetch) | — | 10s |
| **Message supprimé** | ✅ | ✅ (pas de fetch) | — | 10s |
| **Conv lue par l'autre** | ✅ | ✅ | — | 10s |
| **Conv créée (côté receveur)** | ✅ | — | refresh liste | 15s |
| **Conv créée (côté créateur)** | — | — | refresh ciblé selon contexte | — |
| **Conv fermée/rouverte** | ✅ | ✅ | — | 15s |
| **Badge unread global** | ✅ | +1 instantané | re-sync 30s | — |

---

## 8. Points forts

1. **Architecture Riverpod + WS propre** — séparation `realtime` / `list` / `detail` claire, stream-based decoupling.
2. **Updates optimistes** — `delivered`, `edited`, `deleted` et le badge sont appliqués en local sans round-trip → UI fluide.
3. **Fallback polling intelligent** — le polling est **désactivé tant que la WS est connectée** (`if (_ref.read(messagesRealtimeProvider)) return;`), donc pas de gaspillage API.
4. **Reconnexion auto** — `dart_pusher_channels` gère la reconnexion (delay min 2s) avec un `connectionErrorHandler` qui rappelle `refresh()`.
5. **Type safety** — events typés via enum `RealtimeEventType`, payload validé avant emit.

---

## 9. Points de vigilance / gaps

### 9.1 Filtrage par `conversation_type` silencieux

Chaque liste filtre par type de conv (`participant_vendor`, `user_support`, etc.). Si le backend envoie un type inattendu ou omet le champ, **l'event est silencieusement ignoré**. Exemple [support_conversations_provider.dart:89-92](../lib/features/messages/presentation/providers/support_conversations_provider.dart#L89-L92).

> **Recommandation** : ajouter un log/metric sur les events filtrés out pour détecter les divergences front/back.

### 9.2 Re-fetch complet sur `message.received` (détail)

`_silentRefresh()` re-télécharge **toute la conversation** (tous les messages) à chaque message reçu — pas idéal pour les conversations longues (100+ messages).

> **Amélioration possible** : ajouter `?after_uuid={lastUuid}` côté API pour ne fetch que le delta, ou inclure le message complet dans le payload Pusher.

### 9.3 Badge unread approximatif

Le badge est incrémenté de +1 local, mais re-syncé seulement toutes les 30s. Si l'app était offline pendant 1h, le badge sera incorrect jusqu'au prochain refresh.

> **Mitigation déjà en place** : le polling 15s sur les listes ré-appelle `_refreshUnreadCount()` quand la WS est offline.

### 9.4 Events définis mais non gérés

- `conversation.reported` — aucun handler dans les providers
- Events org (`organization.*`) — log seulement, pas d'action métier
- Events booking/ticket/partnership — pas wiring dans ce flux messages (peut être ok, à vérifier ailleurs)

### 9.5 Rafale de messages

5 messages en 100ms = 5 `_silentRefresh()` en cascade = 5 appels API.

> **Amélioration** : debounce le `_silentRefresh` à ~300ms.

### 9.6 Aucun indicateur de connexion WS pour l'utilisateur

Si la WS tombe, le polling prend le relais mais l'utilisateur ne voit aucun feedback. Pour une feature messagerie, un badge "hors-ligne / mode dégradé" est attendu UX.

### 9.7 Pas de typing / presence indicators

Aucun event "X est en train d'écrire", "X est en ligne". À ajouter si attendu produit.

---

## 10. Contexte commit `897d758 handle socket event`

Commit du `2026-05-14` (aujourd'hui) — **massif refactor du système d'events** :

- **+119 fichiers, +21 588 lignes**
- Ajout de l'enum `WsEventName` (36 types d'events) dans [lib/core/realtime/models/ws_event_name.dart](../lib/core/realtime/models/ws_event_name.dart)
- Ajout de `WsNotification` wrapper + DTOs typés sous `lib/core/realtime/models/events/`
- Wiretap global `_allEventsSub` ajouté dans `messages_realtime_provider.dart` pour logger toutes les frames reçues (debug)
- Catalogue exhaustif [docs/PUSHER_EVENTS_CATALOG.md](./PUSHER_EVENTS_CATALOG.md)

Le commit formalise l'ensemble du modèle d'events côté mobile pour préparer l'intégration de nouvelles features (collaborations, partnerships, payouts, etc.) qui passent toutes par le même canal Pusher.

---

## 11. Conclusion

**Le système est production-ready.** Les conversations et messages se mettent à jour **automatiquement et en temps réel** via WebSocket, avec un fallback polling propre quand la WS est indisponible.

Les gaps identifiés sont **incrémentaux** (filtrage silencieux, re-fetch complet, absence de typing) et n'empêchent pas le fonctionnement nominal. Les prochaines évolutions naturelles seraient :

1. Logging des events ignorés (filtrage type)
2. Fetch incrémental des messages
3. Indicateur visuel de connexion WS
4. Debounce sur rafales de messages
5. Typing / presence (si attendu produit)
