import 'package:flutter/material.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/core/utils/age_utils.dart';
import 'package:lehiboo/features/booking/domain/models/booking_flow_state.dart';

/// A single participant form collecting attendee details for one ticket.
class ParticipantFormCard extends StatefulWidget {
  final String ticketTypeName;
  final int participantIndex;
  final int totalForType;
  final bool showSameAsBuyer;
  final BuyerInfo? buyerInfo;
  final ParticipantInfo initialValue;
  final ValueChanged<ParticipantInfo> onChanged;

  const ParticipantFormCard({
    super.key,
    required this.ticketTypeName,
    required this.participantIndex,
    required this.totalForType,
    this.showSameAsBuyer = false,
    this.buyerInfo,
    required this.initialValue,
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

  @override
  void initState() {
    super.initState();
    _firstNameCtrl = TextEditingController(text: widget.initialValue.firstName ?? '');
    _lastNameCtrl = TextEditingController(text: widget.initialValue.lastName ?? '');
    _emailCtrl = TextEditingController(text: widget.initialValue.email ?? '');
    _phoneCtrl = TextEditingController(text: widget.initialValue.phone ?? '');
    _ageCtrl = TextEditingController(
      text: widget.initialValue.age != null ? widget.initialValue.age.toString() : '',
    );
    _cityCtrl = TextEditingController(text: widget.initialValue.city ?? '');
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
      age: age,
      city: _cityCtrl.text.trim().isNotEmpty ? _cityCtrl.text.trim() : null,
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
      final age = computeAge(buyer.birthDate);
      _ageCtrl.text = age != null ? age.toString() : '';
    } else {
      _firstNameCtrl.clear();
      _lastNameCtrl.clear();
      _emailCtrl.clear();
      _phoneCtrl.clear();
      _cityCtrl.clear();
      _ageCtrl.clear();
    }
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
            decoration: _inputDecoration('Nom *'),
            textCapitalization: TextCapitalization.words,
            readOnly: _sameAsBuyer,
            onChanged: (_) => _emitChange(),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Le nom est requis' : null,
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

          // Age (optional)
          TextFormField(
            controller: _ageCtrl,
            decoration: _inputDecoration('Age'),
            keyboardType: TextInputType.number,
            readOnly: _sameAsBuyer,
            onChanged: (_) => _emitChange(),
          ),
          const SizedBox(height: 10),

          // City (optional)
          TextFormField(
            controller: _cityCtrl,
            decoration: _inputDecoration('Ville d\'appartenance'),
            textCapitalization: TextCapitalization.words,
            readOnly: _sameAsBuyer,
            onChanged: (_) => _emitChange(),
          ),
        ],
      ),
    );
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
