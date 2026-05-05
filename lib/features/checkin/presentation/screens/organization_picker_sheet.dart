import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/themes/colors.dart';
import '../../../memberships/data/models/membership_dto.dart';
import '../../../memberships/presentation/providers/membership_state_providers.dart';
import '../../domain/entities/active_organization.dart';
import '../providers/active_organization_provider.dart';
import '../providers/vendor_memberships_provider.dart';

/// Bottom sheet that asks the vendor to pick the organization they're
/// working at. Shown lazily on the first scan attempt when no active org
/// is set, and on demand from the scan screen's "Switch organization"
/// menu entry.
///
/// Returns `true` when the user picks an org; `false` when they dismiss
/// without picking. The active org provider is updated as a side effect.
Future<bool> showOrganizationPickerSheet(BuildContext context) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    isDismissible: true,
    enableDrag: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => const _OrgPickerSheet(),
  );
  return result ?? false;
}

class _OrgPickerSheet extends ConsumerWidget {
  const _OrgPickerSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memberships = ref.watch(vendorMembershipsProvider);
    final asyncList = ref.watch(myMembershipsListProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: HbColors.grey200,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Choisir une organisation',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: HbColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Le scanner enverra les billets à l'organisation sélectionnée.",
              style: TextStyle(
                fontSize: 13,
                color: HbColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            if (asyncList.isLoading && memberships.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (memberships.isEmpty)
              _EmptyState(refresh: () async {
                ref.read(myMembershipsListProvider.notifier).refresh();
              })
            else
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: memberships.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, index) {
                    final m = memberships[index];
                    return _OrgTile(
                      membership: m,
                      onTap: () async {
                        final org = m.organization;
                        if (org == null || org.uuid == null) return;
                        await ref
                            .read(activeOrganizationProvider.notifier)
                            .set(ActiveOrganization(
                              uuid: org.uuid!,
                              name: org.displayName,
                              role: m.role ?? MembershipRole.staff,
                              logoUrl: org.logoOrUrl,
                            ));
                        if (context.mounted) {
                          Navigator.of(context).pop(true);
                        }
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _OrgTile extends StatelessWidget {
  final MembershipDto membership;
  final VoidCallback onTap;

  const _OrgTile({required this.membership, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final org = membership.organization;
    // When the backend doesn't ship per-row role yet, don't render a
    // potentially misleading label like "Membre" for a vendor staff —
    // show the org's address (or nothing) instead.
    final subtitle = switch (membership.role) {
      MembershipRole.owner => 'Propriétaire',
      MembershipRole.admin => 'Administrateur',
      MembershipRole.staff => 'Équipe',
      MembershipRole.viewer => 'Membre',
      null => org?.address ?? '',
    };
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: HbColors.surfaceElevated,
              backgroundImage: org?.logoOrUrl != null && org!.logoOrUrl!.isNotEmpty
                  ? NetworkImage(org.logoOrUrl!)
                  : null,
              child: org?.logoOrUrl == null || org!.logoOrUrl!.isEmpty
                  ? const Icon(Icons.business, color: HbColors.textSecondary)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    org?.displayName ?? '—',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: HbColors.textPrimary,
                    ),
                  ),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: HbColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: HbColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final Future<void> Function() refresh;
  const _EmptyState({required this.refresh});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          const Icon(Icons.workspaces_outline,
              size: 40, color: HbColors.textSecondary),
          const SizedBox(height: 12),
          const Text(
            'Aucune organisation vendeur trouvée',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: HbColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Si vous attendiez d'apparaître ici, contactez le support — "
            "votre profil n'est peut-être pas encore lié à une organisation.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: HbColors.textSecondary),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: refresh,
            child: const Text('Actualiser'),
          ),
        ],
      ),
    );
  }
}
