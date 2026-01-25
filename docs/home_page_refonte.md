# Refonte Page d'Accueil Le Hiboo

## Vue d'ensemble

La page d'accueil a été entièrement refactorisée pour offrir une expérience immersive axée sur la découverte d'événements. L'objectif est de créer un effet "WAOUH" avec des animations premium, une personnalisation intelligente et des éléments FOMO (Fear Of Missing Out).

---

## Architecture

### Structure du Feed

```
┌─────────────────────────────────────────────┐
│  APPBAR (transparente → opaque au scroll)   │
├─────────────────────────────────────────────┤
│  HERO CONTEXTUEL (parallax)                 │
│  Titre dynamique selon contexte             │
│  + Search pill intégrée                     │
├─────────────────────────────────────────────┤
│  STORIES (événements trending)              │
│  ○ ○ ○ ○ ○ → tap = viewer plein écran      │
├─────────────────────────────────────────────┤
│  VOS RECHERCHES (alertes sauvegardées)      │
├─────────────────────────────────────────────┤
│  FILTRER PAR VILLE (chips horizontaux)      │
├─────────────────────────────────────────────┤
│  AVANT QU'IL SOIT TROP TARD (countdown)     │
│  Timer temps réel + animation pulse         │
├─────────────────────────────────────────────┤
│  BANNIÈRES PUBLICITAIRES                    │
├─────────────────────────────────────────────┤
│  ACTIVITÉS AUJOURD'HUI (carousel)           │
│  ACTIVITÉS DEMAIN (carousel)                │
│  LES RECOMMANDATIONS (carousel)             │
├─────────────────────────────────────────────┤
│  POUR VOUS (grille 2 colonnes, scoring)     │
├─────────────────────────────────────────────┤
│  THÉMATIQUES                                │
├─────────────────────────────────────────────┤
│  SÉLECTION PARTENAIRE PREMIUM               │
├─────────────────────────────────────────────┤
│  CATÉGORIES (chips)                         │
├─────────────────────────────────────────────┤
│  PUB NATIVE (Sponsorisé)                    │
├─────────────────────────────────────────────┤
│  CTA SITE WEB                               │
│  VILLES POPULAIRES                          │
│  BLOG                                       │
│  NEWSLETTER                                 │
└─────────────────────────────────────────────┘
```

### Fichiers

| Fichier | Emplacement | Description |
|---------|-------------|-------------|
| `home_screen.dart` | `lib/features/home/presentation/screens/` | Écran principal refactorisé |
| `contextual_hero.dart` | `lib/features/home/presentation/widgets/` | Hero avec titres dynamiques et parallax |
| `event_stories.dart` | `lib/features/home/presentation/widgets/` | Stories événements style Instagram |
| `countdown_event_card.dart` | `lib/features/home/presentation/widgets/` | Card FOMO avec timer temps réel |
| `personalized_section.dart` | `lib/features/home/presentation/widgets/` | Section "Pour vous" avec scoring |
| `native_ad_card.dart` | `lib/features/home/presentation/widgets/` | Pub native intégrée |
| `partner_highlight.dart` | `lib/features/home/presentation/widgets/` | Mise en avant partenaire premium |

---

## Composants détaillés

### 1. ContextualHero

**Fichier:** `contextual_hero.dart`

Le hero contextuel affiche un titre dynamique qui change selon le contexte de l'utilisateur.

#### Paramètres du contexte

| Paramètre | Valeurs | Impact sur le titre |
|-----------|---------|---------------------|
| **Heure** | Matin (5h-12h), Après-midi (12h-18h), Soir (18h-22h), Nuit (22h-5h) | "Bonne journée", "Ce soir", "Sorties nocturnes" |
| **Jour** | Semaine, Week-end, Vendredi | "Ce week-end", "Les sorties du week-end commencent" |
| **Saison** | Printemps, Été, Automne, Hiver | Subtitles adaptés ("Profitez des activités estivales") |
| **Ville** | Depuis `userLocationProvider` | "Ce soir à Paris", "Découvrez Lyon" |

#### Effet Parallax

```dart
// L'image de fond se déplace à 50% de la vitesse du scroll
Transform.translate(
  offset: Offset(0, -scrollOffset * 0.5),
  child: Image(...),
)
```

Le parallax crée une sensation de profondeur. L'image se déplace plus lentement que le contenu au-dessus.

#### Greeting personnalisé

