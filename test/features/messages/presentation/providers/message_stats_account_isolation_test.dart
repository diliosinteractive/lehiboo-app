import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/messages/data/repositories/messages_repository_impl.dart';
import 'package:lehiboo/features/messages/domain/entities/admin_report_stats.dart';
import 'package:lehiboo/features/messages/domain/entities/vendor_stats.dart';
import 'package:lehiboo/features/messages/domain/repositories/messages_repository.dart';
import 'package:lehiboo/features/messages/presentation/providers/admin_conversations_provider.dart';
import 'package:lehiboo/features/messages/presentation/providers/vendor_conversations_provider.dart';

final _accountProvider = StateProvider<String?>((ref) => 'account-a');

class _StatsRepository implements MessagesRepository {
  final vendorRequests = <Completer<VendorStats>>[];
  final adminRequests = <Completer<AdminReportStats>>[];

  @override
  Future<VendorStats> getVendorStats() {
    final request = Completer<VendorStats>();
    vendorRequests.add(request);
    return request.future;
  }

  @override
  Future<AdminReportStats> getAdminConversationReportStats() {
    final request = Completer<AdminReportStats>();
    adminRequests.add(request);
    return request.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('message stats clear immediately and ignore old-account responses',
      () async {
    final repository = _StatsRepository();
    final container = ProviderContainer(
      overrides: [
        authSessionUserIdProvider.overrideWith(
          (ref) => ref.watch(_accountProvider),
        ),
        messagesRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
    final vendorSubscription = container.listen(
      vendorStatsProvider,
      (_, __) {},
      fireImmediately: true,
    );
    final adminSubscription = container.listen(
      adminReportStatsProvider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(vendorSubscription.close);
    addTearDown(adminSubscription.close);

    expect(repository.vendorRequests, hasLength(1));
    expect(repository.adminRequests, hasLength(1));

    container.read(_accountProvider.notifier).state = 'account-b';
    await pumpEventQueue();

    expect(repository.vendorRequests, hasLength(2));
    expect(repository.adminRequests, hasLength(2));
    expect(container.read(vendorStatsProvider).valueOrNull, isNull);
    expect(container.read(adminReportStatsProvider).valueOrNull, isNull);

    repository.vendorRequests.first.complete(
      const VendorStats(
        clientTotal: 91,
        clientUnread: 92,
        supportTotal: 93,
        supportUnread: 94,
      ),
    );
    repository.adminRequests.first.complete(
      const AdminReportStats(
        pending: 81,
        reviewed: 82,
        dismissed: 83,
        total: 84,
      ),
    );
    await pumpEventQueue();

    expect(container.read(vendorStatsProvider).valueOrNull, isNull);
    expect(container.read(adminReportStatsProvider).valueOrNull, isNull);

    repository.vendorRequests.last.complete(
      const VendorStats(
        clientTotal: 1,
        clientUnread: 2,
        supportTotal: 3,
        supportUnread: 4,
      ),
    );
    repository.adminRequests.last.complete(
      const AdminReportStats(
        pending: 5,
        reviewed: 6,
        dismissed: 7,
        total: 8,
      ),
    );
    await pumpEventQueue();

    expect(container.read(vendorStatsProvider).requireValue.clientTotal, 1);
    expect(container.read(adminReportStatsProvider).requireValue.pending, 5);

    container.read(_accountProvider.notifier).state = null;
    await pumpEventQueue();

    expect(container.read(vendorStatsProvider).requireValue.clientTotal, 0);
    expect(container.read(adminReportStatsProvider).requireValue.pending, 0);
    expect(repository.vendorRequests, hasLength(2));
    expect(repository.adminRequests, hasLength(2));
  });

  test('message stats do not revive a cached A element after A to B to A',
      () async {
    final repository = _StatsRepository();
    final container = ProviderContainer(
      overrides: [
        authSessionUserIdProvider.overrideWith(
          (ref) => ref.watch(_accountProvider),
        ),
        messagesRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
    final vendorSubscription = container.listen(
      vendorStatsProvider,
      (_, __) {},
      fireImmediately: true,
    );
    final adminSubscription = container.listen(
      adminReportStatsProvider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(vendorSubscription.close);
    addTearDown(adminSubscription.close);

    expect(repository.vendorRequests, hasLength(1));
    expect(repository.adminRequests, hasLength(1));

    container.read(_accountProvider.notifier).state = 'account-b';
    await pumpEventQueue();
    container.read(_accountProvider.notifier).state = 'account-a';
    await pumpEventQueue();

    expect(repository.vendorRequests, hasLength(3));
    expect(repository.adminRequests, hasLength(3));
    expect(container.read(vendorStatsProvider).valueOrNull, isNull);
    expect(container.read(adminReportStatsProvider).valueOrNull, isNull);

    repository.vendorRequests[0].complete(
      const VendorStats(
        clientTotal: 91,
        clientUnread: 92,
        supportTotal: 93,
        supportUnread: 94,
      ),
    );
    repository.adminRequests[0].complete(
      const AdminReportStats(
        pending: 81,
        reviewed: 82,
        dismissed: 83,
        total: 84,
      ),
    );
    repository.vendorRequests[1].complete(
      const VendorStats(
        clientTotal: 71,
        clientUnread: 72,
        supportTotal: 73,
        supportUnread: 74,
      ),
    );
    repository.adminRequests[1].complete(
      const AdminReportStats(
        pending: 61,
        reviewed: 62,
        dismissed: 63,
        total: 64,
      ),
    );
    await pumpEventQueue();

    expect(container.read(vendorStatsProvider).valueOrNull, isNull);
    expect(container.read(adminReportStatsProvider).valueOrNull, isNull);

    repository.vendorRequests[2].complete(
      const VendorStats(
        clientTotal: 1,
        clientUnread: 2,
        supportTotal: 3,
        supportUnread: 4,
      ),
    );
    repository.adminRequests[2].complete(
      const AdminReportStats(
        pending: 5,
        reviewed: 6,
        dismissed: 7,
        total: 8,
      ),
    );
    await pumpEventQueue();

    expect(container.read(vendorStatsProvider).requireValue.clientTotal, 1);
    expect(container.read(adminReportStatsProvider).requireValue.pending, 5);
  });
}
