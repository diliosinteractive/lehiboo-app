import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/broadcast.dart';
import '../../data/repositories/messages_repository_impl.dart';
import '../providers/vendor_broadcasts_provider.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Providers
// ─────────────────────────────────────────────────────────────────────────────

final _vendorEventsProvider = FutureProvider<List<VendorEvent>>((ref) async {
  return ref.read(messagesRepositoryProvider).getVendorEvents();
});

final _eventSlotsProvider =
    FutureProvider.family<List<SlotOption>, String>((ref, eventUuid) async {
  return ref.read(messagesRepositoryProvider).getEventSlots(eventUuid);
});

// ─────────────────────────────────────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────────────────────────────────────

class CreateBroadcastScreen extends ConsumerStatefulWidget {
  const CreateBroadcastScreen({super.key});

  @override
  ConsumerState<CreateBroadcastScreen> createState() =>
      _CreateBroadcastScreenState();
}

enum _Step { recipients, message, review }

class _CreateBroadcastScreenState
    extends ConsumerState<CreateBroadcastScreen> {
  static const _primaryColor = Color(0xFFFF601F);

  _Step _step = _Step.recipients;

  // Step 1
  VendorEvent? _selectedEvent;
  SlotOption? _selectedSlot; // null = all slots
  int? _recipientsCount;
  bool _loadingPreview = false;
  String? _previewError;

  // Step 2
  final _subjectCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Step 3
  bool _sending = false;

  @override
  void dispose() {
    _subjectCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  Future<void> _previewRecipients() async {
    if (_selectedEvent == null) return;
    setState(() {
      _loadingPreview = true;
      _previewError = null;
      _recipientsCount = null;
    });
    try {
      final count = await ref
          .read(messagesRepositoryProvider)
          .previewBroadcastRecipients(
            eventIds: [_selectedEvent!.uuid],
            slotIds:
                _selectedSlot != null ? [_selectedSlot!.uuid] : null,
          );
      if (!mounted) return;
      setState(() {
        _recipientsCount = count;
        _loadingPreview = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _previewError = e.toString();
        _loadingPreview = false;
      });
    }
  }

  Future<void> _send() async {
    setState(() => _sending = true);
    try {
      await ref.read(messagesRepositoryProvider).createBroadcast(
            subject: _subjectCtrl.text.trim(),
            message: _messageCtrl.text.trim(),
            eventIds: [_selectedEvent!.uuid],
            slotIds:
                _selectedSlot != null ? [_selectedSlot!.uuid] : null,
          );
      if (!mounted) return;
      ref.read(vendorBroadcastsProvider.notifier).refresh();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Diffusion envoyée avec succès !'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _sending = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur : $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _nextStep() {
    setState(() {
      _step = switch (_step) {
        _Step.recipients => _Step.message,
        _Step.message => _Step.review,
        _Step.review => _Step.review,
      };
    });
  }

  void _prevStep() {
    setState(() {
      _step = switch (_step) {
        _Step.recipients => _Step.recipients,
        _Step.message => _Step.recipients,
        _Step.review => _Step.message,
      };
    });
  }

  int get _stepIndex => switch (_step) {
        _Step.recipients => 0,
        _Step.message => 1,
        _Step.review => 2,
      };

  bool get _canGoNext => switch (_step) {
        _Step.recipients =>
          _selectedEvent != null &&
              (_recipientsCount ?? 0) > 0 &&
              !_loadingPreview,
        _Step.message =>
          _subjectCtrl.text.trim().length >= 3 &&
              _messageCtrl.text.trim().isNotEmpty,
        _Step.review => false,
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nouvelle diffusion — Étape ${_stepIndex + 1}/3'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Step indicator
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                _StepDot(
                    index: 0,
                    current: _stepIndex,
                    label: 'Destinataires'),
                Expanded(
                    child: Divider(
                        color: _stepIndex > 0
                            ? _primaryColor
                            : Colors.grey.shade300)),
                _StepDot(
                    index: 1, current: _stepIndex, label: 'Message'),
                Expanded(
                    child: Divider(
                        color: _stepIndex > 1
                            ? _primaryColor
                            : Colors.grey.shade300)),
                _StepDot(
                    index: 2,
                    current: _stepIndex,
                    label: 'Récapitulatif'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: switch (_step) {
              _Step.recipients => _RecipientsStep(
                  selectedEvent: _selectedEvent,
                  selectedSlot: _selectedSlot,
                  recipientsCount: _recipientsCount,
                  loadingPreview: _loadingPreview,
                  previewError: _previewError,
                  onEventSelected: (event) {
                    setState(() {
                      _selectedEvent = event;
                      _selectedSlot = null;
                      _recipientsCount = null;
                    });
                    if (event != null) {
                      ref.invalidate(_eventSlotsProvider(event.uuid));
                      _previewRecipients();
                    }
                  },
                  onSlotSelected: (slot) {
                    setState(() => _selectedSlot = slot);
                    _previewRecipients();
                  },
                ),
              _Step.message => _MessageStep(
                  subjectCtrl: _subjectCtrl,
                  messageCtrl: _messageCtrl,
                  formKey: _formKey,
                  onChanged: () => setState(() {}),
                ),
              _Step.review => _ReviewStep(
                  event: _selectedEvent!,
                  slot: _selectedSlot,
                  recipientsCount: _recipientsCount ?? 0,
                  subject: _subjectCtrl.text.trim(),
                  message: _messageCtrl.text.trim(),
                ),
            },
          ),
          // Bottom nav
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                children: [
                  if (_step != _Step.recipients)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _prevStep,
                        child: const Text('Retour'),
                      ),
                    ),
                  if (_step != _Step.recipients)
                    const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: _step == _Step.review
                        ? FilledButton(
                            style: FilledButton.styleFrom(
                                backgroundColor: _primaryColor),
                            onPressed: _sending ? null : _send,
                            child: _sending
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text('Envoyer'),
                          )
                        : FilledButton(
                            style: FilledButton.styleFrom(
                                backgroundColor: _canGoNext
                                    ? _primaryColor
                                    : Colors.grey),
                            onPressed: _canGoNext ? _nextStep : null,
                            child: const Text('Suivant'),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 1 — Recipients
// ─────────────────────────────────────────────────────────────────────────────

class _RecipientsStep extends ConsumerWidget {
  final VendorEvent? selectedEvent;
  final SlotOption? selectedSlot;
  final int? recipientsCount;
  final bool loadingPreview;
  final String? previewError;
  final ValueChanged<VendorEvent?> onEventSelected;
  final ValueChanged<SlotOption?> onSlotSelected;

  const _RecipientsStep({
    required this.selectedEvent,
    required this.selectedSlot,
    required this.recipientsCount,
    required this.loadingPreview,
    required this.previewError,
    required this.onEventSelected,
    required this.onSlotSelected,
  });

  Future<void> _openEventPicker(
      BuildContext context, List<VendorEvent> events) async {
    final picked = await showModalBottomSheet<VendorEvent>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _EventPickerSheet(
        events: events,
        selected: selectedEvent,
      ),
    );
    if (picked != null) onEventSelected(picked);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(_vendorEventsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Événement',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          eventsAsync.when(
            loading: () => _SelectorField(
              label: 'Chargement...',
              isPlaceholder: true,
              loading: true,
              onTap: null,
            ),
            error: (e, _) => Text('Erreur de chargement : $e',
                style: const TextStyle(color: Colors.red)),
            data: (events) => _SelectorField(
              label: selectedEvent?.title ?? 'Choisir un événement',
              isPlaceholder: selectedEvent == null,
              onTap: () => _openEventPicker(context, events),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Créneau',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          if (selectedEvent == null)
            _SelectorField(
              label: 'Sélectionnez d\'abord un événement',
              isPlaceholder: true,
              onTap: null,
            )
          else
            ref.watch(_eventSlotsProvider(selectedEvent!.uuid)).when(
                  loading: () => _SelectorField(
                    label: 'Chargement des créneaux...',
                    isPlaceholder: true,
                    loading: true,
                    onTap: null,
                  ),
                  error: (e, _) => Text('Erreur : $e',
                      style: const TextStyle(color: Colors.red)),
                  data: (slots) => _SlotSelector(
                    slots: slots,
                    selected: selectedSlot,
                    onChanged: onSlotSelected,
                  ),
                ),
          const SizedBox(height: 24),
          // Recipients preview
          if (selectedEvent != null) ...[
            const Divider(),
            const SizedBox(height: 12),
            if (loadingPreview)
              const Row(
                children: [
                  SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2)),
                  SizedBox(width: 10),
                  Text('Calcul des destinataires...',
                      style: TextStyle(fontSize: 13)),
                ],
              )
            else if (previewError != null)
              Row(
                children: [
                  const Icon(Icons.warning_amber_outlined,
                      color: Colors.orange, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Impossible de calculer les destinataires.',
                      style: TextStyle(
                          fontSize: 13, color: Colors.orange.shade700),
                    ),
                  ),
                ],
              )
            else if (recipientsCount != null)
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: recipientsCount! > 0
                      ? Colors.green.shade50
                      : Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: recipientsCount! > 0
                        ? Colors.green.shade300
                        : Colors.orange.shade300,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      recipientsCount! > 0
                          ? Icons.people_outline
                          : Icons.warning_amber_outlined,
                      size: 18,
                      color: recipientsCount! > 0
                          ? Colors.green.shade700
                          : Colors.orange.shade700,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      recipientsCount! > 0
                          ? '$recipientsCount destinataire${recipientsCount! > 1 ? 's' : ''} potentiel${recipientsCount! > 1 ? 's' : ''}'
                          : 'Aucun destinataire trouvé pour cette sélection',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: recipientsCount! > 0
                            ? Colors.green.shade800
                            : Colors.orange.shade800,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}

// Tappable selector field (consistent with app input style)
class _SelectorField extends StatelessWidget {
  final String label;
  final bool isPlaceholder;
  final bool loading;
  final VoidCallback? onTap;

  const _SelectorField({
    required this.label,
    required this.isPlaceholder,
    this.loading = false,
    required this.onTap,
  });

  static const _primaryColor = Color(0xFFFF601F);

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(
            color: enabled
                ? Colors.grey.shade400
                : Colors.grey.shade200,
          ),
          borderRadius: BorderRadius.circular(8),
          color: enabled ? Colors.white : Colors.grey.shade50,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: isPlaceholder
                      ? Colors.grey.shade500
                      : Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            loading
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.grey.shade400,
                    ),
                  )
                : Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 20,
                    color: enabled
                        ? _primaryColor
                        : Colors.grey.shade300,
                  ),
          ],
        ),
      ),
    );
  }
}

