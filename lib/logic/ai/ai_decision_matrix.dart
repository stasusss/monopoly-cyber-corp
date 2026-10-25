import '../../core/constants/game_rules.dart';
import '../../core/constants/street_colors.dart';
import '../../models/cell.dart';
import '../../models/game_state.dart';
import '../../models/player.dart';
import '../rules_engine.dart';

/// One step in the bankruptcy / fund-raising liquidation queue.
sealed class LiquidationStep {
  const LiquidationStep();
}

class MortgageStep extends LiquidationStep {
  const MortgageStep(this.cellIndex);
  final int cellIndex;
}

class SellHouseStep extends LiquidationStep {
  const SellHouseStep(this.cellIndex);
  final int cellIndex;
}

/// Pure decision math for heuristic bots (no side effects).
abstract final class AiDecisionMatrix {
  /// Estimated average rent the AI might pay landing on opponent property.
  static int averageThreatRent(GameState state, Player ai) {
    final threats = <int>[];
    for (final cell in state.board) {
      final ownerId = cell.ownerIdOrNull;
      if (ownerId == null || ownerId == ai.id || cell.isMortgagedOrFalse) {
        continue;
      }
      final rent = RulesEngine.calculateRent(
        cell: cell,
        board: state.board,
        diceTotal: 7,
      );
      if (rent > 0) threats.add(rent);
    }
    if (threats.isEmpty) {
      // Fallback: mean base street rent on the classic board.
      final bases = state.board
          .whereType<PropertyCell>()
          .map((c) => c.rents.first)
          .toList();
      if (bases.isEmpty) return 50;
      return bases.reduce((a, b) => a + b) ~/ bases.length;
    }
    return threats.reduce((a, b) => a + b) ~/ threats.length;
  }

  static int cashBuffer(GameState state, Player ai) {
    final profile = ai.aiProfile ?? AiProfile.strategist;
    final threat = averageThreatRent(state, ai);
    return (threat * profile.safetyCoefficient).round().clamp(50, 800);
  }

  static bool isLateGame(GameState state) {
    var houses = 0;
    var monopolies = 0;
    for (final cell in state.board.whereType<PropertyCell>()) {
      houses += cell.houses;
    }
    for (final p in state.livingPlayers) {
      for (final g in ColorGroup.values) {
        if (RulesEngine.ownsFullColorGroup(
          board: state.board,
          ownerId: p.id,
          group: g,
        )) {
          monopolies++;
        }
      }
    }
    return houses >= 8 || monopolies >= 2;
  }

  /// True if buying [cell] completes a colour set for [ai].
  static bool closesMonopoly({
    required GameState state,
    required Player ai,
    required BoardCell cell,
  }) {
    if (cell is! PropertyCell || cell.ownerId != null) return false;
    final group = cell.colorGroup;
    final streets = state.board
        .whereType<PropertyCell>()
        .where((c) => c.colorGroup == group)
        .toList();
    var controlled = 0;
    for (final s in streets) {
      if (s.ownerId == ai.id || s.index == cell.index) {
        controlled++;
      } else if (s.ownerId != null) {
        return false;
      }
    }
    return controlled == group.propertyCount;
  }