Si l'utilisateur est connecté, un message de bienvenue apparaît :
- "Bonjour Prénom !" (matin)
- "Bon après-midi Prénom !" (après-midi)
- "Bonsoir Prénom !" (soir)
- "Bonne nuit Prénom !" (nuit)

#### Props

```dart
ContextualHero({
  double scrollOffset = 0,  // Offset de scroll pour le parallax
  double height = 320,      // Hauteur totale du hero
})
```

---

### 2. EventStories

**Fichier:** `event_stories.dart`

Les stories sont des cercles cliquables affichant les événements trending, inspirés du design Instagram.

#### Fonctionnalités

| Fonctionnalité | Description |
|----------------|-------------|
| **Cercles gradient** | Bordure orange gradient si non vu, grise si vu |
| **Persistence** | État "vu" stocké en `SharedPreferences` |
| **Viewer plein écran** | Overlay avec image, titre, date, lieu |
| **Progress bar** | Indicateurs de progression en haut |
| **Navigation** | Tap gauche/droite pour changer, swipe up pour détail |
| **Auto-progression** | Timer de 5 secondes par story |

#### Provider de stories vues

```dart
// Provider pour suivre les stories vues (persisté en local)
final viewedStoriesProvider = StateNotifierProvider<ViewedStoriesNotifier, Set<String>>();

// Marquer une story comme vue
ref.read(viewedStoriesProvider.notifier).markAsViewed(storyId);

// Vérifier si une story a été vue
final isViewed = viewedStories.contains(storyId);
```

#### Interactions du Viewer

| Geste | Action |
|-------|--------|
| Tap zone gauche (1/3) | Story précédente |
| Tap zone droite (1/3) | Story suivante |
| Long press | Pause la progression |
| Swipe up | Ouvrir détail événement |
| Swipe down | Fermer le viewer |

#### Source de données (Mock)

Actuellement, les stories utilisent `featuredActivitiesProvider` (événements les plus vus).

**Pour le vrai endpoint (futur):**
```dart
final trendingStoriesProvider = FutureProvider<List<StoryEvent>>((ref) async {
  final response = await api.get('/v1/events/trending');
  return response.data.map((e) => StoryEvent.fromJson(e)).toList();
});
```

---

### 3. CountdownEventCard

**Fichier:** `countdown_event_card.dart`

Card FOMO affichant un timer en temps réel pour créer un sentiment d'urgence.

#### Timer temps réel

```dart
// Timer qui met à jour chaque seconde
_timer = Timer.periodic(const Duration(seconds: 1), (_) {
  _calculateRemaining();
});
```

#### Animation Pulse

Quand le countdown est urgent (< 6h), le badge pulse :

```dart
// Animation pulse avec scale
_pulseController = AnimationController(
  vsync: this,
  duration: const Duration(milliseconds: 1000),
)..repeat(reverse: true);

// Scale de 1.0 à 1.05 (5% d'agrandissement)
final scale = _isUrgent ? 1.0 + (_pulseController.value * 0.05) : 1.0;
```

#### Props

```dart
CountdownEventCard({
  required Activity activity,
  DateTime? deadline,           // Date limite countdown
  int? remainingSpots,          // Nb places restantes
  String? urgencyMessage,       // Message personnalisé
})
```

#### Design urgent vs normal

