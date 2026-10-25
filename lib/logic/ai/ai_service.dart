import 'dart:async';
import 'dart:math';

import '../../models/game_state.dart';
import '../../models/pending_action.dart';
import '../../models/player.dart';
import '../trade/auction_manager.dart';
import '../trade/trade_manager.dart';
import 'ai_decision_matrix.dart';

/// Callback surface the AI needs from [GameController].
abstract interface class AiGameBridge {
  GameState get aiState;
  bool get aiMounted;

  void aiRollDice();
  void aiFinishMove();
  void aiAcceptBuy();
  void aiDeclineBuy();
  void aiDismissNotice();
  void aiPayJailFine();
  void aiEndTurn();
  void aiBuildHouse(int cellIndex);
  bool aiRaiseFunds(String playerId, int amountNeeded);
  void aiAuctionBid(int amount);
  void aiAuctionPass();
  void aiAcceptTrade();
  void aiDeclineTrade();
}

/// Orchestrates heuristic bot turns with human-like thinking delays.
class AiService {
  AiService(this._bridge, {Random? random}) : _random = random ?? Random();

  final AiGameBridge _bridge;
  final Random _random;

  bool _busy = false;
  int _generation = 0;

  void scheduleIfNeeded() {
    if (_busy || !_bridge.aiMounted) return;
    final state = _bridge.aiState;
    if (state.isGameOver) return;

    final pending = state.pendingAction;
    if (pending is PendingAuction) {
      Player? bidder;
      for (final p in state.players) {
        if (p.id == pending.currentBidderId) bidder = p;
      }
      if (bidder == null || !bidder.isAi || bidder.isBankrupt) return;
      _busy = true;
      final gen = ++_generation;
      unawaited(_runAuction(gen, bidder));
      return;
    }

    if (pending is PendingTradeOffer) {
      final to = state.players
          .where((p) => p.id == pending.toPlayerId)
          .firstOrNull;
      if (to == null || !to.isAi) return;
      _busy = true;
      final gen = ++_generation;
      unawaited(_runTrade(gen, to, pending));
      return;
    }

    final active = state.activePlayer;
    if (!active.isAi || active.isBankrupt) return;

    _busy = true;
    final gen = ++_generation;
    unawaited(_run(gen, active));
  }

  Future<void> _runAuction(int gen, Player bidder) async {
    try {
      await _think(bidder.aiProfile ?? AiProfile.strategist);
      if (!_bridge.aiMounted || gen != _generation) return;
      final state = _bridge.aiState;
      final pending = state.pendingAction;
      if (pending is! PendingAuction) return;
      if (pending.currentBidderId != bidder.id) return;

      final auction = AuctionState(
        cellIndex: pending.cellIndex,
        propertyName: pending.propertyName,
        participantIds: pending.participantIds,
        highestBid: pending.highestBid,
        highestBidderId: pending.highestBidderId,
        currentBidderIndex:
            pending.participantIds.indexOf(pending.currentBidderId),
        passedIds: pending.passedIds.toSet(),
      );
      final price = state.cellAt(pending.cellIndex).priceOrNull ?? 100;
      final bid = AuctionManager.suggestAiBid(
        ai: bidder,
        auction: auction,
        listPrice: price,
        gameStateForMatrix: state,
      );
      if (bid > 0) {
        _bridge.aiAuctionBid(bid);
      } else {
        _bridge.aiAuctionPass();
      }
    } finally {
      if (gen == _generation) _busy = false;
      if (_bridge.aiMounted) scheduleIfNeeded();
    }
  }

  Future<void> _runTrade(
    int gen,
    Player ai,
    PendingTradeOffer pending,
  ) async {
    try {
      await _think(ai.aiProfile ?? AiProfile.strategist);
      if (!_bridge.aiMounted || gen != _generation) return;
      final offer = TradeOffer(
        fromPlayerId: pending.fromPlayerId,
        toPlayerId: pending.toPlayerId,
        offerCash: pending.offerCash,
        requestCash: pending.requestCash,
        offerProperties: pending.offerProperties,
        requestProperties: pending.requestProperties,
      );
      final ok = TradeManager.aiShouldAccept(
        state: _bridge.aiState,
        ai: ai,
        offer: offer,
      );
      if (ok) {
        _bridge.aiAcceptTrade();
      } else {
        _bridge.aiDeclineTrade();
      }
    } finally {
      if (gen == _generation) _busy = false;
      if (_bridge.aiMounted) scheduleIfNeeded();
    }
  }

  Future<void> _run(int gen, Player snapshot) async {
    try {
      while (_bridge.aiMounted && gen == _generation) {
        final state = _bridge.aiState;
        if (state.isGameOver) break;

        // Hand off to auction/trade loops if needed.
        if (state.pendingAction is PendingAuction ||
            state.pendingAction is PendingTradeOffer) {
          break;
        }

        final player = state.activePlayer;
        if (!player.isAi || player.id != snapshot.id) break;

        final profile = player.aiProfile ?? AiProfile.strategist;
        await _think(profile);
        if (!_bridge.aiMounted || gen != _generation) break;
        if (_bridge.aiState.activePlayer.id != snapshot.id) break;

        final acted = await _stepOnce();
        if (!acted) break;
      }
    } finally {
      if (gen == _generation) _busy = false;
      if (_bridge.aiMounted) scheduleIfNeeded();
    }
  }

  Future<void> _think(AiProfile profile) async {
    final (minMs, maxMs) = profile.thinkDelayMs;
    final ms = minMs + _random.nextInt(max(1, maxMs - minMs + 1));
    await Future<void>.delayed(Duration(milliseconds: ms));
  }

  Future<bool> _stepOnce() async {
    final state = _bridge.aiState;
    final player = state.activePlayer;
    if (!player.isAi) return false;

    final pending = state.pendingAction;

    if (pending is PendingBuyOffer) {
      final cell = state.cellAt(pending.cellIndex);
      final buy = AiDecisionMatrix.shouldBuyProperty(
        state: state,
        ai: player,
        cell: cell,
        price: pending.price,
      );
      if (buy) {
        _bridge.aiAcceptBuy();
      } else {
        _bridge.aiDeclineBuy();
      }
      return true;
    }

    if (pending is! PendingNone && pending is! PendingWinner) {
      _bridge.aiDismissNotice();
      return true;
    }

    if (state.phase == TurnPhase.waitingForRoll) {
      if (player.inJail &&
          AiDecisionMatrix.shouldPayJailFine(state: state, ai: player)) {
        _bridge.aiPayJailFine();
        return true;
      }
      _bridge.aiRollDice();
      if (_bridge.aiState.phase == TurnPhase.movingToken) {
        _bridge.aiFinishMove();
      }
      return true;
    }

    if (state.phase == TurnPhase.canEndTurn) {
      _tryBuild(state, player);
      _bridge.aiEndTurn();
      return true;
    }

    if (state.phase == TurnPhase.movingToken) {
      _bridge.aiFinishMove();
      return true;
    }

    return false;
  }

  void _tryBuild(GameState state, Player player) {
    final targets = AiDecisionMatrix.preferredBuildTargets(
      state: state,
      ai: player,
    );
    var built = 0;
    for (final index in targets) {
      if (built >= 3) break;
      final before = _bridge.aiState.activePlayer.balance;
      _bridge.aiBuildHouse(index);
      final after = _bridge.aiState.activePlayer.balance;
      if (after < before) built++;
      if (_bridge.aiState.activePlayer.id != player.id) break;
    }
  }

  void cancel() {
    _generation++;
    _busy = false;
  }
}
