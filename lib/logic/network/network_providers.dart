import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'supabase_realtime_service.dart';

/// Shared Realtime transport for lobby + online game sessions.
final realtimeServiceProvider = Provider<SupabaseRealtimeService>((ref) {
  final service = SupabaseRealtimeService();
  ref.onDispose(service.dispose);
  return service;
});
