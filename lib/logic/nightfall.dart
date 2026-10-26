import '../core/constants/game_rules.dart';
import '../core/constants/street_colors.dart';
import '../models/cell.dart';
import '../models/game_state.dart';
import '../models/player.dart';

/// Blitz session math: node prices, claims, overdraft, net worth.
abstract final class Nightfall {
  /// Levels 1–2 cost half; the third node and above stay at full price.
  static int nodeCost(ColorGroup group, int currentHouses) {
    final full = group.houseCost;
    if (currentHouses < 2) return full ~/ 2;
    return full;
  }

  /// Refund for selling the current top level (half of what that level cost).
  static int nodeRefund(ColorGroup group, int currentHouses) {
    if (currentHouses <= 0) return 0;
    return nodeCost(group, currentHouses - 1) ~/ 2;
  }

  static int unmortgageCost(int mortgage) => mortgage + (mortgage + 9) ~/ 10;

  static int buyoutPrice(int listPrice) =>
      (listPrice * GameRules.buyoutPercent) ~/ 100;

  static int blackoutCost(ColorGroup group) => group.houseCost ~/ 2;

  static int minAuctionBid(int highestBid) => highestBid <= 0
      ? GameRules.auctionBidStep
      : highestBid + GameRules.auctionBidStep;

  static int investedNodes(ColorGroup group, int houses) {
    var total = 0;
    for (var level = 0; level < houses; level++) {
      total += nodeCost(group, level);
    }
    return total;
  }

  static int mortgageValue(BoardCell cell) => switch (cell) {
        PropertyCell(:final mortgage) => mortgage,
        RailroadCell(:final mortgage) => mortgage,
        UtilityCell(:final mortgage) => mortgage,
        _ => 0,
      };

  /// Unmortgaged collateral the syndicate will lend against.
  static int mortgageMass(GameState state, Player player) {
    var mass = 0;
    for (final index in player.propertyIndexes) {
      final cell = state.cellAt(index);
      if (cell.isMortgagedOrFalse) continue;
      if (cell is PropertyCell && cell.houses > 0) continue;
      mass += mortgageValue(cell);
    }
    return mass;
  }

  static int overdraftPrincipal(GameState state, Player player) {
    final mass = mortgageMass(state, player);
    if (mass <= 0) return 0;
    return mass < GameRules.overdraftMax ? mass : GameRules.overdraftMax;
  }

  /// Cash + half of unmortgaged list price + half of money sunk into nodes,
  /// minus syndicate debt still outstanding.
  static int netWorth(GameState state, Player player) {
    if (player.isBankrupt) return 0;
    var worth = player.balance - player.overdraftRemaining;
    for (final index in player.propertyIndexes) {
      final cell = state.cellAt(index);
      if (cell.isMortgagedOrFalse) continue;
      final price = cell.priceOrNull ?? 0;
      worth += price ~/ 2;
      if (cell is PropertyCell && cell.houses > 0) {
        worth += investedNodes(cell.colorGroup, cell.houses) ~/ 2;
      }
    }
    return worth;
  }

  static bool cellSuppressed(GameState state, int index) =>
      state.suppressedCells.contains(index);

  /// Third street of a 3-colour district this player can force-buy.
  static List<int> claimTargets(GameState state, Player player) {
    final targets = <int>[];
    for (final group in ColorGroup.values) {
      if (group.propertyCount != 3) continue;
      final streets = state.board
          .whereType<PropertyCell>()
          .where((c) => c.colorGroup == group)
          .toList();
      if (streets.length != 3) continue;
      final owned = streets.where((c) => c.ownerId == player.id).length;
      if (owned != 2) continue;
      for (final street in streets) {
        if (street.ownerId == null || street.ownerId == player.id) continue;
        if (street.houses > 0 || street.isMortgaged) continue;
        final owner = _living(state, street.ownerId!);
        if (owner == null) continue;
        targets.add(street.index);
      }
    }
    return targets;
  }

  static Player? _living(GameState state, String id) {
    for (final p in state.livingPlayers) {
      if (p.id == id) return p;
    }
    return null;
  }

  static bool opponentStillLiquid(GameState state, Player ai) {
    for (final p in state.livingPlayers) {
      if (p.id == ai.id) continue;
      if (p.balance > GameRules.liquidCashThreshold) return true;
    }
    return false;
  }
}
