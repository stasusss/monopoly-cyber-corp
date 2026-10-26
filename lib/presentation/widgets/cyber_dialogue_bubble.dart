import 'dart:async';

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
  String? _dismissed;
  Timer? _hide;

  @override
  void dispose() {
    _hide?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameControllerProvider);
    final line = state.aiDialogue;
    final speakerId = state.aiDialogueSpeakerId;

    if (line == null || line.isEmpty || speakerId == null || line == _dismissed) {
      return const SizedBox.shrink();
    }

    if (line != _lastFull) {
      _lastFull = line;
      _visible = '';
      _type(line);
      _hide?.cancel();
      final hold = Duration(milliseconds: line.length * 16 + 3200);
      _hide = Timer(hold, () {
        if (!mounted || _lastFull != line) return;
        setState(() => _dismissed = line);
      });
    }

    Player? speaker;
    for (final p in state.players) {
      if (p.id == speakerId) speaker = p;
    }
    if (speaker == null) return const SizedBox.shrink();

    final ink = speaker.tokenColor.ink;
    return IgnorePointer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: DecoratedBox(
            decoration: BoxDecoration(
              color: CyberColors.deepIndigo.withValues(alpha: 0.96),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: speaker.tokenColor.color.withValues(alpha: 0.85),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: speaker.tokenColor.color,
                    child: Text(
                      speaker.name.isNotEmpty
                          ? speaker.name[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                        color: ink,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          speaker.name.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.orbitron(
                            color: speaker.tokenColor.color,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _visible,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.shareTechMono(
                            color: CyberColors.textPrimary,
                            fontSize: 12,
                            height: 1.25,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
