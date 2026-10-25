import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../logic/game_controller.dart';
import '../../models/game_state.dart';
import '../../models/pending_action.dart';

/// Bottom control bar for narrow layouts (mirrors center panel actions).
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

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Row(
        children: [
          Expanded(
            child: FilledButton.icon(
              onPressed: canRoll ? c.rollDice : null,
              icon: const Icon(Icons.casino),
              label: const Text('ROLL DICE'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: canEnd ? c.endTurn : null,
              icon: const Icon(Icons.flag),
              label: const Text('END TURN'),
            ),
          ),
        ],
      ),
    );
  }
}
