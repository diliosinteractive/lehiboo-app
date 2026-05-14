import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/utils/api_response_handler.dart';
import '../../data/datasources/messages_api_datasource.dart';
import '../../data/repositories/messages_repository_impl.dart';
import '../../domain/entities/accepted_partner.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/repositories/messages_repository.dart';
import '../providers/admin_conversations_provider.dart';
import '../providers/conversations_provider.dart';
import '../providers/support_conversations_provider.dart';
import '../providers/vendor_conversations_provider.dart';
import '../providers/vendor_org_conversations_provider.dart';

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

/// Admin contacts any user (live API search)
class AdminToUserConversationContext extends NewConversationContext {}

/// Admin contacts any org/vendor (live API search)
class AdminToOrgConversationContext extends NewConversationContext {}

/// Vendor contacts a participant who has interacted with their org (live API search)
class VendorToParticipantConversationContext extends NewConversationContext {}

/// Vendor contacts an accepted partner org (pre-loaded list, client-side filter)
class VendorToPartnerConversationContext extends NewConversationContext {}

/// Vendor opens a support ticket with LeHiboo (fixed recipient, subject optional)
class VendorSupportConversationContext extends NewConversationContext {}

enum _SupportSubject {
  bookingIssue,
  eventQuestion,
  paymentIssue,
  refundRequest,
  accountIssue,
  contentReport,
  other,
}

// ── Helpers for parsing raw admin search JSON into domain entities ──────────

ConversationParticipant _participantFromJson(Map<String, dynamic> json) {
  final firstName =
      json['first_name'] as String? ?? json['firstName'] as String? ?? '';
  final lastName =
      json['last_name'] as String? ?? json['lastName'] as String? ?? '';
  return ConversationParticipant(
    id: int.tryParse(json['id'].toString()) ?? 0,
    name: json['name'] as String? ?? '$firstName $lastName'.trim(),
    email: json['email'] as String? ?? '',
    avatarUrl: json['avatar_url'] as String? ?? json['avatarUrl'] as String?,
  );
}

ConversationOrganization _orgFromJson(Map<String, dynamic> json) {
  final name = json['company_name'] as String? ?? json['name'] as String? ?? '';
  return ConversationOrganization(
    id: int.tryParse(json['id'].toString()) ?? 0,
    uuid: json['uuid'] as String? ?? '',
    companyName: name,
    organizationName: json['organization_name'] as String? ?? name,
    logoUrl: json['logo_url'] as String? ?? json['logoUrl'] as String?,
    avatarUrl: json['avatar_url'] as String? ?? json['avatarUrl'] as String?,
  );
}

// ── Widget ──────────────────────────────────────────────────────────────────

class NewConversationForm extends ConsumerStatefulWidget {
  final NewConversationContext conversationContext;

  const NewConversationForm({super.key, required this.conversationContext});

