import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/themes/petit_boo_theme.dart';
import '../../../../core/utils/speech_recognition_error_message.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/petit_boo_chat_provider.dart';
import 'animated_toast.dart';

/// Modern input bar for Petit Boo chat - Style Web 2026
/// Inspiré du design assistant web avec ombre, disclaimer et bouton intégré
class ChatInputBar extends ConsumerStatefulWidget {
  const ChatInputBar({
    super.key,
    this.initializeSpeechOnMount = true,
  });

  /// Exposed so widget tests can exercise draft lifecycle without invoking
  /// platform permission channels. Production callers keep the default.
  final bool initializeSpeechOnMount;

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
  late String _draftOwnerKey;
  int _sessionEpoch = 0;

  String _ownerKey(String? accountId) =>
      accountId == null ? 'anonymous' : 'account:$accountId';

  bool _ownsSession(int epoch, String ownerKey) {
    return mounted &&
        epoch == _sessionEpoch &&
        ownerKey == _draftOwnerKey &&
        _ownerKey(ref.read(authSessionUserIdProvider)) == ownerKey;
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
    _speech = stt.SpeechToText();
    _draftOwnerKey = _ownerKey(ref.read(authSessionUserIdProvider));
    ref.listenManual<String?>(authSessionUserIdProvider, (previous, next) {
      final nextOwnerKey = _ownerKey(next);
      if (nextOwnerKey != _draftOwnerKey) {
        _resetDraftForOwner(nextOwnerKey);
      }
    });
    if (widget.initializeSpeechOnMount) {
      unawaited(_initSpeech());
    }
  }

  @override
  void dispose() {
    _sessionEpoch++;
    _controller.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    unawaited(_cancelSpeechSilently());
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (!mounted) return;
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  void _resetDraftForOwner(String nextOwnerKey) {
    _sessionEpoch++;
    _draftOwnerKey = nextOwnerKey;

    _controller.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    _controller.clear();
    _focusNode.unfocus();
    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);

    unawaited(_cancelSpeechSilently());
    if (!mounted) return;
    setState(() {
      _hasText = false;
      _isFocused = false;
      _isListening = false;
      _speechEnabled = false;
    });
  }

  Future<void> _cancelSpeechSilently() async {
    try {
      await _speech.cancel();
    } catch (_) {
      // The platform channel may already be gone during widget disposal.
    }
  }

  Future<void> _initSpeech() async {
    final epoch = _sessionEpoch;
    final ownerKey = _draftOwnerKey;
    try {
      var micStatus = await Permission.microphone.status;
      if (!_ownsSession(epoch, ownerKey)) return;
      if (!micStatus.isGranted) {
        micStatus = await Permission.microphone.request();
        if (!_ownsSession(epoch, ownerKey)) return;
        if (!micStatus.isGranted) {
          _showSpeechError(
            'error_permission',
            epoch: epoch,
            ownerKey: ownerKey,
          );
          if (micStatus.isPermanentlyDenied) {
            await openAppSettings();
          }
          return;
        }
      }

      var speechStatus = await Permission.speech.status;
      if (!_ownsSession(epoch, ownerKey)) return;
      if (!speechStatus.isGranted) {
        speechStatus = await Permission.speech.request();
        if (!_ownsSession(epoch, ownerKey)) return;
        if (!speechStatus.isGranted) {
          _showSpeechError(
            'error_permission',
            epoch: epoch,
            ownerKey: ownerKey,
          );
          if (speechStatus.isPermanentlyDenied) {
            await openAppSettings();
          }
          return;
        }
      }

      final enabled = await _speech.initialize(
        onStatus: (status) {
          if (!_ownsSession(epoch, ownerKey)) return;
          if (status == 'notListening' || status == 'done') {
            setState(() => _isListening = false);
          }
        },
        onError: (errorNotification) {
          _showSpeechError(
            errorNotification.errorMsg,
            epoch: epoch,
            ownerKey: ownerKey,
          );
        },
      );
      if (!_ownsSession(epoch, ownerKey)) return;
      setState(() => _speechEnabled = enabled);
      if (!enabled) {
        _showSpeechError(null, epoch: epoch, ownerKey: ownerKey);
      }
    } catch (e) {
      debugPrint('Speech init error: $e');
      _showSpeechError(e, epoch: epoch, ownerKey: ownerKey);
    }
  }

