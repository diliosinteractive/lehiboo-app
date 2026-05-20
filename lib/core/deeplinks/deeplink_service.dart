import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';

/// Wrapper autour de `app_links` qui expose deux choses :
///   - [initialUri] : l'URL qui a ouvert l'app à froid (ou null)
///   - [uriStream] : les URLs reçues pendant que l'app tourne (warm start)
class DeeplinkService {
  DeeplinkService({AppLinks? appLinks}) : _appLinks = appLinks ?? AppLinks();

  final AppLinks _appLinks;

  Future<Uri?> initialUri() async {
    try {
      return await _appLinks.getInitialLink();
    } catch (e, st) {
      debugPrint('[DeeplinkService] initialUri error: $e\n$st');
      return null;
    }
  }

  Stream<Uri> get uriStream => _appLinks.uriLinkStream;
}
