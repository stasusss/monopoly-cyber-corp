import '../core/constants/game_rules.dart';
import '../core/constants/street_colors.dart';
import '../models/cell.dart';
import '../models/player.dart';

/// Pure rules helpers: rent, monopolies, bankruptcy checks.
abstract final class RulesEngine {
  static bool ownsFullColorGroup({
    required List<BoardCell> board,
    required String ownerId,
    required ColorGroup group,
  }) {
    final streets = board
        .whereType<PropertyCell>()
        .where((c) => c.colorGroup == group)
        .toList();
    if (streets.length != group.propertyCount) return false;
    return streets.every((c) => c.ownerId == ownerId && !c.isMortgaged);
  }

  static int countRailroadsOwned(List<BoardCell> board, String ownerId) => board
      .whereType<RailroadCell>()
      .where((c) => c.ownerId == ownerId && !c.isMortgaged)
      .length;

  static int countUtilitiesOwned(List<BoardCell> board, String ownerId) => board
      .whereType<UtilityCell>()
      .where((c) => c.ownerId == ownerId && !c.isMortgaged)
      .length;

  /// Rent owed when [payer] lands on [cell]. Returns 0 if none.
  static int calculateRent({
    required BoardCell cell,
    required List<BoardCell> board,
    required int diceTotal,
    bool suppressed = false,
    int rentMultiplier = 1,
    bool utilityFlatTen = false,
  }) {
    if (cell.isMortgagedOrFalse) return 0;
    final ownerId = cell.ownerIdOrNull;
    if (ownerId == null) return 0;

    return switch (cell) {
      PropertyCell(
        :final rents,
        :final houses,
        :final colorGroup,
        :final isMortgaged,
      ) =>
        isMortgaged
            ? 0
            : _propertyRent(
                rents: rents,
                houses: suppressed ? (houses - 1).clamp(0, 5) : houses,
                hasMonopoly: ownsFullColorGroup(
                  board: board,
                  ownerId: ownerId,
                  group: colorGroup,
                ),
              ),
      RailroadCell(:final isMortgaged) => isMortgaged
          ? 0
          : GameRules.railroadRents[
                (countRailroadsOwned(board, ownerId) - 1).clamp(0, 3)] *
              rentMultiplier,
      UtilityCell(:final isMortgaged) => isMortgaged
          ? 0
          : diceTotal *
              (utilityFlatTen
                  ? GameRules.utilityMultiplierTwo
                  : countUtilitiesOwned(board, ownerId) >= 2
                      ? GameRules.utilityMultiplierTwo
                      : GameRules.utilityMultiplierOne),
      _ => 0,
    };
  }

  static int _propertyRent({
    required List<int> rents,
    required int houses,
    required bool hasMonopoly,
  }) {
    if (houses > 0) {
      final tier = houses.clamp(1, 5);
      return rents[tier];
    }
    final base = rents[0];
    return hasMonopoly ? base * GameRules.monopolyRentMultiplier : base;
  }

  static bool canAfford(Player player, int amount) =>
      !player.isBankrupt && player.balance >= amount;

  /// True when the player cannot cover [amount] from cash on hand.
  static bool isBankruptAfter(Player player, int amount) =>
      player.balance < amount;
}
