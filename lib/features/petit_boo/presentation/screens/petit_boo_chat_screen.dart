import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/themes/colors.dart';
import '../providers/petit_boo_chat_provider.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/limit_reached_dialog.dart';
import '../widgets/message_bubble.dart';
import '../widgets/typing_indicator.dart';

/// Main chat screen for Petit Boo AI assistant
class PetitBooChatScreen extends ConsumerStatefulWidget {
  final String? sessionUuid;
  final String? initialVoiceMessage;

  const PetitBooChatScreen({
    super.key,
    this.sessionUuid,
    this.initialVoiceMessage,
  });

  @override
  ConsumerState<PetitBooChatScreen> createState() => _PetitBooChatScreenState();
}

class _PetitBooChatScreenState extends ConsumerState<PetitBooChatScreen> {
  final _scrollController = ScrollController();
  bool _hasProcessedInitialMessage = false;

  @override
  void initState() {
    super.initState();
    // Load session if provided
    if (widget.sessionUuid != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(petitBooChatProvider.notifier).loadSession(widget.sessionUuid!);
      });
    }

    // Send initial voice message if provided
    if (widget.initialVoiceMessage != null &&
        widget.initialVoiceMessage!.isNotEmpty &&
        !_hasProcessedInitialMessage) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_hasProcessedInitialMessage) {
          _hasProcessedInitialMessage = true;
          ref.read(petitBooChatProvider.notifier).sendMessage(
            widget.initialVoiceMessage!,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        // Re-check after delay since widget might have been disposed
        if (mounted && _scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(petitBooChatProvider);

    // Auto-scroll when new messages arrive or streaming updates
    ref.listen<PetitBooChatState>(petitBooChatProvider, (previous, next) {
      if (previous?.messages.length != next.messages.length ||
          previous?.currentStreamingText != next.currentStreamingText) {
        _scrollToBottom();
      }
    });

    // Show limit reached dialog
    ref.listen(
      petitBooChatProvider.select((s) => s.isLimitReached),
      (previous, next) {
        if (next && previous != next) {
          LimitReachedDialog.show(context);
        }
      },
    );

    return Scaffold(
      backgroundColor: HbColors.orangePastel,
      appBar: _buildAppBar(context, chatState),
      body: Column(
        children: [
          // Error banner
          if (chatState.error != null)
            _buildErrorBanner(chatState.error!),

          // Service unavailable warning
          if (!chatState.isServiceAvailable)
            _buildServiceUnavailableBanner(),

          // Chat messages
          Expanded(
            child: chatState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildMessageList(chatState),
          ),

          // Input bar with built-in speech-to-text
          const ChatInputBar(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, PetitBooChatState state) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        color: HbColors.textPrimary,
        onPressed: () => context.pop(),
      ),
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: HbColors.brandPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Center(
              child: Text('🦉', style: TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Petit Boo',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: HbColors.textPrimary,
                ),
              ),
              Text(
                state.isStreaming ? 'Écrit...' : 'Assistant IA',
                style: TextStyle(
                  fontSize: 12,
                  color: state.isStreaming
                      ? HbColors.brandPrimary
                      : HbColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        // Brain/Memory button
        IconButton(
          icon: const Icon(Icons.psychology_outlined),
          color: HbColors.textSecondary,
          onPressed: () => context.push('/petit-boo/brain'),
          tooltip: 'Mémoire',
        ),
        // History button
        IconButton(
          icon: const Icon(Icons.history),
          color: HbColors.textSecondary,
          onPressed: () => context.push('/petit-boo/history'),
          tooltip: 'Historique',
        ),
        // New conversation button
        IconButton(
          icon: const Icon(Icons.add_comment_outlined),
          color: HbColors.textSecondary,
          onPressed: () {
            ref.read(petitBooChatProvider.notifier).createNewSession();
          },
          tooltip: 'Nouvelle conversation',
        ),
      ],
    );
  }

  Widget _buildErrorBanner(String error) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: HbColors.error.withOpacity(0.1),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: HbColors.error,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              error,
              style: TextStyle(
                fontSize: 13,
                color: HbColors.error,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            color: HbColors.error,
            onPressed: () {
              ref.read(petitBooChatProvider.notifier).clearError();
            },
          ),
          if (error.contains('error') || error.contains('failed'))
            TextButton(
              onPressed: () {
                ref.read(petitBooChatProvider.notifier).retryLastMessage();
              },
              child: const Text('Réessayer'),
            ),
        ],
      ),
    );
  }

  Widget _buildServiceUnavailableBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: HbColors.warning.withOpacity(0.1),
      child: Row(
        children: [
          Icon(
            Icons.cloud_off,
            color: HbColors.warning,
            size: 20,
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Petit Boo est temporairement indisponible',
              style: TextStyle(
                fontSize: 13,
                color: HbColors.warning,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              ref.read(petitBooChatProvider.notifier).checkServiceAvailability();
            },
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList(PetitBooChatState state) {
    if (state.messages.isEmpty && !state.isStreaming) {
      return _buildWelcomeScreen();
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: state.messages.length + (state.isStreaming ? 1 : 0),
      itemBuilder: (context, index) {
        // Show streaming message at the end
        if (index == state.messages.length && state.isStreaming) {
          // If we have streaming content or tool results, show them
          if (state.currentStreamingText.isNotEmpty || state.hasToolResults) {
            return StreamingMessageBubble(
              text: state.currentStreamingText,
              toolResults: state.currentToolResults,
            );
          }
          // Otherwise show typing indicator
          return const PetitBooTypingIndicator();
        }

        final message = state.messages[index];
        return MessageBubble(message: message);
      },
    );
  }

  Widget _buildWelcomeScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 32),

          // Owl mascot with glow effect
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: HbColors.brandPrimary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: HbColors.brandPrimary.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/petit_boo_logo.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Text('🦉', style: TextStyle(fontSize: 56)),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Greeting
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.waving_hand, size: 28, color: Color(0xFFFFD700)),
              const SizedBox(width: 8),
              const Text(
                'Bonjour !',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: HbColors.textPrimary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          const Text(
            'Je suis Petit Boo',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: HbColors.brandPrimary,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            'Votre assistant personnel pour découvrir des événements '
            'et gérer vos réservations.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: HbColors.textSecondary,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 32),

          // Features list
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildFeatureRow(Icons.search, 'Trouvez des événements près de vous'),
                const SizedBox(height: 12),
                _buildFeatureRow(Icons.calendar_today, 'Gérez vos réservations'),
                const SizedBox(height: 12),
                _buildFeatureRow(Icons.mic, 'Parlez-moi naturellement'),
                const SizedBox(height: 12),
                _buildFeatureRow(Icons.psychology, 'J\'apprends vos préférences'),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Suggestion chips
          const Text(
            'Essayez de me demander...',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: HbColors.textSecondary,
            ),
          ),

          const SizedBox(height: 16),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: _buildSuggestionChips(),
          ),

          const SizedBox(height: 24),

          // Beta notice
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.science_outlined, color: Colors.amber.shade800, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Version Beta - Petit Boo apprend encore !',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.amber.shade900,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: HbColors.brandPrimary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: HbColors.brandPrimary, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: HbColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildSuggestionChips() {
    final suggestions = [
      'Quels événements ce week-end ?',
      'Montre mes réservations',
      'Activités en famille',
      'Mes événements favoris',
    ];

    return suggestions.map((suggestion) {
      return ActionChip(
        label: Text(
          suggestion,
          style: const TextStyle(fontSize: 13),
        ),
        onPressed: () {
          ref.read(petitBooChatProvider.notifier).sendMessage(suggestion);
        },
        backgroundColor: Colors.white,
        side: BorderSide(color: HbColors.brandPrimary.withOpacity(0.3)),
      );
    }).toList();
  }
}
