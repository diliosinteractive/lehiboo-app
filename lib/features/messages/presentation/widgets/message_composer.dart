import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

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
  late final String? _ownerAccountId;
  bool _sessionInvalid = false;

  static const _primaryColor = Color(0xFFFF601F);

  @override
  void initState() {
    super.initState();
    _ownerAccountId = ref.read(authSessionUserIdProvider);
  }

  @override
  void didUpdateWidget(covariant MessageComposer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.conversationUuid != widget.conversationUuid) {
      _textController.clear();
      _isSending = false;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  bool get _canSend {
    return _textController.text.trim().isNotEmpty &&
        !_isSending &&
        !widget.disabled &&
        _ownsCurrentAccount;
  }

  bool get _ownsCurrentAccount =>
      !_sessionInvalid &&
      _ownerAccountId != null &&
      ref.read(authSessionUserIdProvider) == _ownerAccountId;

  void _handleAccountChange(String? nextAccountId) {
    if (nextAccountId == _ownerAccountId || _sessionInvalid) return;
    _sessionInvalid = true;
    _textController.clear();
    if (!mounted) return;
    setState(() => _isSending = false);
  }

  Future<void> _send() async {
    if (!_canSend) return;
    final content = _textController.text.trim();
    setState(() {
      _isSending = true;
      _textController.clear();
    });
    try {
      if (_ownsCurrentAccount) {
        widget.onSend(content.isEmpty ? null : content);
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<String?>(authSessionUserIdProvider, (_, next) {
      _handleAccountChange(next);
    });
    final currentAccountId = ref.watch(authSessionUserIdProvider);
    if (_sessionInvalid ||
        _ownerAccountId == null ||
        currentAccountId != _ownerAccountId) {
      return const SizedBox.shrink(
        key: Key('message-composer-session-invalid'),
      );
    }

    if (widget.disabled) {
      return Container(
        padding: EdgeInsets.fromLTRB(
            16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
        color: Colors.grey.shade100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, size: 16, color: Colors.grey),
            const SizedBox(width: 8),
            Text(
              context.l10n.messagesComposerClosed,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
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
                  buildCounter: (_,
                          {required currentLength,
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
                    hintText: context.l10n.messagesComposerHint,
                    hintStyle:
                        TextStyle(color: Colors.grey.shade400, fontSize: 14),
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
                    color: _canSend ? _primaryColor : Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: _isSending
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
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
