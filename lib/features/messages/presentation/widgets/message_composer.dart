import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageComposer extends ConsumerStatefulWidget {
  final String conversationUuid;
  final bool disabled;
  final bool isSupport;
  final void Function(String? content) onSend;

  const MessageComposer({
    super.key,
    required this.conversationUuid,
    required this.onSend,
    this.disabled = false,
    this.isSupport = false,
  });

  @override
  ConsumerState<MessageComposer> createState() => _MessageComposerState();
}

class _MessageComposerState extends ConsumerState<MessageComposer> {
  final _textController = TextEditingController();
  bool _isSending = false;

  static const _primaryColor = Color(0xFFFF601F);

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  bool get _canSend {
    return _textController.text.trim().isNotEmpty && !_isSending && !widget.disabled;
  }

  Future<void> _send() async {
    if (!_canSend) return;
    final content = _textController.text.trim();
    setState(() {
      _isSending = true;
      _textController.clear();
    });
    try {
      widget.onSend(content.isEmpty ? null : content);
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.disabled) {
      return Container(
        padding: EdgeInsets.fromLTRB(
            16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
        color: Colors.grey.shade100,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_outline, size: 16, color: Colors.grey),
            SizedBox(width: 8),
            Text('Cette conversation est fermée',
                style: TextStyle(color: Colors.grey, fontSize: 13)),
          ],
        ),
      );
    }

    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 8, 10, 8 + bottomPad),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Pill-shaped text input
            Expanded(
              child: Container(
                constraints: const BoxConstraints(minHeight: 48),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F7),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _textController,
                  onChanged: (_) => setState(() {}),
                  maxLines: 5,
                  minLines: 1,
                  maxLength: 2000,
                  buildCounter: (_, {required currentLength,
                        required isFocused,
                        maxLength}) =>
                      currentLength >= 1800
                          ? Text(
                              '$currentLength / 2000',
                              style: TextStyle(
                                fontSize: 10,
                                color: currentLength >= 1950
                                    ? Colors.red
                                    : Colors.grey.shade500,
                              ),
                            )
                          : null,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: 'Votre message…',
                    hintStyle: TextStyle(
                        color: Colors.grey.shade400, fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Circular send button
            AnimatedScale(
              scale: _canSend ? 1.0 : 0.85,
              duration: const Duration(milliseconds: 150),
              child: GestureDetector(
                onTap: _canSend ? _send : null,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _canSend
                        ? _primaryColor
                        : Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: _isSending
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white),
                          )
                        : const Icon(Icons.send_rounded,
                            color: Colors.white, size: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
