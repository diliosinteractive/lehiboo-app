import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/conversation_report.dart';
import '../../data/repositories/messages_repository_impl.dart';
import '../providers/admin_conversations_provider.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Local state / notifier
// ─────────────────────────────────────────────────────────────────────────────

class _ReportDetailState {
  final AsyncValue<ConversationReport> report;
  final bool saving;

  const _ReportDetailState({
    this.report = const AsyncValue.loading(),
    this.saving = false,
  });

  _ReportDetailState copyWith({
    AsyncValue<ConversationReport>? report,
    bool? saving,
  }) =>
      _ReportDetailState(
        report: report ?? this.report,
        saving: saving ?? this.saving,
      );
}

class _ReportDetailNotifier extends StateNotifier<_ReportDetailState> {
  final String _uuid;
  final Ref _ref;

  _ReportDetailNotifier(this._uuid, this._ref)
      : super(const _ReportDetailState()) {
    _load();
  }

  Future<void> _load() async {
    state = state.copyWith(report: const AsyncValue.loading());
    try {
      var list = _ref.read(adminReportsProvider).reports.valueOrNull;
      if (list == null) {
        await _ref.read(adminReportsProvider.notifier).load();
        list = _ref.read(adminReportsProvider).reports.valueOrNull;
      }
      final found = list?.where((r) => r.uuid == _uuid).firstOrNull;
      if (found != null) {
        state = state.copyWith(report: AsyncValue.data(found));
      } else {
        state = state.copyWith(
            report: AsyncValue.error(
                'Signalement introuvable', StackTrace.current));
      }
    } catch (e) {
      state = state.copyWith(
          report: AsyncValue.error('$e', StackTrace.current));
    }
  }

  Future<void> reviewReport(String action, {String? adminNote}) async {
    state = state.copyWith(saving: true);
    try {
      // Single API call through the list provider (it handles local list update)
      await _ref.read(adminReportsProvider.notifier).reviewReport(
            _uuid,
            action,
            adminNote: adminNote,
          );
      final current = state.report.valueOrNull!;
      final fromList = _ref
          .read(adminReportsProvider)
          .reports
          .valueOrNull
          ?.where((r) => r.uuid == _uuid)
          .firstOrNull;
      // Patch the detail state — always set reviewedByName from the current admin
      final reviewerName = _ref.read(authProvider).user?.displayName ??
          fromList?.reviewedByName ??
          current.reviewedByName;
      final patched = (fromList ?? current).copyWith(
        status: action == 'dismiss' ? 'dismissed' : 'reviewed',
        reviewedAt: DateTime.now(),
        adminNote: adminNote ?? current.adminNote,
        reviewedByName: reviewerName,
      );
      state = state.copyWith(report: AsyncValue.data(patched), saving: false);
    } catch (e) {
      state = state.copyWith(saving: false);
      rethrow;
    }
  }

  Future<void> updateNote(String? note) async {
    state = state.copyWith(saving: true);
    try {
      await _ref
          .read(messagesRepositoryProvider)
          .updateAdminConversationReportNote(
            reportUuid: _uuid,
            adminNote: note,
          );
      _ref.read(adminReportsProvider.notifier).updateNote(_uuid, note);
      final current = state.report.valueOrNull;
      if (current != null) {
        state = state.copyWith(
          report: AsyncValue.data(current.copyWith(adminNote: note)),
          saving: false,
        );
      }
    } catch (e) {
      state = state.copyWith(saving: false);
      rethrow;
    }
  }
}

final _reportDetailProvider = StateNotifierProvider.family<
    _ReportDetailNotifier, _ReportDetailState, String>(
  (ref, uuid) => _ReportDetailNotifier(uuid, ref),
);

// ─────────────────────────────────────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────────────────────────────────────

class AdminReportDetailScreen extends ConsumerStatefulWidget {
  final String reportUuid;

  const AdminReportDetailScreen({super.key, required this.reportUuid});

  @override
  ConsumerState<AdminReportDetailScreen> createState() =>
      _AdminReportDetailScreenState();
}

