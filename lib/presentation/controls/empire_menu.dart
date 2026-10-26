import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/game_rules.dart';
import '../../core/l10n/app_lang.dart';
import '../../core/theme/cyber_theme.dart';
import '../../core/l10n/app_strings.dart';
import '../../logic/game_controller.dart';
import '../../logic/nightfall.dart';
import '../../models/game_state.dart';
import '../../models/player.dart';
import '../../models/pending_action.dart';
import '../dialogs/trade_composer.dart';

/// Trade, syndicate overdraft, district claim, and ICE nullifier.
class EmpireMenu extends ConsumerWidget {
  const EmpireMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppStrings(ref.watch(appLangProvider));
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
            s.trade,
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
            s.loan(GameRules.credits(loan)),
            controller.drawOverdraft,
          ),
        if (!me.buyoutUsed && claims.isNotEmpty)
          _btn(context, s.claim, controller.requestClaim),
        if (state.phase == TurnPhase.waitingForRoll &&
            me.chrome == Chrome.sandevistan &&
            !me.chromeSpent &&
            !me.chromeArmed)
          _btn(context, s.armSand, controller.armSandevistan),
        if (me.chrome == Chrome.cyberdeck && !me.chromeSpent)
          _btn(context, s.peekDeck, controller.peekDeck),
        if (state.phase == TurnPhase.waitingForRoll && !me.fixerSpent)
          _btn(context, s.fixer, () => _fixer(context, controller, s)),
        if (me.inJail &&
            me.getOutOfJailCards > 0 &&
            state.phase == TurnPhase.waitingForRoll)
          _btn(
            context,
            s.nullifier(me.getOutOfJailCards),
            controller.useJailCard,
          ),
      ],
    );
  }

  Future<void> _fixer(
    BuildContext context,
    GameController controller,
    AppStrings s,
  ) async {
    final job = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: CyberColors.panel,
        title: Text(s.fixer, style: const TextStyle(color: CyberColors.neonCyan)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(s.fixerDelivery),
              onTap: () => Navigator.pop(ctx, 'delivery'),
            ),
            ListTile(
              title: Text(s.fixerSkim),
              onTap: () => Navigator.pop(ctx, 'skim'),
            ),
            ListTile(
              title: Text(s.fixerIce),
              onTap: () => Navigator.pop(ctx, 'ice'),
            ),
          ],
        ),
      ),
    );
    if (job != null) controller.takeFixer(job);
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
