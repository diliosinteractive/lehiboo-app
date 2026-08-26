import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lehiboo/core/analytics/analytics_provider.dart';
import 'package:lehiboo/core/analytics/noop_analytics_service.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/auth/presentation/screens/customer_register_screen.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

void main() {
  testWidgets('customer signup reaches protected onboarding authenticated', (
    tester,
  ) async {
    final repository = _RegistrationRepository();
    final tracker = _RouteTracker();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(repository),
          analyticsServiceProvider.overrideWithValue(
            const NoopAnalyticsService(),
          ),
        ],
        child: _RouterHarness(tracker: tracker),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextFormField).first,
      'new.user@example.test',
    );
    await tester.tap(find.text('Receive code'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).first, '123456');
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);
    expect(fields, findsNWidgets(7));
    await tester.enterText(fields.at(0), 'New');
    await tester.enterText(fields.at(1), 'User');
    await tester.enterText(fields.at(3), 'Douala');

    final birthDatePicker = find.byWidgetPredicate(
      (widget) => widget is GestureDetector && widget.child is AbsorbPointer,
    );
    expect(birthDatePicker, findsOneWidget);
    await tester.ensureVisible(birthDatePicker);
    await tester.tap(birthDatePicker);
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    await tester.enterText(fields.at(5), 'StrongPass1');
    await tester.enterText(fields.at(6), 'StrongPass1');

    final terms = find.byType(Checkbox).last;
    await tester.ensureVisible(terms);
    await tester.tap(terms);
    await tester.pump();

    final submit = find.text('Create my account');
    await tester.ensureVisible(submit);
    await tester.tap(submit);
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.text('Protected notifications'), findsOneWidget);
    expect(tracker.sawProtectedWhileUnauthenticated, isFalse);
    expect(tester.takeException(), isNull);
  });
}

class _RouteTracker {
  bool sawProtectedWhileUnauthenticated = false;
}

class _RouterHarness extends ConsumerStatefulWidget {
  const _RouterHarness({required this.tracker});

  final _RouteTracker tracker;

  @override
  ConsumerState<_RouterHarness> createState() => _RouterHarnessState();
}

class _RouterHarnessState extends ConsumerState<_RouterHarness> {
  final _refresh = ChangeNotifier();
  late final ProviderSubscription<AuthState> _subscription;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _subscription = ref.listenManual<AuthState>(
      authProvider,
      (_, __) => _refresh.notifyListeners(),
    );
    _router = GoRouter(
      navigatorKey: GlobalKey<NavigatorState>(),
      initialLocation: '/register/customer',
      refreshListenable: _refresh,
      redirect: (_, state) {
        if (state.matchedLocation == '/post-signup/notifications' &&
            !ref.read(authProvider).isAuthenticated) {
          widget.tracker.sawProtectedWhileUnauthenticated = true;
          return '/login';
        }
        return null;
      },
      routes: [
        GoRoute(
          path: '/register/customer',
          builder: (_, __) => const CustomerRegisterScreen(),
        ),
        GoRoute(
          path: '/post-signup/notifications',
          builder: (_, __) =>
              const Scaffold(body: Text('Protected notifications')),
        ),
        GoRoute(
          path: '/login',
          builder: (_, __) => const Scaffold(body: Text('Login')),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _router.dispose();
    _subscription.close();
    _refresh.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    routerConfig: _router,
  );
}

class _RegistrationRepository implements AuthRepository {
  @override
  Future<bool> isAuthenticated() async => false;

  @override
  Future<HbUser?> getCurrentUser() async => null;

  @override
  Future<void> persistUser(HbUser user) async {}

  @override
  Future<OtpResult> sendOtpCode({
    required String email,
    required String type,
  }) async => OtpResult(success: true, message: 'Sent');

  @override
  Future<OtpVerificationResult> verifyOtpCode({
    required String email,
    required String code,
    required String type,
  }) async => OtpVerificationResult(
    success: true,
    verified: true,
    message: 'Verified',
    verifiedEmailToken: 'verified-email-token',
  );

  @override
  Future<CustomerRegistrationResult> registerCustomer({
    required String verifiedEmailToken,
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? phone,
    String? birthDate,
    String? membershipCity,
    required bool acceptTerms,
    bool acceptMarketing = false,
  }) async => CustomerRegistrationResult(
    pendingVerification: false,
    emailVerificationRequired: false,
    email: email,
    message: 'Created',
    authResult: AuthResult(
      user: HbUser(
        id: 'new-account',
        email: email,
        displayName: '$firstName $lastName',
      ),
      accessToken: 'access',
      refreshToken: 'refresh',
      expiresIn: 3600,
    ),
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
