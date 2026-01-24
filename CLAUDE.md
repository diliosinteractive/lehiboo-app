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
