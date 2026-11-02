import 'package:go_router/go_router.dart';
import 'package:lehiboo/core/analytics/noop_analytics_service.dart';
import 'package:lehiboo/core/services/deep_link_service.dart';
import 'package:lehiboo/core/services/push_notification_service.dart';

/// Inert push service: no OneSignal calls, no router/auth wiring. Lets a
/// screen build the real [pushNotificationProvider] without the app shell.
class FakePushNotificationService extends PushNotificationService {
  FakePushNotificationService(GoRouter router)
      : super(
          deepLinkService: DeepLinkService(router: router),
          analytics: const NoopAnalyticsService(),
        );

  @override
  String? get subscriptionId => null;

  @override
  bool get hasPermission => false;

  @override
  bool get isInitialized => false;

  @override
  Future<void> initialize() async {}

  @override
  Future<void> bindUser(String externalId) async {}

  @override
  Future<void> unbindUser() async {}

  @override
  Future<String?> ensureSubscriptionId() async => null;

  @override
  Future<bool> promptUserForPermission() async => false;
}
