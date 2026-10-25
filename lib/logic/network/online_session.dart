import 'supabase_realtime_service.dart';

/// Bound Realtime session for an in-progress online match.
class OnlineSession {
  const OnlineSession({
    required this.localPlayerId,
    required this.realtime,
  });

  final String localPlayerId;
  final SupabaseRealtimeService realtime;

  bool get isHost => realtime.isLocalHost;
  String? get roomId => realtime.roomId;
}

/// Grace period before a dropped operative is replaced by [AiService].
const disconnectAiGrace = Duration(seconds: 15);
