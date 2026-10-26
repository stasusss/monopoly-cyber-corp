import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/game_rules.dart';
import '../../core/theme/cyber_theme.dart';
import '../../logic/game_controller.dart';
import '../../logic/nightfall.dart';
import '../../models/game_state.dart';
import '../../models/pending_action.dart';
import 'auction_dialog.dart';
import 'card_dialog.dart';
import 'cyber_dialog_frame.dart';
import 'trade_dialog.dart';

/// Watches [pendingAction] and presents modal dialogs.
class GameDialogHost extends ConsumerStatefulWidget {
  const GameDialogHost({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<GameDialogHost> createState() => _GameDialogHostState();
}

class _GameDialogHostState extends ConsumerState<GameDialogHost> {
  PendingAction? _shown;
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    ref.listen(gameControllerProvider, (prev, next) {
      final pending = next.pendingAction;
      // The auction route stays mounted and rebuilds from the provider.
      if (pending is PendingAuction && _open) {
        _shown = pending;
        return;
      }
      if (!_humanFacing(next, pending)) {
        _shown = pending;
        return;
      }
      if (_open) return;
      if (_shown == pending) return;
      _shown = pending;
      _schedule(pending);
    });

    return widget.child;
  }

  bool _humanFacing(GameState state, PendingAction pending) {
    if (pending is PendingNone) return false;
    if (pending is PendingWinner) return true;
    if (pending is PendingAuction) {
      final bidder = state.players
          .where((p) => p.id == pending.currentBidderId)
          .firstOrNull;
      return bidder != null && !bidder.isAi;
    }
    if (pending is PendingTradeOffer) {
      final to = state.players
          .where((p) => p.id == pending.toPlayerId)
          .firstOrNull;
      return to != null && !to.isAi;
    }
    return !state.activePlayer.isAi;
  }

  void _schedule(PendingAction pending) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _open) return;
      final state = ref.read(gameControllerProvider);
      final live = state.pendingAction;
      if (live != pending) {
        if (_humanFacing(state, live)) _schedule(live);
        return;
      }
      _present(pending);
    });
  }

  Future<void> _present(PendingAction pending) async {
    if (_open) return;
    final controller = ref.read(gameControllerProvider.notifier);
    final state = ref.read(gameControllerProvider);
    if (state.pendingAction != pending || !_humanFacing(state, pending)) {
      return;
    }
    _open = true;
    try {
      await _show(controller, state, pending);
    } finally {
      _open = false;
      if (mounted) {
        final live = ref.read(gameControllerProvider);
        _shown = live.pendingAction;
        if (_humanFacing(live, live.pendingAction) &&
            live.pendingAction != pending) {
          _schedule(live.pendingAction);
        }
      }
    }
  }

  Future<void> _show(
    GameController controller,
    GameState state,
    PendingAction pending,
  ) async {
    await pending.map(
      none: (_) async {},
      buyOffer: (a) async {
        final stack = state.activePlayer.balance;
        final buy = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => CyberDialogFrame(
            glowColor: CyberColors.terminalGreen,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'HOLOGRAPHIC DEED',
                  style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                        color: CyberColors.neonCyan,
                      ),
                ),
                const SizedBox(height: 8),
                Text('Claim «${a.propertyName}»?'),
                const SizedBox(height: 6),
                Text(
                  GameRules.credits(a.price),
                  style: Theme.of(ctx).textTheme.headlineMedium?.copyWith(
                        color: CyberColors.cyberYellow,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  'YOUR STACK ${GameRules.credits(stack)}',
                  style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                        color: CyberColors.terminalGreen,
                      ),
                ),
              ],
            ),
            actions: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('DECLINE'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('ACQUIRE'),
                  ),
                ),
              ],
            ),
          ),
        );
        if (buy == true) {
          controller.acceptBuy();
        } else {
          controller.declineBuy();
        }
      },
      rentNotice: (a) async {
        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('RENT EXTRACTED'),
            content: Text(
              '${a.payerName} → ${GameRules.credits(a.amount)} → ${a.ownerName}\n'
              'node: «${a.propertyName}»',
            ),
            actions: [
              FilledButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('ACK'),
              ),
            ],
          ),
        );
        controller.dismissNotice();
      },
      taxNotice: (a) async {
        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(a.taxName),
            content: Text(
              '${a.playerName} transfers ${GameRules.credits(a.amount)} to the Bank.',
            ),
            actions: [
              FilledButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('ACK'),
              ),
            ],
          ),
        );
        controller.dismissNotice();
      },
      cardNotice: (a) async {
        await showCyberCardDialog(
          context,
          title: a.title,
          description: a.description,
        );
        controller.dismissNotice();
      },
      auction: (_) => showAuctionDialog(context),
      tradeOffer: (a) async {
        String fromName = a.fromPlayerId;
        String toName = a.toPlayerId;
        for (final p in state.players) {
          if (p.id == a.fromPlayerId) fromName = p.name;
          if (p.id == a.toPlayerId) toName = p.name;
        }
        final ok = await showTradeDialog(
          context,
          offer: a,
          fromName: fromName,
          toName: toName,
          board: state.board,
        );
        if (ok == true) {
          controller.acceptTrade();
        } else {
          controller.declineTrade();
        }
      },
      claimOffer: (a) async {
        final board = state.board;
        final choice = await showDialog<int>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => CyberDialogFrame(
            glowColor: CyberColors.neonMagenta,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'EMINENT DOMAIN',
                  style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                        color: CyberColors.neonMagenta,
                      ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Seize one exposed street for 120% of list price.',
                ),
                const SizedBox(height: 8),
                for (final index in a.cellIndexes)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: FilledButton(
                      onPressed: state.activePlayer.balance >=
                              Nightfall.buyoutPrice(
                                board[index].priceOrNull ?? 0,
                              )
                          ? () => Navigator.pop(ctx, index)
                          : null,
                      child: Text(
                        '${board[index].name} · '
                        '${GameRules.credits(Nightfall.buyoutPrice(board[index].priceOrNull ?? 0))}',
                      ),
                    ),
                  ),
              ],
            ),
            actions: OutlinedButton(
              onPressed: () => Navigator.pop(ctx, -1),
              child: const Text('DECLINE'),
            ),
          ),
        );
        if (choice != null && choice >= 0) {
          controller.acceptClaim(choice);
        } else {
          controller.declineClaim();
        }
      },
      winner: (a) async {
        await showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            title: const Text('PROTOCOL COMPLETE'),
            content: Text(
              'Controlling interest: ${a.playerName}\n'
              'NET ${GameRules.credits(a.netWorth)}',
            ),
            actions: [
              FilledButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  controller.restart();
                },
                child: const Text('REBOOT'),
              ),
            ],
          ),
        );
      },
    );
  }
}
