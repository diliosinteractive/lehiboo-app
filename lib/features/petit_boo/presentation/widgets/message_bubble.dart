import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/themes/petit_boo_theme.dart';
import '../../data/models/chat_message_dto.dart';
import '../../data/models/tool_result_dto.dart';
import 'streaming_text.dart';
import 'tool_result_card.dart';

/// A chat message bubble with modern design
class MessageBubble extends StatelessWidget {
  final ChatMessageDto message;
  final bool isStreaming;
  final String? streamingText;
  final List<ToolResultDto>? toolResults;
  final VoidCallback? onRetry;

  const MessageBubble({
    super.key,
    required this.message,
    this.isStreaming = false,
    this.streamingText,
    this.toolResults,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    return Row(
      mainAxisAlignment:
          isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar assistant (gauche)
        if (!isUser) ...[
          _buildAssistantAvatar(),
          SizedBox(width: PetitBooTheme.spacing12),
        ],

        // Message content
        Flexible(
          child: Column(
            crossAxisAlignment:
                isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              // Tool results (avant le message assistant)
              if (!isUser &&
                  (message.hasToolResults || (toolResults?.isNotEmpty ?? false)))
                _buildToolResults(message.toolResults ?? toolResults ?? []),

              // Message bubble
              _buildBubble(context, isUser),
            ],
          ),
        ),

        // Pas d'avatar pour user (comme le web)
      ],
    );
  }

  Widget _buildAssistantAvatar() {
    return Container(
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
            size: PetitBooTheme.iconMd,
          ),
        ),
      ),
    );
  }

  Widget _buildToolResults(List<ToolResultDto> results) {
    return Padding(
      padding: EdgeInsets.only(bottom: PetitBooTheme.spacing12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            results.map((result) => ToolResultCard(result: result)).toList(),
      ),
    );
  }

  Widget _buildBubble(BuildContext context, bool isUser) {
    final displayText = isStreaming ? (streamingText ?? '') : message.content;

    if (displayText.isEmpty && !isStreaming) {
      return const SizedBox.shrink();
    }

    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.78,
      ),
      padding: EdgeInsets.all(PetitBooTheme.spacing20),
      decoration: isUser
          ? PetitBooTheme.bubbleUserDecoration
          : PetitBooTheme.bubbleAssistantDecoration,
      child: isStreaming
          ? StreamingText(
              text: displayText,
              style: PetitBooTheme.bodyMd,
            )
          : isUser
              // User messages: simple text
              ? SelectableText(
                  displayText,
                  style: PetitBooTheme.bodyMd.copyWith(
                    color: PetitBooTheme.textOnPrimary,
                  ),
                )
              // Assistant messages: Markdown formatted
              : MarkdownBody(
                  data: displayText,
                  selectable: true,
                  onTapLink: (text, href, title) {
                    if (href != null) {
                      launchUrl(Uri.parse(href),
                          mode: LaunchMode.externalApplication);
                    }
                  },
                  styleSheet: _buildMarkdownStyle(),
                ),
    );
  }

  MarkdownStyleSheet _buildMarkdownStyle() {
    return MarkdownStyleSheet(
      p: PetitBooTheme.bodyMd,
      strong: PetitBooTheme.bodyMd.copyWith(fontWeight: FontWeight.w600),
      em: PetitBooTheme.bodyMd.copyWith(fontStyle: FontStyle.italic),
      code: TextStyle(
        fontFamily: 'monospace',
        fontSize: 14,
        backgroundColor: PetitBooTheme.grey100,
        color: PetitBooTheme.textPrimary,
      ),
      codeblockDecoration: BoxDecoration(
        color: PetitBooTheme.grey100,
        borderRadius: PetitBooTheme.borderRadiusMd,
      ),
      codeblockPadding: EdgeInsets.all(PetitBooTheme.spacing12),
      listBullet: PetitBooTheme.bodyMd,
      a: PetitBooTheme.bodyMd.copyWith(
        color: PetitBooTheme.primary,
        decoration: TextDecoration.underline,
        decorationColor: PetitBooTheme.primary,
      ),
      h1: PetitBooTheme.headingLg,
      h2: PetitBooTheme.headingMd,
      h3: PetitBooTheme.headingSm,
      blockquoteDecoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: PetitBooTheme.primary.withValues(alpha: 0.5),
            width: 3,
          ),
        ),
      ),
      blockquotePadding: EdgeInsets.only(left: PetitBooTheme.spacing12),
    );
  }
}

/// Streaming message bubble (for assistant while receiving tokens)
class StreamingMessageBubble extends StatelessWidget {
  final String text;
  final List<ToolResultDto> toolResults;

  const StreamingMessageBubble({
    super.key,
    required this.text,
    this.toolResults = const [],
  });

  @override
  Widget build(BuildContext context) {
    return MessageBubble(
      message: ChatMessageDto.assistant(
        content: '',
        isStreaming: true,
      ),
      isStreaming: true,
      streamingText: text,
      toolResults: toolResults,
    );
  }
}
