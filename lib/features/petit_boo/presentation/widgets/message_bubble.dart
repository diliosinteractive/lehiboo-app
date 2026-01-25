import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/themes/colors.dart';
import '../../data/models/chat_message_dto.dart';
import '../../data/models/tool_result_dto.dart';
import 'streaming_text.dart';
import 'tool_result_card.dart';

/// A chat message bubble
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            _buildAvatar(),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                // Tool results (before assistant message)
                if (!isUser && (message.hasToolResults || (toolResults?.isNotEmpty ?? false)))
                  _buildToolResults(message.toolResults ?? toolResults ?? []),

                // Message bubble
                _buildBubble(context, isUser),
              ],
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            _buildUserAvatar(),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: HbColors.brandPrimary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Center(
        child: Text(
          '🦉',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  Widget _buildUserAvatar() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: HbColors.brandSecondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Icon(
        Icons.person_outline,
        size: 20,
        color: HbColors.brandSecondary,
      ),
    );
  }

  Widget _buildToolResults(List<ToolResultDto> results) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: results.map((result) => ToolResultCard(result: result)).toList(),
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
        maxWidth: MediaQuery.of(context).size.width * 0.75,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isUser ? HbColors.brandPrimary : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20),
          topRight: const Radius.circular(20),
          bottomLeft: Radius.circular(isUser ? 20 : 4),
          bottomRight: Radius.circular(isUser ? 4 : 20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: isStreaming
          ? StreamingText(
              text: displayText,
              style: TextStyle(
                fontSize: 15,
                height: 1.4,
                color: HbColors.textPrimary,
              ),
            )
          : isUser
              // User messages: simple text
              ? SelectableText(
                  displayText,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.4,
                    color: Colors.white,
                  ),
                )
              // Assistant messages: Markdown formatted
              : MarkdownBody(
                  data: displayText,
                  selectable: true,
                  onTapLink: (text, href, title) {
                    if (href != null) {
                      launchUrl(Uri.parse(href), mode: LaunchMode.externalApplication);
                    }
                  },
                  styleSheet: MarkdownStyleSheet(
                    p: const TextStyle(
                      fontSize: 15,
                      height: 1.4,
                      color: HbColors.textPrimary,
                    ),
                    strong: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: HbColors.textPrimary,
                    ),
                    em: const TextStyle(
                      fontStyle: FontStyle.italic,
                      color: HbColors.textPrimary,
                    ),
                    code: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13,
                      backgroundColor: Colors.grey.shade100,
                      color: HbColors.textPrimary,
                    ),
                    codeblockDecoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    listBullet: const TextStyle(
                      color: HbColors.textPrimary,
                    ),
                    a: const TextStyle(
                      color: HbColors.brandPrimary,
                      decoration: TextDecoration.underline,
                    ),
                    h1: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: HbColors.textPrimary,
                    ),
                    h2: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: HbColors.textPrimary,
                    ),
                    h3: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: HbColors.textPrimary,
                    ),
                    blockquoteDecoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: HbColors.brandPrimary.withOpacity(0.5),
                          width: 3,
                        ),
                      ),
                    ),
                    blockquotePadding: const EdgeInsets.only(left: 12),
                  ),
                ),
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
