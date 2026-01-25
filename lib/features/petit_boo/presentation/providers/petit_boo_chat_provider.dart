import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../config/dio_client.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/providers/shared_preferences_provider.dart';
import '../../data/datasources/petit_boo_context_storage.dart';
import '../../data/datasources/petit_boo_sse_datasource.dart';
import '../../data/models/chat_message_dto.dart';
import '../../data/models/quota_dto.dart';
import '../../data/models/tool_result_dto.dart';
import '../../domain/repositories/petit_boo_repository.dart';

/// Provider for the context storage
final petitBooContextStorageProvider = Provider<PetitBooContextStorage>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return PetitBooContextStorage(prefs);
});

/// State for the Petit Boo chat
class PetitBooChatState {
  final List<ChatMessageDto> messages;
  final String currentStreamingText;
  final List<ToolResultDto> currentToolResults;
  final bool isStreaming;
  final bool isLoading;
  final String? sessionUuid;
  final String? error;
  final QuotaDto? quota;
  final bool isServiceAvailable;
  final Map<String, dynamic> userContext;
  final bool isMemoryEnabled;
  final bool isLimitReached;
  final int messageCount;

  const PetitBooChatState({
    this.messages = const [],
    this.currentStreamingText = '',
    this.currentToolResults = const [],
    this.isStreaming = false,
    this.isLoading = false,
    this.sessionUuid,
    this.error,
    this.quota,
    this.isServiceAvailable = true,
    this.userContext = const {},
    this.isMemoryEnabled = true,
    this.isLimitReached = false,
    this.messageCount = 0,
  });

  PetitBooChatState copyWith({
    List<ChatMessageDto>? messages,
    String? currentStreamingText,
    List<ToolResultDto>? currentToolResults,
    bool? isStreaming,
    bool? isLoading,
    String? sessionUuid,
    String? error,
    QuotaDto? quota,
    bool? isServiceAvailable,
    Map<String, dynamic>? userContext,
    bool? isMemoryEnabled,
    bool? isLimitReached,
    int? messageCount,
  }) {
    return PetitBooChatState(
      messages: messages ?? this.messages,
      currentStreamingText: currentStreamingText ?? this.currentStreamingText,
      currentToolResults: currentToolResults ?? this.currentToolResults,
      isStreaming: isStreaming ?? this.isStreaming,
      isLoading: isLoading ?? this.isLoading,
      sessionUuid: sessionUuid ?? this.sessionUuid,
      error: error,
      quota: quota ?? this.quota,
      isServiceAvailable: isServiceAvailable ?? this.isServiceAvailable,
      userContext: userContext ?? this.userContext,
      isMemoryEnabled: isMemoryEnabled ?? this.isMemoryEnabled,
      isLimitReached: isLimitReached ?? this.isLimitReached,
      messageCount: messageCount ?? this.messageCount,
    );
  }

  /// Check if user can send a message
  bool get canSendMessage =>
      !isStreaming && !isLoading && isServiceAvailable && !isLimitReached;

  /// Get combined tool results from current streaming
  bool get hasToolResults => currentToolResults.isNotEmpty;
}

/// Provider for the chat state notifier
final petitBooChatProvider =
    StateNotifierProvider.autoDispose<PetitBooChatNotifier, PetitBooChatState>(
  (ref) {
    final repository = ref.watch(petitBooRepositoryProvider);
    final contextStorage = ref.watch(petitBooContextStorageProvider);
    return PetitBooChatNotifier(repository, contextStorage, ref);
  },
);

/// StateNotifier for managing Petit Boo chat
class PetitBooChatNotifier extends StateNotifier<PetitBooChatState> {
  final PetitBooRepository _repository;
  final PetitBooContextStorage _contextStorage;
  final Ref _ref;
  StreamSubscription? _streamSubscription;
  String? _pendingMessage; // For auto-send after limit unlock

  PetitBooChatNotifier(this._repository, this._contextStorage, this._ref)
      : super(const PetitBooChatState()) {
    _initialize();
  }

  // ==================== Getters for Brain Screen ====================

  /// Get user context for display in Brain screen
  Map<String, dynamic> get userContext => _contextStorage.getContext();

  /// Check if memory is enabled
  bool get isMemoryEnabled => _contextStorage.getMemoryEnabled();

  // ==================== Brain/Context Methods ====================

  /// Update a single context key
  Future<void> updateContextKey(String key, dynamic value) async {
    if (!_contextStorage.getMemoryEnabled()) return;
    await _contextStorage.updateContextKey(key, value);
    state = state.copyWith(userContext: _contextStorage.getContext());
  }

