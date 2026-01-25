import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/themes/colors.dart';
import '../providers/petit_boo_chat_provider.dart';
import 'quota_indicator.dart';

/// Input bar for the Petit Boo chat with speech-to-text support
class ChatInputBar extends ConsumerStatefulWidget {
  const ChatInputBar({super.key});

  @override
  ConsumerState<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends ConsumerState<ChatInputBar> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _hasText = false;

  // Speech-to-text
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _speechEnabled = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
    _speech = stt.SpeechToText();
    _initSpeech();
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// Initialize speech recognition
  Future<void> _initSpeech() async {
    // Check microphone permission
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      await Permission.microphone.request();
    }

    try {
      _speechEnabled = await _speech.initialize(
        onStatus: (status) {
          if (status == 'notListening' || status == 'done') {
            if (mounted) setState(() => _isListening = false);
          }
        },
        onError: (errorNotification) {
          if (mounted) {
            setState(() => _isListening = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Erreur micro: ${errorNotification.errorMsg}'),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
      );
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint("🎙️ Speech init error: $e");
    }
  }

  /// Start listening for speech
  Future<void> _startListening() async {
    if (!_speechEnabled) {
      await _initSpeech();
      return;
    }

    if (_isListening) {
      _stopListening();
      return;
    }

    setState(() => _isListening = true);
    await _speech.listen(
      onResult: (result) {
        // Guard: Ignore late results if we stopped listening
        if (!_isListening) return;

        setState(() {
          _controller.text = result.recognizedWords;
          // Move cursor to end
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: _controller.text.length),
          );
          if (result.finalResult) {
            _isListening = false;
          }
        });
      },
      localeId: "fr_FR",
    );
  }

  /// Stop listening
  Future<void> _stopListening() async {
    setState(() => _isListening = false);
    await _speech.stop();
  }

  void _onTextChanged() {
    final hasText = _controller.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  void _sendMessage() {
    // Stop listening immediately to prevent text updates
    if (_isListening) {
      _stopListening();
    }

    final message = _controller.text.trim();
    if (message.isEmpty) return;

    ref.read(petitBooChatProvider.notifier).sendMessage(message);
    _controller.clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(petitBooChatProvider);
    final canSend = chatState.canSendMessage && _hasText;
    final isDisabled = chatState.isStreaming || chatState.isLoading;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Quota indicator
            if (chatState.quota != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: QuotaIndicator(quota: chatState.quota!),
              ),

            // Input row
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Text input with listening indicator
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 120),
                    decoration: BoxDecoration(
                      color: _isListening
                          ? Colors.red.shade50
                          : HbColors.orangePastel,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: _isListening
                            ? Colors.red.shade200
                            : (_focusNode.hasFocus
                                ? HbColors.brandPrimary.withOpacity(0.3)
                                : Colors.transparent),
                        width: 1.5,
                      ),
                    ),
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      enabled: !isDisabled,
                      decoration: InputDecoration(
                        hintText: _isListening
                            ? 'Je vous écoute...'
                            : (chatState.isStreaming
                                ? 'Petit Boo réfléchit...'
                                : 'Posez une question à Petit Boo...'),
                        hintStyle: TextStyle(
                          color: _isListening
                              ? Colors.red.shade400
                              : HbColors.textSecondary.withOpacity(0.6),
                          fontSize: 15,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 15,
                        color: HbColors.textPrimary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Dynamic button: Mic or Send
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 48,
                  height: 48,
                  child: Material(
                    color: _getButtonColor(canSend, isDisabled),
                    borderRadius: BorderRadius.circular(24),
                    child: InkWell(
                      onTap: isDisabled ? null : _onButtonTap,
                      borderRadius: BorderRadius.circular(24),
                      child: Icon(
                        _getButtonIcon(canSend),
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Get the button color based on state
  Color _getButtonColor(bool canSend, bool isDisabled) {
    if (isDisabled) return Colors.grey.shade300;
    if (_hasText) return HbColors.brandPrimary;
    if (_isListening) return Colors.red;
    return Colors.grey.shade400;
  }

  /// Get the button icon based on state
  IconData _getButtonIcon(bool canSend) {
    if (_hasText) return Icons.arrow_upward_rounded;
    if (_isListening) return Icons.stop_rounded;
    return Icons.mic_rounded;
  }

  /// Handle button tap (send or toggle mic)
  void _onButtonTap() {
    if (_hasText) {
      _sendMessage();
    } else {
      _startListening();
    }
  }
}
