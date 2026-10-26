import 'package:shared_preferences/shared_preferences.dart';

/// Persists operative identity across F5 / cold reloads for a given room.
class OnlineIdentityStore {
  OnlineIdentityStore({this._prefs});

  static const _playerIdKey = 'cyber_corp_online_player_id_v1';
  static const _roomKey = 'cyber_corp_online_room_v1';
  static const _joinedAtKey = 'cyber_corp_online_joined_at_v1';

  SharedPreferences? _prefs;

  Future<SharedPreferences> _ensure() async =>
      _prefs ??= await SharedPreferences.getInstance();

  /// Returns saved seat for [roomCode], or null if none / different room.
  Future<({String playerId, int joinedAtMs})?> loadForRoom(String roomCode) async {
    final p = await _ensure();
    final savedRoom = p.getString(_roomKey);
    final playerId = p.getString(_playerIdKey);
    final joinedAtMs = p.getInt(_joinedAtKey);
    if (savedRoom == null ||
        playerId == null ||
        playerId.isEmpty ||
        joinedAtMs == null) {
      return null;
    }
    if (savedRoom.toUpperCase() != roomCode.toUpperCase()) return null;
    return (playerId: playerId, joinedAtMs: joinedAtMs);
  }

  Future<void> save({
    required String roomCode,
    required String playerId,
    required int joinedAtMs,
  }) async {
    final p = await _ensure();
    await p.setString(_roomKey, roomCode.toUpperCase());
    await p.setString(_playerIdKey, playerId);
    await p.setInt(_joinedAtKey, joinedAtMs);
  }

  Future<void> clear() async {
    final p = await _ensure();
    await p.remove(_roomKey);
    await p.remove(_playerIdKey);
    await p.remove(_joinedAtKey);
  }
}
