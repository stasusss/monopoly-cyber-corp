import 'dart:math';

/// Room codes, deep-link parsing, and invite URLs for peer-host multiplayer.
abstract final class RoomManager {
  static final _rng = Random();

  static const _prefixes = <String>[
    'NEON',
    'CHROME',
    'GRID',
    'NOIR',
    'PULSE',
    'ICE',
    'VOID',
    'CYBER',
    'GLITCH',
    'NIGHT',
    'CORPO',
    'NET',
  ];

  /// Generates a shareable code like `NEON-73`.
  static String generateRoomCode() {
    final prefix = _prefixes[_rng.nextInt(_prefixes.length)];
    final n = _rng.nextInt(90) + 10; // 10–99
    return '$prefix-$n';
  }

  /// Normalizes user/URL input to `PREFIX-NN` uppercase form.
  static String? normalizeRoomCode(String? raw) {
    if (raw == null) return null;
    final cleaned = raw.trim().toUpperCase().replaceAll(RegExp(r'\s+'), '');
    if (cleaned.isEmpty) return null;

    final match = RegExp(r'^([A-Z]{2,8})-?(\d{2})$').firstMatch(cleaned);
    if (match != null) {
      return '${match.group(1)}-${match.group(2)}';
    }

    // Allow bare alphanumeric fallbacks (e.g. NEON73 → NEON-73 if possible).
    final compact = RegExp(r'^([A-Z]{2,8})(\d{2})$').firstMatch(cleaned);
    if (compact != null) {
      return '${compact.group(1)}-${compact.group(2)}';
    }

    if (RegExp(r'^[A-Z0-9-]{4,12}$').hasMatch(cleaned)) {
      return cleaned;
    }
    return null;
  }

  /// Reads `?room=` from the browser URL (cold start / deep link).
  static String? roomCodeFromUri([Uri? uri]) {
    final u = uri ?? Uri.base;
    return normalizeRoomCode(u.queryParameters['room']);
  }

  /// Invite link for chums — works for local and production origins.
  static String shareUrl(String roomCode, {Uri? base}) {
    final code = normalizeRoomCode(roomCode) ?? roomCode;
    final origin = (base ?? Uri.base).origin;
    return '$origin/?room=$code';
  }

  /// Realtime channel topic for a room.
  static String channelName(String roomCode) {
    final code = normalizeRoomCode(roomCode) ?? roomCode;
    return 'room:$code';
  }

  /// Host = earliest [joinedAtMs]; stable tie-break by playerId.
  static String? electHostId(
    Iterable<({String playerId, int joinedAtMs})> members,
  ) {
    final list = members.toList();
    if (list.isEmpty) return null;
    list.sort((a, b) {
      final byTime = a.joinedAtMs.compareTo(b.joinedAtMs);
      if (byTime != 0) return byTime;
      return a.playerId.compareTo(b.playerId);
    });
    return list.first.playerId;
  }
}
