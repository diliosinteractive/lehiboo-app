import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lehiboo/core/l10n/l10n.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/core/utils/age_utils.dart';
import 'package:lehiboo/features/booking/domain/models/booking_flow_state.dart';
import 'package:lehiboo/features/booking/presentation/utils/booking_l10n.dart';
import 'package:lehiboo/features/profile/domain/models/saved_participant.dart';

/// One ticket = one card. Layout matches the desktop accordion item:
/// numbered avatar (✓ when complete) + ticket-type pill + status pill,
/// then an expandable body containing the "Pré-remplir ce billet" dropdown,
/// the form fields in a 2-column grid, an optional contact section, and
/// a "Save to Mes participants" checkbox when manually entered.
class ParticipantFormCard extends StatefulWidget {
  final String ticketTypeName;
  final int participantIndex; // 1-based for display
  final int totalForType;
  final BuyerInfo? buyerInfo;
  final ParticipantInfo initialValue;
  final List<SavedParticipant> savedParticipants;
  final ValueChanged<ParticipantInfo> onChanged;

  /// Optional event/slot context shown in the card header.
  final String? eventTitle;
  final String? slotLabel;

  /// Whether this card should be expanded by default (parent decides — typically
  /// the first incomplete one).
  final bool initiallyExpanded;

  const ParticipantFormCard({
    super.key,
    required this.ticketTypeName,
    required this.participantIndex,
    required this.totalForType,
    this.buyerInfo,
    required this.initialValue,
    this.savedParticipants = const [],
    required this.onChanged,
    this.eventTitle,
    this.slotLabel,
    this.initiallyExpanded = false,
  });

  @override
  State<ParticipantFormCard> createState() => _ParticipantFormCardState();
}

class _ParticipantFormCardState extends State<ParticipantFormCard> {
  late TextEditingController _firstNameCtrl;
  late TextEditingController _lastNameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _cityCtrl;

  String? _birthDate;
  String? _relationship;
  String _prefillSource =
      'manual'; // 'manual' | 'self' | <savedParticipant.uuid>
  bool _saveForLater = false;
  bool _expanded = false;
  bool _contactExpanded = false;

  static const List<String> _relationshipKeys = [
    'self',
    'child',
    'spouse',
    'family',
    'friend',
    'other',
  ];

  @override
  void initState() {
    super.initState();
    _initControllers(widget.initialValue);
    _prefillSource = _resolvePrefillSource(widget.initialValue);
    _expanded = widget.initiallyExpanded || !widget.initialValue.isComplete;
    _saveForLater = widget.initialValue.saveForLater;
  }

  @override
  void didUpdateWidget(covariant ParticipantFormCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Parent-driven prefill (e.g. "Remplir tous avec mon profil") replaces
    // the initialValue. Sync the controllers if the data actually changed.
    if (oldWidget.initialValue != widget.initialValue) {
      _syncFieldsFromInitial(widget.initialValue);
      _prefillSource = _resolvePrefillSource(widget.initialValue);
      _saveForLater = widget.initialValue.saveForLater;
    } else if ((oldWidget.savedParticipants != widget.savedParticipants ||
            oldWidget.buyerInfo != widget.buyerInfo) &&
        !_isPrefillSourceAvailable(_prefillSource)) {
      _prefillSource = _resolvePrefillSource(widget.initialValue);
    }
  }

  void _initControllers(ParticipantInfo info) {
    _firstNameCtrl = TextEditingController();
    _lastNameCtrl = TextEditingController();
    _emailCtrl = TextEditingController();
    _phoneCtrl = TextEditingController();
    _cityCtrl = TextEditingController();
    _syncFieldsFromInitial(info);
  }

