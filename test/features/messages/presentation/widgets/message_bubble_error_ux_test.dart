import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/l10n/app_locale.dart';
import 'package:lehiboo/features/messages/domain/entities/message.dart';
import 'package:lehiboo/features/messages/presentation/widgets/message_bubble.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

void main() {
  setUp(() => AppLocaleCache.setLanguageCode('en'));

  testWidgets('failed edit keeps the draft open and shows actionable feedback',
      (tester) async {
    String? submittedContent;

    await tester.pumpWidget(
      _TestApp(
        child: MessageBubble(
          message: _message,
          onEdit: (_, content) async {
            submittedContent = content;
            throw StateError('internal edit failure');
          },
        ),
      ),
    );

    await tester.longPress(find.text('Original message'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Updated copy');
    await tester.tap(find.text('Validate'));
    await tester.pumpAndSettle();

    expect(submittedContent, 'Updated copy');
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Updated copy'), findsOneWidget);
    expect(
      find.text(
        "We couldn't save your changes. Your message is still here—try again.",
      ),
      findsOneWidget,
    );
    expect(find.textContaining('StateError'), findsNothing);
  });

  testWidgets('failed delete preserves a safe backend validation message',
      (tester) async {
    await tester.pumpWidget(
      _TestApp(
        child: MessageBubble(
          message: _message,
          onDelete: (_) async {
            throw DioException.badResponse(
              statusCode: 422,
              requestOptions: RequestOptions(path: '/messages/1'),
              response: Response<dynamic>(
                requestOptions: RequestOptions(path: '/messages/1'),
                statusCode: 422,
                data: const {
                  'message': 'This message can no longer be deleted.',
                },
              ),
            );
          },
        ),
      ),
    );

    await tester.longPress(find.text('Original message'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Original message'), findsOneWidget);
    expect(
      find.text('This message can no longer be deleted.'),
      findsOneWidget,
    );
    expect(find.textContaining('DioException'), findsNothing);
  });
}

final _message = Message(
  uuid: 'message-1',
  senderType: 'participant',
  isSystem: false,
  content: 'Original message',
  isDeleted: false,
  isEdited: false,
  isRead: true,
  isDelivered: true,
  isMine: true,
  createdAt: DateTime(2026, 7, 31, 10, 0),
);

class _TestApp extends StatelessWidget {
  const _TestApp({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: Center(child: child)),
    );
  }
}
