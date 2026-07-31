import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/analytics/analytics_provider.dart';
import 'package:lehiboo/core/analytics/noop_analytics_service.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_session_key_provider.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import 'package:lehiboo/features/events/presentation/widgets/detail/event_share_sheet.dart';
import 'package:lehiboo/features/gamification/data/datasources/gamification_api_datasource.dart';
import 'package:lehiboo/features/gamification/data/models/hibons_api_dto.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';
import 'package:share_plus/share_plus.dart';

class _NeverCompletingAuthRepository implements AuthRepository {
  final _result = Completer<bool>();

  @override
  Future<bool> isAuthenticated() => _result.future;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MutableAuthNotifier extends AuthNotifier {
  _MutableAuthNotifier(Ref ref) : super(_NeverCompletingAuthRepository(), ref) {
    setUser(_accountA);
  }

  void setUser(HbUser user) {
    state = AuthState(status: AuthStatus.authenticated, user: user);
  }
}

class _RecordingGamificationApi implements GamificationApiDataSource {
  int shareCalls = 0;

  @override
  Future<HibonsRewardResponseDto> trackEventShare(
    String slug,
    String channel,
  ) async {
    shareCalls++;
    return const HibonsRewardResponseDto();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _RecordingAnalytics extends NoopAnalyticsService {
  int logCalls = 0;

  @override
  Future<void> logEvent(
    String name, {
    Map<String, Object?>? params,
  }) async {
    logCalls++;
  }
}

const _accountA = HbUser(
  id: 'account-a',
  email: 'a@example.test',
  displayName: 'Account A',
);

const _accountB = HbUser(
  id: 'account-b',
  email: 'b@example.test',
  displayName: 'Account B',
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'a delayed native share result cannot cross an A to B to A cycle',
    (tester) async {
      final shareResult = Completer<ShareResult>();
      final gamification = _RecordingGamificationApi();
      final analytics = _RecordingAnalytics();
      late _MutableAuthNotifier auth;

      final container = ProviderContainer(
        overrides: [
          authProvider.overrideWith((ref) {
            auth = _MutableAuthNotifier(ref);
            return auth;
          }),
          analyticsServiceProvider.overrideWithValue(analytics),
          gamificationApiDataSourceProvider.overrideWithValue(gamification),
          eventShareLauncherProvider.overrideWithValue(
            (_) => shareResult.future,
          ),
        ],
      );
      addTearDown(container.dispose);

      final ownerA = container.read(authSessionKeyProvider);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: ShareButton(
                event: Event.minimal(
                  id: 'private-event',
                  slug: 'private-event',
                  title: 'Private event',
                ),
                ownerSession: ownerA,
                shareUrl: 'https://example.test/events/private-event',
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.share_outlined));
      await tester.pump();

      auth.setUser(_accountB);
      await tester.pump();
      auth.setUser(_accountA);
      await tester.pump();
      expect(
          identical(container.read(authSessionKeyProvider), ownerA), isFalse);

      shareResult.complete(
        const ShareResult('native', ShareResultStatus.success),
      );
      await tester.pump();

      expect(gamification.shareCalls, 0);
      expect(analytics.logCalls, 0);
    },
  );
}
