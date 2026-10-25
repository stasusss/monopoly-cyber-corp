import '../../models/game_state.dart';
import '../../models/player.dart';
import '../ai/ai_decision_matrix.dart';
import '../rules_engine.dart';

/// Live auction for a declined property purchase.
class AuctionState {
  AuctionState({
    required this.cellIndex,
    required this.propertyName,
    required this.participantIds,
    this.highestBid = 0,
    this.highestBidderId,
    this.currentBidderIndex = 0,
    Set<String>? passedIds,
  }) : passedIds = passedIds ?? {};

  final int cellIndex;
  final String propertyName;
  final List<String> participantIds;
  int highestBid;
  String? highestBidderId;
  int currentBidderIndex;
  final Set<String> passedIds;

  String get currentBidderId =>
      participantIds[currentBidderIndex % participantIds.length];

  bool get isFinished {
    final active = participantIds.where((id) => !passedIds.contains(id)).toList();
    if (active.isEmpty) return true;
    if (active.length == 1 && highestBidderId == active.first) return true;
    if (passedIds.length >= participantIds.length) return true;
    return false;
  }

  Map<String, dynamic> toJson() => {
        'cellIndex': cellIndex,
        'propertyName': propertyName,
        'participantIds': participantIds,
        'highestBid': highestBid,
        'highestBidderId': highestBidderId,
        'currentBidderIndex': currentBidderIndex,
        'passedIds': passedIds.toList(),
      };

  factory AuctionState.fromJson(Map<String, dynamic> json) => AuctionState(
        cellIndex: json['cellIndex'] as int,
        propertyName: json['propertyName'] as String,
        participantIds: List<String>.from(json['participantIds'] as List),
        highestBid: json['highestBid'] as int? ?? 0,
        highestBidderId: json['highestBidderId'] as String?,
        currentBidderIndex: json['currentBidderIndex'] as int? ?? 0,
        passedIds: Set<String>.from(json['passedIds'] as List? ?? const []),
      );
}

abstract final class AuctionManager {
  static AuctionState start({
    required int cellIndex,
    required String propertyName,
    required List<Player> livingPlayers,
  }) {
    return AuctionState(
      cellIndex: cellIndex,
      propertyName: propertyName,
      participantIds: [for (final p in livingPlayers) p.id],
    );
  }

  static void pass(AuctionState auction, String playerId) {
    auction.passedIds.add(playerId);
    _advance(auction);
  }

  static bool placeBid(AuctionState auction, String playerId, int amount) {
    if (amount <= auction.highestBid) return false;
    auction.highestBid = amount;
    auction.highestBidderId = playerId;
    auction.passedIds.remove(playerId);
    // Everyone else must respond again except current high bidder.
    auction.passedIds.removeWhere((id) => id == playerId);
    for (final id in auction.participantIds) {
      if (id != playerId) auction.passedIds.remove(id);
    }
    _advance(auction);
    return true;
  }

  static void _advance(AuctionState auction) {
    if (auction.participantIds.isEmpty) return;
    for (var i = 0; i < auction.participantIds.length; i++) {
      auction.currentBidderIndex =
          (auction.currentBidderIndex + 1) % auction.participantIds.length;
      final id = auction.currentBidderId;
      if (!auction.passedIds.contains(id) || id == auction.highestBidderId) {
        // Prefer next non-passed participant.
        if (!auction.passedIds.contains(id)) break;
      }
    }
    // Skip those who passed (unless sole remaining).
    var guard = 0;
    while (auction.passedIds.contains(auction.currentBidderId) &&
        auction.passedIds.length < auction.participantIds.length &&
        guard < auction.participantIds.length) {
      auction.currentBidderIndex =
          (auction.currentBidderIndex + 1) % auction.participantIds.length;
      guard++;
    }
  }

  /// AI bid suggestion — 0 means pass.
  static int suggestAiBid({
    required Player ai,
    required AuctionState auction,
    required int listPrice,
    required GameState gameStateForMatrix,
  }) {
    final profile = ai.aiProfile ?? AiProfile.strategist;
    final maxBid = switch (profile) {
      AiProfile.aggressive => (listPrice * 1.15).round(),
      AiProfile.strategist => listPrice,
      AiProfile.banker => (listPrice * 0.75).round(),
    };
    final buffer = AiDecisionMatrix.cashBuffer(gameStateForMatrix, ai);
    final affordable = ai.balance - buffer;
    final ceiling = [maxBid, affordable].reduce((a, b) => a < b ? a : b);
    final next = auction.highestBid + 10;
    if (next > ceiling || !RulesEngine.canAfford(ai, next)) return 0;
    return next;
  }
}
