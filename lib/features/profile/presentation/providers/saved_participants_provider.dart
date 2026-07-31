import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_session_key_provider.dart';
import 'package:lehiboo/features/profile/data/datasources/saved_participants_api_datasource.dart';
import 'package:lehiboo/features/profile/domain/models/saved_participant.dart';

final savedParticipantsProvider = StateNotifierProvider.autoDispose<
    SavedParticipantsNotifier, AsyncValue<List<SavedParticipant>>>((ref) {
  final ownerSession = ref.watch(authSessionKeyProvider);
  final api = ref.watch(savedParticipantsApiDataSourceProvider);
  return SavedParticipantsNotifier(
    api,
    accountId: ownerSession.accountId,
  );
});

final savedParticipantsActionsProvider =
    Provider<SavedParticipantsActions>((ref) {
  final ownerSession = ref.watch(authSessionKeyProvider);
  return SavedParticipantsActions(ref, ownerSession: ownerSession);
});

class SavedParticipantsNotifier
    extends StateNotifier<AsyncValue<List<SavedParticipant>>> {
  SavedParticipantsNotifier(
    this._api, {
    required String? accountId,
  })  : _accountId = accountId,
        super(
          accountId == null
              ? const AsyncValue.data([])
              : const AsyncValue.loading(),
        ) {
    if (accountId != null) _load();
  }

  final SavedParticipantsApiDataSource _api;
  final String? _accountId;
  int _requestGeneration = 0;

  Future<void> _load() async {
    final requestGeneration = ++_requestGeneration;
    if (_accountId == null) return;

    try {
      final participants = await _api.list();
      if (!mounted || requestGeneration != _requestGeneration) return;
      state = AsyncValue.data(participants);
    } catch (error, stackTrace) {
      if (!mounted || requestGeneration != _requestGeneration) return;
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

class SavedParticipantsActions {
  final Ref _ref;
  final AuthSessionKey _ownerSession;

  const SavedParticipantsActions(
    this._ref, {
    required AuthSessionKey ownerSession,
  }) : _ownerSession = ownerSession;

  bool get _ownsActiveAccount {
    if (_ownerSession.accountId == null) return false;
    try {
      return identical(
        _ref.read(authSessionKeyProvider),
        _ownerSession,
      );
    } catch (_) {
      // A retained action object may outlive its provider after an account
      // switch. A disposed Ref must never be used to issue a mutation.
      return false;
    }
  }

  void _requireActiveAccount() {
    if (!_ownsActiveAccount) {
      throw StateError('The authenticated account changed. Please try again.');
    }
  }

  Future<void> create(SavedParticipant participant) async {
    _requireActiveAccount();
    await _ref.read(savedParticipantsApiDataSourceProvider).create(participant);
    if (_ownsActiveAccount) _ref.invalidate(savedParticipantsProvider);
  }

  Future<void> update(SavedParticipant participant) async {
    _requireActiveAccount();
    await _ref.read(savedParticipantsApiDataSourceProvider).update(participant);
    if (_ownsActiveAccount) _ref.invalidate(savedParticipantsProvider);
  }

  Future<void> delete(String uuid) async {
    _requireActiveAccount();
    await _ref.read(savedParticipantsApiDataSourceProvider).delete(uuid);
    if (_ownsActiveAccount) _ref.invalidate(savedParticipantsProvider);
  }
}
