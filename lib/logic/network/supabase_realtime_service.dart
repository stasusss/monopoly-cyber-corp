import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/player.dart';
import 'network_action.dart';
import 'room_manager.dart';

typedef NetworkActionHandler = void Function(NetworkAction action);
typedef StateSyncHandler = void Function(Map<String, dynamic> stateJson);
typedef PresenceHandler = void Function(List<PresenceMember> members);
typedef PresenceLeaveHandler = void Function(
  PresenceMember left,
  List<PresenceMember> remaining,
);

/// Peer-host transport over Supabase Realtime (Broadcast + Presence).
class SupabaseRealtimeService {
  SupabaseRealtimeService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  RealtimeChannel? _channel;
  String? _roomId;
  String? _localPlayerId;
  List<PresenceMember> _members = const [];

  final _actionController = StreamController<NetworkAction>.broadcast();
  final _stateSyncController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _presenceController =
      StreamController<List<PresenceMember>>.broadcast();
  final _leaveController =
      StreamController<(PresenceMember, List<PresenceMember>)>.broadcast();

  String? get roomId => _roomId;
  String? get localPlayerId => _localPlayerId;
  bool get isConnected => _channel != null;
  List<PresenceMember> get members => List.unmodifiable(_members);

  String? get hostPlayerId => RoomManager.electHostId(
        _members.map((m) => (playerId: m.playerId, joinedAtMs: m.joinedAtMs)),
      );

  bool get isLocalHost =>
      _localPlayerId != null && _localPlayerId == hostPlayerId;

  Stream<NetworkAction> get onActionReceived => _actionController.stream;
  Stream<Map<String, dynamic>> get onStateSyncReceived =>
      _stateSyncController.stream;
  Stream<List<PresenceMember>> get onPresenceChanged =>
      _presenceController.stream;
  Stream<(PresenceMember left, List<PresenceMember> remaining)>
      get onPresenceLeave => _leaveController.stream;

  /// Join `room:{roomId}` with broadcast + presence enabled.
  Future<void> connect({
    required String roomId,
    required Player player,
    int? joinedAtMs,
  }) async {
    final code = RoomManager.normalizeRoomCode(roomId) ?? roomId;
    await disconnect();

    _roomId = code;
    _localPlayerId = player.id;

    final topic = RoomManager.channelName(code);
    _channel = _client.channel(
      topic,
      opts: RealtimeChannelConfig(
        self: true,
        key: player.id,
        ack: false,
      ),
    );

    _channel!
      ..onBroadcast(
        event: NetworkEvents.action,
        callback: _handleActionBroadcast,
      )
      ..onBroadcast(
        event: NetworkEvents.stateSync,
        callback: _handleStateSyncBroadcast,
      )
      ..onPresenceSync((_) => _refreshPresence())
      ..onPresenceJoin((_) => _refreshPresence())
      ..onPresenceLeave((payload) {
        final before = _members;
        _refreshPresence();
        for (final leftPresence in payload.leftPresences) {
          final leftId =
              leftPresence.payload['playerId'] as String? ?? payload.key;
          final previous = before.cast<PresenceMember?>().firstWhere(
                (m) => m?.playerId == leftId || m?.presenceKey == payload.key,
                orElse: () => null,
              );
          if (previous != null) {
            _leaveController.add((previous, _members));
          }
        }
      });

    final subscribed = Completer<void>();
    _channel!.subscribe((status, [error]) {
      if (status == RealtimeSubscribeStatus.subscribed) {
        if (!subscribed.isCompleted) subscribed.complete();
      } else if (status == RealtimeSubscribeStatus.channelError ||
          status == RealtimeSubscribeStatus.timedOut) {
        if (!subscribed.isCompleted) {
          subscribed.completeError(
            error ?? StateError('Realtime subscribe failed: $status'),
          );
        }
      }
    });

    await subscribed.future.timeout(const Duration(seconds: 15));
    await trackPresence(player, joinedAtMs: joinedAtMs);
  }

  /// Publish / refresh local presence (nickname, token, ready flag).
  Future<void> trackPresence(
    Player player, {
    bool ready = false,
    int? joinedAtMs,
  }) async {
    final channel = _channel;
    if (channel == null) {
      throw StateError('Not connected to a room');
    }
    _localPlayerId = player.id;
    final existing = _members.cast<PresenceMember?>().firstWhere(
          (m) => m?.playerId == player.id,
          orElse: () => null,
        );
    final member = PresenceMember(
      playerId: player.id,
      name: player.name,
      tokenColor: player.tokenColor.name,
      chrome: player.chrome.name,
      joinedAtMs: joinedAtMs ??
          existing?.joinedAtMs ??
          DateTime.now().millisecondsSinceEpoch,
      presenceKey: player.id,
      ready: ready,
    );
    await channel.track(member.toPresencePayload());
    _refreshPresence();
  }

