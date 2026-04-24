import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/conversation.dart';
import '../../data/repositories/messages_repository_impl.dart';

class NewConversationScreen extends ConsumerStatefulWidget {
  final String? fromBookingUuid;
  final String? fromOrganizationUuid;

  const NewConversationScreen({
    super.key,
    this.fromBookingUuid,
    this.fromOrganizationUuid,
  });

  @override
  ConsumerState<NewConversationScreen> createState() =>
      _NewConversationScreenState();
}

class _NewConversationScreenState extends ConsumerState<NewConversationScreen> {
  static const _primaryColor = Color(0xFFFF601F);

  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  String? _errorMessage;

  // Org selected from picker or pre-filled
  ConversationOrganization? _selectedOrg;

  @override
  void initState() {
    super.initState();
    if (widget.fromBookingUuid != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _createFromBooking();
      });
    } else if (widget.fromOrganizationUuid != null) {
      _loadOrgForUuid(widget.fromOrganizationUuid!);
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _createFromBooking() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final repo = ref.read(messagesRepositoryProvider);
      final result = await repo.createFromBooking(widget.fromBookingUuid!);
      if (!mounted) return;
      context.go('/messages/${result.conversation.uuid}');
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _loadOrgForUuid(String orgUuid) async {
    try {
      final repo = ref.read(messagesRepositoryProvider);
      final orgs = await repo.getContactableOrganizations();
      final match = orgs.where((o) => o.uuid == orgUuid).firstOrNull;
      if (mounted && match != null) {
        setState(() => _selectedOrg = match);
      }
    } catch (_) {
      // Non-critical: form still usable without pre-fill
    }
  }

  Future<void> _openOrgPicker() async {
    setState(() => _isLoading = true);
    try {
      final repo = ref.read(messagesRepositoryProvider);
      final orgs = await repo.getContactableOrganizations();
      if (!mounted) return;
      setState(() => _isLoading = false);

      final picked = await showModalBottomSheet<ConversationOrganization>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (ctx) => DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.3,
          expand: false,
          builder: (ctx, scrollCtrl) => Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Choisir un organisateur',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const Divider(height: 1),
              Expanded(
                child: orgs.isEmpty
                    ? const Center(
                        child: Text(
                            'Aucun organisateur disponible.',
                            style: TextStyle(color: Colors.grey)),
                      )
                    : ListView.builder(
                        controller: scrollCtrl,
                        itemCount: orgs.length,
                        itemBuilder: (_, i) {
                          final org = orgs[i];
                          return ListTile(
                            title: Text(org.companyName),
                            subtitle: Text(org.organizationName),
                            leading: CircleAvatar(
                              backgroundColor: _primaryColor,
                              child: Text(
                                org.companyName.isNotEmpty
                                    ? org.companyName[0].toUpperCase()
                                    : '?',
                                style:
                                    const TextStyle(color: Colors.white),
                              ),
                            ),
                            onTap: () => Navigator.pop(ctx, org),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      );

      if (picked != null && mounted) {
        setState(() => _selectedOrg = picked);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_selectedOrg == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner un organisateur.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final repo = ref.read(messagesRepositoryProvider);
      final conversation = await repo.createConversation(
        organizationUuid: _selectedOrg!.uuid,
        subject: _subjectController.text.trim(),
        message: _messageController.text.trim(),
      );
      if (!mounted) return;
      context.go('/messages/${conversation.uuid}');
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // fromBookingUuid mode: show loading/error only
    if (widget.fromBookingUuid != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Nouveau message')),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline,
                          color: Colors.red, size: 48),
                      const SizedBox(height: 12),
                      Text(
                        _errorMessage ?? 'Une erreur est survenue.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _createFromBooking,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryColor),
                        child: const Text('Réessayer',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Nouveau message')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Org selector
                    GestureDetector(
                      onTap: widget.fromOrganizationUuid == null
                          ? _openOrgPicker
                          : null,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Organisateur',
                          border: const OutlineInputBorder(),
                          suffixIcon: widget.fromOrganizationUuid == null
                              ? const Icon(Icons.arrow_drop_down)
                              : null,
                        ),
                        child: Text(
                          _selectedOrg?.companyName ??
                              'Sélectionner un organisateur…',
                          style: TextStyle(
                            color: _selectedOrg != null
                                ? Colors.black87
                                : Colors.grey.shade500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _subjectController,
                      decoration: const InputDecoration(
                        labelText: 'Sujet',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Veuillez saisir un sujet.'
                          : null,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        labelText: 'Message',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 6,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Veuillez saisir un message.'
                          : null,
                    ),
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Envoyer',
                          style: TextStyle(
                              color: Colors.white, fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
