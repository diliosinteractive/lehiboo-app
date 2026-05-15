import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/themes/colors.dart';
import '../../../memberships/data/models/membership_dto.dart';
import '../../../memberships/presentation/providers/membership_state_providers.dart';
import '../../data/models/checkin_request_dto.dart';
import '../../data/models/ticket_summary_dto.dart';
import '../../data/repositories/checkin_repository_impl.dart';
import '../../domain/entities/active_organization.dart';
import '../../domain/entities/peek_result.dart';
import '../../domain/repositories/checkin_repository.dart';
import '../providers/active_organization_provider.dart';
import '../providers/scan_session_provider.dart';
import '../providers/vendor_memberships_provider.dart';
import 'checkin_blocked_sheet.dart';
import 'checkin_confirm_sheet.dart';
import 'organization_picker_sheet.dart';

/// Vendor QR scanner — the entry point for the check-in feature.
///
/// Flow:
///   1. On mount, ensure an active organization is selected. If not,
///      show the picker as a modal sheet (lazy — never on login).
///   2. Once an org is set, start the camera. On a stable QR read,
///      call peek and render the matching sheet (green / amber / red).
///   3. On confirm, commit. On success, snackbar + resume scanner.
///
/// Spec: docs/MOBILE_CHECKIN_SPEC.md.
class CheckinScanScreen extends ConsumerStatefulWidget {
  const CheckinScanScreen({super.key});

  @override
  ConsumerState<CheckinScanScreen> createState() => _CheckinScanScreenState();
}

