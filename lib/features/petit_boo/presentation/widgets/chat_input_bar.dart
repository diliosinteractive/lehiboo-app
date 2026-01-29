import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/themes/petit_boo_theme.dart';
import '../providers/petit_boo_chat_provider.dart';
import 'animated_toast.dart';

/// Modern input bar for Petit Boo chat - Style Web 2026
/// Inspiré du design assistant web avec ombre, disclaimer et bouton intégré
class ChatInputBar extends ConsumerStatefulWidget {
  const ChatInputBar({super.key});

  @override
  ConsumerState<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends ConsumerState<ChatInputBar> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _hasText = false;
  bool _isFocused = false;

  // Speech-to-text
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _speechEnabled = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
    _speech = stt.SpeechToText();
    _initSpeech();
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  Future<void> _initSpeech() async {
    var micStatus = await Permission.microphone.status;
    if (!micStatus.isGranted) {
      micStatus = await Permission.microphone.request();
      if (micStatus.isPermanentlyDenied) {
        openAppSettings();
        return;
      }
    }

    var speechStatus = await Permission.speech.status;
    if (!speechStatus.isGranted) {
      speechStatus = await Permission.speech.request();
      if (speechStatus.isPermanentlyDenied) {
        openAppSettings();
        return;
      }
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
            PetitBooToast.error(context, 'Erreur micro: ${errorNotification.errorMsg}');
          }
        },
      );
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint("Speech init error: $e");
    }
  }

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
        if (!_isListening) return;

        setState(() {
          _controller.text = result.recognizedWords;
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

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          PetitBooTheme.spacing16,
          PetitBooTheme.spacing12,
          PetitBooTheme.spacing16,
          PetitBooTheme.spacing8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Input container style web avec ombre et border focus
            AnimatedContainer(
              duration: PetitBooTheme.durationFast,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: PetitBooTheme.surface,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: _isFocused || _isListening
                      ? (_isListening ? PetitBooTheme.error : PetitBooTheme.primary)
                      : Colors.transparent,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Text input
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      maxLines: 1,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      enabled: !isDisabled,
                      style: PetitBooTheme.bodyLg.copyWith(
                        color: PetitBooTheme.textPrimary,
                      ),
                      cursorColor: PetitBooTheme.primary,
                      decoration: InputDecoration(
                        hintText: _getHintText(chatState.isStreaming),
                        hintStyle: PetitBooTheme.bodyLg.copyWith(
                          color: _isListening
                              ? PetitBooTheme.error
                              : PetitBooTheme.textTertiary,
                        ),
                        filled: false,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: PetitBooTheme.spacing24,
                          vertical: PetitBooTheme.spacing16,
                        ),
                      ),
                    ),
                  ),
                  // Send/Mic button
                  Padding(
                    padding: EdgeInsets.only(right: PetitBooTheme.spacing8),
                    child: _buildActionButton(canSend, isDisabled),
                  ),
                ],
              ),
            ),
            // Disclaimer text
            Padding(
              padding: EdgeInsets.only(top: PetitBooTheme.spacing10),
              child: Text(
                "L'IA peut commettre des erreurs. Vérifiez les informations importantes.",
                style: PetitBooTheme.caption.copyWith(
                  color: PetitBooTheme.textTertiary,
                  fontSize: 11,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getHintText(bool isStreaming) {
    if (_isListening) return 'Je vous écoute...';
    if (isStreaming) return 'Petit Boo réfléchit...';
    return "Posez une question à votre assistant ou tapez '/' pour les commandes...";
  }

  Widget _buildActionButton(bool canSend, bool isDisabled) {
    final size = 48.0;

    return AnimatedContainer(
      duration: PetitBooTheme.durationFast,
      width: size,
      height: size,
      child: Material(
        color: _getButtonColor(isDisabled),
        shape: const CircleBorder(),
        elevation: _hasText ? 2 : 0,
        shadowColor: PetitBooTheme.primary.withValues(alpha: 0.3),
        child: InkWell(
          onTap: isDisabled ? null : _onButtonTap,
          customBorder: const CircleBorder(),
          child: Center(
            child: AnimatedSwitcher(
              duration: PetitBooTheme.durationFast,
              child: Icon(
                _getButtonIcon(),
                key: ValueKey(_getButtonIcon()),
                color: PetitBooTheme.textOnPrimary,
                size: 22,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getButtonColor(bool isDisabled) {
    if (isDisabled) return PetitBooTheme.grey300;
    if (_hasText) return PetitBooTheme.primary;
    if (_isListening) return PetitBooTheme.error;
    // Couleur orange pastel quand pas de texte (comme le web)
    return PetitBooTheme.primary.withValues(alpha: 0.6);
  }

  IconData _getButtonIcon() {
    if (_hasText) return Icons.arrow_forward_rounded;
    if (_isListening) return Icons.stop_rounded;
    return Icons.mic_rounded;
  }

  void _onButtonTap() {
    if (_hasText) {
      _sendMessage();
    } else {
      _startListening();
    }
  }
}