  static bool shouldBuyProperty({
    required GameState state,
    required Player ai,
    required BoardCell cell,
    required int price,
  }) {
    if (!ai.isAi || ai.isBankrupt) return false;
    if (ai.balance < price) return false;

    final profile = ai.aiProfile ?? AiProfile.strategist;
    final completes = closesMonopoly(state: state, ai: ai, cell: cell);
    if (completes) {
      // Always close a set if a minimal emergency reserve remains.
      return ai.balance - price >= 50;
    }

    final buffer = cashBuffer(state, ai);
    final remaining = ai.balance - price;
    if (remaining < buffer) return false;

    final maxSpend = (ai.balance * profile.maxBuyFraction).round();
    if (price > maxSpend) return false;

    // Railroads / utilities: Strategist likes rails, Banker is picky.
    if (cell is RailroadCell) {
      final owned = RulesEngine.countRailroadsOwned(state.board, ai.id);
      return switch (profile) {
        AiProfile.aggressive => true,
        AiProfile.strategist => owned >= 1 || remaining > buffer * 1.2,
        AiProfile.banker => owned >= 2 && remaining > buffer * 1.5,
      };
    }
    if (cell is UtilityCell) {
      return switch (profile) {
        AiProfile.aggressive => remaining > buffer,
        AiProfile.strategist =>
          RulesEngine.countUtilitiesOwned(state.board, ai.id) >= 1,
        AiProfile.banker => false,
      };
    }

    // Streets: prefer completing pairs / high-traffic colours.
    if (cell is PropertyCell) {
      final ownedInGroup = state.board
          .whereType<PropertyCell>()
          .where((c) => c.colorGroup == cell.colorGroup && c.ownerId == ai.id)
          .length;
      if (ownedInGroup >= 1) return true;
      if (_isHighTraffic(cell.colorGroup)) {
        return remaining >= buffer;
      }
      return profile == AiProfile.aggressive || remaining > buffer * 1.3;
    }

    return remaining >= buffer;
  }

  /// Pay fine to leave jail? (vs rolling for doubles / sitting).
  static bool shouldPayJailFine({
    required GameState state,
    required Player ai,
  }) {
    if (!ai.inJail) return false;
    if (!RulesEngine.canAfford(ai, GameRules.jailFine)) return false;

    final profile = ai.aiProfile ?? AiProfile.strategist;
    final late = isLateGame(state);

    // Late game: sit out turns (jail is a shelter from rents).
    if (late) {
      // Only pay on last forced turn.
      return ai.jailTurns >= GameRules.maxJailTurns - 1;
    }

    // Early / mid: exit for cash according to profile bias.
    if (ai.jailTurns == 0) {
      return profile.earlyJailExitBias >= 0.8 &&
          ai.balance - GameRules.jailFine >= cashBuffer(state, ai);
    }
    return profile.earlyJailExitBias >= 0.5;
  }

  /// Property indexes to build on, highest priority first (even-build aware).
  static List<int> preferredBuildTargets({
    required GameState state,
    required Player ai,
  }) {
    final profile = ai.aiProfile ?? AiProfile.strategist;
    final targets = <({int index, double score})>[];

    for (final group in ColorGroup.values) {
      if (!RulesEngine.ownsFullColorGroup(
        board: state.board,
        ownerId: ai.id,
        group: group,
      )) {
        continue;
      }

      final streets = state.board
          .whereType<PropertyCell>()
          .where((c) => c.colorGroup == group && c.ownerId == ai.id)
          .toList();
      if (streets.any((c) => c.isMortgaged)) continue;

      final minHouses =
          streets.map((c) => c.houses).reduce((a, b) => a < b ? a : b);
      if (minHouses >= 5) continue;

      for (final street in streets) {
        // Even building: only build on tiles at the current minimum.
        if (street.houses != minHouses) continue;
        if (street.houses >= 5) continue;

        final cost = group.houseCost;
        if (ai.balance - cost < cashBuffer(state, ai) * 0.6 &&
            profile == AiProfile.banker) {
          continue;
        }

        var score = _trafficScore(group) * profile.trafficBias;
        // Prefer tiles 6–8 steps ahead of opponents (classic dice mode).
        score += _opponentLandingPressure(state, ai, street.index);
        // Prefer cheaper houses for Aggressive cash efficiency.
        score += (300 - cost) / 100;

        targets.add((index: street.index, score: score));
      }
    }

    targets.sort((a, b) => b.score.compareTo(a.score));
    return [for (final t in targets) t.index];
  }

