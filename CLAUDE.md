# Instructions Développement Le Hiboo - App Flutter

## Stack Technique

| Composant | Version | Description |
|-----------|---------|-------------|
| **Framework** | Flutter 3.x | Framework mobile cross-platform |
| **Langage** | Dart | Langage de programmation |
| **Architecture** | Clean Architecture | Separation of concerns |
| **State** | Riverpod | Gestion d'état réactive |
| **API** | Dio | Client HTTP |

---

## CRITIQUE - Identifiants Event (UUID vs ID numérique)

**Le backend Laravel utilise `uuid` comme identifiant pour les routes API.**

### Règle obligatoire :

Quand on mappe un `EventDto` vers une entité `Event`, toujours utiliser l'UUID :

```dart
// ❌ FAUX - utilise le hash numérique
id: dto.id.toString(),

// ✅ CORRECT - utilise l'UUID avec fallback
id: dto.uuid ?? dto.id.toString(),
```

### Pourquoi ?

- `EventDto.id` (int) : Hash numérique généré par `_parseEventId()` - utilisé pour les comparaisons internes
- `EventDto.uuid` (String) : UUID réel de l'API - **requis pour les appels API**
- Les routes Laravel comme `/favorites/{event}/toggle` attendent l'UUID via `getRouteKeyName()`

### Symptôme du bug :

```
POST /api/v1/me/favorites/1032995507/toggle
→ 404 Not Found: "Resource not found."
```

L'app envoyait un hash numérique au lieu de l'UUID (format: `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`).

---

## Structure Projet

```
lib/
├── core/                         # Configuration, DI, routing
│   ├── config/
│   ├── di/
│   └── routing/
├── features/                     # Features par domaine
│   ├── auth/
│   ├── events/
│   │   ├── data/
│   │   │   ├── mappers/         # EventMapper (conversion DTO → Entity)
│   │   │   ├── models/          # EventDto (modèles API)
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/        # Event (entité métier)
│   │   │   └── repositories/
│   │   └── presentation/
│   ├── favorites/
│   ├── home/
│   └── ...
└── shared/                       # Composants partagés
```

---

## API Backend

| Service | URL Dev | URL Prod |
|---------|---------|----------|
| API | http://api.lehiboo.localhost | https://api.lehiboo.com |

### Endpoints utilisés :

| Endpoint | Description |
|----------|-------------|
| `GET /v1/home-feed` | Feed homepage |
| `GET /v1/events` | Liste événements |
| `GET /v1/events/{identifier}` | Détail événement (UUID ou slug) |
| `GET /v1/events/{uuid}/availability` | Disponibilité événement |
| `POST /v1/me/favorites/{uuid}/toggle` | Toggle favori |
| `GET /v1/me/favorites` | Liste favoris |
| `GET /v1/me/alerts` | Liste recherches sauvegardées |
| `POST /v1/me/alerts` | Créer une recherche sauvegardée |
| `DELETE /v1/me/alerts/{id}` | Supprimer une recherche |

---

## Feature : Recherches Sauvegardées (Alerts)

### Architecture

```
lib/features/alerts/
├── data/
│   ├── datasources/alerts_api_datasource.dart   # Appels API
│   ├── models/alert_dto.dart                    # DTO avec search_criteria
│   └── repositories/alerts_repository_impl.dart
├── domain/
│   ├── entities/alert.dart                      # Entity avec EventFilter
│   └── repositories/alerts_repository.dart
└── presentation/
    ├── providers/alerts_provider.dart           # StateNotifier + isFilterSaved()
    └── screens/alerts_list_screen.dart
```

### Création d'une alerte

```dart
// Provider accepte enablePush et enableEmail explicitement
await ref.read(alertsProvider.notifier).createAlert(
  name: 'Ma recherche',
  filter: currentFilter,
  enablePush: true,   // Notifications push
  enableEmail: false, // Notifications email
);
```

### Vérifier si un filtre est déjà sauvegardé

```dart
final isAlreadySaved = ref.read(alertsProvider.notifier).isFilterSaved(filter);
```

La comparaison vérifie : `searchQuery`, `citySlug`, `latitude/longitude`, `dateFilterType`, `categoriesSlugs`, `thematiquesSlugs`, et les options booléennes.

---

## Feature : Widgets de Recherche

### Composants

| Widget | Fichier | Usage |
|--------|---------|-------|
| `HomeSearchPill` | `home_search_pill.dart` | Pilule de recherche sur la home avec badge filtres |
| `AirbnbSearchSheet` | `airbnb_search_sheet.dart` | Modal plein écran avec accordéons (Où/Quand/Quoi) |
| `SaveSearchSheet` | `save_search_sheet.dart` | Modal sauvegarde avec toggles Push/Email |
| `FilterBottomSheet` | `filter_bottom_sheet.dart` | Bottom sheet filtres avec cards |
| `FilterSharedComponents` | `filter_shared_components.dart` | Composants UI réutilisables |

### Ouvrir la recherche depuis la home

```dart
// Ouvre le modal plein écran (cache la bottom nav)
AirbnbSearchSheet.show(context);
```