  /// Present as a modal bottom sheet from any BuildContext.
  /// Returns true if a conversation was successfully created, null if cancelled.
  static Future<bool?> show(
    BuildContext context, {
    required NewConversationContext conversationContext,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      // Keyboard insets MUST be read from the builder's ctx, not from the
      // form widget's own context. Using the form's context can lag or miss
      // updates, leaving the action bar hidden behind the keyboard.
      builder: (ctx) => AnimatedPadding(
        duration: const Duration(milliseconds: 130),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(ctx).bottom,
        ),
        child: NewConversationForm(conversationContext: conversationContext),
      ),
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

  // Existing fields
  ConversationOrganization? _selectedOrg;
  String? _eventId;
  String? _eventTitle;
  final _subjectCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  _SupportSubject? _selectedSupportSubject;
  bool _orgError = false;
  bool _isLoading = false;
  String? _submitError;
  bool _submitted = false;

  // Admin recipient
  ConversationParticipant? _selectedAdminUser;
  ConversationOrganization? _selectedAdminOrg;
  // Vendor recipient
  ConversationParticipant? _selectedVendorParticipant;
  AcceptedPartner? _selectedPartner;
  List<AcceptedPartner> _allPartners = [];
  // Shared error flag for new contexts
  bool _recipientError = false;

  // Contactable orgs for DashboardContext (loaded eagerly)
  List<ConversationOrganization>? _contactableOrgs;
  bool _orgsLoading = false;

  // Existing getters
  bool get _isSupport =>
      widget.conversationContext is SupportConversationContext;
  bool get _isDashboard =>
      widget.conversationContext is DashboardConversationContext;
  bool get _isFromOrg =>
      widget.conversationContext is FromOrganizerConversationContext;

  // New getters
  bool get _isAdminToUser =>
      widget.conversationContext is AdminToUserConversationContext;
  bool get _isAdminToOrg =>
      widget.conversationContext is AdminToOrgConversationContext;
  bool get _isVendorToParticipant =>
      widget.conversationContext is VendorToParticipantConversationContext;
  bool get _isVendorToPartner =>
      widget.conversationContext is VendorToPartnerConversationContext;
  bool get _isVendorSupport =>
      widget.conversationContext is VendorSupportConversationContext;

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

    if (widget.conversationContext is VendorToPartnerConversationContext) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        try {
          final partners = await ref
              .read(messagesRepositoryImplProvider)
              .getAcceptedPartners();
          if (mounted) setState(() => _allPartners = partners);
        } catch (_) {}
      });
    }
    if (widget.conversationContext is DashboardConversationContext) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _loadContactableOrgs());
    }
  }

  Future<void> _loadContactableOrgs() async {
    setState(() => _orgsLoading = true);
    try {
      final orgs = await ref
          .read(messagesRepositoryImplProvider)
          .getContactableOrganizations();
      if (mounted) {
        setState(() {
          _contactableOrgs = orgs;
          _orgsLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _contactableOrgs = [];
          _orgsLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _subjectCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  // ── Derived ────────────────────────────────────────────────────────────────

  String _subtitle(BuildContext context) {
    if (_isSupport || _isVendorSupport) {
      return context.l10n.messagesNewConversationSubtitleSupport;
    }
    if (_isAdminToUser ||
        _isAdminToOrg ||
        _isVendorToParticipant ||
        _isVendorToPartner) {
      return context.l10n.messagesNewConversationSubtitleRecipient;
    }
    return context.l10n.messagesNewConversationSubtitleDefault;
  }

  List<({String label, _SupportSubject subject})> _supportSubjectOptions(
    BuildContext context,
  ) {
    final l10n = context.l10n;
    return [
      (
        subject: _SupportSubject.bookingIssue,
        label: l10n.messagesSupportSubjectBookingIssue,
      ),
      (
        subject: _SupportSubject.eventQuestion,
        label: l10n.messagesSupportSubjectEventQuestion,
      ),
      (
        subject: _SupportSubject.paymentIssue,
        label: l10n.messagesSupportSubjectPaymentIssue,
      ),
      (
        subject: _SupportSubject.refundRequest,
        label: l10n.messagesSupportSubjectRefundRequest,
      ),
      (
        subject: _SupportSubject.accountIssue,
        label: l10n.messagesSupportSubjectAccountIssue,
      ),
      (
        subject: _SupportSubject.contentReport,
        label: l10n.messagesSupportSubjectContentReport,
      ),
      (subject: _SupportSubject.other, label: l10n.messagesReasonOther),
    ];
  }

  bool _validate() {
    final orgMissing = _isDashboard && _selectedOrg == null;
    final recipientMissing = (_isAdminToUser && _selectedAdminUser == null) ||
        (_isAdminToOrg && _selectedAdminOrg == null) ||
        (_isVendorToParticipant && _selectedVendorParticipant == null) ||
        (_isVendorToPartner && _selectedPartner == null);
    final subjectMissing =
        !_isVendorSupport && _subjectCtrl.text.trim().isEmpty;
    final messageMissing = _messageCtrl.text.trim().isEmpty;
    setState(() {
      _submitted = true;
      _orgError = orgMissing;
      _recipientError = recipientMissing;
    });
    return !orgMissing &&
        !recipientMissing &&
        !subjectMissing &&
        !messageMissing;
  }

  // ── Org picker (DashboardContext only) ─────────────────────────────────────

  Future<void> _openOrgPicker() async {
    final orgs = _contactableOrgs;
    if (orgs == null || orgs.isEmpty) return;
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
  }

  // ── Admin/Vendor search openers ────────────────────────────────────────────

  Future<void> _openAdminUserSearch() async {
    final ds = ref.read(messagesApiDataSourceProvider);
    final selected = await showModalBottomSheet<ConversationParticipant>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _AdminUserSearchSheet(datasource: ds),
    );
    if (selected != null && mounted) {
      setState(() {
        _selectedAdminUser = selected;
        _recipientError = false;
      });
    }
  }

  Future<void> _openAdminOrgSearch() async {
    final ds = ref.read(messagesApiDataSourceProvider);
    final selected = await showModalBottomSheet<ConversationOrganization>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _AdminOrgSearchSheet(datasource: ds),
    );
    if (selected != null && mounted) {
      setState(() {
        _selectedAdminOrg = selected;
        _recipientError = false;
      });
    }
  }

  Future<void> _openVendorParticipantSearch() async {
    final repo = ref.read(messagesRepositoryImplProvider);
    final selected = await showModalBottomSheet<ConversationParticipant>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _VendorParticipantSearchSheet(repo: repo),
    );
    if (selected != null && mounted) {
      setState(() {
        _selectedVendorParticipant = selected;
        _recipientError = false;
      });
    }
  }

  Future<void> _openVendorPartnerSearch() async {
    final selected = await showModalBottomSheet<AcceptedPartner>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _VendorPartnerSearchSheet(partners: _allPartners),
    );
    if (selected != null && mounted) {
      setState(() {
        _selectedPartner = selected;
        _recipientError = false;
      });
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
      final ctx = widget.conversationContext;

      String uuid;
      String route;

      if (ctx is DashboardConversationContext) {
        final conv = await repo.createConversation(
          organizationUuid: _selectedOrg!.uuid,
          subject: subject,
          message: message,
        );
        uuid = conv.uuid;
        route = '/messages/$uuid';
      } else if (ctx is FromOrganizerConversationContext) {
        final conv = await repo.createFromOrganization(
          organizationUuid: ctx.organizationUuid,
          subject: subject,
          message: message,
          eventId: _eventId,
        );
        uuid = conv.uuid;
        route = '/messages/$uuid';
      } else if (_isAdminToUser) {
        final conv = await repo.createAdminUserThread(
          userId: _selectedAdminUser!.id,
          subject: subject.isEmpty ? null : subject,
          message: message.isEmpty ? null : message,
        );
        uuid = conv.uuid;
        route = '/messages/admin/${conv.uuid}';
      } else if (_isAdminToOrg) {
        final conv = await repo.createAdminSupportThread(
          organizationUuid: _selectedAdminOrg!.uuid,
          subject: subject.isEmpty ? null : subject,
          message: message.isEmpty ? null : message,
        );
        uuid = conv.uuid;
        route = '/messages/admin/${conv.uuid}';
      } else if (_isVendorToParticipant) {
        final conv = await repo.createVendorConversationToParticipant(
          participantId: _selectedVendorParticipant!.id,
          subject: subject,
          message: message,
        );
        uuid = conv.uuid;
        route = '/messages/vendor/${conv.uuid}';
      } else if (_isVendorToPartner) {
        final conv = await repo.createOrgConversation(
          partnerOrganizationId: _selectedPartner!.id,
          subject: subject,
          message: message,
        );
        uuid = conv.uuid;
        route = '/messages/vendor-org/${conv.uuid}';
      } else if (_isVendorSupport) {
        final conv = await repo.createVendorSupportThread(
          subject: subject.isEmpty ? context.l10n.messagesTabSupport : subject,
          message: message,
        );
        uuid = conv.uuid;
        route = '/messages/vendor/${conv.uuid}';
      } else {
        // SupportConversationContext (fallback)
        final conv = await repo.createSupportConversation(
          subject: subject,
          message: message,
        );
        uuid = conv.uuid;
        route = '/messages/support/$uuid';
      }

      if (!mounted) return;
      // Refresh the relevant list so the newly created conversation appears
      // immediately, regardless of user type (participant / vendor / admin / support).
      // WS event `conversation.created` will also refresh on the recipient side.
      switch (ctx) {
        case SupportConversationContext():
          ref.read(supportConversationsProvider.notifier).refresh();
        case DashboardConversationContext():
        case FromOrganizerConversationContext():
          ref.read(conversationsProvider.notifier).refresh();
        case AdminToUserConversationContext():
          ref
              .read(adminConversationsProvider('user_support').notifier)
              .refresh();
        case AdminToOrgConversationContext():
          ref
              .read(adminConversationsProvider('vendor_admin').notifier)
              .refresh();
        case VendorToParticipantConversationContext():
          ref.read(vendorConversationsProvider.notifier).refresh();
        case VendorToPartnerConversationContext():
          ref.read(vendorOrgConversationsProvider.notifier).refresh();
        case VendorSupportConversationContext():
          ref.read(vendorSupportProvider.notifier).refresh();
      }
      Navigator.of(context).pop(true);
      // Use pushReplacement for contexts that are opened from a dedicated
      // "new conversation" screen (/messages/new, /messages/support/new,
      // /messages/new/from-organizer/…) so pressing back skips the spinner.
      if (ctx is SupportConversationContext ||
          ctx is DashboardConversationContext ||
          ctx is FromOrganizerConversationContext) {
        context.pushReplacement(route);
      } else {
        context.push(route);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _submitError = ApiResponseHandler.extractError(e);
        });
      }
    }
  }

  // ── build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // Simple Column fills the height provided by AnimatedPadding (in show()).
    // DraggableScrollableSheet is not needed — the sheet is always full-height
    // and the keyboard lift is handled at the builder level.
    return Column(
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
                    Text(context.l10n.messagesNewMessage,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text(_subtitle(context),
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey.shade600)),
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
        // Scrollable body — grows to fill remaining space between header and
        // the pinned action bar below.
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
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
                      if (_submitError != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Text(_submitError!,
                              style: TextStyle(
                                  color: Colors.red.shade700, fontSize: 13)),
                        ),
                      ],
                    ],
                  ),
                ),
        ),
        // Pinned action bar — always visible, lifted above the keyboard by
        // the AnimatedPadding wrapping the whole sheet in show().
        if (!_isLoading)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.07),
                  blurRadius: 12,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
            child: _buildActions(),
          ),
      ],
    );
  }

  // ── Section builders ────────────────────────────────────────────────────────

  Widget _buildRecipientSection() {
    final ctx = widget.conversationContext;
    if (ctx is SupportConversationContext) {
      return _buildFixedRecipientCard(
        icon: const Icon(Icons.support_agent, color: Colors.white, size: 20),
        label: context.l10n.messagesTabSupportLeHiboo,
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

    // Admin contexts
    if (_isAdminToUser) {
      return _buildSearchableRecipient(
        label: context.l10n.messagesRecipientLabel,
        selectedAvatarUrl: _selectedAdminUser?.avatarUrl,
        selectedName: _selectedAdminUser?.name,
        selectedSubtitle: _selectedAdminUser?.email,
        hasError: _recipientError,
        placeholder: context.l10n.messagesSearchUserPlaceholder,
        placeholderIcon: Icons.person_search_outlined,
        onTap: _openAdminUserSearch,
        onClear: () => setState(() {
          _selectedAdminUser = null;
          _recipientError = false;
        }),
      );
    }
    if (_isAdminToOrg) {
      return _buildSearchableRecipient(
        label: context.l10n.messagesOrganizationLabel,
        selectedAvatarUrl: _selectedAdminOrg?.logoUrl,
        selectedName: _selectedAdminOrg?.companyName,
        hasError: _recipientError,
        placeholder: context.l10n.messagesSearchOrganizationPlaceholder,
        placeholderIcon: Icons.business_outlined,
        onTap: _openAdminOrgSearch,
        onClear: () => setState(() {
          _selectedAdminOrg = null;
          _recipientError = false;
        }),
      );
    }

    // Vendor contexts
    if (_isVendorToParticipant) {
      return _buildSearchableRecipient(
        label: context.l10n.messagesParticipantLabel,
        selectedAvatarUrl: _selectedVendorParticipant?.avatarUrl,
        selectedName: _selectedVendorParticipant?.name,
        selectedSubtitle: _selectedVendorParticipant?.email,
        hasError: _recipientError,
        placeholder: context.l10n.messagesSearchParticipantPlaceholder,
        placeholderIcon: Icons.person_search_outlined,
        onTap: _openVendorParticipantSearch,
        onClear: () => setState(() {
          _selectedVendorParticipant = null;
          _recipientError = false;
        }),
      );
    }
    if (_isVendorToPartner) {
      return _buildSearchableRecipient(
        label: context.l10n.messagesPartnerLabel,
        selectedAvatarUrl:
            _selectedPartner?.logoUrl ?? _selectedPartner?.avatarUrl,
        selectedName: _selectedPartner?.companyName,
        hasError: _recipientError,
        placeholder: context.l10n.messagesSearchPartnerPlaceholder,
        placeholderIcon: Icons.handshake_outlined,
        onTap: _openVendorPartnerSearch,
        onClear: () => setState(() {
          _selectedPartner = null;
          _recipientError = false;
        }),
      );
    }
    if (_isVendorSupport) {
      return _buildFixedRecipientCard(
        icon: const Icon(Icons.support_agent, color: Colors.white, size: 20),
        label: context.l10n.messagesTabSupportLeHiboo,
        color: _primaryColor,
      );
    }

    // DashboardContext — tappable picker row (greyed out when no orgs available)
    final orgsEmpty =
        !_orgsLoading && _contactableOrgs != null && _contactableOrgs!.isEmpty;
    final pickerEnabled =
        !_orgsLoading && (_contactableOrgs?.isNotEmpty ?? false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel(context.l10n.messagesRecipientLabel, required: true),
        const SizedBox(height: 6),
        InkWell(
          onTap: pickerEnabled ? _openOrgPicker : null,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: orgsEmpty ? Colors.grey.shade100 : null,
              border: Border.all(
                color: _orgError ? Colors.red : Colors.grey.shade300,
                width: _orgError ? 1.5 : 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                if (_selectedOrg != null)
                  () {
                    final url =
                        _selectedOrg!.logoUrl ?? _selectedOrg!.avatarUrl;
                    return CircleAvatar(
                      radius: 14,
                      backgroundColor: _primaryColor.withValues(alpha: 0.15),
                      child: url != null && url.isNotEmpty
                          ? ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: url,
                                width: 28,
                                height: 28,
                                fit: BoxFit.cover,
                                errorWidget: (_, __, ___) => Text(
                                  _selectedOrg!.companyName[0].toUpperCase(),
                                  style: const TextStyle(
                                      color: _primaryColor, fontSize: 12),
                                ),
                              ),
                            )
                          : Text(
                              _selectedOrg!.companyName[0].toUpperCase(),
                              style: const TextStyle(
                                  color: _primaryColor, fontSize: 12),
                            ),
                    );
                  }()
                else
                  Icon(Icons.business_outlined,
                      color: orgsEmpty
                          ? Colors.grey.shade400
                          : Colors.grey.shade500,
                      size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _selectedOrg?.companyName ??
                        (orgsEmpty
                            ? context.l10n.messagesNoOrganizerAvailable
                            : context.l10n.messagesSelectOrganizerPlaceholder),
                    style: TextStyle(
                      color: _selectedOrg != null
                          ? Colors.black87
                          : orgsEmpty
                              ? Colors.grey.shade400
                              : Colors.grey.shade500,
                      fontSize: 14,
                    ),
                  ),
                ),
                if (_orgsLoading)
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.grey.shade400),
                  )
                else
                  Icon(Icons.expand_more,
                      color: orgsEmpty
                          ? Colors.grey.shade300
                          : Colors.grey.shade500),
              ],
            ),
          ),
        ),
        if (orgsEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              context.l10n.messagesOrganizerPickerHelp,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
            ),
          ),
        if (_orgError)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(
              context.l10n.messagesSelectOrganizerRequired,
              style: TextStyle(fontSize: 11, color: Colors.red.shade600),
            ),
          ),
      ],
    );
  }

  Widget _buildSearchableRecipient({
    required String label,
    required String? selectedName,
    String? selectedAvatarUrl,
    String? selectedSubtitle,
    required bool hasError,
    required String placeholder,
    required IconData placeholderIcon,
    required VoidCallback onTap,
    required VoidCallback onClear,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel(label, required: true),
        const SizedBox(height: 6),
        if (selectedName != null)
          Container(
            padding: const EdgeInsets.fromLTRB(14, 10, 8, 10),
            decoration: BoxDecoration(
              color: _primaryColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _primaryColor.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: _primaryColor.withValues(alpha: 0.15),
                  child:
                      selectedAvatarUrl != null && selectedAvatarUrl.isNotEmpty
                          ? ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: selectedAvatarUrl,
                                width: 32,
                                height: 32,
                                fit: BoxFit.cover,
                                errorWidget: (_, __, ___) => Text(
                                  selectedName.isNotEmpty
                                      ? selectedName[0].toUpperCase()
                                      : '?',
                                  style: const TextStyle(
                                      color: _primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13),
                                ),
                              ),
                            )
                          : Text(
                              selectedName.isNotEmpty
                                  ? selectedName[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                  color: _primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13),
                            ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(selectedName,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14)),
                      if (selectedSubtitle != null)
                        Text(selectedSubtitle,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 16),
                  color: Colors.grey,
                  onPressed: onClear,
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          )
        else
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(
                    color: hasError ? Colors.red : Colors.grey.shade300,
                    width: hasError ? 1.5 : 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, size: 20, color: Colors.grey.shade500),
                  const SizedBox(width: 10),
                  Expanded(
                      child: Text(placeholder,
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 14))),
                  Icon(placeholderIcon, size: 18, color: _primaryColor),
                ],
              ),
            ),
          ),
        if (hasError && selectedName == null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(context.l10n.messagesFieldRequired,
                style: TextStyle(fontSize: 11, color: Colors.red.shade600)),
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
        _sectionLabel(context.l10n.messagesRecipientLabel),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                child: avatarUrl != null && avatarUrl.isNotEmpty
                    ? ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: avatarUrl,
                          width: 32,
                          height: 32,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) =>
                              icon ??
                              Text(
                                label.isNotEmpty ? label[0].toUpperCase() : '?',
                                style: TextStyle(
                                    color: color,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
                              ),
                        ),
                      )
                    : (icon ??
                        Text(
                          label.isNotEmpty ? label[0].toUpperCase() : '?',
                          style: TextStyle(
                              color: color,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        )),
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
        Text(context.l10n.messagesEventLabel,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700)),
        const SizedBox(width: 6),
        Text(context.l10n.messagesOptionalLabel,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.fromLTRB(10, 4, 6, 4),
          decoration: BoxDecoration(
            color: _primaryColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _primaryColor.withValues(alpha: 0.3)),
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
                child: const Icon(Icons.close, size: 14, color: _primaryColor),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSupportSubjectChips() {
    final options = _supportSubjectOptions(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.l10n.messagesSupportSubjectPrompt,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: options.map((opt) {
            final selected = _selectedSupportSubject == opt.subject;
            return ChoiceChip(
              label: Text(opt.label,
                  style: TextStyle(
                      fontSize: 12,
                      color: selected ? _primaryColor : Colors.black87)),
              selected: selected,
              onSelected: (_) => setState(() {
                _selectedSupportSubject = opt.subject;
                if (opt.subject != _SupportSubject.other) {
                  _subjectCtrl.text = opt.label;
                } else {
                  _subjectCtrl.clear();
                }
              }),
              selectedColor: _primaryColor.withValues(alpha: 0.12),
              checkmarkColor: _primaryColor,
              side: BorderSide(
                  color: selected ? _primaryColor : Colors.grey.shade300),
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
        _submitted && !_isVendorSupport && _subjectCtrl.text.trim().isEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel(
          context.l10n.messagesSubjectLabel,
          required: !_isVendorSupport,
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _subjectCtrl,
          maxLength: _subjectMax,
          buildCounter: (_,
                  {required currentLength, required isFocused, maxLength}) =>
              null,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            hintText: context.l10n.messagesSubjectHint,
            border: const OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: hasError ? Colors.red : Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: hasError ? Colors.red : _primaryColor, width: 1.5),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (hasError)
              Text(context.l10n.messagesSubjectRequired,
                  style: TextStyle(fontSize: 11, color: Colors.red.shade600))
            else
              const SizedBox.shrink(),
            Text(
              '${_subjectCtrl.text.length}/$_subjectMax',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMessageField() {
    final hasError = _submitted && _messageCtrl.text.trim().isEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel(context.l10n.messagesMessageLabel, required: true),
        const SizedBox(height: 6),
        TextField(
          controller: _messageCtrl,
          maxLines: 5,
          maxLength: _messageMax,
          buildCounter: (_,
                  {required currentLength, required isFocused, maxLength}) =>
              null,
          decoration: InputDecoration(
            hintText: context.l10n.messagesMessageHint,
            alignLabelWithHint: true,
            border: const OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: hasError ? Colors.red : Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: hasError ? Colors.red : _primaryColor, width: 1.5),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (hasError)
              Text(context.l10n.messagesMessageRequired,
                  style: TextStyle(fontSize: 11, color: Colors.red.shade600))
            else
              const SizedBox.shrink(),
            Text(
              '${_messageCtrl.text.length}/$_messageMax',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
            ),
          ],
        ),
      ],
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
            child: Text(context.l10n.commonCancel),
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
                        strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.send_rounded, size: 16, color: Colors.white),
            label: Text(
              context.l10n.messagesSend,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 14),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              context.l10n.messagesChooseOrganizerTitle,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              autofocus: true,
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: context.l10n.messagesSearchByNameHint,
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
                ? Center(
                    child: Text(
                      context.l10n.messagesNoOrganizerAvailable,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  )
                : filtered.isEmpty
                    ? Center(
                        child: Text(
                          context.l10n.messagesNoSearchResults(_query),
                          style: const TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        controller: scrollCtrl,
                        itemCount: filtered.length,
                        itemBuilder: (_, i) {
                          final org = filtered[i];
                          final logoUrl = org.logoUrl ?? org.avatarUrl;
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  _primaryColor.withValues(alpha: 0.15),
                              child: logoUrl != null && logoUrl.isNotEmpty
                                  ? ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: logoUrl,
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                        errorWidget: (_, __, ___) => Text(
                                          org.companyName.isNotEmpty
                                              ? org.companyName[0].toUpperCase()
                                              : '?',
                                          style: const TextStyle(
                                              color: _primaryColor),
                                        ),
                                      ),
                                    )
                                  : Text(
                                      org.companyName.isNotEmpty
                                          ? org.companyName[0].toUpperCase()
                                          : '?',
                                      style:
                                          const TextStyle(color: _primaryColor),
                                    ),
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

// ── Admin user search sheet ────────────────────────────────────────────────────

class _AdminUserSearchSheet extends StatefulWidget {
  final MessagesApiDataSource datasource;
  const _AdminUserSearchSheet({required this.datasource});

  @override
  State<_AdminUserSearchSheet> createState() => _AdminUserSearchSheetState();
}

class _AdminUserSearchSheetState extends State<_AdminUserSearchSheet> {
  static const _primaryColor = Color(0xFFFF601F);
  List<ConversationParticipant> _results = [];
  bool _loading = true;
  String _query = '';
  String? _error;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _search('');
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _search(String q) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final raw = await widget.datasource.searchAdminUsers(search: q);
      if (mounted) {
        setState(() {
          _results = raw.map(_participantFromJson).toList();
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = ApiResponseHandler.extractError(e);
        });
      }
    }
  }

  void _onQueryChanged(String v) {
    _query = v;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () => _search(v));
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      expand: false,
      builder: (_, scrollCtrl) => Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(
              context.l10n.messagesSearchUserTitle,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              autofocus: true,
              onChanged: _onQueryChanged,
              decoration: InputDecoration(
                hintText: context.l10n.messagesUserSearchHint,
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
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          context.l10n.messagesLoadError(_error!),
                          style: TextStyle(
                              color: Colors.red.shade700, fontSize: 12),
                        ),
                      )
                    : _results.isEmpty
                        ? Center(
                            child: Text(
                              _query.isEmpty
                                  ? context.l10n.messagesNoUsersAvailable
                                  : context.l10n
                                      .messagesNoSearchResults(_query),
                              style: const TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            controller: scrollCtrl,
                            itemCount: _results.length,
                            itemBuilder: (_, i) {
                              final user = _results[i];
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor:
                                      _primaryColor.withValues(alpha: 0.15),
                                  child: user.avatarUrl != null &&
                                          user.avatarUrl!.isNotEmpty
                                      ? ClipOval(
                                          child: CachedNetworkImage(
                                            imageUrl: user.avatarUrl!,
                                            width: 40,
                                            height: 40,
                                            fit: BoxFit.cover,
                                            errorWidget: (_, __, ___) => Text(
                                              user.name.isNotEmpty
                                                  ? user.name[0].toUpperCase()
                                                  : '?',
                                              style: const TextStyle(
                                                  color: _primaryColor),
                                            ),
                                          ),
                                        )
                                      : Text(
                                          user.name.isNotEmpty
                                              ? user.name[0].toUpperCase()
                                              : '?',
                                          style: const TextStyle(
                                              color: _primaryColor),
                                        ),
                                ),
                                title: Text(user.name),
                                subtitle: Text(user.email),
                                onTap: () => Navigator.pop(context, user),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}

// ── Admin org search sheet ─────────────────────────────────────────────────────

class _AdminOrgSearchSheet extends StatefulWidget {
  final MessagesApiDataSource datasource;
  const _AdminOrgSearchSheet({required this.datasource});

  @override
  State<_AdminOrgSearchSheet> createState() => _AdminOrgSearchSheetState();
}

class _AdminOrgSearchSheetState extends State<_AdminOrgSearchSheet> {
  static const _primaryColor = Color(0xFFFF601F);
  List<ConversationOrganization> _results = [];
  bool _loading = true;
  String _query = '';
  String? _error;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _search('');
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _search(String q) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final raw = await widget.datasource.searchAdminOrganizations(search: q);
      if (mounted) {
        setState(() {
          _results = raw.map(_orgFromJson).toList();
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = ApiResponseHandler.extractError(e);
        });
      }
    }
  }

  void _onQueryChanged(String v) {
    _query = v;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () => _search(v));
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      expand: false,
      builder: (_, scrollCtrl) => Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(
              context.l10n.messagesSearchOrganizationTitle,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              autofocus: true,
              onChanged: _onQueryChanged,
              decoration: InputDecoration(
                hintText: context.l10n.messagesOrganizationSearchHint,
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
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          context.l10n.messagesLoadError(_error!),
                          style: TextStyle(
                              color: Colors.red.shade700, fontSize: 12),
                        ),
                      )
                    : _results.isEmpty
                        ? Center(
                            child: Text(
                              _query.isEmpty
                                  ? context
                                      .l10n.messagesNoOrganizationsAvailable
                                  : context.l10n
                                      .messagesNoSearchResults(_query),
                              style: const TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            controller: scrollCtrl,
                            itemCount: _results.length,
                            itemBuilder: (_, i) {
                              final org = _results[i];
                              final orgImageUrl =
                                  org.logoUrl?.isNotEmpty == true
                                      ? org.logoUrl
                                      : org.avatarUrl?.isNotEmpty == true
                                          ? org.avatarUrl
                                          : null;
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor:
                                      _primaryColor.withValues(alpha: 0.15),
                                  child: orgImageUrl != null
                                      ? ClipOval(
                                          child: CachedNetworkImage(
                                            imageUrl: orgImageUrl,
                                            width: 40,
                                            height: 40,
                                            fit: BoxFit.cover,
                                            errorWidget: (_, __, ___) => Text(
                                              org.companyName.isNotEmpty
                                                  ? org.companyName[0]
                                                      .toUpperCase()
                                                  : '?',
                                              style: const TextStyle(
                                                  color: _primaryColor),
                                            ),
                                          ),
                                        )
                                      : Text(
                                          org.companyName.isNotEmpty
                                              ? org.companyName[0].toUpperCase()
                                              : '?',
                                          style: const TextStyle(
                                              color: _primaryColor),
                                        ),
                                ),
                                title: Text(org.companyName),
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

// ── Vendor participant search sheet ───────────────────────────────────────────

class _VendorParticipantSearchSheet extends StatefulWidget {
  final MessagesRepository repo;
  const _VendorParticipantSearchSheet({required this.repo});

  @override
  State<_VendorParticipantSearchSheet> createState() =>
      _VendorParticipantSearchSheetState();
}

class _VendorParticipantSearchSheetState
    extends State<_VendorParticipantSearchSheet> {
  static const _primaryColor = Color(0xFFFF601F);
  List<ConversationParticipant> _results = [];
  bool _loading = true;
  String _query = '';
  String? _error;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _search('');
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _search(String q) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final participants =
          await widget.repo.getInteractedParticipants(search: q);
      if (mounted) {
        setState(() {
          _results = participants;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = ApiResponseHandler.extractError(e);
        });
      }
    }
  }

  void _onQueryChanged(String v) {
    _query = v;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () => _search(v));
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      expand: false,
      builder: (_, scrollCtrl) => Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
            child: Text(
              context.l10n.messagesSearchParticipantTitle,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
            child: Text(
              context.l10n.messagesVendorParticipantSearchHelper,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: TextField(
              autofocus: true,
              onChanged: _onQueryChanged,
              decoration: InputDecoration(
                hintText: context.l10n.messagesNameOrEmailHint,
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
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          context.l10n.messagesLoadError(_error!),
                          style: TextStyle(
                              color: Colors.red.shade700, fontSize: 12),
                        ),
                      )
                    : _results.isEmpty
                        ? Center(
                            child: Text(
                              _query.isEmpty
                                  ? context.l10n.messagesNoParticipantsAvailable
                                  : context.l10n
                                      .messagesNoSearchResults(_query),
                              style: const TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            controller: scrollCtrl,
                            itemCount: _results.length,
                            itemBuilder: (_, i) {
                              final p = _results[i];
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor:
                                      _primaryColor.withValues(alpha: 0.15),
                                  child: p.avatarUrl != null &&
                                          p.avatarUrl!.isNotEmpty
                                      ? ClipOval(
                                          child: CachedNetworkImage(
                                            imageUrl: p.avatarUrl!,
                                            width: 40,
                                            height: 40,
                                            fit: BoxFit.cover,
                                            errorWidget: (_, __, ___) => Text(
                                              p.name.isNotEmpty
                                                  ? p.name[0].toUpperCase()
                                                  : '?',
                                              style: const TextStyle(
                                                  color: _primaryColor),
                                            ),
                                          ),
                                        )
                                      : Text(
                                          p.name.isNotEmpty
                                              ? p.name[0].toUpperCase()
                                              : '?',
                                          style: const TextStyle(
                                              color: _primaryColor),
                                        ),
                                ),
                                title: Text(p.name),
                                subtitle: Text(p.email),
                                onTap: () => Navigator.pop(context, p),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}

// ── Vendor partner search sheet (client-side filter) ──────────────────────────

class _VendorPartnerSearchSheet extends StatefulWidget {
  final List<AcceptedPartner> partners;
  const _VendorPartnerSearchSheet({required this.partners});

  @override
  State<_VendorPartnerSearchSheet> createState() =>
      _VendorPartnerSearchSheetState();
}

class _VendorPartnerSearchSheetState extends State<_VendorPartnerSearchSheet> {
  static const _primaryColor = Color(0xFFFF601F);
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = _query.isEmpty
        ? widget.partners
        : widget.partners
            .where((p) =>
                p.companyName.toLowerCase().contains(_query.toLowerCase()) ||
                p.organizationName.toLowerCase().contains(_query.toLowerCase()))
            .toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      expand: false,
      builder: (_, scrollCtrl) => Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(
              context.l10n.messagesSearchPartnerTitle,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              autofocus: true,
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: context.l10n.messagesPartnerSearchHint,
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
            child: widget.partners.isEmpty
                ? Center(
                    child: Text(
                      context.l10n.messagesNoPartnersAvailable,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  )
                : filtered.isEmpty
                    ? Center(
                        child: Text(
                          context.l10n.messagesNoSearchResults(_query),
                          style: const TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        controller: scrollCtrl,
                        itemCount: filtered.length,
                        itemBuilder: (_, i) {
                          final partner = filtered[i];
                          final logoUrl = partner.logoUrl ?? partner.avatarUrl;
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  _primaryColor.withValues(alpha: 0.15),
                              child: logoUrl != null && logoUrl.isNotEmpty
                                  ? ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: logoUrl,
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                        errorWidget: (_, __, ___) => Text(
                                          partner.companyName.isNotEmpty
                                              ? partner.companyName[0]
                                                  .toUpperCase()
                                              : '?',
                                          style: const TextStyle(
                                              color: _primaryColor),
                                        ),
                                      ),
                                    )
                                  : Text(
                                      partner.companyName.isNotEmpty
                                          ? partner.companyName[0].toUpperCase()
                                          : '?',
                                      style:
                                          const TextStyle(color: _primaryColor),
                                    ),
                            ),
                            title: Text(partner.companyName),
                            subtitle:
                                partner.organizationName != partner.companyName
                                    ? Text(partner.organizationName)
                                    : null,
                            onTap: () => Navigator.pop(context, partner),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
