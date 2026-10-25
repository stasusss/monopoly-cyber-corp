import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/cyber_theme.dart';
import 'logic/game_controller.dart';
import 'presentation/board/monopoly_board.dart';
import 'presentation/controls/game_controls.dart';
import 'presentation/dialogs/game_dialogs.dart';
import 'presentation/player_hud/player_hud.dart';
import 'presentation/widgets/dev_debug_overlay.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      home: const GameShellPage(),
    );
  }
}

class GameShellPage extends ConsumerWidget {
  const GameShellPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GameDialogHost(
      child: DevDebugOverlay(
        child: Scaffold(
          backgroundColor: CyberColors.voidBlack,
          appBar: AppBar(
            title: const Text(CyberLore.appTitle),
            actions: [
              IconButton(
                tooltip: 'REBOOT SESSION',
                onPressed: () =>
                    ref.read(gameControllerProvider.notifier).restart(),
                icon: const Icon(Icons.refresh),
              ),
              Builder(
                builder: (ctx) => IconButton(
                  tooltip: 'OPERATIVES',
                  onPressed: () => Scaffold.of(ctx).openEndDrawer(),
                  icon: const Icon(Icons.groups),
                ),
              ),
            ],
          ),
          endDrawer: const PlayerHudDrawer(),
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 960;

                if (isWide) {
                  return const Row(
                    children: [
                      Expanded(flex: 3, child: MonopolyBoard()),
                      Expanded(flex: 1, child: PlayerHud()),
                    ],
                  );
                }

                return const Column(
                  children: [
                    Expanded(child: MonopolyBoard()),
                    GameControlsBar(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
