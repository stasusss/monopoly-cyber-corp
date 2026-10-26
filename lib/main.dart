import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/config/supabase_config.dart';
import 'core/theme/cyber_theme.dart';
import 'presentation/lobby/lobby_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.publishableKey,
  );
  runApp(
    const ProviderScope(
      child: MonopolyApp(),
    ),
  );
}

class MonopolyApp extends StatelessWidget {
  const MonopolyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: CyberLore.appTitle,
      debugShowCheckedModeBanner: false,
      theme: CyberTheme.dark,
      home: const LobbyScreen(),
    );
  }
}
