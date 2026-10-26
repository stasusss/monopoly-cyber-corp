import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/cyber_theme.dart';
import '../../logic/game_controller.dart';
import '../../models/game_state.dart';
import '../../models/pending_action.dart';
import '../../models/player.dart';
import '../widgets/cyber_dialogue_bubble.dart';
import '../widgets/signal_lost_banner.dart';
import 'board_cell_widget.dart';
import 'board_center_panel.dart';
import 'board_geometry.dart';
import 'cell_deed_sheet.dart';

class MonopolyBoard extends ConsumerStatefulWidget {
  const MonopolyBoard({super.key});

  @override
  ConsumerState<MonopolyBoard> createState() => _MonopolyBoardState();
}

class _MonopolyBoardState extends ConsumerState<MonopolyBoard> {
  bool _stepping = false;
  int? _selected;
  String? _rentPayer;
  String? _rentOwner;
  final TransformationController _transform = TransformationController();
  bool _zoomed = false;

  @override
  void initState() {
    super.initState();
    _transform.addListener(_onTransform);
  }

  @override
  void dispose() {
    _transform.removeListener(_onTransform);
    _transform.dispose();
    super.dispose();
  }

  void _onTransform() {
    final matrix = _transform.value;
    final scale = matrix.getMaxScaleOnAxis();
    if (scale <= 1.001) {
      final translation = matrix.getTranslation();
      if (translation.x.abs() > 0.4 ||
          translation.y.abs() > 0.4 ||
          (scale - 1).abs() > 0.001) {
        _transform.value = Matrix4.identity();
      }
      if (_zoomed) setState(() => _zoomed = false);
      return;
    }
    if (!_zoomed) setState(() => _zoomed = true);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameControllerProvider);
    final controller = ref.read(gameControllerProvider.notifier);
    final wide =
        MediaQuery.sizeOf(context).width >= CyberLayout.wideBreakpoint;

    ref.listen<GameState>(gameControllerProvider, (prev, next) {
      if (next.phase == TurnPhase.movingToken &&
          next.moveStepsLeft > 0 &&
          !_stepping) {
        _runMoveSteps(controller);
      }
      final pending = next.pendingAction;
      if (pending is PendingRentNotice && prev?.pendingAction != pending) {
        setState(() {
          _rentPayer = pending.payerName;
          _rentOwner = pending.ownerName;
        });
        Future<void>.delayed(const Duration(milliseconds: 420), () {
          if (!mounted) return;
          setState(() {
            _rentPayer = null;
            _rentOwner = null;
          });
        });
      }
    });

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Center(
        child: AspectRatio(
          aspectRatio: 1,
          child: InteractiveViewer(
            transformationController: _transform,
            minScale: 1,
            maxScale: 3,
            panEnabled: _zoomed,
            scaleEnabled: true,
            clipBehavior: Clip.hardEdge,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final size = Size(constraints.maxWidth, constraints.maxHeight);
                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: CyberColors.voidBlack,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: CyberColors.neonCyan, width: 2),
                    boxShadow: CyberTheme.glow(CyberColors.neonCyan, blur: 12),
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
                        _buildCenter(size, state, controller, wide),
                        ..._buildTokens(state, size),
                        const CyberDialogueBubble(),
                        const SignalLostBanner(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openCell(int index) async {
    setState(() => _selected = index);
    await showCellDeedSheet(context, initialIndex: index);
    if (mounted) setState(() => _selected = null);
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
          child: RepaintBoundary(
            child: BoardCellWidget(
              cell: cell,
              ownerColor: _ownerColor(state, cell.ownerIdOrNull),
              selected: _selected == cell.index,
              onTap: () => _openCell(cell.index),
            ),
          ),
        ),
    ];
  }

  Widget _buildCenter(
    Size size,
    GameState state,
    GameController controller,
    bool wide,
  ) {
    final cell = size.width / BoardGeometry.gridSize;
    return Positioned(
      left: cell,
      top: cell,
      width: cell * 9,
      height: cell * 9,
      child: BoardCenterPanel(
        state: state,
        showActions: wide,
        inputEnabled: controller.isLocalInputAllowed,
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
        final paying = p.name == _rentPayer;
        final collecting = p.name == _rentOwner;

        widgets.add(
          AnimatedPositioned(
            key: ValueKey('token-${p.id}'),
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            left: center.dx - tokenSize / 2,
            top: center.dy - tokenSize / 2,
            width: tokenSize,
            height: tokenSize,
            child: _TokenChip(
              player: p,
              highlighted: isActive,
              rentFlash: paying || collecting,
              flashColor: paying
                  ? CyberColors.neonMagenta
                  : CyberColors.terminalGreen,
            ),
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

class _TokenChip extends StatefulWidget {
  const _TokenChip({
    required this.player,
    required this.highlighted,
    required this.rentFlash,
    required this.flashColor,
  });

  final Player player;
  final bool highlighted;
  final bool rentFlash;
  final Color flashColor;

  @override
  State<_TokenChip> createState() => _TokenChipState();
}

class _TokenChipState extends State<_TokenChip>
    with TickerProviderStateMixin {
  late final AnimationController _bounce;
  late final AnimationController _flash;

  @override
  void initState() {
    super.initState();
    _bounce = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _flash = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    if (widget.rentFlash) _flash.forward();
  }

  @override
  void didUpdateWidget(covariant _TokenChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.player.position != widget.player.position) {
      _bounce.forward(from: 0);
    }
    if (widget.rentFlash && !oldWidget.rentFlash) {
      _flash.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _bounce.dispose();
    _flash.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ink = widget.player.tokenColor.ink;
    return AnimatedBuilder(
      animation: Listenable.merge([_bounce, _flash]),
      builder: (context, _) {
        final bounce = _bounce.isAnimating
            ? 1 + (_bounce.value < 0.5
                ? _bounce.value * 2 * 0.28
                : (1 - _bounce.value) * 2 * 0.28)
            : 1.0;
        final flashT = _flash.isAnimating
            ? (_flash.value < 0.5 ? _flash.value * 2 : (1 - _flash.value) * 2)
            : 0.0;
        final fill = Color.lerp(
          widget.player.tokenColor.color,
          widget.flashColor,
          flashT * 0.85,
        )!;

        return Transform.scale(
          scale: bounce,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: fill,
              shape: BoxShape.circle,
              border: Border.all(
                color: widget.highlighted ? Colors.white : Colors.black87,
                width: widget.highlighted ? 2.5 : 1.2,
              ),
              boxShadow: widget.highlighted
                  ? CyberTheme.glow(widget.player.tokenColor.color, blur: 8)
                  : const [
                      BoxShadow(
                        color: Color(0x59000000),
                        blurRadius: 3,
                        offset: Offset(0, 1),
                      ),
                    ],
            ),
            child: FittedBox(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Text(
                  widget.player.name.isNotEmpty
                      ? widget.player.name[0].toUpperCase()
                      : '?',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: ink,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
