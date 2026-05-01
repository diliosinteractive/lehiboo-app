import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/entities/accepted_partner.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/repositories/messages_repository.dart';
import '../../data/repositories/messages_repository_impl.dart';

enum VendorConversationMode { toParticipant, toPartner, supportThread }

class VendorNewConversationScreen extends ConsumerStatefulWidget {
  final VendorConversationMode mode;

  const VendorNewConversationScreen({super.key, required this.mode});

  @override
  ConsumerState<VendorNewConversationScreen> createState() =>
      _VendorNewConversationScreenState();
}

class _VendorNewConversationScreenState
    extends ConsumerState<VendorNewConversationScreen> {
  static const _primaryColor = Color(0xFFFF601F);
  static const _maxFiles = 3;
  static const _maxFileBytes = 5 * 1024 * 1024;
  static const _allowedExtensions = ['jpg', 'jpeg', 'png', 'webp', 'pdf'];

  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  final List<XFile> _attachments = [];

  ConversationParticipant? _selectedParticipant;
  AcceptedPartner? _selectedPartner;

  // Partners pre-loaded for the search sheet
  List<AcceptedPartner> _partners = [];
  bool _loadingPartners = false;

  bool _submitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.mode == VendorConversationMode.toPartner) {
      _loadPartners();
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _loadPartners() async {
    setState(() => _loadingPartners = true);
    try {
      final partners =
          await ref.read(messagesRepositoryProvider).getAcceptedPartners();
      setState(() {
        _partners = partners;
        _loadingPartners = false;
      });
    } catch (_) {
      setState(() => _loadingPartners = false);
    }
  }

  // ── Attachments ──────────────────────────────────────────────────────────────

  Future<void> _pickAttachment() async {
    if (_attachments.length >= _maxFiles) {
      _showSnack('Maximum $_maxFiles fichiers par message.');
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
              title: const Text('Photo / Image'),
              onTap: () async {
                Navigator.pop(ctx);
                await _pickImages();
              },
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text('Document (PDF)'),
              onTap: () async {
                Navigator.pop(ctx);
                await _pickPdf();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage();
    await _addFiles(picked.map((x) => XFile(x.path, name: x.name)).toList());
  }

  Future<void> _pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: false,
    );
    if (result == null || result.files.isEmpty) return;
    final path = result.files.single.path;
    final name = result.files.single.name;
    if (path != null) await _addFiles([XFile(path, name: name)]);
  }

  Future<void> _addFiles(List<XFile> files) async {
    for (final file in files) {
      if (_attachments.length >= _maxFiles) {
        _showSnack('Maximum $_maxFiles fichiers.');
        break;
      }
      final ext = file.name.split('.').last.toLowerCase();
      if (!_allowedExtensions.contains(ext)) {
        _showSnack('Type non supporté : .$ext');
        continue;
      }
      final size = await file.length();
      if (size > _maxFileBytes) {
        _showSnack('${file.name} dépasse 5 Mo.');
        continue;
      }
      setState(() => _attachments.add(file));
    }
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  // ── Search modals ─────────────────────────────────────────────────────────────

  Future<void> _openParticipantSearch() async {
    final repo = ref.read(messagesRepositoryProvider);
    final selected = await showModalBottomSheet<ConversationParticipant>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _ParticipantSearchSheet(repo: repo),
    );
    if (selected != null) setState(() => _selectedParticipant = selected);
  }

  Future<void> _openPartnerSearch() async {
    final selected = await showModalBottomSheet<AcceptedPartner>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _PartnerSearchSheet(partners: _partners),
    );
    if (selected != null) setState(() => _selectedPartner = selected);
  }

  // ── Submit ────────────────────────────────────────────────────────────────────

  Future<void> _submit() async {
    final subject = _subjectController.text.trim();
    final message = _messageController.text.trim();

    if (widget.mode != VendorConversationMode.supportThread) {
      if (subject.isEmpty) {
        setState(() => _error = 'Le sujet est requis.');
        return;
      }
    }
    if (message.isEmpty) {
      setState(() => _error = 'Le message est requis.');
      return;
    }

    setState(() {
      _submitting = true;
      _error = null;
    });

    try {
      final repo = ref.read(messagesRepositoryProvider);
      final files = _attachments.isNotEmpty ? _attachments : null;
      late final String convUuid;
      late final bool isOrgRoute;

      switch (widget.mode) {
        case VendorConversationMode.toParticipant:
          if (_selectedParticipant == null) {
            setState(() {
              _error = 'Veuillez sélectionner un participant.';
              _submitting = false;
            });
            return;
          }
          final conv = await repo.createVendorConversationToParticipant(
            participantId: _selectedParticipant!.id,
            subject: subject,
            message: message,
            attachments: files,
          );
          convUuid = conv.uuid;
          isOrgRoute = false;

        case VendorConversationMode.toPartner:
          if (_selectedPartner == null) {
            setState(() {
              _error = 'Veuillez sélectionner un partenaire.';
              _submitting = false;
            });
            return;
          }
          final conv = await repo.createOrgConversation(
            partnerOrganizationId: _selectedPartner!.id,
            subject: subject,
            message: message,
            attachments: files,
          );
          convUuid = conv.uuid;
          isOrgRoute = true;

        case VendorConversationMode.supportThread:
          final conv = await repo.createVendorSupportThread(
            subject: subject.isEmpty ? 'Support' : subject,
            message: message,
            attachments: files,
          );
          convUuid = conv.uuid;
          isOrgRoute = false;
      }

      if (mounted) {
        final path = isOrgRoute
            ? '/messages/vendor-org/$convUuid'
            : '/messages/vendor/$convUuid';
        context.pushReplacement(path);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _submitting = false;
          _error = e.toString().contains('403')
              ? _forbiddenMessage()
              : 'Erreur : $e';
        });
      }
    }
  }

  String _forbiddenMessage() => switch (widget.mode) {
        VendorConversationMode.toParticipant =>
          'Ce participant n\'a pas d\'interaction avec votre organisation.',
        VendorConversationMode.toPartner => 'Ce partenariat n\'est pas accepté.',
        _ => 'Accès refusé.',
      };

  String get _title => switch (widget.mode) {
        VendorConversationMode.toParticipant => 'Contacter un participant',
        VendorConversationMode.toPartner => 'Contacter un partenaire',
        VendorConversationMode.supportThread => 'Ticket support',
      };

  // ── Build ─────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.mode == VendorConversationMode.toParticipant) ...[
              _buildParticipantSelector(),
              const SizedBox(height: 16),
            ],
            if (widget.mode == VendorConversationMode.toPartner) ...[
              _buildPartnerSelector(),
              const SizedBox(height: 16),
            ],
            TextField(
              controller: _subjectController,
              maxLength: 100,
              decoration: InputDecoration(
                labelText: widget.mode == VendorConversationMode.supportThread
                    ? 'Sujet (optionnel)'
                    : 'Sujet *',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _messageController,
              maxLines: 5,
              maxLength: 2000,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Message *',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 8),
            _buildAttachmentsSection(),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitting ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: _submitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Envoyer'),
            ),
          ],
        ),
      ),
    );
  }

  // ── Selector widgets ──────────────────────────────────────────────────────────

  Widget _buildParticipantSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Participant *',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        const SizedBox(height: 8),
        if (_selectedParticipant != null)
          _SelectedCard(
            avatarUrl: _selectedParticipant!.avatarUrl,
            name: _selectedParticipant!.name,
            subtitle: _selectedParticipant!.email,
            onClear: () => setState(() => _selectedParticipant = null),
          )
        else
          _SearchTapField(
            hint: 'Rechercher un participant…',
            icon: Icons.person_search_outlined,
            onTap: _openParticipantSearch,
          ),
      ],
    );
  }

  Widget _buildPartnerSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Partenaire *',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        const SizedBox(height: 8),
        if (_selectedPartner != null)
          _SelectedCard(
            avatarUrl: _selectedPartner!.logoUrl ?? _selectedPartner!.avatarUrl,
            name: _selectedPartner!.companyName,
            onClear: () => setState(() => _selectedPartner = null),
          )
        else
          _loadingPartners
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: CircularProgressIndicator(),
                  ),
                )
              : _SearchTapField(
                  hint: 'Rechercher un partenaire…',
                  icon: Icons.handshake_outlined,
                  onTap: _openPartnerSearch,
                ),
      ],
    );
  }

  Widget _buildAttachmentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Pièces jointes',
              style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 6),
            Text('(max 3 • 5 Mo)',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
            const Spacer(),
            if (_attachments.length < _maxFiles)
              TextButton.icon(
                onPressed: _pickAttachment,
                icon: const Icon(Icons.attach_file, size: 16),
                label: const Text('Ajouter', style: TextStyle(fontSize: 13)),
                style: TextButton.styleFrom(foregroundColor: _primaryColor),
              ),
          ],
        ),
        if (_attachments.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: _attachments.map((f) {
              final isPdf = f.name.toLowerCase().endsWith('.pdf');
              return Chip(
                avatar: Icon(
                  isPdf ? Icons.picture_as_pdf : Icons.image_outlined,
                  size: 14,
                  color: isPdf ? Colors.red.shade400 : Colors.blue.shade400,
                ),
                label: Text(f.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11)),
                deleteIcon: const Icon(Icons.close, size: 14),
                onDeleted: () => setState(() => _attachments.remove(f)),
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared selector UI
// ─────────────────────────────────────────────────────────────────────────────

class _SearchTapField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final VoidCallback onTap;

  static const _primaryColor = Color(0xFFFF601F);

  const _SearchTapField({
    required this.hint,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Icon(Icons.search, size: 20, color: Colors.grey.shade500),
            const SizedBox(width: 10),
            Expanded(
              child: Text(hint,
                  style:
                      TextStyle(color: Colors.grey.shade500, fontSize: 15)),
            ),
            Icon(icon, size: 18, color: _primaryColor),
          ],
        ),
      ),
    );
  }
}

