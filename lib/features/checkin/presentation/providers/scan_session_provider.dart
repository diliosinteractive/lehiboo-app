import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Per-session scanner config persisted only in-memory: the device
/// identifiers (set once via `device_info_plus`) and the optional gate
/// label the vendor types in the scan screen.
class ScanSession {
  final String? deviceId;
  final String? deviceName;
  final String? gate;

  const ScanSession({this.deviceId, this.deviceName, this.gate});

  ScanSession copyWith({String? deviceId, String? deviceName, String? gate}) {
    return ScanSession(
      deviceId: deviceId ?? this.deviceId,
      deviceName: deviceName ?? this.deviceName,
      gate: gate ?? this.gate,
    );
  }
}

class ScanSessionNotifier extends StateNotifier<ScanSession> {
  ScanSessionNotifier() : super(const ScanSession()) {
    _loadDeviceInfo();
  }

  Future<void> _loadDeviceInfo() async {
    try {
      final plugin = DeviceInfoPlugin();
      String? id;
      String? name;
      if (Platform.isAndroid) {
        final info = await plugin.androidInfo;
        id = info.id;
        name = '${info.manufacturer} ${info.model}'.trim();
      } else if (Platform.isIOS) {
        final info = await plugin.iosInfo;
        id = info.identifierForVendor;
        name = info.utsname.machine;
      }
      state = state.copyWith(deviceId: id, deviceName: name);
    } catch (_) {
      // Best effort — gate metadata is optional, see spec §4.1.
    }
  }

  void setGate(String? gate) {
    state = state.copyWith(gate: gate);
  }
}

final scanSessionProvider =
    StateNotifierProvider<ScanSessionNotifier, ScanSession>(
  (ref) => ScanSessionNotifier(),
);
