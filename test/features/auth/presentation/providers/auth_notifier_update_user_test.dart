import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/analytics/analytics_provider.dart';
import 'package:lehiboo/core/analytics/noop_analytics_service.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/auth/data/models/auth_response_dto.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';

void main() {
  test('a profile response without onesignal_id or role keeps the device bound',
      () {
    final container = ProviderContainer(
      overrides: [
        analyticsServiceProvider.overrideWithValue(
          const NoopAnalyticsService(),
        ),
        authProvider.overrideWith((ref) => _TestAuthNotifier(ref, _vendor)),
      ],
    );
    addTearDown(container.dispose);

    // The profile endpoint parser defaults the role and has no capabilities
    // nor, before this fix, onesignal_id.
    container.read(authProvider.notifier).updateUser(
          const UserDto(
            id: 7,
            email: 'vendor@example.test',
            displayName: 'Renamed vendor',
            role: 'customer',
          ),
        );

    final user = container.read(authProvider).user!;
    expect(user.displayName, 'Renamed vendor');
    expect(user.onesignalId, 'external-7');
    expect(user.role, UserRole.partner);
    expect(user.capabilities.canScanTickets, isTrue);
  });
}

const _vendor = HbUser(
  id: '7',
  email: 'vendor@example.test',
  displayName: 'Vendor',
  role: UserRole.partner,
  onesignalId: 'external-7',
  capabilities: UserCapabilities(
    canBook: true,
    canScanTickets: true,
    canManageEvents: true,
  ),
);

class _NeverCompletingAuthRepository implements AuthRepository {
  final Completer<bool> _result = Completer<bool>();

  @override
  Future<bool> isAuthenticated() => _result.future;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _TestAuthNotifier extends AuthNotifier {
  _TestAuthNotifier(Ref ref, HbUser user)
      : super(_NeverCompletingAuthRepository(), ref) {
    state = AuthState(status: AuthStatus.authenticated, user: user);
  }
}
