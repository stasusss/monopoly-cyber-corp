import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/cyber_theme.dart';

Future<void> showCyberCardDialog(
  BuildContext context, {
  required String title,
  required String description,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => Dialog(
      backgroundColor: Colors.transparent,
      child: CyberTheme.glass(
        glowColor: title.contains('BREACH')
            ? CyberColors.cyberYellow
            : CyberColors.terminalGreen,
        padding: const EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
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
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('ACKNOWLEDGE'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
