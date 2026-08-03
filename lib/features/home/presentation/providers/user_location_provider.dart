import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/services/location_service.dart';

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
      final l10n = cachedAppLocalizations();
      final outcome = await LocationService.currentPosition();

      switch (outcome) {
        case LocationUnresolved(:final failure):
          _setErrorIfNoFallback(
            previousLocation,
            switch (failure) {
              LocationFailure.serviceDisabled => l10n.searchLocationDisabled,
              LocationFailure.permissionDenied => l10n.searchPermissionDenied,
              LocationFailure.permissionDeniedForever =>
                l10n.searchLocationSettingsRequired,
              LocationFailure.unavailable => l10n.searchLocationNotFound,
            },
            StackTrace.empty,
          );

        case LocationResolved(:final position):
          final cityName = await _resolveCityName(position);
          if (!mounted) return;
          _lastResolvedAt = DateTime.now();
          state = AsyncValue.data(
            UserLocation(
              lat: position.latitude,
              lng: position.longitude,
              cityName: cityName,
            ),
          );
      }
    } catch (error, stackTrace) {
      _setErrorIfNoFallback(previousLocation, error, stackTrace);
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  /// Reverse-geocoding best-effort : une position sans nom de ville reste
  /// exploitable pour le feed.
  Future<String?> _resolveCityName(Position position) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isEmpty) return null;

      final locality = placemarks.first.locality;
      if (locality != null && locality.isNotEmpty) return locality;
      // Some providers only expose the administrative area.
      return placemarks.first.subAdministrativeArea;
    } catch (error) {
      debugPrint('Error getting placemarks: $error');
      return null;
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
