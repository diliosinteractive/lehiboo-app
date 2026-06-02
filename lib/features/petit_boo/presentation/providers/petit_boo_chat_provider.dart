import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/dio_client.dart';
import '../../../../core/analytics/analytics_event.dart';
import '../../../../core/analytics/analytics_provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/l10n/app_locale.dart';
import '../../../../core/providers/shared_preferences_provider.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/petit_boo_context_storage.dart';
import '../../data/datasources/petit_boo_sse_datasource.dart';
import '../../data/models/chat_message_dto.dart';
import '../../data/models/quota_dto.dart';
import '../../data/models/tool_result_dto.dart';
import '../../domain/repositories/petit_boo_repository.dart';

const _genericPetitBooError =
    'Petit Boo est temporairement indisponible. Réessaie dans un instant.';

String _safePetitBooErrorMessage(
  Object? error, {
  String fallback = _genericPetitBooError,
}) {
  final raw = (error ?? '').toString().trim();
  if (raw.isEmpty) return fallback;

  final lower = raw.toLowerCase();
  final exposesProviderDetails = lower.contains('openai') ||
      lower.contains('deepseek') ||
      lower.contains('platform.') ||
      lower.contains('api.openai') ||
      lower.contains('insufficient_quota') ||
      lower.contains('billing') ||
      lower.contains('error code:') ||
      lower.contains('model') ||
      lower.contains('provider') ||
      lower.contains('langchain') ||
      lower.contains('traceback');

  if (exposesProviderDetails) return fallback;

  return raw;
}

/// Provider for the context storage
final petitBooContextStorageProvider = Provider<PetitBooContextStorage>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return PetitBooContextStorage(prefs);
});

/// Sentinel value to distinguish "not provided" from "explicitly null"
const _notProvided = Object();

/// State-changing Petit Boo action waiting for explicit user confirmation.
class PetitBooPendingConfirmation {
  final String actionId;
  final String tool;
  final Map<String, dynamic> arguments;
  final String message;
  final String? expiresAt;

  const PetitBooPendingConfirmation({
    required this.actionId,
    required this.tool,
    required this.arguments,
    required this.message,
    this.expiresAt,
  });
}

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
  final PetitBooPendingConfirmation? pendingConfirmation;
  final bool isConfirmingAction;

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
    this.pendingConfirmation,
    this.isConfirmingAction = false,
  });

  /// copyWith preserves error by default.
  /// To explicitly clear error, pass error: null.
  /// To preserve error, don't pass the error parameter.
  PetitBooChatState copyWith({
    List<ChatMessageDto>? messages,
    String? currentStreamingText,
    List<ToolResultDto>? currentToolResults,
    bool? isStreaming,
    bool? isLoading,
    String? sessionUuid,
    Object? error = _notProvided,
    QuotaDto? quota,
    bool? isServiceAvailable,
    Map<String, dynamic>? userContext,
    bool? isMemoryEnabled,
    bool? isLimitReached,
    int? messageCount,
    Object? pendingConfirmation = _notProvided,
    bool? isConfirmingAction,
  }) {
    return PetitBooChatState(
      messages: messages ?? this.messages,
      currentStreamingText: currentStreamingText ?? this.currentStreamingText,
      currentToolResults: currentToolResults ?? this.currentToolResults,
      isStreaming: isStreaming ?? this.isStreaming,
      isLoading: isLoading ?? this.isLoading,
      sessionUuid: sessionUuid ?? this.sessionUuid,
      error: error == _notProvided ? this.error : error as String?,
      quota: quota ?? this.quota,
      isServiceAvailable: isServiceAvailable ?? this.isServiceAvailable,
      userContext: userContext ?? this.userContext,
      isMemoryEnabled: isMemoryEnabled ?? this.isMemoryEnabled,
      isLimitReached: isLimitReached ?? this.isLimitReached,
      messageCount: messageCount ?? this.messageCount,
      pendingConfirmation: pendingConfirmation == _notProvided
          ? this.pendingConfirmation
          : pendingConfirmation as PetitBooPendingConfirmation?,
      isConfirmingAction: isConfirmingAction ?? this.isConfirmingAction,
    );
  }

  /// Check if user can send a message
  bool get canSendMessage =>
      !isStreaming &&
      !isLoading &&
      isServiceAvailable &&
      !isLimitReached &&
      !(quota?.isExhausted ?? false);

  /// Get combined tool results from current streaming
  bool get hasToolResults => currentToolResults.isNotEmpty;
}

