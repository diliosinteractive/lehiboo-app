import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/l10n/l10n.dart';
import 'package:lehiboo/features/notifications/presentation/providers/push_notification_provider.dart';
import 'package:lehiboo/features/notifications/presentation/utils/push_notification_error_message.dart';

void main() {
  test('permission denial is distinct from account device sync failure', () {
    final l10n = lookupAppLocalizations(const Locale('en'));

    final denied = pushNotificationErrorMessage(
      l10n,
      PushNotificationFailureReason.permissionDenied,
    );
    final syncFailed = pushNotificationErrorMessage(
      l10n,
      PushNotificationFailureReason.backendSyncFailed,
    );

    expect(denied, contains('device settings'));
    expect(syncFailed, contains('linked to your account'));
    expect(denied, isNot(syncFailed));
    expect(denied.toLowerCase(), isNot(contains('onesignal')));
    expect(syncFailed.toLowerCase(), isNot(contains('backend')));
  });
}
