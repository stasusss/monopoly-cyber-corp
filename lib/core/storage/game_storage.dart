import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../logic/cards/deck_manager.dart';
import '../../models/game_state.dart';

/// Local persistence for Cyber-Corp sessions (SharedPreferences / web localStorage).
class GameStorage {
  GameStorage({this.prefs});

  static const _key = 'cyber_corp_session_v1';
  SharedPreferences? prefs;

  Future<SharedPreferences> _ensure() async =>
      prefs ??= await SharedPreferences.getInstance();

  Future<bool> hasSession() async {
    final p = await _ensure();
    return p.containsKey(_key);
  }

  Future<void> save({
    required GameState state,
    required DeckManager decks,
  }) async {
    final p = await _ensure();
    final payload = jsonEncode({
      'state': state.toJson(),
      'decks': decks.toJson(),
      'savedAt': DateTime.now().toIso8601String(),
    });
    await p.setString(_key, payload);
  }

  Future<({GameState state, DeckManager decks})?> load() async {
    final p = await _ensure();
    final raw = p.getString(_key);
    if (raw == null || raw.isEmpty) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final state =
          GameState.fromJson(map['state'] as Map<String, dynamic>);
      final decks = DeckManager.fromJson(
        map['decks'] as Map<String, dynamic>? ?? const {},
      );
      return (state: state, decks: decks);
    } catch (_) {
      return null;
    }
  }

  Future<void> clear() async {
    final p = await _ensure();
    await p.remove(_key);
  }
}
