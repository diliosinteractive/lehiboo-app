import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lehiboo/core/l10n/l10n.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/core/utils/api_response_handler.dart';
import 'package:lehiboo/features/profile/domain/models/saved_participant.dart';
import 'package:lehiboo/features/profile/presentation/providers/saved_participants_provider.dart';

class SavedParticipantsScreen extends ConsumerStatefulWidget {
  const SavedParticipantsScreen({super.key});

  @override
  ConsumerState<SavedParticipantsScreen> createState() =>
      _SavedParticipantsScreenState();
}

class _SavedParticipantsScreenState
    extends ConsumerState<SavedParticipantsScreen> {
  @override
  Widget build(BuildContext context) {
    final participantsAsync = ref.watch(savedParticipantsProvider);

    return Scaffold(
      backgroundColor: HbColors.backgroundLight,
      appBar: AppBar(
        title: Text(context.l10n.profileParticipantsTitle),
        backgroundColor: Colors.white,
        foregroundColor: HbColors.textPrimary,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openParticipantForm(context),
        backgroundColor: HbColors.brandPrimary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text(context.l10n.profileParticipantsAddShort),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: _ParticipantPersonalizationNotice(),
          ),
          Expanded(
            child: participantsAsync.when(
              data: (participants) {
                if (participants.isEmpty) {
                  return _EmptyParticipantsState(
                    onAdd: () => _openParticipantForm(context),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                  itemBuilder: (context, index) {
                    final participant = participants[index];
                    return _ParticipantTile(
                      participant: participant,
                      onEdit: () => _openParticipantForm(context, participant),
                      onDelete: () => _deleteParticipant(participant),
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemCount: participants.length,
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 42,
                      ),
                      const SizedBox(height: 12),
                      Text(context.l10n.profileParticipantsLoadError),
                      const SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: () =>
                            ref.invalidate(savedParticipantsProvider),
                        child: Text(context.l10n.commonRetry),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openParticipantForm(
    BuildContext context, [
    SavedParticipant? participant,
  ]) async {
    final messenger = ScaffoldMessenger.of(context);
    final addedMessage = context.l10n.profileParticipantAdded;
    final updatedMessage = context.l10n.profileParticipantUpdated;
    final result = await showModalBottomSheet<SavedParticipant>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => _ParticipantFormSheet(participant: participant),
    );

    if (result == null) return;

    try {
      final actions = ref.read(savedParticipantsActionsProvider);
      if (participant == null) {
        await actions.create(result);
      } else {
        await actions.update(result);
      }
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            participant == null ? addedMessage : updatedMessage,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(ApiResponseHandler.extractError(e)),
          backgroundColor: Colors.red.shade600,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  Future<void> _deleteParticipant(SavedParticipant participant) async {
    try {
      await ref.read(savedParticipantsActionsProvider).delete(participant.uuid);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.profileParticipantDeleted)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ApiResponseHandler.extractError(e)),
          backgroundColor: Colors.red.shade600,
        ),
      );
    }
  }
}

class _ParticipantPersonalizationNotice extends StatelessWidget {
  const _ParticipantPersonalizationNotice();

  @override
  Widget build(BuildContext context) {
    const noticeColor = Color(0xFF9A3412);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFED7AA)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.auto_awesome_outlined,
            size: 18,
            color: noticeColor,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              context.l10n.profileParticipantsPersonalizationNotice,
              style: const TextStyle(
                fontSize: 13,
                height: 1.35,
                fontWeight: FontWeight.w600,
                color: noticeColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyParticipantsState extends StatelessWidget {
  final VoidCallback onAdd;

  const _EmptyParticipantsState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: HbColors.brandPrimary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.groups_outlined,
                color: HbColors.brandPrimary,
                size: 38,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              context.l10n.profileParticipantsEmptyTitle,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: HbColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.profileParticipantsEmptyBody,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: Text(context.l10n.profileParticipantsAddCta),
              style: ElevatedButton.styleFrom(
                backgroundColor: HbColors.brandPrimary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ParticipantTile extends StatelessWidget {
  final SavedParticipant participant;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ParticipantTile({
    required this.participant,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: HbColors.brandPrimary.withValues(alpha: 0.1),
            child: Text(
              participant.displayName.trim().isNotEmpty
                  ? participant.displayName.trim().substring(0, 1).toUpperCase()
                  : '?',
              style: const TextStyle(color: HbColors.brandPrimary),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  participant.displayName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: HbColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  [
                    _formatBirthDate(context, participant.birthDate),
                    participant.membershipCity,
                  ].whereType<String>().where((v) => v.isNotEmpty).join(' - '),
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline, color: Colors.red),
          ),
        ],
      ),
    );
  }

  String? _formatBirthDate(BuildContext context, String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final parsed = DateTime.tryParse(raw.trim());
    if (parsed == null) return raw;
    return context
        .appDateFormat('dd/MM/yyyy', enPattern: 'MM/dd/yyyy')
        .format(parsed);
  }
}

class _ParticipantFormSheet extends StatefulWidget {
  final SavedParticipant? participant;

  const _ParticipantFormSheet({this.participant});

  @override
  State<_ParticipantFormSheet> createState() => _ParticipantFormSheetState();
}

class _ParticipantFormSheetState extends State<_ParticipantFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _labelCtrl;
  late final TextEditingController _firstNameCtrl;
  late final TextEditingController _lastNameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _cityCtrl;
  DateTime? _birthDate;
  String? _relationship;
  bool _birthDateMissing = false;

  @override
  void initState() {
    super.initState();
    final participant = widget.participant;
    _labelCtrl = TextEditingController(text: participant?.label ?? '');
    _firstNameCtrl = TextEditingController(text: participant?.firstName ?? '');
    _lastNameCtrl = TextEditingController(text: participant?.lastName ?? '');
    _emailCtrl = TextEditingController(text: participant?.email ?? '');
    _phoneCtrl = TextEditingController(text: participant?.phone ?? '');
    _cityCtrl = TextEditingController(text: participant?.membershipCity ?? '');
    _birthDate = _parseInitialBirthDate(participant?.birthDate);
    _relationship = participant?.relationship;
  }

  /// Accepts ISO (yyyy-MM-dd or full ISO) and dd/MM/yyyy fallback.
  static DateTime? _parseInitialBirthDate(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final iso = DateTime.tryParse(raw);
    if (iso != null) return DateTime(iso.year, iso.month, iso.day);
    try {
      return DateFormat('dd/MM/yyyy').parseStrict(raw.trim());
    } catch (_) {
      return null;
    }
  }

  @override
  void dispose() {
    _labelCtrl.dispose();
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _cityCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final initial = _birthDate ?? DateTime(now.year - 8, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: now,
      helpText: context.l10n.profileBirthDateLabel,
      cancelText: context.l10n.commonCancel,
      confirmText: context.l10n.commonValidate,
    );
    if (picked != null && mounted) {
      setState(() {
        _birthDate = picked;
        _birthDateMissing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.participant == null
                    ? context.l10n.profileParticipantAddTitle
                    : context.l10n.profileParticipantEditTitle,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: HbColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              const _ParticipantPersonalizationNotice(),
              const SizedBox(height: 16),
              TextFormField(
                controller: _firstNameCtrl,
                decoration: _inputDecoration(
                    context.l10n.profileParticipantFirstNameLabelRequired),
                validator: (value) => value == null || value.trim().isEmpty
                    ? context.l10n.profileParticipantFirstNameRequired
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _lastNameCtrl,
                decoration: _inputDecoration(
                    context.l10n.profileParticipantLastNameLabelRequired),
                validator: (value) => value == null || value.trim().isEmpty
                    ? context.l10n.profileParticipantLastNameRequired
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _labelCtrl,
                decoration: _inputDecoration(
                    context.l10n.profileParticipantNicknameLabel),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _relationship,
                decoration: _inputDecoration(
                    context.l10n.profileParticipantRelationshipLabelRequired),
                items: [
                  DropdownMenuItem(
                    value: 'self',
                    child: Text(context.l10n.bookingRelationshipSelf),
                  ),
                  DropdownMenuItem(
                    value: 'child',
                    child: Text(context.l10n.bookingRelationshipChild),
                  ),
                  DropdownMenuItem(
                    value: 'spouse',
                    child: Text(context.l10n.bookingRelationshipSpouse),
                  ),
                  DropdownMenuItem(
                    value: 'family',
                    child: Text(context.l10n.bookingRelationshipFamily),
                  ),
                  DropdownMenuItem(
                    value: 'friend',
                    child: Text(context.l10n.bookingRelationshipFriend),
                  ),
                  DropdownMenuItem(
                    value: 'other',
                    child: Text(context.l10n.bookingRelationshipOther),
                  ),
                ],
                onChanged: (value) => setState(() => _relationship = value),
                validator: (value) => value == null || value.isEmpty
                    ? context.l10n.profileParticipantRelationshipRequired
                    : null,
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: _pickBirthDate,
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: _inputDecoration(
                    context.l10n.profileParticipantBirthDateLabelRequired,
                  ).copyWith(
                    suffixIcon: const Icon(Icons.calendar_today_outlined),
                    errorText: _birthDateMissing
                        ? context.l10n.profileParticipantBirthDateRequired
                        : null,
                  ),
                  child: Text(
                    _birthDate != null
                        ? context
                            .appDateFormat(
                              'dd/MM/yyyy',
                              enPattern: 'MM/dd/yyyy',
                            )
                            .format(_birthDate!)
                        : context.l10n.profileParticipantBirthDateHint,
                    style: TextStyle(
                      color: _birthDate != null
                          ? HbColors.textPrimary
                          : Colors.grey.shade500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _cityCtrl,
                decoration: _inputDecoration(
                    context.l10n.profileParticipantCityLabelRequired),
                textCapitalization: TextCapitalization.words,
                validator: (value) => value == null || value.trim().isEmpty
                    ? context.l10n.profileParticipantCityRequired
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailCtrl,
                decoration: _inputDecoration(context.l10n.authEmailLabel),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneCtrl,
                decoration: _inputDecoration(context.l10n.profilePhoneLabel),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HbColors.brandPrimary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(context.l10n.commonSave),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  void _submit() {
    setState(() => _birthDateMissing = _birthDate == null);
    if (!_formKey.currentState!.validate() || _birthDateMissing) return;

    Navigator.of(context).pop(
      SavedParticipant(
        uuid: widget.participant?.uuid ?? '',
        label: _labelCtrl.text.trim().isEmpty ? null : _labelCtrl.text.trim(),
        relationship: _relationship,
        displayName: _labelCtrl.text.trim().isNotEmpty
            ? _labelCtrl.text.trim()
            : '${_firstNameCtrl.text.trim()} ${_lastNameCtrl.text.trim()}',
        firstName: _firstNameCtrl.text.trim(),
        lastName: _lastNameCtrl.text.trim(),
        email: _emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim(),
        phone: _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
        birthDate: _birthDate == null
            ? null
            : DateFormat('yyyy-MM-dd').format(_birthDate!),
        membershipCity: _cityCtrl.text.trim(),
      ),
    );
  }
}
