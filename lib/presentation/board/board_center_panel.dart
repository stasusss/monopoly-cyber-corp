import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/game_rules.dart';
import '../../core/l10n/app_strings.dart';
import '../../core/theme/cyber_theme.dart';
import '../../logic/city_ops.dart';
import '../../models/game_state.dart';
import '../../models/pending_action.dart';
import '../controls/empire_menu.dart';
import 'cell_art.dart';
import '../widgets/animated_credits.dart';
import '../widgets/dice_view.dart';
import '../widgets/turn_action_button.dart';

class BoardCenterPanel extends StatelessWidget {
  const BoardCenterPanel({
    super.key,
    required this.state,
    required this.onRoll,
    required this.onEndTurn,
    required this.onPayJailFine,
    this.inputEnabled = true,
    this.showActions = true,
    this.focusIndex,
    this.onOpenFocus,
  });

  final GameState state;
  final VoidCallback onRoll;
  final VoidCallback onEndTurn;
  final VoidCallback onPayJailFine;
  final bool inputEnabled;

  /// Cell shown large in the center. Null follows the active token.
  final int? focusIndex;
  final VoidCallback? onOpenFocus;

  /// Desktop keeps roll / end / bail in the board center.
  /// Narrow layouts use the bottom bar instead, so the center stays readable.
  final bool showActions;

  bool get _idlePending => state.pendingAction is PendingNone;

  @override
  Widget build(BuildContext context) {
    final canRoll = inputEnabled &&
        state.phase == TurnPhase.waitingForRoll &&
        !state.isGameOver &&
        _idlePending;
    final canEnd = inputEnabled &&
        state.phase == TurnPhase.canEndTurn &&
        !state.isGameOver &&
        _idlePending;
    final inJail = state.activePlayer.inJail;
    final canBail = inputEnabled &&
        inJail &&
        state.phase == TurnPhase.waitingForRoll &&
        !state.isGameOver;
    final lastLine = state.log.isEmpty ? null : state.log.last;
    final s = stringsOf(context);
    final focusAt = focusIndex ?? state.activePlayer.position;
    final focus = state.board[
        focusAt.clamp(0, state.board.length - 1).toInt()];

    final body = Column(
          mainAxisSize: showActions ? MainAxisSize.max : MainAxisSize.min,
          children: [
            if (showActions) ...[
              Text(
                CyberLore.appTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: CyberColors.neonCyan,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                s.appSubtitle,
                style: const TextStyle(
                  color: CyberColors.textMuted,
                  fontSize: 11,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
            ],
            Text(
              s.roundLine(
                state.round,
                GameRules.blitzRoundLimit,
                state.housesInBank,
                state.hotelsInBank,
              ),
              textAlign: TextAlign.center,
              style: GoogleFonts.shareTechMono(
                color: CyberColors.textMuted,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 4),
            CellPortrait(
              cell: focus,
              height: showActions ? 128 : 84,
              onTap: onOpenFocus,
              virusHops: CityOps.virusHopsOf(state, focus.index),
              status: CityOps.consequence(
                state: state,
                cell: focus,
                viewer: state.activePlayer,
                s: s,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              s.activeLine(state.activePlayer.name, inJail),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: CyberColors.cyberYellow,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedCredits(
              amount: state.activePlayer.balance,
              textAlign: TextAlign.center,
              style: GoogleFonts.shareTechMono(
                fontSize: showActions ? 18 : 16,
                fontWeight: FontWeight.w800,
                color: CyberColors.cyberYellow,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(height: 8),
            DiceView(
              roll: state.lastRoll,
              rolling: state.phase == TurnPhase.rolling,
            ),
            if (showActions) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                alignment: WrapAlignment.center,
                children: [
                  TurnActionButton(
                    pulse: canRoll,
                    onPressed: canRoll ? onRoll : null,
                    icon: Icons.casino,
                    label: s.roll,
                  ),
                  if (inJail && state.phase == TurnPhase.waitingForRoll)
                    TurnActionButton(
                      primary: false,
                      pulse: canBail && !canRoll,
                      pulseColor: CyberColors.cyberYellow,
                      onPressed: canBail ? onPayJailFine : null,
                      icon: Icons.lock_open,
                      label: s.bail(GameRules.credits(GameRules.jailFine)),
                    ),
                  TurnActionButton(
                    primary: false,
                    pulse: canEnd,
                    pulseColor: CyberColors.cyberYellow,
                    onPressed: canEnd ? onEndTurn : null,
                    icon: Icons.flag,
                    label: s.endTurn,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const EmpireMenu(),
              const SizedBox(height: 8),
              Expanded(child: _EventLog(lines: state.log)),
            ] else if (lastLine != null) ...[
              const SizedBox(height: 8),
              Text(
                '> $lastLine',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: GoogleFonts.shareTechMono(
                  color: CyberColors.terminalGreen,
                  fontSize: 11,
                  height: 1.25,
                ),
              ),
            ],
          ],
        );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: CyberColors.deepIndigo.withValues(alpha: 0.92),
        border: Border.all(
          color: CyberColors.neonCyan.withValues(alpha: 0.45),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (showActions) return body;
            return FittedBox(
              fit: BoxFit.scaleDown,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: constraints.maxWidth),
                child: body,
              ),
            );
          },
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
              style: GoogleFonts.shareTechMono(
                color: CyberColors.terminalGreen,
                fontSize: 11,
                height: 1.25,
              ),
            ),
          );
        },
      ),
    );
  }
}
