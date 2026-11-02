import '../providers/push_notification_provider.dart';

/// Secondary line shown under the Settings push switch when this device
/// cannot receive pushes even though the account allows them.
enum PushSwitchHint {
  none,

  /// A permission prompt was refused on this device: the system settings are
  /// the reliable way back.
  blockedBySystem,

  /// This device has no OS permission yet and nothing proves a refusal (never
  /// asked, or Android 13+ registered before asking). A tap on the switch
  /// prompts, or falls back to the system settings when it no longer can.
  notSetUpOnDevice,

  /// Permission is not the problem, but this device could not be set up
  /// (subscription not ready, backend sync failed, SDK unavailable).
  deviceSyncFailed,
}

class PushSwitchView {
  const PushSwitchView({required this.isOn, this.hint = PushSwitchHint.none});

  final bool isOn;
  final PushSwitchHint hint;

  @override
  bool operator ==(Object other) =>
      other is PushSwitchView && other.isOn == isOn && other.hint == hint;

  @override
  int get hashCode => Object.hash(isOn, hint);

  @override
  String toString() => 'PushSwitchView(isOn: $isOn, hint: ${hint.name})';
}

/// Whether THIS device will actually display pushes for the current account.
///
/// [accountOptIn] is the server-side `push_notifications_enabled` flag, shared
/// by every device of the account. [device] is this device's push setup.
///
/// [PushNotificationState.hasPermission] is only a real OS reading once
/// [PushNotificationStatus.initialized]: every other state is rebuilt from a
/// const constructor that resets it to `false`. Decide from `status` and
/// `failureReason` first.
///
/// "On" requires positive evidence from the device. Every "off" hint leads to
/// a tap that can fix it. When the device state is unknown, or nothing on the
/// device can change it, the account preference is shown as is.
PushSwitchView resolvePushSwitch({
  required bool accountOptIn,
  required PushNotificationState device,
}) {
  const on = PushSwitchView(isOn: true);
  const notSetUp = PushSwitchView(
    isOn: false,
    hint: PushSwitchHint.notSetUpOnDevice,
  );
  const syncFailed = PushSwitchView(
    isOn: false,
    hint: PushSwitchHint.deviceSyncFailed,
  );

  if (!accountOptIn) return const PushSwitchView(isOn: false);

  return switch (device.status) {
    // Unknown yet. Showing "off" would route a tap into requestPermission(),
    // which refuses while initializing and surfaces a misleading error toast.
    PushNotificationStatus.uninitialized ||
    PushNotificationStatus.initializing =>
      on,
    PushNotificationStatus.initialized => device.hasPermission ? on : notSetUp,
    PushNotificationStatus.disabled || PushNotificationStatus.error => switch (
          device.failureReason) {
        null => notSetUp,
        PushNotificationFailureReason.permissionDenied => const PushSwitchView(
            isOn: false,
            hint: PushSwitchHint.blockedBySystem,
          ),
        // Build without OneSignal (e.g. no ONESIGNAL_APP_ID): no retry from
        // this device can succeed, so a hint would only mislead.
        PushNotificationFailureReason.serviceUnavailable => on,
        PushNotificationFailureReason.subscriptionUnavailable ||
        PushNotificationFailureReason.backendSyncFailed ||
        PushNotificationFailureReason.unexpected =>
          syncFailed,
      },
  };
}
