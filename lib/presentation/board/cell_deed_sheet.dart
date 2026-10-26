import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/game_rules.dart';
import '../../core/constants/street_colors.dart';
import '../../core/theme/cyber_theme.dart';
import '../../logic/game_controller.dart';
import '../../logic/nightfall.dart';
import '../../models/cell.dart';
import '../../models/game_state.dart';
import '../../models/pending_action.dart';
import '../../models/player.dart';
import 'board_cell_widget.dart';

Future<void> showCellDeedSheet(
  BuildContext context, {
  required int initialIndex,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _DeedSheet(initialIndex: initialIndex),
  );
}

class _DeedSheet extends ConsumerStatefulWidget {
  const _DeedSheet({required this.initialIndex});

  final int initialIndex;

  @override
  ConsumerState<_DeedSheet> createState() => _DeedSheetState();
}

class _DeedSheetState extends ConsumerState<_DeedSheet> {
  late final PageController _page = PageController(
    initialPage: widget.initialIndex.clamp(0, GameRules.boardSize - 1),
  );

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final sheetH = math.min(480.0, math.max(300.0, height * 0.52));
    final state = ref.watch(gameControllerProvider);

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          height: sheetH,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: CyberColors.panel,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              border: Border(
                top: BorderSide(color: CyberColors.neonCyan, width: 1.2),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 8),
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: CyberColors.gridLine,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'SWIPE · NEIGHBOR NODES',
                          style: GoogleFonts.shareTechMono(
                            color: CyberColors.textMuted,
                            fontSize: 11,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'CLOSE',
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, color: CyberColors.neonCyan),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _page,
                    itemCount: state.board.length,
                    itemBuilder: (context, index) {
                      return _DeedPage(
                        cell: state.board[index],
                        board: state.board,
                        players: state.players,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DeedPage extends StatelessWidget {
  const _DeedPage({
    required this.cell,
    required this.board,
    required this.players,
  });

  final BoardCell cell;
  final List<BoardCell> board;
  final List<Player> players;

  @override
  Widget build(BuildContext context) {
    final accent = BoardCellWidget.accentOf(cell);
    final owner = _owner(cell, players);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
      children: [
        Container(height: 10, color: accent),
        const SizedBox(height: 12),
        Text(
          cell.name,
          style: GoogleFonts.orbitron(
            color: CyberColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            height: 1.25,
          ),
        ),
        if (cell is PropertyCell) ...[
          const SizedBox(height: 4),
          Text(
            (cell as PropertyCell).colorGroup.districtName,
            style: GoogleFonts.rajdhani(
              color: accent,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
        if (cell.priceOrNull != null) ...[
          const SizedBox(height: 8),
          Text(
            GameRules.credits(cell.priceOrNull!),
            style: GoogleFonts.orbitron(
              color: CyberColors.cyberYellow,
              fontSize: 28,
              fontWeight: FontWeight.w700,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
        const SizedBox(height: 10),
        Text(
          owner == null ? 'UNCLAIMED' : 'OWNER · ${owner.name}',
          style: GoogleFonts.shareTechMono(
            color: owner == null ? CyberColors.textMuted : owner.tokenColor.color,
            fontSize: 13,
          ),
        ),
        if (cell.isMortgagedOrFalse)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              'MORTGAGED · ICE',
              style: GoogleFonts.shareTechMono(
                color: CyberColors.neonMagenta,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        if (cell is PropertyCell) ...[
          const SizedBox(height: 6),
          Text(
            CyberLore.buildingTier((cell as PropertyCell).houses),
            style: GoogleFonts.shareTechMono(
              color: CyberColors.terminalGreen,
              fontSize: 12,
            ),
          ),
        ],
        if (_mortgageOf(cell) != null) ...[
          const SizedBox(height: 4),
          Text(
            'MORTGAGE VALUE ${GameRules.credits(_mortgageOf(cell)!)}',
            style: GoogleFonts.shareTechMono(
              color: CyberColors.textMuted,
              fontSize: 12,
            ),
          ),
        ],
        const SizedBox(height: 14),
        ..._rentRows(cell, board, owner),
        const SizedBox(height: 8),
        _DeedActions(cell: cell),
        const SizedBox(height: 8),
        Text(
          _blurb(cell),
          style: GoogleFonts.rajdhani(
            color: CyberColors.textPrimary,
            fontSize: 16,
            height: 1.3,
          ),
        ),
      ],
    );
  }

  static Player? _owner(BoardCell cell, List<Player> players) {
    final id = cell.ownerIdOrNull;
    if (id == null) return null;
    for (final p in players) {
      if (p.id == id) return p;
    }
    return null;
  }

  static int? _mortgageOf(BoardCell cell) => switch (cell) {
        PropertyCell(:final mortgage) => mortgage,
        RailroadCell(:final mortgage) => mortgage,
        UtilityCell(:final mortgage) => mortgage,
        _ => null,
      };

  static String _blurb(BoardCell cell) => switch (cell) {
        SpecialCell(:final kind) => switch (kind) {
            SpecialKind.go => 'Pass this node to collect ₵200.',
            SpecialKind.jail => 'Visiting, or locked in ICE until bail or doubles.',
            SpecialKind.freeParking => 'Safe zone. The bank pays nothing here.',
            SpecialKind.goToJail => 'Transit ends. Report to ICE Lock.',
            SpecialKind.chance => 'Draw a Data Breach card.',
            SpecialKind.communityChest => 'Draw a Corpo Bounty card.',
          },
        TaxCell(:final amount) =>
          'Flat transfer of ${GameRules.credits(amount)} to the bank.',
        RailroadCell() => 'Fare scales with how many Maglev lines you hold.',
        UtilityCell() => 'Bill is a multiplier on the dice that landed here.',
        PropertyCell() => 'Rent climbs with Data Racks. A full district doubles the base.',
      };

  List<Widget> _rentRows(BoardCell cell, List<BoardCell> board, Player? owner) {
    return switch (cell) {
      PropertyCell(:final rents, :final houses) => [
          for (var i = 0; i < rents.length; i++)
            _rentLine(
              switch (i) {
                0 => 'BASE',
                5 => 'HQ',
                _ => 'RACK ×$i',
              },
              GameRules.credits(rents[i]),
              active: !cell.isMortgaged && houses == i,
            ),
        ],
      RailroadCell() => [
          for (var i = 0; i < GameRules.railroadRents.length; i++)
            _rentLine(
              '${i + 1} LINE${i == 0 ? '' : 'S'}',
              GameRules.credits(GameRules.railroadRents[i]),
              active: owner != null &&
                  _ownedCount<RailroadCell>(board, owner.id) == i + 1,
            ),
        ],
      UtilityCell() => [
          _rentLine(
            '1 GRID',
            '×${GameRules.utilityMultiplierOne} DICE',
            active: owner != null &&
                _ownedCount<UtilityCell>(board, owner.id) <= 1,
          ),
          _rentLine(
            '2 GRIDS',
            '×${GameRules.utilityMultiplierTwo} DICE',
            active: owner != null &&
                _ownedCount<UtilityCell>(board, owner.id) >= 2,
          ),
        ],
      _ => const [],
    };
  }

  static int _ownedCount<T>(List<BoardCell> board, String ownerId) {
    var n = 0;
    for (final cell in board) {
      if (cell is T && cell.ownerIdOrNull == ownerId) n++;
    }
    return n;
  }

  Widget _rentLine(String label, String value, {required bool active}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.shareTechMono(
                color: active ? CyberColors.cyberYellow : CyberColors.textMuted,
                fontSize: 13,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.shareTechMono(
              color: active ? CyberColors.cyberYellow : CyberColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

class _DeedActions extends ConsumerWidget {
  const _DeedActions({required this.cell});

  final BoardCell cell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameControllerProvider);
    final controller = ref.read(gameControllerProvider.notifier);
    if (!controller.isLocalInputAllowed) return const SizedBox.shrink();
    if (state.isGameOver) return const SizedBox.shrink();
    if (state.pendingAction is! PendingNone) return const SizedBox.shrink();
    if (state.phase != TurnPhase.waitingForRoll &&
        state.phase != TurnPhase.canEndTurn) {
      return const SizedBox.shrink();
    }
    final me = state.activePlayer;
    if (me.isAi) return const SizedBox.shrink();
    final node = cell;

    final buttons = <Widget>[];

    if (node is PropertyCell &&
        node.ownerId == me.id &&
        !node.isMortgaged &&
        node.houses < 5) {
      final cost = Nightfall.nodeCost(node.colorGroup, node.houses);
      final hotel = node.houses >= 4;
      final supplyOk = hotel ? state.hotelsInBank > 0 : state.housesInBank > 0;
      buttons.add(
        _act(
          context,
          supplyOk && me.balance >= cost
              ? () => controller.buildHouse(node.index)
              : null,
          'BUILD ${GameRules.credits(cost)}'
          '${hotel ? ' · HQ ${state.hotelsInBank}' : ' · RACK ${state.housesInBank}'}',
        ),
      );
    }
    if (node is PropertyCell && node.ownerId == me.id && node.houses > 0) {
      final refund = Nightfall.nodeRefund(node.colorGroup, node.houses);
      final blocked = node.houses >= 5 && state.housesInBank < 4;
      buttons.add(
        _act(
          context,
          blocked ? null : () => controller.sellNode(node.index),
          'SELL NODE +${GameRules.credits(refund)}',
        ),
      );
    }
    final bareOwnable = node.ownerIdOrNull == me.id &&
        !node.isMortgagedOrFalse &&
        (node is! PropertyCell || node.houses == 0);
    if (bareOwnable) {
      final value = Nightfall.mortgageValue(node);
      if (value > 0) {
        buttons.add(
          _act(
            context,
            () => controller.pledgeProperty(node.index),
            'MORTGAGE +${GameRules.credits(value)}',
          ),
        );
      }
    }
    if (node.ownerIdOrNull == me.id && node.isMortgagedOrFalse) {
      final cost = Nightfall.unmortgageCost(Nightfall.mortgageValue(node));
      buttons.add(
        _act(
          context,
          me.balance >= cost
              ? () => controller.unmortgageProperty(node.index)
              : null,
          'LIFT ICE −${GameRules.credits(cost)}',
        ),
      );
    }
    if (node is PropertyCell &&
        node.ownerId != null &&
        node.ownerId != me.id &&
        node.houses > 0 &&
        !node.isMortgaged &&
        !me.blackoutUsedThisTurn &&
        !state.blackoutGroupsThisRound.contains(node.colorGroup.name) &&
        !Nightfall.cellSuppressed(state, node.index)) {
      final cost = Nightfall.blackoutCost(node.colorGroup);
      buttons.add(
        _act(
          context,
          me.balance >= cost ? () => controller.blackout(node.index) : null,
          'BLACKOUT −${GameRules.credits(cost)}',
        ),
      );
    }
    if (!me.buyoutUsed &&
        Nightfall.claimTargets(state, me).contains(node.index)) {
      final price = Nightfall.buyoutPrice(node.priceOrNull ?? 0);
      buttons.add(
        _act(
          context,
          me.balance >= price ? () => controller.buyout(node.index) : null,
          'CLAIM 120% · ${GameRules.credits(price)}',
        ),
      );
    }

    if (buttons.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final button in buttons) ...[
          button,
          const SizedBox(height: 6),
        ],
      ],
    );
  }

  Widget _act(BuildContext context, VoidCallback? onPressed, String label) {
    return FilledButton(
      onPressed: onPressed == null
          ? null
          : () {
              onPressed();
              Navigator.pop(context);
            },
      child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
}
