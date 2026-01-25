import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/themes/petit_boo_theme.dart';
import '../providers/petit_boo_chat_provider.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/limit_reached_dialog.dart';
import '../widgets/message_bubble.dart';
import '../widgets/quota_indicator.dart';
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
    if (widget.sessionUuid != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(petitBooChatProvider.notifier).loadSession(widget.sessionUuid!);
      });
    }

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
        if (mounted && _scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: PetitBooTheme.durationNormal,
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(petitBooChatProvider);

    ref.listen<PetitBooChatState>(petitBooChatProvider, (previous, next) {
      if (previous?.messages.length != next.messages.length ||
          previous?.currentStreamingText != next.currentStreamingText) {
        _scrollToBottom();
      }
    });

    ref.listen(
      petitBooChatProvider.select((s) => s.isLimitReached),
      (previous, next) {
        if (next && previous != next) {
          LimitReachedDialog.show(context);
        }
      },
    );

    return Scaffold(
      backgroundColor: PetitBooTheme.background,
      appBar: _buildAppBar(context, chatState),
      body: Column(
        children: [
          if (chatState.error != null) _buildErrorBanner(chatState.error!),
          if (!chatState.isServiceAvailable) _buildServiceUnavailableBanner(),
          Expanded(
            child: chatState.isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: PetitBooTheme.primary,
                      strokeWidth: 2,
                    ),
                  )
                : _buildMessageList(chatState),
          ),
          const ChatInputBar(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
      BuildContext context, PetitBooChatState state) {
    return AppBar(
      backgroundColor: PetitBooTheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: PetitBooTheme.iconMd,
        ),
        color: PetitBooTheme.textPrimary,
        onPressed: () => context.pop(),
      ),
      title: Row(
        children: [
          // Logo Petit Boo
          Container(
            width: PetitBooTheme.avatarMd,
            height: PetitBooTheme.avatarMd,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: PetitBooTheme.primaryLight,
            ),
            child: ClipOval(
              child: Image.asset(
                PetitBooTheme.owlLogoPath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.smart_toy_outlined,
                  color: PetitBooTheme.primary,
                  size: PetitBooTheme.iconLg,
                ),
              ),
            ),
          ),
          SizedBox(width: PetitBooTheme.spacing12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Petit Boo', style: PetitBooTheme.headingSm),
              Text(
                state.isStreaming ? 'Répond...' : 'Assistant IA',
                style: PetitBooTheme.caption.copyWith(
                  color: state.isStreaming
                      ? PetitBooTheme.primary
                      : PetitBooTheme.textTertiary,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        // Quota circulaire (compact, en haut)
        if (state.quota != null)
          Padding(
            padding: EdgeInsets.only(right: PetitBooTheme.spacing4),
            child: CircularQuotaIndicator(quota: state.quota!, size: 34),
          ),
        // History
        IconButton(
          icon: Icon(Icons.history_rounded, size: PetitBooTheme.iconLg),
          color: PetitBooTheme.grey500,
          onPressed: () => context.push('/petit-boo/history'),
          tooltip: 'Historique',
        ),
        // New conversation
        IconButton(
          icon: Icon(Icons.add_rounded, size: PetitBooTheme.iconLg),
          color: PetitBooTheme.grey500,
          onPressed: () {
            ref.read(petitBooChatProvider.notifier).createNewSession();
          },
          tooltip: 'Nouvelle conversation',
        ),
        SizedBox(width: PetitBooTheme.spacing8),
      ],
    );
  }

  Widget _buildErrorBanner(String error) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: PetitBooTheme.spacing16,
        vertical: PetitBooTheme.spacing12,
      ),
      decoration: BoxDecoration(
        color: PetitBooTheme.errorLight,
        border: Border(
          bottom: BorderSide(color: PetitBooTheme.error.withValues(alpha: 0.2)),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: PetitBooTheme.error,
            size: PetitBooTheme.iconMd,
          ),
          SizedBox(width: PetitBooTheme.spacing8),
          Expanded(
            child: Text(
              error,
              style: PetitBooTheme.bodySm.copyWith(color: PetitBooTheme.error),
            ),
          ),
          IconButton(
            icon: Icon(Icons.close_rounded, size: 18),
            color: PetitBooTheme.error,
            onPressed: () {
              ref.read(petitBooChatProvider.notifier).clearError();
            },
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceUnavailableBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: PetitBooTheme.spacing16,
        vertical: PetitBooTheme.spacing12,
      ),
      decoration: BoxDecoration(
        color: PetitBooTheme.warningLight,
        border: Border(
          bottom: BorderSide(color: PetitBooTheme.warning.withValues(alpha: 0.2)),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.cloud_off_rounded,
            color: PetitBooTheme.warning,
            size: PetitBooTheme.iconMd,
          ),
          SizedBox(width: PetitBooTheme.spacing8),
          Expanded(
            child: Text(
              'Petit Boo est temporairement indisponible',
              style: PetitBooTheme.bodySm.copyWith(color: PetitBooTheme.grey700),
            ),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(petitBooChatProvider.notifier)
                  .checkServiceAvailability();
            },
            style: TextButton.styleFrom(
              foregroundColor: PetitBooTheme.warning,
              padding: EdgeInsets.symmetric(horizontal: PetitBooTheme.spacing12),
            ),
            child: Text('Retry'),
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
      padding: EdgeInsets.symmetric(
        vertical: PetitBooTheme.spacing24,
        horizontal: PetitBooTheme.spacing16,
      ),
      itemCount: state.messages.length + (state.isStreaming ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == state.messages.length && state.isStreaming) {
          if (state.currentStreamingText.isNotEmpty || state.hasToolResults) {
            return Padding(
              padding: EdgeInsets.only(bottom: PetitBooTheme.spacing24),
              child: StreamingMessageBubble(
                text: state.currentStreamingText,
                toolResults: state.currentToolResults,
              ),
            );
          }
          return Padding(
            padding: EdgeInsets.only(bottom: PetitBooTheme.spacing24),
            child: const PetitBooTypingIndicator(),
          );
        }

        final message = state.messages[index];
        return Padding(
          padding: EdgeInsets.only(bottom: PetitBooTheme.spacing24),
          child: MessageBubble(message: message),
        );
      },
    );
  }

  Widget _buildWelcomeScreen() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: PetitBooTheme.spacing20),
      child: Column(
        children: [
          SizedBox(height: PetitBooTheme.spacing16),

          // Hero Section - Clean style with border
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: PetitBooTheme.spacing24,
              vertical: PetitBooTheme.spacing32,
            ),
            decoration: BoxDecoration(
              color: PetitBooTheme.surface,
              borderRadius: PetitBooTheme.borderRadius2xl,
              border: Border.all(
                color: PetitBooTheme.primary.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                // Logo
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: PetitBooTheme.primaryLight,
                    boxShadow: PetitBooTheme.shadowMd,
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      PetitBooTheme.owlLogoPath,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.smart_toy_outlined,
                        color: PetitBooTheme.primary,
                        size: 44,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: PetitBooTheme.spacing20),

                // Greeting
                Text(
                  'Bonjour !',
                  style: PetitBooTheme.headingLg.copyWith(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: PetitBooTheme.spacing4),
                Text(
                  'Je suis Petit Boo',
                  style: PetitBooTheme.headingMd.copyWith(
                    color: PetitBooTheme.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),

                SizedBox(height: PetitBooTheme.spacing8),

                Text(
                  'Votre assistant IA pour découvrir\ndes événements uniques',
                  textAlign: TextAlign.center,
                  style: PetitBooTheme.bodySm.copyWith(
                    color: PetitBooTheme.textSecondary,
                    height: 1.4,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: PetitBooTheme.spacing20),

          // Features as horizontal scroll
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              clipBehavior: Clip.none,
              children: [
                _buildFeatureCard(
                  Icons.search_rounded,
                  'Événements',
                  'Trouvez des sorties',
                ),
                _buildFeatureCard(
                  Icons.calendar_today_rounded,
                  'Réservations',
                  'Gérez vos billets',
                ),
                _buildFeatureCard(
                  Icons.mic_rounded,
                  'Vocal',
                  'Parlez-moi',
                ),
                _buildFeatureCard(
                  Icons.favorite_rounded,
                  'Favoris',
                  'Vos coups de coeur',
                ),
              ],
            ),
          ),

          SizedBox(height: PetitBooTheme.spacing24),

          // Suggestions Section
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: PetitBooTheme.spacing4),
              child: Text(
                'Essayez de me demander...',
                style: PetitBooTheme.headingSm.copyWith(
                  color: PetitBooTheme.textPrimary,
                ),
              ),
            ),
          ),

          SizedBox(height: PetitBooTheme.spacing16),

          // Suggestion chips as list
          ..._buildSuggestionItems(),

          SizedBox(height: PetitBooTheme.spacing16),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String subtitle) {
    return Container(
      width: 100,
      margin: EdgeInsets.only(right: PetitBooTheme.spacing10),
      padding: EdgeInsets.all(PetitBooTheme.spacing10),
      decoration: BoxDecoration(
        color: PetitBooTheme.surface,
        borderRadius: PetitBooTheme.borderRadiusLg,
        border: Border.all(color: PetitBooTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: PetitBooTheme.primaryLight,
              borderRadius: PetitBooTheme.borderRadiusMd,
            ),
            child: Icon(
              icon,
              color: PetitBooTheme.primary,
              size: 15,
            ),
          ),
          const Spacer(),
          Text(
            title,
            style: PetitBooTheme.bodySm.copyWith(
              fontWeight: FontWeight.w600,
              color: PetitBooTheme.textPrimary,
              fontSize: 12,
              height: 1.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            subtitle,
            style: PetitBooTheme.caption.copyWith(
              fontSize: 10,
              color: PetitBooTheme.textTertiary,
              height: 1.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSuggestionItems() {
    final suggestions = [
      {
        'icon': Icons.event_rounded,
        'text': 'Quels \u00e9v\u00e9nements ce week-end ?',
      },
      {
        'icon': Icons.confirmation_number_rounded,
        'text': 'Affiche mes r\u00e9servations',
      },
      {
        'icon': Icons.family_restroom_rounded,
        'text': 'Activit\u00e9s pour enfants',
      },
      {
        'icon': Icons.star_rounded,
        'text': 'Mes favoris',
      },
    ];

    return suggestions.map((suggestion) {
      return Padding(
        padding: EdgeInsets.only(bottom: PetitBooTheme.spacing10),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              ref.read(petitBooChatProvider.notifier).sendMessage(
                    suggestion['text'] as String,
                  );
            },
            borderRadius: PetitBooTheme.borderRadiusXl,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: PetitBooTheme.spacing16,
                vertical: PetitBooTheme.spacing12,
              ),
              decoration: BoxDecoration(
                color: PetitBooTheme.surface,
                borderRadius: PetitBooTheme.borderRadiusXl,
                border: Border.all(color: PetitBooTheme.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: PetitBooTheme.grey100,
                      borderRadius: PetitBooTheme.borderRadiusMd,
                    ),
                    child: Icon(
                      suggestion['icon'] as IconData,
                      color: PetitBooTheme.grey500,
                      size: 16,
                    ),
                  ),
                  SizedBox(width: PetitBooTheme.spacing12),
                  Expanded(
                    child: Text(
                      suggestion['text'] as String,
                      style: PetitBooTheme.bodyMd.copyWith(
                        color: PetitBooTheme.textSecondary,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: PetitBooTheme.grey300,
                    size: 14,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }).toList();
  }
}
