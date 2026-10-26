import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/l10n/app_lang.dart';
import '../../core/l10n/app_strings.dart';
import '../../core/theme/cyber_theme.dart';
import '../../logic/game_controller.dart';
import '../../models/cell.dart';
import '../../models/player.dart';
import '../widgets/animated_credits.dart';

class PlayerHud extends ConsumerWidget {
  const PlayerHud({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(appLangProvider);
    final state = ref.watch(gameControllerProvider);

    return Container(
      margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      decoration: CyberTheme.neonBorder(
        color: CyberColors.neonCyan,
        fill: CyberColors.deepIndigo,
        radius: 10,
      ),
      child: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: state.players.length,
        separatorBuilder: (_, _) => const Divider(height: 16),
        itemBuilder: (context, i) {
          final player = state.players[i];
          final active = i == state.activePlayerIndex;
          final props = player.propertyIndexes
              .map((idx) => state.board[idx])
              .toList();

          return _PlayerCard(
            player: player,
            active: active,
            properties: props,
          );
        },
      ),
    );
  }
}

class PlayerHudDrawer extends StatelessWidget {
  const PlayerHudDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Drawer(
      backgroundColor: CyberColors.deepIndigo,
      child: SafeArea(child: PlayerHud()),
    );
  }
}

class _PlayerCard extends StatelessWidget {
  const _PlayerCard({
    required this.player,
    required this.active,
    required this.properties,
  });

  final Player player;
  final bool active;
  final List<BoardCell> properties;

  @override
  Widget build(BuildContext context) {
    final s = stringsOf(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: active ? player.tokenColor.color : Colors.transparent,
          width: 2,
        ),
        color: active
            ? player.tokenColor.color.withValues(alpha: 0.08)
            : Colors.transparent,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: player.tokenColor.color,
                  child: Text(
                    player.name.isNotEmpty
                        ? player.name[0].toUpperCase()
                        : '?',
                    style: TextStyle(
                      fontSize: 12,
                      color: player.tokenColor.ink,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${player.name}${player.isAi ? ' (${s.aiTag(player.aiProfile)})' : ''}'
                    '${player.isBankrupt ? ' — ${s.bankrupt}' : ''}'
                    '${player.inJail ? ' 🔒' : ''}',
                    style: TextStyle(
                      fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                      decoration:
                          player.isBankrupt ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
                AnimatedCredits(
                  amount: player.balance,
                  style: GoogleFonts.shareTechMono(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: CyberColors.cyberYellow,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
            if (properties.isNotEmpty) ...[
              const SizedBox(height: 6),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: [
                  for (final cell in properties)
                    Chip(
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      label: Text(
                        cell.name,
                        style: const TextStyle(fontSize: 10),
                      ),
                      padding: EdgeInsets.zero,
                      labelPadding: const EdgeInsets.symmetric(horizontal: 6),
                    ),
                ],
              ),
            ] else
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  s.noHoldings,
                  style: TextStyle(fontSize: 11, color: CyberColors.textMuted),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
