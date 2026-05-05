import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';

/// True when the signed-in user can scan tickets at the gate. Backend-
/// authoritative — sourced from `user.capabilities.canScanTickets` (parsed
/// in `auth_response_dto.dart`). Defaults to false for safety: only a user
/// the backend has explicitly flagged can see the check-in feature.
///
/// Spec: docs/MOBILE_CHECKIN_SPEC.md §2 (vendor group of routes).
final vendorEligibilityProvider = Provider<bool>((ref) {
  final user = ref.watch(authProvider).user;
  return user?.capabilities.canScanTickets ?? false;
});
