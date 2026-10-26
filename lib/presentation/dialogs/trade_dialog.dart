import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/game_rules.dart';
import '../../core/theme/cyber_theme.dart';
import '../../models/cell.dart';
import '../../models/pending_action.dart';
import 'cyber_dialog_frame.dart';

Future<bool?> showTradeDialog(
  BuildContext context, {
  required PendingTradeOffer offer,
  required String fromName,
  required String toName,
  required List<BoardCell> board,
}) {
  String names(List<int> indexes) {
    if (indexes.isEmpty) return 'no streets';
    return indexes.map((i) {
      if (i < 0 || i >= board.length) return '#$i';
      return board[i].name;
    }).join(', ');
  }

  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => CyberDialogFrame(
      glowColor: CyberColors.neonCyan,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'TRADE PROTOCOL',
            style: GoogleFonts.orbitron(
              color: CyberColors.neonCyan,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text('$fromName offers:',
              style: GoogleFonts.rajdhani(color: CyberColors.textMuted)),
          const SizedBox(height: 4),
          Text(
            GameRules.credits(offer.offerCash),
            style: GoogleFonts.shareTechMono(
              color: CyberColors.terminalGreen,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          Text(
            names(offer.offerProperties),
            style: GoogleFonts.shareTechMono(color: CyberColors.terminalGreen),
          ),
          const SizedBox(height: 8),
          Text('Requests from $toName:',
              style: GoogleFonts.rajdhani(color: CyberColors.textMuted)),
          const SizedBox(height: 4),
          Text(
            GameRules.credits(offer.requestCash),
            style: GoogleFonts.shareTechMono(
              color: CyberColors.cyberYellow,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          Text(
            names(offer.requestProperties),
            style: GoogleFonts.shareTechMono(color: CyberColors.cyberYellow),
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
              child: const Text('ACCEPT'),
            ),
          ),
        ],
      ),
    ),
  );
}
