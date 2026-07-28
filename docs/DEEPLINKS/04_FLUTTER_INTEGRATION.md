# Étape 4 — Intégration Flutter

> Objectif : recevoir les URLs entrantes (cold + warm start), les router vers `EventDetailScreen`, et gérer les cas auth / event protégé / 404.

---

## 1. Dépendance

`pubspec.yaml` :

```yaml
dependencies:
  app_links: ^6.3.2  # vérifier la dernière version stable au moment de l'install
```

Puis `flutter pub get`. Aucune config native supplémentaire requise pour le package — c'est l'`AndroidManifest.xml` (étape 03) et les entitlements iOS (étape 02) qui font le travail OS.

---

## 2. Service `DeeplinkService`

Nouveau fichier : `lib/core/deeplinks/deeplink_service.dart`

```dart
import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';

/// Wrapper autour de `app_links` qui expose deux choses :
///   - `initialUri()` : l'URL qui a ouvert l'app à froid (ou null)
///   - `uriStream` : les URLs reçues en warm start
class DeeplinkService {
  DeeplinkService({AppLinks? appLinks}) : _appLinks = appLinks ?? AppLinks();

  final AppLinks _appLinks;

  Future<Uri?> initialUri() async {
    try {
      return await _appLinks.getInitialAppLink();
    } catch (e, st) {
      debugPrint('[DeeplinkService] initialUri error: $e\n$st');
      return null;
    }
  }

  Stream<Uri> get uriStream => _appLinks.uriLinkStream;
}
```

---

## 3. Provider Riverpod

Nouveau fichier : `lib/core/deeplinks/deeplink_providers.dart`

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'deeplink_service.dart';

final deeplinkServiceProvider = Provider<DeeplinkService>((ref) {
  return DeeplinkService();
});
```

---

## 4. Parsing de l'URL → route interne

Nouveau fichier : `lib/core/deeplinks/deeplink_router.dart`

```dart
import 'package:flutter/foundation.dart';

/// Convertit une URL deeplink en route interne `go_router`,
/// ou null si l'URL n'est pas gérée.
String? mapDeeplinkToRoute(Uri uri) {
  // On accepte les hosts qu'on déclare dans l'AASA / assetlinks
  const allowedHosts = {
    'lehiboo.com', 'www.lehiboo.com',
    'lehiboo.fr', 'www.lehiboo.fr',  // si applicable
  };

  if (uri.scheme != 'https' || !allowedHosts.contains(uri.host)) {
    debugPrint('[deeplink] host non géré: ${uri.host}');
    return null;
  }

  final segments = uri.pathSegments;
  // /events/{slug}
  if (segments.length >= 2 && segments[0] == 'events') {
    final slug = segments[1];
    if (slug.isEmpty) return null;
    return '/events/$slug';
  }

  return null;
}
```

Tests unitaires recommandés (cas : URL malformée, host inconnu, slug vide, segments en trop).

---

## 5. Branchement dans le router

[lib/routes/app_router.dart](../../lib/routes/app_router.dart) — la route `/events/:id` (`event-detail-alias`) existe déjà. Il faut juste s'assurer que :

1. Le `redirect` ne renvoie pas un deeplink vers `/login` si l'event est public.
2. Si l'utilisateur **est** sur `/login` (cold start sans auth) et qu'un deeplink arrive, on capture la cible pour rejouer après login.

### Capture pour replay post-login

Ajouter un provider qui retient le deeplink en attente :

```dart
final pendingDeeplinkProvider = StateProvider<String?>((ref) => null);
```

Dans le `redirect` :

```dart
redirect: (context, state) {
  final isAuthed = ref.read(authProvider).isAuthenticated;
  final target = state.matchedLocation;

  // Routes publiques → laisser passer
  const publicPrefixes = ['/events/', '/event/', '/login', '/register', '/'];
  final isPublic = publicPrefixes.any(target.startsWith);

  if (!isAuthed && !isPublic) {
    // Sauvegarde la cible pour après login
    ref.read(pendingDeeplinkProvider.notifier).state = target;
    return '/login';
  }

  // Si on est sur /login et qu'il y a un deeplink en attente, on le rejoue
  if (isAuthed && target == '/login') {
    final pending = ref.read(pendingDeeplinkProvider);
    if (pending != null) {
      ref.read(pendingDeeplinkProvider.notifier).state = null;
      return pending;
    }
  }

  return null;
}
```

**Note** : pour les events publics, le replay n'est pas nécessaire — l'utilisateur peut voir l'event sans être logué. Cette logique est mise en place pour la phase 2 (bookings, alerts).

---

## 6. Listener cold + warm start

Modifier `main.dart` ou créer un widget `DeeplinkListener` qui wrap le `MaterialApp.router`.

### Option recommandée : un widget listener

Nouveau fichier : `lib/core/deeplinks/deeplink_listener.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'deeplink_providers.dart';
import 'deeplink_router.dart';
import '../analytics/analytics_service.dart'; // adapter au nom réel

