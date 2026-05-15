import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/l10n/l10n.dart';

class UserLocation {
  final double lat;
  final double lng;
  final String? cityName;

  UserLocation({required this.lat, required this.lng, this.cityName});
}

class UserLocationNotifier extends StateNotifier<AsyncValue<UserLocation?>> {
  UserLocationNotifier() : super(const AsyncValue.data(null)) {
    _initLocation();
  }

  Future<void> _initLocation() async {
    state = const AsyncValue.loading();
    try {
      final l10n = cachedAppLocalizations();
      bool serviceEnabled;
      LocationPermission permission;

      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        state = AsyncValue.error(l10n.searchLocationDisabled, StackTrace.empty);
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, next time you could try
          // requesting permissions again (this is also where
          // Android's shouldShowRequestPermissionRationale
          // returned true. According to Android guidelines
          // your App should show an explanatory UI now.
          state =
              AsyncValue.error(l10n.searchPermissionDenied, StackTrace.empty);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        state = AsyncValue.error(
            l10n.searchLocationSettingsRequired, StackTrace.empty);
        return;
      }

      // When we reach here, permissions are granted and we can
      // continue accessing the position of the device.
      final position = await Geolocator.getCurrentPosition();

      String? cityName;
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          cityName = placemarks.first.locality;
          // Some fallbacks if locality is empty (e.g. strict administrative areas)
          if (cityName == null || cityName.isEmpty) {
            cityName = placemarks.first.subAdministrativeArea;
          }
        }
      } catch (e) {
        debugPrint('Error getting placemarks: $e');
      }

      state = AsyncValue.data(UserLocation(
        lat: position.latitude,
        lng: position.longitude,
        cityName: cityName,
      ));
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> refresh() async {
    await _initLocation();
  }
}

final userLocationProvider =
    StateNotifierProvider<UserLocationNotifier, AsyncValue<UserLocation?>>(
        (ref) {
  return UserLocationNotifier();
});