  void _syncFieldsFromInitial(ParticipantInfo info) {
    _firstNameCtrl.text = info.firstName ?? '';
    _lastNameCtrl.text = info.lastName ?? '';
    _emailCtrl.text = info.email ?? '';
    _phoneCtrl.text = info.phone ?? '';
    _cityCtrl.text = info.membershipCity ?? info.city ?? '';
    _birthDate = info.birthDate;
    _relationship = info.relationship;
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _cityCtrl.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Sync helpers

  void _emitChange() {
    final age = computeAge(_birthDate);
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
      saveForLater: _saveForLater,
    ));
  }

  String _resolvePrefillSource(ParticipantInfo info) {
    if (info.isBlank) return 'manual';

    for (final participant in widget.savedParticipants) {
      if (_matchesSavedParticipant(info, participant)) {
        return participant.uuid;
      }
    }

    if (_matchesBuyerInfo(info, widget.buyerInfo)) {
      return 'self';
    }

    return 'manual';
  }

  bool _isPrefillSourceAvailable(String source) {
    if (source == 'manual') return true;
    if (source == 'self') return widget.buyerInfo != null;
    return widget.savedParticipants.any((p) => p.uuid == source);
  }

  bool _matchesSavedParticipant(ParticipantInfo info, SavedParticipant saved) {
    return _sameText(info.firstName, saved.firstName) &&
        _sameText(info.lastName, saved.lastName) &&
        _sameText(info.email, saved.email) &&
        _sameText(info.phone, saved.phone) &&
        _sameText(info.birthDate, saved.birthDate) &&
        _sameText(_participantCity(info), saved.membershipCity) &&
        _sameRelationship(info.relationship, saved.relationship);
  }

  bool _matchesBuyerInfo(ParticipantInfo info, BuyerInfo? buyer) {
    if (buyer == null) return false;
    return _sameText(info.firstName, buyer.firstName) &&
        _sameText(info.lastName, buyer.lastName) &&
        _sameText(info.email, buyer.email) &&
        _sameText(info.phone, buyer.phone) &&
        _sameText(info.birthDate, buyer.birthDate) &&
        _sameText(_participantCity(info), buyer.town) &&
        _normalize(info.relationship) == 'self';
  }

  String _participantCity(ParticipantInfo info) {
    final membershipCity = _normalize(info.membershipCity);
    return membershipCity.isNotEmpty ? membershipCity : _normalize(info.city);
  }

  bool _sameText(String? left, String? right) {
    return _normalize(left) == _normalize(right);
  }

  bool _sameRelationship(String? infoRelationship, String? sourceRelationship) {
    final info = _normalize(infoRelationship);
    final source = _normalize(sourceRelationship);
    if (source.isEmpty) {
      return info.isEmpty || info == 'other';
    }
    return info == source;
  }

  String _normalize(String? value) => value?.trim() ?? '';

  void _applyPrefill(String source) {
    if (source == 'manual') {
      // Don't wipe the user's input — manual just means "ne pas pré-remplir".
      setState(() {
        _prefillSource = source;
      });
      _emitChange();
      return;
    }

    if (source == 'self' && widget.buyerInfo != null) {
      final buyer = widget.buyerInfo!;
      setState(() {
        _prefillSource = source;
        _firstNameCtrl.text = buyer.firstName ?? '';
        _lastNameCtrl.text = buyer.lastName ?? '';
        _emailCtrl.text = buyer.email ?? '';
        _phoneCtrl.text = buyer.phone ?? '';
        _cityCtrl.text = buyer.town ?? '';
        _birthDate = buyer.birthDate;
        _relationship = 'self';
        _saveForLater = false;
      });
      _emitChange();
      return;
    }

    final saved = widget.savedParticipants
        .where((p) => p.uuid == source)
        .cast<SavedParticipant?>()
        .firstWhere((_) => true, orElse: () => null);
    if (saved != null) {
      setState(() {
        _prefillSource = source;
        _firstNameCtrl.text = saved.firstName;
        _lastNameCtrl.text = saved.lastName;
        _emailCtrl.text = saved.email ?? '';
        _phoneCtrl.text = saved.phone ?? '';
        _cityCtrl.text = saved.membershipCity ?? '';
        _birthDate = saved.birthDate;
        _relationship = saved.relationship ?? 'other';
        _saveForLater = false;
      });
      _emitChange();
    }
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final initial = DateTime.tryParse(_birthDate ?? '') ??
        DateTime(now.year - 8, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: now,
      helpText: context.l10n.bookingBirthDateHelp,
      cancelText: context.l10n.commonCancel,
      confirmText: context.l10n.bookingConfirm,
    );
    if (picked == null || !mounted) return;

    final formatted = DateFormat('yyyy-MM-dd').format(picked);
    setState(() {
      _birthDate = formatted;
    });
    _emitChange();
  }

  // ---------------------------------------------------------------------------
  // Build

  bool get _isComplete => widget.initialValue.isComplete;

  String get _displayName {
    final fn = _firstNameCtrl.text.trim();
    final ln = _lastNameCtrl.text.trim();
    final composed = [fn, ln].where((v) => v.isNotEmpty).join(' ');
    return composed.isNotEmpty
        ? composed
        : '${context.l10n.bookingTicketFallback} ${widget.participantIndex}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _isComplete
              ? const Color(0xFFA7F3D0) // emerald-200
              : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 220),
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              // Top inset gives the first field's outline floating label room
              // to render — without it AnimatedCrossFade's Stack clips the
              // label's upper half (the part that sits above the field).
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
              child: _buildBody(),
            ),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return InkWell(
      onTap: () => setState(() => _expanded = !_expanded),
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
        child: Row(
          children: [
            // Numbered avatar / checkmark
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: _isComplete
                    ? const Color(0xFF10B981) // emerald-500
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(99),
              ),
              alignment: Alignment.center,
              child: _isComplete
                  ? const Icon(Icons.check, size: 18, color: Colors.white)
                  : Text(
                      '${widget.participantIndex}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: HbColors.textPrimary,
                      ),
                    ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          _displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: HbColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      _TicketTypePill(label: widget.ticketTypeName),
                    ],
                  ),
                  if (widget.eventTitle != null ||
                      widget.slotLabel != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      [
                        widget.eventTitle,
                        widget.slotLabel,
                      ].whereType<String>().join(' · '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 6),
            _StatusPill(complete: _isComplete),
            Icon(
              _expanded ? Icons.expand_less : Icons.expand_more,
              size: 20,
              color: Colors.grey.shade500,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          key: ValueKey('prefill-$_prefillSource'),
          initialValue: _prefillSource,
          decoration:
              _inputDecoration(context.l10n.bookingPrefillTicket).copyWith(
            // Base helper uses isDense + symmetric padding, which clips the
            // floating label. Switch to non-dense and use asymmetric padding
            // that mirrors Flutter's default for outline + floating label
            // (extra top room so the label has space to sit).
            isDense: false,
            contentPadding: const EdgeInsets.fromLTRB(12, 20, 12, 12),
          ),
          isExpanded: true,
          items: [
            DropdownMenuItem(
              value: 'manual',
              child: Text(context.l10n.bookingManualEntry),
            ),
            if (widget.buyerInfo != null)
              DropdownMenuItem(
                value: 'self',
                child: Text(context.l10n.bookingBuyerSelf),
              ),
            for (final p in widget.savedParticipants)
              DropdownMenuItem(
                value: p.uuid,
                child: Text(
                  '${p.displayName}${p.relationship != null ? ' · ${context.bookingRelationshipLabel(p.relationship!)}' : ''}',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
          onChanged: (value) {
            if (value == null) return;
            _applyPrefill(value);
          },
        ),
        const SizedBox(height: 12),
        LayoutBuilder(builder: (context, constraints) {
          final fieldWidth = (constraints.maxWidth - 10) / 2;
          return Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              SizedBox(
                width: fieldWidth,
                child: TextFormField(
                  controller: _firstNameCtrl,
                  decoration: _inputDecoration(
                      context.l10n.bookingFirstNameLabelRequired),
                  textCapitalization: TextCapitalization.words,
                  onChanged: (_) => _emitChange(),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? context.l10n.bookingFirstNameShortRequired
                      : null,
                ),
              ),
              SizedBox(
                width: fieldWidth,
                child: TextFormField(
                  controller: _lastNameCtrl,
                  decoration:
                      _inputDecoration(context.l10n.bookingLastNameLabel),
                  textCapitalization: TextCapitalization.words,
                  onChanged: (_) => _emitChange(),
                ),
              ),
              SizedBox(
                width: fieldWidth,
                child: _buildBirthDateField(),
              ),
              SizedBox(
                width: fieldWidth,
                child: TextFormField(
                  controller: _cityCtrl,
                  decoration:
                      _inputDecoration(context.l10n.bookingMembershipCityLabel),
                  textCapitalization: TextCapitalization.words,
                  onChanged: (_) => _emitChange(),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? context.l10n.bookingCityRequired
                      : null,
                ),
              ),
              SizedBox(
                width: constraints.maxWidth,
                child: DropdownButtonFormField<String>(
                  key: ValueKey('relationship-${_relationship ?? ''}'),
                  initialValue:
                      (_relationship != null && _relationship!.isNotEmpty)
                          ? _relationship
                          : null,
                  decoration: _inputDecoration(
                      context.l10n.bookingRelationLabelRequired),
                  items: _relationshipKeys
                      .map(
                        (relationship) => DropdownMenuItem(
                          value: relationship,
                          child: Text(
                            context.bookingRelationshipLabel(relationship),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() => _relationship = value);
                    _emitChange();
                  },
                  validator: (value) => value == null || value.isEmpty
                      ? context.l10n.bookingRelationRequired
                      : null,
                ),
              ),
            ],
          );
        }),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => setState(() => _contactExpanded = !_contactExpanded),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Icon(
                  _contactExpanded ? Icons.expand_less : Icons.expand_more,
                  size: 18,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 4),
                Text(
                  context.l10n.bookingContactOptional,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 180),
          firstChild: const SizedBox.shrink(),
          secondChild: Column(
            children: [
              const SizedBox(height: 6),
              TextFormField(
                controller: _emailCtrl,
                decoration: _inputDecoration(context.l10n.authEmailLabel),
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) => _emitChange(),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _phoneCtrl,
                decoration: _inputDecoration(context.l10n.bookingPhoneLabel),
                keyboardType: TextInputType.phone,
                onChanged: (_) => _emitChange(),
              ),
            ],
          ),
          crossFadeState: _contactExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
        ),
        if (_prefillSource == 'manual' && _isComplete) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              SizedBox(
                height: 24,
                width: 24,
                child: Checkbox(
                  value: _saveForLater,
                  onChanged: (v) {
                    setState(() => _saveForLater = v ?? false);
                    _emitChange();
                  },
                  activeColor: HbColors.brandPrimary,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() => _saveForLater = !_saveForLater);
                    _emitChange();
                  },
                  child: Text(
                    context.l10n.bookingSaveParticipant,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildBirthDateField() {
    final parsed = DateTime.tryParse(_birthDate ?? '');
    return InkWell(
      onTap: _pickBirthDate,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: _inputDecoration(context.l10n.bookingBirthDateLabelRequired)
            .copyWith(
          suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
        ),
        child: Text(
          parsed != null
              ? context
                  .appDateFormat('dd/MM/yyyy', enPattern: 'MM/dd/yyyy')
                  .format(parsed)
              : context.l10n.bookingBirthDatePlaceholder,
          style: TextStyle(
            color: parsed != null ? HbColors.textPrimary : Colors.grey.shade500,
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
      isDense: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: HbColors.brandPrimary, width: 1.6),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }
}

class _TicketTypePill extends StatelessWidget {
  final String label;
  const _TicketTypePill({required this.label});

  @override
  Widget build(BuildContext context) {
    final lower = label.toLowerCase();
    final isChild = lower.contains('enfant') || lower.contains('child');
    final color = isChild ? const Color(0xFFEA580C) : const Color(0xFF059669);
    final bg = isChild ? const Color(0xFFFFEDD5) : const Color(0xFFD1FAE5);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final bool complete;
  const _StatusPill({required this.complete});

  @override
  Widget build(BuildContext context) {
    final color = complete
        ? const Color(0xFF065F46) // emerald-800
        : const Color(0xFF9A3412); // orange-800
    final bg = complete
        ? const Color(0xFFD1FAE5) // emerald-100
        : const Color(0xFFFFEDD5); // orange-100
    final icon = complete ? Icons.check_circle : Icons.error_outline;
    final label = complete
        ? context.l10n.bookingParticipantComplete
        : context.l10n.bookingParticipantActionRequired;

    return Container(
      margin: const EdgeInsets.only(right: 4),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
