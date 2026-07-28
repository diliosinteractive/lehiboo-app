import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class UserLocation {
  final double lat;
  final double lng;
  final String? cityName;

  UserLocation({required this.lat, required this.lng, this.cityName});
}

class UserLocationNotifier extends StateNotifier<AsyncValue<UserLocation?>>
    with WidgetsBindingObserver {
  static const _locationFreshness = Duration(minutes: 15);

  UserLocationNotifier() : super(const AsyncValue.data(null)) {
    WidgetsBinding.instance.addObserver(this);
    unawaited(refresh().catchError((_) {}));
  }

  Future<void>? _refreshInFlight;
  DateTime? _lastResolvedAt;

  Future<void> _resolveLocation() async {
    final previousLocation = state.valueOrNull;
    if (previousLocation == null) {
      state = const AsyncValue.loading();
    }

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _setErrorIfNoFallback(
          previousLocation,
          'Location services are disabled.',
          StackTrace.empty,
        );
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _setErrorIfNoFallback(
            previousLocation,
            'Location permissions are denied',
            StackTrace.empty,
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _setErrorIfNoFallback(
          previousLocation,
          'Location permissions are permanently denied, we cannot request permissions.',
          StackTrace.empty,
        );
        return;
      }

      final position = await Geolocator.getCurrentPosition();

      String? cityName;
      try {
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          cityName = placemarks.first.locality;
          if (cityName == null || cityName.isEmpty) {
            cityName = placemarks.first.subAdministrativeArea;
          }
        }
      } catch (error) {
        debugPrint('Error getting placemarks: $error');
      }

      if (!mounted) return;
      _lastResolvedAt = DateTime.now();
      state = AsyncValue.data(
        UserLocation(
          lat: position.latitude,
          lng: position.longitude,
          cityName: cityName,
        ),
      );
    } catch (error, stackTrace) {
      _setErrorIfNoFallback(previousLocation, error, stackTrace);
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  void _setErrorIfNoFallback(
    UserLocation? previousLocation,
    Object error,
    StackTrace stackTrace,
  ) {
    if (!mounted || previousLocation != null) return;
    state = AsyncValue.error(error, stackTrace);
  }

  Future<void> refresh() {
    return _refreshInFlight ??= _resolveLocation().whenComplete(() {
      _refreshInFlight = null;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;

    final resolvedAt = _lastResolvedAt;
    final isStale = resolvedAt == null ||
        DateTime.now().difference(resolvedAt) >= _locationFreshness;
    if (this.state.hasError || isStale) {
      unawaited(refresh().catchError((_) {}));
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

final userLocationProvider =
    StateNotifierProvider<UserLocationNotifier, AsyncValue<UserLocation?>>(
        (ref) {
  return UserLocationNotifier();
});
