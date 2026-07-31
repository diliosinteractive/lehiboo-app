import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/analytics/analytics_provider.dart';
import 'package:lehiboo/core/analytics/noop_analytics_service.dart';
import 'package:lehiboo/core/constants/app_constants.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/petit_boo/data/datasources/petit_boo_context_storage.dart';
import 'package:lehiboo/features/petit_boo/data/models/chat_message_dto.dart';
import 'package:lehiboo/features/petit_boo/data/models/conversation_dto.dart';
import 'package:lehiboo/features/petit_boo/data/models/petit_boo_event_dto.dart';
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
  _TestAuthNotifier(Ref ref, HbUser user)
      : super(_NeverCompletingAuthRepository(), ref) {
    setUser(user);
  }

  void setUser(HbUser user) {
    state = AuthState(status: AuthStatus.authenticated, user: user);
  }
}

class _StreamRequest {
  late final StreamController<PetitBooEventDto> controller;
  bool wasCancelled = false;

  _StreamRequest() {
    controller = StreamController<PetitBooEventDto>(
      onCancel: () => wasCancelled = true,
    );
  }
}

class _ControlledPetitBooRepository implements PetitBooRepository {
  Completer<bool>? nextHealthResponse;
  final conversationRequests = <Completer<ConversationDto>>[];
  final streamRequests = <_StreamRequest>[];

  @override
  Future<bool> isServiceAvailable() {
    final response = nextHealthResponse;
    nextHealthResponse = null;
    return response?.future ?? Future.value(true);
  }

  @override
  Future<QuotaDto> getQuota() async => const QuotaDto();

  @override
  Future<ConversationDto> getConversation(String uuid) {
    final response = Completer<ConversationDto>();
    conversationRequests.add(response);
    return response.future;
  }

  @override
  Stream<PetitBooEventDto> sendMessage({
    String? sessionUuid,
    required String message,
    required bool memoryEnabled,
  }) {
    final request = _StreamRequest();
    streamRequests.add(request);
    return request.controller.stream;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

const _accountA = HbUser(
  id: 'account-a',
  email: 'a@example.test',
  displayName: 'Account A',
);

const _accountB = HbUser(
  id: 'account-b',
  email: 'b@example.test',
  displayName: 'Account B',
);

ConversationDto _conversation(String uuid, String message) => ConversationDto(
      uuid: uuid,
      createdAt: '2026-07-31T10:00:00Z',
      messages: [ChatMessageDto.assistant(content: message)],
    );

Future<
    ({
      ProviderContainer container,
      _TestAuthNotifier auth,
      ProviderSubscription<PetitBooChatState> subscription,
    })> _createContainer(
  _ControlledPetitBooRepository repository, {
  HbUser user = _accountA,
  Map<String, Object> preferences = const {},
  Map<String, String> secureStorage = const {},
}) async {
  SharedPreferences.setMockInitialValues(preferences);
  FlutterSecureStorage.setMockInitialValues(Map.of(secureStorage));
  final sharedPreferences = await SharedPreferences.getInstance();
  late _TestAuthNotifier auth;
  final container = ProviderContainer(
    overrides: [
      authProvider.overrideWith((ref) {
        auth = _TestAuthNotifier(ref, user);
        return auth;
      }),
      analyticsServiceProvider.overrideWithValue(
        const NoopAnalyticsService(),
      ),
      petitBooRepositoryProvider.overrideWithValue(repository),
      petitBooContextStorageProvider.overrideWithValue(
        PetitBooContextStorage(sharedPreferences),
      ),
    ],
  );
  final subscription = container.listen(
    petitBooChatProvider,
    (_, __) {},
    fireImmediately: true,
  );
  await pumpEventQueue(times: 20);
  return (
    container: container,
    auth: auth,
    subscription: subscription,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('late initialization cannot overwrite the next account', () async {
    final repository = _ControlledPetitBooRepository();
    final oldHealth = Completer<bool>();
    repository.nextHealthResponse = oldHealth;
    final scope = await _createContainer(repository);
    addTearDown(scope.subscription.close);
    addTearDown(scope.container.dispose);

    expect(
      scope.container.read(petitBooChatProvider).serviceStatus,
      PetitBooServiceStatus.checking,
    );

    scope.auth.setUser(_accountB);
    await pumpEventQueue(times: 20);
    expect(
      scope.container.read(petitBooChatProvider).serviceStatus,
      PetitBooServiceStatus.available,
    );

    oldHealth.complete(false);
    await pumpEventQueue(times: 10);
    expect(
      scope.container.read(petitBooChatProvider).serviceStatus,
      PetitBooServiceStatus.available,
    );
  });

  test('late conversation load cannot populate the next account', () async {
    final repository = _ControlledPetitBooRepository();
    final scope = await _createContainer(repository);
    addTearDown(scope.subscription.close);
    addTearDown(scope.container.dispose);

    final oldLoad = scope.container
        .read(petitBooChatProvider.notifier)
        .loadSession('account-a-session');
    await pumpEventQueue();
    expect(repository.conversationRequests, hasLength(1));

    scope.auth.setUser(_accountB);
    await pumpEventQueue(times: 20);
    repository.conversationRequests.single.complete(
      _conversation('account-a-session', 'Account A private answer'),
    );
    await oldLoad;
    await pumpEventQueue();

    final state = scope.container.read(petitBooChatProvider);
    expect(state.sessionUuid, isNull);
    expect(state.messages, isEmpty);
    expect(state.isLoading, isFalse);
  });

  test('old SSE stream is cancelled and cannot reach the next account',
      () async {
    final repository = _ControlledPetitBooRepository();
    final scope = await _createContainer(repository);
    addTearDown(scope.subscription.close);
    addTearDown(scope.container.dispose);

    await scope.container
        .read(petitBooChatProvider.notifier)
        .sendMessage('private prompt');
    final oldStream = repository.streamRequests.single;
    oldStream.controller.add(
      const PetitBooEventDto(
        type: 'session',
        sessionUuid: 'account-a-session',
      ),
    );
    await pumpEventQueue(times: 10);

    scope.auth.setUser(_accountB);
    await pumpEventQueue(times: 20);
    expect(oldStream.wasCancelled, isTrue);

    oldStream.controller
      ..add(const PetitBooEventDto(type: 'token', content: 'Private answer'))
      ..add(const PetitBooEventDto(type: 'done'));
    await pumpEventQueue();

    final state = scope.container.read(petitBooChatProvider);
    expect(state.sessionUuid, isNull);
    expect(state.messages, isEmpty);
    expect(state.currentStreamingText, isEmpty);
    await oldStream.controller.close();
  });

  test('persisted session and memory are restored only for their owner',
      () async {
    final repository = _ControlledPetitBooRepository();
    final scope = await _createContainer(
      repository,
      user: _accountB,
      preferences: {
        'petit_boo_user_context': jsonEncode({
          '_storage_account_id': _accountA.id,
          'data': {'private_note': 'Account A only'},
        }),
        'petit_boo_memory_enabled': false,
        'petit_boo_memory_enabled_owner': _accountA.id,
      },
      secureStorage: {
        AppConstants.keyPetitBooSessionUuid: jsonEncode({
          'version': 1,
          'account_id': _accountA.id,
          'session_uuid': 'account-a-session',
        }),
      },
    );
    addTearDown(scope.subscription.close);
    addTearDown(scope.container.dispose);

    final state = scope.container.read(petitBooChatProvider);
    expect(state.sessionUuid, isNull);
    expect(state.userContext, isEmpty);
    expect(state.isMemoryEnabled, isTrue);
  });
}
