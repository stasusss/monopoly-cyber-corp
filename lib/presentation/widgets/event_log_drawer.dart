import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/l10n/app_lang.dart';
import '../../core/l10n/app_strings.dart';
import '../../core/theme/cyber_theme.dart';
import '../../logic/game_controller.dart';

class EventLogDrawer extends ConsumerWidget {
  const EventLogDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppStrings(ref.watch(appLangProvider));
    final log = ref.watch(gameControllerProvider.select((s) => s.log));

    return Drawer(
      backgroundColor: CyberColors.voidBlack,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                s.eventStream,
                style: GoogleFonts.orbitron(
                  color: CyberColors.terminalGreen,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
            ),
            const Divider(color: CyberColors.gridLine),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: log.length,
                itemBuilder: (context, i) {
                  final line = log[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.shareTechMono(
                          color: CyberColors.textMuted,
                          fontSize: 12,
                          height: 1.35,
                        ),
                        children: _colorize(line),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<InlineSpan> _colorize(String line) {
    final spans = <InlineSpan>[
      TextSpan(
        text: '› ',
        style: GoogleFonts.shareTechMono(color: CyberColors.terminalGreen),
      ),
    ];
    final credit = RegExp(r'₵\d+');
    var start = 0;
    for (final m in credit.allMatches(line)) {
      if (m.start > start) {
        spans.add(TextSpan(text: line.substring(start, m.start)));
      }
      spans.add(TextSpan(
        text: m.group(0),
        style: const TextStyle(
          color: CyberColors.cyberYellow,
          fontWeight: FontWeight.w700,
        ),
      ));
      start = m.end;
    }
    if (start < line.length) {
      spans.add(TextSpan(text: line.substring(start)));
    }
    return spans;
  }
}
