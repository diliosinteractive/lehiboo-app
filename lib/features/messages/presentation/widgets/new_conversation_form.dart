import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/repositories/messages_repository_impl.dart';
import '../../domain/entities/conversation.dart';

// ── Context sealed class ────────────────────────────────────────────────────

sealed class NewConversationContext {}

/// User selects organizer from their contactable orgs.
class DashboardConversationContext extends NewConversationContext {}

/// Organizer is pre-filled (from event detail or org public page).
class FromOrganizerConversationContext extends NewConversationContext {
  final String organizationUuid;
  final String organizationName;
  final String? organizationLogoUrl;
  final String? prefilledEventId;
  final String? prefilledEventTitle;

  FromOrganizerConversationContext({
    required this.organizationUuid,
    required this.organizationName,
    this.organizationLogoUrl,
    this.prefilledEventId,
    this.prefilledEventTitle,
  });
}

/// Fixed recipient: Support Le Hiboo.
class SupportConversationContext extends NewConversationContext {}

// ── Widget ──────────────────────────────────────────────────────────────────

class NewConversationForm extends ConsumerStatefulWidget {
  final NewConversationContext conversationContext;

  const NewConversationForm({super.key, required this.conversationContext});

  /// Present as a modal bottom sheet from any BuildContext.
  static Future<void> show(
    BuildContext context, {
    required NewConversationContext conversationContext,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) =>
          NewConversationForm(conversationContext: conversationContext),
    );
  }

  @override
  ConsumerState<NewConversationForm> createState() =>
      _NewConversationFormState();
}

class _NewConversationFormState extends ConsumerState<NewConversationForm> {
  static const _primaryColor = Color(0xFFFF601F);
  static const _subjectMax = 100;
  static const _messageMax = 2000;
  static const _maxFiles = 3;
  static const _maxFileBytes = 5 * 1024 * 1024;
  static const _allowedExtensions = ['jpg', 'jpeg', 'png', 'webp', 'pdf'];
  static const _supportSubjects = [
    'Problème de réservation',
    'Question sur un événement',
    'Problème de paiement',
    'Demande de remboursement',
    'Problème de compte',
    "Signalement d'un contenu",
    'Autre',
  ];

  ConversationOrganization? _selectedOrg;
  String? _eventId;
  String? _eventTitle;
  final _subjectCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  String? _selectedSupportSubject;
  final List<XFile> _files = [];
  String? _fileError;
  bool _orgError = false;
  bool _isLoading = false;
  String? _submitError;
  bool _submitted = false;

  bool get _isSupport =>
      widget.conversationContext is SupportConversationContext;
  bool get _isDashboard =>
      widget.conversationContext is DashboardConversationContext;
  bool get _isFromOrg =>
      widget.conversationContext is FromOrganizerConversationContext;

