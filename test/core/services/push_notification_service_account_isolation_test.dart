import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lehiboo/core/analytics/noop_analytics_service.dart';
import 'package:lehiboo/core/services/deep_link_service.dart';
import 'package:lehiboo/core/services/push_notification_service.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const accountA = PushRecipientIdentity(
    accountId: '101',
    externalId: 'external-a',
  );
  const accountB = PushRecipientIdentity(
    accountId: '202',
    externalId: 'external-b',
  );

  setUp(resetPushClickStateForTesting);

  test('mismatched recipient cannot open a payload-specific private route', () {
    final destination = authorizedPushDestination(
      resolvedRoute: '/booking-detail/booking-a',
      data: const {
        'type': 'booking_confirmed',
        'booking_uuid': 'booking-a',
        'recipient_user_id': '101',
      },
      activeRecipient: accountB,
    );

    expect(destination, '/notifications');
  });

  test('legacy private payload without recipient opens only current inbox', () {
    final destination = authorizedPushDestination(
      resolvedRoute: '/messages/conversation-a',
      data: const {
        'type': 'new_message',
        'conversation_uuid': 'conversation-a',
      },
      activeRecipient: accountA,
    );

    expect(destination, '/notifications');
  });

  test('exact recipient may open its private payload destination', () {
    final byAccountId = authorizedPushDestination(
      resolvedRoute: '/ticket/ticket-a',
      data: const {
        'type': 'tickets_ready',
        'ticket_uuid': 'ticket-a',
        'notifiable_id': '101',
      },
      activeRecipient: accountA,
    );
    final byExternalId = authorizedPushDestination(
      resolvedRoute: '/messages/conversation-a',
      data: const {
        'type': 'new_message',
        'conversation_uuid': 'conversation-a',
        'external_user_id': 'external-a',
      },
      activeRecipient: accountA,
    );

    expect(byAccountId, '/ticket/ticket-a');
    expect(byExternalId, '/messages/conversation-a');
  });

  test('public event route remains available only without private object ids',
      () {
    final publicDestination = authorizedPushDestination(
      resolvedRoute: '/event/public-concert',
      data: const {
        'type': 'new_event_from_followed_organization',
        'event_slug': 'public-concert',
        'organization_uuid': 'public-organizer',
      },
      activeRecipient: null,
    );
    final privateDestination = authorizedPushDestination(
      resolvedRoute: '/event/public-concert',
      data: const {
        'type': 'event_reminder',
        'event_slug': 'public-concert',
        'booking_uuid': 'private-booking',
      },
      activeRecipient: accountA,
    );
    final mismatchedRecipientDestination = authorizedPushDestination(
      resolvedRoute: '/event/public-concert',
      data: const {
        'type': 'new_event_from_followed_organization',
        'event_slug': 'public-concert',
        'recipient_user_id': '101',
      },
      activeRecipient: accountB,
    );

    expect(publicDestination, '/event/public-concert');
    expect(privateDestination, '/notifications');
    expect(mismatchedRecipientDestination, '/notifications');
  });

  test('pending click is erased across an exact identity switch', () {
    final fixture = _serviceFixture(currentRecipient: () => accountB);
    addTearDown(fixture.dispose);
    final service = fixture.service;
    service.updateActiveRecipient(accountA);
    stashPendingPushClickForTesting(const {
      'type': 'booking_confirmed',
      'booking_uuid': 'booking-a',
      'recipient_user_id': '101',
    });
    expect(hasPendingPushClickForTesting, isTrue);

    service.updateActiveRecipient(accountB);
    service.updateActiveRecipient(accountA);

    expect(hasPendingPushClickForTesting, isFalse);
    service.replayPendingClickForTesting();
    expect(fixture.deepLinks.destinations, isEmpty);
  });

  test('pending click is erased across account and guest transitions', () {
    final fixture = _serviceFixture(currentRecipient: () => null);
    addTearDown(fixture.dispose);
    final service = fixture.service;
    service.updateActiveRecipient(accountA);

    stashPendingPushClickForTesting(const {
      'type': 'new_message',
      'conversation_uuid': 'conversation-a',
      'recipient_user_id': '101',
    });
    service.updateActiveRecipient(null);
    expect(hasPendingPushClickForTesting, isFalse);

    stashPendingPushClickForTesting(const {
      'type': 'new_message',
      'conversation_uuid': 'conversation-a',
      'recipient_user_id': '101',
    });
    service.updateActiveRecipient(accountA);
    expect(hasPendingPushClickForTesting, isFalse);
  });

  test('permission result from A is ignored after an A to B to A cycle',
      () async {
    markOneSignalConfigured();
    var activeRecipient = accountA;
    final permissionResult = Completer<bool>();
    final sdk = _FakePushNotificationSdk(permissionResult: permissionResult);
    final fixture = _serviceFixture(
      currentRecipient: () => activeRecipient,
      sdk: sdk,
    );
    addTearDown(fixture.dispose);
    final service = fixture.service;
    service.updateActiveRecipient(accountA);

    final request = service.promptUserForPermission();
    await sdk.permissionRequested.future;
    activeRecipient = accountB;
    service.updateActiveRecipient(accountB);
    activeRecipient = accountA;
    service.updateActiveRecipient(accountA);
    permissionResult.complete(true);

    expect(await request, isFalse);
  });

  test(
      'initialize registers one stable SDK listener set and dispose removes it',
      () async {
    markOneSignalConfigured();
    final sdk = _FakePushNotificationSdk();
    final fixture = _serviceFixture(
      currentRecipient: () => accountA,
      sdk: sdk,
    );
    final service = fixture.service;

    await Future.wait([service.initialize(), service.initialize()]);
    await service.unregister();
    await service.initialize();

    expect(sdk.foregroundAdds, 1);
    expect(sdk.clickAdds, 1);
    expect(sdk.permissionAdds, 1);
    expect(sdk.subscriptionAdds, 1);

    service.dispose();
    fixture.router.dispose();
    expect(sdk.foregroundRemoves, 1);
    expect(sdk.clickRemoves, 1);
    expect(sdk.permissionRemoves, 1);
    expect(sdk.subscriptionRemoves, 1);
  });
}

