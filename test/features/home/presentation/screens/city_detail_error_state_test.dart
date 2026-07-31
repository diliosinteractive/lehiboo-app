import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/domain/entities/city.dart';
import 'package:lehiboo/features/events/domain/repositories/event_repository.dart';
import 'package:lehiboo/features/home/presentation/screens/city_detail_screen.dart';

void main() {
  test('city lookup preserves API failures instead of returning not found',
      () async {
    final failure = Exception('cities unavailable');
    final container = ProviderContainer(
      overrides: [
        eventRepositoryProvider.overrideWithValue(
          _CityRepository(failure: failure),
        ),
      ],
    );
    addTearDown(container.dispose);

    await expectLater(
      container.read(cityDetailProvider('paris').future),
      throwsA(same(failure)),
    );
  });

  test('city activity results retain and explicitly clear load-more errors',
      () {
    final failure = Exception('next page unavailable');
    final failed = const CityActivitiesResult(
      activities: [],
      total: 30,
      page: 1,
      lastPage: 2,
    ).copyWith(loadMoreError: failure);

    expect(failed.loadMoreError, same(failure));
    expect(failed.copyWith().loadMoreError, same(failure));
    expect(failed.copyWith(loadMoreError: null).loadMoreError, isNull);
  });
}

class _CityRepository implements EventRepository {
  const _CityRepository({required this.failure});

  final Object failure;

  @override
  Future<List<City>> getCities() async => throw failure;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
