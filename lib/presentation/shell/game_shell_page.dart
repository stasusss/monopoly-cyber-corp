import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/cyber_theme.dart';
import '../../logic/game_controller.dart';
import '../board/monopoly_board.dart';
import '../controls/game_controls.dart';
import '../dialogs/game_dialogs.dart';
import '../player_hud/player_hud.dart';
import '../player_hud/player_strip.dart';
import '../widgets/dev_debug_overlay.dart';

class GameShellPage extends ConsumerWidget {
  const GameShellPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SelectionContainer.disabled(
      child: GameDialogHost(
        child: DevDebugOverlay(
          child: Scaffold(
            backgroundColor: CyberColors.voidBlack,
            appBar: AppBar(
              title: const FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(CyberLore.appTitle),
              ),
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
                  final view = MediaQuery.sizeOf(context);
                  final shortLandscape = view.height <
                          CyberLayout.shortLandscapeHeight &&
                      view.width > view.height;
                  if (shortLandscape) return const _RotatePrompt();

                  final isWide =
                      constraints.maxWidth >= CyberLayout.wideBreakpoint;
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
                      PlayerStrip(),
                      Expanded(child: MonopolyBoard()),
                      GameControlsBar(),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RotatePrompt extends StatelessWidget {
  const _RotatePrompt();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.screen_rotation,
              color: CyberColors.neonCyan,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'ROTATE TO PORTRAIT',
              textAlign: TextAlign.center,
              style: GoogleFonts.orbitron(
                color: CyberColors.neonCyan,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.4,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Поверніть пристрій вертикально або збільште висоту вікна. '
              'У короткому альбомному кадрі клітинки стають нечитабельними.',
              textAlign: TextAlign.center,
              style: GoogleFonts.rajdhani(
                color: CyberColors.textMuted,
                fontSize: 16,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