class DeeplinkListener extends ConsumerStatefulWidget {
  const DeeplinkListener({super.key, required this.child});
  final Widget child;

  @override
  ConsumerState<DeeplinkListener> createState() => _DeeplinkListenerState();
}

class _DeeplinkListenerState extends ConsumerState<DeeplinkListener> {
  StreamSubscription<Uri>? _sub;
  bool _coldHandled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  Future<void> _bootstrap() async {
    final service = ref.read(deeplinkServiceProvider);

    // Cold start
    final initial = await service.initialUri();
    if (initial != null && !_coldHandled) {
      _coldHandled = true;
      _handle(initial, coldStart: true);
    }

    // Warm start
    _sub = service.uriStream.listen(
      (uri) => _handle(uri, coldStart: false),
      onError: (e, st) => debugPrint('[deeplink] stream error: $e'),
    );
  }

  void _handle(Uri uri, {required bool coldStart}) {
    final route = mapDeeplinkToRoute(uri);
    if (route == null) return;

    // Analytics
    ref.read(analyticsServiceProvider).logEvent(
      'deeplink_opened',
      params: {
        'source': defaultTargetPlatform == TargetPlatform.iOS
            ? 'universal_link'
            : 'app_link',
        'path': uri.path,
        'cold_start': coldStart,
      },
    );

    // Navigation
    if (mounted) {
      GoRouter.of(context).go(route);
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
```

### Wiring dans `main.dart`

Localiser le `MaterialApp.router` (probablement dans `lib/main.dart` ou `lib/app.dart`). Wrap :

```dart
return DeeplinkListener(
  child: MaterialApp.router(
    routerConfig: router,
    ...
  ),
);
```

→ `DeeplinkListener` doit être **sous** le `ProviderScope` et **au-dessus** ou **autour** de `MaterialApp.router` pour pouvoir appeler `GoRouter.of(context)` quand la nav est prête.

---

## 7. Cas particuliers

### Event password-protected

L'écran `EventDetailScreen` gère déjà le 403 `password_required` en affichant `EventLockedView`. Aucune logique deeplink-spécifique nécessaire — le deeplink ouvre la route, l'écran fait le reste.

### Event introuvable (404)

`eventDetailControllerProvider` remonte une `AsyncError`. L'écran affiche déjà un état d'erreur. Vérifier que ce state propose un bouton "Retour à l'accueil" sinon l'utilisateur arrivé par deeplink sera coincé.

### URL malformée

`mapDeeplinkToRoute` retourne `null` → on ignore silencieusement. À considérer : logger un event analytics `deeplink_unmapped` pour détecter des cas non prévus.

### Utilisateur non authentifié sur event public

Pas de problème — les events sont publics. Le `redirect` ne doit pas renvoyer vers `/login`.

---

## 8. Tests Flutter

Nouveau fichier : `test/core/deeplinks/deeplink_router_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/deeplinks/deeplink_router.dart';

void main() {
  group('mapDeeplinkToRoute', () {
    test('event slug sur lehiboo.com', () {
      expect(
        mapDeeplinkToRoute(Uri.parse('https://lehiboo.com/events/jazz-night')),
        '/events/jazz-night',
      );
    });

    test('event slug sur www.lehiboo.com', () {
      expect(
        mapDeeplinkToRoute(Uri.parse('https://www.lehiboo.com/events/foo')),
        '/events/foo',
      );
    });

    test('host inconnu → null', () {
      expect(
        mapDeeplinkToRoute(Uri.parse('https://evil.com/events/foo')),
        null,
      );
    });

    test('http au lieu de https → null', () {
      expect(
        mapDeeplinkToRoute(Uri.parse('http://lehiboo.com/events/foo')),
        null,
      );
    });

    test('slug vide → null', () {
      expect(
        mapDeeplinkToRoute(Uri.parse('https://lehiboo.com/events/')),
        null,
      );
    });

    test('autre route → null', () {
      expect(
        mapDeeplinkToRoute(Uri.parse('https://lehiboo.com/about')),
        null,
      );
    });
  });
}
```

---

## 9. Checklist

- [ ] `app_links` ajouté dans `pubspec.yaml` et installé
- [ ] `deeplink_service.dart`, `deeplink_router.dart`, `deeplink_providers.dart`, `deeplink_listener.dart` créés
- [ ] `DeeplinkListener` wrap `MaterialApp.router`
- [ ] `pendingDeeplinkProvider` + replay post-login dans le `redirect`
- [ ] Tests unitaires `deeplink_router` verts
- [ ] Analytics `deeplink_opened` envoyé (cold + warm)
- [ ] Test manuel : `adb shell am start` ouvre l'app sur le bon écran
- [ ] Test manuel iOS depuis Notes → idem
