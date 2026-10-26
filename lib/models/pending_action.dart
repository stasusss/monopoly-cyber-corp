import 'package:freezed_annotation/freezed_annotation.dart';

part 'pending_action.freezed.dart';
part 'pending_action.g.dart';

/// UI-facing action that blocks the turn until the player responds (or dismisses).
@freezed
sealed class PendingAction with _$PendingAction {
  const factory PendingAction.none() = PendingNone;

  const factory PendingAction.buyOffer({
    required int cellIndex,
    required String propertyName,
    required int price,
  }) = PendingBuyOffer;

  const factory PendingAction.rentNotice({
    required String payerName,
    required String ownerName,
    required String propertyName,
    required int amount,
    @Default(false) bool canDodge,
  }) = PendingRentNotice;

  const factory PendingAction.taxNotice({
    required String playerName,
    required String taxName,
    required int amount,
  }) = PendingTaxNotice;

  const factory PendingAction.cardNotice({
    required String title,
    required String description,
  }) = PendingCardNotice;

  const factory PendingAction.auction({
    required int cellIndex,
    required String propertyName,
    required int highestBid,
    String? highestBidderId,
    required String currentBidderId,
    required List<String> participantIds,
    required List<String> passedIds,
  }) = PendingAuction;

  const factory PendingAction.tradeOffer({
    required String fromPlayerId,
    required String toPlayerId,
    required int offerCash,
    required int requestCash,
    required List<int> offerProperties,
    required List<int> requestProperties,
  }) = PendingTradeOffer;

  const factory PendingAction.winner({
    required String playerId,
    required String playerName,
    @Default(0) int netWorth,
  }) = PendingWinner;

  /// Eminent-domain / once-per-game district claim. Player picks a blocker.
  const factory PendingAction.claimOffer({
    required List<int> cellIndexes,
    required bool consumesBuyout,
  }) = PendingClaimOffer;

  /// Human is short on a bill and must mortgage, sell, pay, or flatline.
  const factory PendingAction.shortfall({
    required int amount,
    required String kind,
    String? creditorId,
    int? cellIndex,
    required String label,
  }) = PendingShortfall;

  /// Net-worth leader picks the mid-session city decree.
  const factory PendingAction.cityVote({
    required int round,
    required String leaderId,
  }) = PendingCityVote;

  /// Heat is maxed: pay the fine or sit in ICE.
  const factory PendingAction.heatCheck({
    required int fine,
  }) = PendingHeatCheck;

  factory PendingAction.fromJson(Map<String, dynamic> json) =>
      _$PendingActionFromJson(json);
}
