import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/entities/user.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../memberships/data/models/membership_dto.dart';
import '../../../memberships/presentation/providers/membership_state_providers.dart';

/// Subset of `myMembershipsListProvider` that only contains rows where the
/// user can scan tickets for an active organization. Drives the org picker
/// for the check-in feature.
///
/// Two filters live here:
///
/// 1. **Strict path** — backend returned per-row `role`/`is_active`
///    (MOBILE_CHECKIN_SPEC §12.2). Keep rows where the role is in
///    {owner, staff, admin} and `is_active == true`.
///
/// 2. **Fallback path** — backend returned the customer shape (status +
///    status_label, no role). The `/me/memberships` endpoint as of
///    2026-05-05 doesn't yet expose the role per row. When the auth
///    response says the user is a vendor (partner/admin at the user
///    level), every `status == active` membership is treated as a vendor
///    org — the auth role substitutes for the missing per-row info.
///    Subscriber users never reach this fallback because the eligibility
///    provider already gates the screen.
///
/// Reuses the existing memberships fetch — no extra HTTP call. Returns an
/// empty list while the underlying provider is loading or errored.
final vendorMembershipsProvider = Provider<List<MembershipDto>>((ref) {
  final list = ref.watch(myMembershipsListProvider).valueOrNull;
  if (list == null) return const [];

  final authRole = ref.watch(authProvider).user?.role;
  final isAuthVendor =
      authRole == UserRole.partner || authRole == UserRole.admin;

  return list.data.where((m) {
    final orgUuid = m.organization?.uuid;
    if (orgUuid == null || orgUuid.isEmpty) return false;

    // Strict: backend ships per-row role + is_active.
    if (m.role != null) {
      return (m.isActive ?? false) && m.role!.isVendorRole;
    }

    // Fallback: customer shape — defer to the auth-level role.
    if (isAuthVendor) {
      return m.status == MembershipStatus.active;
    }

    return false;
  }).toList(growable: false);
});
