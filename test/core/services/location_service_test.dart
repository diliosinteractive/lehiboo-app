import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lehiboo/core/services/location_service.dart';

/// Par défaut la position est datée de maintenant ; [age] permet de simuler un
/// fix servi depuis le cache de la plateforme.
Position _position(double lat, double lng, {Duration age = Duration.zero}) {
  return Position(
    latitude: lat,
    longitude: lng,
    timestamp: DateTime.now().toUtc().subtract(age),
    accuracy: 10,
    altitude: 0,
    altitudeAccuracy: 0,
    heading: 0,
    headingAccuracy: 0,
    speed: 0,
    speedAccuracy: 0,
  );
}

/// Faux backend geolocator : chaque test décrit l'état de l'appareil.
class _FakeGeolocator extends GeolocatorPlatform {
  _FakeGeolocator({
    this.serviceEnabled = true,
    this.permission = LocationPermission.whileInUse,
    this.currentPosition,
    this.queuedPositions = const [],
    this.lastKnown,
    this.currentPositionError,
    this.permissionError,
  });

  bool serviceEnabled;
  LocationPermission permission;

  /// Réponse par défaut ; [queuedPositions] a la priorité pour simuler une
  /// suite d'appels (cache puis fix réel).
  Position? currentPosition;
  List<Position> queuedPositions;
  Position? lastKnown;
  Object? currentPositionError;
  Object? permissionError;

  LocationSettings? receivedSettings;
  final List<LocationAccuracy> requestedAccuracies = [];
  int currentPositionCalls = 0;

  @override
  Future<bool> isLocationServiceEnabled() async => serviceEnabled;

  @override
  Future<LocationPermission> checkPermission() async {
    if (permissionError != null) throw permissionError!;
    return permission;
  }

  @override
  Future<LocationPermission> requestPermission() async {
    if (permissionError != null) throw permissionError!;
    return permission;
  }

  @override
  Future<Position?> getLastKnownPosition({
    bool forceLocationManager = false,
  }) async {
    return lastKnown;
  }

  @override
  Future<Position> getCurrentPosition({
    LocationSettings? locationSettings,
  }) async {
    currentPositionCalls++;
    receivedSettings = locationSettings;
    if (locationSettings != null) {
      requestedAccuracies.add(locationSettings.accuracy);
    }
    if (currentPositionError != null) throw currentPositionError!;
    if (queuedPositions.isNotEmpty) return queuedPositions.removeAt(0);
    return currentPosition!;
  }
}