// Slot selector — kept as dropdown (few items, no search needed)
class _SlotSelector extends StatelessWidget {
  final List<SlotOption> slots;
  final SlotOption? selected;
  final ValueChanged<SlotOption?> onChanged;

  const _SlotSelector({
    required this.slots,
    required this.selected,
    required this.onChanged,
  });

  static const _primaryColor = Color(0xFFFF601F);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<SlotOption?>(
      key: ValueKey(selected?.uuid ?? 'all'),
      initialValue: selected,
      isExpanded: true,
      decoration: InputDecoration(
        border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              const BorderSide(color: _primaryColor, width: 1.5),
        ),
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
      items: [
        const DropdownMenuItem<SlotOption?>(
          value: null,
          child: Text('Tous les créneaux'),
        ),
        ...slots.map((s) => DropdownMenuItem<SlotOption?>(
              value: s,
              child:
                  Text(s.label, overflow: TextOverflow.ellipsis),
            )),
      ],
      onChanged: onChanged,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Event picker bottom sheet with search
// ─────────────────────────────────────────────────────────────────────────────

class _EventPickerSheet extends StatefulWidget {
  final List<VendorEvent> events;
  final VendorEvent? selected;

  const _EventPickerSheet({required this.events, required this.selected});

  @override
  State<_EventPickerSheet> createState() => _EventPickerSheetState();
}

class _EventPickerSheetState extends State<_EventPickerSheet> {
  static const _primaryColor = Color(0xFFFF601F);

  final _searchCtrl = TextEditingController();
  List<VendorEvent> _filtered = [];

  @override
  void initState() {
    super.initState();
    _filtered = widget.events;
    _searchCtrl.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearch() {
    final q = _searchCtrl.text.trim().toLowerCase();
    setState(() {
      _filtered = q.isEmpty
          ? widget.events
          : widget.events
              .where((e) => e.title.toLowerCase().contains(q))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      expand: false,
      builder: (_, scrollCtrl) => Column(
        children: [
          // Handle + header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Choisir un événement',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),
                // Search field — same style as ConversationFiltersBar
                TextField(
                  controller: _searchCtrl,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Rechercher...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    suffixIcon: _searchCtrl.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close, size: 18),
                            onPressed: () {
                              _searchCtrl.clear();
                              _onSearch();
                            },
                          )
                        : null,
                    isDense: true,
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
          const Divider(height: 1),
          // List
          Expanded(
            child: _filtered.isEmpty
                ? Center(
                    child: Text(
                      'Aucun événement trouvé',
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  )
                : ListView.builder(
                    controller: scrollCtrl,
                    itemCount: _filtered.length,
                    itemBuilder: (ctx, i) {
                      final event = _filtered[i];
                      final isSelected =
                          event.uuid == widget.selected?.uuid;
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: _primaryColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.event_outlined,
                              color: _primaryColor, size: 20),
                        ),
                        title: Text(
                          event.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check_circle,
                                color: _primaryColor, size: 20)
                            : null,
                        onTap: () => Navigator.of(ctx).pop(event),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 2 — Message
// ─────────────────────────────────────────────────────────────────────────────

class _MessageStep extends StatelessWidget {
  final TextEditingController subjectCtrl;
  final TextEditingController messageCtrl;
  final GlobalKey<FormState> formKey;
  final VoidCallback onChanged;

  const _MessageStep({
    required this.subjectCtrl,
    required this.messageCtrl,
    required this.formKey,
    required this.onChanged,
  });

  static const _primaryColor = Color(0xFFFF601F);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Sujet',
                style:
                    TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextFormField(
              controller: subjectCtrl,
              onChanged: (_) => onChanged(),
              maxLength: 255,
              decoration: InputDecoration(
                hintText: 'Objet de votre message...',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: _primaryColor, width: 1.5),
                ),
                isDense: true,
                contentPadding: const EdgeInsets.all(12),
              ),
              validator: (v) {
                if (v == null || v.trim().length < 3) {
                  return 'Minimum 3 caractères';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            const Text('Message',
                style:
                    TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextFormField(
              controller: messageCtrl,
              onChanged: (_) => onChanged(),
              maxLength: 10000,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: 'Rédigez votre message...',
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: _primaryColor, width: 1.5),
                ),
                isDense: true,
                contentPadding: const EdgeInsets.all(12),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Le message est requis';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 3 — Review
// ─────────────────────────────────────────────────────────────────────────────

class _ReviewStep extends StatelessWidget {
  final VendorEvent event;
  final SlotOption? slot;
  final int recipientsCount;
  final String subject;
  final String message;

  const _ReviewStep({
    required this.event,
    required this.slot,
    required this.recipientsCount,
    required this.subject,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Récapitulatif',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          _ReviewRow(
            icon: Icons.event_outlined,
            label: 'Événement',
            value: event.title,
          ),
          _ReviewRow(
            icon: Icons.schedule_outlined,
            label: 'Créneau',
            value: slot?.label ?? 'Tous les créneaux',
          ),
          _ReviewRow(
            icon: Icons.people_outline,
            label: 'Destinataires',
            value:
                '$recipientsCount destinataire${recipientsCount > 1 ? 's' : ''}',
            valueColor: Colors.green.shade700,
          ),
          const Divider(height: 24),
          _ReviewRow(
            icon: Icons.subject_outlined,
            label: 'Sujet',
            value: subject,
          ),
          const SizedBox(height: 12),
          const Text(
            'Message',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Text(
              message,
              style: const TextStyle(fontSize: 14, height: 1.5),
              maxLines: 6,
              overflow: TextOverflow.fade,
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _ReviewRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _ReviewRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade500),
          const SizedBox(width: 10),
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: valueColor ?? Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step dot indicator
// ─────────────────────────────────────────────────────────────────────────────

class _StepDot extends StatelessWidget {
  final int index;
  final int current;
  final String label;

  const _StepDot(
      {required this.index, required this.current, required this.label});

  static const _primaryColor = Color(0xFFFF601F);

  @override
  Widget build(BuildContext context) {
    final isActive = index == current;
    final isDone = index < current;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDone
                ? _primaryColor
                : isActive
                    ? _primaryColor
                    : Colors.grey.shade300,
          ),
          child: Center(
            child: isDone
                ? const Icon(Icons.check, size: 14, color: Colors.white)
                : Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isActive ? Colors.white : Colors.grey.shade600,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            color: isActive || isDone ? _primaryColor : Colors.grey.shade500,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
