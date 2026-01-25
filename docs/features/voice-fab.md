# Voice FAB - Assistant Vocal Petit Boo

## Vue d'ensemble

Le Voice FAB transforme le bouton central "Petit Boo" en assistant vocal premium. Avec un simple **appui prolongé**, l'utilisateur peut parler directement et sa demande est envoyée automatiquement au chat IA.

## Utilisation

### Tap court

| Geste | Action |
|-------|--------|
| **1er tap** | Affiche le tooltip "Maintiens pour parler" (2 secondes) |
| **2e tap rapide** (< 500ms) | Ouvre le chat classique `/petit-boo` |

### Appui prolongé

1. **Maintenir >=300ms** pour activer l'écoute vocale
2. **Parler** pendant l'appui (transcription temps réel visible)
3. **Relâcher** pour envoyer automatiquement au chat

## Feedback visuel et sonore

### Animations premium pendant l'écoute

| Animation | Description |
|-----------|-------------|
| **Anneau gradient tournant** | Style stories Instagram, rotation 360° en 2s |
| **Ondes concentriques** | 3 cercles pulsants avec décalage 500ms |
| **Scale bouton** | Agrandissement 1.0 -> 1.1 avec rebond |
| **Glow renforcé** | Ombre orange plus intense |
| **Icône micro** | Remplace l'icône Petit Boo pendant l'écoute |

### Feedback haptique

- Vibration moyenne (`HapticFeedback.mediumImpact()`) au démarrage de l'écoute

### Sons personnalisés

- `voice_start.mp3` : joué au début de l'écoute
- `voice_end.mp3` : joué au relâchement

## Personnalisation des sons

### Emplacement des fichiers

```
assets/sounds/
├── voice_start.mp3    # Son début écoute
└── voice_end.mp3      # Son fin écoute
```

### Formats supportés

- **MP3** (recommandé)
- WAV
- AAC

### Remplacement des sons

1. Créez vos fichiers audio (MP3 recommandé, < 1s pour réactivité)
2. Nommez-les exactement `voice_start.mp3` et `voice_end.mp3`
3. Placez-les dans `assets/sounds/`
4. Rebuild l'app (`flutter clean && flutter run`)

### Recommandations

- Durée < 1 seconde pour une expérience réactive
- Format MP3 pour taille optimale
- Volume normalisé pour éviter les surprises

**Note** : Si les fichiers sont absents, l'app fonctionne silencieusement sans crash.

## Architecture technique

### Structure des fichiers

```
lib/core/widgets/voice_fab/
├── voice_fab.dart           # Widget principal avec GestureDetector
├── voice_fab_state.dart     # StateNotifier Riverpod (états)
├── animated_ring.dart       # Anneau gradient tournant (SweepGradient)
├── pulse_waves.dart         # Ondes concentriques animées
└── voice_fab_sounds.dart    # Gestion des sons custom (audioplayers)

assets/sounds/
├── voice_start.mp3          # Son début (placeholder)
└── voice_end.mp3            # Son fin (placeholder)
```

### Composants

| Fichier | Rôle |
|---------|------|
| `voice_fab.dart` | Widget principal, gère les gestes et le speech-to-text |
| `voice_fab_state.dart` | États Riverpod : idle, hintShown, listening, processing, error |
| `animated_ring.dart` | Anneau gradient tournant avec SweepGradient |
| `pulse_waves.dart` | 3 cercles pulsants concentriques |
| `voice_fab_sounds.dart` | Lecture sons via audioplayers |

### États du VoiceFab

```dart
enum VoiceFabStatus {
  idle,        // État normal, FAB classique
  hintShown,   // Tooltip visible "Maintiens pour parler"
  listening,   // Écoute active, animations en cours
  processing,  // Transcription terminée, navigation en cours
  error,       // Erreur (permission refusée, etc.)
}
```

### Flow de données

