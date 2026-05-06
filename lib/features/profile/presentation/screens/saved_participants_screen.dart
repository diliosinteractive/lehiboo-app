import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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
        title: const Text('Mes participants'),
        backgroundColor: Colors.white,
        foregroundColor: HbColors.textPrimary,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openParticipantForm(context),
        backgroundColor: HbColors.brandPrimary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Ajouter'),
      ),
      body: participantsAsync.when(
        data: (participants) {
          if (participants.isEmpty) {
            return _EmptyParticipantsState(
              onAdd: () => _openParticipantForm(context),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
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
                const Icon(Icons.error_outline, color: Colors.red, size: 42),
                const SizedBox(height: 12),
                const Text('Impossible de charger vos participants'),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () => ref.invalidate(savedParticipantsProvider),
                  child: const Text('Reessayer'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openParticipantForm(
    BuildContext context, [
    SavedParticipant? participant,
  ]) async {
    final messenger = ScaffoldMessenger.of(context);
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
            participant == null ? 'Participant ajoute' : 'Participant modifie',
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
        const SnackBar(content: Text('Participant supprime')),
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
            const Text(
              'Aucun participant',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: HbColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ajoutez vos enfants, proches ou personnes recurrentes pour les choisir rapidement au checkout.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('Ajouter un participant'),
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
                    participant.birthDate,
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

  static final DateFormat _displayDateFormat = DateFormat('dd/MM/yyyy');

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
      helpText: 'Date de naissance',
      cancelText: 'Annuler',
      confirmText: 'Valider',
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
                    ? 'Ajouter un participant'
                    : 'Modifier le participant',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: HbColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: HbColors.brandPrimary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: HbColors.brandPrimary.withValues(alpha: 0.18),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.auto_awesome_outlined,
                      size: 18,
                      color: HbColors.brandPrimary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Le prenom, la date de naissance, la ville et la relation aident l IA et l experience Le Hiboo a proposer les offres et evenements les plus pertinents.',
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.35,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _firstNameCtrl,
                decoration: _inputDecoration('Prenom *'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Prenom requis'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _lastNameCtrl,
                decoration: _inputDecoration('Nom *'),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Nom requis' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _labelCtrl,
                decoration: _inputDecoration('Surnom'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _relationship,
                decoration: _inputDecoration('Relation *'),
                items: const [
                  DropdownMenuItem(value: 'self', child: Text('Moi')),
                  DropdownMenuItem(value: 'child', child: Text('Enfant')),
                  DropdownMenuItem(value: 'spouse', child: Text('Conjoint')),
                  DropdownMenuItem(value: 'family', child: Text('Famille')),
                  DropdownMenuItem(value: 'friend', child: Text('Ami')),
                  DropdownMenuItem(value: 'other', child: Text('Autre')),
                ],
                onChanged: (value) => setState(() => _relationship = value),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Relation requise' : null,
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: _pickBirthDate,
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: _inputDecoration('Date de naissance *').copyWith(
                    suffixIcon: const Icon(Icons.calendar_today_outlined),
                    errorText:
                        _birthDateMissing ? 'Date de naissance requise' : null,
                  ),
                  child: Text(
                    _birthDate != null
                        ? _displayDateFormat.format(_birthDate!)
                        : 'jj/mm/aaaa',
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
                decoration: _inputDecoration('Ville d appartenance *'),
                textCapitalization: TextCapitalization.words,
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Ville requise'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailCtrl,
                decoration: _inputDecoration('Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneCtrl,
                decoration: _inputDecoration('Telephone'),
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
                  child: const Text('Enregistrer'),
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
