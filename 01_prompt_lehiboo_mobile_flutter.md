# 📱 PROMPT_LEHIBOO_MOBILE_FLUTTER.md
# Prompt complet pour générer toute l'application Flutter LeHiboo avec Gemini 3 Pro

---

## 🦉 1. CONTEXTE & OBJECTIF

LeHiboo est une application mobile hyper-locale qui aide les habitants et les familles à découvrir facilement :
- des activités,
- des sorties culturelles,
- des ateliers,
- des loisirs sportifs,
- des événements associatifs,
- des animations famille & enfants,
- des événements de quartier.

🎯 **Mission pour Gemini 3 Pro :**
Créer **toute l'application mobile Flutter LeHiboo**, avec une architecture scalable, une UI propre, une gestion d'état robuste et un module complet de réservation/billetterie.

L'app doit être **production-ready**, entièrement fonctionnelle et organisée par **features Flutter**.

---

## 🧱 2. ARCHITECTURE FLUTTER À RESPECTER

Architecture en **Clean Feature Architecture** :

```
lib/
├── core/
│   ├── constants/
│   ├── themes/
│   ├── utils/
│   └── widgets/
├── config/                 # API, Dio, Interceptors, Env
├── routes/                 # go_router
├── features/
│   ├── auth/
│   ├── home/
│   ├── search/
│   ├── events/
│   ├── booking/
│   ├── tickets/
│   ├── favorites/
│   ├── profile/
│   ├── calendar/
│   ├── editorial/
│   └── partners/
└── main.dart
```

Chaque feature suit :

```
feature/
├── data/          # DTO, models, datasources (remote/local)
├── domain/        # Entities, repositories abstraits, usecases
└── presentation/  # Screens, widgets, providers Riverpod
```

---

## 🎨 3. DESIGN SYSTEM FLUTTER (BASE)

### Couleurs principales
- `brandPrimary = Color(0xFFFF6B35)`
- `brandSecondary = Color(0xFFFF8C42)`
- `graySoft = Color(0xFFF5F5F7)`
- `textPrimary = Color(0xFF111827)`
- `textSecondary = Color(0xFF4B5563)`

### Typographies
- Titres : **Poppins**
- Corps : **Inter**

### Tokens (ThemeExtension)
- `spacing`: xs=4, s=8, m=12, l=16, xl=24, xxl=32
- `radius` : 16px
- Police Material 3

Un prompt séparé créera tous les composants UI.

---

## 🔍 4. FONCTIONNALITÉS À IMPLÉMENTER

### 4.1. Onboarding
- 3 écrans :
  - "Découvre quoi faire près de chez toi"
  - "Filtre par date, âge, budget"
  - "Réserve en quelques clics"
- Choix de la ville par défaut
- Geoloc facultative

---

### 4.2. Authentification
- Connexion / inscription email + mot de passe
- Reset password
- Possibilité future Google/Apple (prévoir architecture)
- Gestion de token + refresh token via `flutter_secure_storage`
- Profil utilisateur : nom, email, ville, centres d'intérêt

---

## 🏠 4.3. Home Page
Contient :
- Hero avec image + recherche rapide
- Champs : activité, ville, date, catégorie
- Filtres rapides : Aujourd’hui / Demain / Ce week-end
- Carrousel "Incontournables"
- Catégories principales (cartes)
- Villes principales
- Articles éditoriaux
- Témoignages
- Logo partenaires
- CTA "Espace Pro"
- Footer

Structure similaire à la maquette fournie.

---

## 🔎 4.4. Recherche avancée
Filtres :
- ville
- distance (0–50 km)
- date & horaire
- âges (multi-select)
- catégories
- tags
- intérieur / extérieur
- prix (gratuit / payant / max price)
- durée (0–30 / 30–60 / 60–120 / 120+)

Résultats :
- liste paginée
- bascule liste <-> carte (Google Maps)
- tri : pertinence, date, distance

---

