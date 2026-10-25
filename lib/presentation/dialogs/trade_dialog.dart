import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/game_rules.dart';
import '../../core/theme/cyber_theme.dart';
import '../../models/pending_action.dart';

Future<bool?> showTradeDialog(
  BuildContext context, {
  required PendingTradeOffer offer,
  required String fromName,
  required String toName,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => Dialog(
      backgroundColor: Colors.transparent,
      child: CyberTheme.glass(
        glowColor: CyberColors.neonCyan,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              Text(
                '${GameRules.credits(offer.offerCash)} + props ${offer.offerProperties}',
                style: GoogleFonts.shareTechMono(color: CyberColors.terminalGreen),
              ),
              const SizedBox(height: 8),
              Text('Requests from $toName:',
                  style: GoogleFonts.rajdhani(color: CyberColors.textMuted)),
              Text(
                '${GameRules.credits(offer.requestCash)} + props ${offer.requestProperties}',
                style: GoogleFonts.shareTechMono(color: CyberColors.cyberYellow),
              ),
              const SizedBox(height: 14),
              Row(
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
            ],
          ),
        ),
      ),
    ),
  );
}
