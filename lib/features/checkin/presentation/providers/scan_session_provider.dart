import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/providers/auth_session_key_provider.dart';

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
  ScanSessionNotifier({
    required String? accountId,
    required String? Function() currentAccountId,
  })  : _accountId = accountId,
        _currentAccountId = currentAccountId,
        super(const ScanSession()) {
    if (accountId != null) _loadDeviceInfo();
  }

  final String? _accountId;
  final String? Function() _currentAccountId;

  bool get _ownsCurrentSession =>
      mounted && _accountId != null && _currentAccountId() == _accountId;

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
      if (!_ownsCurrentSession) return;
      state = state.copyWith(deviceId: id, deviceName: name);
    } catch (_) {
      // Best effort — gate metadata is optional, see spec §4.1.
    }
  }

  void setGate(String? gate) {
    if (!_ownsCurrentSession) return;
    state = ScanSession(
      deviceId: state.deviceId,
      deviceName: state.deviceName,
      gate: gate,
    );
  }
}

final scanSessionProvider =
    StateNotifierProvider<ScanSessionNotifier, ScanSession>(
  (ref) {
    ref.watch(authSessionKeyProvider);
    final accountId = ref.watch(authSessionUserIdProvider);
    return ScanSessionNotifier(
      accountId: accountId,
      currentAccountId: () => ref.read(authSessionUserIdProvider),
    );
  },
);
