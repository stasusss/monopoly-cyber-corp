import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/game_rules.dart';
import '../../logic/game_controller.dart';
import '../../logic/nightfall.dart';
import '../../models/game_state.dart';
import '../../models/pending_action.dart';
import '../dialogs/trade_composer.dart';

/// Trade, syndicate overdraft, district claim, and ICE nullifier.
class EmpireMenu extends ConsumerWidget {
  const EmpireMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameControllerProvider);
    final controller = ref.read(gameControllerProvider.notifier);
    final open = _open(state, controller);
    if (!open) return const SizedBox.shrink();

    final me = state.activePlayer;
    final opponents = state.livingPlayers.where((p) => p.id != me.id).toList();
    final canTrade = opponents.isNotEmpty &&
        (me.propertyIndexes.isNotEmpty ||
            opponents.any((p) => p.propertyIndexes.isNotEmpty));
    final loan = Nightfall.overdraftPrincipal(state, me);
    final claims = Nightfall.claimTargets(state, me);

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      alignment: WrapAlignment.center,
      children: [
        if (canTrade)
          _btn(
            context,
            'TRADE',
            () async {
              final offer = await showTradeComposer(
                context,
                from: me,
                opponents: opponents,
                board: state.board,
              );
              if (offer != null) controller.proposeTrade(offer);
            },
          ),
        if (!me.overdraftUsed && loan > 0)
          _btn(
            context,
            'LOAN ${GameRules.credits(loan)}',
            controller.drawOverdraft,
          ),
        if (!me.buyoutUsed && claims.isNotEmpty)
          _btn(context, 'CLAIM', controller.requestClaim),
        if (me.inJail &&
            me.getOutOfJailCards > 0 &&
            state.phase == TurnPhase.waitingForRoll)
          _btn(
            context,
            'NULLIFIER ×${me.getOutOfJailCards}',
            controller.useJailCard,
          ),
      ],
    );
  }

  bool _open(GameState state, GameController controller) {
    if (!controller.isLocalInputAllowed || state.isGameOver) return false;
    if (state.pendingAction is! PendingNone) return false;
    if (state.activePlayer.isAi) return false;
    return state.phase == TurnPhase.waitingForRoll ||
        state.phase == TurnPhase.canEndTurn;
  }

  Widget _btn(BuildContext context, String label, VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
}
