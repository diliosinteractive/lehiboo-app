import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lehiboo/features/profile/data/datasources/saved_participants_api_datasource.dart';
import 'package:lehiboo/features/profile/domain/models/saved_participant.dart';

final savedParticipantsProvider =
    FutureProvider.autoDispose<List<SavedParticipant>>((ref) async {
  return ref.read(savedParticipantsApiDataSourceProvider).list();
});

final savedParticipantsActionsProvider =
    Provider<SavedParticipantsActions>((ref) {
  return SavedParticipantsActions(ref);
});

class SavedParticipantsActions {
  final Ref _ref;

  const SavedParticipantsActions(this._ref);

  Future<void> create(SavedParticipant participant) async {
    await _ref.read(savedParticipantsApiDataSourceProvider).create(participant);
    _ref.invalidate(savedParticipantsProvider);
  }

  Future<void> update(SavedParticipant participant) async {
    await _ref.read(savedParticipantsApiDataSourceProvider).update(participant);
    _ref.invalidate(savedParticipantsProvider);
  }

  Future<void> delete(String uuid) async {
    await _ref.read(savedParticipantsApiDataSourceProvider).delete(uuid);
    _ref.invalidate(savedParticipantsProvider);
  }
}
