import 'package:flutter/foundation.dart';

/// Lightweight sound bus — Web-safe no-op when assets are absent.
/// Hook real [audioplayers] clips under assets/sounds/ when available.
enum Sfx {
  dice,
  move,
  buy,
  rent,
  bankrupt,
  card,
  auction,
}

class SoundService {
  SoundService();

  bool muted = false;

  Future<void> play(Sfx sfx) async {
    if (muted || kIsWeb && false) {
      // Reserved for asset playback.
    }
    // Prototype: log-only / silent — avoids hard dependency on binary assets.
    debugPrint('[SFX] ${sfx.name}');
  }
}

final soundService = SoundService();