class _CheckinScanScreenState extends ConsumerState<CheckinScanScreen>
    with WidgetsBindingObserver {
  late final MobileScannerController _scanner;
  String? _lastScanned;
  DateTime? _lastScanAt;
  bool _processing = false;
  bool _orgPickerShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scanner = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
      torchEnabled: false,
    );
    // Defer to post-frame so the picker can use a Navigator that's mounted.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensureActiveOrganization();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scanner.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Pause the camera when the app goes to background — releases the
    // hardware promptly and avoids burning battery on the lock screen.
    if (state == AppLifecycleState.resumed) {
      if (ref.read(activeOrganizationProvider) != null) {
        unawaited(_scanner.start());
      }
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      unawaited(_scanner.stop());
    }
  }

  Future<void> _ensureActiveOrganization() async {
    if (!mounted) return;
    final activeOrg = ref.read(activeOrganizationProvider);
    if (activeOrg != null) return;

    // Prime the memberships list — the picker needs it.
    if (ref.read(myMembershipsListProvider) is AsyncLoading) {
      // wait for it
      try {
        await ref.read(myMembershipsListProvider.future);
      } catch (_) {/* picker will show its own error */}
    } else if (ref.read(myMembershipsListProvider).hasError) {
      ref.read(myMembershipsListProvider.notifier).refresh();
    }

    if (!mounted) return;

    // Edge case: only one vendor org → silent select, no sheet.
    final vendorOrgs = ref.read(vendorMembershipsProvider);
    if (vendorOrgs.length == 1) {
      final m = vendorOrgs.first;
      final org = m.organization;
      if (org != null && org.uuid != null) {
        await ref
            .read(activeOrganizationProvider.notifier)
            .set(_buildActiveOrgFromMembership(m));
        return;
      }
    }

    if (_orgPickerShown) return;
    _orgPickerShown = true;
    final picked = await showOrganizationPickerSheet(context);
    _orgPickerShown = false;
    if (!mounted) return;
    if (!picked) {
      // User dismissed without picking — leave the screen.
      context.pop();
    }
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_processing) return;
    if (capture.barcodes.isEmpty) return;
    final raw = capture.barcodes.first.rawValue;
    if (raw == null || raw.isEmpty) return;

    // Debounce: same code within 2s is an artifact of the scanner re-firing
    // before we navigate away. Real re-entries come via `WouldBeReEntry`
    // after a successful commit + resume.
    final now = DateTime.now();
    if (_lastScanned == raw &&
        _lastScanAt != null &&
        now.difference(_lastScanAt!) < const Duration(seconds: 2)) {
      return;
    }
    _lastScanned = raw;
    _lastScanAt = now;

    setState(() => _processing = true);
    HapticFeedback.lightImpact();
    await _scanner.stop();

    try {
      await _handleQr(raw);
    } finally {
      if (mounted) {
        setState(() => _processing = false);
        // Resume scanning for the next ticket.
        await Future<void>.delayed(const Duration(milliseconds: 350));
        if (mounted) {
          await _scanner.start();
        }
      }
    }
  }

  Future<void> _handleQr(String qrData, {bool manualMode = false}) async {
    final repo = ref.read(checkinRepositoryProvider);
    PeekResult? result;
    try {
      result = await repo.peek(
        qrData: manualMode ? null : qrData,
        qrCode: manualMode ? qrData : null,
      );
    } on CheckinFailure catch (e) {
      if (!mounted) return;
      await _showBlocked(e);
      return;
    }

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
    final repo = ref.read(checkinRepositoryProvider);
    final request = CheckinRequestDto(
      deviceId: session.deviceId,
      deviceName: session.deviceName,
      gate: session.gate,
      scanMethod: 'qr_code',
    );

    try {
      final response = await repo.commit(ticket.uuid, request);
      if (!mounted) return;
      _showSuccessSnack(response.isReEntry, response.checkInCount);
    } on CheckinFailure catch (e) {
      if (!mounted) return;
      if (e.isNetworkError) {
        // Spec §15: never auto-retry. Surface and let the vendor re-scan;
        // the next peek will reveal whether the previous commit landed.
        _showNetworkUnstableBanner();
      } else {
        await _showBlocked(e);
      }
    }
  }

  Future<void> _showBlocked(CheckinFailure e) async {
    await showCheckinBlockedSheet(
      context,
      reason: e.blocker,
      extraMessage: e.message,
    );
  }

  void _showSuccessSnack(bool isReEntry, int count) {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        backgroundColor: isReEntry ? HbColors.warning : HbColors.success,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        content: Text(
          isReEntry
              ? l10n.checkinReEntryRecorded(count)
              : l10n.checkinEntryRecorded,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showNetworkUnstableBanner() {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        backgroundColor: HbColors.error,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        content: Text(
          l10n.checkinNetworkRescan,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Future<void> _switchOrg() async {
    await _scanner.stop();
    if (!mounted) return;
    final picked = await showOrganizationPickerSheet(context);
    if (!mounted) return;
    if (picked) {
      await _scanner.start();
    } else if (ref.read(activeOrganizationProvider) != null) {
      // No new org: resume the current one (active org unchanged).
      await _scanner.start();
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeOrg = ref.watch(activeOrganizationProvider);
    final session = ref.watch(scanSessionProvider);
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black54,
        elevation: 0,
        foregroundColor: Colors.white,
        title: Text(l10n.checkinScannerTitle),
        actions: [
          IconButton(
            tooltip: l10n.checkinTorchTooltip,
            icon: const Icon(Icons.flash_on),
            onPressed: () => _scanner.toggleTorch(),
          ),
          IconButton(
            tooltip: l10n.checkinCameraTooltip,
            icon: const Icon(Icons.cameraswitch_outlined),
            onPressed: () => _scanner.switchCamera(),
          ),
          PopupMenuButton<String>(
            tooltip: l10n.checkinMoreTooltip,
            onSelected: (value) async {
              switch (value) {
                case 'switch_org':
                  await _switchOrg();
                case 'manual':
                  await _scanner.stop();
                  if (!context.mounted) return;
                  await context.push('/vendor/scan/manual');
                  if (mounted) await _scanner.start();
                case 'gate':
                  await _editGate();
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'switch_org',
                child: Text(l10n.checkinSwitchOrganization),
              ),
              PopupMenuItem(
                value: 'manual',
                child: Text(l10n.checkinManualEntryTitle),
              ),
              PopupMenuItem(
                value: 'gate',
                child: Text(l10n.checkinGateLabel),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (activeOrg != null)
            MobileScanner(
              controller: _scanner,
              onDetect: _onDetect,
              errorBuilder: (_, error, __) => _CameraErrorOverlay(error: error),
            )
          else
            const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          _ScanReticle(processing: _processing),
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: _BottomBar(
              orgName: activeOrg?.name ?? '—',
              gate: session.gate,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _editGate() async {
    final controller = TextEditingController(
      text: ref.read(scanSessionProvider).gate,
    );
    final l10n = context.l10n;
    final res = await showDialog<String?>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.checkinGateLabel),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: l10n.checkinGateHint,
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: Text(l10n.commonSave),
          ),
        ],
      ),
    );
    if (res != null) {
      ref.read(scanSessionProvider.notifier).setGate(res.isEmpty ? null : res);
    }
  }
}

ActiveOrganization _buildActiveOrgFromMembership(MembershipDto membership) {
  final org = membership.organization!;
  return ActiveOrganization(
    uuid: org.uuid!,
    name: org.displayName,
    role: membership.role ?? MembershipRole.staff,
    logoUrl: org.logoOrUrl,
  );
}

class _ScanReticle extends StatelessWidget {
  final bool processing;
  const _ScanReticle({required this.processing});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 260,
        height: 260,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: processing ? HbColors.warning : Colors.white,
            width: 3,
          ),
        ),
        alignment: Alignment.center,
        child: processing
            ? const SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white,
                ),
              )
            : null,
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final String orgName;
  final String? gate;
  const _BottomBar({required this.orgName, this.gate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.business, size: 18, color: Colors.white70),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  orgName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (gate != null && gate!.isNotEmpty)
                  Text(
                    context.l10n.checkinGateDisplay(gate!),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CameraErrorOverlay extends StatelessWidget {
  final MobileScannerException error;
  const _CameraErrorOverlay({required this.error});

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      debugPrint('mobile_scanner error: ${error.errorCode}');
    }
    final isPermissionDenied =
        error.errorCode == MobileScannerErrorCode.permissionDenied;
    final l10n = context.l10n;
    return Container(
      color: Colors.black,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.no_photography_outlined,
              size: 56, color: Colors.white70),
          const SizedBox(height: 16),
          Text(
            isPermissionDenied
                ? l10n.checkinCameraPermissionDeniedTitle
                : l10n.checkinCameraUnavailableTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isPermissionDenied
                ? l10n.checkinCameraPermissionDeniedBody
                : l10n.checkinCameraUnavailableBody,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () => context.push('/vendor/scan/manual'),
            child: Text(l10n.checkinManualEntryTitle),
          ),
        ],
      ),
    );
  }
}
