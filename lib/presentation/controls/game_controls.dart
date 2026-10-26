import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/game_rules.dart';
import '../../core/theme/cyber_theme.dart';
import '../../logic/game_controller.dart';
import '../../models/game_state.dart';
import '../../models/pending_action.dart';
import '../widgets/turn_action_button.dart';
import 'empire_menu.dart';

/// Thumb-zone actions for narrow layouts. The board center does not repeat them.
class GameControlsBar extends ConsumerWidget {
  const GameControlsBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameControllerProvider);
    final c = ref.read(gameControllerProvider.notifier);
    final idle = state.pendingAction is PendingNone;
    final localOk = c.isLocalInputAllowed;

    final canRoll = localOk &&
        idle &&
        state.phase == TurnPhase.waitingForRoll &&
        !state.isGameOver;
    final canEnd = localOk &&
        idle &&
        state.phase == TurnPhase.canEndTurn &&
        !state.isGameOver;
    final canBail = localOk &&
        idle &&
        state.activePlayer.inJail &&
        state.phase == TurnPhase.waitingForRoll &&
        !state.isGameOver;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const EmpireMenu(),
          const SizedBox(height: 6),
          Row(
        children: [
          Expanded(
            child: TurnActionButton(
              pulse: canRoll,
              onPressed: canRoll ? c.rollDice : null,
              icon: Icons.casino,
              label: 'ROLL',
            ),
          ),
          if (state.activePlayer.inJail &&
              state.phase == TurnPhase.waitingForRoll) ...[
            const SizedBox(width: 8),
            Expanded(
              child: TurnActionButton(
                primary: false,
                pulse: canBail && !canRoll,
                pulseColor: CyberColors.cyberYellow,
                onPressed: canBail ? c.payJailFine : null,
                icon: Icons.lock_open,
                label: 'BAIL ${GameRules.credits(GameRules.jailFine)}',
              ),
            ),
          ],
          const SizedBox(width: 8),
          Expanded(
            child: TurnActionButton(
              primary: false,
              pulse: canEnd,
              pulseColor: CyberColors.cyberYellow,
              onPressed: canEnd ? c.endTurn : null,
              icon: Icons.flag,
              label: 'END',
            ),
          ),
        ],
          ),
        ],
      ),
    );
  }
}
