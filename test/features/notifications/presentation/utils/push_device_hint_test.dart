import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/notifications/presentation/providers/push_notification_provider.dart';
import 'package:lehiboo/features/notifications/presentation/utils/push_device_hint.dart';

const _ready = PushNotificationState(
  status: PushNotificationStatus.initialized,
  subscriptionId: 'subscription-1',
  hasPermission: true,
);

PushDeviceHint _hintFor(PushNotificationState device) =>
    resolvePushDeviceHint(accountOptIn: true, device: device);

void main() {
  test('an opted-out account reports nothing about the device', () {
    const blocked = PushNotificationState(
      status: PushNotificationStatus.initialized,
      canRequestPermission: false,
    );

    expect(
      resolvePushDeviceHint(accountOptIn: false, device: blocked),
      PushDeviceHint.none,
    );
  });

  test('a registered device allowed by the OS reports nothing', () {
    expect(_hintFor(_ready), PushDeviceHint.none);
  });

  test('stays silent while the device state is not known yet', () {
    for (final status in [
      PushNotificationStatus.uninitialized,
      PushNotificationStatus.initializing,
    ]) {
      expect(
        _hintFor(PushNotificationState(status: status)),
        PushDeviceHint.none,
        reason: status.name,
      );
    }
  });

  group('without OS permission', () {
    test('is not set up while the OS can still prompt', () {
      // Android 13+ registers before the OS is ever asked.
      const device = PushNotificationState(
        status: PushNotificationStatus.initialized,
        subscriptionId: 'subscription-1',
        canRequestPermission: true,
      );

      expect(_hintFor(device), PushDeviceHint.notSetUp);
    });

    test('is blocked once only the system settings can grant it', () {
      for (final device in const [
        // Revoked from the system settings after a successful setup.
        PushNotificationState(
          status: PushNotificationStatus.initialized,
          subscriptionId: 'subscription-1',
          canRequestPermission: false,
        ),
        // Prompt refused for good.
        PushNotificationState(
          status: PushNotificationStatus.disabled,
          failureReason: PushNotificationFailureReason.permissionDenied,
          canRequestPermission: false,
        ),
      ]) {
        expect(_hintFor(device), PushDeviceHint.blockedBySystem);
      }
    });

    test('waits until the OS has said whether it can still prompt', () {
      const device = PushNotificationState(
        status: PushNotificationStatus.disabled,
        failureReason: PushNotificationFailureReason.permissionDenied,
      );

      expect(_hintFor(device), PushDeviceHint.none);
    });
  });

  test('reports a setup failure when the OS allows notifications', () {
    for (final (status, reason) in const [
      (PushNotificationStatus.disabled, null),
      (
        PushNotificationStatus.error,
        PushNotificationFailureReason.backendSyncFailed,
      ),
      (
        PushNotificationStatus.error,
        PushNotificationFailureReason.subscriptionUnavailable,
      ),
      (
        PushNotificationStatus.error,
        PushNotificationFailureReason.unexpected,
      ),
    ]) {
      final device = PushNotificationState(
        status: status,
        failureReason: reason,
        hasPermission: true,
      );

      expect(
        _hintFor(device),
        PushDeviceHint.setupFailed,
        reason: '${status.name}/${reason?.name}',
      );
    }
  });

  test('stays silent when the build has no push SDK', () {
    const device = PushNotificationState(
      status: PushNotificationStatus.disabled,
      failureReason: PushNotificationFailureReason.serviceUnavailable,
    );

    expect(_hintFor(device), PushDeviceHint.none);
  });
}