## 📄 4.5. Page Activité
Doit afficher :
- visuel principal
- titre, catégorie, âge
- gratuit/payant + fourchette de prix
- durée
- lieu + carte
- description (markdown)
- organisateur + lien vers page partenaire
- tags
- prochain créneau

CTA :
- Réserver maintenant
- Favoris
- Partager

Modes de réservation :
- `lehiboo_free` (gratuit)
- `lehiboo_paid` (paiement+billets)
- `external_url`
- `phone`
- `email`

---

## 🧑‍🤝‍🧑 4.6. Page Partenaire
- logo, nom, description
- coordonnées
- réseaux sociaux
- liste d’activités
- badge partenaire vérifié

---

## 💛 4.7. Favoris
- Favoris d’activités
- Favoris villes (optionnel)
- Stockage local + sync cloud

---

## 📅 4.8. Agenda
- Vue calendrier
- Vue liste des réservations/favoris
- Export ICS
- Ajout au calendrier natif

---

## 📰 4.9. Articles
- Carrousel Home
- Listing articles
- Page article

---

## 🔔 4.10. Notifications
- Firebase Messaging
- Abonnements : ville, catégories, partenaires
- Deep-links : activity, booking, ticket

---

## 🧑‍💼 4.11. Espace Partenaire (mobile lite)
- Connexion partenaire
- Voir liste de ses activités
- Voir créneaux
- Voir réservations
- Check-in simple (sans scan dans MVP)

---

# 🎟️ 5. MODULE DE RÉSERVATION (APERÇU)
Un prompt séparé traitera la **logique complète**, mais l'app doit prévoir :

### Étapes :
1. Sélection créneau & quantité
2. Informations acheteur & participants
3. Paiement (Stripe ou stub)
4. Confirmation
5. Consultation billets (QR code)

Tickets : QR, statut, ajout calendrier.

---

# 🌐 6. API & INTÉGRATION WORDPRESS
L'app doit consommer :
- `/lehiboo/v1/activities`
- `/lehiboo/v1/slots`
- `/lehiboo/v1/bookings`
- `/lehiboo/v1/tickets`
- `/lehiboo/v1/editorial`
- `/lehiboo/v1/partners`

Mode mock : JSON en `assets/fixtures/*`.

---

# 🧪 7. TESTS
- Tests mapping DTO ↔ Domain
- Tests repository
- Tests widget : Home, Search, Activity
- Tests booking (sélection créneau, validation)
- Golden tests pour 2–3 écrans

---

# 🛠️ 8. OUTILS & DÉPENDANCES
- `flutter_riverpod`
- `go_router`
- `dio`
- `freezed`, `json_serializable`
- `cached_network_image`
- `sqflite`
- `flutter_secure_storage`
- `geolocator`
- `google_maps_flutter`
- `flutter_stripe`
- `qr_flutter`
- `firebase_messaging`
- `flutter_markdown`

---

# 📦 9. LIVRABLE ATTENDU PAR GEMINI
Gemini doit produire :

### Code Flutter réel :
- architecture complète du projet
- écrans principaux intégrés
- providers Riverpod
- modèles & DTO & repository
- UI (maquette respectée)
- navigation go_router
- datastore local + mock mode

### Documentation
- README Flutter
- Commentaires `TODO(lehiboo)` sur les zones à brancher

### Qualité
- pas de pseudo-code
- fichiers compilables
- structure claire et cohérente

---

# 🎯 OBJECTIF FINAL
Aider Gemini 3 Pro à générer :
👉 **Une application mobile Flutter LeHiboo entièrement fonctionnelle**, incluant :
- recherche avancée,
- gestion de créneaux,
- pages dynamiques,
- réservation complète,
- billets QR,
- favoris,
- agenda,
- notifications,
- espace partenaire.

Ce prompt constitue la **base globale**. Des prompts spécialisés complèteront :
- le backend WordPress,
- les composants UI,
- les modèles & mappers,
- la logique de réservation.

