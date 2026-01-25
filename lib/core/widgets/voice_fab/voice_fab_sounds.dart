import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

/// Gestionnaire des sons pour le VoiceFab
class VoiceFabSounds {
  static const String _startListeningPath = 'sounds/voice_start.mp3';
  static const String _stopListeningPath = 'sounds/voice_end.mp3';

  static AudioPlayer? _player;

  /// Initialise le player audio
  static Future<void> init() async {
    _player = AudioPlayer();
    // Pré-charger les sons pour une lecture instantanée
    try {
      await _player?.setSource(AssetSource(_startListeningPath));
    } catch (e) {
      debugPrint('VoiceFabSounds: Son de démarrage non trouvé: $e');
    }
  }

  /// Joue le son de début d'écoute
  static Future<void> playStartListening() async {
    try {
      _player ??= AudioPlayer();
      await _player?.stop();
      await _player?.play(AssetSource(_startListeningPath));
    } catch (e) {
      // Lecture silencieuse si fichier absent
      debugPrint('VoiceFabSounds: Impossible de jouer voice_start.mp3: $e');
    }
  }

  /// Joue le son de fin d'écoute
  static Future<void> playStopListening() async {
    try {
      _player ??= AudioPlayer();
      await _player?.stop();
      await _player?.play(AssetSource(_stopListeningPath));
    } catch (e) {
      // Lecture silencieuse si fichier absent
      debugPrint('VoiceFabSounds: Impossible de jouer voice_end.mp3: $e');
    }
  }

  /// Libère les ressources
  static Future<void> dispose() async {
    await _player?.dispose();
    _player = null;
  }
}
