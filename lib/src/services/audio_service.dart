// import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioService extends ChangeNotifier {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  // Stub implementation - no actual audio players for now
  // final AudioPlayer _musicPlayer = AudioPlayer();
  // final AudioPlayer _sfxPlayer = AudioPlayer();

  bool _musicEnabled = true;
  bool _soundEnabled = true;
  double _musicVolume = 0.5;
  double _sfxVolume = 0.7;

  bool get musicEnabled => _musicEnabled;
  bool get soundEnabled => _soundEnabled;
  double get musicVolume => _musicVolume;
  double get sfxVolume => _sfxVolume;

  /// Initialize audio players (stub)
  Future<void> init() async {
    // Stub - no actual initialization needed
    if (kDebugMode) {
      print('AudioService initialized (stub mode)');
    }
  }

  /// Play background music (stub)
  Future<void> playMusic(String asset) async {
    if (!_musicEnabled) return;
    if (kDebugMode) {
      print('Playing music: $asset (stub)');
    }
  }

  /// Play sound effect (stub)
  Future<void> playSfx(SoundEffect sfx) async {
    if (!_soundEnabled) return;
    if (kDebugMode) {
      print('Playing SFX: $sfx (stub)');
    }
  }

  /// Stop music (stub)
  Future<void> stopMusic() async {
    if (kDebugMode) {
      print('Stopping music (stub)');
    }
  }

  /// Pause music (stub)
  Future<void> pauseMusic() async {
    if (kDebugMode) {
      print('Pausing music (stub)');
    }
  }

  /// Resume music (stub)
  Future<void> resumeMusic() async {
    if (!_musicEnabled) return;
    if (kDebugMode) {
      print('Resuming music (stub)');
    }
  }

  /// Set music enabled/disabled
  void setMusicEnabled(bool enabled) {
    _musicEnabled = enabled;
    if (!enabled) {
      stopMusic();
    }
    notifyListeners();
  }

  /// Set sound enabled/disabled
  void setSoundEnabled(bool enabled) {
    _soundEnabled = enabled;
    notifyListeners();
  }

  /// Set music volume
  void setMusicVolume(double volume) {
    _musicVolume = volume.clamp(0.0, 1.0);
    // _musicPlayer.setVolume(_musicVolume);
    notifyListeners();
  }

  /// Set SFX volume
  void setSfxVolume(double volume) {
    _sfxVolume = volume.clamp(0.0, 1.0);
    // _sfxPlayer.setVolume(_sfxVolume);
    notifyListeners();
  }

  String _getSfxPath(SoundEffect sfx) {
    // Map sound effects to audio file paths
    // For now, returning placeholder paths
    switch (sfx) {
      case SoundEffect.tap:
        return 'audio/tap.mp3';
      case SoundEffect.dig:
        return 'audio/dig.mp3';
      case SoundEffect.fossilFound:
        return 'audio/fossil_found.mp3';
      case SoundEffect.coinEarned:
        return 'audio/coin.mp3';
      case SoundEffect.levelUp:
        return 'audio/levelup.mp3';
      case SoundEffect.cardFlip:
        return 'audio/card_flip.mp3';
      case SoundEffect.buttonClick:
        return 'audio/button.mp3';
      case SoundEffect.success:
        return 'audio/success.mp3';
      case SoundEffect.error:
        return 'audio/error.mp3';
    }
  }

  /// Dispose audio players (stub)
  @override
  void dispose() {
    // _musicPlayer.dispose();
    // _sfxPlayer.dispose();
    super.dispose();
  }
}

/// Sound effect types
enum SoundEffect {
  tap,
  dig,
  fossilFound,
  coinEarned,
  levelUp,
  cardFlip,
  buttonClick,
  success,
  error,
}
