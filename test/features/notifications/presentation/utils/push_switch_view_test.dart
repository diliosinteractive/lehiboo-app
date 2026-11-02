import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/notifications/presentation/providers/push_notification_provider.dart';
import 'package:lehiboo/features/notifications/presentation/utils/push_switch_view.dart';

const _on = PushSwitchView(isOn: true);
const _off = PushSwitchView(isOn: false);
const _blocked = PushSwitchView(
  isOn: false,
  hint: PushSwitchHint.blockedBySystem,
);
const _notSetUp = PushSwitchView(
  isOn: false,
  hint: PushSwitchHint.notSetUpOnDevice,
);
const _syncFailed = PushSwitchView(
  isOn: false,
  hint: PushSwitchHint.deviceSyncFailed,
);

void main() {
  group('account opted out', () {
    test('stays off without a hint, even when the device is ready', () {
      final view = resolvePushSwitch(
        accountOptIn: false,
        device: const PushNotificationState(
          status: PushNotificationStatus.initialized,
          subscriptionId: 'subscription-1',
          hasPermission: true,
        ),
      );

      expect(view, _off);
    });

    test('stays off while the device state is still loading', () {
      final view = resolvePushSwitch(
        accountOptIn: false,
        device: const PushNotificationState(
          status: PushNotificationStatus.initializing,
        ),
      );

      expect(view, _off);
    });
  });

  group('account opted in', () {
    test('is on when the device is registered and allowed by the OS', () {
      final view = resolvePushSwitch(
        accountOptIn: true,
        device: const PushNotificationState(
          status: PushNotificationStatus.initialized,
          subscriptionId: 'subscription-1',
          hasPermission: true,
        ),
      );

      expect(view, _on);
    });

    test(
        'is off and not set up when registered without OS permission: '
        'Android 13+ hands out a subscription id before the OS is ever asked',
        () {
      final view = resolvePushSwitch(
        accountOptIn: true,
        device: const PushNotificationState(
          status: PushNotificationStatus.initialized,
          subscriptionId: 'subscription-1',
        ),
      );

      expect(view, _notSetUp);
    });

    test('is off and blocked when a permission prompt was refused', () {
      final view = resolvePushSwitch(
        accountOptIn: true,
        device: const PushNotificationState(
          status: PushNotificationStatus.disabled,
          failureReason: PushNotificationFailureReason.permissionDenied,
        ),
      );

      expect(view, _blocked);
    });

    test('is off and not set up when this device never asked', () {
      final view = resolvePushSwitch(
        accountOptIn: true,
        device: const PushNotificationState(
          status: PushNotificationStatus.disabled,
        ),
      );

      expect(view, _notSetUp);
    });

    test(
        'keeps the account preference while the device state is unknown, '
        'so a tap never hits the initializing guard of requestPermission()',
        () {
      for (final status in [
        PushNotificationStatus.uninitialized,
        PushNotificationStatus.initializing,
      ]) {
        final view = resolvePushSwitch(
          accountOptIn: true,
          device: PushNotificationState(status: status),
        );

        expect(view, _on, reason: status.name);
      }
    });

    test(
        'keeps the account preference without a hint when the build has no '
        'push SDK: no retry from the device can succeed', () {
      final view = resolvePushSwitch(
        accountOptIn: true,
        device: const PushNotificationState(
          status: PushNotificationStatus.disabled,
          failureReason: PushNotificationFailureReason.serviceUnavailable,
        ),
      );

      expect(view, _on);
    });

    test('is off with a retry hint when this device could not be set up', () {
      const failures = [
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
        (
          PushNotificationStatus.disabled,
          PushNotificationFailureReason.subscriptionUnavailable,
        ),
        (
          PushNotificationStatus.disabled,
          PushNotificationFailureReason.unexpected,
        ),
      ];

      for (final (status, reason) in failures) {
        final view = resolvePushSwitch(
          accountOptIn: true,
          device: PushNotificationState(status: status, failureReason: reason),
        );

        expect(view, _syncFailed, reason: '${status.name}/${reason.name}');
      }
    });
  });
}
