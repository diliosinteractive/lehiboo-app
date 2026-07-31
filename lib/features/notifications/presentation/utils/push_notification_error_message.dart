import '../../../../core/l10n/l10n.dart';
import '../providers/push_notification_provider.dart';

/// Localizes a stable push setup failure without surfacing SDK/backend text.
String pushNotificationErrorMessage(
  AppLocalizations l10n,
  PushNotificationFailureReason? reason,
) {
  return switch (reason) {
    PushNotificationFailureReason.permissionDenied =>
      l10n.settingsPushPermissionDenied,
    PushNotificationFailureReason.backendSyncFailed =>
      l10n.settingsPushDeviceSyncFailed,
    PushNotificationFailureReason.subscriptionUnavailable =>
      l10n.settingsPushSubscriptionPending,
    PushNotificationFailureReason.serviceUnavailable ||
    PushNotificationFailureReason.unexpected ||
    null =>
      l10n.settingsPushSetupFailed,
  };
}
