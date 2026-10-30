import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_session_key_provider.dart';
import 'package:lehiboo/features/checkin/data/datasources/managed_organizations_api_datasource.dart';
import 'package:lehiboo/features/checkin/data/models/managed_organization_dto.dart';
import 'package:lehiboo/features/checkin/presentation/providers/managed_organizations_provider.dart';
import 'package:lehiboo/features/checkin/presentation/screens/organization_picker_sheet.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
      'opening the switcher refreshes cached organizations and retry errors '
      'stay in provider state', (tester) async {
    final api = _ControlledManagedOrganizationsApiDataSource();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith(_AuthenticatedUserNotifier.new),
          managedOrganizationsApiDataSourceProvider.overrideWithValue(api),
        ],
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () {
                  showOrganizationPickerSheet(
                    context,
                    ownerAccountId: '1',
                  );
                },
                child: const Text('Open picker'),
              ),
            ),
          ),
        ),
      ),
    );

    final container = ProviderScope.containerOf(
      tester.element(find.byType(MaterialApp)),
    );
    final ownerSession = container.read(authSessionKeyProvider);
    final cachedLoad =
        container.read(managedOrganizationsProvider(ownerSession).future);
    expect(api.requests, hasLength(1));
    api.requests.single.complete(const []);
    await cachedLoad;

    await tester.tap(find.text('Open picker'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(api.requests, hasLength(2));
    api.requests[1].completeError(
      StateError('first picker load failed'),
      StackTrace.current,
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Refresh'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Refresh'));
    await tester.pump();
    expect(api.requests, hasLength(3));

    api.requests[2].completeError(
      StateError('retry failed'),
      StackTrace.current,
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Refresh'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

class _ControlledManagedOrganizationsApiDataSource
    extends ManagedOrganizationsApiDataSource {
  _ControlledManagedOrganizationsApiDataSource() : super(Dio());

  final List<Completer<List<ManagedOrganizationDto>>> requests = [];

  @override
  Future<List<ManagedOrganizationDto>> getManagedOrganizations() {
    final request = Completer<List<ManagedOrganizationDto>>();
    requests.add(request);
    return request.future;
  }
}

class _AuthenticatedUserNotifier extends AuthNotifier {
  _AuthenticatedUserNotifier(Ref ref)
      : super(_NeverCompletingAuthRepository(), ref) {
    state = const AuthState(
      status: AuthStatus.authenticated,
      user: HbUser(
        id: '1',
        email: 'vendor@example.test',
        displayName: 'Vendor',
        role: UserRole.partner,
      ),
    );
  }
}

class _NeverCompletingAuthRepository implements AuthRepository {
  final Completer<bool> _authentication = Completer<bool>();

  @override
  Future<bool> isAuthenticated() => _authentication.future;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
