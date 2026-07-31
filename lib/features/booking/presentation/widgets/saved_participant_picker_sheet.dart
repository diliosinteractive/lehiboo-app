import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/themes/colors.dart';
import '../../../auth/presentation/widgets/account_bound_route_guard.dart';
import '../../../profile/domain/models/saved_participant.dart';

/// Shows account-owned saved participants and closes immediately if the
/// authenticated account changes while the sheet is open.
Future<SavedParticipant?> showSavedParticipantPickerSheet(
  BuildContext context, {
  required String ownerAccountId,
  required List<SavedParticipant> participants,
}) {
  return showModalBottomSheet<SavedParticipant>(
    context: context,
    showDragHandle: true,
    builder: (_) => AccountBoundRouteGuard<SavedParticipant>(
      ownerAccountId: ownerAccountId,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                child: Text(
                  sheetContext.l10n.bookingChooseSavedParticipant,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: HbColors.textPrimary,
                  ),
                ),
              ),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemBuilder: (_, index) {
                    final participant = participants[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            HbColors.brandPrimary.withValues(alpha: 0.1),
                        child: Text(
                          participant.displayName.isNotEmpty
                              ? participant.displayName
                                  .trim()
                                  .substring(0, 1)
                                  .toUpperCase()
                              : '?',
                          style: const TextStyle(
                            color: HbColors.brandPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      title: Text(participant.displayName),
                      subtitle: Text(
                        [
                          participant.birthDate,
                          participant.membershipCity,
                        ]
                            .whereType<String>()
                            .where((value) => value.isNotEmpty)
                            .join(' · '),
                      ),
                      onTap: () => Navigator.of(sheetContext).pop(participant),
                    );
                  },
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemCount: participants.length,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Text(
                  sheetContext.l10n.bookingAddToNextEmptyTicket,
                  style: const TextStyle(
                    fontSize: 12,
                    color: HbColors.textMuted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
