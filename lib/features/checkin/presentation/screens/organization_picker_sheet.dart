import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/utils/api_response_handler.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/providers/auth_session_key_provider.dart';
import '../../data/models/managed_organization_dto.dart';
import '../../domain/entities/active_organization.dart';
import '../providers/active_organization_provider.dart';
import '../providers/managed_organizations_provider.dart';

/// Bottom sheet that asks the vendor to pick the organization they're
/// working at. Shown lazily on the first scan attempt when no active org
/// is set, and on demand from the scan screen's "Switch organization"
/// menu entry.
///
/// Returns `true` when the user picks an org; `false` when they dismiss
/// without picking. The active org provider is updated as a side effect.
Future<bool> showOrganizationPickerSheet(
  BuildContext context, {
  required String ownerAccountId,
}) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    isDismissible: true,
    enableDrag: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _OrgPickerSheet(ownerAccountId: ownerAccountId),
  );
  return result ?? false;
}

class _OrgPickerSheet extends ConsumerStatefulWidget {
  const _OrgPickerSheet({required this.ownerAccountId});

  final String ownerAccountId;

  @override
  ConsumerState<_OrgPickerSheet> createState() => _OrgPickerSheetState();
}

class _OrgPickerSheetState extends ConsumerState<_OrgPickerSheet> {
  bool _invalid = false;

  @override
  void initState() {
    super.initState();
    ref.listenManual<String?>(authSessionUserIdProvider, (_, next) {
      if (next == widget.ownerAccountId || _invalid) return;
      _invalid = true;
      if (!mounted) return;
      final navigator = Navigator.of(context);
      if (navigator.canPop()) navigator.pop(false);
    });
  }

  bool get _ownsCurrentSession =>
      !_invalid && ref.read(authSessionUserIdProvider) == widget.ownerAccountId;

  @override
  Widget build(BuildContext context) {
    final currentAccountId = ref.watch(authSessionUserIdProvider);
    if (_invalid || currentAccountId != widget.ownerAccountId) {
      return const SizedBox.shrink();
    }

    final ownerSession = ref.watch(authSessionKeyProvider);
    final organizationsAsync =
        ref.watch(managedOrganizationsProvider(ownerSession));
    final organizations = organizationsAsync.valueOrNull ?? const [];
    final l10n = context.l10n;
    final loadError = organizationsAsync.maybeWhen<Object?>(
      error: (error, _) => error,
      orElse: () => null,
    );

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
            Text(
              l10n.checkinChooseOrganizationTitle,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: HbColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.checkinChooseOrganizationBody,
              style: const TextStyle(
                fontSize: 13,
                color: HbColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            if (organizationsAsync.isLoading && organizations.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (loadError != null && organizations.isEmpty)
              _LoadErrorState(
                message: ApiResponseHandler.extractError(
                  loadError,
                  fallback: l10n.membershipLoadError,
                ),
                refresh: () async {
                  if (!_ownsCurrentSession) return;
                  final refreshed = ref.refresh(
                    managedOrganizationsProvider(ownerSession).future,
                  );
                  await refreshed;
                  if (!_ownsCurrentSession) return;
                },
              )
            else if (organizations.isEmpty)
              _EmptyState(refresh: () async {
                if (!_ownsCurrentSession) return;
                final refreshed = ref.refresh(
                  managedOrganizationsProvider(ownerSession).future,
                );
                await refreshed;
                if (!_ownsCurrentSession) return;
              })
            else
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: organizations.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, index) {
                    final organization = organizations[index];
                    return _OrgTile(
                      organization: organization,
                      onTap: () async {
                        if (!_ownsCurrentSession) return;
                        final activeOrganization =
                            ref.read(activeOrganizationProvider.notifier);
                        await activeOrganization
                            .set(organization.toActiveOrganization());
                        if (!_ownsCurrentSession) return;
                        if (context.mounted && _ownsCurrentSession) {
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

class _LoadErrorState extends StatelessWidget {
  const _LoadErrorState({required this.message, required this.refresh});

  final String message;
  final Future<void> Function() refresh;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          const Icon(
            Icons.cloud_off_outlined,
            size: 40,
            color: HbColors.textSecondary,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.membershipLoadError,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: HbColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: HbColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: refresh,
            child: Text(l10n.checkinRefresh),
          ),
        ],
      ),
    );
  }
}

class _OrgTile extends StatelessWidget {
  final ManagedOrganizationDto organization;
  final VoidCallback onTap;

  const _OrgTile({required this.organization, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final subtitle = switch (organization.role) {
      OrganizationAccessRole.owner => l10n.checkinRoleOwner,
      OrganizationAccessRole.admin => l10n.checkinRoleAdmin,
      OrganizationAccessRole.manager => l10n.checkinRoleStaff,
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
              backgroundImage: organization.logoUrl != null
                  ? NetworkImage(organization.logoUrl!)
                  : null,
              child: organization.logoUrl == null
                  ? const Icon(Icons.business, color: HbColors.textSecondary)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    organization.name.isEmpty ? '—' : organization.name,
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
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          const Icon(Icons.workspaces_outline,
              size: 40, color: HbColors.textSecondary),
          const SizedBox(height: 12),
          Text(
            l10n.checkinNoVendorOrganizationTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: HbColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.checkinNoVendorOrganizationBody,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: HbColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: refresh,
            child: Text(l10n.checkinRefresh),
          ),
        ],
      ),
    );
  }
}
