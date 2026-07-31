import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/partners/data/datasources/organizer_api_datasource.dart';
import 'package:lehiboo/features/partners/data/models/organizer_profile_dto.dart';
import 'package:lehiboo/features/partners/domain/repositories/organizer_repository.dart';
import 'package:lehiboo/features/partners/presentation/providers/followed_organizers_providers.dart';
import 'package:lehiboo/features/partners/presentation/providers/organizer_profile_providers.dart';

class _FailingOrganizerRepository implements OrganizerRepository {
  _FailingOrganizerRepository(this.failure);

  final Object failure;

  @override
  Future<OrganizerProfileDto> getProfile(String identifier) async => _organizer;

  @override
  Future<FollowedOrganizersPage> getFollowing({
    String? search,
    int page = 1,
    int perPage = 20,
  }) async {
    return FollowedOrganizersPage(
      items: [_organizer],
      page: 1,
      perPage: perPage,
      total: 1,
      lastPage: 1,
    );
  }

  @override
  Future<FollowStateDto> follow(String identifier) => Future.error(failure);

  @override
  Future<FollowStateDto> unfollow(String identifier) => Future.error(failure);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

const _organizer = OrganizerProfileDto(
  uuid: 'organizer-1',
  slug: 'organizer',
  name: 'Organizer',
  followersCount: 4,
  isFollowed: false,
);

void main() {
  test('profile follow rollback rethrows so the button can explain failure',
      () async {
    final failure = StateError('follow rejected');
    final container = _containerWithFailure(failure);
    addTearDown(container.dispose);
    final provider = followStateControllerProvider(_organizer.uuid);
    final subscription = container.listen(
      provider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);
    await container
        .read(organizerProfileFutureProvider(_organizer.uuid).notifier)
        .refresh();

    final mutation = container.read(provider.notifier).toggle();
    expect(container.read(provider).valueOrNull?.isFollowed, isTrue);
    expect(container.read(provider).valueOrNull?.isInFlight, isTrue);

    await expectLater(mutation, throwsA(same(failure)));

    final rolledBack = container.read(provider).valueOrNull;
    expect(rolledBack?.isFollowed, isFalse);
    expect(rolledBack?.followersCount, 4);
    expect(rolledBack?.isInFlight, isFalse);
  });

  test('list unfollow restores the row and rethrows for user feedback',
      () async {
    final failure = StateError('unfollow rejected');
    final container = _containerWithFailure(failure);
    addTearDown(container.dispose);
    final subscription = container.listen(
      followedOrganizersControllerProvider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);
    await container
        .read(followedOrganizersControllerProvider.notifier)
        .refresh();

    final mutation = container
        .read(followedOrganizersControllerProvider.notifier)
        .unfollow(_organizer.uuid);
    expect(
      container.read(followedOrganizersControllerProvider).valueOrNull?.items,
      isEmpty,
    );

    await expectLater(mutation, throwsA(same(failure)));

    expect(
      container
          .read(followedOrganizersControllerProvider)
          .valueOrNull
          ?.items
          .single
          .uuid,
      _organizer.uuid,
    );
  });
}

ProviderContainer _containerWithFailure(Object failure) {
  return ProviderContainer(
    overrides: [
      authSessionUserIdProvider.overrideWithValue('user-a'),
      organizerRepositoryProvider.overrideWithValue(
        _FailingOrganizerRepository(failure),
      ),
    ],
  );
}
