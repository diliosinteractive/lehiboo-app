import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lehiboo/core/utils/api_response_handler.dart';

import '../../data/repositories/messages_repository_impl.dart';
import '../providers/conversations_provider.dart';
import '../widgets/new_conversation_form.dart';
import 'package:lehiboo/core/l10n/l10n.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';

class NewConversationScreen extends ConsumerStatefulWidget {
  final String? fromBookingUuid;
  final String? fromOrganizationUuid;
  final String? fromOrganizationName;

  const NewConversationScreen({
    super.key,
    this.fromBookingUuid,
    this.fromOrganizationUuid,
    this.fromOrganizationName,
  });

  @override
  ConsumerState<NewConversationScreen> createState() =>
      _NewConversationScreenState();
}

class _NewConversationScreenState extends ConsumerState<NewConversationScreen> {
  static const _primaryColor = Color(0xFFFF601F);

  bool _isLoading = false;
  String? _errorMessage;
  late final String? _ownerAccountId;
  bool _sessionInvalid = false;
  bool _exitScheduled = false;
  int _requestGeneration = 0;

  bool get _ownsCurrentAccount {
    return mounted &&
        !_sessionInvalid &&
        _ownerAccountId != null &&
        ref.read(authSessionUserIdProvider) == _ownerAccountId;
  }

  @override
  void initState() {
    super.initState();
    _ownerAccountId = ref.read(authSessionUserIdProvider);
    _sessionInvalid = _ownerAccountId == null;
    ref.listenManual<String?>(authSessionUserIdProvider, (_, next) {
      if (_sessionInvalid || next == _ownerAccountId) return;
      _sessionInvalid = true;
      _requestGeneration++;
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = null;
        });
      }
      _scheduleFailClosedExit();
    });
    if (_sessionInvalid) _scheduleFailClosedExit();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_ownsCurrentAccount) return;
      _init();
    });
  }

  void _scheduleFailClosedExit() {
    if (_exitScheduled) return;
    _exitScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_sessionInvalid) return;
      final ownedRoute = ModalRoute.of(context);
      final navigator = Navigator.of(context);
      if (ownedRoute == null) return;
      navigator.popUntil((route) => identical(route, ownedRoute));
      if (ownedRoute.isCurrent && navigator.canPop()) navigator.pop();
    });
  }

  bool _ownsRequest(
    int generation,
    ConversationsNotifier ownerNotifier,
  ) {
    return _ownsCurrentAccount &&
        generation == _requestGeneration &&
        identical(
          ref.read(conversationsProvider.notifier),
          ownerNotifier,
        );
  }

  Future<void> _init() async {
    if (!_ownsCurrentAccount) return;
    if (widget.fromBookingUuid != null) {
      await _createFromBooking();
    } else {
      final created = await _showFormModal();
      // Only navigate away when the user cancelled — a successful submission
      // already called context.pushReplacement inside _submit().
      if (!mounted || !_ownsCurrentAccount || created == true) return;
      context.canPop() ? context.pop() : context.go('/messages');
    }
  }

  Future<void> _createFromBooking() async {
    if (!_ownsCurrentAccount) return;
    final generation = ++_requestGeneration;
    final repo = ref.read(messagesRepositoryProvider);
    final ownerNotifier = ref.read(conversationsProvider.notifier);
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final result = await repo.createFromBooking(widget.fromBookingUuid!);
      if (!mounted || !_ownsRequest(generation, ownerNotifier)) return;
      unawaited(ownerNotifier.refresh());
      if (!mounted || !_ownsRequest(generation, ownerNotifier)) return;
      context.pushReplacement('/messages/${result.conversation.uuid}');
    } catch (e) {
      if (!mounted || !_ownsRequest(generation, ownerNotifier)) return;
      setState(() {
        _isLoading = false;
        _errorMessage = ApiResponseHandler.extractError(
          e,
          fallback: context.l10n.messagesBookingConversationCreateFailed,
        );
      });
    }
  }

  Future<bool?> _showFormModal() async {
    if (!_ownsCurrentAccount) return null;
    NewConversationContext ctx;
    if (widget.fromOrganizationUuid != null) {
      ctx = FromOrganizerConversationContext(
        organizationUuid: widget.fromOrganizationUuid!,
        organizationName: widget.fromOrganizationName ??
            context.l10n.messagesFallbackOrganizer,
      );
    } else {
      ctx = DashboardConversationContext();
    }
    return NewConversationForm.show(context, conversationContext: ctx);
  }

  @override
  Widget build(BuildContext context) {
    final currentAccountId = ref.watch(authSessionUserIdProvider);
    if (_sessionInvalid ||
        (_ownerAccountId != null && currentAccountId != _ownerAccountId) ||
        (_ownerAccountId == null && currentAccountId != null)) {
      return const Scaffold(
        key: Key('new-conversation-session-invalid'),
        body: SizedBox.shrink(),
      );
    }

    if (widget.fromBookingUuid != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.messagesNewMessage),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
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
                        _errorMessage ?? context.l10n.messagesGenericError,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _createFromBooking,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryColor),
                        child: Text(context.l10n.commonRetry,
                            style: const TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
      );
    }
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
