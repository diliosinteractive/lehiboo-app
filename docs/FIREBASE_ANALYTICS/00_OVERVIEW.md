# Firebase Analytics — Plan d'intégration

Plan de mise en place de **Firebase Analytics / GA4** dans l'app Flutter Le Hiboo.

## État de l'existant (audit au 2026-05-18)

| Élément | Statut |
|---|---|
| `firebase_core: ^3.6.0` dans `pubspec.yaml` | ✅ |
| `firebase_analytics: ^11.3.3` dans `pubspec.yaml` | ✅ |
| `lib/firebase_options.dart` | ✅ (projet `lehiboo-77c35`) |
| `ios/Runner/GoogleService-Info.plist` | ✅ |
| `android/app/google-services.json` | ✅ |
| `Firebase.initializeApp(...)` dans `main.dart` | ✅ |
| Code applicatif utilisant `FirebaseAnalytics` | ❌ aucun |
| `FirebaseAnalyticsObserver` sur GoRouter | ❌ |
| Service / provider analytics | ❌ |
| Consentement RGPD + ATT iOS | ❌ |

Le SDK est déjà chargé : **rien à installer**. Le travail restant est de construire un service métier, brancher la navigation, instrumenter les features et gérer le consentement.

## Objectifs

1. **Mesurer le funnel de conversion** : home → recherche → fiche événement → réservation → paiement → billet.
2. **Comprendre l'engagement** : Petit Boo, favoris, alertes, Hibons, stories, partages.
3. **Segmenter les utilisateurs** : rôle (visitor / member / partner / admin), ville, locale, statut adhésion.
4. **Détecter les frictions** : abandons paiement, erreurs de connexion, recherches sans résultat.
5. **Respecter le RGPD** : opt-in explicite avant collecte, opt-out toujours accessible.

## Étapes — index des documents

| # | Fichier | Sujet | Effort |
|---|---|---|---|
| 1 | [01_PREREQUISITES.md](01_PREREQUISITES.md) | Audit natif, consoles Firebase, multi-env | 0.5 j |
| 2 | [02_CORE_SETUP.md](02_CORE_SETUP.md) | `AnalyticsService` + provider Riverpod + init | 0.5 j |
| 3 | [03_NAVIGATION_TRACKING.md](03_NAVIGATION_TRACKING.md) | `FirebaseAnalyticsObserver` sur GoRouter | 0.5 j |
| 4 | [04_USER_PROPERTIES.md](04_USER_PROPERTIES.md) | `setUserId` + user properties | 0.5 j |
| 5 | [05_EVENT_CATALOG.md](05_EVENT_CATALOG.md) | Catalogue d'events + conventions de nommage | 1 j |
| 6 | [06_INSTRUMENTATION.md](06_INSTRUMENTATION.md) | Où poser les `logEvent` dans le code | 2-3 j |
| 7 | [07_CONSENT_RGPD.md](07_CONSENT_RGPD.md) | Consent gate + ATT iOS + opt-out | 1 j |
| 8 | [08_DEBUG_QA.md](08_DEBUG_QA.md) | DebugView, validation, recette | 0.5 j |
| 9 | [09_ROLLOUT.md](09_ROLLOUT.md) | Phasage release, dashboards, BigQuery | 0.5 j |

**Total estimé : 7 à 8 jours-homme** pour une couverture complète (auth + funnel booking + Petit Boo + favoris + Hibons + search).

## Hors périmètre

- **Crashlytics** : le commentaire `# firebase_crashlytics: ^4.1.3` dans `pubspec.yaml` indique que c'est prévu mais désactivé. À traiter dans un plan séparé.
- **Performance Monitoring** : non couvert ici, peut être ajouté en réutilisant la même infra de service.
- **A/B testing (Remote Config)** : non couvert.

## Pré-requis avant de commencer

1. Accès admin à la console Firebase projet `lehiboo-77c35`.
2. Décider si on veut un seul projet Firebase ou 3 (dev / staging / prod) — voir [01_PREREQUISITES.md](01_PREREQUISITES.md).
3. Validation produit/marketing du catalogue d'events (cf. [05_EVENT_CATALOG.md](05_EVENT_CATALOG.md)) avant l'étape 6.
4. Mise à jour de la politique de confidentialité (mentionner Firebase Analytics + GA4 + transferts hors UE).
