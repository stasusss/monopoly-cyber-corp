import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/game_rules.dart';
import '../../core/l10n/app_strings.dart';
import '../../core/theme/cyber_theme.dart';
import '../../logic/game_controller.dart';
import '../../logic/nightfall.dart';
import '../../models/pending_action.dart';
import 'cyber_dialog_frame.dart';

/// One auction dialog for the whole lot. It follows the live bid instead of
/// stacking a new route every time the high number changes.
Future<void> showAuctionDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => const _LiveAuctionDialog(),
  );
}

class _LiveAuctionDialog extends ConsumerStatefulWidget {
  const _LiveAuctionDialog();

  @override
  ConsumerState<_LiveAuctionDialog> createState() => _LiveAuctionDialogState();
}

class _LiveAuctionDialogState extends ConsumerState<_LiveAuctionDialog> {
  var _closed = false;

  void _close() {
    if (_closed || !mounted) return;
    _closed = true;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameControllerProvider);
    final pending = state.pendingAction;
    if (pending is! PendingAuction) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _close());
      return const SizedBox.shrink();
    }

    final bidder = state.players
        .where((p) => p.id == pending.currentBidderId)
        .firstOrNull;
    final leader = state.players
        .where((p) => p.id == pending.highestBidderId)
        .firstOrNull;
    final canAct = bidder != null && !bidder.isAi;

    return _AuctionBody(
      auction: pending,
      floor: Nightfall.minAuctionBid(pending.highestBid),
      actorName: bidder?.name ?? pending.currentBidderId,
      leaderName: leader?.name,
      canAct: canAct,
      yourBalance: bidder?.balance,
      onBid: (amount) {
        ref.read(gameControllerProvider.notifier).auctionBid(amount);
      },
      onPass: () {
        ref.read(gameControllerProvider.notifier).auctionPass();
      },
    );
  }
}

class _AuctionBody extends StatefulWidget {
  const _AuctionBody({
    required this.auction,
    required this.floor,
    required this.actorName,
    required this.leaderName,
    required this.canAct,
    required this.yourBalance,
    required this.onBid,
    required this.onPass,
  });

  final PendingAuction auction;
  final int floor;
  final String actorName;
  final String? leaderName;
  final bool canAct;
  final int? yourBalance;
  final void Function(int bid) onBid;
  final VoidCallback onPass;

  @override
  State<_AuctionBody> createState() => _AuctionBodyState();
}

class _AuctionBodyState extends State<_AuctionBody> {
  late final TextEditingController _amount = TextEditingController(
    text: '${widget.floor}',
  );

  @override
  void didUpdateWidget(covariant _AuctionBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.floor != widget.floor) {
      _amount.text = '${widget.floor}';
    }
  }

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  void _submit() {
    final amount = int.tryParse(_amount.text.trim());
    if (amount == null || amount < widget.floor) return;
    if (widget.yourBalance != null && amount > widget.yourBalance!) return;
    widget.onBid(amount);
  }

  @override
  Widget build(BuildContext context) {
    final s = stringsOf(context);
    final auction = widget.auction;
    final high = auction.highestBid <= 0
        ? s.noBidsYet
        : s.auctionHigh(
            GameRules.credits(auction.highestBid),
            widget.leaderName,
          );
    return CyberDialogFrame(
      glowColor: CyberColors.neonMagenta,
      maxWidth: 380,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            s.liveAuction,
            style: GoogleFonts.orbitron(
              color: CyberColors.neonMagenta,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            auction.propertyName,
            style: GoogleFonts.rajdhani(
              color: CyberColors.neonCyan,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            high,
            style: GoogleFonts.shareTechMono(
              color: CyberColors.cyberYellow,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          Text(
            widget.canAct
                ? s.yourBid(widget.actorName)
                : s.waitingOn(widget.actorName),
            style: GoogleFonts.shareTechMono(color: CyberColors.textMuted),
          ),
          Text(
            s.minimumBid(GameRules.credits(widget.floor)),
            style: GoogleFonts.shareTechMono(
              color: CyberColors.textMuted,
              fontSize: 12,
            ),
          ),
          if (widget.yourBalance != null && widget.canAct) ...[
            const SizedBox(height: 6),
            Text(
              s.yourStack(GameRules.credits(widget.yourBalance!)),
              style: GoogleFonts.shareTechMono(
                color: CyberColors.terminalGreen,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
          if (widget.canAct) ...[
            const SizedBox(height: 12),
            TextField(
              controller: _amount,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: GoogleFonts.shareTechMono(color: CyberColors.textPrimary),
              decoration: InputDecoration(
                labelText: s.yourBidField,
                isDense: true,
              ),
              onSubmitted: (_) => _submit(),
            ),
          ],
        ],
      ),
      actions: widget.canAct
          ? Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: _submit,
                    child: Text(s.bid),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: widget.onPass,
                    child: Text(s.pass),
                  ),
                ),
              ],
            )
          : Text(
              s.waitingForBidder,
              style: GoogleFonts.shareTechMono(color: CyberColors.textMuted),
            ),
    );
  }
}
