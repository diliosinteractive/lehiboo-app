import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../routes/app_router.dart';
import '../analytics/analytics_event.dart';
import '../analytics/analytics_provider.dart';
import 'deeplink_providers.dart';
import 'deeplink_router.dart';

/// Écoute les Universal Links iOS / App Links Android :
///   - cold start : récupère l'URL qui a démarré l'app
///   - warm start : écoute les URLs reçues pendant la session
///
/// La navigation passe par l'instance `GoRouter` exposée par
/// `routerProvider` (Riverpod), **pas** par `GoRouter.of(context)` : le
/// `context` du `builder` de `MaterialApp.router` est au-dessus de
/// l'`InheritedGoRouter`, donc le lookup par context échoue
/// ("No GoRouter found in context"). L'instance Riverpod, elle, est un
/// singleton accessible partout.
///
/// Cold start race : au démarrage, [AuthState.status] vaut `initial` le
/// temps que le bootstrap se termine. Tenter `go()` à ce moment ferait
/// rebondir le redirect sur `/bootstrap` et on perdrait la cible.
/// On attend donc que l'auth soit settled avant de naviguer.
class DeeplinkListener extends ConsumerStatefulWidget {
  const DeeplinkListener({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<DeeplinkListener> createState() => _DeeplinkListenerState();
}

class _DeeplinkListenerState extends ConsumerState<DeeplinkListener> {
  StreamSubscription<Uri>? _sub;
  bool _coldHandled = false;
  _PendingDeeplink? _waitingForAuth;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  Future<void> _bootstrap() async {
    if (!mounted) return;
    final service = ref.read(deeplinkServiceProvider);

    // Cold start — URL qui a démarré l'app.
    try {
      final initial = await service.initialUri();
      if (initial != null && !_coldHandled) {
        _coldHandled = true;
        _attemptNavigate(initial, coldStart: true);
      }
    } catch (e) {
      debugPrint('[DeeplinkListener] cold start error: $e');
    }

    // Warm start — URLs reçues pendant que l'app tourne.
    _sub = service.uriStream.listen(
      (uri) => _attemptNavigate(uri, coldStart: false),
      onError: (Object e, StackTrace st) {
        debugPrint('[DeeplinkListener] stream error: $e\n$st');
      },
    );
  }

  void _attemptNavigate(Uri uri, {required bool coldStart}) {
    final status = ref.read(authProvider).status;
    if (status == AuthStatus.initial) {
      // Auth pas encore résolue : on met le deeplink en attente.
      // build() écoute authProvider et le rejouera dès que l'état est settled.
      _waitingForAuth = _PendingDeeplink(uri: uri, coldStart: coldStart);
      return;
    }
    _navigate(uri, coldStart: coldStart);
  }

  void _navigate(Uri uri, {required bool coldStart}) {
    final route = mapDeeplinkToRoute(uri);
    final analytics = ref.read(analyticsServiceProvider);

    if (route == null) {
      analytics.logEvent(
        AnalyticsEvent.deeplinkUnmapped,
        params: {
          AnalyticsParam.host: uri.host,
          AnalyticsParam.path: uri.path,
        },
      );
      return;
    }

    analytics.logEvent(
      AnalyticsEvent.deeplinkOpened,
      params: {
        AnalyticsParam.source: _platformSource(),
        AnalyticsParam.path: uri.path,
        AnalyticsParam.coldStart: coldStart,
        if (uri.queryParameters['utm_source'] != null)
          AnalyticsParam.utmSource: uri.queryParameters['utm_source'],
      },
    );

    if (!mounted) {
      ref.read(pendingDeeplinkProvider.notifier).state = route;
      return;
    }

    // On récupère le router via Riverpod (singleton) plutôt que via le
    // context : robuste quel que soit l'emplacement de ce widget dans l'arbre.
    try {
      ref.read(routerProvider).go(route);
    } catch (e) {
      debugPrint('[DeeplinkListener] go() failed, deferring: $e');
      ref.read(pendingDeeplinkProvider.notifier).state = route;
    }
  }

  String _platformSource() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return 'universal_link';
      case TargetPlatform.android:
        return 'app_link';
      default:
        return 'deeplink';
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Rejoue le deeplink mis en attente dès que l'auth est settled.
    ref.listen<AuthState>(authProvider, (prev, next) {
      if (prev?.status == AuthStatus.initial &&
          next.status != AuthStatus.initial) {
        final waiting = _waitingForAuth;
        if (waiting != null) {
          _waitingForAuth = null;
          _navigate(waiting.uri, coldStart: waiting.coldStart);
        }
      }
    });
    return widget.child;
  }
}

class _PendingDeeplink {
  const _PendingDeeplink({required this.uri, required this.coldStart});
  final Uri uri;
  final bool coldStart;
}
