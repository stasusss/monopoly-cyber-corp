import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/cyber_theme.dart';
import '../../logic/game_controller.dart';
import '../../models/game_state.dart';
import '../../models/player.dart';
import '../widgets/cyber_dialogue_bubble.dart';
import 'board_cell_widget.dart';
import 'board_center_panel.dart';
import 'board_geometry.dart';

class MonopolyBoard extends ConsumerStatefulWidget {
  const MonopolyBoard({super.key});

  @override
  ConsumerState<MonopolyBoard> createState() => _MonopolyBoardState();
}

class _MonopolyBoardState extends ConsumerState<MonopolyBoard> {
  bool _stepping = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameControllerProvider);
    final controller = ref.read(gameControllerProvider.notifier);

    ref.listen<GameState>(gameControllerProvider, (prev, next) {
      if (next.phase == TurnPhase.movingToken &&
          next.moveStepsLeft > 0 &&
          !_stepping) {
        _runMoveSteps(controller);
      }
    });

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Center(
        child: AspectRatio(
          aspectRatio: 1,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final size = Size(constraints.maxWidth, constraints.maxHeight);
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: CyberColors.voidBlack,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: CyberColors.neonCyan, width: 2),
                  boxShadow: CyberTheme.glow(CyberColors.neonCyan, blur: 18),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      CyberColors.voidBlack,
                      CyberColors.deepIndigo,
                      CyberColors.voidBlack,
                    ],
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Stack(
                    children: [
                      ..._buildCells(state, size),
                      _buildCenter(size, state, controller),
                      ..._buildTokens(state, size),
                      const CyberDialogueBubble(),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _runMoveSteps(GameController controller) async {
    _stepping = true;
    while (mounted &&
        ref.read(gameControllerProvider).phase == TurnPhase.movingToken &&
        ref.read(gameControllerProvider).moveStepsLeft > 0) {
      await Future<void>.delayed(const Duration(milliseconds: 220));
      if (!mounted) break;
      controller.advanceMoveStep();
    }
    _stepping = false;
  }

  List<Widget> _buildCells(GameState state, Size size) {
    return [
      for (final cell in state.board)
        Positioned.fromRect(
          rect: BoardGeometry.cellRect(size, cell.index),
          child: BoardCellWidget(
            cell: cell,
            ownerColor: _ownerColor(state, cell.ownerIdOrNull),
          ),
        ),
    ];
  }

  Widget _buildCenter(Size size, GameState state, GameController controller) {
    final cell = size.width / BoardGeometry.gridSize;
    return Positioned(
      left: cell,
      top: cell,
      width: cell * 9,
      height: cell * 9,
      child: BoardCenterPanel(
        state: state,
        onRoll: controller.rollDice,
        onEndTurn: controller.endTurn,
        onPayJailFine: controller.payJailFine,
      ),
    );
  }

  List<Widget> _buildTokens(GameState state, Size size) {
    final byCell = <int, List<Player>>{};
    for (final p in state.players.where((p) => !p.isBankrupt)) {
      byCell.putIfAbsent(p.position, () => []).add(p);
    }

    final widgets = <Widget>[];
    for (final entry in byCell.entries) {
      final players = entry.value;
      for (var i = 0; i < players.length; i++) {
        final p = players[i];
        final center = BoardGeometry.tokenOffset(
          boardSize: size,
          index: entry.key,
          tokenSlot: i,
          tokensOnCell: players.length,
        );
        final tokenSize = size.width / BoardGeometry.gridSize * 0.38;
        final isActive = p.id == state.activePlayer.id;

        widgets.add(
          AnimatedPositioned(
            key: ValueKey('token-${p.id}'),
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            left: center.dx - tokenSize / 2,
            top: center.dy - tokenSize / 2,
            width: tokenSize,
            height: tokenSize,
            child: _TokenChip(player: p, highlighted: isActive),
          ),
        );
      }
    }
    return widgets;
  }

  Color? _ownerColor(GameState state, String? ownerId) {
    if (ownerId == null) return null;
    for (final p in state.players) {
      if (p.id == ownerId) return p.tokenColor.color;
    }
    return null;
  }
}

class _TokenChip extends StatelessWidget {
  const _TokenChip({required this.player, required this.highlighted});

  final Player player;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: player.tokenColor.color,
        shape: BoxShape.circle,
        border: Border.all(
          color: highlighted ? Colors.white : Colors.black87,
          width: highlighted ? 2.5 : 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: highlighted ? 6 : 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        player.name.isNotEmpty ? player.name[0].toUpperCase() : '?',
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w900,
          color: Colors.white,
          shadows: [Shadow(color: Colors.black54, blurRadius: 2)],
        ),
      ),
    );
  }
}