  /// Remove a context key
  Future<void> removeContextKey(String key) async {
    await _contextStorage.removeContextKey(key);
    state = state.copyWith(userContext: _contextStorage.getContext());
  }

  /// Toggle memory on/off
  Future<void> toggleMemory(bool enabled) async {
    await _contextStorage.setMemoryEnabled(enabled);
    state = state.copyWith(isMemoryEnabled: enabled);
  }

  /// Clear all user context
  Future<void> clearContext() async {
    await _contextStorage.clearContext();
    state = state.copyWith(userContext: {});
  }

  // ==================== Initialization ====================

  Future<void> _initialize() async {
    // Load context from storage
    final context = _contextStorage.getContext();
    final memoryEnabled = _contextStorage.getMemoryEnabled();

    state = state.copyWith(
      userContext: context,
      isMemoryEnabled: memoryEnabled,
    );

    // Load saved session UUID
    final storage = SharedSecureStorage.instance;
    final savedSessionUuid = await storage.read(
      key: AppConstants.keyPetitBooSessionUuid,
    );

    if (savedSessionUuid != null) {
      state = state.copyWith(sessionUuid: savedSessionUuid);
    }

    // Check service availability
    await checkServiceAvailability();

    // Load quota
    await checkQuota();
  }

  /// Check if Petit Boo service is available
  Future<void> checkServiceAvailability() async {
    try {
      final isAvailable = await _repository.isServiceAvailable();
      state = state.copyWith(isServiceAvailable: isAvailable);
    } catch (e) {
      state = state.copyWith(isServiceAvailable: false);
    }
  }

