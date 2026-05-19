import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/themes/colors.dart';
import '../../../partners/presentation/widgets/organizer_avatar.dart';
import '../../data/models/membership_dto.dart';
import 'organizer_join_button.dart';

/// Gate body shown in place of the event detail when the API returns
/// `403 members_only` (spec MEMBERSHIPS_MOBILE_SPEC.md §20). Carries the
/// organization payload from the response so the user can request to join
/// without an extra fetch.
class MembersOnlyGate extends ConsumerWidget {
  final OrganizationSummaryDto organization;
  final VoidCallback? onBack;

  const MembersOnlyGate({
    super.key,
    required this.organization,
    this.onBack,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final orgName = organization.name;
    final orgUuid = organization.uuid;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: HbColors.textPrimary),
          onPressed: onBack ??
              () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/');
                }
              },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              const Icon(
                Icons.lock_outline,
                size: 64,
                color: HbColors.brandPrimary,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.membersOnlyGateTitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: HbColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.membersOnlyGateBody(orgName),
                textAlign: TextAlign.center,
                style: GoogleFonts.figtree(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  children: [
                    OrganizerAvatar(
                      logoUrl: organization.logoOrUrl,
                      fallbackName: orgName,
                      size: 48,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            orgName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.montserrat(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: HbColors.textPrimary,
                            ),
                          ),
                          if (organization.address != null &&
                              organization.address!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                organization.address!,
                                style: GoogleFonts.figtree(
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (orgUuid != null && orgUuid.isNotEmpty)
                      TextButton(
                        onPressed: () => context.push('/organizers/$orgUuid'),
                        child: Text(l10n.membershipViewOrganizer),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: orgUuid == null || orgUuid.isEmpty
                      ? null
                      : () => confirmAndJoin(context, ref, orgUuid, orgName),
                  icon: const Icon(Icons.group_add_outlined, size: 18),
                  label: Text(l10n.membersOnlyGateJoin(orgName)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HbColors.brandPrimary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
