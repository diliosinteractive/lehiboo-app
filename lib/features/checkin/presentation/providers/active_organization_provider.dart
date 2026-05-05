import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../config/dio_client.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/active_organization.dart';

/// Storage key for the persisted active vendor organization. `_v1` lets us
/// invalidate transparently if the schema changes later.
const _kActiveOrgStorageKey = 'active_org_v1';

/// Process-wide cache of the active organization UUID. The Dio
/// `OrganizationHeaderInterceptor` reads from this synchronously when
/// building each request — interceptors can't `await` Riverpod or secure
/// storage on the request hot path.
///
/// The notifier below is the only writer; it keeps this cache in lockstep
/// with its own state. App startup rehydrates from secure storage before
/// the user can reach the vendor screens.
class ActiveOrganizationCache {
  ActiveOrganizationCache._();

  static String? _uuid;

  /// Read the UUID for header injection. Returns null when no org is
  /// active; the interceptor must then skip header injection (or refuse
  /// the request — see interceptor for the actual policy).
  static String? get uuid => _uuid;

  static void _set(String? value) {
    _uuid = (value != null && value.isNotEmpty) ? value : null;
  }
}

/// `StateNotifier<ActiveOrganization?>` — the in-memory + persisted active
/// org for the vendor check-in feature. Rehydrates from secure storage on
/// construction and writes through on every set/clear.
class ActiveOrganizationNotifier extends StateNotifier<ActiveOrganization?> {
  ActiveOrganizationNotifier(this._storage) : super(null) {
    _rehydrate();
  }

  final FlutterSecureStorage _storage;

  Future<void> _rehydrate() async {
    try {
      final raw = await _storage.read(key: _kActiveOrgStorageKey);
      if (raw == null || raw.isEmpty) return;
      final json = jsonDecode(raw);
      if (json is! Map<String, dynamic>) return;
      final org = ActiveOrganization.fromJson(json);
      if (org == null) return;
      state = org;
      ActiveOrganizationCache._set(org.uuid);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('ActiveOrganizationNotifier: rehydrate failed: $e');
      }
    }
  }

  /// Set the active organization and persist it. Updates the synchronous
  /// cache used by the Dio interceptor.
  Future<void> set(ActiveOrganization org) async {
    state = org;
    ActiveOrganizationCache._set(org.uuid);
    try {
      await _storage.write(
        key: _kActiveOrgStorageKey,
        value: jsonEncode(org.toJson()),
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('ActiveOrganizationNotifier: persist failed: $e');
      }
    }
  }

  /// Clear the active organization (called on logout and "switch
  /// organization"). Best-effort persisted clear; in-memory state is
  /// cleared synchronously regardless.
  Future<void> clear() async {
    state = null;
    ActiveOrganizationCache._set(null);
    try {
      await _storage.delete(key: _kActiveOrgStorageKey);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('ActiveOrganizationNotifier: clear failed: $e');
      }
    }
  }
}

final activeOrganizationProvider =
    StateNotifierProvider<ActiveOrganizationNotifier, ActiveOrganization?>(
  (ref) {
    final notifier = ActiveOrganizationNotifier(SharedSecureStorage.instance);
    // Clear the active org whenever auth flips to unauthenticated. Covers
    // explicit logout AND the 401 force-logout path — both end with the
    // auth state machine in `unauthenticated`.
    ref.listen<AuthStatus>(
      authProvider.select((s) => s.status),
      (previous, next) {
        if (next == AuthStatus.unauthenticated &&
            previous != AuthStatus.unauthenticated &&
            previous != AuthStatus.initial) {
          unawaited(notifier.clear());
        }
      },
    );
    return notifier;
  },
);
