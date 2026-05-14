import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/repositories/messages_repository_impl.dart';
import '../providers/conversations_provider.dart';
import '../widgets/new_conversation_form.dart';
import 'package:lehiboo/core/l10n/l10n.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/auth/presentation/widgets/guest_restriction_dialog.dart';

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

  @override
  void initState() {
    super.initState();

    // Safety check for unauthenticated users (e.g. deep links)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = ref.read(authProvider);
      if (authState.status == AuthStatus.unauthenticated) {
        GuestRestrictionDialog.show(
          context,
          featureName: context.l10n.guestFeatureSendMessage,
        );
      } else {
        _init();
      }
    });
  }

  Future<void> _init() async {
    if (widget.fromBookingUuid != null) {
      await _createFromBooking();
    } else {
      final created = await _showFormModal();
      // Only navigate away when the user cancelled — a successful submission
      // already called context.pushReplacement inside _submit().
      if (mounted && created != true) {
        context.canPop() ? context.pop() : context.go('/messages');
      }
    }
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
      ref.read(conversationsProvider.notifier).refresh();
      context.pushReplacement('/messages/${result.conversation.uuid}');
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  Future<bool?> _showFormModal() async {
    if (!mounted) return null;
    NewConversationContext ctx;
    if (widget.fromOrganizationUuid != null) {
      ctx = FromOrganizerConversationContext(
        organizationUuid: widget.fromOrganizationUuid!,
        organizationName: widget.fromOrganizationName ?? 'Organisateur',
      );
    } else {
      ctx = DashboardConversationContext();
    }
    return NewConversationForm.show(context, conversationContext: ctx);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.fromBookingUuid != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Nouveau message'),
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
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
