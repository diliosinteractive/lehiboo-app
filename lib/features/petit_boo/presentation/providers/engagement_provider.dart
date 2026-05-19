import 'dart:async';
import 'dart:ui' show Locale;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/l10n/app_locale.dart';
import '../../../../core/providers/shared_preferences_provider.dart';
import '../../../../l10n/generated/app_localizations.dart';

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
final petitBooEngagementProvider =
    StateNotifierProvider<PetitBooEngagementNotifier, EngagementState>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return PetitBooEngagementNotifier(prefs);
});

// -----------------------------------------------------------------------------
// NOTIFIER
// -----------------------------------------------------------------------------
class PetitBooEngagementNotifier extends StateNotifier<EngagementState> {
  final SharedPreferences _prefs;
  Timer? _bubbleTimer;
  DateTime? _lastActionTime;
  int _pageViewCount = 0;

  static const String _kLastChatClickKey = 'petit_boo_last_click_date';

  PetitBooEngagementNotifier(this._prefs) : super(const EngagementState()) {
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
    _lastActionTime = DateTime.now();
  }

  // --- ACTIONS ---

  void onUserClickChat() {
    _prefs.setString(_kLastChatClickKey, DateTime.now().toIso8601String());
    _hideBubble();
    state = state.copyWith(hasClickedChatToday: true);
  }

  void onAppStart() {
    if (state.hasClickedChatToday) return;

    // Show welcome bubble after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (!state.hasClickedChatToday && mounted) {
        _showBubble(
          _l10n.petitBooEngagementWelcome,
          duration: const Duration(seconds: 6),
        );
      }
    });
  }

  void onNavigation() {
    if (state.hasClickedChatToday) return;

    _pageViewCount++;
    _lastActionTime = DateTime.now();

    // High activity without chat - every 8 pages
    if (_pageViewCount > 0 && _pageViewCount % 8 == 0) {
      _showBubble(_l10n.petitBooEngagementInspiration);
    }
  }

  void onSearchEmpty() {
    if (state.hasClickedChatToday) return;

    // Zero results -> immediate help
    _showBubble(
      _l10n.petitBooEngagementNoResults,
      duration: const Duration(seconds: 8),
    );
  }

  void checkIdle() {
    if (state.hasClickedChatToday) return;
    if (state.isVisible) return;

    // Idle for > 20s
    if (_lastActionTime != null &&
        DateTime.now().difference(_lastActionTime!) >
            const Duration(seconds: 20)) {
      if (DateTime.now().second % 30 == 0) {
        _showBubble(_l10n.petitBooEngagementIdle);
      }
    }
  }

  // --- INTERNAL ---

  void _showBubble(String message,
      {Duration duration = const Duration(seconds: 5)}) {
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

  AppLocalizations get _l10n => lookupAppLocalizations(
        Locale(AppLocaleCache.languageCode),
      );

  void _hideBubble() {
    state = state.copyWith(isVisible: false);
  }

  @override
  void dispose() {
    _bubbleTimer?.cancel();
    super.dispose();
  }
}
