import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/game_rules.dart';
import '../../core/theme/cyber_theme.dart';
import '../../logic/game_controller.dart';
import '../../models/pending_action.dart';
import 'auction_dialog.dart';
import 'card_dialog.dart';
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

  @override
  Widget build(BuildContext context) {
    ref.listen(gameControllerProvider, (prev, next) {
      final pending = next.pendingAction;
      if (pending is PendingNone) {
        _shown = pending;
        return;
      }

      if (pending is PendingAuction) {
        final bidder = next.players
            .where((p) => p.id == pending.currentBidderId)
            .firstOrNull;
        if (bidder == null || bidder.isAi) {
          _shown = pending;
          return;
        }
      } else if (pending is PendingTradeOffer) {
        final to =
            next.players.where((p) => p.id == pending.toPlayerId).firstOrNull;
        if (to == null || to.isAi) {
          _shown = pending;
          return;
        }
      } else if (next.activePlayer.isAi && pending is! PendingWinner) {
        _shown = pending;
        return;
      }

      if (_shown == pending) return;
      _shown = pending;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _present(pending);
      });
    });

    return widget.child;
  }

  Future<void> _present(PendingAction pending) async {
    final controller = ref.read(gameControllerProvider.notifier);
    final state = ref.read(gameControllerProvider);

    await pending.map(
      none: (_) async {},
      buyOffer: (a) async {
        final buy = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => Dialog(
            backgroundColor: Colors.transparent,
            child: CyberTheme.glass(
              glowColor: CyberColors.terminalGreen,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('HOLOGRAPHIC DEED'),
                  const SizedBox(height: 8),
                  Text(
                    'Claim «${a.propertyName}» for ${GameRules.credits(a.price)}?',
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('DECLINE'),
                        ),
                      ),
                      Expanded(
                        child: FilledButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text('ACQUIRE'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
      auction: (a) async {
        String bidderName = a.currentBidderId;
        for (final p in state.players) {
          if (p.id == a.currentBidderId) bidderName = p.name;
        }
        final humanTurn = state.players.any(
          (p) => p.id == a.currentBidderId && !p.isAi,
        );
        await showAuctionDialog(
          context,
          auction: a,
          currentBidderName: bidderName,
          canAct: humanTurn,
          onBid: controller.auctionBid,
          onPass: controller.auctionPass,
        );
      },
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
        );
        if (ok == true) {
          controller.acceptTrade();
        } else {
          controller.declineTrade();
        }
      },
      winner: (a) async {
        await showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            title: const Text('PROTOCOL COMPLETE'),
            content: Text('Controlling interest: ${a.playerName}'),
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

    _shown = const PendingAction.none();
  }
}