class _AdminReportDetailScreenState
    extends ConsumerState<AdminReportDetailScreen> {
  static const _primaryColor = Color(0xFFFF601F);

  final _noteController = TextEditingController();
  bool _noteInitialized = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(_reportDetailProvider(widget.reportUuid));
    final notifier =
        ref.read(_reportDetailProvider(widget.reportUuid).notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: BackButton(
          onPressed: () =>
              context.canPop() ? context.pop() : context.go('/messages'),
        ),
        title: const Text('Détail du signalement',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ),
      body: state.report.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.flag_outlined,
                  color: Colors.grey, size: 40),
              const SizedBox(height: 12),
              Text('$e',
                  style: const TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: notifier._load,
                icon: const Icon(Icons.refresh),
                label: const Text('Réessayer'),
              ),
            ],
          ),
        ),
        data: (report) {
          if (!_noteInitialized) {
            _noteController.text = report.adminNote ?? '';
            _noteInitialized = true;
          }

          final isPending = report.status == 'pending';

          return SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── 1. Header card ──────────────────────────────────────
                _Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              report.conversationSubject ??
                                  'Conversation sans titre',
                              style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87),
                            ),
                          ),
                          const SizedBox(width: 10),
                          _StatusBadge(status: report.status),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.schedule_outlined,
                              size: 13, color: Colors.grey.shade500),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('d MMMM yyyy à HH:mm', 'fr_FR')
                                .format(report.createdAt),
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500),
                          ),
                          const SizedBox(width: 12),
                          Icon(Icons.tag,
                              size: 13, color: Colors.grey.shade400),
                          const SizedBox(width: 2),
                          Text(
                            report.uuid.length > 8
                                ? report.uuid.substring(0, 8)
                                : report.uuid,
                            style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade400,
                                fontFamily: 'monospace'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // ── 2. Parties ──────────────────────────────────────────
                const _SectionLabel('Parties impliquées'),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _PartyCard(
                        label: 'Rapporteur',
                        party: report.reporter,
                        typeLabel: 'Utilisateur',
                        typeColor: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _PartyCard(
                        label: 'Signalé',
                        party: report.againstWhom,
                        typeLabel: report.againstWhomType == 'organization'
                            ? 'Organisation'
                            : 'Utilisateur',
                        typeColor:
                            report.againstWhomType == 'organization'
                                ? Colors.purple
                                : Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ── 3. Reason ───────────────────────────────────────────
                const _SectionLabel('Motif du signalement'),
                _Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ReasonChip(reason: report.reason),
                      if (report.comment != null &&
                          report.comment!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border(
                              left: BorderSide(
                                  color: Colors.grey.shade300, width: 3),
                            ),
                          ),
                          child: Text(
                            report.comment!,
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade700,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // ── 4. Admin note ───────────────────────────────────────
                const _SectionLabel('Note interne (non visible par les usagers)'),
                _Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _noteController,
                        maxLines: 4,
                        style: const TextStyle(fontSize: 13),
                        decoration: InputDecoration(
                          hintText:
                              'Ajouter une note de modération…',
                          hintStyle: TextStyle(
                              color: Colors.grey.shade400, fontSize: 13),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                                color: Colors.grey.shade200),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                                color: Colors.grey.shade200),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: _primaryColor, width: 1.5),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          contentPadding: const EdgeInsets.all(12),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: FilledButton.icon(
                          onPressed: state.saving
                              ? null
                              : () => _saveNote(context, notifier),
                          style: FilledButton.styleFrom(
                            backgroundColor: _primaryColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          icon: state.saving
                              ? const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white),
                                )
                              : const Icon(Icons.save_outlined, size: 16),
                          label: const Text('Enregistrer',
                              style: TextStyle(fontSize: 13)),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── 5. Actions (pending only) ───────────────────────────
                if (isPending) ...[
                  const SizedBox(height: 16),
                  const _SectionLabel('Actions de modération'),
                  _Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Ces actions sont définitives et ne peuvent pas être annulées.',
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: state.saving
                                    ? null
                                    : () => _confirmReview(
                                        context, notifier, 'dismiss'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.grey.shade700,
                                  side: BorderSide(
                                      color: Colors.grey.shade300),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(8)),
                                ),
                                icon: const Icon(Icons.close, size: 16),
                                label: const Text('Ignorer',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500)),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: FilledButton.icon(
                                onPressed: state.saving
                                    ? null
                                    : () => _confirmReview(
                                        context, notifier, 'reviewed'),
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.green.shade600,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(8)),
                                ),
                                icon: const Icon(Icons.check, size: 16),
                                label: const Text('Marquer traité',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],

                // ── 6. Reviewed-by ──────────────────────────────────────
                if (report.reviewedByName != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(color: Colors.green.shade100),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.verified_outlined,
                            size: 16,
                            color: Colors.green.shade600),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Traité par ${report.reviewedByName}'
                            '${report.reviewedAt != null ? ' le ${DateFormat('d MMM yyyy', 'fr_FR').format(report.reviewedAt!)}' : ''}',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.green.shade700),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // ── 7. View conversation ────────────────────────────────
                if (report.conversationUuid != null) ...[
                  const SizedBox(height: 24),
                  const Divider(height: 1),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => context.push(
                          '/messages/admin/${report.conversationUuid}?readonly=true'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _primaryColor,
                        side: const BorderSide(color: _primaryColor),
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      icon: const Icon(Icons.visibility_outlined,
                          size: 18),
                      label: const Text('Voir la conversation liée',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],

                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _saveNote(
      BuildContext context, _ReportDetailNotifier notifier) async {
    try {
      final note = _noteController.text.trim();
      await notifier.updateNote(note.isEmpty ? null : note);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Note enregistrée.')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Erreur : $e'),
            backgroundColor: Colors.red));
      }
    }
  }

  Future<void> _confirmReview(
    BuildContext context,
    _ReportDetailNotifier notifier,
    String action,
  ) async {
    final isDismiss = action == 'dismiss';
    final label = isDismiss ? 'Ignorer' : 'Marquer traité';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(label),
        content: Text(isDismiss
            ? 'Ce signalement sera marqué comme ignoré. Confirmez-vous cette action ?'
            : 'Ce signalement sera marqué comme traité. Confirmez-vous cette action ?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Annuler')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: FilledButton.styleFrom(
                backgroundColor:
                    isDismiss ? Colors.grey : Colors.green.shade600,
              ),
              child: Text(label)),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    try {
      final note = _noteController.text.trim();
      await notifier.reviewReport(action,
          adminNote: note.isEmpty ? null : note);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(isDismiss
                  ? 'Signalement ignoré.'
                  : 'Signalement marqué comme traité.'),
              backgroundColor:
                  isDismiss ? Colors.grey.shade700 : Colors.green),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Erreur : $e'),
            backgroundColor: Colors.red));
      }
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Helper widgets
// ─────────────────────────────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  final Widget child;

  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEEEEF0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Colors.grey.shade500,
          letterSpacing: 0.9,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = switch (status) {
      'pending' => ('En attente', const Color(0xFFFFF3E0), const Color(0xFFE65100)),
      'reviewed' => ('Traité', const Color(0xFFE8F5E9), const Color(0xFF2E7D32)),
      'dismissed' => ('Ignoré', const Color(0xFFF5F5F5), const Color(0xFF616161)),
      'suspended' => ('Suspendu', const Color(0xFFFFEBEE), const Color(0xFFC62828)),
      _ => (status, const Color(0xFFF5F5F5), const Color(0xFF616161)),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
            fontSize: 11, color: fg, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _ReasonChip extends StatelessWidget {
  final String reason;

  const _ReasonChip({required this.reason});

  @override
  Widget build(BuildContext context) {
    final (label, icon, color) = switch (reason) {
      'inappropriate' => (
          'Contenu inapproprié',
          Icons.warning_amber_outlined,
          Colors.orange
        ),
      'harassment' => ('Harcèlement', Icons.person_off_outlined, Colors.red),
      'spam' => ('Spam', Icons.mark_email_unread_outlined, Colors.blue),
      _ => ('Autre', Icons.help_outline, Colors.grey),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(label,
              style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _PartyCard extends StatelessWidget {
  final String label;
  final ConversationReportParty? party;
  final String typeLabel;
  final Color typeColor;

  const _PartyCard({
    required this.label,
    this.party,
    required this.typeLabel,
    required this.typeColor,
  });

  @override
  Widget build(BuildContext context) {
    final name = party?.name ?? '–';
    final initial =
        name.isNotEmpty && name != '–' ? name[0].toUpperCase() : '?';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEEEEF0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
                fontSize: 9,
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _Avatar(
                  avatarUrl: party?.avatarUrl,
                  initial: initial,
                  color: typeColor),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (party?.email != null)
                      Text(
                        party!.email,
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey.shade500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (party?.organizationName != null) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.business_outlined,
                    size: 11, color: Colors.grey.shade400),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    party!.organizationName!,
                    style: TextStyle(
                        fontSize: 11, color: Colors.grey.shade500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 8),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: typeColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              typeLabel,
              style: TextStyle(
                  fontSize: 10,
                  color: typeColor,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String? avatarUrl;
  final String initial;
  final Color color;

  const _Avatar(
      {required this.avatarUrl,
      required this.initial,
      required this.color});

  @override
  Widget build(BuildContext context) {
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 18,
        backgroundImage: CachedNetworkImageProvider(avatarUrl!),
      );
    }
    return CircleAvatar(
      radius: 18,
      backgroundColor: color.withValues(alpha: 0.15),
      child: Text(
        initial,
        style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: color),
      ),
    );
  }
}
