import '../../core/constants/street_colors.dart';
import '../../models/cell.dart';
import '../../models/game_state.dart';
import '../../models/player.dart';
import '../ai/ai_decision_matrix.dart';

class TradeOffer {
  const TradeOffer({
    required this.fromPlayerId,
    required this.toPlayerId,
    this.offerCash = 0,
    this.requestCash = 0,
    this.offerProperties = const [],
    this.requestProperties = const [],
  });

  final String fromPlayerId;
  final String toPlayerId;
  final int offerCash;
  final int requestCash;
  final List<int> offerProperties;
  final List<int> requestProperties;

  Map<String, dynamic> toJson() => {
        'fromPlayerId': fromPlayerId,
        'toPlayerId': toPlayerId,
        'offerCash': offerCash,
        'requestCash': requestCash,
        'offerProperties': offerProperties,
        'requestProperties': requestProperties,
      };

  factory TradeOffer.fromJson(Map<String, dynamic> json) => TradeOffer(
        fromPlayerId: json['fromPlayerId'] as String,
        toPlayerId: json['toPlayerId'] as String,
        offerCash: json['offerCash'] as int? ?? 0,
        requestCash: json['requestCash'] as int? ?? 0,
        offerProperties:
            List<int>.from(json['offerProperties'] as List? ?? const []),
        requestProperties:
            List<int>.from(json['requestProperties'] as List? ?? const []),
      );
}

abstract final class TradeManager {
  static bool validate(GameState state, TradeOffer offer) {
    Player? byId(String id) {
      try {
        return state.players.firstWhere((p) => p.id == id);
      } catch (_) {
        return null;
      }
    }

    final from = byId(offer.fromPlayerId);
    final to = byId(offer.toPlayerId);
    if (from == null || to == null || from.isBankrupt || to.isBankrupt) {
      return false;
    }
    if (from.balance < offer.offerCash || to.balance < offer.requestCash) {
      return false;
    }
    for (final i in offer.offerProperties) {
      if (state.cellAt(i).ownerIdOrNull != from.id) return false;
      if (state.cellAt(i) is PropertyCell &&
          (state.cellAt(i) as PropertyCell).houses > 0) {
        return false;
      }
    }
    for (final i in offer.requestProperties) {
      if (state.cellAt(i).ownerIdOrNull != to.id) return false;
      if (state.cellAt(i) is PropertyCell &&
          (state.cellAt(i) as PropertyCell).houses > 0) {
        return false;
      }
    }
    return true;
  }

  /// Rough asset value for AI evaluation.
  static int assetValue(BoardCell cell) => cell.priceOrNull ?? 0;

  static int sideValue({
    required GameState state,
    required int cash,
    required List<int> properties,
  }) {
    var total = cash;
    for (final i in properties) {
      total += assetValue(state.cellAt(i));
    }
    return total;
  }

  /// AI accepts if net value improves or monopoly is completed with fair cash.
  static bool aiShouldAccept({
    required GameState state,
    required Player ai,
    required TradeOffer offer,
  }) {
    // Perspective: AI is the "to" side receiving offerProperties + offerCash,
    // giving requestProperties + requestCash.
    final receiving = sideValue(
      state: state,
      cash: offer.offerCash,
      properties: offer.offerProperties,
    );
    final giving = sideValue(
      state: state,
      cash: offer.requestCash,
      properties: offer.requestProperties,
    );

    final closes = offer.offerProperties.any((i) {
      final cell = state.cellAt(i);
      return AiDecisionMatrix.closesMonopoly(
        state: state,
        ai: ai,
        cell: cell is PropertyCell
            ? cell.copyWith(ownerId: null) // treat as acquirable
            : cell,
      );
    });

    // Better heuristic: after trade, would AI own full group?
    var monopolyGain = false;
    for (final i in offer.offerProperties) {
      final cell = state.cellAt(i);
      if (cell is! PropertyCell) continue;
      final owned = state.board
          .whereType<PropertyCell>()
          .where((c) => c.colorGroup == cell.colorGroup)
          .where(
            (c) =>
                c.ownerId == ai.id ||
                offer.offerProperties.contains(c.index),
          )
          .where((c) => !offer.requestProperties.contains(c.index));
      if (owned.length == cell.colorGroup.propertyCount) {
        monopolyGain = true;
        break;
      }
    }

    if (monopolyGain || closes) {
      return receiving + 100 >= giving;
    }
    return receiving >= giving + 20;
  }

  static GameState apply(GameState state, TradeOffer offer) {
    if (!validate(state, offer)) return state;

    var players = [...state.players];
    var board = [...state.board];

    Player update(Player p) {
      final i = players.indexWhere((x) => x.id == p.id);
      players[i] = p;
      return p;
    }

    var from = players.firstWhere((p) => p.id == offer.fromPlayerId);
    var to = players.firstWhere((p) => p.id == offer.toPlayerId);

    from = from.copyWith(
      balance: from.balance - offer.offerCash + offer.requestCash,
      propertyIndexes: [
        ...from.propertyIndexes.where((i) => !offer.offerProperties.contains(i)),
        ...offer.requestProperties,
      ],
    );
    to = to.copyWith(
      balance: to.balance - offer.requestCash + offer.offerCash,
      propertyIndexes: [
        ...to.propertyIndexes.where((i) => !offer.requestProperties.contains(i)),
        ...offer.offerProperties,
      ],
    );
    update(from);
    update(to);

    void transfer(int index, String newOwner) {
      final cell = board[index];
      board[index] = switch (cell) {
        PropertyCell c => c.copyWith(ownerId: newOwner),
        RailroadCell c => c.copyWith(ownerId: newOwner),
        UtilityCell c => c.copyWith(ownerId: newOwner),
        _ => cell,
      };
    }

    for (final i in offer.offerProperties) {
      transfer(i, to.id);
    }
    for (final i in offer.requestProperties) {
      transfer(i, from.id);
    }

    return state.copyWith(board: board, players: players);
  }
}
