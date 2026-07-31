import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/l10n/l10n.dart';
import 'package:lehiboo/features/alerts/domain/entities/alert.dart';
import 'package:lehiboo/features/alerts/domain/repositories/alerts_repository.dart';
import 'package:lehiboo/features/alerts/presentation/providers/alerts_provider.dart';
import 'package:lehiboo/features/events/domain/entities/event_question.dart';
import 'package:lehiboo/features/events/domain/repositories/event_questions_repository.dart';
import 'package:lehiboo/features/events/domain/repositories/event_repository.dart';
import 'package:lehiboo/features/events/presentation/providers/event_questions_providers.dart';
import 'package:lehiboo/features/events/presentation/screens/event_list_screen.dart';
import 'package:lehiboo/features/search/domain/models/event_filter.dart';

void main() {
  test('saved-search creation rethrows the repository failure', () async {
    final failure = Exception('save failed');
    final repository = _FailingAlertsRepository(failure);
    final testProvider =
        StateNotifierProvider<AlertsNotifier, AsyncValue<List<Alert>>>(
      (ref) => AlertsNotifier(repository, ref, isAuthenticated: false),
    );
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(testProvider.notifier);

    await expectLater(
      notifier.createAlert(
        name: 'Weekend',
        filter: const EventFilter(),
      ),
      throwsA(same(failure)),
    );
    expect(container.read(testProvider).hasError, isTrue);
    expect(container.read(testProvider).valueOrNull, isEmpty);
  });

  test('alert deletion failure propagates and preserves the loaded list',
      () async {
    final failure = Exception('delete failed');
    final repository = _FailingAlertsRepository(failure);
    final testProvider =
        StateNotifierProvider<AlertsNotifier, AsyncValue<List<Alert>>>(
      (ref) => AlertsNotifier(repository, ref, isAuthenticated: true),
    );
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(testProvider.notifier);
    await notifier.loadAlerts();
    expect(container.read(testProvider).valueOrNull, [_alert]);

    await expectLater(
      notifier.deleteAlert(_alert.id),
      throwsA(same(failure)),
    );
    expect(container.read(testProvider).valueOrNull, [_alert]);
    expect(container.read(testProvider).hasError, isFalse);
  });

  test('event list provider propagates repository failures', () async {
    final failure = Exception('events failed');
    final container = ProviderContainer(
      overrides: [
        eventRepositoryProvider.overrideWithValue(
          _FailingEventRepository(failure),
        ),
      ],
    );
    addTearDown(container.dispose);

    await expectLater(
      container.read(
        eventsListProvider(const EventsListParams()).future,
      ),
      throwsA(same(failure)),
    );
  });

  test('question creation uses its action-specific fallback', () async {
    final repository = _FailingQuestionsRepository(StateError('broken'));
    final testProvider = StateNotifierProvider<EventQuestionsActionsController,
        AsyncValue<void>>(
      (ref) => EventQuestionsActionsController(repository, ref),
    );
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final result = await container
        .read(testProvider.notifier)
        .createQuestion(eventSlug: 'event', text: 'A valid question?');

    expect(result, isA<CreateQuestionFailure>());
    expect(
      (result as CreateQuestionFailure).errorMessage,
      cachedAppLocalizations().eventQuestionSubmitFailed,
    );
  });
}

class _FailingAlertsRepository implements AlertsRepository {
  _FailingAlertsRepository(this.failure);

  final Object failure;

  @override
  Future<List<Alert>> getAlerts() async => [_alert];

  @override
  Future<Alert> createAlert(
    String name,
    EventFilter filter, {
    bool enablePush = true,
    bool enableEmail = false,
  }) async {
    throw failure;
  }

  @override
  Future<void> deleteAlert(String id) async => throw failure;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final _alert = Alert(
  id: 'alert-1',
  name: 'Weekend',
  filter: const EventFilter(),
  createdAt: DateTime(2026),
);

class _FailingEventRepository implements EventRepository {
  _FailingEventRepository(this.failure);

  final Object failure;

  @override
  Future<EventsResult> getEvents({
    int page = 1,
    int perPage = 20,
    String? search,
    int? categoryId,
    String? categorySlug,
    String? thematique,
    String? city,
    String? location,
    String? dateFrom,
    String? dateTo,
    double? priceMin,
    double? priceMax,
    bool? freeOnly,
    int? cityRadiusKm,
    bool? familyFriendly,
    bool? accessiblePmr,
    bool? onlineOnly,
    bool? inPersonOnly,
    String? publicFilters,
    String? targetAudiences,
    String? eventTag,
    String? specialEvents,
    String? emotions,
    bool? availableOnly,
    String? locationType,
    String? venueType,
    bool? indoor,
    bool? outdoor,
    int? ageMin,
    double? lat,
    double? lng,
    int? radius,
    double? northEastLat,
    double? northEastLng,
    double? southWestLat,
    double? southWestLng,
    bool? lightweight,
    String? sort,
    String? orderBy,
    String? order,
    bool includePast = true,
  }) async {
    throw failure;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FailingQuestionsRepository implements EventQuestionsRepository {
  _FailingQuestionsRepository(this.failure);

  final Object failure;

  @override
  Future<EventQuestion> createQuestion(String eventSlug, String text) async {
    throw failure;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
