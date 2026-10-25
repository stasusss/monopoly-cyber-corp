import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/cyber_theme.dart';
import '../../logic/game_controller.dart';
import '../../models/player.dart';

/// Typewriter cyber banter overlay for AI operatives.
class CyberDialogueBubble extends ConsumerStatefulWidget {
  const CyberDialogueBubble({super.key});

  @override
  ConsumerState<CyberDialogueBubble> createState() =>
      _CyberDialogueBubbleState();
}

class _CyberDialogueBubbleState extends ConsumerState<CyberDialogueBubble> {
  String _visible = '';
  String? _lastFull;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameControllerProvider);
    final line = state.aiDialogue;
    final speakerId = state.aiDialogueSpeakerId;

    if (line == null || line.isEmpty || speakerId == null) {
      return const SizedBox.shrink();
    }

    if (line != _lastFull) {
      _lastFull = line;
      _visible = '';
      _type(line);
    }

    Player? speaker;
    for (final p in state.players) {
      if (p.id == speakerId) speaker = p;
    }
    if (speaker == null) return const SizedBox.shrink();

    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
        child: CyberTheme.glass(
          glowColor: speaker.tokenColor.color,
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: speaker.tokenColor.color,
                child: Text(
                  speaker.name.isNotEmpty ? speaker.name[0].toUpperCase() : '?',
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      speaker.name.toUpperCase(),
                      style: GoogleFonts.orbitron(
                        color: speaker.tokenColor.color,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _visible,
                      style: GoogleFonts.shareTechMono(
                        color: CyberColors.textPrimary,
                        fontSize: 12,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _type(String full) async {
    for (var i = 1; i <= full.length; i++) {
      if (!mounted || _lastFull != full) return;
      setState(() => _visible = full.substring(0, i));
      await Future<void>.delayed(const Duration(milliseconds: 16));
    }
  }
}
