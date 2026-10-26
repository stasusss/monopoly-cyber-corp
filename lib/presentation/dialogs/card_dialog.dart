import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/cyber_theme.dart';
import 'cyber_dialog_frame.dart';

Future<void> showCyberCardDialog(
  BuildContext context, {
  required String title,
  required String description,
}) {
  final breach = title.contains('BREACH');
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => CyberDialogFrame(
      glowColor: breach ? CyberColors.cyberYellow : CyberColors.terminalGreen,
      maxWidth: 360,
      body: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.orbitron(
              color: CyberColors.neonCyan,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            textAlign: TextAlign.center,
            style: GoogleFonts.rajdhani(
              color: CyberColors.textPrimary,
              fontSize: 16,
              height: 1.35,
            ),
          ),
        ],
      ),
      actions: FilledButton(
        onPressed: () => Navigator.pop(ctx),
        child: const Text('ACKNOWLEDGE'),
      ),
    ),
  );
}