  /// Ordered liquidation steps to raise at least [amountNeeded].
  static List<LiquidationStep> liquidationQueue({
    required GameState state,
    required Player ai,
    required int amountNeeded,
  }) {
    final deficit = amountNeeded - ai.balance;
    if (deficit <= 0) return const [];

    final steps = <LiquidationStep>[];
    final simulated = Map<int, BoardCell>.fromEntries(
      ai.propertyIndexes.map((i) => MapEntry(i, state.board[i])),
    );
    var raised = 0;

    bool stillNeed() => raised < deficit;

    // 1) Mortgage railroads & utilities (non-colour).
    for (final idx in [...ai.propertyIndexes]) {
      if (!stillNeed()) break;
      final cell = simulated[idx];
      if (cell == null || cell.isMortgagedOrFalse) continue;
      if (cell is! RailroadCell && cell is! UtilityCell) continue;
      final mortgage = switch (cell) {
        RailroadCell(:final mortgage) => mortgage,
        UtilityCell(:final mortgage) => mortgage,
        _ => 0,
      };
      steps.add(MortgageStep(idx));
      raised += mortgage;
      simulated[idx] = switch (cell) {
        RailroadCell c => c.copyWith(isMortgaged: true),
        UtilityCell c => c.copyWith(isMortgaged: true),
        _ => cell,
      };
    }

    // 2) Mortgage singleton streets (not part of a monopoly).
    for (final idx in [...ai.propertyIndexes]) {
      if (!stillNeed()) break;
      final cell = simulated[idx];
      if (cell is! PropertyCell || cell.isMortgaged) continue;
      final inMono = RulesEngine.ownsFullColorGroup(
        board: [
          for (final c in state.board)
            if (simulated.containsKey(c.index)) simulated[c.index]! else c,
        ],
        ownerId: ai.id,
        group: cell.colorGroup,
      );
      if (inMono) continue;
      if (cell.houses > 0) continue;
      steps.add(MortgageStep(idx));
      raised += cell.mortgage;
      simulated[idx] = cell.copyWith(isMortgaged: true);
    }

    // 3) Sell houses (hotels first), then mortgage monopoly streets.
    final withHouses = simulated.entries
        .where((e) => e.value is PropertyCell && (e.value as PropertyCell).houses > 0)
        .toList()
      ..sort((a, b) {
        final ha = (a.value as PropertyCell).houses;
        final hb = (b.value as PropertyCell).houses;
        return hb.compareTo(ha);
      });

    for (final entry in withHouses) {
      while (stillNeed()) {
        final cell = simulated[entry.key] as PropertyCell;
        if (cell.houses <= 0) break;
        steps.add(SellHouseStep(entry.key));
        raised += cell.colorGroup.houseCost ~/ 2;
        simulated[entry.key] = cell.copyWith(houses: cell.houses - 1);
      }
    }

    for (final idx in [...ai.propertyIndexes]) {
      if (!stillNeed()) break;
      final cell = simulated[idx];
      if (cell is! PropertyCell || cell.isMortgaged || cell.houses > 0) {
        continue;
      }
      steps.add(MortgageStep(idx));
      raised += cell.mortgage;
      simulated[idx] = cell.copyWith(isMortgaged: true);
    }

    return steps;
  }

  static bool _isHighTraffic(ColorGroup g) =>
      g == ColorGroup.orange || g == ColorGroup.red || g == ColorGroup.pink;

  static double _trafficScore(ColorGroup g) => switch (g) {
        ColorGroup.orange => 10,
        ColorGroup.red => 9,
        ColorGroup.pink => 7,
        ColorGroup.lightBlue => 6,
        ColorGroup.yellow => 5,
        ColorGroup.green => 4,
        ColorGroup.darkBlue => 3,
        ColorGroup.brown => 2,
      };

  /// How often opponents are ~6–8 steps before [targetIndex].
  static double _opponentLandingPressure(
    GameState state,
    Player ai,
    int targetIndex,
  ) {
    var score = 0.0;
    for (final opp in state.livingPlayers) {
      if (opp.id == ai.id) continue;
      for (var steps = 6; steps <= 8; steps++) {
        final land = (opp.position + steps) % GameRules.boardSize;
        if (land == targetIndex) score += 3;
      }
      // Also lightly weight 5 and 9 (common totals).
      for (final steps in [5, 9]) {
        if ((opp.position + steps) % GameRules.boardSize == targetIndex) {
          score += 1.5;
        }
      }
    }
    return score;
  }
}