  void _showSpeechError(
    Object? code, {
    required int epoch,
    required String ownerKey,
  }) {
    if (!_ownsSession(epoch, ownerKey)) return;
    setState(() => _isListening = false);
    PetitBooToast.error(
      context,
      speechRecognitionErrorMessage(context.l10n, code),
    );
  }

  Future<void> _startListening() async {
    final epoch = _sessionEpoch;
    final ownerKey = _draftOwnerKey;
    final localeId = context.appLocaleName;
    if (!_ownsSession(epoch, ownerKey)) return;
    if (!_speechEnabled) {
      await _initSpeech();
      if (!_ownsSession(epoch, ownerKey) || !_speechEnabled) return;
    }

    if (_isListening) {
      unawaited(_stopListening());
      return;
    }

    setState(() => _isListening = true);
    try {
      final started = await _speech.listen(
        onResult: (result) {
          if (!_ownsSession(epoch, ownerKey) || !_isListening) return;

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
        localeId: localeId,
      );
      if (!_ownsSession(epoch, ownerKey)) return;
      if (!started) {
        _showSpeechError(null, epoch: epoch, ownerKey: ownerKey);
      }
    } catch (e) {
      debugPrint('Speech listen error: $e');
      _showSpeechError(e, epoch: epoch, ownerKey: ownerKey);
    }
  }

  Future<void> _stopListening() async {
    final epoch = _sessionEpoch;
    final ownerKey = _draftOwnerKey;
    if (_ownsSession(epoch, ownerKey)) {
      setState(() => _isListening = false);
    }
    try {
      await _speech.stop();
    } catch (e) {
      debugPrint('Speech stop error: $e');
      _showSpeechError(e, epoch: epoch, ownerKey: ownerKey);
    }
  }

  void _onTextChanged() {
    if (!mounted) return;
    final hasText = _controller.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  void _sendMessage() {
    if (_ownerKey(ref.read(authSessionUserIdProvider)) != _draftOwnerKey) {
      return;
    }
    if (!ref.read(petitBooChatProvider).canSendMessage) return;

    if (_isListening) {
      unawaited(_stopListening());
    }

    final message = _controller.text.trim();
    if (message.isEmpty) return;

    ref.read(petitBooChatProvider.notifier).sendMessage(message);
    _controller.clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final chatState = ref.watch(petitBooChatProvider);
    final isInputDisabled = chatState.isStreaming || chatState.isLoading;
    final isActionDisabled = !chatState.canSendMessage;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
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
                      ? (_isListening
                          ? PetitBooTheme.error
                          : PetitBooTheme.primary)
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
                      key: const ValueKey('petit-boo-chat-input'),
                      controller: _controller,
                      focusNode: _focusNode,
                      maxLines: 1,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      enabled: !isInputDisabled,
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
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: PetitBooTheme.spacing24,
                          vertical: PetitBooTheme.spacing16,
                        ),
                      ),
                    ),
                  ),
                  // Send/Mic button
                  Padding(
                    padding: const EdgeInsets.only(
                      right: PetitBooTheme.spacing8,
                    ),
                    child: _buildActionButton(isActionDisabled),
                  ),
                ],
              ),
            ),
            // Disclaimer text
            Padding(
              padding: const EdgeInsets.only(top: PetitBooTheme.spacing10),
              child: Text(
                l10n.petitBooDisclaimer,
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
    final l10n = context.l10n;
    if (_isListening) return l10n.petitBooChatHintListening;
    if (isStreaming) return l10n.petitBooChatHintStreaming;
    return l10n.petitBooChatHintIdle;
  }

  Widget _buildActionButton(bool isDisabled) {
    const size = 48.0;

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
