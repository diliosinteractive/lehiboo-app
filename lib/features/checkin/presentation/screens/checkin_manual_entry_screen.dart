import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/themes/colors.dart';
import '../../data/models/checkin_request_dto.dart';
import '../../data/models/ticket_summary_dto.dart';
import '../../data/repositories/checkin_repository_impl.dart';
import '../../domain/entities/peek_result.dart';
import '../../domain/repositories/checkin_repository.dart';
import '../providers/active_organization_provider.dart';
import '../providers/scan_session_provider.dart';
import 'checkin_blocked_sheet.dart';
import 'checkin_confirm_sheet.dart';

/// Fallback for damaged QRs and devices without a camera. Sends the raw
/// shortcode as `qr_code` (no `qr_secret` — see spec §7). The spec
/// documents 12 chars but staging tickets ship 16-char codes; we don't
/// pin a length to avoid future drift.
///
/// Manual entry is intentionally less secure than QR scanning: the secret
/// half of the QR isn't transmitted, so any leaked shortcode would let
/// anyone pass. The UI warns explicitly that this mode requires a visual
/// ID check.
class CheckinManualEntryScreen extends ConsumerStatefulWidget {
  const CheckinManualEntryScreen({super.key});

  @override
  ConsumerState<CheckinManualEntryScreen> createState() =>
      _CheckinManualEntryScreenState();
}

class _CheckinManualEntryScreenState
    extends ConsumerState<CheckinManualEntryScreen> {
  final _controller = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final code = _controller.text.trim();
    if (code.isEmpty) return;
    if (ref.read(activeOrganizationProvider) == null) {
      _toast(context.l10n.checkinChooseOrganizationFirst);
      return;
    }
    setState(() => _submitting = true);
    final repo = ref.read(checkinRepositoryProvider);
    try {
      final result = await repo.peek(qrCode: code);
      if (!mounted) return;
      switch (result) {
        case CanCheckIn(:final ticket):
          await _confirmAndCommit(ticket: ticket, isReEntry: false);
        case WouldBeReEntry(:final ticket):
          await _confirmAndCommit(ticket: ticket, isReEntry: true);
        case Blocked(:final reason, :final ticket):
          await showCheckinBlockedSheet(
            context,
            reason: reason,
            ticket: ticket,
          );
      }
    } on CheckinFailure catch (e) {
      if (!mounted) return;
      await showCheckinBlockedSheet(
        context,
        reason: e.blocker,
        extraMessage: e.message,
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _confirmAndCommit({
    required TicketSummaryDto ticket,
    required bool isReEntry,
  }) async {
    final confirmed = await showCheckinConfirmSheet(
      context,
      ticket: ticket,
      isReEntry: isReEntry,
    );
    if (confirmed != true) return;
    final session = ref.read(scanSessionProvider);
    final request = CheckinRequestDto(
      deviceId: session.deviceId,
      deviceName: session.deviceName,
      gate: session.gate,
      scanMethod: 'manual',
    );
    try {
      final response = await ref
          .read(checkinRepositoryProvider)
          .commit(ticket.uuid, request);
      if (!mounted) return;
      final l10n = context.l10n;
      _toast(
        response.isReEntry
            ? l10n.checkinReEntryRecorded(response.checkInCount)
            : l10n.checkinEntryRecorded,
        success: true,
      );
      _controller.clear();
    } on CheckinFailure catch (e) {
      if (!mounted) return;
      if (e.isNetworkError) {
        _toast(context.l10n.checkinNetworkRetype);
      } else {
        await showCheckinBlockedSheet(
          context,
          reason: e.blocker,
          extraMessage: e.message,
        );
      }
    }
  }

  void _toast(String message, {bool success = false}) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        backgroundColor: success ? HbColors.success : HbColors.error,
        behavior: SnackBarBehavior.floating,
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeOrg = ref.watch(activeOrganizationProvider);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.checkinManualEntryTitle),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: HbColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: HbColors.warning.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: HbColors.warning,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        l10n.checkinManualWarning,
                        style: const TextStyle(
                          fontSize: 13,
                          color: HbColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (activeOrg != null)
                Text(
                  l10n.checkinOrganizationLabel(activeOrg.name),
                  style: const TextStyle(
                    fontSize: 13,
                    color: HbColors.textSecondary,
                  ),
                ),
              const SizedBox(height: 12),
              TextField(
                controller: _controller,
                autofocus: true,
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                  // Generous cap — current codes are 16 chars but the
                  // server is the source of truth on length, not the app.
                  LengthLimitingTextInputFormatter(32),
                ],
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'XXXXXXXXXXXXXXXX',
                  helperText: l10n.checkinManualCodeHelper,
                  border: const OutlineInputBorder(),
                ),
                onSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _submitting ? null : _submit,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _submitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(l10n.checkinVerifyCode),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