  @override
  void initState() {
    super.initState();
    final ctx = widget.conversationContext;
    if (ctx is FromOrganizerConversationContext) {
      _eventId = ctx.prefilledEventId;
      _eventTitle = ctx.prefilledEventTitle;
    }
    _subjectCtrl.addListener(() => setState(() {}));
    _messageCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _subjectCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  // ── Derived ────────────────────────────────────────────────────────────────

  String get _subtitle => _isSupport
      ? 'Décrivez votre problème et notre équipe vous répondra rapidement.'
      : 'Composez votre message ci-dessous.';

  bool _validate() {
    final orgMissing = _isDashboard && _selectedOrg == null;
    final subjectMissing = _subjectCtrl.text.trim().isEmpty;
    final messageMissing = _messageCtrl.text.trim().isEmpty;
    setState(() {
      _submitted = true;
      _orgError = orgMissing;
    });
    return !orgMissing && !subjectMissing && !messageMissing;
  }

  // ── Org picker (DashboardContext only) ─────────────────────────────────────

  Future<void> _openOrgPicker() async {
    setState(() => _isLoading = true);
    try {
      final repo = ref.read(messagesRepositoryImplProvider);
      final orgs = await repo.getContactableOrganizations();
      if (!mounted) return;
      setState(() => _isLoading = false);
      final picked = await showModalBottomSheet<ConversationOrganization>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (_) => _OrgPickerSheet(orgs: orgs),
      );
      if (picked != null && mounted) {
        setState(() {
          _selectedOrg = picked;
          _orgError = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ── File helpers ────────────────────────────────────────────────────────────

  Future<void> _pickAttachment() async {
    setState(() => _fileError = null);
    if (_files.length >= _maxFiles) {
      setState(() =>
          _fileError = 'Maximum $_maxFiles fichiers par message.');
      return;
    }
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Photo / Vidéo'),
              onTap: () async {
                Navigator.pop(ctx);
                final picker = ImagePicker();
                final picked = await picker.pickMultiImage();
                await _addFiles(
                    picked.map((x) => XFile(x.path, name: x.name)).toList());
              },
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text('Document (PDF)'),
              onTap: () async {
                Navigator.pop(ctx);
                final result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['pdf'],
                  allowMultiple: false,
                );
                if (result == null || result.files.isEmpty) return;
                final path = result.files.single.path;
                final name = result.files.single.name;
                if (path != null) await _addFiles([XFile(path, name: name)]);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addFiles(List<XFile> candidates) async {
    for (final f in candidates) {
      if (_files.length >= _maxFiles) {
        setState(() =>
            _fileError = 'Maximum $_maxFiles fichiers par message.');
        break;
      }
      final ext = f.name.split('.').last.toLowerCase();
      if (!_allowedExtensions.contains(ext)) {
        setState(() => _fileError = 'Type non supporté : .$ext');
        continue;
      }
      final size = await f.length();
      if (size > _maxFileBytes) {
        setState(() => _fileError = '${f.name} dépasse 5 Mo.');
        continue;
      }
      setState(() => _files.add(f));
    }
  }

  // ── Submit ──────────────────────────────────────────────────────────────────

  Future<void> _submit() async {
    if (!_validate()) return;
    setState(() {
      _isLoading = true;
      _submitError = null;
    });
    try {
      final repo = ref.read(messagesRepositoryImplProvider);
      final subject = _subjectCtrl.text.trim();
      final message = _messageCtrl.text.trim();
      final files = List<XFile>.from(_files);
      final ctx = widget.conversationContext;

      String uuid;
      String route;

      if (ctx is DashboardConversationContext) {
        final conv = await repo.createConversation(
          organizationUuid: _selectedOrg!.uuid,
          subject: subject,
          message: message,
          attachments: files.isEmpty ? null : files,
        );
        uuid = conv.uuid;
        route = '/messages/$uuid';
      } else if (ctx is FromOrganizerConversationContext) {
        final conv = await repo.createFromOrganization(
          organizationUuid: ctx.organizationUuid,
          subject: subject,
          message: message,
          eventId: _eventId,
          attachments: files.isEmpty ? null : files,
        );
        uuid = conv.uuid;
        route = '/messages/$uuid';
      } else {
        final conv = await repo.createSupportConversation(
          subject: subject,
          message: message,
        );
        uuid = conv.uuid;
        route = '/messages/support/$uuid';
      }

      if (!mounted) return;
      Navigator.of(context).pop();
      context.push(route);
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _submitError = e.toString().replaceFirst('Exception: ', '');
        });
      }
    }
  }

  // ── build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      expand: false,
      builder: (_, scrollCtrl) => Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 4),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header row
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 12, 4),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Nouveau message',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      Text(_subtitle,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Scrollable body
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    controller: scrollCtrl,
                    padding:
                        const EdgeInsets.fromLTRB(20, 16, 20, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildRecipientSection(),
                        if (_isFromOrg && _eventId != null) ...[
                          const SizedBox(height: 16),
                          _buildEventChip(),
                        ],
                        const SizedBox(height: 16),
                        if (_isSupport) _buildSupportSubjectChips(),
                        _buildSubjectField(),
                        const SizedBox(height: 16),
                        _buildMessageField(),
                        if (!_isSupport) ...[
                          const SizedBox(height: 16),
                          _buildAttachmentsSection(),
                        ],
                        if (_submitError != null) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: Colors.red.shade200),
                            ),
                            child: Text(_submitError!,
                                style: TextStyle(
                                    color: Colors.red.shade700,
                                    fontSize: 13)),
                          ),
                        ],
                        const SizedBox(height: 24),
                        _buildActions(),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // ── Section builders ────────────────────────────────────────────────────────

  Widget _buildRecipientSection() {
    final ctx = widget.conversationContext;
    if (ctx is SupportConversationContext) {
      return _buildFixedRecipientCard(
        icon: const Icon(Icons.support_agent,
            color: Colors.white, size: 20),
        label: 'Support Le Hiboo',
        color: _primaryColor,
      );
    }
    if (ctx is FromOrganizerConversationContext) {
      return _buildFixedRecipientCard(
        avatarUrl: ctx.organizationLogoUrl,
        label: ctx.organizationName,
        color: _primaryColor,
      );
    }
    // DashboardContext — tappable picker row
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Destinataire', required: true),
        const SizedBox(height: 6),
        InkWell(
          onTap: _openOrgPicker,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: _orgError
                    ? Colors.red
                    : Colors.grey.shade300,
                width: _orgError ? 1.5 : 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                if (_selectedOrg != null)
                  CircleAvatar(
                    radius: 14,
                    backgroundColor:
                        _primaryColor.withValues(alpha: 0.15),
                    child: Text(
                      _selectedOrg!.companyName[0].toUpperCase(),
                      style: const TextStyle(
                          color: _primaryColor, fontSize: 12),
                    ),
                  )
                else
                  Icon(Icons.business_outlined,
                      color: Colors.grey.shade500, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _selectedOrg?.companyName ??
                        'Sélectionner un organisateur…',
                    style: TextStyle(
                      color: _selectedOrg != null
                          ? Colors.black87
                          : Colors.grey.shade500,
                      fontSize: 14,
                    ),
                  ),
                ),
                Icon(Icons.expand_more,
                    color: Colors.grey.shade500),
              ],
            ),
          ),
        ),
        if (_orgError)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(
              'Veuillez sélectionner un organisateur.',
              style: TextStyle(
                  fontSize: 11, color: Colors.red.shade600),
            ),
          ),
      ],
    );
  }

  Widget _buildFixedRecipientCard({
    String? avatarUrl,
    Widget? icon,
    required String label,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Destinataire'),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: color.withValues(alpha: 0.15),
                backgroundImage:
                    avatarUrl != null && avatarUrl.isNotEmpty
                        ? CachedNetworkImageProvider(avatarUrl)
                        : null,
                child: avatarUrl == null || avatarUrl.isEmpty
                    ? (icon ??
                        Text(
                          label.isNotEmpty
                              ? label[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                              color: color,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ))
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(label,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: color)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEventChip() {
    return Row(
      children: [
        Text('Événement',
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700)),
        const SizedBox(width: 6),
        Text('(optionnel)',
            style: TextStyle(
                fontSize: 12, color: Colors.grey.shade500)),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.fromLTRB(10, 4, 6, 4),
          decoration: BoxDecoration(
            color: _primaryColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: _primaryColor.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  _eventTitle ?? _eventId ?? '',
                  style: const TextStyle(
                      fontSize: 12,
                      color: _primaryColor,
                      fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () => setState(() {
                  _eventId = null;
                  _eventTitle = null;
                }),
                child: const Icon(Icons.close,
                    size: 14, color: _primaryColor),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSupportSubjectChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quel est le sujet de votre demande ?',
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: _supportSubjects.map((opt) {
            final selected = _selectedSupportSubject == opt;
            return ChoiceChip(
              label: Text(opt,
                  style: TextStyle(
                      fontSize: 12,
                      color: selected
                          ? _primaryColor
                          : Colors.black87)),
              selected: selected,
              onSelected: (_) => setState(() {
                _selectedSupportSubject = opt;
                if (opt != 'Autre') {
                  _subjectCtrl.text = opt;
                } else {
                  _subjectCtrl.clear();
                }
              }),
              selectedColor:
                  _primaryColor.withValues(alpha: 0.12),
              checkmarkColor: _primaryColor,
              side: BorderSide(
                  color: selected
                      ? _primaryColor
                      : Colors.grey.shade300),
              backgroundColor: Colors.white,
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSubjectField() {
    final hasError =
        _submitted && _subjectCtrl.text.trim().isEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Objet', required: true),
        const SizedBox(height: 6),
        TextField(
          controller: _subjectCtrl,
          maxLength: _subjectMax,
          buildCounter: (_, {required currentLength,
                required isFocused,
                maxLength}) =>
              null,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            hintText: "L'objet de votre message",
            border: const OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: hasError
                      ? Colors.red
                      : Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: hasError ? Colors.red : _primaryColor,
                  width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 12),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (hasError)
              Text('Le sujet est obligatoire.',
                  style: TextStyle(
                      fontSize: 11,
                      color: Colors.red.shade600))
            else
              const SizedBox.shrink(),
            Text(
              '${_subjectCtrl.text.length}/$_subjectMax',
              style: TextStyle(
                  fontSize: 11, color: Colors.grey.shade500),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMessageField() {
    final hasError =
        _submitted && _messageCtrl.text.trim().isEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Message', required: true),
        const SizedBox(height: 6),
        TextField(
          controller: _messageCtrl,
          maxLines: 5,
          maxLength: _messageMax,
          buildCounter: (_, {required currentLength,
                required isFocused,
                maxLength}) =>
              null,
          decoration: InputDecoration(
            hintText: 'Écrivez votre message…',
            alignLabelWithHint: true,
            border: const OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: hasError
                      ? Colors.red
                      : Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: hasError ? Colors.red : _primaryColor,
                  width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 12),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (hasError)
              Text('Le message est obligatoire.',
                  style: TextStyle(
                      fontSize: 11,
                      color: Colors.red.shade600))
            else
              const SizedBox.shrink(),
            Text(
              '${_messageCtrl.text.length}/$_messageMax',
              style: TextStyle(
                  fontSize: 11, color: Colors.grey.shade500),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAttachmentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Pièces jointes (optionnel)'),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed:
              _files.length >= _maxFiles ? null : _pickAttachment,
          icon: const Icon(Icons.upload_outlined, size: 16),
          label: const Text('Ajouter un fichier'),
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: _files.length >= _maxFiles
                  ? Colors.grey.shade300
                  : Colors.grey.shade400,
            ),
          ),
        ),
        if (_fileError != null) ...[
          const SizedBox(height: 4),
          Text(_fileError!,
              style: TextStyle(
                  fontSize: 11, color: Colors.red.shade600)),
        ],
        if (_files.isNotEmpty) ...[
          const SizedBox(height: 8),
          ..._files.map(_buildFileRow),
        ],
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '${_files.length}/$_maxFiles · Max 5 Mo chacun',
            style: TextStyle(
                fontSize: 11, color: Colors.grey.shade500),
          ),
        ),
      ],
    );
  }

  Widget _buildFileRow(XFile f) {
    final isPdf = f.name.toLowerCase().endsWith('.pdf');
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(
            isPdf
                ? Icons.picture_as_pdf
                : Icons.image_outlined,
            size: 20,
            color: isPdf
                ? Colors.red.shade400
                : Colors.blue.shade400,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(f.name,
                style: const TextStyle(fontSize: 12),
                overflow: TextOverflow.ellipsis),
          ),
          GestureDetector(
            onTap: () => setState(() => _files.remove(f)),
            child: Icon(Icons.close,
                size: 16, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Annuler'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : _submit,
            icon: _isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white),
                  )
                : const Icon(Icons.send_rounded,
                    size: 16, color: Colors.white),
            label: Text(
              _isSupport ? 'Envoyer au support' : 'Envoyer',
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              padding:
                  const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }

  // ── Utilities ───────────────────────────────────────────────────────────────

  Widget _sectionLabel(String text, {bool required = false}) {
    return Row(
      children: [
        Text(text,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700)),
        if (required)
          const Text(' *',
              style: TextStyle(
                  color: Colors.red,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
      ],
    );
  }
}

// ── Org picker bottom sheet with search ────────────────────────────────────────

class _OrgPickerSheet extends StatefulWidget {
  final List<ConversationOrganization> orgs;

  const _OrgPickerSheet({required this.orgs});

  @override
  State<_OrgPickerSheet> createState() => _OrgPickerSheetState();
}

class _OrgPickerSheetState extends State<_OrgPickerSheet> {
  static const _primaryColor = Color(0xFFFF601F);
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = _query.isEmpty
        ? widget.orgs
        : widget.orgs
            .where((o) =>
                o.companyName.toLowerCase().contains(_query.toLowerCase()))
            .toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      minChildSize: 0.3,
      expand: false,
      builder: (_, scrollCtrl) => Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text('Choisir un organisateur',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              autofocus: true,
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Rechercher par nom…',
                prefixIcon: const Icon(Icons.search, size: 20),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: widget.orgs.isEmpty
                ? const Center(
                    child: Text('Aucun organisateur disponible.',
                        style: TextStyle(color: Colors.grey)))
                : filtered.isEmpty
                    ? Center(
                        child: Text(
                          'Aucun résultat pour "$_query".',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        controller: scrollCtrl,
                        itemCount: filtered.length,
                        itemBuilder: (_, i) {
                          final org = filtered[i];
                          final logoUrl =
                              org.logoUrl ?? org.avatarUrl;
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  _primaryColor.withValues(alpha: 0.15),
                              backgroundImage: logoUrl != null &&
                                      logoUrl.isNotEmpty
                                  ? CachedNetworkImageProvider(logoUrl)
                                  : null,
                              child: logoUrl == null || logoUrl.isEmpty
                                  ? Text(
                                      org.companyName.isNotEmpty
                                          ? org.companyName[0].toUpperCase()
                                          : '?',
                                      style: const TextStyle(
                                          color: _primaryColor),
                                    )
                                  : null,
                            ),
                            title: Text(org.companyName),
                            subtitle: org.organizationName != org.companyName
                                ? Text(org.organizationName)
                                : null,
                            onTap: () => Navigator.pop(context, org),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