### Ouvrir le modal de sauvegarde

```dart
final result = await SaveSearchSheet.show(context, filter: currentFilter);
if (result != null) {
  // result.name, result.enablePush, result.enableEmail
}
```

---

## Instructions Git

**Ne JAMAIS ajouter de Co-Authored-By dans les commits.**

---

## Conventions de Code

### Dart/Flutter

```dart
// Classes : PascalCase
class EventMapper {}

// Fichiers : snake_case
event_mapper.dart

// Variables/Méthodes : camelCase
final eventList = [];
void fetchEvents() {}

// Constantes : lowerCamelCase ou SCREAMING_SNAKE_CASE
const apiBaseUrl = 'https://...';
const API_TIMEOUT = 30000;
```

### Architecture Clean

```
Data Layer (data/)
├── models/          # DTOs (JSON serialization)
├── mappers/         # DTO → Entity conversion
├── datasources/     # API calls
└── repositories/    # Repository implementations

Domain Layer (domain/)
├── entities/        # Business objects
├── repositories/    # Repository interfaces
└── usecases/        # Business logic

Presentation Layer (presentation/)
├── screens/         # Pages/Screens
├── widgets/         # UI components
└── providers/       # State management
```

---

## Feature : Petit Boo (Assistant IA)

### Architecture

```
lib/features/petit_boo/
├── data/
│   ├── datasources/
│   │   ├── petit_boo_api_datasource.dart    # REST API (quota, sessions)
│   │   ├── petit_boo_sse_datasource.dart    # SSE streaming chat
│   │   └── petit_boo_context_storage.dart   # Stockage contexte local
│   └── models/
│       ├── chat_message_dto.dart            # Messages
│       ├── quota_dto.dart                   # Quota utilisateur
│       ├── conversation_dto.dart            # Sessions/conversations
│       ├── petit_boo_event_dto.dart         # Events SSE
│       └── tool_result_dto.dart             # Résultats outils MCP
├── domain/
│   └── repositories/petit_boo_repository.dart
└── presentation/
    ├── providers/
    │   ├── petit_boo_chat_provider.dart     # State principal
    │   ├── conversation_list_provider.dart  # Liste conversations
    │   └── engagement_provider.dart         # Bulles engagement
    ├── screens/
    │   ├── petit_boo_chat_screen.dart       # Écran chat
    │   ├── petit_boo_brain_screen.dart      # Gestion mémoire
    │   └── conversation_list_screen.dart    # Historique
    └── widgets/
        ├── chat_input_bar.dart              # Barre saisie
        ├── message_bubble.dart              # Bulles messages
        ├── streaming_message_bubble.dart    # Streaming en cours
        ├── typing_indicator.dart            # Animation "écrit..."
        ├── limit_reached_dialog.dart        # Dialog limite atteinte
        └── tool_results/                    # 8 widgets outils MCP
```

### URLs Backend

| Env | URL |
|-----|-----|
| Dev | http://petitboo.lehiboo.localhost |
| Prod | https://petitboo.lehiboo.com |

**Note:** Ajouter `127.0.0.1 petitboo.lehiboo.localhost` dans `/etc/hosts` pour le dev local.

### Endpoints

| Endpoint | Description |
|----------|-------------|
| `GET /health/ready` | Health check |
| `POST /api/v1/chat` | Chat SSE streaming |
| `GET /api/v1/quota` | Quota utilisateur |
| `GET /api/v1/sessions` | Liste conversations |
| `GET /api/v1/sessions/{uuid}` | Détail conversation |
| `POST /api/v1/sessions` | Créer conversation |
| `DELETE /api/v1/sessions/{uuid}` | Supprimer conversation |

### Events SSE

| Event | Description |
|-------|-------------|
| `session` | UUID nouvelle session |
| `token` | Token texte streaming |
| `tool_call` | Outil MCP en cours d'appel |
| `tool_result` | Résultat outil MCP (events, bookings, etc.) |
| `error` | Erreur |
| `done` | Fin du stream |

### Routes Flutter

| Route | Description |
|-------|-------------|
| `/petit-boo` | Chat principal |
| `/petit-boo?session=xxx` | Reprendre session existante |
| `/petit-boo?message=xxx` | Message initial (depuis VoiceFab) |
| `/petit-boo/history` | Historique conversations |
| `/petit-boo/brain` | Gestion mémoire utilisateur |

### VoiceFab

Widget flottant central avec reconnaissance vocale :
- **Tap** = Affiche tooltip "Maintiens pour parler"
- **Double-tap** = Ouvre le chat classique
- **Long-press** = Active l'écoute vocale avec animations

### Outils MCP disponibles

| Outil | Description |
|-------|-------------|
| `search_events` | Recherche d'événements |
| `get_event_details` | Détails d'un événement |
| `list_bookings` | Liste des réservations |
| `get_booking_details` | Détails d'une réservation |
| `list_favorites` | Liste des favoris |
| `toggle_favorite` | Ajouter/retirer favori |
| `get_recommendations` | Recommandations personnalisées |
| `get_user_context` | Contexte utilisateur |
