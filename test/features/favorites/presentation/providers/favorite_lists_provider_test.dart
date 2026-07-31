import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/favorites/domain/entities/favorite_list.dart';
import 'package:lehiboo/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:lehiboo/features/favorites/presentation/providers/favorite_lists_provider.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';

void main() {
  test('favorite-list mutation failures are propagated to the UI', () async {
    final failure = Exception('create failed');
    final repository = _FailingFavoritesRepository(failure);
    final provider = StateNotifierProvider<FavoriteListsNotifier,
        AsyncValue<List<FavoriteList>>>(
      (ref) => FavoriteListsNotifier(repository, ref),
    );
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider
            .overrideWithValue(const _LoggedOutAuthRepository()),
      ],
    );
    addTearDown(container.dispose);

    await expectLater(
      container.read(provider.notifier).createList(name: 'Week-end'),
      throwsA(same(failure)),
    );
  });
}

class _LoggedOutAuthRepository implements AuthRepository {
  const _LoggedOutAuthRepository();

  @override
  Future<bool> isAuthenticated() async => false;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FailingFavoritesRepository implements FavoritesRepository {
  const _FailingFavoritesRepository(this.failure);

  final Object failure;

  @override
  Future<List<FavoriteList>> getLists() async => const [];

  @override
  Future<FavoriteList> createList({
    required String name,
    String? description,
    String? color,
    String? icon,
  }) async {
    throw failure;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