  /// Check user's chat quota
  Future<void> checkQuota() async {
    try {
      final quota = await _repository.getQuota();
      state = state.copyWith(quota: quota);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('🤖 PetitBoo: Failed to load quota: $e');
      }
    }
  }

  /// Send a message and process streaming response
  Future<void> sendMessage(String message) async {
    if (!state.canSendMessage || message.trim().isEmpty) return;

    // Cancel any existing stream
    await _streamSubscription?.cancel();

    // Add user message
    final userMessage = ChatMessageDto.user(message);
    state = state.copyWith(
      messages: [...state.messages, userMessage],
      currentStreamingText: '',
      currentToolResults: [],
      isStreaming: true,
      error: null,
    );

    try {
      final stream = _repository.sendMessage(
        sessionUuid: state.sessionUuid,
        message: message,
      );

      _streamSubscription = stream.listen(
        _handleSseEvent,
        onError: _handleSseError,
        onDone: _handleSseDone,
        cancelOnError: false,
      );
    } catch (e) {
      _handleError(e);
    }
  }

  /// Handle incoming SSE event
  void _handleSseEvent(dynamic event) {
    if (!mounted) return;

    if (kDebugMode) {
      debugPrint('🤖 PetitBoo: Event type=${event.type}');
    }

    switch (event.type) {
      case 'session':
        // New session created, save the UUID
        if (event.sessionUuid != null) {
          _saveSessionUuid(event.sessionUuid!);
          state = state.copyWith(sessionUuid: event.sessionUuid);
        }
        break;

      case 'token':
        // Streaming text token
        if (event.content != null) {
          state = state.copyWith(
            currentStreamingText: state.currentStreamingText + event.content,
          );
        }
        break;

      case 'tool_call':
        // Tool is being called (can show loading indicator for specific tool)
        if (kDebugMode) {
          debugPrint('🤖 PetitBoo: Tool call - ${event.tool}');
        }
        break;

      case 'tool_result':
        // Tool execution result
        if (event.tool != null && event.result != null) {
          final toolResult = ToolResultDto(
            tool: event.tool,
            data: event.result,
            executedAt: DateTime.now().toIso8601String(),
          );
          state = state.copyWith(
            currentToolResults: [...state.currentToolResults, toolResult],
          );
        }
        break;

      case 'error':
        // Error during processing
        state = state.copyWith(
          error: event.error ?? 'An error occurred',
          isStreaming: false,
        );
        break;

      case 'done':
        // Stream completed
        _finishStreaming();
        break;
    }
  }

  /// Handle SSE stream error
  void _handleSseError(dynamic error) {
    if (!mounted) return;

    if (kDebugMode) {
      debugPrint('🤖 PetitBoo: Stream error - $error');
    }

    String errorMessage = 'Erreur de connexion';

    if (error is PetitBooSseException) {
      errorMessage = error.message;

      if (error.code == 'auth_required') {
        errorMessage = 'Connectez-vous pour discuter avec Petit Boo';
      } else if (error.code == 'quota_exceeded') {
        errorMessage = 'Vous avez atteint votre limite de messages';
      }
    }

    state = state.copyWith(
      error: errorMessage,
      isStreaming: false,
    );

    // Refresh quota after error
    checkQuota();
  }

  /// Handle SSE stream completion
  void _handleSseDone() {
    if (!mounted) return;

    if (state.isStreaming) {
      _finishStreaming();
    }
  }

  /// Finish streaming and create assistant message
  void _finishStreaming() {
    if (state.currentStreamingText.isEmpty && state.currentToolResults.isEmpty) {
      state = state.copyWith(isStreaming: false);
      return;
    }

    // Create assistant message with tool results
    final assistantMessage = ChatMessageDto.assistant(
      content: state.currentStreamingText,
      toolResults: state.currentToolResults.isEmpty ? null : state.currentToolResults,
    );

    state = state.copyWith(
      messages: [...state.messages, assistantMessage],
      currentStreamingText: '',
      currentToolResults: [],
      isStreaming: false,
    );

    // Refresh quota after message
    checkQuota();
  }

  /// Handle general error
  void _handleError(dynamic error) {
    if (!mounted) return;

    if (kDebugMode) {
      debugPrint('🤖 PetitBoo: Error - $error');
    }

    state = state.copyWith(
      error: error.toString(),
      isStreaming: false,
    );
  }

  /// Save session UUID to secure storage
  Future<void> _saveSessionUuid(String uuid) async {
    try {
      final storage = SharedSecureStorage.instance;
      await storage.write(key: AppConstants.keyPetitBooSessionUuid, value: uuid);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('🤖 PetitBoo: Failed to save session UUID: $e');
      }
    }
  }

  /// Load an existing conversation
  Future<void> loadSession(String uuid) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final conversation = await _repository.getConversation(uuid);

      state = state.copyWith(
        sessionUuid: conversation.uuid,
        messages: conversation.messages ?? [],
        isLoading: false,
      );

      await _saveSessionUuid(uuid);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Impossible de charger la conversation',
      );
    }
  }

  /// Create a new conversation (clear current state)
  Future<void> createNewSession() async {
    await _streamSubscription?.cancel();

    // Clear saved session UUID
    try {
      final storage = SharedSecureStorage.instance;
      await storage.delete(key: AppConstants.keyPetitBooSessionUuid);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('🤖 PetitBoo: Failed to clear session UUID: $e');
      }
    }

    state = const PetitBooChatState();
    await _initialize();
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Retry last message (remove last user message and resend)
  Future<void> retryLastMessage() async {
    if (state.messages.isEmpty) return;

    // Find last user message
    final lastUserMessageIndex = state.messages.lastIndexWhere((m) => m.isUser);
    if (lastUserMessageIndex == -1) return;

    final lastUserMessage = state.messages[lastUserMessageIndex];
    final messagesBeforeLastUser =
        state.messages.sublist(0, lastUserMessageIndex);

    state = state.copyWith(
      messages: messagesBeforeLastUser,
      error: null,
    );

    await sendMessage(lastUserMessage.content);
  }

  // ==================== Limit/Quota Methods ====================

  /// Reset the message limit (called after spending Hibons or watching ads)
  Future<void> resetLimit() async {
    state = state.copyWith(isLimitReached: false, messageCount: 0);

    // Auto-send pending message if any
    if (_pendingMessage != null) {
      final msg = _pendingMessage!;
      _pendingMessage = null;
      await sendMessage(msg);
    }
  }

  /// Save pending message for later (when limit is reached)
  void savePendingMessage(String message) {
    _pendingMessage = message;
    state = state.copyWith(isLimitReached: true);
  }

  /// Check if there's a pending message
  bool get hasPendingMessage => _pendingMessage != null;

  // ==================== Context Sync ====================

  /// Update context from AI response
  Future<void> _updateContextFromResponse(Map<String, dynamic>? newContext) async {
    if (newContext == null || !state.isMemoryEnabled) return;

    await _contextStorage.mergeContext(newContext);
    state = state.copyWith(userContext: _contextStorage.getContext());
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }
}

/// Provider for just the quota
final petitBooQuotaProvider = Provider<QuotaDto?>((ref) {
  return ref.watch(petitBooChatProvider).quota;
});

/// Provider for checking if user can send messages
final canSendMessageProvider = Provider<bool>((ref) {
  return ref.watch(petitBooChatProvider).canSendMessage;
});
