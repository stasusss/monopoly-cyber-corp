/// Supabase project credentials for CYBER-CORP Realtime multiplayer.
///
/// The `anon` key is safe for client (Flutter Web) use with Broadcast/Presence.
/// Never put the `service_role` key in this file or ship it to the browser.
abstract final class SupabaseConfig {
  static const String url = 'https://taipipcmthunwjvbszcg.supabase.co';

  /// Publishable (anon) key — safe for Flutter Web client use.
  static const String publishableKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRhaXBpcGNtdGh1bndqdmJzemNnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTI5NjA4MzAsImV4cCI6MjEwODUzNjgzMH0.C3AXH0mCF9TrGo-0U6f_hr3kwxE6M8ipWRv8s8jXEy4';
}
