import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/game_rules.dart';
import '../../core/l10n/app_lang.dart';
import '../../core/l10n/app_strings.dart';
import '../../core/theme/cyber_theme.dart';
import '../../logic/game_controller.dart';
import '../../logic/nightfall.dart';
import '../../models/cell.dart';
import '../../models/game_state.dart';
import '../../models/pending_action.dart';
import '../../models/player.dart';
import 'board_cell_widget.dart';
import 'cell_art.dart';

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
    ref.watch(appLangProvider);
    final state = ref.watch(gameControllerProvider);
    final s = stringsOf(context);

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
                          s.swipeNodes,
                          style: GoogleFonts.shareTechMono(
                            color: CyberColors.textMuted,
                            fontSize: 11,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: s.close,
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
    final s = stringsOf(context);
    final accent = BoardCellWidget.accentOf(cell);
    final owner = _owner(cell, players);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            height: 168,
            width: double.infinity,
            child: CellArtwork(cell: cell),
          ),
        ),
        Container(height: 4, color: accent),
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
            s.districtName((cell as PropertyCell).colorGroup),
            style: GoogleFonts.rajdhani(
              color: accent,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          _DistrictRoster(
            cell: cell as PropertyCell,
            board: board,
            players: players,
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
          owner == null ? s.unclaimed : s.ownerLine(owner.name),
          style: GoogleFonts.shareTechMono(
            color: owner == null ? CyberColors.textMuted : owner.tokenColor.color,
            fontSize: 13,
          ),
        ),
        if (cell.isMortgagedOrFalse)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              s.mortgagedIce,
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
            s.buildingTier((cell as PropertyCell).houses),
            style: GoogleFonts.shareTechMono(
              color: CyberColors.terminalGreen,
              fontSize: 12,
            ),
          ),
        ],
        if (_mortgageOf(cell) != null) ...[
          const SizedBox(height: 4),
          Text(
            s.mortgageValue(GameRules.credits(_mortgageOf(cell)!)),
            style: GoogleFonts.shareTechMono(
              color: CyberColors.textMuted,
              fontSize: 12,
            ),
          ),
        ],
        const SizedBox(height: 14),
        ..._rentRows(cell, board, owner, s),
        const SizedBox(height: 8),
        _DeedActions(cell: cell),
        const SizedBox(height: 8),
        Text(
          _blurb(cell, s),
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

  static String _blurb(BoardCell cell, AppStrings s) => switch (cell) {
        SpecialCell(:final kind) => switch (kind) {
            SpecialKind.go => s.blurbFor('go'),
            SpecialKind.jail => s.blurbFor('jail'),
            SpecialKind.freeParking => s.blurbFor('parking'),
            SpecialKind.goToJail => s.blurbFor('goto'),
            SpecialKind.chance => s.blurbFor('chance'),
            SpecialKind.communityChest => s.blurbFor('chest'),
          },
        TaxCell(:final amount) => s.taxFlat(GameRules.credits(amount)),
        RailroadCell() => s.blurbFor('rail'),
        UtilityCell() => s.blurbFor('util'),
        PropertyCell() => s.blurbFor('street'),
      };

  List<Widget> _rentRows(
    BoardCell cell,
    List<BoardCell> board,
    Player? owner,
    AppStrings s,
  ) {
    return switch (cell) {
      PropertyCell(:final rents, :final houses) => [
          for (var i = 0; i < rents.length; i++)
            _rentLine(
              switch (i) {
                0 => s.base,
                5 => s.hq,
                _ => s.rackTimes(i),
              },
              GameRules.credits(rents[i]),
              active: !cell.isMortgaged && houses == i,
            ),
        ],
      RailroadCell() => [
          for (var i = 0; i < GameRules.railroadRents.length; i++)
            _rentLine(
              s.lines(i + 1),
              GameRules.credits(GameRules.railroadRents[i]),
              active: owner != null &&
                  _ownedCount<RailroadCell>(board, owner.id) == i + 1,
            ),
        ],
      UtilityCell() => [
          _rentLine(
            s.oneGrid,
            s.diceTimes(GameRules.utilityMultiplierOne),
            active: owner != null &&
                _ownedCount<UtilityCell>(board, owner.id) <= 1,
          ),
          _rentLine(
            s.twoGrids,
            s.diceTimes(GameRules.utilityMultiplierTwo),
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
    final s = AppStrings(ref.watch(appLangProvider));
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
    final notes = <String>[];

    if (node is PropertyCell &&
        node.ownerId == me.id &&
        !node.isMortgaged &&
        node.houses < 5) {
      final block = Nightfall.rackBuildBlock(
        state: state,
        cell: node,
        player: me,
        strings: s,
      );
      final cost = Nightfall.nodeCost(node.colorGroup, node.houses);
      final hotel = node.houses >= 4;
      if (block == null) {
        buttons.add(
          _act(
            context,
            () => controller.buildHouse(node.index),
            s.buildLabel(
              GameRules.credits(cost),
              hotel,
              hotel ? state.hotelsInBank : state.housesInBank,
            ),
          ),
        );
      } else {
        notes.add(block);
      }
    }
    if (node is PropertyCell && node.ownerId == me.id && node.houses > 0) {
      final block = Nightfall.rackSellBlock(
        state: state,
        cell: node,
        player: me,
        strings: s,
      );
      final refund = Nightfall.nodeRefund(node.colorGroup, node.houses);
      if (block == null) {
        buttons.add(
          _act(
            context,
            () => controller.sellNode(node.index) > 0,
            s.sellLabel(GameRules.credits(refund)),
          ),
        );
      } else {
        notes.add(block);
      }
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
            s.mortgageLabel(GameRules.credits(value)),
          ),
        );
      }
    }
    if (node.ownerIdOrNull == me.id && node.isMortgagedOrFalse) {
      final cost = Nightfall.unmortgageCost(Nightfall.mortgageValue(node));
      if (me.balance >= cost) {
        buttons.add(
          _act(
            context,
            () => controller.unmortgageProperty(node.index),
            s.liftLabel(GameRules.credits(cost)),
          ),
        );
      } else {
        notes.add(
          s.liftShort(
            GameRules.credits(cost),
            GameRules.credits(cost - me.balance),
          ),
        );
      }
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
      if (me.balance >= cost) {
        buttons.add(
          _act(
            context,
            () {
              controller.blackout(node.index);
              return true;
            },
            s.blackoutLabel(GameRules.credits(cost)),
          ),
        );
      } else {
        notes.add(
          s.blackoutShort(
            GameRules.credits(cost),
            GameRules.credits(cost - me.balance),
          ),
        );
      }
    }
    if (!me.buyoutUsed &&
        Nightfall.claimTargets(state, me).contains(node.index)) {
      final price = Nightfall.buyoutPrice(node.priceOrNull ?? 0);
      if (me.balance >= price) {
        buttons.add(
          _act(
            context,
            () => controller.buyout(node.index),
            s.claimLabel(GameRules.credits(price)),
          ),
        );
      } else {
        notes.add(
          s.claimShort(
            GameRules.credits(price),
            GameRules.credits(price - me.balance),
          ),
        );
      }
    }

    if (buttons.isEmpty && notes.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final note in notes) ...[
          Text(
            note,
            style: GoogleFonts.shareTechMono(
              color: CyberColors.cyberYellow,
              fontSize: 12,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 8),
        ],
        for (final button in buttons) ...[
          button,
          const SizedBox(height: 6),
        ],
      ],
    );
  }

  Widget _act(BuildContext context, bool Function() onPressed, String label) {
    return FilledButton(
      onPressed: () {
        if (onPressed() && context.mounted) Navigator.pop(context);
      },
      child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
}

class _DistrictRoster extends StatelessWidget {
  const _DistrictRoster({
    required this.cell,
    required this.board,
    required this.players,
  });

  final PropertyCell cell;
  final List<BoardCell> board;
  final List<Player> players;

  @override
  Widget build(BuildContext context) {
    final s = stringsOf(context);
    final streets = board
        .whereType<PropertyCell>()
        .where((c) => c.colorGroup == cell.colorGroup)
        .toList()
      ..sort((a, b) => a.index.compareTo(b.index));
    final owned = cell.ownerId == null
        ? 0
        : streets.where((c) => c.ownerId == cell.ownerId).length;
    final sameOwner = cell.ownerId != null &&
        streets.every((c) => c.ownerId == cell.ownerId && !c.isMortgaged);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          s.districtProgress(owned, streets.length, sameOwner),
          style: GoogleFonts.shareTechMono(
            color: sameOwner ? CyberColors.terminalGreen : CyberColors.cyberYellow,
            fontSize: 11,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 4),
        for (final street in streets)
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text(
              '${street.index == cell.index ? '>' : '-'} ${street.name} — ${_status(street, s)}',
              style: GoogleFonts.shareTechMono(
                color: street.index == cell.index
                    ? CyberColors.neonCyan
                    : CyberColors.textMuted,
                fontSize: 11,
                height: 1.3,
              ),
            ),
          ),
      ],
    );
  }

  String _status(PropertyCell street, AppStrings s) {
    if (street.ownerId == null) return s.unclaimed;
    final owner = players.where((p) => p.id == street.ownerId).firstOrNull;
    final who = owner?.name ?? s.unknown;
    final ice = street.isMortgaged ? ' · ${s.pick('ICE', 'ЗАСТАВА')}' : '';
    final racks = switch (street.houses) {
      0 => '',
      >= 5 => ' · ${s.hq}',
      _ => ' · ${s.rackTimes(street.houses)}',
    };
    return '$who$ice$racks';
  }
}
