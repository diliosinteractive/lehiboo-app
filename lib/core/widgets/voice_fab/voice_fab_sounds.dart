import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Gestionnaire des sons pour le VoiceFab
class VoiceFabSounds {
  static const String _startListeningPath = 'sounds/voice_start.mp3';
  static const String _stopListeningPath = 'sounds/voice_end.mp3';

  static AudioPlayer? _player;
  static bool _startSoundAvailable = false;
  static bool _stopSoundAvailable = false;

  /// Initialise le player audio en vérifiant la disponibilité des assets
  static Future<void> init() async {
    _startSoundAvailable = await _assetExists('assets/$_startListeningPath');
    _stopSoundAvailable = await _assetExists('assets/$_stopListeningPath');

    if (_startSoundAvailable || _stopSoundAvailable) {
      _player = AudioPlayer();
    }
  }

  /// Vérifie si un asset existe sans crasher
  static Future<bool> _assetExists(String path) async {
    try {
      final data = await rootBundle.load(path);
      return data.lengthInBytes > 0;
    } catch (_) {
      return false;
    }
  }

  /// Joue le son de début d'écoute
  static Future<void> playStartListening() async {
    if (!_startSoundAvailable) return;
    try {
      _player ??= AudioPlayer();
      await _player?.stop();
      await _player?.play(AssetSource(_startListeningPath));
    } catch (e) {
      debugPrint('VoiceFabSounds: Impossible de jouer voice_start.mp3: $e');
    }
  }

  /// Joue le son de fin d'écoute
  static Future<void> playStopListening() async {
    if (!_stopSoundAvailable) return;
    try {
      _player ??= AudioPlayer();
      await _player?.stop();
      await _player?.play(AssetSource(_stopListeningPath));
    } catch (e) {
      debugPrint('VoiceFabSounds: Impossible de jouer voice_end.mp3: $e');
    }
  }

  /// Libère les ressources
  static Future<void> dispose() async {
    await _player?.dispose();
    _player = null;
  }
}
