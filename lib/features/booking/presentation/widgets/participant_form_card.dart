import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/core/utils/age_utils.dart';
import 'package:lehiboo/features/booking/domain/models/booking_flow_state.dart';
import 'package:lehiboo/features/profile/domain/models/saved_participant.dart';

/// A single participant form collecting attendee details for one ticket.
class ParticipantFormCard extends StatefulWidget {
  final String ticketTypeName;
  final int participantIndex;
  final int totalForType;
  final bool showSameAsBuyer;
  final BuyerInfo? buyerInfo;
  final ParticipantInfo initialValue;
  final List<SavedParticipant> savedParticipants;
  final ValueChanged<ParticipantInfo> onChanged;

  const ParticipantFormCard({
    super.key,
    required this.ticketTypeName,
    required this.participantIndex,
    required this.totalForType,
    this.showSameAsBuyer = false,
    this.buyerInfo,
    required this.initialValue,
    this.savedParticipants = const [],
    required this.onChanged,
  });

  @override
  State<ParticipantFormCard> createState() => _ParticipantFormCardState();
}

class _ParticipantFormCardState extends State<ParticipantFormCard> {
  late TextEditingController _firstNameCtrl;
  late TextEditingController _lastNameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _ageCtrl;
  late TextEditingController _cityCtrl;

  bool _sameAsBuyer = false;
  String? _birthDate;
  String? _relationship;

  static final DateFormat _displayDateFormat = DateFormat('dd/MM/yyyy');
  static const Map<String, String> _relationshipLabels = {
    'self': 'Moi',
    'child': 'Enfant',
    'spouse': 'Conjoint',
    'family': 'Famille',
    'friend': 'Ami',
    'other': 'Autre',
  };

  @override
  void initState() {
    super.initState();
    _firstNameCtrl =
        TextEditingController(text: widget.initialValue.firstName ?? '');
    _lastNameCtrl =
        TextEditingController(text: widget.initialValue.lastName ?? '');
    _emailCtrl = TextEditingController(text: widget.initialValue.email ?? '');
    _phoneCtrl = TextEditingController(text: widget.initialValue.phone ?? '');
    _birthDate = widget.initialValue.birthDate;
    _relationship = widget.initialValue.relationship;
    _ageCtrl = TextEditingController(
      text: widget.initialValue.age != null
          ? widget.initialValue.age.toString()
          : (computeAge(widget.initialValue.birthDate)?.toString() ?? ''),
    );
    _cityCtrl = TextEditingController(
      text:
          widget.initialValue.membershipCity ?? widget.initialValue.city ?? '',
    );
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _ageCtrl.dispose();
    _cityCtrl.dispose();
    super.dispose();
  }

  void _emitChange() {
    final age = int.tryParse(_ageCtrl.text);
    widget.onChanged(ParticipantInfo(
      firstName: _firstNameCtrl.text.trim(),
      lastName: _lastNameCtrl.text.trim(),
      email: _emailCtrl.text.trim().isNotEmpty ? _emailCtrl.text.trim() : null,
      phone: _phoneCtrl.text.trim().isNotEmpty ? _phoneCtrl.text.trim() : null,
      relationship: _relationship,
      birthDate: _birthDate,
      age: age,
      city: _cityCtrl.text.trim().isNotEmpty ? _cityCtrl.text.trim() : null,
      membershipCity:
          _cityCtrl.text.trim().isNotEmpty ? _cityCtrl.text.trim() : null,
    ));
  }

  void _toggleSameAsBuyer(bool value) {
    setState(() {
      _sameAsBuyer = value;
    });
    if (value && widget.buyerInfo != null) {
      final buyer = widget.buyerInfo!;
      _firstNameCtrl.text = buyer.firstName ?? '';
      _lastNameCtrl.text = buyer.lastName ?? '';
      _emailCtrl.text = buyer.email ?? '';
      _phoneCtrl.text = buyer.phone ?? '';
      _cityCtrl.text = buyer.town ?? '';
      _birthDate = buyer.birthDate;
      _relationship = 'self';
      final age = computeAge(buyer.birthDate);
      _ageCtrl.text = age != null ? age.toString() : '';
    } else {
      _firstNameCtrl.clear();
      _lastNameCtrl.clear();
      _emailCtrl.clear();
      _phoneCtrl.clear();
      _cityCtrl.clear();
      _ageCtrl.clear();
      _birthDate = null;
      _relationship = null;
    }
    _emitChange();
  }

  void _applySavedParticipant(SavedParticipant participant) {
    setState(() {
      _sameAsBuyer = false;
      _firstNameCtrl.text = participant.firstName;
      _lastNameCtrl.text = participant.lastName;
      _emailCtrl.text = participant.email ?? '';
      _phoneCtrl.text = participant.phone ?? '';
      _cityCtrl.text = participant.membershipCity ?? '';
      _birthDate = participant.birthDate;
      _relationship = participant.relationship ?? 'other';
      final age = computeAge(participant.birthDate);
      _ageCtrl.text = age != null ? age.toString() : '';
    });
    _emitChange();
  }