({
  PushNotificationService service,
  _RecordingDeepLinkService deepLinks,
  GoRouter router,
  void Function() dispose,
}) _serviceFixture({
  required PushRecipientIdentity? Function() currentRecipient,
  PushNotificationSdk? sdk,
}) {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) => const SizedBox.shrink(),
      ),
    ],
  );
  final deepLinks = _RecordingDeepLinkService(router);
  final service = PushNotificationService(
    deepLinkService: deepLinks,
    analytics: const NoopAnalyticsService(),
    currentRecipient: currentRecipient,
    sdk: sdk,
  );
  return (
    service: service,
    deepLinks: deepLinks,
    router: router,
    dispose: () {
      service.dispose();
      router.dispose();
    },
  );
}

class _RecordingDeepLinkService extends DeepLinkService {
  _RecordingDeepLinkService(GoRouter router) : super(router: router);

  final List<String> destinations = [];

  @override
  void navigate(String path) {
    destinations.add(path);
  }
}

class _FakePushNotificationSdk implements PushNotificationSdk {
  _FakePushNotificationSdk({this.permissionResult});

  final Completer<bool>? permissionResult;
  final permissionRequested = Completer<void>();

  @override
  String? subscriptionId = 'subscription-1';

  int foregroundAdds = 0;
  int foregroundRemoves = 0;
  int clickAdds = 0;
  int clickRemoves = 0;
  int permissionAdds = 0;
  int permissionRemoves = 0;
  int subscriptionAdds = 0;
  int subscriptionRemoves = 0;

  @override
  void addForegroundListener(OnNotificationWillDisplayListener listener) {
    foregroundAdds++;
  }

  @override
  void removeForegroundListener(OnNotificationWillDisplayListener listener) {
    foregroundRemoves++;
  }

  @override
  void addClickListener(OnNotificationClickListener listener) {
    clickAdds++;
  }

  @override
  void removeClickListener(OnNotificationClickListener listener) {
    clickRemoves++;
  }

  @override
  void addPermissionObserver(
    OnNotificationPermissionChangeObserver observer,
  ) {
    permissionAdds++;
  }

  @override
  void removePermissionObserver(
    OnNotificationPermissionChangeObserver observer,
  ) {
    permissionRemoves++;
  }

  @override
  void addSubscriptionObserver(
    OnPushSubscriptionChangeObserver observer,
  ) {
    subscriptionAdds++;
  }

  @override
  void removeSubscriptionObserver(
    OnPushSubscriptionChangeObserver observer,
  ) {
    subscriptionRemoves++;
  }

  @override
  Future<void> login(String externalId) async {}

  @override
  Future<void> logout() async {}

  @override
  Future<bool> requestPermission() {
    if (!permissionRequested.isCompleted) permissionRequested.complete();
    return permissionResult?.future ?? Future<bool>.value(true);
  }
}
