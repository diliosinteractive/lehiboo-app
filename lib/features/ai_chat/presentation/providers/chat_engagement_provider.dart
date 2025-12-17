import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chat_provider.dart';

// -----------------------------------------------------------------------------
// STATE
// -----------------------------------------------------------------------------
class EngagementState {
  final String? currentBubbleMessage;
  final bool isVisible;
  final bool hasClickedChatToday;

  const EngagementState({
    this.currentBubbleMessage,
    this.isVisible = false,
    this.hasClickedChatToday = false,
  });

  EngagementState copyWith({
    String? currentBubbleMessage,
    bool? isVisible,
    bool? hasClickedChatToday,
  }) {
    return EngagementState(
      currentBubbleMessage: currentBubbleMessage,
      isVisible: isVisible ?? this.isVisible,
      hasClickedChatToday: hasClickedChatToday ?? this.hasClickedChatToday,
    );
  }
}

// -----------------------------------------------------------------------------
// PROVIDER
// -----------------------------------------------------------------------------
final chatEngagementProvider = StateNotifierProvider<ChatEngagementNotifier, EngagementState>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ChatEngagementNotifier(prefs);
});

// -----------------------------------------------------------------------------
// NOTIFIER
// -----------------------------------------------------------------------------
class ChatEngagementNotifier extends StateNotifier<EngagementState> {
  final SharedPreferences _prefs;
  Timer? _bubbleTimer;
  DateTime? _lastActionTime;
  int _pageViewCount = 0;
  
  static const String _kLastChatClickKey = 'last_chat_click_date';

  ChatEngagementNotifier(this._prefs) : super(const EngagementState()) {
    _init();
  }

  void _init() {
    final lastClickStr = _prefs.getString(_kLastChatClickKey);
    bool clickedToday = false;
    
    if (lastClickStr != null) {
      final lastClick = DateTime.tryParse(lastClickStr);
      if (lastClick != null) {
        final now = DateTime.now();
        clickedToday = lastClick.year == now.year && 
                       lastClick.month == now.month && 
                       lastClick.day == now.day;
      }
    }

    state = state.copyWith(hasClickedChatToday: clickedToday);
    _lastActionTime = DateTime.now(); // Reset idle timer base
  }

  // --- ACTIONS ---

  void onUserClickChat() {
    // Save today's date
    _prefs.setString(_kLastChatClickKey, DateTime.now().toIso8601String());
    
    // Hide bubble immediately and permanently for today
    _hideBubble();
    state = state.copyWith(hasClickedChatToday: true);
  }

  void onAppStart() {
    if (state.hasClickedChatToday) return;

    // Rule: "Bonjour" after 5 seconds on fresh start
    Future.delayed(const Duration(seconds: 5), () {
      if (!state.hasClickedChatToday) {
        _showBubble("Bonjour ! Je peux vous aider ? 🌟", duration: const Duration(seconds: 6));
      }
    });
  }

  void onNavigation() {
    if (state.hasClickedChatToday) return;

    _pageViewCount++;
    _lastActionTime = DateTime.now(); // Not idle if navigating

    // Rule: High Activity without chat? (Every 5 pages)
    if (_pageViewCount > 0 && _pageViewCount % 8 == 0) {
       _showBubble("Vous cherchez l'inspiration ? 💡");
    }
  }

  void onSearchEmpty() {
    if (state.hasClickedChatToday) return;

    // Rule: Zero Results -> Immediate Help
    // This is high priority, overrides others
    _showBubble("Oups, rien trouvé ? Je peux chercher pour vous ! 🕵️‍♂️", duration: const Duration(seconds: 8));
  }

  void checkIdle() {
    if (state.hasClickedChatToday) return;
    if (state.isVisible) return; // Already showing something

    // Rule: Idle for > 20s
    if (_lastActionTime != null && 
        DateTime.now().difference(_lastActionTime!) > const Duration(seconds: 20)) {
       
       // Only show if we haven't shown recently? 
       // For simplicity, let's just show a gentle reminder once per session or randomized
       // Here we rely on the external timer calling simple randomness
       
       if (DateTime.now().second % 30 == 0) { // Random chance check
          _showBubble("Psst... Je connais des coins sympas ! 🗺️");
       }
    }
  }

  // --- INTERNAL ---

  void _showBubble(String message, {Duration duration = const Duration(seconds: 5)}) {
    if (state.hasClickedChatToday) return;

    state = state.copyWith(
      currentBubbleMessage: message,
      isVisible: true,
    );

    _bubbleTimer?.cancel();
    _bubbleTimer = Timer(duration, () {
      _hideBubble();
    });
  }

  void _hideBubble() {
    state = state.copyWith(isVisible: false);
  }
  
  @override
  void dispose() {
    _bubbleTimer?.cancel();
    super.dispose();
  }
}
