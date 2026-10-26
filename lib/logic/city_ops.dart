import '../core/constants/game_rules.dart';
import '../core/constants/street_colors.dart';
import '../core/l10n/app_strings.dart';
import '../models/cell.dart';
import '../models/game_state.dart';
import '../models/player.dart';
import 'rules_engine.dart';

/// Rent modifiers, chrome prices, viruses, and the one-line center readout.
abstract final class CityOps {
  static int virusHopsOf(GameState state, int index) {
    final at = state.virusCells.indexOf(index);
    if (at < 0 || at >= state.virusHops.length) return 0;
    return state.virusHops[at];
  }

  static int adjustedRent({
    required GameState state,
    required BoardCell cell,
    required int base,
  }) {
    if (base <= 0) return 0;
    if (state.decree == CityDecree.maglevFree && cell is RailroadCell) {
      return 0;
    }
    var rent = base;
    if (virusHopsOf(state, cell.index) > 0) rent ~/= 2;
    if (state.decree == CityDecree.rentSurge &&
        cell is PropertyCell &&
        cell.colorGroup.name == state.surgeGroup) {
      rent *= 2;
    }
    return rent;
  }

  /// Mantis cheapens a buy that extends a district you already hold.
  static int buyPrice(GameState state, Player buyer, BoardCell cell) {
    final list = cell.priceOrNull ?? 0;
    if (buyer.chrome != Chrome.mantis || cell is! PropertyCell) return list;
    final started = state.board.whereType<PropertyCell>().any(
          (c) => c.colorGroup == cell.colorGroup && c.ownerId == buyer.id,
        );
    if (!started) return list;
    return (list * 4) ~/ 5;
  }

  static int taxDue(GameState state, int amount) =>
      state.decree == CityDecree.taxHoliday ? 0 : amount;

  static List<PropertyCell> ownedStreets(GameState state, Player player) => [
        for (final index in player.propertyIndexes)
          if (state.cellAt(index) case final PropertyCell street)
            if (street.ownerId == player.id) street,
      ];

  /// One swatch per district the player holds at least one street in.
  static List<ColorGroup> districts(GameState state, Player player) {
    final seen = <ColorGroup>[];
    for (final street in ownedStreets(state, player)) {
      if (!seen.contains(street.colorGroup)) seen.add(street.colorGroup);
    }
    return seen;
  }

  static String? surgeGroupFor(GameState state, Player player) {
    PropertyCell? best;
    for (final street in ownedStreets(state, player)) {
      if (best == null || street.price > best.price) best = street;
    }
    return best?.colorGroup.name;
  }

  static int? virusTarget(GameState state, Player hacker) {
    if (hacker.virusRound == state.round) return null;
    if (hacker.balance < GameRules.virusCost) return null;
    BoardCell? best;
    var bestRent = 0;
    for (final cell in state.board) {
      final owner = cell.ownerIdOrNull;
      if (owner == null || owner == hacker.id) continue;
      if (virusHopsOf(state, cell.index) > 0) continue;
      final rent = RulesEngine.calculateRent(
        cell: cell,
        board: state.board,
        diceTotal: 7,
      );
      if (rent > bestRent) {
        bestRent = rent;
        best = cell;
      }
    }
    if (bestRent < 40) return null;
    return best?.index;
  }

  static String consequence({
    required GameState state,
    required BoardCell cell,
    required Player viewer,
    required AppStrings s,
  }) {
    if (cell is TaxCell) {
      final due = taxDue(state, cell.amount);
      return due == 0
          ? s.taxSleeping
          : s.taxDue(GameRules.credits(due));
    }
    if (cell is SpecialCell) {
      return s.blurbFor(switch (cell.kind) {
        SpecialKind.go => 'go',
        SpecialKind.jail => 'jail',
        SpecialKind.freeParking => 'parking',
        SpecialKind.goToJail => 'goto',
        SpecialKind.chance => 'chance',
        SpecialKind.communityChest => 'chest',
      });
    }

    final ownerId = cell.ownerIdOrNull;
    final price = cell.priceOrNull;
    if (ownerId == null) {
      final ask = buyPrice(state, viewer, cell);
      return price == null ? '' : s.forSale(GameRules.credits(ask));
    }
    if (cell.isMortgagedOrFalse) return s.icedOver;
    var ownerName = '';
    for (final p in state.players) {
      if (p.id == ownerId) ownerName = p.name;
    }
    if (ownerId == viewer.id) {
      final racks = cell is PropertyCell ? cell.houses : 0;
      return racks > 0 ? s.yourNodeLevel(racks) : s.yourNode;
    }
    final rent = adjustedRent(
      state: state,
      cell: cell,
      base: RulesEngine.calculateRent(
        cell: cell,
        board: state.board,
        diceTotal: state.lastRoll?.total ?? 7,
        suppressed: NightfallSuppressed.yes(state, cell.index),
      ),
    );
    if (virusHopsOf(state, cell.index) > 0) {
      return s.virusRent(GameRules.credits(rent), ownerName);
    }
    return s.rentTo(GameRules.credits(rent), ownerName);
  }
}

/// Avoids importing Nightfall from a file that would cycle through the controller.
abstract final class NightfallSuppressed {
  static bool yes(GameState state, int index) =>
      state.suppressedCells.contains(index);
}