```
┌─────────────────────────────────────────────────────────────┐
│  1. GestureDetector.onLongPressStart (après 300ms)          │
│     ↓                                                       │
│  2. HapticFeedback.mediumImpact()                           │
│  3. AudioPlayer.play('voice_start.mp3')                     │
│  4. setState → listening = true                             │
│  5. SpeechToText.listen(localeId: 'fr_FR')                  │
│     ↓                                                       │
│  6. Pendant écoute : transcription temps réel               │
│     ↓                                                       │
│  7. GestureDetector.onLongPressEnd                          │
│     ↓                                                       │
│  8. SpeechToText.stop()                                     │
│  9. AudioPlayer.play('voice_end.mp3')                       │
│ 10. Si transcription vide → tooltip erreur                  │
│ 11. Si transcription OK → navigation                        │
│     ↓                                                       │
│ 12. context.push('/petit-boo?message=<text>')               │
│     ↓                                                       │
│ 13. PetitBooChatScreen reçoit initialVoiceMessage           │
│ 14. Envoie automatiquement → IA répond                      │
└─────────────────────────────────────────────────────────────┘
```

## Gestion des erreurs

| Cas | Comportement |
|-----|--------------|
| Permission micro refusée | Tooltip "Autorise le micro dans Réglages" |
| Transcription vide | Tooltip "Je n'ai rien entendu" (3s) |
| Erreur speech_to_text | Tooltip avec message d'erreur |
| Fichier son absent | Lecture silencieuse (pas de crash) |
| Micro non disponible | Tooltip "Le micro n'est pas disponible" |

## Dépendances

### Déjà installées

- `speech_to_text: ^7.3.0` - Reconnaissance vocale
- `permission_handler: ^11.3.1` - Gestion permissions micro

### Ajoutées

- `audioplayers: ^5.2.1` - Lecture sons custom

## Intégration

### Dans main_scaffold.dart

```dart
// Le FAB classique est remplacé par le VoiceFab
floatingActionButton: const VoiceFab(),
```

### Route avec message vocal

```dart
// app_router.dart
GoRoute(
  path: '/petit-boo',
  builder: (context, state) {
    final sessionUuid = state.uri.queryParameters['session'];
    final initialMessage = state.uri.queryParameters['message'];
    return PetitBooChatScreen(
      sessionUuid: sessionUuid,
      initialVoiceMessage: initialMessage,
    );
  },
),
```

### Chat screen avec message initial

```dart
// petit_boo_chat_screen.dart
class PetitBooChatScreen extends ConsumerStatefulWidget {
  final String? sessionUuid;
  final String? initialVoiceMessage;  // Nouveau paramètre

  // ...
}
```

## Troubleshooting

### Le micro ne fonctionne pas

1. Vérifier les permissions dans Réglages > App > Microphone
2. Tester sur device physique (simulateur = micro limité)
3. Vérifier que l'app a bien accès au micro dans le manifest

### Pas de son

1. Vérifier que les fichiers existent dans `assets/sounds/`
2. Vérifier que `assets/sounds/` est déclaré dans `pubspec.yaml`
3. Vérifier le volume du device
4. Rebuild l'app après ajout des fichiers

### Transcription incorrecte

- Parler clairement et distinctement
- Environnement calme recommandé
- Le français est la langue par défaut (`fr_FR`)

### Les animations ne s'affichent pas

1. Vérifier que `_isListening` passe bien à `true`
2. Vérifier les AnimationControllers dans les widgets enfants
3. S'assurer que le widget n'est pas dispose() prématurément

## Tests manuels requis

### Checklist

- [ ] **Tap court 1er** → Tooltip "Maintiens pour parler" apparaît (2s)
- [ ] **Tap court 2e rapide** → Ouvre le chat classique
- [ ] **Appui prolongé** :
  - [ ] Vibration après 300ms
  - [ ] Son de début
  - [ ] Anneau gradient tourne
  - [ ] Ondes pulsent
  - [ ] Bouton grossit avec icône micro
- [ ] **Parler** → Transcription visible en temps réel
- [ ] **Relâcher** :
  - [ ] Son de fin
  - [ ] Animations s'arrêtent
  - [ ] Navigation vers chat
  - [ ] Message envoyé automatiquement
  - [ ] IA répond
- [ ] **Permission refusée** → Tooltip + lien settings
- [ ] **Transcription vide** → Tooltip "Je n'ai rien entendu"

### Devices à tester

- [ ] iOS Simulator (iPhone avec notch)
- [ ] Android Emulator
- [ ] Device physique (pour vibration et micro réel)
