import 'package:flutter/foundation.dart';

/// Hosts vérifiés via Universal Links (iOS) et App Links (Android).
///
/// Doivent rester synchronisés avec :
///   - `applinks:` dans `ios/Runner/Runner.entitlements`
///   - `<data android:host>` dans `android/app/src/main/AndroidManifest.xml`
///   - Le fichier AASA et `assetlinks.json` publiés sur ces domaines.
const Set<String> kDeeplinkAllowedHosts = {
  'lehiboo.com',
  'www.lehiboo.com',
  'staging.lehiboo.com',
  'www.staging.lehiboo.com',
};

/// Convertit une URL deeplink en route interne `go_router`,
/// ou `null` si l'URL n'est pas gérée.
///
/// Règles :
///   - Le scheme doit être `https` (les App Links HTTPS sont vérifiés
///     cryptographiquement ; on refuse `http` même si le filter Android le
///     laissait passer).
///   - Le host doit appartenir à [kDeeplinkAllowedHosts].
///   - Seul `/events/{slug}` est mappé pour cette première itération.
String? mapDeeplinkToRoute(Uri uri) {
  if (uri.scheme != 'https') {
    debugPrint('[deeplink] scheme non géré: ${uri.scheme}');
    return null;
  }
  if (!kDeeplinkAllowedHosts.contains(uri.host)) {
    debugPrint('[deeplink] host non géré: ${uri.host}');
    return null;
  }

  final segments = uri.pathSegments;
  if (segments.length >= 2 && segments[0] == 'events') {
    final slug = segments[1].trim();
    if (slug.isEmpty) return null;
    return '/events/$slug';
  }

  return null;
}
