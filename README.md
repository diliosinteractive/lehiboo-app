# LeHiboo Mobile App

LeHiboo est une plateforme hyper-locale qui aide les familles et les habitants à découvrir facilement des activités, sorties et événements près de chez eux.

## 🦉 À propos

Le Hiboo répond à la question "Qu'est-ce qu'on fait ce soir, ce week-end ?" de façon simple et fiable en permettant de :

### 👥 Pour les utilisateurs :
- Recherche rapide par lieu, date, âge, catégorie
- Filtres pratiques (intérieur/extérieur, gratuit/payant, durée, public visé)
- Réservation directe via la plateforme
- Comptes personnels pour favoris, notifications, gestion des réservations

### 🏢 Pour les partenaires :
- Tableau de bord pour gérer événements, créneaux et réservations
- Statistiques détaillées (vues, réservations, profils utilisateurs)
- Mise en avant payante (options de visibilité, publicité locale)
- Outil SAAS de gestion (créneaux-first)

## 🏗️ Architecture

Cette application Flutter suit une architecture Clean Architecture avec :

```
lib/
├── core/                    # Utilities, constants, widgets partagés
│   ├── constants/
│   ├── themes/
│   ├── utils/
│   └── widgets/
├── features/               # Features par domaine métier
│   ├── auth/              # Authentification
│   ├── events/            # Gestion des événements
│   ├── home/              # Page d'accueil
│   ├── search/            # Recherche et filtres
│   ├── favorites/         # Favoris
│   ├── profile/           # Profil utilisateur
│   ├── booking/           # Réservations
│   └── partners/          # Partenaires
├── config/                # Configuration (API, services)
└── routes/                # Navigation et routing
```

Chaque feature suit la structure :
```
feature/
├── data/                  # Sources de données, models, repositories
├── domain/                # Entities, repositories abstraits, use cases
└── presentation/          # Screens, widgets, providers (state management)
```

## 🚀 Démarrage

### Prérequis
- Flutter 3.5.4+
- Dart 3.0+
- Android Studio / VS Code
- Git

### Installation

1. Installez les dépendances :
```bash
flutter pub get
```

2. Configurez les variables d'environnement :
```bash
# Éditez .env avec vos clés API
```

3. Générez le code (modèles, routing, etc.) :
```bash
flutter packages pub run build_runner build
```

4. Lancez l'application :
```bash
flutter run
```

## 📦 Dépendances principales

### State Management & Navigation
- `flutter_riverpod` : Gestion d'état
- `go_router` : Navigation déclarative

### Réseau & API
- `dio` : Client HTTP
- `retrofit` : API REST type-safe
- `cached_network_image` : Cache d'images

### UI & Design
- `google_fonts` : Polices Google
- `flutter_svg` : Support SVG
- `shimmer` : Effets de chargement

### Fonctionnalités
- `google_maps_flutter` : Cartes
- `geolocator` : Géolocalisation
- `image_picker` : Sélection d'images
- `shared_preferences` : Stockage local

## 🎨 Design System

L'application utilise :
- **Couleur principale** : Orange (#FF6B35)
- **Couleur secondaire** : Orange clair (#FF8C42)
- **Police** : Poppins (titres) + Inter (corps)
- **Icônes** : Material Icons + icônes personnalisées

## 🧪 Tests

```bash
# Tests unitaires
flutter test

# Tests d'intégration
flutter test integration_test/

# Coverage
flutter test --coverage
```

## 📱 Build

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## 🔧 Scripts utiles

```bash
# Génération de code
flutter packages pub run build_runner build --delete-conflicting-outputs

# Nettoyage
flutter clean && flutter pub get

# Analyse du code
flutter analyze

# Formatage
dart format .
```

## 🏗️ Structure des features

### Events (Événements)
- Listing et détail des événements
- Filtres avancés (catégorie, date, prix, distance)
- Géolocalisation et cartes
- Système de favoris

### Booking (Réservations)
- Processus de réservation
- Gestion des créneaux
- Confirmation et billets
- Historique des réservations

### Search (Recherche)
- Recherche textuelle
- Filtres multiples
- Géolocalisation
- Suggestions et historique

## 🤝 Contribution

1. Fork le projet
2. Créez une branche feature (`git checkout -b feature/amazing-feature`)
3. Committez vos changements (`git commit -m 'Add amazing feature'`)
4. Push vers la branche (`git push origin feature/amazing-feature`)
5. Ouvrez une Pull Request

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.

## 📞 Support

- Email : support@lehiboo.fr
- Site web : https://lehiboo.fr
- Documentation : https://docs.lehiboo.fr