| État | Couleur badge | Couleur bordure | Message |
|------|---------------|-----------------|---------|
| Normal (> 6h) | Orange (#FF601F) | Orange 20% | Timer classique |
| Urgent (< 6h) | Rouge (#FF4444) | Rouge 30% | "Dernières heures pour réserver !" |

#### UrgencySection

Widget qui affiche automatiquement les événements commençant dans les 12 prochaines heures :

```dart
const UrgencySection()

// Filtrage automatique
final urgentActivities = activities.where((activity) {
  final diff = activity.nextSlot!.startDateTime.difference(now);
  return diff.inHours >= 0 && diff.inHours <= 12;
}).take(3).toList();
```

---

### 4. PersonalizedSection

**Fichier:** `personalized_section.dart`

Section "Pour vous" qui affiche des événements scorés selon les préférences utilisateur.

#### Algorithme de Scoring

| Facteur | Points | Condition |
|---------|--------|-----------|
| Catégorie vue | +0 à +3 | Basé sur le nb de vues (max 10 vues = 3 pts) |
| Même ville | +2 | Localisation utilisateur = ville événement |
| Gratuit | +0.5 | priceMin == 0 |
| Imminent | +1 | Événement dans les prochaines 24h |

#### Provider d'historique des catégories

```dart
// Provider pour tracker les vues par catégorie
final categoryHistoryProvider = StateNotifierProvider<CategoryHistoryNotifier, Map<String, int>>();

// Enregistrer une vue
ref.read(categoryHistoryProvider.notifier).recordCategoryView('concert');

// Données stockées en SharedPreferences
{
  "concert": 5,
  "spectacle": 3,
  "atelier": 12
}
```

#### Provider d'activités personnalisées

```dart
final personalizedActivitiesProvider = FutureProvider<List<ScoredActivity>>((ref) async {
  // Combine toutes les activités
  final activities = {...allActivities, ...todayActivities, ...tomorrowActivities};

  // Score chaque activité
  final scored = activities.map((activity) {
    double score = 0;
    // ... algorithme de scoring
    return ScoredActivity(activity: activity, score: score);
  }).toList();

  // Tri par score décroissant
  scored.sort((a, b) => b.score.compareTo(a.score));

  return scored.take(10).toList();
});
```

#### Affichage

- Grille 2 colonnes
- 4 événements affichés
- Icône sparkle dans le titre
- Sous-titre "Basé sur vos préférences"

---

### 5. NativeAdCard

**Fichier:** `native_ad_card.dart`

Publicité native intégrée au feed avec un design similaire aux EventCard.

#### Configuration

```dart
NativeAdConfig({
  required String id,
  required String imageUrl,
  required String title,
  String? subtitle,
  required String sponsorName,
  String? sponsorLogo,
  String ctaText = 'En savoir plus',
  required String targetUrl,
  String? trackingPixelUrl,
})
```

#### Tracking

```dart
// Impression trackée au premier render
void _trackImpression() {
  debugPrint('[NativeAd] Impression tracked: $id');
  // Fire tracking pixel if available
}

// Clic tracké avant ouverture URL
void _trackClick() {
  debugPrint('[NativeAd] Click tracked: $id');
}
```

#### Design

- Badge "Sponsorisé" discret en haut à droite
- Logo sponsor en bas à gauche de l'image
- CTA button orange plein width

---

### 6. PartnerHighlight

**Fichier:** `partner_highlight.dart`

Section de mise en avant d'un partenaire premium avec ses événements.

#### Configuration

```dart
PartnerConfig({
  required String id,
  required String name,
  required String logoUrl,
  String? tagline,              // "La sélection FNAC"
  Color brandColor,             // Couleur de marque
  String? backgroundImageUrl,
})
```

#### Design

- Header avec logo, nom, tagline, badge "Partenaire"
- Carousel horizontal d'événements stylisés
- Ligne d'accent colorée sur chaque card
- Bouton "Voir toute la sélection"

#### PartnerEventCard

Card spéciale avec la couleur de marque du partenaire :

```dart
_PartnerEventCard({
  required Activity activity,
  required Color brandColor,  // Appliqué sur prix et accents
})
```

---

## AppBar Dynamique

L'AppBar change d'opacité au scroll pour une transition fluide.

```dart
PreferredSizeWidget _buildAppBar() {
  // Opacité de 0 à 1 sur les 100 premiers pixels de scroll
  final opacity = (_scrollOffset / 100).clamp(0.0, 1.0);

  return AppBar(
    backgroundColor: Color.lerp(
      Colors.transparent,        // État initial
      const Color(0xFFFF601F),   // État final (orange)
      opacity,
    ),
    // Logo apparaît progressivement
    title: AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(milliseconds: 150),
      child: Image.asset('assets/images/logo_lehiboo_blanc_x3_2.png'),
    ),
  );
}
```

---

## Providers utilisés

| Provider | Type | Description |
|----------|------|-------------|
| `mobileAppConfigProvider` | FutureProvider | Config hero, bannières, textes |
| `currentUserProvider` | Provider | Utilisateur connecté (prénom) |
| `userLocationProvider` | StateNotifierProvider | Géolocalisation + nom de ville |
| `alertsProvider` | StateNotifierProvider | Recherches sauvegardées |
| `homeFeedProvider` | FutureProvider | Feed consolidé (today/tomorrow/recommended) |
| `homeTodayActivitiesProvider` | FutureProvider | Activités du jour |
| `homeTomorrowActivitiesProvider` | FutureProvider | Activités de demain |
| `homeActivitiesProvider` | FutureProvider | Activités recommandées |
| `featuredActivitiesProvider` | FutureProvider | Activités populaires (pour stories) |
| `viewedStoriesProvider` | StateNotifierProvider | Stories vues (local) |
| `categoryHistoryProvider` | StateNotifierProvider | Historique catégories (local) |
| `personalizedActivitiesProvider` | FutureProvider | Activités scorées |

---

## Évolutions Backend nécessaires

### Court terme (fonctionnel maintenant)

Les composants fonctionnent avec les données existantes en mode mock.

### Moyen terme

#### 1. Endpoint Stories/Trending

```http
GET /v1/events/trending
```

**Réponse:**
```json
{
  "data": [
    {
      "uuid": "xxx",
      "title": "...",
      "story_image_url": "url_optimisée_mobile",
      "story_video_url": "optionnel",
      "expires_at": "2026-02-01T00:00:00Z",
      "is_sponsored": false
    }
  ]
}
```

#### 2. Extension Home Feed (urgency)

```http
GET /v1/home-feed
```

**Réponse étendue:**
```json
{
  "data": {
    "today": [...],
    "tomorrow": [...],
    "recommended": [...],
    "urgency": [
      {
        "uuid": "xxx",
        "remaining_spots": 5,
        "booking_deadline": "2026-01-25T20:00:00Z"
      }
    ]
  }
}
```

### Long terme

#### 3. Config Partenaires

```http
GET /mobile/config
```

**Extension:**
```json
{
  "hero": {...},
  "ads": {...},
  "partners": {
    "highlight": {
      "id": 1,
      "name": "FNAC",
      "logo": "url",
      "tagline": "La sélection FNAC",
      "background_color": "#E74C3C"
    }
  },
  "stories_enabled": true
}
```

#### 4. Événements Partenaire

```http
GET /v1/partners/{id}/events
```

---

## Couleurs et Design System

| Élément | Couleur | Code |
|---------|---------|------|
| Brand Primary | Orange | `#FF601F` |
| Urgence | Rouge | `#FF4444` |
| Text Dark | Charcoal | `#2D3748` |
| Text Secondary | Grey | `Colors.grey[600]` |
| Gratuit | Green | `Colors.green[700]` |
| Background Stories non-vu | Gradient | `#FF601F → #FF8B5A → #FFB347` |

---

## Tests recommandés

### Tester le Hero contextuel

1. Changer l'heure du device pour voir les différents titres
2. Activer/désactiver la localisation
3. Se connecter/déconnecter pour le greeting

### Tester les Stories

1. Ouvrir le viewer, naviguer avec tap gauche/droite
2. Vérifier que les stories vues sont grisées après reload
3. Swipe up pour aller au détail
4. Long press pour pause

### Tester le Countdown

1. Attendre que le timer se mette à jour
2. Observer l'animation pulse quand < 6h
3. Vérifier le formatage (jours, heures, minutes, secondes)

### Tester la personnalisation

1. Naviguer sur plusieurs événements d'une catégorie
2. Revenir à la home
3. Vérifier que les événements de cette catégorie sont en haut

---

## Performance

### Optimisations appliquées

- Lazy loading des images avec `CachedNetworkImage`
- Skeletons pendant le chargement
- `const` widgets où possible
- Providers dérivés pour éviter les re-fetches

### Points d'attention

- Le timer du CountdownEventCard utilise `Timer.periodic` - dispose correctement
- Les animations utilisent des controllers - dispose dans `dispose()`
- Le scroll offset est mis à jour via `setState` - utiliser avec parcimonie

---

## Migration depuis l'ancienne Home

### Widgets supprimés

Aucun widget n'a été supprimé, ils sont toujours disponibles dans :
- `recommended_section.dart` (legacy)
- `quick_filters.dart`
- `category_filter_chips.dart`

### Widgets conservés et réutilisés

- `HomeCitiesSection` - Section villes avec chips
- `AdsBannersSection` - Bannières publicitaires
- `EventCard` - Card événement standard
- `ThematiquesSection` - Thématiques
- `CategoriesChipsSection` - Catégories
- `BlogSection` - Articles de blog

---

## Prochaines étapes

1. **Backend** : Implémenter endpoint `/v1/events/trending`
2. **Backend** : Ajouter `urgency` dans home-feed
3. **Backend** : Module admin pour gérer les stories
4. **Frontend** : Remplacer mock par vrais providers quand API ready
5. **Analytics** : Intégrer tracking Firebase pour stories/pubs
