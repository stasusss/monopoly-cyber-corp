import 'package:flutter/material.dart';

import '../../core/constants/game_rules.dart';
import '../../core/theme/cyber_theme.dart';
import '../../models/game_state.dart';
import '../../models/pending_action.dart';
import '../widgets/dice_view.dart';

class BoardCenterPanel extends StatelessWidget {
  const BoardCenterPanel({
    super.key,
    required this.state,
    required this.onRoll,
    required this.onEndTurn,
    required this.onPayJailFine,
  });

  final GameState state;
  final VoidCallback onRoll;
  final VoidCallback onEndTurn;
  final VoidCallback onPayJailFine;

  bool get _idlePending => state.pendingAction is PendingNone;

  @override
  Widget build(BuildContext context) {
    final canRoll = state.phase == TurnPhase.waitingForRoll &&
        !state.isGameOver &&
        _idlePending;
    final canEnd = state.phase == TurnPhase.canEndTurn &&
        !state.isGameOver &&
        _idlePending;
    final inJail = state.activePlayer.inJail;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: CyberColors.deepIndigo.withValues(alpha: 0.92),
        border: Border.all(
          color: CyberColors.neonCyan.withValues(alpha: 0.45),
        ),
        boxShadow: [
          BoxShadow(
            color: CyberColors.neonCyan.withValues(alpha: 0.12),
            blurRadius: 20,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              CyberLore.appTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: CyberColors.neonCyan,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    shadows: [
                      Shadow(
                        color: CyberColors.neonCyan.withValues(alpha: 0.8),
                        blurRadius: 12,
                      ),
                    ],
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              CyberLore.appSubtitle,
              style: const TextStyle(
                color: CyberColors.textMuted,
                fontSize: 11,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'ACTIVE: ${state.activePlayer.name}'
              '${inJail ? ' · ICE LOCK' : ''}',
              style: const TextStyle(
                color: CyberColors.cyberYellow,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            DiceView(
              roll: state.lastRoll,
              rolling: state.phase == TurnPhase.rolling,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              alignment: WrapAlignment.center,
              children: [
                FilledButton.tonalIcon(
                  onPressed: canRoll ? onRoll : null,
                  icon: const Icon(Icons.casino, size: 18),
                  label: const Text('ROLL'),
                ),
                if (inJail && state.phase == TurnPhase.waitingForRoll)
                  OutlinedButton(
                    onPressed: onPayJailFine,
                    child:
                        Text('BAIL ${GameRules.credits(GameRules.jailFine)}'),
                  ),
                OutlinedButton.icon(
                  onPressed: canEnd ? onEndTurn : null,
                  icon: const Icon(Icons.flag, size: 18),
                  label: const Text('END TURN'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(child: _EventLog(lines: state.log)),
          ],
        ),
      ),
    );
  }
}

class _EventLog extends StatelessWidget {
  const _EventLog({required this.lines});

  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    final recent = lines.length <= 8 ? lines : lines.sublist(lines.length - 8);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: CyberColors.terminalGreen.withValues(alpha: 0.25),
        ),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: recent.length,
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              '> ${recent[i]}',
              style: const TextStyle(
                color: CyberColors.terminalGreen,
                fontSize: 11,
                height: 1.25,
                fontFamily: 'monospace',
              ),
            ),
          );
        },
      ),
    );
  }
}
