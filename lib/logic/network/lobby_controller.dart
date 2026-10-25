import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../models/player.dart';
import 'network_action.dart';
import 'network_providers.dart';
import 'room_manager.dart';
import 'supabase_realtime_service.dart';

enum LobbyPhase {
  /// Nickname + create / join.
  entry,

  /// Realtime subscribe in flight.
  connecting,

  /// Waiting room (2–4 slots).
  room,

  /// Host started — navigate to board.
  starting,

  error,
}

class LobbyState {
  const LobbyState({
    this.phase = LobbyPhase.entry,
    this.nickname = 'NETRUNNER',
    this.tokenColor = TokenColor.blue,
    this.roomCode,
    this.localPlayerId,
    this.members = const [],
    this.ready = false,
    this.errorMessage,
    this.deepLinkRoom,
  });

  final LobbyPhase phase;
  final String nickname;
  final TokenColor tokenColor;
  final String? roomCode;
  final String? localPlayerId;
  final List<PresenceMember> members;
  final bool ready;
  final String? errorMessage;
  final String? deepLinkRoom;

  bool get isHost {
    final id = localPlayerId;
    if (id == null) return false;
    return members.any((m) => m.playerId == id && m.isHost);
  }

  int get occupiedSlots => members.length;
  bool get canStart =>
      isHost && members.length >= 2 && members.length <= 4;

  String? get shareUrl =>
      roomCode == null ? null : RoomManager.shareUrl(roomCode!);

  LobbyState copyWith({
    LobbyPhase? phase,
    String? nickname,
    TokenColor? tokenColor,
    String? roomCode,
    String? localPlayerId,
    List<PresenceMember>? members,
    bool? ready,
    String? errorMessage,
    String? deepLinkRoom,
    bool clearError = false,
    bool clearRoom = false,
  }) {
    return LobbyState(
      phase: phase ?? this.phase,
      nickname: nickname ?? this.nickname,
      tokenColor: tokenColor ?? this.tokenColor,
      roomCode: clearRoom ? null : (roomCode ?? this.roomCode),
      localPlayerId: localPlayerId ?? this.localPlayerId,
      members: members ?? this.members,
      ready: ready ?? this.ready,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      deepLinkRoom: deepLinkRoom ?? this.deepLinkRoom,
    );
  }
}

class LobbyController extends StateNotifier<LobbyState> {
  LobbyController(this._realtime)
      : super(
          LobbyState(deepLinkRoom: RoomManager.roomCodeFromUri()),
        ) {
    _actionSub = _realtime.onActionReceived.listen(_onAction);
    _syncSub = _realtime.onStateSyncReceived.listen(_onStateSync);
    _presenceSub = _realtime.onPresenceChanged.listen((members) {
      state = state.copyWith(members: members, clearError: true);
    });
  }

  static const _uuid = Uuid();
  static const maxPlayers = 4;
  static const minPlayers = 2;

  final SupabaseRealtimeService _realtime;
  StreamSubscription<NetworkAction>? _actionSub;
  StreamSubscription<Map<String, dynamic>>? _syncSub;
  StreamSubscription<List<PresenceMember>>? _presenceSub;

  void setNickname(String value) {
    final trimmed = value.trim();
    state = state.copyWith(
      nickname: trimmed.isEmpty ? 'NETRUNNER' : trimmed.toUpperCase(),
    );
  }

  void setTokenColor(TokenColor color) {
    state = state.copyWith(tokenColor: color);
  }

  Future<void> createRoom() async {
    final code = RoomManager.generateRoomCode();
    await _connect(code);
  }

  Future<void> joinRoom(String rawCode) async {
    final code = RoomManager.normalizeRoomCode(rawCode);
    if (code == null) {
      state = state.copyWith(
        phase: LobbyPhase.error,
        errorMessage: 'INVALID ROOM CODE',
      );
      return;
    }
    await _connect(code);
  }

  Future<void> joinDeepLinkIfPresent() async {
    final code = state.deepLinkRoom;
    if (code == null) return;
    await joinRoom(code);
  }

  Future<void> _connect(String code) async {
    state = state.copyWith(
      phase: LobbyPhase.connecting,
      roomCode: code,
      clearError: true,
    );

    final playerId = state.localPlayerId ?? _uuid.v4();
    final player = Player(
      id: playerId,
      name: state.nickname,
      tokenColor: state.tokenColor,
    );

    try {
      await _realtime.connect(roomId: code, player: player);
      // Soft cap: still enter room; UI warns if overfull.
      state = state.copyWith(
        phase: LobbyPhase.room,
        localPlayerId: playerId,
        members: _realtime.members,
        ready: false,
      );
    } catch (e) {
      state = state.copyWith(
        phase: LobbyPhase.error,
        errorMessage: 'LINK FAILED · $e',
        clearRoom: true,
      );
    }
  }

  Future<void> toggleReady() async {
    if (state.phase != LobbyPhase.room) return;
    final next = !state.ready;
    await _realtime.setReady(next);
    state = state.copyWith(ready: next);
  }

  Future<void> refreshPresenceProfile() async {
    if (state.phase != LobbyPhase.room || state.localPlayerId == null) return;
    final player = Player(
      id: state.localPlayerId!,
      name: state.nickname,
      tokenColor: state.tokenColor,
    );
    await _realtime.trackPresence(player, ready: state.ready);
  }

  Future<void> startGame() async {
    if (!state.canStart) return;
    final senderId = state.localPlayerId;
    if (senderId == null) return;

    await _realtime.sendAction(
      NetworkAction(
        type: NetworkActionType.startGame,
        senderId: senderId,
        payload: {
          'roomCode': state.roomCode,
          'players': state.members
              .map(
                (m) => {
                  'id': m.playerId,
                  'name': m.name,
                  'tokenColor': m.tokenColor,
                  'isHost': m.isHost,
                },
              )
              .toList(),
        },
      ),
    );
    state = state.copyWith(phase: LobbyPhase.starting);
  }

  Future<void> leaveRoom() async {
    await _realtime.disconnect();
    state = LobbyState(
      nickname: state.nickname,
      tokenColor: state.tokenColor,
      deepLinkRoom: state.deepLinkRoom,
    );
  }

  void consumeStart() {
    if (state.phase == LobbyPhase.starting) {
      state = state.copyWith(phase: LobbyPhase.room);
    }
  }

  void _onAction(NetworkAction action) {
    if (action.type == NetworkActionType.startGame &&
        state.phase == LobbyPhase.room) {
      state = state.copyWith(phase: LobbyPhase.starting);
    }
  }

  /// Host STATE_SYNC after bootstrap — clients jump into the match even if
  /// ACTION_START_GAME was missed / stripped by Realtime payload shaping.
  void _onStateSync(Map<String, dynamic> envelope) {
    if (state.phase != LobbyPhase.room) return;
    final game = envelope['game'];
    if (game is Map && game['players'] is List) {
      state = state.copyWith(phase: LobbyPhase.starting);
    }
  }

  @override
  void dispose() {
    _actionSub?.cancel();
    _syncSub?.cancel();
    _presenceSub?.cancel();
    super.dispose();
  }
}

final lobbyControllerProvider =
    StateNotifierProvider<LobbyController, LobbyState>((ref) {
  final realtime = ref.watch(realtimeServiceProvider);
  return LobbyController(realtime);
});