class _SelectedCard extends StatelessWidget {
  final String? avatarUrl;
  final String name;
  final String? subtitle;
  final VoidCallback onClear;

  static const _primaryColor = Color(0xFFFF601F);

  const _SelectedCard({
    required this.avatarUrl,
    required this.name,
    this.subtitle,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    final hasUrl = avatarUrl != null && avatarUrl!.isNotEmpty;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
      decoration: BoxDecoration(
        border: Border.all(color: _primaryColor.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(8),
        color: _primaryColor.withValues(alpha: 0.03),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: _primaryColor.withValues(alpha: 0.12),
            backgroundImage:
                hasUrl ? CachedNetworkImageProvider(avatarUrl!) : null,
            child: hasUrl
                ? null
                : Text(initial,
                    style: const TextStyle(
                        color: _primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                if (subtitle != null)
                  Text(subtitle!,
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            color: Colors.grey,
            onPressed: onClear,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Participant search bottom sheet
// ─────────────────────────────────────────────────────────────────────────────

class _ParticipantSearchSheet extends StatefulWidget {
  final MessagesRepository repo;

  const _ParticipantSearchSheet({required this.repo});

  @override
  State<_ParticipantSearchSheet> createState() =>
      _ParticipantSearchSheetState();
}

class _ParticipantSearchSheetState extends State<_ParticipantSearchSheet> {
  static const _primaryColor = Color(0xFFFF601F);

  final _ctrl = TextEditingController();
  Timer? _debounce;
  List<ConversationParticipant> _results = [];
  bool _loading = false;
  bool _searched = false;

  @override
  void initState() {
    super.initState();
    _loadInitial();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _loadInitial() async {
    setState(() => _loading = true);
    try {
      final results = await widget.repo.getInteractedParticipants(search: '');
      if (!mounted) return;
      setState(() {
        _results = results;
        _loading = false;
        _searched = true;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    if (value.trim().isEmpty) {
      _loadInitial();
      return;
    }
    setState(() => _loading = true);
    _debounce = Timer(
      const Duration(milliseconds: 300),
      () => _search(value.trim()),
    );
  }

  Future<void> _search(String query) async {
    try {
      final results =
          await widget.repo.getInteractedParticipants(search: query);
      if (!mounted) return;
      setState(() {
        _results = results;
        _loading = false;
        _searched = true;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _searched = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, scrollCtrl) => Column(
        children: [
          _dragHandle(),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 4),
            child: Text('Rechercher un participant',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Text(
              'Seuls les participants ayant interagi avec votre organisation.',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: _searchField(onChanged: _onChanged),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _results.isEmpty
                    ? _emptyState(
                        icon: Icons.person_search,
                        label: !_searched
                            ? 'Chargement…'
                            : 'Aucun résultat',
                      )
                    : ListView.builder(
                        controller: scrollCtrl,
                        itemCount: _results.length,
                        itemBuilder: (ctx, i) {
                          final p = _results[i];
                          final hasUrl = p.avatarUrl != null &&
                              p.avatarUrl!.isNotEmpty;
                          final initial = p.name.isNotEmpty
                              ? p.name[0].toUpperCase()
                              : '?';
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  _primaryColor.withValues(alpha: 0.1),
                              backgroundImage: hasUrl
                                  ? CachedNetworkImageProvider(p.avatarUrl!)
                                  : null,
                              child: hasUrl
                                  ? null
                                  : Text(initial,
                                      style: const TextStyle(
                                          color: _primaryColor,
                                          fontWeight: FontWeight.bold)),
                            ),
                            title: Text(p.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500)),
                            subtitle: Text(p.email,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600)),
                            onTap: () => Navigator.pop(ctx, p),
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
// Partner search bottom sheet (client-side filter over pre-loaded list)
// ─────────────────────────────────────────────────────────────────────────────

class _PartnerSearchSheet extends StatefulWidget {
  final List<AcceptedPartner> partners;

  const _PartnerSearchSheet({required this.partners});

  @override
  State<_PartnerSearchSheet> createState() => _PartnerSearchSheetState();
}

class _PartnerSearchSheetState extends State<_PartnerSearchSheet> {
  static const _primaryColor = Color(0xFFFF601F);

  String _query = '';
  List<AcceptedPartner> get _filtered => _query.isEmpty
      ? widget.partners
      : widget.partners
          .where((p) =>
              p.companyName.toLowerCase().contains(_query.toLowerCase()) ||
              p.organizationName.toLowerCase().contains(_query.toLowerCase()))
          .toList();

  @override
  Widget build(BuildContext context) {
    final results = _filtered;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, scrollCtrl) => Column(
        children: [
          _dragHandle(),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Text('Rechercher un partenaire',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: _searchField(
              onChanged: (v) => setState(() => _query = v.trim()),
            ),
          ),
          Expanded(
            child: results.isEmpty
                ? _emptyState(
                    icon: Icons.handshake_outlined,
                    label: widget.partners.isEmpty
                        ? 'Aucun partenaire accepté'
                        : 'Aucun résultat',
                  )
                : ListView.builder(
                    controller: scrollCtrl,
                    itemCount: results.length,
                    itemBuilder: (ctx, i) {
                      final p = results[i];
                      final url = p.logoUrl ?? p.avatarUrl;
                      final hasUrl = url != null && url.isNotEmpty;
                      final initial = p.companyName.isNotEmpty
                          ? p.companyName[0].toUpperCase()
                          : '?';
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              _primaryColor.withValues(alpha: 0.1),
                          backgroundImage: hasUrl
                              ? CachedNetworkImageProvider(url)
                              : null,
                          child: hasUrl
                              ? null
                              : Text(initial,
                                  style: const TextStyle(
                                      color: _primaryColor,
                                      fontWeight: FontWeight.bold)),
                        ),
                        title: Text(p.companyName,
                            style:
                                const TextStyle(fontWeight: FontWeight.w500)),
                        subtitle: p.organizationName != p.companyName
                            ? Text(p.organizationName,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600))
                            : null,
                        onTap: () => Navigator.pop(ctx, p),
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
// Shared sheet helpers
// ─────────────────────────────────────────────────────────────────────────────

Widget _dragHandle() => Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          width: 36,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );

Widget _searchField({required void Function(String) onChanged}) {
  return TextField(
    autofocus: true,
    onChanged: onChanged,
    decoration: InputDecoration(
      hintText: 'Rechercher…',
      prefixIcon: const Icon(Icons.search, size: 20),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 10),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: Color(0xFFFF601F)),
      ),
    ),
  );
}

Widget _emptyState({required IconData icon, required String label}) => Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 52, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(label,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
        ],
      ),
    );
