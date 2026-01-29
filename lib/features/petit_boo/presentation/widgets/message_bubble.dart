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
    final hasToolResults = !isUser &&
        (message.hasToolResults || (toolResults?.isNotEmpty ?? false));

    return Column(
      crossAxisAlignment:
          isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        // Tool results FULL WIDTH (outside avatar row)
        if (hasToolResults)
          _buildToolResults(message.toolResults ?? toolResults ?? []),

        // Message row with avatar + bubble
        Row(
          mainAxisAlignment:
              isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isUser) ...[
              _buildAssistantAvatar(),
              SizedBox(width: PetitBooTheme.spacing12),
            ],
            Flexible(
              child: _buildBubble(context, isUser),
            ),
          ],
        ),
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
    final cards = <Widget>[];
    for (var i = 0; i < results.length; i++) {
      if (i > 0) {
        cards.add(SizedBox(height: PetitBooTheme.spacing16));
      }
      cards.add(ToolResultCard(result: results[i]));
    }
    return Padding(
      padding: EdgeInsets.only(bottom: PetitBooTheme.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: cards,
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
