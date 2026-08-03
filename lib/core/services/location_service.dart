import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

// [LocationResolved] expose une [Position] et l'appelant peut choisir une
// [LocationAccuracy] : les deux font partie de l'API publique du service.
export 'package:geolocator/geolocator.dart' show LocationAccuracy, Position;

/// Raison pour laquelle une position n'a pas pu être résolue.
///
/// L'appelant choisit le message à afficher : les écrans de recherche et la
/// carte n'utilisent pas les mêmes libellés.
enum LocationFailure {
  /// Service de localisation désactivé sur l'appareil.
  serviceDisabled,

  /// Permission refusée pour cette demande.
  permissionDenied,

  /// Permission refusée définitivement : il faut passer par les réglages.
  permissionDeniedForever,

  /// Aucun fix obtenu dans le délai imparti et aucune position connue.
  unavailable,
}

/// Résultat d'une demande de position : soit une [Position], soit un
/// [LocationFailure].
sealed class LocationOutcome {
  const LocationOutcome();
}

class LocationResolved extends LocationOutcome {
  const LocationResolved(this.position);

  final Position position;
}

class LocationUnresolved extends LocationOutcome {
  const LocationUnresolved(this.failure);

  final LocationFailure failure;
}

/// Accès à la position de l'appareil : borné dans le temps, et borné en âge.
///
/// Deux pièges de `geolocator` sont neutralisés ici.
///
/// **Attente infinie.** `Geolocator.getCurrentPosition()` n'applique aucun
/// délai par défaut : tant que la puce GPS n'obtient pas de fix (intérieur,
/// signal faible, émulateur sans position injectée), le Future ne se termine
/// jamais et l'écran appelant reste bloqué en chargement.
///
/// **Positions périmées.** Sur Android, `getLastKnownPosition()` délègue à
/// `FusedLocationProviderClient.getLastLocation()`, et le `LocationRequest`
/// construit par le plugin ne borne pas `maxUpdateAgeMillis` : les deux
/// chemins peuvent rendre un fix vieux de plusieurs heures, identique à chaque
/// appel. Sans contrôle d'âge, l'utilisateur reste épinglé à un ancien lieu et
/// ses coordonnées ne changent plus jamais.
class LocationService {
  const LocationService._();

  /// Attente maximale d'un nouveau fix.
  static const fixTimeout = Duration(seconds: 12);

  /// Au-delà de cet âge, une position ne décrit plus « où je suis ».
  static const maxFixAge = Duration(minutes: 5);

  static Future<LocationOutcome> currentPosition({
    LocationAccuracy accuracy = LocationAccuracy.high,
    Duration timeout = fixTimeout,
    Duration maxAge = maxFixAge,
  }) async {
    final permissionFailure = await _ensurePermission();
    if (permissionFailure != null) {
      return LocationUnresolved(permissionFailure);
    }

    final fix = await _requestFix(accuracy, timeout, maxAge);
    if (fix != null) return LocationResolved(fix);

    // Dernier recours : le fix mémorisé par le système, s'il est assez récent
    // pour être encore honnête.
    final lastKnown = await lastKnownPosition();
    if (lastKnown != null && _isFresh(lastKnown, maxAge)) {
      _log('repli sur la dernière position connue', lastKnown);
      return LocationResolved(lastKnown);
    }

    _log('aucune position fraîche disponible', lastKnown);
    return const LocationUnresolved(LocationFailure.unavailable);
  }

  /// Dernière position connue du système, `null` si indisponible.
  ///
  /// Aucune garantie de fraîcheur : c'est à l'appelant de la vérifier.
  static Future<Position?> lastKnownPosition() async {
    try {
      return await Geolocator.getLastKnownPosition();
    } catch (_) {
      return null;
    }
  }

  /// Demande un fix et refuse de rendre une position périmée.
  ///
  /// Un premier appel qui rend instantanément un fix trop vieux signale que la
  /// plateforme a servi son cache ; on réessaie alors en accuracy maximale, qui
  /// engage réellement le GPS au lieu de se contenter du réseau.
  static Future<Position?> _requestFix(
    LocationAccuracy accuracy,
    Duration timeout,
    Duration maxAge,
  ) async {
    final first = await _tryGetCurrentPosition(accuracy, timeout);
    if (first == null) return null;
    if (_isFresh(first, maxAge)) return first;

    _log('position en cache rendue par la plateforme, nouvel essai', first);

    final retry = await _tryGetCurrentPosition(LocationAccuracy.best, timeout);
    if (retry != null && _isFresh(retry, maxAge)) return retry;

    _log('toujours pas de fix frais après nouvel essai', retry ?? first);
    return null;
  }

  static Future<Position?> _tryGetCurrentPosition(
    LocationAccuracy accuracy,
    Duration timeout,
  ) async {
    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: accuracy,
          timeLimit: timeout,
        ),
      );
    } catch (_) {
      // Timeout ou erreur plateforme : traité comme une absence de fix.
      return null;
    }
  }

  static bool _isFresh(Position position, Duration maxAge) {
    // `timestamp` est en UTC ; `difference` compare des instants absolus.
    final age = DateTime.now().difference(position.timestamp);
    return !age.isNegative && age <= maxAge;
  }

  static void _log(String message, Position? position) {
    if (!kDebugMode) return;
    if (position == null) {
      debugPrint('📍 LocationService: $message');
      return;
    }
    final age = DateTime.now().difference(position.timestamp);
    debugPrint(
      '📍 LocationService: $message '
      '(${position.latitude}, ${position.longitude}) '
      'âge=${age.inSeconds}s',
    );
  }

  /// Retourne `null` si la localisation est utilisable, sinon la raison du
  /// blocage.
  static Future<LocationFailure?> _ensurePermission() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return LocationFailure.serviceDisabled;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      return switch (permission) {
        LocationPermission.denied => LocationFailure.permissionDenied,
        LocationPermission.deniedForever =>
          LocationFailure.permissionDeniedForever,
        _ => null,
      };
    } catch (_) {
      // `requestPermission` lève notamment quand une demande est déjà en cours
      // (ex. la carte qui demande la permission au montage).
      return LocationFailure.permissionDenied;
    }
  }
}
