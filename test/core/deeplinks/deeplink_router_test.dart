import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/deeplinks/deeplink_router.dart';

void main() {
  group('mapDeeplinkToRoute', () {
    test('event slug sur lehiboo.com → /events/{slug}', () {
      expect(
        mapDeeplinkToRoute(Uri.parse('https://lehiboo.com/events/jazz-night')),
        '/events/jazz-night',
      );
    });

    test('event slug sur www.lehiboo.com → /events/{slug}', () {
      expect(
        mapDeeplinkToRoute(Uri.parse('https://www.lehiboo.com/events/foo')),
        '/events/foo',
      );
    });

    test('query params préservés mais ignorés dans la route', () {
      expect(
        mapDeeplinkToRoute(
          Uri.parse('https://lehiboo.com/events/foo?utm_source=app_share'),
        ),
        '/events/foo',
      );
    });

    test('slug avec caractères encodés', () {
      expect(
        mapDeeplinkToRoute(
          Uri.parse('https://lehiboo.com/events/concert-%C3%A0-paris'),
        ),
        '/events/concert-à-paris',
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

    test('path /events sans slug → null', () {
      expect(
        mapDeeplinkToRoute(Uri.parse('https://lehiboo.com/events')),
        null,
      );
    });

    test('autre route (/about) → null', () {
      expect(
        mapDeeplinkToRoute(Uri.parse('https://lehiboo.com/about')),
        null,
      );
    });

    test('root path → null', () {
      expect(
        mapDeeplinkToRoute(Uri.parse('https://lehiboo.com/')),
        null,
      );
    });

    test('custom scheme (lehiboo://) → null (pas supporté en phase 1)', () {
      expect(
        mapDeeplinkToRoute(Uri.parse('lehiboo://events/foo')),
        null,
      );
    });

    test('slug avec segments supplémentaires → mappé sur le premier segment', () {
      // Apple AASA matche `/events/*`, donc /events/foo/bar arrive aussi à l'app.
      // On résout sur le premier segment pour rester aligné avec la route
      // `/events/:id` de go_router.
      expect(
        mapDeeplinkToRoute(Uri.parse('https://lehiboo.com/events/foo/bar')),
        '/events/foo',
      );
    });
  });
}
