import '../providers/push_notification_provider.dart';

/// What keeps THIS device from displaying pushes, shown below the
/// account-level push switch in Settings.
enum PushDeviceHint {
  /// Nothing to report: the device displays pushes, its state is not known
  /// yet, or the account opted out.
  none,

  /// The OS no longer shows its permission prompt: only the system settings
  /// can bring notifications back.
  blockedBySystem,

  /// No OS permission yet, and the OS can still ask for it.
  notSetUp,

  /// The OS allows notifications, but this device is not registered yet
  /// (subscription not ready, backend sync failed).
  setupFailed,
}

/// Whether the account's push preference actually reaches THIS device.
///
/// The Settings switch shows [accountOptIn] as is, so the account can always
/// be opted out in one tap. This hint only reports the device side, and stays
/// [PushDeviceHint.none] rather than guessing while facts are missing.
PushDeviceHint resolvePushDeviceHint({
  required bool accountOptIn,
  required PushNotificationState device,
}) {
  if (!accountOptIn) return PushDeviceHint.none;
  // Build without OneSignal (e.g. no ONESIGNAL_APP_ID): nothing on this
  // device can fix it.
  if (device.failureReason ==
      PushNotificationFailureReason.serviceUnavailable) {
    return PushDeviceHint.none;
  }

  return switch (device.status) {
    PushNotificationStatus.uninitialized ||
    PushNotificationStatus.initializing =>
      PushDeviceHint.none,
    _ when !device.hasPermission => switch (device.canRequestPermission) {
        true => PushDeviceHint.notSetUp,
        false => PushDeviceHint.blockedBySystem,
        null => PushDeviceHint.none,
      },
    PushNotificationStatus.initialized => PushDeviceHint.none,
    PushNotificationStatus.disabled ||
    PushNotificationStatus.error =>
      PushDeviceHint.setupFailed,
  };
}
