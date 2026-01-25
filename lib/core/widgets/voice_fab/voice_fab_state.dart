import 'package:flutter_riverpod/flutter_riverpod.dart';

/// États possibles du VoiceFab
enum VoiceFabStatus {
  /// État normal, FAB classique
  idle,
  /// Tooltip visible "Maintiens pour parler"
  hintShown,
  /// Écoute active, animations en cours
  listening,
  /// Transcription terminée, navigation en cours
  processing,
  /// Erreur (permission refusée, etc.)
  error,
}

/// État complet du VoiceFab
class VoiceFabState {
  final VoiceFabStatus status;
  final String? transcription;
  final String? errorMessage;
  final bool hasShownHint;

  const VoiceFabState({
    this.status = VoiceFabStatus.idle,
    this.transcription,
    this.errorMessage,
    this.hasShownHint = false,
  });

  bool get isListening => status == VoiceFabStatus.listening;
  bool get isProcessing => status == VoiceFabStatus.processing;
  bool get hasError => status == VoiceFabStatus.error;

  VoiceFabState copyWith({
    VoiceFabStatus? status,
    String? transcription,
    String? errorMessage,
    bool? hasShownHint,
  }) {
    return VoiceFabState(
      status: status ?? this.status,
      transcription: transcription ?? this.transcription,
      errorMessage: errorMessage ?? this.errorMessage,
      hasShownHint: hasShownHint ?? this.hasShownHint,
    );
  }
}

/// StateNotifier pour gérer l'état du VoiceFab
class VoiceFabNotifier extends StateNotifier<VoiceFabState> {
  VoiceFabNotifier() : super(const VoiceFabState());

  /// Affiche le tooltip d'aide
  void showHint() {
    if (!state.hasShownHint) {
      state = state.copyWith(
        status: VoiceFabStatus.hintShown,
        hasShownHint: true,
      );
    }
  }

  /// Cache le tooltip
  void hideHint() {
    if (state.status == VoiceFabStatus.hintShown) {
      state = state.copyWith(status: VoiceFabStatus.idle);
    }
  }

  /// Démarre l'écoute vocale
  void startListening() {
    state = state.copyWith(
      status: VoiceFabStatus.listening,
      transcription: null,
      errorMessage: null,
    );
  }

  /// Met à jour la transcription en temps réel
  void updateTranscription(String text) {
    state = state.copyWith(transcription: text);
  }

  /// Arrête l'écoute et passe en mode processing
  void stopListening() {
    state = state.copyWith(status: VoiceFabStatus.processing);
  }

  /// Signale une erreur
  void setError(String message) {
    state = state.copyWith(
      status: VoiceFabStatus.error,
      errorMessage: message,
    );
  }

  /// Réinitialise à l'état idle
  void reset() {
    state = state.copyWith(
      status: VoiceFabStatus.idle,
      transcription: null,
      errorMessage: null,
    );
  }
}

/// Provider pour le VoiceFab
final voiceFabProvider = StateNotifierProvider<VoiceFabNotifier, VoiceFabState>(
  (ref) => VoiceFabNotifier(),
);