void main() {
  late _FakeGeolocator fake;

  void useFake(_FakeGeolocator instance) {
    fake = instance;
    GeolocatorPlatform.instance = instance;
  }

  test('bounds the wait for a GPS fix', () async {
    useFake(_FakeGeolocator(currentPosition: _position(50.35, 3.52)));

    await LocationService.currentPosition();

    // Sans timeLimit, geolocator attend un fix indéfiniment et l'écran
    // appelant reste bloqué en chargement.
    expect(fake.receivedSettings?.timeLimit, isNotNull);
    expect(fake.receivedSettings!.timeLimit, LocationService.fixTimeout);
  });

  test('honours a caller-supplied timeout', () async {
    useFake(_FakeGeolocator(currentPosition: _position(50.35, 3.52)));

    await LocationService.currentPosition(timeout: const Duration(seconds: 3));

    expect(fake.receivedSettings!.timeLimit, const Duration(seconds: 3));
  });

  test('returns the resolved position', () async {
    useFake(_FakeGeolocator(currentPosition: _position(50.35, 3.52)));

    final outcome = await LocationService.currentPosition();

    expect(outcome, isA<LocationResolved>());
    expect((outcome as LocationResolved).position.latitude, 50.35);
  });

  test('falls back to a recent last known position when the fix times out',
      () async {
    useFake(_FakeGeolocator(
      currentPositionError: TimeoutException('no fix'),
      lastKnown: _position(50.62, 3.05, age: const Duration(minutes: 1)),
    ));

    final outcome = await LocationService.currentPosition();

    expect(outcome, isA<LocationResolved>());
    expect((outcome as LocationResolved).position.latitude, 50.62);
  });

  // Sans borne d'âge, `getLastLocation()` rend le même fix vieilli à chaque
  // appel : les coordonnées de l'utilisateur ne changent alors plus jamais.
  test('refuses a stale last known position', () async {
    useFake(_FakeGeolocator(
      currentPositionError: TimeoutException('no fix'),
      lastKnown: _position(50.62, 3.05, age: const Duration(hours: 6)),
    ));

    final outcome = await LocationService.currentPosition();

    expect(
      (outcome as LocationUnresolved).failure,
      LocationFailure.unavailable,
    );
  });

  test('reports unavailable when the fix times out with no last known position',
      () async {
    useFake(_FakeGeolocator(
      currentPositionError: TimeoutException('no fix'),
      lastKnown: null,
    ));

    final outcome = await LocationService.currentPosition();

    expect(outcome, isA<LocationUnresolved>());
    expect(
      (outcome as LocationUnresolved).failure,
      LocationFailure.unavailable,
    );
  });

  // Le LocationRequest du plugin ne borne pas `maxUpdateAgeMillis` : la
  // plateforme peut répondre instantanément avec une position historique.
  test('retries at full accuracy when the platform serves a cached fix',
      () async {
    useFake(_FakeGeolocator(
      queuedPositions: <Position>[
        _position(48.85, 2.35, age: const Duration(hours: 3)),
        _position(50.35, 3.52),
      ],
    ));

    final outcome = await LocationService.currentPosition();

    expect((outcome as LocationResolved).position.latitude, 50.35);
    expect(fake.currentPositionCalls, 2);
    expect(fake.requestedAccuracies.last, LocationAccuracy.best);
  });

  test('does not retry when the first fix is already fresh', () async {
    useFake(_FakeGeolocator(currentPosition: _position(50.35, 3.52)));

    await LocationService.currentPosition();

    expect(fake.currentPositionCalls, 1);
  });

  test('reports unavailable when only cached fixes are ever returned',
      () async {
    final stale = _position(48.85, 2.35, age: const Duration(hours: 3));
    useFake(_FakeGeolocator(currentPosition: stale, lastKnown: stale));

    final outcome = await LocationService.currentPosition();

    // Mieux vaut un échec explicite qu'épingler l'utilisateur à un ancien lieu.
    expect(
      (outcome as LocationUnresolved).failure,
      LocationFailure.unavailable,
    );
  });

  test('reports a disabled location service without asking for a fix',
      () async {
    useFake(_FakeGeolocator(serviceEnabled: false));

    final outcome = await LocationService.currentPosition();

    expect(
      (outcome as LocationUnresolved).failure,
      LocationFailure.serviceDisabled,
    );
    expect(fake.currentPositionCalls, 0);
  });

  test('distinguishes a one-off denial from a permanent one', () async {
    useFake(_FakeGeolocator(permission: LocationPermission.denied));
    var outcome = await LocationService.currentPosition();
    expect(
      (outcome as LocationUnresolved).failure,
      LocationFailure.permissionDenied,
    );

    useFake(_FakeGeolocator(permission: LocationPermission.deniedForever));
    outcome = await LocationService.currentPosition();
    expect(
      (outcome as LocationUnresolved).failure,
      LocationFailure.permissionDeniedForever,
    );
  });

  test('surfaces a permission request already in progress as a denial',
      () async {
    // Deux écrans qui demandent la permission en même temps ne doivent pas
    // laisser un spinner tourner sur une exception non gérée.
    useFake(_FakeGeolocator(
      permissionError: const PermissionRequestInProgressException(
        'A request for location permissions is already running',
      ),
    ));

    final outcome = await LocationService.currentPosition();

    expect(
      (outcome as LocationUnresolved).failure,
      LocationFailure.permissionDenied,
    );
  });
}
