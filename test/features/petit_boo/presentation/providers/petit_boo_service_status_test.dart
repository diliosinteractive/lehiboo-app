import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/petit_boo/data/datasources/petit_boo_context_storage.dart';
import 'package:lehiboo/features/petit_boo/data/models/quota_dto.dart';
import 'package:lehiboo/features/petit_boo/domain/repositories/petit_boo_repository.dart';
import 'package:lehiboo/features/petit_boo/presentation/providers/petit_boo_chat_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _NeverCompletingAuthRepository implements AuthRepository {
  final _result = Completer<bool>();

  @override
  Future<bool> isAuthenticated() => _result.future;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _TestAuthNotifier extends AuthNotifier {
  _TestAuthNotifier(Ref ref) : super(_NeverCompletingAuthRepository(), ref) {
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

class _HealthRepository implements PetitBooRepository {
  bool isAvailable;
  Object? error;
  Completer<bool>? pendingCheck;

  _HealthRepository({required this.isAvailable, this.error});

  @override
  Future<bool> isServiceAvailable() async {
    final pending = pendingCheck;
    if (pending != null) {
      pendingCheck = null;
      return pending.future;
    }
    final currentError = error;
    if (currentError != null) throw currentError;
    return isAvailable;
  }

  @override
  Future<QuotaDto> getQuota() async => const QuotaDto();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Future<ProviderContainer> _createContainer(_HealthRepository repository) async {
  SharedPreferences.setMockInitialValues({});
  FlutterSecureStorage.setMockInitialValues({});
  final preferences = await SharedPreferences.getInstance();

  final container = ProviderContainer(
    overrides: [
      authProvider.overrideWith((ref) => _TestAuthNotifier(ref)),
      petitBooRepositoryProvider.overrideWithValue(repository),
      petitBooContextStorageProvider.overrideWithValue(
        PetitBooContextStorage(preferences),
      ),
    ],
  );
  container.read(petitBooChatProvider);
  await pumpEventQueue(times: 20);
  return container;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('a failed readiness request is not reported as service unavailable',
      () async {
    final repository = _HealthRepository(
      isAvailable: false,
      error: StateError('offline'),
    );
    final container = await _createContainer(repository);
    addTearDown(container.dispose);

    expect(
      container.read(petitBooChatProvider).serviceStatus,
      PetitBooServiceStatus.checkFailed,
    );
    expect(container.read(petitBooChatProvider).canSendMessage, isFalse);

    repository
      ..error = null
      ..isAvailable = true;
    await container
        .read(petitBooChatProvider.notifier)
        .checkServiceAvailability();

    expect(
      container.read(petitBooChatProvider).serviceStatus,
      PetitBooServiceStatus.available,
    );
    expect(container.read(petitBooChatProvider).canSendMessage, isTrue);
  });

  test('a completed unhealthy response is reported as service unavailable',
      () async {
    final repository = _HealthRepository(isAvailable: false);
    final container = await _createContainer(repository);
    addTearDown(container.dispose);

    expect(
      container.read(petitBooChatProvider).serviceStatus,
      PetitBooServiceStatus.unavailable,
    );
    expect(container.read(petitBooChatProvider).canSendMessage, isFalse);
  });

  test('a retry blocks sending while the readiness check is pending', () async {
    final repository = _HealthRepository(isAvailable: true);
    final container = await _createContainer(repository);
    addTearDown(container.dispose);
    final pending = Completer<bool>();
    repository.pendingCheck = pending;

    final retry = container
        .read(petitBooChatProvider.notifier)
        .checkServiceAvailability();

    expect(
      container.read(petitBooChatProvider).serviceStatus,
      PetitBooServiceStatus.checking,
    );
    expect(container.read(petitBooChatProvider).canSendMessage, isFalse);

    pending.complete(true);
    await retry;
    expect(
      container.read(petitBooChatProvider).serviceStatus,
      PetitBooServiceStatus.available,
    );
  });
}