  Future<void> setReady(bool ready) async {
    final channel = _channel;
    final id = _localPlayerId;
    if (channel == null || id == null) return;
    final current = _members.cast<PresenceMember?>().firstWhere(
          (m) => m?.playerId == id,
          orElse: () => null,
        );
    await channel.track({
      'playerId': id,
      'name': current?.name ?? 'OPERATIVE',
      'tokenColor': current?.tokenColor ?? TokenColor.blue.name,
      'chrome': current?.chrome ?? Chrome.sandevistan.name,
      'joinedAtMs':
          current?.joinedAtMs ?? DateTime.now().millisecondsSinceEpoch,
      'ready': ready,
    });
    _refreshPresence();
  }

  Future<void> sendAction(NetworkAction action) async {
    final channel = _channel;
    if (channel == null) {
      debugPrint('Realtime sendAction skipped: not connected');
      return;
    }
    try {
      await channel.sendBroadcastMessage(
        event: NetworkEvents.action,
        payload: action.toJson(),
      );
    } catch (e, st) {
      debugPrint('Realtime sendAction failed: $e\n$st');
    }
  }

  /// Host pushes authoritative [GameState.toJson] (or lobby snapshot).
  Future<void> sendStateSync(Map<String, dynamic> stateJson) async {
    final channel = _channel;
    if (channel == null) {
      debugPrint('Realtime sendStateSync skipped: not connected');
      return;
    }
    try {
      await channel.sendBroadcastMessage(
        event: NetworkEvents.stateSync,
        payload: {
          'state': stateJson,
          'senderId': _localPlayerId,
          'sentAt': DateTime.now().toIso8601String(),
        },
      );
    } catch (e, st) {
      debugPrint('Realtime sendStateSync failed: $e\n$st');
    }
  }

  Future<void> disconnect() async {
    final channel = _channel;
    _channel = null;
    _roomId = null;
    _members = const [];
    if (channel != null) {
      try {
        await channel.untrack();
      } catch (_) {}
      await _client.removeChannel(channel);
    }
    _presenceController.add(const []);
  }

  void dispose() {
    unawaited(disconnect());
    _actionController.close();
    _stateSyncController.close();
    _presenceController.close();
    _leaveController.close();
  }

  void _handleActionBroadcast(Map<String, dynamic> raw) {
    try {
      final map = _unwrapBroadcast(raw);
      final action = NetworkAction.tryFromJson(map);
      if (action == null) {
        debugPrint('Realtime ACTION ignored (not a game envelope): $map');
        return;
      }
      _actionController.add(action);
    } catch (e, st) {
      debugPrint('Realtime ACTION parse error: $e\n$st raw=$raw');
    }
  }

  void _handleStateSyncBroadcast(Map<String, dynamic> raw) {
    try {
      final map = _unwrapBroadcast(raw);
      final state = map['state'];
      if (state is Map) {
        _stateSyncController.add(Map<String, dynamic>.from(state));
      } else {
        _stateSyncController.add(map);
      }
    } catch (e, st) {
      debugPrint('Realtime STATE_SYNC parse error: $e\n$st');
    }
  }

  Map<String, dynamic> _unwrapBroadcast(Map<String, dynamic> raw) {
    final nested = raw['payload'];
    if (nested is Map) {
      return Map<String, dynamic>.from(nested);
    }
    return Map<String, dynamic>.from(raw);
  }

  void _refreshPresence() {
    final channel = _channel;
    if (channel == null) {
      _members = const [];
      _presenceController.add(_members);
      return;
    }

    final collected = <PresenceMember>[];
    for (final entry in channel.presenceState()) {
      if (entry.presences.isEmpty) continue;
      final payload = entry.presences.last.payload;
      collected.add(
        PresenceMember.fromPresence(
          presenceKey: entry.key,
          payload: payload,
        ),
      );
    }

    final hostId = RoomManager.electHostId(
      collected.map((m) => (playerId: m.playerId, joinedAtMs: m.joinedAtMs)),
    );
    _members = collected
        .map((m) => m.copyWith(isHost: m.playerId == hostId))
        .toList()
      ..sort((a, b) => a.joinedAtMs.compareTo(b.joinedAtMs));

    _presenceController.add(_members);
  }
}
