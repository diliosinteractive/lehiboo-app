import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/messages/data/repositories/messages_repository_impl.dart';
import 'package:lehiboo/features/messages/domain/entities/conversation_report.dart';
import 'package:lehiboo/features/messages/domain/repositories/messages_repository.dart';
import 'package:lehiboo/features/messages/presentation/screens/admin_report_detail_screen.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

final _activeAccountProvider = StateProvider<String?>((ref) => 'account-a');

void main() {
  testWidgets('admin report note and report data disappear on account switch',
      (tester) async {
    final repository = _ReportRepository();
    final container = ProviderContainer(
      overrides: [
        authSessionUserIdProvider.overrideWith(
          (ref) => ref.watch(_activeAccountProvider),
        ),
        messagesRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          locale: Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: AdminReportDetailScreen(reportUuid: 'report-a'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Account A report'), findsOneWidget);
    expect(find.text('account A stored note'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'account A draft note');

    container.read(_activeAccountProvider.notifier).state = 'account-b';
    await tester.pump();

    expect(
      find.byKey(const Key('admin-report-detail-session-invalid')),
      findsOneWidget,
    );
    expect(find.text('Account A report'), findsNothing);
    expect(find.text('account A stored note'), findsNothing);
    expect(find.text('account A draft note'), findsNothing);
    expect(repository.updateCalls, isEmpty);
    expect(repository.reviewCalls, isEmpty);
  });
}

class _ReportRepository implements MessagesRepository {
  final updateCalls = <String>[];
  final reviewCalls = <String>[];

  @override
  Future<ConversationReportsListResult> getAdminConversationReports({
    String? search,
    String? reason,
    int page = 1,
    int perPage = 20,
  }) async {
    return ConversationReportsListResult(
      reports: [
        ConversationReport(
          uuid: 'report-a',
          reason: 'spam',
          status: 'pending',
          createdAt: DateTime(2026),
          adminNote: 'account A stored note',
          conversationSubject: 'Account A report',
        ),
      ],
      hasMore: false,
      currentPage: 1,
      totalCount: 1,
    );
  }

  @override
  Future<void> updateAdminConversationReportNote({
    required String reportUuid,
    String? adminNote,
  }) async {
    updateCalls.add(reportUuid);
  }

  @override
  Future<void> reviewAdminConversationReport({
    required String reportUuid,
    required String action,
    String? adminNote,
  }) async {
    reviewCalls.add(reportUuid);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
