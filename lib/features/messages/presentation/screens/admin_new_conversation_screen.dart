import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/datasources/messages_api_datasource.dart';
import '../../data/repositories/messages_repository_impl.dart';

enum AdminConversationMode { toUser, toOrganizer }

// Local DTOs — results of admin search
class _AdminOrg {
  final int id;
  final String uuid;
  final String name;
  final String? logoUrl;

  const _AdminOrg({
    required this.id,
    required this.uuid,
    required this.name,
    this.logoUrl,
  });

  factory _AdminOrg.fromJson(Map<String, dynamic> json) {
    return _AdminOrg(
      id: int.tryParse(json['id'].toString()) ?? 0,
      uuid: json['uuid'] as String? ?? '',
      name: json['company_name'] as String? ?? json['name'] as String? ?? '',
      logoUrl: json['logo_url'] as String? ?? json['logoUrl'] as String?,
    );
  }
}

class _AdminUser {
  final int id;
  final String uuid;
  final String name;
  final String email;
  final String? avatarUrl;

  const _AdminUser({
    required this.id,
    required this.uuid,
    required this.name,
    required this.email,
    this.avatarUrl,
  });

  factory _AdminUser.fromJson(Map<String, dynamic> json) {
    final firstName = json['first_name'] as String? ?? '';
    final lastName = json['last_name'] as String? ?? '';
    final fullName = json['name'] as String? ??
        ('$firstName $lastName'.trim().isEmpty
            ? ''
            : '$firstName $lastName'.trim());
    return _AdminUser(
      id: int.tryParse(json['id'].toString()) ?? 0,
      uuid: json['uuid'] as String? ?? '',
      name: fullName,
      email: json['email'] as String? ?? '',
      avatarUrl: json['avatar_url'] as String? ?? json['avatarUrl'] as String?,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class AdminNewConversationScreen extends ConsumerStatefulWidget {
  final AdminConversationMode mode;

  const AdminNewConversationScreen({super.key, required this.mode});

  @override
  ConsumerState<AdminNewConversationScreen> createState() =>
      _AdminNewConversationScreenState();
}

class _AdminNewConversationScreenState
    extends ConsumerState<AdminNewConversationScreen> {
  static const _primaryColor = Color(0xFFFF601F);
  static const _maxFiles = 3;
  static const _maxFileBytes = 5 * 1024 * 1024;
  static const _allowedExtensions = ['jpg', 'jpeg', 'png', 'webp', 'pdf'];

  _AdminUser? _selectedUser;
  _AdminOrg? _selectedOrg;

  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  final List<XFile> _attachments = [];

  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  String get _title => switch (widget.mode) {
        AdminConversationMode.toUser => 'Contacter un utilisateur',
        AdminConversationMode.toOrganizer => 'Contacter un organisateur',
      };

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

  Future<void> _openUserSearch() async {
    final selected = await showModalBottomSheet<_AdminUser>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _UserSearchSheet(
        datasource: ref.read(messagesApiDataSourceProvider),
      ),
    );
    if (selected != null) setState(() => _selectedUser = selected);
  }

  Future<void> _openOrgSearch() async {
    final selected = await showModalBottomSheet<_AdminOrg>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _OrgSearchSheet(
        datasource: ref.read(messagesApiDataSourceProvider),
      ),
    );
    if (selected != null) setState(() => _selectedOrg = selected);
  }

  // ── Submit ────────────────────────────────────────────────────────────────────

  Future<void> _submit() async {
    setState(() => _error = null);

    if (widget.mode == AdminConversationMode.toUser && _selectedUser == null) {
      setState(() => _error = 'Veuillez sélectionner un utilisateur.');
      return;
    }
    if (widget.mode == AdminConversationMode.toOrganizer &&
        _selectedOrg == null) {
      setState(() => _error = 'Veuillez sélectionner une organisation.');
      return;
    }

    setState(() => _submitting = true);

    try {
      final repo = ref.read(messagesRepositoryProvider);
      final subject = _subjectController.text.trim();
      final message = _messageController.text.trim();
      final files = _attachments.isNotEmpty ? _attachments : null;
      late final String convUuid;

      switch (widget.mode) {
        case AdminConversationMode.toUser:
          final conv = await repo.createAdminUserThread(
            userId: _selectedUser!.id,
            subject: subject.isEmpty ? null : subject,
            message: message.isEmpty ? null : message,
            attachments: files,
          );
          convUuid = conv.uuid;

        case AdminConversationMode.toOrganizer:
          final conv = await repo.createAdminSupportThread(
            organizationUuid: _selectedOrg!.uuid,
            subject: subject.isEmpty ? null : subject,
            message: message.isEmpty ? null : message,
            attachments: files,
          );
          convUuid = conv.uuid;
      }

      if (mounted) context.pushReplacement('/messages/admin/$convUuid');
    } catch (e) {
      if (mounted) {
        setState(() {
          _submitting = false;
          _error = 'Erreur : $e';
        });
      }
    }
  }

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
            if (widget.mode == AdminConversationMode.toUser) ...[
              _buildUserSelector(),
              const SizedBox(height: 16),
            ],
            if (widget.mode == AdminConversationMode.toOrganizer) ...[
              _buildOrgSelector(),
              const SizedBox(height: 16),
            ],
            TextField(
              controller: _subjectController,
              maxLength: 100,
              decoration: const InputDecoration(
                labelText: 'Sujet (optionnel)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _messageController,
              maxLines: 5,
              maxLength: 2000,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Message (optionnel)',
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
                  : const Text('Créer la conversation'),
            ),
          ],
        ),
      ),
    );
  }

  // ── Selector widgets ──────────────────────────────────────────────────────────

  Widget _buildUserSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Destinataire *',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        const SizedBox(height: 8),
        if (_selectedUser != null)
          _SelectedCard(
            avatarUrl: _selectedUser!.avatarUrl,
            name: _selectedUser!.name,
            subtitle: _selectedUser!.email,
            onClear: () => setState(() => _selectedUser = null),
          )
        else
          _SearchTapField(
            hint: 'Rechercher un utilisateur…',
            icon: Icons.person_search_outlined,
            onTap: _openUserSearch,
          ),
      ],
    );
  }

  Widget _buildOrgSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Organisation *',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        const SizedBox(height: 8),
        if (_selectedOrg != null)
          _SelectedCard(
            avatarUrl: _selectedOrg!.logoUrl,
            name: _selectedOrg!.name,
            onClear: () => setState(() => _selectedOrg = null),
          )
        else
          _SearchTapField(
            hint: 'Rechercher une organisation…',
            icon: Icons.business_outlined,
            onTap: _openOrgSearch,
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
// Shared selector UI components
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
                  style: TextStyle(
                      color: Colors.grey.shade500, fontSize: 15)),
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
// User search bottom sheet
// ─────────────────────────────────────────────────────────────────────────────

