import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/game_rules.dart';
import '../../core/l10n/app_strings.dart';
import '../../core/theme/cyber_theme.dart';
import '../../logic/game_controller.dart';
import '../../logic/nightfall.dart';
import '../../models/cell.dart';
import '../../models/game_state.dart';
import '../../models/pending_action.dart';
import '../board/cell_art.dart';
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
    if (pending is PendingCityVote) {
      final leader = state.players
          .where((p) => p.id == pending.leaderId)
          .firstOrNull;
      return leader != null && !leader.isAi;
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
          builder: (ctx) {
            final s = stringsOf(ctx);
            return CyberDialogFrame(
            glowColor: CyberColors.terminalGreen,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  s.holographicDeed,
                  style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                        color: CyberColors.neonCyan,
                      ),
                ),
                const SizedBox(height: 8),
                CellPortrait(
                  cell: state.board[a.cellIndex],
                  height: 140,
                  showCaption: false,
                ),
                const SizedBox(height: 8),
                Text(s.claimAsk(a.propertyName)),
                const SizedBox(height: 6),
                Text(
                  GameRules.credits(a.price),
                  style: Theme.of(ctx).textTheme.headlineMedium?.copyWith(
                        color: CyberColors.cyberYellow,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  s.yourStack(GameRules.credits(stack)),
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
                    child: Text(s.decline),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: Text(s.acquire),
                  ),
                ),
              ],
            ),
          );
          },
        );
        if (buy == true) {
          controller.acceptBuy();
        } else {
          controller.declineBuy();
        }
      },
      rentNotice: (a) async {
        final dodged = await showDialog<bool>(
          context: context,
          builder: (ctx) {
            final s = stringsOf(ctx);
            return AlertDialog(
            title: Text(s.rentExtracted),
            content: Text(
              s.rentBody(
                a.payerName,
                GameRules.credits(a.amount),
                a.ownerName,
                a.propertyName,
              ),
            ),
            actions: [
              if (a.canDodge)
                TextButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: Text(s.dodgeRent),
                ),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(a.canDodge ? s.payNow : s.ack),
              ),
            ],
          );
          },
        );
        if (dodged == true) {
          controller.dodgeRent();
        } else {
          controller.dismissNotice();
        }
      },
      taxNotice: (a) async {
        await showDialog<void>(
          context: context,
          builder: (ctx) {
            final s = stringsOf(ctx);
            return AlertDialog(
            title: Text(a.taxName),
            content: Text(s.taxBody(a.playerName, GameRules.credits(a.amount))),
            actions: [
              FilledButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(s.ack),
              ),
            ],
          );
          },
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
          builder: (ctx) {
            final s = stringsOf(ctx);
            return CyberDialogFrame(
            glowColor: CyberColors.neonMagenta,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  s.eminentDomain,
                  style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                        color: CyberColors.neonMagenta,
                      ),
                ),
                const SizedBox(height: 8),
                Text(s.seizeHint),
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
              child: Text(s.decline),
            ),
          );
          },
        );
        if (choice != null && choice >= 0) {
          controller.acceptClaim(choice);
        } else {
          controller.declineClaim();
        }
      },
      shortfall: (a) async {
        await showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => _ShortfallDialog(
            amount: a.amount,
            label: a.label,
            onPay: () {
              Navigator.pop(ctx);
              controller.settleShortfall();
            },
            onFlatline: () {
              Navigator.pop(ctx);
              controller.abandonShortfall();
            },
          ),
        );
      },
      cityVote: (a) async {
        final kind = await showDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) {
            final s = stringsOf(ctx);
            return AlertDialog(
              title: Text(s.cityTitle),
              content: Text(s.cityBody(a.round)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, 'rentSurge'),
                  child: Text(s.decreeSurge),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(ctx, 'maglevFree'),
                  child: Text(s.decreeMaglev),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(ctx, 'taxHoliday'),
                  child: Text(s.decreeTax),
                ),
              ],
            );
          },
        );
        if (kind != null) controller.chooseDecree(kind);
      },
      heatCheck: (a) async {
        final pay = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) {
            final s = stringsOf(ctx);
            return AlertDialog(
              title: Text(s.heatTitle),
              content: Text(s.heatBody(GameRules.credits(a.fine))),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text(s.sitIce),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: Text(s.payHeat),
                ),
              ],
            );
          },
        );
        controller.resolveHeat(pay: pay ?? false);
      },
      winner: (a) async {
        await showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) {
            final s = stringsOf(ctx);
            return AlertDialog(
            title: Text(s.protocolComplete),
            content: Text(
              s.winnerBody(a.playerName, GameRules.credits(a.netWorth)),
            ),
            actions: [
              FilledButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  controller.restart();
                },
                child: Text(s.reboot),
              ),
            ],
          );
          },
        );
      },
    );
  }
}

class _ShortfallDialog extends ConsumerWidget {
  const _ShortfallDialog({
    required this.amount,
    required this.label,
    required this.onPay,
    required this.onFlatline,
  });

  final int amount;
  final String label;
  final VoidCallback onPay;
  final VoidCallback onFlatline;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = stringsOf(context);
    final state = ref.watch(gameControllerProvider);
    final controller = ref.read(gameControllerProvider.notifier);
    final me = state.activePlayer;
    final actions = <Widget>[];
    for (final index in me.propertyIndexes) {
      final cell = state.cellAt(index);
      if (cell is PropertyCell && cell.houses > 0) {
        if (Nightfall.rackSellBlock(
              state: state,
              cell: cell,
              player: me,
              strings: s,
            ) ==
            null) {
          final refund = Nightfall.nodeRefund(cell.colorGroup, cell.houses);
          actions.add(
            TextButton(
              onPressed: () => controller.sellNode(index),
              child: Text('${cell.name} · ${s.sellLabel(GameRules.credits(refund))}'),
            ),
          );
        }
      } else if (cell.isOwnable && !cell.isMortgagedOrFalse) {
        actions.add(
          TextButton(
            onPressed: () => controller.pledgeProperty(index),
            child: Text(
              '${cell.name} · ${s.mortgageLabel(GameRules.credits(Nightfall.mortgageValue(cell)))}',
            ),
          ),
        );
      }
    }
    return AlertDialog(
      title: Text(s.shortfallTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(s.shortfallBody(GameRules.credits(amount), label)),
            const SizedBox(height: 8),
            Text(s.yourStack(GameRules.credits(me.balance))),
            ...actions,
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: onFlatline, child: Text(s.flatline)),
        FilledButton(
          onPressed: me.balance >= amount ? onPay : null,
          child: Text(s.payNow),
        ),
      ],
    );
  }
}
