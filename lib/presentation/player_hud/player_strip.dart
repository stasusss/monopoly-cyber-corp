import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/cyber_theme.dart';
import '../../logic/game_controller.dart';
import '../../models/player.dart';
import '../widgets/animated_credits.dart';

/// Always-on turn strip for narrow layouts: avatar, name, credits.
class PlayerStrip extends ConsumerWidget {
  const PlayerStrip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameControllerProvider);

    return SizedBox(
      height: 48,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
        child: Row(
          children: [
            for (var i = 0; i < state.players.length; i++) ...[
              if (i > 0) const SizedBox(width: 4),
              Expanded(
                child: _StripChip(
                  player: state.players[i],
                  active: i == state.activePlayerIndex,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StripChip extends StatelessWidget {
  const _StripChip({required this.player, required this.active});

  final Player player;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = player.tokenColor.color;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: active ? color.withValues(alpha: 0.14) : CyberColors.panel,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: active ? color : CyberColors.gridLine,
          width: active ? 1.6 : 0.8,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Row(
          children: [
            CircleAvatar(
              radius: 10,
              backgroundColor: color,
              child: Text(
                player.name.isNotEmpty ? player.name[0].toUpperCase() : '?',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: player.tokenColor.ink,
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    player.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.rajdhani(
                      color: player.isBankrupt
                          ? CyberColors.textMuted
                          : CyberColors.textPrimary,
                      fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                      fontSize: 12,
                      decoration: player.isBankrupt
                          ? TextDecoration.lineThrough
                          : null,
                      height: 1,
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: AnimatedCredits(
                      amount: player.balance,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.shareTechMono(
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                        color: CyberColors.cyberYellow,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