class _UserSearchSheet extends StatefulWidget {
  final MessagesApiDataSource datasource;

  const _UserSearchSheet({required this.datasource});

  @override
  State<_UserSearchSheet> createState() => _UserSearchSheetState();
}

class _UserSearchSheetState extends State<_UserSearchSheet> {
  static const _primaryColor = Color(0xFFFF601F);

  final _ctrl = TextEditingController();
  Timer? _debounce;
  List<_AdminUser> _results = [];
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
      final raw = await widget.datasource.searchAdminUsers(search: '');
      if (!mounted) return;
      setState(() {
        _results = raw.map(_AdminUser.fromJson).toList();
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
      final raw = await widget.datasource.searchAdminUsers(search: query);
      if (!mounted) return;
      setState(() {
        _results = raw.map(_AdminUser.fromJson).toList();
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
            padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Text('Rechercher un utilisateur',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
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
                          final user = _results[i];
                          final hasUrl = user.avatarUrl != null &&
                              user.avatarUrl!.isNotEmpty;
                          final initial = user.name.isNotEmpty
                              ? user.name[0].toUpperCase()
                              : '?';
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  _primaryColor.withValues(alpha: 0.1),
                              backgroundImage: hasUrl
                                  ? CachedNetworkImageProvider(user.avatarUrl!)
                                  : null,
                              child: hasUrl
                                  ? null
                                  : Text(initial,
                                      style: const TextStyle(
                                          color: _primaryColor,
                                          fontWeight: FontWeight.bold)),
                            ),
                            title: Text(user.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500)),
                            subtitle: Text(user.email,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600)),
                            trailing: Text('#${user.id}',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade400)),
                            onTap: () => Navigator.pop(ctx, user),
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
// Organisation search bottom sheet
// ─────────────────────────────────────────────────────────────────────────────

class _OrgSearchSheet extends StatefulWidget {
  final MessagesApiDataSource datasource;

  const _OrgSearchSheet({required this.datasource});

  @override
  State<_OrgSearchSheet> createState() => _OrgSearchSheetState();
}

class _OrgSearchSheetState extends State<_OrgSearchSheet> {
  static const _primaryColor = Color(0xFFFF601F);

  final _ctrl = TextEditingController();
  Timer? _debounce;
  List<_AdminOrg> _results = [];
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
      final raw =
          await widget.datasource.searchAdminOrganizations(search: '');
      if (!mounted) return;
      setState(() {
        _results = raw.map(_AdminOrg.fromJson).toList();
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
      final raw =
          await widget.datasource.searchAdminOrganizations(search: query);
      if (!mounted) return;
      setState(() {
        _results = raw.map(_AdminOrg.fromJson).toList();
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
            padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Text('Rechercher une organisation',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: _searchField(onChanged: _onChanged),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _results.isEmpty
                    ? _emptyState(
                        icon: Icons.business_outlined,
                        label: !_searched ? 'Chargement…' : 'Aucun résultat',
                      )
                    : ListView.builder(
                        controller: scrollCtrl,
                        itemCount: _results.length,
                        itemBuilder: (ctx, i) {
                          final org = _results[i];
                          final url = org.logoUrl;
                          final hasUrl = url != null && url.isNotEmpty;
                          final initial = org.name.isNotEmpty
                              ? org.name[0].toUpperCase()
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
                            title: Text(org.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500)),
                            trailing: Text('#${org.id}',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade400)),
                            onTap: () => Navigator.pop(ctx, org),
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
