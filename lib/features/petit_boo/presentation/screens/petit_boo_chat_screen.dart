import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/themes/petit_boo_theme.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../home/presentation/providers/user_location_provider.dart';
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
    // Get user data for personalization
    final user = ref.watch(currentUserProvider);
    final locationAsync = ref.watch(userLocationProvider);

    final firstName = user?.firstName ?? user?.displayName?.split(' ').first;
    final cityName = locationAsync.valueOrNull?.cityName;

    // Build personalized greeting
    final greeting = _buildPersonalizedGreeting(firstName);
    final subtitle = _buildPersonalizedSubtitle(cityName);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: PetitBooTheme.spacing20),
      child: Column(
        children: [
          SizedBox(height: PetitBooTheme.spacing16),

          // Hero Section - Personalized
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: PetitBooTheme.spacing24,
              vertical: PetitBooTheme.spacing24,
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
                // Logo + Greeting Row
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: PetitBooTheme.primaryLight,
                        boxShadow: PetitBooTheme.shadowSm,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          PetitBooTheme.owlLogoPath,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.smart_toy_outlined,
                            color: PetitBooTheme.primary,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: PetitBooTheme.spacing16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            greeting,
                            style: PetitBooTheme.headingMd.copyWith(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: PetitBooTheme.spacing2),
                          Text(
                            subtitle,
                            style: PetitBooTheme.bodySm.copyWith(
                              color: PetitBooTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: PetitBooTheme.spacing20),

                // Location pill if available
                if (cityName != null)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: PetitBooTheme.spacing12,
                      vertical: PetitBooTheme.spacing8,
                    ),
                    decoration: BoxDecoration(
                      color: PetitBooTheme.primaryLight,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 16,
                          color: PetitBooTheme.primary,
                        ),
                        SizedBox(width: PetitBooTheme.spacing6),
                        Text(
                          cityName,
                          style: PetitBooTheme.bodySm.copyWith(
                            color: PetitBooTheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          SizedBox(height: PetitBooTheme.spacing24),

          // Quick actions - Horizontal scroll pills
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              children: [
                _buildQuickActionPill(
                  Icons.calendar_today_rounded,
                  'Ce soir',
                  cityName != null
                      ? 'Que faire ce soir à $cityName ?'
                      : 'Que faire ce soir ?',
                ),
                _buildQuickActionPill(
                  Icons.weekend_rounded,
                  'Week-end',
                  cityName != null
                      ? 'Événements ce week-end à $cityName'
                      : 'Événements ce week-end',
                ),
                _buildQuickActionPill(
                  Icons.confirmation_number_rounded,
                  'Mes billets',
                  'Affiche mes réservations',
                ),
                _buildQuickActionPill(
                  Icons.favorite_rounded,
                  'Favoris',
                  'Mes favoris',
                ),
              ],
            ),
          ),

          SizedBox(height: PetitBooTheme.spacing32),

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

          // Suggestion chips - Personalized with city
          ..._buildSuggestionItems(cityName),

          SizedBox(height: PetitBooTheme.spacing16),
        ],
      ),
    );
  }

  String _buildPersonalizedGreeting(String? firstName) {
    final hour = DateTime.now().hour;
    String timeGreeting;

    if (hour < 12) {
      timeGreeting = 'Bonjour';
    } else if (hour < 18) {
      timeGreeting = 'Bon après-midi';
    } else {
      timeGreeting = 'Bonsoir';
    }

    if (firstName != null && firstName.isNotEmpty) {
      return '$timeGreeting $firstName !';
    }
    return '$timeGreeting !';
  }

  String _buildPersonalizedSubtitle(String? cityName) {
    if (cityName != null) {
      return 'Que puis-je faire pour vous à $cityName ?';
    }
    return 'Comment puis-je vous aider aujourd\'hui ?';
  }

  Widget _buildQuickActionPill(IconData icon, String label, String message) {
    return Padding(
      padding: EdgeInsets.only(right: PetitBooTheme.spacing10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            ref.read(petitBooChatProvider.notifier).sendMessage(message);
          },
          borderRadius: BorderRadius.circular(100),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: PetitBooTheme.spacing14,
              vertical: PetitBooTheme.spacing10,
            ),
            decoration: BoxDecoration(
            color: PetitBooTheme.surface,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: PetitBooTheme.grey200,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: PetitBooTheme.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: PetitBooTheme.primary,
                  size: 14,
                ),
              ),
              SizedBox(width: PetitBooTheme.spacing8),
              Text(
                label,
                style: PetitBooTheme.bodySm.copyWith(
                  fontWeight: FontWeight.w500,
                  color: PetitBooTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }

  List<Widget> _buildSuggestionItems(String? cityName) {
    final suggestions = [
      {
        'icon': Icons.local_activity_rounded,
        'text': cityName != null
            ? 'Quels événements ce soir à $cityName ?'
            : 'Quels événements ce soir ?',
      },
      {
        'icon': Icons.family_restroom_rounded,
        'text': cityName != null
            ? 'Activités pour enfants à $cityName'
            : 'Activités pour enfants ce week-end',
      },
      {
        'icon': Icons.restaurant_rounded,
        'text': cityName != null
            ? 'Sorties gastronomiques à $cityName'
            : 'Sorties gastronomiques ce week-end',
      },
      {
        'icon': Icons.music_note_rounded,
        'text': cityName != null
            ? 'Concerts et spectacles à $cityName'
            : 'Concerts et spectacles à venir',
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