  Future<void> _pickBirthDate(FormFieldState<String> field) async {
    final now = DateTime.now();
    final initial = DateTime.tryParse(_birthDate ?? '') ??
        DateTime(now.year - 8, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: now,
      helpText: 'Date de naissance',
      cancelText: 'Annuler',
      confirmText: 'Valider',
    );
    if (picked == null || !mounted) return;

    final formatted = DateFormat('yyyy-MM-dd').format(picked);
    setState(() {
      _birthDate = formatted;
      final age = computeAge(formatted);
      _ageCtrl.text = age != null ? age.toString() : '';
    });
    field.didChange(formatted);
    _emitChange();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            '${widget.ticketTypeName} — Participant ${widget.participantIndex} / ${widget.totalForType}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: HbColors.textPrimary,
            ),
          ),

          // "Same as buyer" toggle
          if (widget.showSameAsBuyer) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: Checkbox(
                    value: _sameAsBuyer,
                    onChanged: (v) => _toggleSameAsBuyer(v ?? false),
                    activeColor: HbColors.brandPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _toggleSameAsBuyer(!_sameAsBuyer),
                  child: Text(
                    'Identique à l\'acheteur',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                  ),
                ),
              ],
            ),
          ],

          if (widget.savedParticipants.isNotEmpty) ...[
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showParticipantPicker(context),
                icon: const Icon(Icons.group_outlined, size: 18),
                label: const Text('Choisir dans Mes participants'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: HbColors.brandPrimary,
                  side: BorderSide(
                    color: HbColors.brandPrimary.withValues(alpha: 0.35),
                  ),
                ),
              ),
            ),
          ],

          const SizedBox(height: 12),

          // First name
          TextFormField(
            controller: _firstNameCtrl,
            decoration: _inputDecoration('Prénom *'),
            textCapitalization: TextCapitalization.words,
            readOnly: _sameAsBuyer,
            onChanged: (_) => _emitChange(),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Le prénom est requis' : null,
          ),
          const SizedBox(height: 10),

          // Last name
          TextFormField(
            controller: _lastNameCtrl,
            decoration: _inputDecoration('Nom'),
            textCapitalization: TextCapitalization.words,
            readOnly: _sameAsBuyer,
            onChanged: (_) => _emitChange(),
          ),
          const SizedBox(height: 10),

          DropdownButtonFormField<String>(
            initialValue: (_relationship != null && _relationship!.isNotEmpty)
                ? _relationship
                : null,
            decoration: _inputDecoration('Relation *'),
            items: _relationshipLabels.entries
                .map(
                  (entry) => DropdownMenuItem(
                    value: entry.key,
                    child: Text(entry.value),
                  ),
                )
                .toList(),
            onChanged: _sameAsBuyer
                ? null
                : (value) {
                    setState(() => _relationship = value);
                    _emitChange();
                  },
            validator: (value) =>
                value == null || value.isEmpty ? 'Relation requise' : null,
          ),
          const SizedBox(height: 10),

          // Email (optional)
          TextFormField(
            controller: _emailCtrl,
            decoration: _inputDecoration('Email'),
            keyboardType: TextInputType.emailAddress,
            readOnly: _sameAsBuyer,
            onChanged: (_) => _emitChange(),
          ),
          const SizedBox(height: 10),

          // Phone (optional)
          TextFormField(
            controller: _phoneCtrl,
            decoration: _inputDecoration('Téléphone'),
            keyboardType: TextInputType.phone,
            readOnly: _sameAsBuyer,
            onChanged: (_) => _emitChange(),
          ),
          const SizedBox(height: 10),

          FormField<String>(
            initialValue: _birthDate,
            validator: (_) => (_birthDate == null || _birthDate!.isEmpty)
                ? 'Date de naissance requise'
                : null,
            builder: (field) {
              final parsed = DateTime.tryParse(_birthDate ?? '');

              return InkWell(
                onTap: _sameAsBuyer ? null : () => _pickBirthDate(field),
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: _inputDecoration('Date de naissance *').copyWith(
                    suffixIcon: const Icon(Icons.calendar_today_outlined),
                    errorText: field.errorText,
                    fillColor: _sameAsBuyer
                        ? Colors.grey.shade100
                        : Colors.grey.shade50,
                  ),
                  child: Text(
                    parsed != null
                        ? _displayDateFormat.format(parsed)
                        : 'jj/mm/aaaa',
                    style: TextStyle(
                      color: parsed != null
                          ? HbColors.textPrimary
                          : Colors.grey.shade500,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 10),

          TextFormField(
            controller: _ageCtrl,
            decoration: _inputDecoration('Age'),
            keyboardType: TextInputType.number,
            readOnly: true,
          ),
          const SizedBox(height: 10),

          // City (optional)
          TextFormField(
            controller: _cityCtrl,
            decoration: _inputDecoration('Ville d\'appartenance *'),
            textCapitalization: TextCapitalization.words,
            readOnly: _sameAsBuyer,
            onChanged: (_) => _emitChange(),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Ville requise' : null,
          ),
        ],
      ),
    );
  }

  Future<void> _showParticipantPicker(BuildContext context) async {
    final selected = await showModalBottomSheet<SavedParticipant>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            itemBuilder: (context, index) {
              final participant = widget.savedParticipants[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: HbColors.brandPrimary.withValues(alpha: 0.1),
                  child: Text(
                    participant.displayName.isNotEmpty
                        ? participant.displayName
                            .trim()
                            .substring(0, 1)
                            .toUpperCase()
                        : '?',
                    style: const TextStyle(color: HbColors.brandPrimary),
                  ),
                ),
                title: Text(participant.displayName),
                subtitle: Text(
                  [
                    participant.birthDate,
                    participant.membershipCity,
                  ].whereType<String>().where((v) => v.isNotEmpty).join(' - '),
                ),
                onTap: () => Navigator.of(context).pop(participant),
              );
            },
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemCount: widget.savedParticipants.length,
          ),
        );
      },
    );

    if (selected != null) {
      _applySavedParticipant(selected);
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: _sameAsBuyer ? Colors.grey.shade100 : Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: HbColors.brandPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}
