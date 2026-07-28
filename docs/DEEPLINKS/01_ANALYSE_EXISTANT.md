# Deeplinks événements — Analyse de l'existant

> Snapshot du code au 2026-05-19, branche `feat/analytics`.

---

## 1. Partage d'event (côté app)

### Bouton partage

[lib/features/events/presentation/widgets/detail/event_share_sheet.dart](../../lib/features/events/presentation/widgets/detail/event_share_sheet.dart)

- Package : `share_plus` 12.0.2 (pubspec.yaml:99)
- URL construite via `EnvConfig.eventShareUrl(event.slug)` → `{websiteUrl}/events/{slug}`
- Déclenché depuis la barre d'action de [event_detail_screen.dart:639](../../lib/features/events/presentation/screens/event_detail_screen.dart#L639)
- Analytics : `eventShared` + GA4 `share`
- Gamification : `gamificationDatasource.trackShare(...)`

### URL hard-codée à plusieurs endroits

Le diagnostic [DIAGNOSTIC_PARTAGE_EVENT_TESTFLIGHT.md](../DIAGNOSTIC_PARTAGE_EVENT_TESTFLIGHT.md) signale déjà :

- [event_detail_screen.dart:631](../../lib/features/events/presentation/screens/event_detail_screen.dart#L631) — `'https://lehiboo.com/events/${event.slug}'`
- [event_detail_screen.dart:1174](../../lib/features/events/presentation/screens/event_detail_screen.dart#L1174) — idem dans `EventGalleryFullscreen.show`

À nettoyer dans l'étape [06_SHARE_URL_CLEANUP.md](06_SHARE_URL_CLEANUP.md).

### Source de vérité URL

[lib/config/env_config.dart:26-29](../../lib/config/env_config.dart#L26-L29)

```dart
static String get websiteUrl => dotenv.env['WEBSITE_URL'] ?? 'https://lehiboo.com';
static String eventShareUrl(String slug) => '$websiteUrl/events/$slug';
```

Lecture via flutter_dotenv. Les fichiers `.env.development`, `.env.staging`, `.env.production` peuvent overrider.

---

## 2. Routing actuel

### Router

`go_router` 14.3.0 (pubspec.yaml:33), instance dans [lib/routes/app_router.dart](../../lib/routes/app_router.dart) (`routerProvider`).

### Routes event existantes

| Path | Name | Param | Widget |
|------|------|-------|--------|
| `/event/:id` | `event-detail` | `id` (UUID **ou** slug) | `EventDetailScreen(eventId: …)` |
| `/events/:id` | `event-detail-alias` | `id` | `EventDetailScreen(eventId: …)` — alias |
| `/event/:id/questions` | — | `id` | `UserQuestionsScreen` |
| `/event/:slug/reviews` | — | `slug` | `ReviewsScreen` |

→ **L'alias `/events/:id` est déjà aligné avec le format de l'URL partagée** `https://lehiboo.com/events/{slug}`. Pas besoin de créer de nouvelle route, juste de la laisser servir le deeplink.

### Redirect / auth

`routerProvider` a un `redirect` (app_router.dart:138-219) qui force la redirection des routes protégées vers `/login` si l'utilisateur n'est pas authentifié.

Le détail d'event est **public** côté API, donc pas de blocage théorique. À vérifier si le `redirect` actuel laisse bien passer `/events/:id`.

---

## 3. Écran de détail

[lib/features/events/presentation/screens/event_detail_screen.dart](../../lib/features/events/presentation/screens/event_detail_screen.dart)

```dart
class EventDetailScreen extends ConsumerStatefulWidget {
  final String eventId;  // UUID ou slug
  const EventDetailScreen({super.key, required this.eventId});
}
```

Le provider `eventDetailControllerProvider(eventId)` (lignes 53-86) appelle `eventRepositoryProvider.getEvent(identifier)`. Le repo gère **UUID et slug** (rappel CLAUDE.md : le backend Laravel utilise `getRouteKeyName()` pour le slug).

Cas spéciaux gérés :
- 403 password_required → `EventDetailState.locked(shell)` → `EventLockedView` + `EventPasswordSheet`
- 404 → AsyncError standard

→ **Aucun changement nécessaire sur l'écran**. Il sait déjà gérer un identifier brut venu d'une URL.

---

## 4. Configuration native — état actuel

### iOS

[ios/Runner/Info.plist](../../ios/Runner/Info.plist) :
- `CFBundleURLTypes` : **absent**
- Bundle ID : `$(PRODUCT_BUNDLE_IDENTIFIER)` → `com.dilios.lehiboo`

[ios/Runner/Runner.entitlements](../../ios/Runner/Runner.entitlements) :
- `com.apple.developer.associated-domains` : **absent**
- `aps-environment` = `development` (à passer à `production` pour TestFlight/App Store, mais c'est un autre sujet)
- App group OneSignal présent

→ **Tout est à ajouter.** Voir [02_IOS_UNIVERSAL_LINKS.md](02_IOS_UNIVERSAL_LINKS.md).

### Android

[android/app/src/main/AndroidManifest.xml](../../android/app/src/main/AndroidManifest.xml) :
- `MainActivity` a uniquement `MAIN` + `LAUNCHER` (lignes 34-37)
- Pas d'`intent-filter` avec `VIEW` + `BROWSABLE` + data scheme HTTPS
- `applicationId` (build.gradle.kts:45) : `com.dilios.lehibooexperience`

→ **Tout est à ajouter.** Voir [03_ANDROID_APP_LINKS.md](03_ANDROID_APP_LINKS.md).

### Inconsistance Bundle ID / Application ID

| Plateforme | Identifier |
|------------|------------|
| iOS Bundle ID | `com.dilios.lehiboo` |
| Android applicationId | `com.dilios.lehibooexperience` |

C'est légal mais ça oblige à maintenir deux fichiers côté backend (un AASA listant `com.dilios.lehiboo`, un `assetlinks.json` listant `com.dilios.lehibooexperience`). Documenté en [05_BACKEND_AASA_ASSETLINKS.md](05_BACKEND_AASA_ASSETLINKS.md).

---

## 5. Packages déjà disponibles

| Package | Version | Usage actuel | Utile pour deeplinks ? |
|---------|---------|--------------|------------------------|
| `go_router` | 14.3.0 | Routing | ✅ Réception des URLs |
| `share_plus` | 12.0.2 | Partage natif | Indirect — produit le lien |
| `url_launcher` | 6.3.1 | Ouvrir liens externes | Non |
| `flutter_dotenv` | — | Env | ✅ Pour URL site |
| `firebase_*` | 3.x / 11.x | Auth/Analytics/Crashlytics | Pour logger `deeplink_opened` |
| `app_links` | ❌ absent | — | **À ajouter** |
| `uni_links` | ❌ absent | — | Déprécié, ne pas ajouter |
| `firebase_dynamic_links` | ❌ absent | — | Déprécié par Google, ne pas ajouter |

---

## 6. Résumé : ce qui manque

| Couche | Manquant |
|--------|----------|
| iOS | Associated Domains entitlement + AASA publié |
| Android | `intent-filter` HTTPS + `assetlinks.json` publié |
| Flutter | Package `app_links` + listener cold/warm start + branchement go_router |
| Backend web | Routes `/.well-known/apple-app-site-association` et `/.well-known/assetlinks.json` |
| Code partage | Suppression des URLs hard-codées (déjà identifié dans le diagnostic TestFlight) |
| Domaine | Trancher entre `lehiboo.com` et `lehiboo.fr` |