/// Provider for the chat state notifier
/// Note: NOT autoDispose to preserve session across navigations
final petitBooChatProvider =
    StateNotifierProvider<PetitBooChatNotifier, PetitBooChatState>(
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
  String? _activeMessage; // Message currently being streamed
  bool _isInitialized = false;

  PetitBooChatNotifier(this._repository, this._contextStorage, this._ref)
      : super(const PetitBooChatState(isLoading: true)) {
    _initialize();
    // Petit Boo holds the user's name, kids' ages, and chat history in
    // memory. Persisted copies are wiped by AuthNotifier._clearPersistedUserData
    // — we still need to drop the in-memory mirror so the previous user's
    // messages don't render until next pull.
    _ref.listen<AuthStatus>(
      authProvider.select((s) => s.status),
      (previous, next) {
        final loggedOut = next == AuthStatus.unauthenticated &&
            previous == AuthStatus.authenticated;
        final loggedIn = next == AuthStatus.authenticated &&
            previous != AuthStatus.authenticated &&
            previous != AuthStatus.initial;
        if (loggedOut) {
          _streamSubscription?.cancel();
          _pendingMessage = null;
          _activeMessage = null;
          _isInitialized = false;
          state = const PetitBooChatState();
        } else if (loggedIn) {
          _isInitialized = false;
          _initialize();
        }
      },
    );
  }

  // ==================== Getters for Brain Screen ====================

  /// Get user context for display in Brain screen
  Map<String, dynamic> get userContext => _contextStorage.getContext();

  /// Check if memory is enabled
  bool get isMemoryEnabled => _contextStorage.getMemoryEnabled();

  AppLocalizations get _l10n => lookupAppLocalizations(
        Locale(AppLocaleCache.languageCode),
      );

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

    // Load saved session UUID FIRST (critical for session continuity)
    const storage = SharedSecureStorage.instance;
    final savedSessionUuid = await storage.read(
      key: AppConstants.keyPetitBooSessionUuid,
    );

    if (kDebugMode) {
      debugPrint(
          '🤖 PetitBoo: Loaded session UUID from storage: $savedSessionUuid');
    }

    if (savedSessionUuid != null && savedSessionUuid.isNotEmpty) {
      state = state.copyWith(sessionUuid: savedSessionUuid);
    }

    // Mark as initialized BEFORE other async calls
    _isInitialized = true;

    // Check service availability
    await checkServiceAvailability();

    // Load quota
    await checkQuota();

    // Remove loading state
    state = state.copyWith(isLoading: false);
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
      state = state.copyWith(
        quota: quota,
        isLimitReached: quota.isExhausted,
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('🤖 PetitBoo: Failed to load quota: $e');
      }
    }
  }

  /// Send a message and process streaming response
  Future<void> sendMessage(String message) async {
    final trimmedMessage = message.trim();
    if (trimmedMessage.isEmpty ||
        state.isStreaming ||
        state.isLoading ||
        !state.isServiceAvailable) {
      return;
    }

    // Wait for initialization to complete (max 2 seconds)
    int waitCount = 0;
    while (!_isInitialized && waitCount < 20) {
      await Future.delayed(const Duration(milliseconds: 100));
      waitCount++;
    }

    final quota = state.quota;
    if (state.isLimitReached || (quota?.isExhausted ?? false)) {
      savePendingMessage(trimmedMessage);
      _ref.read(analyticsServiceProvider).logEvent(
        AnalyticsEvent.petitbooQuotaReached,
        params: {AnalyticsParam.quotaType: AnalyticsQuotaType.daily},
      );
      return;
    }

    _ref.read(analyticsServiceProvider).logEvent(
      AnalyticsEvent.petitbooMessageSent,
      params: {
        AnalyticsParam.length: trimmedMessage.length,
        AnalyticsParam.isVoice: false,
        if (state.sessionUuid != null)
          AnalyticsParam.sessionUuid: state.sessionUuid!,
      },
    );

    if (kDebugMode) {
      debugPrint('🤖 PetitBoo: sendMessage - sessionUuid=${state.sessionUuid}');
    }

    // Cancel any existing stream
    await _streamSubscription?.cancel();

    // Add user message
    final userMessage = ChatMessageDto.user(trimmedMessage);
    _activeMessage = trimmedMessage;
    state = state.copyWith(
      messages: [...state.messages, userMessage],
      currentStreamingText: '',
      currentToolResults: [],
      isStreaming: true,
      error: null,
      pendingConfirmation: null,
    );

    try {
      final stream = _repository.sendMessage(
        sessionUuid: state.sessionUuid,
        message: trimmedMessage,
        memoryEnabled: state.isMemoryEnabled,
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
          if (kDebugMode) {
            debugPrint(
                '🤖 PetitBoo: Received NEW session UUID=${event.sessionUuid}');
            debugPrint(
                '🤖 PetitBoo: Previous session UUID was=${state.sessionUuid}');
          }
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

          _ref.read(analyticsServiceProvider).logEvent(
            AnalyticsEvent.petitbooToolUsed,
            params: {AnalyticsParam.toolName: event.tool},
          );

          // Sync brain memory to local storage when brain tools are called
          _syncBrainMemoryFromToolResult(event.tool, event.result);
        }
        break;

      case 'confirmation_required':
        _handleConfirmationRequired(event);
        break;

      case 'error':
        // Error during processing
        if (event.code == 'quota_exceeded') {
          _saveActiveMessageAsPending();
          state = state.copyWith(
            messages: _withoutActiveOptimisticMessage(),
            currentStreamingText: '',
            currentToolResults: [],
            error: event.error ?? _l10n.petitBooQuotaExceededError,
            isStreaming: false,
            isLimitReached: true,
          );
          _activeMessage = null;
          checkQuota();
          break;
        }
        state = state.copyWith(
          error: event.error ?? _l10n.petitBooGenericError,
          isStreaming: false,
        );
        break;

      case 'done':
        // Stream completed
        _finishStreaming();
        break;
    }
  }

  void _handleConfirmationRequired(dynamic event) {
    final result = event.result;
    if (result is! Map<String, dynamic>) return;

    final actionId = result['action_id'];
    if (actionId is! String || actionId.isEmpty) return;

    state = state.copyWith(
      pendingConfirmation: PetitBooPendingConfirmation(
        actionId: actionId,
        tool: event.tool as String? ?? '',
        arguments: event.arguments as Map<String, dynamic>? ?? const {},
        message: result['message'] as String? ?? _l10n.petitBooConfirmationBody,
        expiresAt: result['expires_at'] as String?,
      ),
    );
  }

  /// Handle SSE stream error
  void _handleSseError(dynamic error) {
    if (!mounted) return;

    if (kDebugMode) {
      debugPrint('🤖 PetitBoo: Stream error - $error');
    }

    String errorMessage = _l10n.petitBooConnectionError;

    if (error is PetitBooSseException) {
      errorMessage = _safePetitBooErrorMessage(error.message);

      if (error.code == 'auth_required' || error.code == 'auth_invalid') {
        errorMessage = _l10n.petitBooAuthRequiredError;
      } else if (error.code == 'quota_exceeded') {
        errorMessage = _l10n.petitBooQuotaExceededError;
        _saveActiveMessageAsPending();
      }
    }

    state = state.copyWith(
      messages: error is PetitBooSseException && error.code == 'quota_exceeded'
          ? _withoutActiveOptimisticMessage()
          : state.messages,
      error: errorMessage,
      isStreaming: false,
      isLimitReached:
          error is PetitBooSseException && error.code == 'quota_exceeded',
    );
    _activeMessage = null;

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
    if (state.currentStreamingText.isEmpty &&
        state.currentToolResults.isEmpty) {
      state = state.copyWith(isStreaming: false);
      _activeMessage = null;
      return;
    }

    // Create assistant message with tool results
    final assistantMessage = ChatMessageDto.assistant(
      content: state.currentStreamingText,
      toolResults:
          state.currentToolResults.isEmpty ? null : state.currentToolResults,
    );

    state = state.copyWith(
      messages: [...state.messages, assistantMessage],
      currentStreamingText: '',
      currentToolResults: [],
      isStreaming: false,
    );
    _activeMessage = null;

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
      error: _safePetitBooErrorMessage(error),
      isStreaming: false,
    );
    _activeMessage = null;
  }

  /// Save session UUID to secure storage
  Future<void> _saveSessionUuid(String uuid) async {
    try {
      const storage = SharedSecureStorage.instance;
      await storage.write(
          key: AppConstants.keyPetitBooSessionUuid, value: uuid);
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
        error: _l10n.petitBooConversationLoadFailed,
      );
    }
  }

  /// Create a new conversation (clear current state)
  Future<void> createNewSession() async {
    await _streamSubscription?.cancel();

    // Clear saved session UUID
    try {
      const storage = SharedSecureStorage.instance;
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

  /// Confirm the pending Petit Boo action and render its tool result.
  Future<void> confirmPendingAction() async {
    final pending = state.pendingConfirmation;
    if (pending == null || state.isConfirmingAction) return;

    state = state.copyWith(isConfirmingAction: true, error: null);

    try {
      final response = await _repository.confirmPendingAction(pending.actionId);
      final tool = response['tool'] as String? ?? pending.tool;
      final result = response['result'] as Map<String, dynamic>? ??
          <String, dynamic>{'success': false};
      final toolResult = ToolResultDto(
        tool: tool,
        data: result,
        executedAt: DateTime.now().toIso8601String(),
      );
      final assistantMessage = ChatMessageDto.assistant(
        content: _confirmedActionMessage(result),
        toolResults: [toolResult],
      );

      state = state.copyWith(
        messages: [...state.messages, assistantMessage],
        pendingConfirmation: null,
        isConfirmingAction: false,
      );

      _syncBrainMemoryFromToolResult(tool, result);
    } catch (e) {
      state = state.copyWith(
        error: _safePetitBooErrorMessage(
          e,
          fallback: _l10n.petitBooConfirmationError,
        ),
        isConfirmingAction: false,
      );
    }
  }

  /// Cancel the pending Petit Boo action.
  Future<void> cancelPendingAction() async {
    final pending = state.pendingConfirmation;
    if (pending == null || state.isConfirmingAction) return;

    state = state.copyWith(isConfirmingAction: true, error: null);

    try {
      await _repository.cancelPendingAction(pending.actionId);
      state = state.copyWith(
        pendingConfirmation: null,
        isConfirmingAction: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: _safePetitBooErrorMessage(
          e,
          fallback: _l10n.petitBooConfirmationError,
        ),
        isConfirmingAction: false,
      );
    }
  }

  String _confirmedActionMessage(Map<String, dynamic> result) {
    final data = result['data'];
    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String && message.trim().isNotEmpty) {
        return message;
      }
    }

    final message = result['message'];
    if (message is String && message.trim().isNotEmpty) {
      return message;
    }

    final error = result['error'];
    if (error is String && error.trim().isNotEmpty) {
      return error;
    }

    return _l10n.petitBooConfirmationDone;
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
    state = state.copyWith(isLimitReached: false, messageCount: 0, error: null);
    await checkQuota();

    if (state.quota?.isExhausted ?? false) {
      state = state.copyWith(isLimitReached: true);
      return;
    }

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

  void _saveActiveMessageAsPending() {
    final activeMessage = _activeMessage;
    if (activeMessage != null && activeMessage.trim().isNotEmpty) {
      _pendingMessage = activeMessage;
    }
  }

  List<ChatMessageDto> _withoutActiveOptimisticMessage() {
    final activeMessage = _activeMessage;
    if (activeMessage == null || state.messages.isEmpty) {
      return state.messages;
    }

    final last = state.messages.last;
    if (last.isUser && last.content == activeMessage) {
      return state.messages.sublist(0, state.messages.length - 1);
    }

    return state.messages;
  }

  /// Check if there's a pending message
  bool get hasPendingMessage => _pendingMessage != null;

  // ==================== Context Sync ====================

  /// Sync brain memory from tool result to local storage
  /// Called when getBrain or updateBrain tools return data
  void _syncBrainMemoryFromToolResult(
      String toolName, Map<String, dynamic> result) {
    // Normalize tool name (snake_case or camelCase)
    final normalizedTool = toolName.toLowerCase().replaceAll('_', '');

    // Only process brain-related tools
    if (!normalizedTool.contains('brain')) return;

    if (kDebugMode) {
      debugPrint('🧠 PetitBoo: Syncing brain memory from tool $toolName');
      debugPrint('🧠 PetitBoo: Result keys: ${result.keys.toList()}');
    }

    // Extract memory data from result
    // The backend may return data in different formats:
    // - { memory: { family: [...], preferences: [...] } }
    // - { data: { memory: {...} } }
    // - { family: [...], preferences: [...] } directly
    Map<String, dynamic>? memoryData;

    if (result['memory'] is Map<String, dynamic>) {
      memoryData = result['memory'] as Map<String, dynamic>;
    } else if (result['data'] is Map<String, dynamic>) {
      final data = result['data'] as Map<String, dynamic>;
      if (data['memory'] is Map<String, dynamic>) {
        memoryData = data['memory'] as Map<String, dynamic>;
      } else {
        memoryData = data;
      }
    } else {
      // Check if result directly contains brain sections
      final knownSections = [
        'family',
        'location',
        'preferences',
        'constraints'
      ];
      final hasKnownSections = knownSections.any((s) => result.containsKey(s));
      if (hasKnownSections) {
        memoryData = result;
      }
    }

    if (memoryData == null || memoryData.isEmpty) {
      if (kDebugMode) {
        debugPrint('🧠 PetitBoo: No memory data found to sync');
      }
      return;
    }

    // Convert brain sections to flat context keys for local storage
    _syncBrainSectionsToContext(memoryData);
  }

  /// Convert brain sections (family, preferences, etc.) to flat context keys
  Future<void> _syncBrainSectionsToContext(
      Map<String, dynamic> memoryData) async {
    final flatContext = <String, dynamic>{};

    // Family section
    if (memoryData['family'] != null) {
      final family = memoryData['family'];
      if (family is List && family.isNotEmpty) {
        flatContext['family_info'] = family;
        // Try to extract specific info
        for (final item in family) {
          final itemStr = item.toString().toLowerCase();
          if (itemStr.contains('enfant') || itemStr.contains('child')) {
            flatContext['has_children'] = true;
          }
        }
      } else if (family is Map) {
        flatContext['family_info'] = family;
      }
    }

    // Location section
    if (memoryData['location'] != null) {
      final location = memoryData['location'];
      if (location is List && location.isNotEmpty) {
        flatContext['location_info'] = location;
        // Try to extract city
        for (final item in location) {
          final itemStr = item.toString();
          if (itemStr.isNotEmpty && !itemStr.contains(':')) {
            flatContext['city'] = itemStr;
            break;
          }
        }
      } else if (location is String) {
        flatContext['city'] = location;
      }
    }

    // Preferences section
    if (memoryData['preferences'] != null) {
      final prefs = memoryData['preferences'];
      if (prefs is List && prefs.isNotEmpty) {
        flatContext['preferences'] = prefs;
      }
    }

    // Constraints section
    if (memoryData['constraints'] != null) {
      final constraints = memoryData['constraints'];
      if (constraints is List && constraints.isNotEmpty) {
        flatContext['constraints'] = constraints;
        // Check for budget constraints
        for (final item in constraints) {
          final itemStr = item.toString().toLowerCase();
          if (itemStr.contains('budget') ||
              itemStr.contains('argent') ||
              itemStr.contains('économ')) {
            flatContext['budget_preference'] = 'low';
          }
        }
      }
    }

    if (flatContext.isNotEmpty) {
      if (kDebugMode) {
        debugPrint(
            '🧠 PetitBoo: Saving ${flatContext.length} context keys to local storage');
      }
      await _contextStorage.mergeContext(flatContext);
      state = state.copyWith(userContext: _contextStorage.getContext());
    }
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
