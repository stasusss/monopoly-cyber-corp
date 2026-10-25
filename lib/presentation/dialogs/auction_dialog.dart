import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/game_rules.dart';
import '../../core/theme/cyber_theme.dart';
import '../../models/pending_action.dart';

Future<void> showAuctionDialog(
  BuildContext context, {
  required PendingAuction auction,
  required String currentBidderName,
  required bool canAct,
  required void Function(int bid) onBid,
  required VoidCallback onPass,
}) {
  final nextBid = auction.highestBid + 10;
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => Dialog(
      backgroundColor: Colors.transparent,
      child: CyberTheme.glass(
        glowColor: CyberColors.neonMagenta,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'LIVE AUCTION',
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
                'High: ${GameRules.credits(auction.highestBid)}'
                '${auction.highestBidderId != null ? '' : ' (none)'}',
                style: GoogleFonts.shareTechMono(color: CyberColors.cyberYellow),
              ),
              Text(
                'Bidder: $currentBidderName',
                style: GoogleFonts.shareTechMono(color: CyberColors.textMuted),
              ),
              const SizedBox(height: 14),
              if (canAct)
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          onBid(nextBid);
                        },
                        child: Text('BID ${GameRules.credits(nextBid)}'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          onPass();
                        },
                        child: const Text('PASS'),
                      ),
                    ),
                  ],
                )
              else
                Text(
                  'Waiting for AI bidder…',
                  style: GoogleFonts.shareTechMono(
                    color: CyberColors.textMuted,
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}
