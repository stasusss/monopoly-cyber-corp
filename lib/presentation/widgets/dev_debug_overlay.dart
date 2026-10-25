import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/game_rules.dart';
import '../../core/theme/cyber_theme.dart';
import '../../logic/game_controller.dart';

/// Floating QA cheat panel — compiled away visually unless [kDebugMode].
class DevDebugOverlay extends ConsumerStatefulWidget {
  const DevDebugOverlay({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<DevDebugOverlay> createState() => _DevDebugOverlayState();
}

class _DevDebugOverlayState extends ConsumerState<DevDebugOverlay> {
  bool _open = false;
  int _teleportIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) return widget.child;

    return Stack(
      children: [
        widget.child,
        Positioned(
          right: 12,
          bottom: 12,
          child: FloatingActionButton.small(
            heroTag: 'dev-debug-fab',
            backgroundColor: CyberColors.neonMagenta.withValues(alpha: 0.9),
            foregroundColor: CyberColors.voidBlack,
            tooltip: 'DEV DEBUG',
            onPressed: () => setState(() => _open = !_open),
            child: Icon(_open ? Icons.close : Icons.bug_report),
          ),
        ),
        if (_open)
          Positioned(
            right: 12,
            bottom: 68,
            width: 300,
            child: Material(
              color: Colors.transparent,
              child: CyberTheme.glass(
                glowColor: CyberColors.neonMagenta,
                padding: const EdgeInsets.all(12),
                child: _panel(context),
              ),
            ),
          ),
      ],
    );
  }

  Widget _panel(BuildContext context) {
    final c = ref.read(gameControllerProvider.notifier);
    final state = ref.watch(gameControllerProvider);
    final cellName = state.board[_teleportIndex.clamp(0, 39)].name;

    return DefaultTextStyle(
      style: GoogleFonts.shareTechMono(
        color: CyberColors.textPrimary,
        fontSize: 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'DEV DEBUG · ${state.activePlayer.name}',
            style: GoogleFonts.orbitron(
              color: CyberColors.neonMagenta,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text('TELEPORT → $_teleportIndex'),
          Text(
            cellName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: CyberColors.neonCyan, fontSize: 11),
          ),
          Slider(
            value: _teleportIndex.toDouble(),
            min: 0,
            max: 39,
            divisions: 39,
            activeColor: CyberColors.neonCyan,
            label: '$_teleportIndex',
            onChanged: (v) => setState(() => _teleportIndex = v.round()),
          ),
          FilledButton(
            onPressed: () => c.debugTeleport(_teleportIndex),
            child: const Text('EXECUTE TELEPORT'),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => c.debugAdjustCredits(500),
                  child: Text('+${GameRules.credits(500)}'),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => c.debugAdjustCredits(-500),
                  child: Text('-${GameRules.credits(500)}'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          FilledButton.tonal(
            onPressed: c.debugForceAiTurn,
            child: const Text('FORCE AI TURN'),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => c.debugDrawCard(dataBreach: true),
                  child: const Text('DATA BREACH'),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => c.debugDrawCard(dataBreach: false),
                  child: const Text('CORPO BOUNTY'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'phase: ${state.phase.name}',
            style: const TextStyle(color: CyberColors.textMuted, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
