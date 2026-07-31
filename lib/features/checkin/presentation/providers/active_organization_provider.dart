import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../config/dio_client.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/providers/auth_session_key_provider.dart';
import '../../domain/entities/active_organization.dart';

/// Storage key for the persisted active vendor organization. `_v1` lets us
/// identify and discard the old ownerless schema. It must never be restored:
/// the app cannot prove which account wrote it.
const _kLegacyActiveOrgStorageKey = 'active_org_v1';
const _kActiveOrgStorageKeyPrefix = 'active_org_v2_';

@visibleForTesting
String activeOrganizationStorageKeyForAccount(String accountId) {
  final encoded = base64Url.encode(utf8.encode(accountId)).replaceAll('=', '');
  return '$_kActiveOrgStorageKeyPrefix$encoded';
}

abstract interface class ActiveOrganizationStorage {
  Future<String?> read({required String key});
  Future<void> write({required String key, required String value});
  Future<void> delete({required String key});
}

class SecureActiveOrganizationStorage implements ActiveOrganizationStorage {
  const SecureActiveOrganizationStorage(this._storage);

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read({required String key}) => _storage.read(key: key);

  @override
  Future<void> write({required String key, required String value}) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete({required String key}) => _storage.delete(key: key);
}

final activeOrganizationStorageProvider =
    Provider<ActiveOrganizationStorage>((ref) {
  return const SecureActiveOrganizationStorage(SharedSecureStorage.instance);
});

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
  ActiveOrganizationNotifier(
    this._storage, {
    required String? accountId,
    required String? Function() currentAccountId,
  })  : _accountId = accountId,
        _currentAccountId = currentAccountId,
        super(null) {
    // Header state must be cleared synchronously on logout and A -> B before
    // either account's asynchronous secure-storage read can complete.
    ActiveOrganizationCache._set(null);
    unawaited(_discardLegacyRecord());
    if (accountId != null) unawaited(_rehydrate());
  }

  final ActiveOrganizationStorage _storage;
  final String? _accountId;
  final String? Function() _currentAccountId;
  int _operationGeneration = 0;

  bool get _ownsActiveAccount {
    if (!mounted || _accountId == null) return false;
    try {
      return _currentAccountId() == _accountId;
    } catch (_) {
      return false;
    }
  }

  bool _isCurrent(int generation) {
    return _ownsActiveAccount && generation == _operationGeneration;
  }

  Future<void> _discardLegacyRecord() async {
    try {
      await _storage.delete(key: _kLegacyActiveOrgStorageKey);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('ActiveOrganizationNotifier: legacy clear failed: $e');
      }
    }
  }

  Future<void> _rehydrate() async {
    final accountId = _accountId;
    if (accountId == null) return;
    final generation = ++_operationGeneration;
    try {
      final raw = await _storage.read(
        key: activeOrganizationStorageKeyForAccount(accountId),
      );
      if (!_isCurrent(generation)) return;
      if (raw == null || raw.isEmpty) return;
      final json = jsonDecode(raw);
      if (json is! Map<String, dynamic>) return;
      if (json['account_id']?.toString() != accountId) return;
      final rawOrg = json['organization'];
      if (rawOrg is! Map<String, dynamic>) return;
      final org = ActiveOrganization.fromJson(rawOrg);
      if (org == null) return;
      if (!_isCurrent(generation)) return;
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
    final accountId = _accountId;
    if (!_ownsActiveAccount || accountId == null) {
      throw StateError(
        'The authenticated account changed. Select the organization again.',
      );
    }
    final generation = ++_operationGeneration;
    state = org;
    ActiveOrganizationCache._set(org.uuid);
    try {
      await _storage.write(
        key: activeOrganizationStorageKeyForAccount(accountId),
        value: jsonEncode({
          'account_id': accountId,
          'organization': org.toJson(),
        }),
      );
      // No post-write publication: if the account changed while secure
      // storage was pending, the replacement notifier already cleared the
      // request-header cache synchronously.
      if (!_isCurrent(generation)) return;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('ActiveOrganizationNotifier: persist failed: $e');
      }
    }
  }

  /// Clear the active organization when the current account explicitly
  /// switches organization. Auth/account transitions recreate this notifier
  /// and clear the in-memory header cache synchronously; the persisted record
  /// remains harmless because it is keyed and tagged by its owning account.
  Future<void> clear() async {
    final accountId = _accountId;
    if (!_ownsActiveAccount || accountId == null) return;
    final generation = ++_operationGeneration;
    state = null;
    ActiveOrganizationCache._set(null);
    try {
      await _storage.delete(
        key: activeOrganizationStorageKeyForAccount(accountId),
      );
      if (!_isCurrent(generation)) return;
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
    ref.watch(authSessionKeyProvider);
    final accountId = ref.watch(authSessionUserIdProvider);
    final storage = ref.watch(activeOrganizationStorageProvider);
    return ActiveOrganizationNotifier(
      storage,
      accountId: accountId,
      currentAccountId: () => ref.read(authSessionUserIdProvider),
    );
  },
);
