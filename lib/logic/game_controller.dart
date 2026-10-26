import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/audio/sound_service.dart';
import '../core/constants/game_factory.dart';
import '../core/constants/game_rules.dart';
import '../core/constants/street_colors.dart';
import '../core/l10n/app_lang.dart';
import '../core/l10n/app_strings.dart';
import '../core/storage/game_storage.dart';
import '../models/cell.dart';
import '../models/dice.dart';
import '../models/game_state.dart';
import '../models/pending_action.dart';
import '../models/player.dart';
import 'ai/ai_decision_matrix.dart';
import 'ai/ai_dialogue_service.dart';
import 'ai/ai_service.dart';
import 'cards/card_resolver.dart';
import 'cards/deck_manager.dart';
import 'cards/game_card.dart';
import 'network/network_action.dart';
import 'network/online_session.dart';
import 'network/supabase_realtime_service.dart';
import 'nightfall.dart';
import 'rules_engine.dart';
import 'trade/auction_manager.dart';
import 'trade/trade_manager.dart';

final gameControllerProvider =
    StateNotifierProvider<GameController, GameState>((ref) {
  return GameController(
    strings: () => AppStrings(ref.read(appLangProvider)),
  );
});

/// Turn state machine + board mutations for Pass & Play / heuristic AI /
/// peer-host online (host validates + STATE_SYNC).
class GameController extends StateNotifier<GameState>
    implements AiGameBridge {
  GameController({
    Random? random,
    GameState? initial,
    DeckManager? decks,
    GameStorage? storage,
    AppStrings Function()? strings,
    this.enableAi = true,
    this.autosave = true,
  })  : _random = random ?? Random(),
        _decks = decks ?? DeckManager.shuffled(random ?? Random()),
        _storage = storage ?? GameStorage(),
        _strings = strings ?? _englishStrings,
        super(initial ?? GameFactory.newGame(roster: GameFactory.defaultRoster)) {
    _ai = AiService(this, random: _random);
    if (initial == null) _localizeBootLog();
    if (enableAi) {
      Future.microtask(_ai.scheduleIfNeeded);
    }
  }

  final AppStrings Function() _strings;

  AppStrings get t => _strings();

  static AppStrings _englishStrings() => const AppStrings(AppLang.en);

  void _localizeBootLog() {
    final names = state.players.map((p) => p.name).join(', ');
    state = state.copyWith(
      log: [t.sessionBoot(names, GameRules.credits(GameRules.startingMoney))],
    );
  }

  final Random _random;
  final bool enableAi;
  final bool autosave;
  final GameStorage _storage;
  late final AiService _ai;
  DeckManager _decks;
  AuctionState? _auction;

  OnlineSession? _online;
  bool _applyingRemote = false;
  String? _lastKnownHostId;
  StreamSubscription<NetworkAction>? _actionSub;
  StreamSubscription<Map<String, dynamic>>? _syncSub;
  StreamSubscription<List<PresenceMember>>? _presenceSub;
  StreamSubscription<(PresenceMember, List<PresenceMember>)>? _leaveSub;
  final Map<String, Timer> _disconnectTimers = {};

  DeckManager get decks => _decks;

  bool get isOnline => _online != null;
  bool get isHost => _online == null || _online!.isHost;
  String? get localPlayerId => _online?.localPlayerId;

  /// UI: only the local operative may press turn actions in online mode.
  bool get isLocalInputAllowed {
    if (!isOnline) return true;
    final id = localPlayerId;
    if (id == null) return false;
    final pending = state.pendingAction;
    if (pending is PendingAuction) return pending.currentBidderId == id;
    if (pending is PendingTradeOffer) return pending.toPlayerId == id;
    if (pending is PendingBuyOffer ||
        pending is PendingRentNotice ||
        pending is PendingTaxNotice ||
        pending is PendingCardNotice) {
      return state.activePlayer.id == id;
    }
    return state.activePlayer.id == id;
  }

  Player get _active => state.activePlayer;

  void _pokeAi() {
    if (!enableAi) return;
    if (isOnline && !isHost) return;
    _ai.scheduleIfNeeded();
  }

  // —— AiGameBridge ——————————————————————————————————————————————

  @override
  GameState get aiState => state;

  @override
  bool get aiMounted => mounted;

  @override
  void aiRollDice() => rollDice();

  @override
  void aiFinishMove() => finishMove();

  @override
  void aiAcceptBuy() => acceptBuy();

  @override
  void aiDeclineBuy() => declineBuy();

  @override
  void aiDismissNotice() => dismissNotice();

  @override
  void aiPayJailFine() => payJailFine();

  @override
  void aiEndTurn() => endTurn();

  @override
  void aiBuildHouse(int cellIndex) => buildHouse(cellIndex);

  @override
  bool aiRaiseFunds(String playerId, int amountNeeded) =>
      raiseFunds(playerId, amountNeeded);

  @override
  void aiAuctionBid(int amount) => auctionBid(amount);

  @override
  void aiAuctionPass() => auctionPass();

  @override
  void aiAcceptTrade() => acceptTrade();

  @override
  void aiDeclineTrade() => declineTrade();

  @override
  void aiUseJailCard() => useJailCard();

  @override
  void aiDrawOverdraft() => drawOverdraft();

  @override
  void aiBuyout(int cellIndex) => buyout(cellIndex);

  @override
  void aiBlackout(int cellIndex) => blackout(cellIndex);

  @override
  void aiAcceptClaim(int cellIndex) => acceptClaim(cellIndex);

  @override
  void aiDeclineClaim() => declineClaim();

  // —— Public API ————————————————————————————————————————————————

  void rollDice() {
    if (_clientSend(NetworkActionType.roll)) return;
    if (!_allowActivePlayerAction()) return;
    if (state.phase != TurnPhase.waitingForRoll || state.isGameOver) return;
    if (state.pendingAction is! PendingNone) return;

    final roll = DiceRoll.roll(_random);
    state = state.copyWith(
      phase: TurnPhase.rolling,
      lastRoll: roll,
    );

    if (_active.inJail) {
      _resolveJailRoll(roll);
      _pokeAi();
      _hostSync();
      return;
    }

    final doubles = roll.isDoubles ? state.consecutiveDoubles + 1 : 0;
    if (doubles >= GameRules.doublesForJail) {
      _sendToJail(
        reason: t.tripleDoubles(_active.name),
        resetDoubles: true,
      );
      _pokeAi();
      _hostSync();
      return;
    }

    state = state.copyWith(consecutiveDoubles: doubles);
    _beginMove(steps: roll.total);
    _pokeAi();
    _hostSync();
  }

  void advanceMoveStep() {
    if (isOnline && !isHost) return;
    if (state.phase != TurnPhase.movingToken || state.moveStepsLeft <= 0) {
      return;
    }

    final player = _active;
    final nextPos = (player.position + 1) % GameRules.boardSize;
    final passedGo = nextPos == GameRules.goIndex;
    final updatedPlayer = player.copyWith(
      position: nextPos,
      balance: passedGo ? player.balance + GameRules.goSalary : player.balance,
    );
    final stepsLeft = state.moveStepsLeft - 1;

    state = state.copyWith(
      players: _replacePlayer(updatedPlayer),
      moveStepsLeft: stepsLeft,
      log: passedGo
          ? _append(
              t.passedGo(player.name, GameRules.credits(GameRules.goSalary)),
            )
          : state.log,
    );

    if (passedGo) {
      _skimOverdraftOnActive();
      if (state.isGameOver || _active.isBankrupt) {
        state = state.copyWith(moveStepsLeft: 0, moveFromIndex: null);
        return;
      }
    }

    if (stepsLeft == 0 && state.phase == TurnPhase.movingToken) {
      state = state.copyWith(
        phase: TurnPhase.cellAction,
        moveFromIndex: null,
      );
      _resolveCell();
      _pokeAi();
      _hostSync();
    }
  }

  void finishMove() {
    if (isOnline && !isHost) return;
    while (state.phase == TurnPhase.movingToken && state.moveStepsLeft > 0) {
      advanceMoveStep();
    }
  }

  void acceptBuy() {
    if (_clientSend(NetworkActionType.buy)) return;
    if (!_allowActivePlayerAction()) return;
    final pending = state.pendingAction;
    if (pending is! PendingBuyOffer) return;
    _purchase(pending.cellIndex);
    _clearPendingAndContinue();
    _hostSync();
  }

  void declineBuy() {
    if (_clientSend(NetworkActionType.declineBuy)) return;
    if (!_allowActivePlayerAction()) return;
    final pending = state.pendingAction;
    if (pending is! PendingBuyOffer) return;
    _speak(
      _active,
      AiDialogueEvent.declineBuy,
    );
    state = state.copyWith(
      log: _append(
        t.declinesToAuction(_active.name, pending.propertyName),
      ),
    );
    soundService.play(Sfx.auction);
    _beginAuction(pending.cellIndex, pending.propertyName);
    _hostSync();
  }

  void auctionBid(int amount) {
    if (_clientSend(NetworkActionType.auctionBid, {'amount': amount})) return;
    if (!_allowAuctionActor()) return;
    final auction = _auction;
    if (auction == null) return;
    final bidderId = auction.currentBidderId;
    final bidder = state.players.firstWhere((p) => p.id == bidderId);
    if (!RulesEngine.canAfford(bidder, amount)) return;
    if (!AuctionManager.placeBid(auction, bidderId, amount)) return;
    state = state.copyWith(
      log: _append(t.bids(bidder.name, GameRules.credits(amount))),
    );
    _afterAuctionAction();
    _hostSync();
  }

  void auctionPass() {
    if (_clientSend(NetworkActionType.auctionPass)) return;
    if (!_allowAuctionActor()) return;
    final auction = _auction;
    if (auction == null) return;
    final bidderId = auction.currentBidderId;
    final bidder = state.players.firstWhere((p) => p.id == bidderId);
    AuctionManager.pass(auction, bidderId);
    state = state.copyWith(log: _append(t.passesAuction(bidder.name)));
    _afterAuctionAction();
    _hostSync();
  }

  void proposeTrade(TradeOffer offer) {
    if (_clientSend(NetworkActionType.trade, offer.toJson())) return;
    if (!TradeManager.validate(state, offer)) return;
    state = state.copyWith(
      pendingAction: PendingAction.tradeOffer(
        fromPlayerId: offer.fromPlayerId,
        toPlayerId: offer.toPlayerId,
        offerCash: offer.offerCash,
        requestCash: offer.requestCash,
        offerProperties: offer.offerProperties,
        requestProperties: offer.requestProperties,
      ),
      phase: TurnPhase.cellAction,
      log: _append(t.pick('Trade proposed.', 'Обмін запропоновано.')),
    );
    _pokeAi();
    _hostSync();
  }

  void acceptTrade() {
    if (_clientSend(NetworkActionType.tradeAccept)) return;
    if (!_allowTradeResponder()) return;
    final pending = state.pendingAction;
    if (pending is! PendingTradeOffer) return;
    final offer = TradeOffer(
      fromPlayerId: pending.fromPlayerId,
      toPlayerId: pending.toPlayerId,
      offerCash: pending.offerCash,
      requestCash: pending.requestCash,
      offerProperties: pending.offerProperties,
      requestProperties: pending.requestProperties,
    );
    state = TradeManager.apply(state, offer).copyWith(
      pendingAction: const PendingAction.none(),
      phase: TurnPhase.canEndTurn,
      log: _append(t.pick('Trade executed.', 'Обмін виконано.')),
    );
    _pokeAi();
    _hostSync();
  }

  void declineTrade() {
    if (_clientSend(NetworkActionType.tradeDecline)) return;
    if (!_allowTradeResponder()) return;
    if (state.pendingAction is! PendingTradeOffer) return;
    state = state.copyWith(
      pendingAction: const PendingAction.none(),
      phase: TurnPhase.canEndTurn,
      log: _append(t.pick('Trade declined.', 'Обмін відхилено.')),
    );
    _pokeAi();
    _hostSync();
  }

  void dismissNotice() {
    if (_clientSend(NetworkActionType.dismissNotice)) return;
    if (!_allowActivePlayerAction()) return;
    final pending = state.pendingAction;
    if (pending is PendingBuyOffer ||
        pending is PendingWinner ||
        pending is PendingAuction ||
        pending is PendingTradeOffer ||
        pending is PendingClaimOffer) {
      return;
    }
    if (pending is PendingNone) return;

    final posBefore = _active.position;
    _clearPendingAndContinue();

    // If a card relocated the token, resolve the new cell once.
    if (pending is PendingCardNotice &&
        state.phase == TurnPhase.canEndTurn &&
        state.cellAt(posBefore).isOwnable) {
      // Card resolver may have moved; re-check landing.
    }
    final cell = state.cellAt(_active.position);
    if (pending is PendingCardNotice &&
        (cell.isOwnable || cell is TaxCell || cell is SpecialCell)) {
      // Re-enter resolve only when we just moved via card and haven't paid rent.
      if (state.log.isNotEmpty &&
          state.log.last.contains('Card move pending')) {
        state = state.copyWith(phase: TurnPhase.cellAction);
        _resolveCell();
        _pokeAi();
      }
    }
    _hostSync();
  }

  void payJailFine() {
    if (_clientSend(NetworkActionType.payJailFine)) return;
    if (!_allowActivePlayerAction()) return;
    if (!_active.inJail || state.phase != TurnPhase.waitingForRoll) return;
    if (!RulesEngine.canAfford(_active, GameRules.jailFine)) {
      if (_active.isAi) {
        raiseFunds(_active.id, GameRules.jailFine);
      }
      if (!RulesEngine.canAfford(_active, GameRules.jailFine)) {
        state = state.copyWith(
          log: _append(
            t.cannotPayFine(_active.name, GameRules.credits(GameRules.jailFine)),
          ),
        );
        return;
      }
    }
    final freed = _active.copyWith(
      balance: _active.balance - GameRules.jailFine,
      inJail: false,
      jailTurns: 0,
    );
    state = state.copyWith(
      players: _replacePlayer(freed),
      log: _append(
        t.paidFine(freed.name, GameRules.credits(GameRules.jailFine)),
      ),
    );
    _pokeAi();
    _hostSync();
  }

  void endTurn() {
    if (_clientSend(NetworkActionType.endTurn)) return;
    if (!_allowActivePlayerAction()) return;
    if (state.phase != TurnPhase.canEndTurn || state.isGameOver) return;
    if (state.pendingAction is! PendingNone) return;

    final rolledDoubles = state.lastRoll?.isDoubles ?? false;
    final extraTurn = rolledDoubles &&
        state.consecutiveDoubles > 0 &&
        !_active.inJail;

    if (extraTurn) {
      state = state.copyWith(
        phase: TurnPhase.waitingForRoll,
        log: _append(t.extraTurn(_active.name)),
      );
      _pokeAi();
      _hostSync();
      return;
    }

    _advanceToNextPlayer();
    _hostSync();
  }

  /// Build one house / hotel step on [cellIndex] (even-build enforced).
  bool buildHouse(int cellIndex) {
    if (_clientSend(NetworkActionType.buildHouse, {'cellIndex': cellIndex})) {
      return false;
    }
    if (!_canManageEmpire()) return false;
    final cell = state.cellAt(cellIndex);
    if (cell is! PropertyCell) return false;
    if (Nightfall.rackBuildBlock(state: state, cell: cell, player: _active) !=
        null) {
      return false;
    }

    final buildingHotel = cell.houses >= 4;
    final cost = Nightfall.nodeCost(cell.colorGroup, cell.houses);

    final board = [...state.board];
    board[cellIndex] = cell.copyWith(houses: cell.houses + 1);
    final buyer = _active.copyWith(balance: _active.balance - cost);
    state = state.copyWith(
      board: board,
      players: _replacePlayer(buyer),
      housesInBank: buildingHotel
          ? (state.housesInBank + 4).clamp(0, GameRules.housesInSupply)
          : state.housesInBank - 1,
      hotelsInBank:
          buildingHotel ? state.hotelsInBank - 1 : state.hotelsInBank,
      log: _append(
        t.built(
          buyer.name,
          cell.name,
          cell.houses + 1,
          GameRules.credits(cost),
        ),
      ),
    );
    _hostSync();
    return true;
  }

  /// Sell one node on [cellIndex]. Returns cash raised.
  int sellNode(int cellIndex) {
    if (_clientSend(NetworkActionType.sellHouse, {'cellIndex': cellIndex})) {
      return 0;
    }
    if (!_canManageEmpire()) return 0;
    final cell = state.cellAt(cellIndex);
    if (cell is! PropertyCell || cell.ownerId != _active.id) return 0;
    return sellHouse(cellIndex);
  }

  /// Mortgage an owned unimproved property; returns cash raised (0 if failed).
  int mortgageProperty(int cellIndex) {
    if (isOnline && !isHost && !_applyingRemote) return 0;
    final cell = state.cellAt(cellIndex);
    final ownerId = cell.ownerIdOrNull;
    if (ownerId == null || cell.isMortgagedOrFalse) return 0;

    final player = state.players.firstWhere((p) => p.id == ownerId);

    final mortgage = switch (cell) {
      PropertyCell c when c.houses == 0 => c.mortgage,
      RailroadCell c => c.mortgage,
      UtilityCell c => c.mortgage,
      _ => 0,
    };
    if (mortgage <= 0) return 0;

    final board = [...state.board];
    board[cellIndex] = switch (cell) {
      PropertyCell c => c.copyWith(isMortgaged: true),
      RailroadCell c => c.copyWith(isMortgaged: true),
      UtilityCell c => c.copyWith(isMortgaged: true),
      _ => cell,
    };

    state = state.copyWith(
      board: board,
      players: _replacePlayer(
        player.copyWith(balance: player.balance + mortgage),
      ),
      log: _append(
        t.mortgaged(player.name, cell.name, GameRules.credits(mortgage)),
      ),
    );
    return mortgage;
  }

  /// Player-facing mortgage. [mortgageProperty] stays available mid-resolution.
  bool pledgeProperty(int cellIndex) {
    if (_clientSend(NetworkActionType.mortgage, {'cellIndex': cellIndex})) {
      return false;
    }
    if (!_canManageEmpire()) return false;
    final cell = state.cellAt(cellIndex);
    if (cell.ownerIdOrNull != _active.id) return false;
    return mortgageProperty(cellIndex) > 0;
  }

  bool unmortgageProperty(int cellIndex) {
    if (_clientSend(NetworkActionType.unmortgage, {'cellIndex': cellIndex})) {
      return false;
    }
    if (!_canManageEmpire()) return false;
    final cell = state.cellAt(cellIndex);
    if (cell.ownerIdOrNull != _active.id || !cell.isMortgagedOrFalse) {
      return false;
    }
    if (cell is PropertyCell && cell.houses > 0) return false;
    final cost = Nightfall.unmortgageCost(Nightfall.mortgageValue(cell));
    if (cost <= 0 || !RulesEngine.canAfford(_active, cost)) return false;

    final board = [...state.board];
    board[cellIndex] = switch (cell) {
      PropertyCell c => c.copyWith(isMortgaged: false),
      RailroadCell c => c.copyWith(isMortgaged: false),
      UtilityCell c => c.copyWith(isMortgaged: false),
      _ => cell,
    };
    final player = _active.copyWith(balance: _active.balance - cost);
    state = state.copyWith(
      board: board,
      players: _replacePlayer(player),
      log: _append(
        t.lifted(player.name, cell.name, GameRules.credits(cost)),
      ),
    );
    _hostSync();
    return true;
  }

  void useJailCard() {
    if (_clientSend(NetworkActionType.useJailCard)) return;
    if (!_allowActivePlayerAction()) return;
    final player = _active;
    if (!player.inJail ||
        state.phase != TurnPhase.waitingForRoll ||
        player.getOutOfJailCards <= 0) {
      return;
    }
    final sources = [...player.jailCardSources];
    final sourceName =
        sources.isEmpty ? CardDeckKind.dataBreach.name : sources.removeAt(0);
    final kind = CardDeckKind.values.byName(sourceName);
    _decks.returnGetOutCard(kind);
    final freed = player.copyWith(
      inJail: false,
      jailTurns: 0,
      getOutOfJailCards: player.getOutOfJailCards - 1,
      jailCardSources: sources,
    );
    state = state.copyWith(
      players: _replacePlayer(freed),
      log: _append(t.burnedNullifier(freed.name)),
    );
    _pokeAi();
    _hostSync();
  }

  void drawOverdraft() {
    if (_clientSend(NetworkActionType.overdraft)) return;
    if (!_canManageEmpire()) return;
    final player = _active;
    if (player.overdraftUsed) return;
    final principal = Nightfall.overdraftPrincipal(state, player);
    if (principal <= 0) return;
    final total = (principal * 3) ~/ 2;
    final debtor = player.copyWith(
      balance: player.balance + principal,
      overdraftUsed: true,
      overdraftRemaining: total,
      overdraftInstallmentsLeft: 2,
    );
    state = state.copyWith(
      players: _replacePlayer(debtor),
      log: _append(
        t.overdraft(
          debtor.name,
          GameRules.credits(principal),
          GameRules.credits(total),
        ),
      ),
    );
    _hostSync();
  }

  bool buyout(int cellIndex) {
    if (_clientSend(NetworkActionType.buyout, {'cellIndex': cellIndex})) {
      return false;
    }
    if (!_canManageEmpire()) return false;
    if (_active.buyoutUsed) return false;
    if (!Nightfall.claimTargets(state, _active).contains(cellIndex)) {
      return false;
    }
    return _executeBuyout(cellIndex, consumeCharge: true);
  }

  void requestClaim() {
    if (_clientSend(NetworkActionType.requestClaim)) return;
    if (!_canManageEmpire()) return;
    if (_active.buyoutUsed) return;
    _beginClaim(consumesBuyout: true);
    _pokeAi();
    _hostSync();
  }

  void acceptClaim(int cellIndex) {
    if (_clientSend(NetworkActionType.acceptClaim, {'cellIndex': cellIndex})) {
      return;
    }
    if (!_allowActivePlayerAction()) return;
    final pending = state.pendingAction;
    if (pending is! PendingClaimOffer) return;
    if (!pending.cellIndexes.contains(cellIndex)) return;
    if (pending.consumesBuyout && _active.buyoutUsed) return;
    if (!_executeBuyout(cellIndex, consumeCharge: pending.consumesBuyout)) {
      return;
    }
    _clearPendingAndContinue();
    _hostSync();
  }

  void declineClaim() {
    if (_clientSend(NetworkActionType.declineClaim)) return;
    if (!_allowActivePlayerAction()) return;
    if (state.pendingAction is! PendingClaimOffer) return;
    state = state.copyWith(
      pendingAction: const PendingAction.none(),
      phase: TurnPhase.canEndTurn,
      log: _append(t.declinedClaim(_active.name)),
    );
    _pokeAi();
    _hostSync();
  }

  void blackout(int cellIndex) {
    if (_clientSend(NetworkActionType.blackout, {'cellIndex': cellIndex})) {
      return;
    }
    if (!_canManageEmpire()) return;
    final player = _active;
    if (player.blackoutUsedThisTurn) return;
    final cell = state.cellAt(cellIndex);
    if (cell is! PropertyCell) return;
    if (cell.ownerId == null || cell.ownerId == player.id) return;
    if (cell.houses < 1 || cell.isMortgaged) return;
    if (state.blackoutGroupsThisRound.contains(cell.colorGroup.name)) return;
    if (Nightfall.cellSuppressed(state, cellIndex)) return;
    final cost = Nightfall.blackoutCost(cell.colorGroup);
    if (!RulesEngine.canAfford(player, cost)) return;
    final hacker = player.copyWith(
      balance: player.balance - cost,
      blackoutUsedThisTurn: true,
    );
    state = state.copyWith(
      players: _replacePlayer(hacker),
      suppressedCells: [...state.suppressedCells, cellIndex],
      suppressedBy: [...state.suppressedBy, player.id],
      blackoutGroupsThisRound: [
        ...state.blackoutGroupsThisRound,
        cell.colorGroup.name,
      ],
      log: _append(
        t.blackedOut(hacker.name, cell.name, GameRules.credits(cost)),
      ),
    );
    _hostSync();
  }

  /// Sell one house on [cellIndex]; returns cash raised.
  int sellHouse(int cellIndex) {
    final cell = state.cellAt(cellIndex);
    if (cell is! PropertyCell || cell.houses <= 0 || cell.ownerId == null) {
      return 0;
    }
    final player = state.players.firstWhere((p) => p.id == cell.ownerId);
    if (Nightfall.rackSellBlock(state: state, cell: cell, player: player) !=
        null) {
      return 0;
    }

    final refund = Nightfall.nodeRefund(cell.colorGroup, cell.houses);
    final sellingHotel = cell.houses >= 5;
    final board = [...state.board];
    board[cellIndex] = cell.copyWith(houses: cell.houses - 1);

    state = state.copyWith(
      board: board,
      players: _replacePlayer(
        player.copyWith(balance: player.balance + refund),
      ),
      housesInBank: sellingHotel
          ? state.housesInBank - 4
          : (state.housesInBank + 1).clamp(0, GameRules.housesInSupply),
      hotelsInBank: sellingHotel
          ? (state.hotelsInBank + 1).clamp(0, GameRules.hotelsInSupply)
          : state.hotelsInBank,
      log: _append(
        t.soldNode(player.name, cell.name, GameRules.credits(refund)),
      ),
    );
    return refund;
  }

  /// Executes AI liquidation queue until [playerId] can cover [amountNeeded].
  bool raiseFunds(String playerId, int amountNeeded) {
    var player = state.players.firstWhere((p) => p.id == playerId);
    if (player.balance >= amountNeeded) return true;

    final steps = AiDecisionMatrix.liquidationQueue(
      state: state,
      ai: player,
      amountNeeded: amountNeeded,
    );

    for (final step in steps) {
      player = state.players.firstWhere((p) => p.id == playerId);
      if (player.balance >= amountNeeded) return true;

      switch (step) {
        case MortgageStep(:final cellIndex):
          mortgageProperty(cellIndex);
        case SellHouseStep(:final cellIndex):
          sellHouse(cellIndex);
      }
    }

    player = state.players.firstWhere((p) => p.id == playerId);
    return player.balance >= amountNeeded;
  }

  void restart({List<PlayerRosterEntry>? roster}) {
    if (isOnline && !isHost) return;
    _ai.cancel();
    state = GameFactory.newGame(roster: roster ?? GameFactory.defaultRoster);
    _localizeBootLog();
    _pokeAi();
    _hostSync();
  }

  /// Bind Supabase Realtime for peer-host multiplayer (call from lobby).
  void bindOnline({
    required String localPlayerId,
    required SupabaseRealtimeService realtime,
  }) {
    detachOnline();
    _online = OnlineSession(localPlayerId: localPlayerId, realtime: realtime);
    _lastKnownHostId = realtime.hostPlayerId;
    _actionSub = realtime.onActionReceived.listen(_onRemoteAction);
    _syncSub = realtime.onStateSyncReceived.listen(_applyStateSync);
    _presenceSub = realtime.onPresenceChanged.listen(_onPresenceSync);
    _leaveSub = realtime.onPresenceLeave.listen((event) {
      _onPresenceLeave(event.$1, event.$2);
    });
  }

  /// Host seeds a match from lobby presence (preserves player IDs).
  void bootstrapOnlineRoster(List<PresenceMember> members) {
    if (!isOnline || !isHost) return;
    final capped = members.take(GameRules.maxPlayers).toList();
    if (capped.length < GameRules.minPlayers) return;

    final players = [
      for (final m in capped)
        Player(
          id: m.playerId,
          name: m.name,
          tokenColor: TokenColor.values.firstWhere(
            (c) => c.name == m.tokenColor,
            orElse: () => TokenColor.blue,
          ),
          balance: GameRules.startingMoney,
          isAi: false,
        ),
    ];

    _ai.cancel();
    _auction = null;
    _decks = DeckManager.shuffled(_random);
    state = GameFactory.fromPlayers(players);
    _localizeBootLog();
    _hostSync();
    _pokeAi();
  }

  void detachOnline() {
    for (final t in _disconnectTimers.values) {
      t.cancel();
    }
    _disconnectTimers.clear();
    _actionSub?.cancel();
    _syncSub?.cancel();
    _presenceSub?.cancel();
    _leaveSub?.cancel();
    _actionSub = null;
    _syncSub = null;
    _presenceSub = null;
    _leaveSub = null;
    _online = null;
    _lastKnownHostId = null;
  }

  // —— Dev / QA debug hooks (kDebugMode UI only) ————————————————

  /// Instantly place the active operative on [index] and resolve the cell.
  void debugTeleport(int index) {
    final i = index.clamp(0, GameRules.boardSize - 1);
    final jailed = i == GameRules.jailIndex
        ? _active.copyWith(position: i)
        : _active.copyWith(position: i, inJail: false, jailTurns: 0);
    state = state.copyWith(
      players: _replacePlayer(jailed),
      phase: TurnPhase.cellAction,
      moveStepsLeft: 0,
      moveFromIndex: null,
      pendingAction: const PendingAction.none(),
      log: _append('[DEV] Teleport → $i (${state.cellAt(i).name}).'),
    );
    _resolveCell();
    _pokeAi();
  }

  void debugAdjustCredits(int delta) {
    final next = (_active.balance + delta).clamp(0, 999999);
    state = state.copyWith(
      players: _replacePlayer(_active.copyWith(balance: next)),
      log: _append(
        '[DEV] ${_active.name} credits ${delta >= 0 ? '+' : ''}$delta'
        ' → ${GameRules.credits(next)}.',
      ),
    );
  }

  /// Force an AI operative to become active and take a turn.
  void debugForceAiTurn() {
    final idx = state.players.indexWhere((p) => p.isAi && !p.isBankrupt);
    if (idx < 0) {
      state = state.copyWith(log: _append('[DEV] No AI operative online.'));
      return;
    }
    state = state.copyWith(
      activePlayerIndex: idx,
      phase: TurnPhase.waitingForRoll,
      consecutiveDoubles: 0,
      lastRoll: null,
      moveStepsLeft: 0,
      pendingAction: const PendingAction.none(),
      log: _append('[DEV] Force AI turn → ${state.players[idx].name}.'),
    );
    _ai.scheduleIfNeeded();
  }

  /// Pull a lore card without landing on the cell.
  void debugDrawCard({required bool dataBreach}) {
    state = state.copyWith(
      log: _append(
        '[DEV] Forced deck pull: ${dataBreach ? 'DATA BREACH' : 'CORPO BOUNTY'}',
      ),
      phase: TurnPhase.cellAction,
    );
    _drawDeckCard(
      dataBreach ? CardDeckKind.dataBreach : CardDeckKind.corpoBounty,
    );
    _pokeAi();
  }

  Future<void> restoreSession(GameState saved, DeckManager decks) async {
    _ai.cancel();
    _decks = decks;
    _auction = null;
    state = saved;
    _pokeAi();
  }

  Future<void> persistNow() async {
    if (!autosave) return;
    await _storage.save(state: state, decks: _decks);
  }

  /// Test helper: apply an exact dice pair then finish movement.
  void debugRollExact(int die1, int die2) {
    if (state.phase != TurnPhase.waitingForRoll || state.isGameOver) return;
    if (state.pendingAction is! PendingNone) return;

    final roll = DiceRoll(die1: die1, die2: die2);
    state = state.copyWith(phase: TurnPhase.rolling, lastRoll: roll);

    if (_active.inJail) {
      _resolveJailRoll(roll);
      return;
    }

    final doubles = roll.isDoubles ? state.consecutiveDoubles + 1 : 0;
    if (doubles >= GameRules.doublesForJail) {
      _sendToJail(
        reason: t.tripleDoubles(_active.name),
        resetDoubles: true,
      );
      return;
    }

    state = state.copyWith(consecutiveDoubles: doubles);
    _beginMove(steps: roll.total);
    finishMove();
  }

  @override
  void dispose() {
    detachOnline();
    _ai.cancel();
    super.dispose();
  }

  // —— Online peer-host ——————————————————————————————————————————

  bool _clientSend(
    NetworkActionType type, [
    Map<String, dynamic> payload = const {},
  ]) {
    if (!isOnline || isHost || _applyingRemote) return false;
    final id = localPlayerId;
    if (id == null) return true;
    unawaited(
      () async {
        try {
          await _online!.realtime.sendAction(
            NetworkAction(type: type, senderId: id, payload: payload),
          );
        } catch (e, st) {
          assert(() {
            // ignore: avoid_print
            print('client sendAction failed: $e\n$st');
            return true;
          }());
        }
      }(),
    );
    return true;
  }

  bool _allowActivePlayerAction() {
    if (!isOnline || _applyingRemote) return true;
    if (isHost && state.activePlayer.isAi) return true;
    return state.activePlayer.id == localPlayerId;
  }

  bool _canManageEmpire() {
    if (state.isGameOver) return false;
    if (state.pendingAction is! PendingNone) return false;
    if (state.phase != TurnPhase.waitingForRoll &&
        state.phase != TurnPhase.canEndTurn) {
      return false;
    }
    return _allowActivePlayerAction();
  }

  bool _allowAuctionActor() {
    if (!isOnline || _applyingRemote) return true;
    final auction = _auction;
    if (auction == null) return false;
    if (isHost) {
      final bidder = state.players
          .where((p) => p.id == auction.currentBidderId)
          .firstOrNull;
      if (bidder?.isAi == true) return true;
    }
    return auction.currentBidderId == localPlayerId;
  }

  bool _allowTradeResponder() {
    if (!isOnline || _applyingRemote) return true;
    final pending = state.pendingAction;
    if (pending is! PendingTradeOffer) return false;
    if (isHost) {
      final to = state.players
          .where((p) => p.id == pending.toPlayerId)
          .firstOrNull;
      if (to?.isAi == true) return true;
    }
    return pending.toPlayerId == localPlayerId;
  }

  void _hostSync() {
    if (!isOnline || !isHost || _applyingRemote) return;
    unawaited(_broadcastSync());
  }

  Future<void> _broadcastSync() async {
    final online = _online;
    if (online == null || !online.isHost) return;
    try {
      await online.realtime.sendStateSync({
        'game': state.toJson(),
        'decks': _decks.toJson(),
        'auction': _auction?.toJson(),
      });
    } catch (e, st) {
      assert(() {
        // ignore: avoid_print
        print('host STATE_SYNC failed: $e\n$st');
        return true;
      }());
    }
  }

  void _applyStateSync(Map<String, dynamic> envelope) {
    if (isHost) return; // host is authoritative
    try {
      final gameRaw = envelope['game'] ?? envelope['state'] ?? envelope;
      if (gameRaw is! Map) return;
      final next = GameState.fromJson(Map<String, dynamic>.from(gameRaw));
      final decksRaw = envelope['decks'];
      if (decksRaw is Map) {
        _decks = DeckManager.fromJson(
          Map<String, dynamic>.from(decksRaw),
          _random,
        );
      }
      final auctionRaw = envelope['auction'];
      _auction = auctionRaw is Map
          ? AuctionState.fromJson(Map<String, dynamic>.from(auctionRaw))
          : null;
      _ai.cancel();
      state = next;
    } catch (e, st) {
      assert(() {
        // ignore: avoid_print
        print('STATE_SYNC apply failed: $e\n$st');
        return true;
      }());
    }
  }

  bool _senderInSession(String senderId) {
    if (senderId.isEmpty) return false;
    final online = _online;
    if (online == null) return false;
    if (online.realtime.members.any((m) => m.playerId == senderId)) {
      return true;
    }
    return state.players.any((p) => p.id == senderId);
  }

  bool _isActivePlayerAction(NetworkActionType type) {
    return type == NetworkActionType.roll ||
        type == NetworkActionType.buy ||
        type == NetworkActionType.declineBuy ||
        type == NetworkActionType.endTurn ||
        type == NetworkActionType.dismissNotice ||
        type == NetworkActionType.payJailFine ||
        type == NetworkActionType.buildHouse ||
        type == NetworkActionType.sellHouse ||
        type == NetworkActionType.mortgage ||
        type == NetworkActionType.unmortgage ||
        type == NetworkActionType.useJailCard ||
        type == NetworkActionType.overdraft ||
        type == NetworkActionType.buyout ||
        type == NetworkActionType.blackout ||
        type == NetworkActionType.requestClaim ||
        type == NetworkActionType.acceptClaim ||
        type == NetworkActionType.declineClaim;
  }

  void _onRemoteAction(NetworkAction action) {
    if (!isHost) return;
    if (action.senderId == localPlayerId) return;
    if (!_senderInSession(action.senderId)) return;

    // Role checks before mutation — never trust client payload blindly.
    if (_isActivePlayerAction(action.type) &&
        action.senderId != state.activePlayer.id) {
      return;
    }
    if (action.type == NetworkActionType.tradeAccept ||
        action.type == NetworkActionType.tradeDecline) {
      final pending = state.pendingAction;
      if (pending is! PendingTradeOffer ||
          action.senderId != pending.toPlayerId) {
        return;
      }
    }
    if (action.type == NetworkActionType.auctionBid ||
        action.type == NetworkActionType.auctionPass) {
      if (_auction == null || _auction!.currentBidderId != action.senderId) {
        return;
      }
    }
    if (action.type == NetworkActionType.auctionBid) {
      final amount = (action.payload['amount'] as num?)?.toInt() ?? 0;
      if (amount <= _auction!.highestBid) return;
    }
    if (action.type == NetworkActionType.trade) {
      try {
        final offer = TradeOffer.fromJson(action.payload);
        if (offer.fromPlayerId != action.senderId) return;
      } catch (_) {
        return;
      }
    }

    _applyingRemote = true;
    try {
      switch (action.type) {
        case NetworkActionType.roll:
          rollDice();
        case NetworkActionType.buy:
          acceptBuy();
        case NetworkActionType.declineBuy:
          declineBuy();
        case NetworkActionType.endTurn:
          endTurn();
        case NetworkActionType.dismissNotice:
          dismissNotice();
        case NetworkActionType.payJailFine:
          payJailFine();
        case NetworkActionType.auctionBid:
          auctionBid((action.payload['amount'] as num?)?.toInt() ?? 0);
        case NetworkActionType.auctionPass:
          auctionPass();
        case NetworkActionType.tradeAccept:
          acceptTrade();
        case NetworkActionType.tradeDecline:
          declineTrade();
        case NetworkActionType.trade:
          proposeTrade(TradeOffer.fromJson(action.payload));
        case NetworkActionType.buildHouse:
          buildHouse((action.payload['cellIndex'] as num?)?.toInt() ?? -1);
        case NetworkActionType.sellHouse:
          sellNode((action.payload['cellIndex'] as num?)?.toInt() ?? -1);
        case NetworkActionType.mortgage:
          pledgeProperty((action.payload['cellIndex'] as num?)?.toInt() ?? -1);
        case NetworkActionType.unmortgage:
          unmortgageProperty(
            (action.payload['cellIndex'] as num?)?.toInt() ?? -1,
          );
        case NetworkActionType.useJailCard:
          useJailCard();
        case NetworkActionType.overdraft:
          drawOverdraft();
        case NetworkActionType.buyout:
          buyout((action.payload['cellIndex'] as num?)?.toInt() ?? -1);
        case NetworkActionType.blackout:
          blackout((action.payload['cellIndex'] as num?)?.toInt() ?? -1);
        case NetworkActionType.requestClaim:
          requestClaim();
        case NetworkActionType.acceptClaim:
          acceptClaim((action.payload['cellIndex'] as num?)?.toInt() ?? -1);
        case NetworkActionType.declineClaim:
          declineClaim();
        case NetworkActionType.kickToAi:
        case NetworkActionType.ready:
        case NetworkActionType.startGame:
          break;
      }
    } catch (e, st) {
      assert(() {
        // ignore: avoid_print
        print('remote action rejected/failed: $e\n$st');
        return true;
      }());
    } finally {
      _applyingRemote = false;
    }
    unawaited(_broadcastSync());
  }

  void _onPresenceSync(List<PresenceMember> members) {
    final onlineIds = members.map((m) => m.playerId).toSet();
    for (final id in onlineIds) {
      final timer = _disconnectTimers.remove(id);
      timer?.cancel();
      final roster = state.players.where((p) => p.id == id).firstOrNull;
      final waitingForThem = state.isWaitingForReconnection &&
          roster != null &&
          roster.name == state.disconnectedPlayerName;
      if (timer != null || waitingForThem || (roster?.isAi ?? false)) {
        _reclaimHumanSeat(id);
      }
    }
    _maybeHandleHostMigration();
    if (isOnline && isHost) {
      _pokeAi();
    }
  }

  void _maybeHandleHostMigration() {
    if (!isOnline) return;
    final online = _online;
    if (online == null) return;

    final newHostId = online.realtime.hostPlayerId;
    final prevHostId = _lastKnownHostId;
    if (newHostId == prevHostId) return;
    _lastKnownHostId = newHostId;

    // Newly elected host immediately freezes board state for all peers.
    if (isHost &&
        newHostId == localPlayerId &&
        prevHostId != null &&
        prevHostId != newHostId) {
      state = state.copyWith(
        log: _append(
          t.hostMigration(
            state.players
                    .where((p) => p.id == localPlayerId)
                    .firstOrNull
                    ?.name ??
                'HOST',
          ),
        ),
      );
      unawaited(_broadcastSync());
      _pokeAi();
    }
  }

  void _onPresenceLeave(
    PresenceMember left,
    List<PresenceMember> remaining,
  ) {
    _maybeHandleHostMigration();
    if (!isOnline || !isHost) return;

    final id = left.playerId;
    final rosterIdx = state.players.indexWhere((p) => p.id == id);
    if (rosterIdx < 0) return;
    final player = state.players[rosterIdx];
    if (player.isBankrupt) return;

    _disconnectTimers[id]?.cancel();
    final deadline =
        DateTime.now().add(disconnectAiGrace).millisecondsSinceEpoch;
    state = state.copyWith(
      isWaitingForReconnection: true,
      disconnectedPlayerName: player.name,
      reconnectDeadlineMs: deadline,
      log: _append(
        t.signalLostLog(player.name, disconnectAiGrace.inSeconds),
      ),
    );
    unawaited(_broadcastSync());

    _disconnectTimers[id] = Timer(disconnectAiGrace, () {
      _disconnectTimers.remove(id);
      _convertDisconnectedToAi(id);
    });
  }

  void _reclaimHumanSeat(String playerId) {
    if (!isHost) return;
    final idx = state.players.indexWhere((p) => p.id == playerId);
    if (idx < 0) return;
    final player = state.players[idx];
    if (player.isBankrupt) return;

    final players = [...state.players];
    var changed = false;
    if (player.isAi) {
      players[idx] = player.copyWith(isAi: false);
      changed = true;
    }

    final clearingWait = state.isWaitingForReconnection &&
        state.disconnectedPlayerName == player.name;

    if (!changed && !clearingWait) return;

    state = state.copyWith(
      players: players,
      isWaitingForReconnection:
          clearingWait ? false : state.isWaitingForReconnection,
      disconnectedPlayerName:
          clearingWait ? null : state.disconnectedPlayerName,
      reconnectDeadlineMs:
          clearingWait ? null : state.reconnectDeadlineMs,
      log: _append(t.signalRestored(player.name)),
    );
    unawaited(_broadcastSync());
  }

  void _convertDisconnectedToAi(String playerId) {
    if (!isHost) return;
    final idx = state.players.indexWhere((p) => p.id == playerId);
    if (idx < 0) return;
    final player = state.players[idx];
    if (player.isBankrupt) return;

    final bot = player.copyWith(
      isAi: true,
      aiProfile: player.aiProfile ?? AiProfile.strategist,
    );
    final players = [...state.players];
    players[idx] = bot;
    final clearBanner = state.disconnectedPlayerName == player.name;
    state = state.copyWith(
      players: players,
      isWaitingForReconnection:
          clearBanner ? false : state.isWaitingForReconnection,
      disconnectedPlayerName:
          clearBanner ? null : state.disconnectedPlayerName,
      reconnectDeadlineMs: clearBanner ? null : state.reconnectDeadlineMs,
      log: _append(
        t.aiTakeover(
          player.name,
          disconnectAiGrace.inSeconds,
          bot.aiProfile?.name ?? 'bot',
        ),
      ),
    );
    unawaited(_broadcastSync());
    _pokeAi();
  }

  // —— Internals ————————————————————————————————————————————————

  void _beginMove({required int steps}) {
    state = state.copyWith(
      phase: TurnPhase.movingToken,
      moveFromIndex: _active.position,
      moveStepsLeft: steps,
      log: _append(
        t.rolled(
          _active.name,
          state.lastRoll!.die1,
          state.lastRoll!.die2,
          state.lastRoll!.total,
          state.lastRoll!.isDoubles,
        ),
      ),
    );
  }

  void _resolveJailRoll(DiceRoll roll) {
    if (roll.isDoubles) {
      final freed = _active.copyWith(inJail: false, jailTurns: 0);
      state = state.copyWith(
        players: _replacePlayer(freed),
        consecutiveDoubles: 0,
        log: _append(t.jailDoubles(freed.name)),
      );
      _beginMove(steps: roll.total);
      return;
    }

    final turns = _active.jailTurns + 1;
    if (turns >= GameRules.maxJailTurns) {
      if (!RulesEngine.canAfford(_active, GameRules.jailFine)) {
        raiseFunds(_active.id, GameRules.jailFine);
      }
      if (!RulesEngine.canAfford(_active, GameRules.jailFine)) {
        _declareBankruptcy(_active, creditorId: null);
        return;
      }
      final freed = _active.copyWith(
        inJail: false,
        jailTurns: 0,
        balance: _active.balance - GameRules.jailFine,
      );
      state = state.copyWith(
        players: _replacePlayer(freed),
        consecutiveDoubles: 0,
        log: _append(
          t.jailFineForced(
            freed.name,
            GameRules.credits(GameRules.jailFine),
            GameRules.maxJailTurns,
          ),
        ),
      );
      _beginMove(steps: roll.total);
      return;
    }

    state = state.copyWith(
      players: _replacePlayer(_active.copyWith(jailTurns: turns)),
      consecutiveDoubles: 0,
      phase: TurnPhase.canEndTurn,
      log: _append(
        t.staysJailed(_active.name, turns, GameRules.maxJailTurns),
      ),
    );
  }

  void _resolveCell() {
    if (state.nextRentMultiplier != 1 || state.nextUtilityFlatTen) {
      final cell = state.cellAt(_active.position);
      final keepRail = cell is RailroadCell;
      final keepUtil = cell is UtilityCell;
      if (!keepRail && !keepUtil) {
        state = state.copyWith(nextRentMultiplier: 1, nextUtilityFlatTen: false);
      }
    }
    final cell = state.cellAt(_active.position);

    switch (cell) {
      case SpecialCell(:final kind):
        _resolveSpecial(kind, cell.name);
      case TaxCell(:final amount, :final name):
        _payTax(amount, name);
      case PropertyCell() || RailroadCell() || UtilityCell():
        _resolveOwnable(cell);
    }
  }

  void _resolveSpecial(SpecialKind kind, String name) {
    switch (kind) {
      case SpecialKind.go:
      case SpecialKind.jail:
      case SpecialKind.freeParking:
        state = state.copyWith(
          log: _append(t.onCell(_active.name, name)),
        );
        _finishCellAction(autoPass: true);
      case SpecialKind.goToJail:
        _speak(_active, AiDialogueEvent.goToJail);
        _sendToJail(
          reason: t.hitDetention(_active.name),
          resetDoubles: true,
        );
      case SpecialKind.chance:
        _drawDeckCard(CardDeckKind.dataBreach);
      case SpecialKind.communityChest:
        _drawDeckCard(CardDeckKind.corpoBounty);
    }
  }

  void _drawDeckCard(CardDeckKind kind) {
    soundService.play(Sfx.card);
    final card = _decks.draw(kind);
    final result = CardResolver.apply(state, card);
    state = result.state;
    if (result.salaryGranted > 0) {
      _addSalaryToActive(result.salaryGranted);
      if (state.isGameOver || _active.isBankrupt) return;
    }
    if (card.effect == CardEffectType.eminentDomain) {
      _beginClaim(consumesBuyout: false);
      _pokeAi();
      return;
    }
    if (result.wentToJail) {
      _speak(_active, AiDialogueEvent.goToJail);
      return;
    }
    if (result.reresolveCell) {
      state = state.copyWith(
        log: _append(
          'Card move pending cell resolve at ${state.activePlayer.position}.',
        ),
      );
    }
  }

  void _resolveOwnable(BoardCell cell) {
    final rentMultiplier = cell is RailroadCell ? state.nextRentMultiplier : 1;
    final utilityFlatTen = cell is UtilityCell && state.nextUtilityFlatTen;
    if (state.nextRentMultiplier != 1 || state.nextUtilityFlatTen) {
      state = state.copyWith(nextRentMultiplier: 1, nextUtilityFlatTen: false);
    }

    final ownerId = cell.ownerIdOrNull;
    if (ownerId == null) {
      final price = cell.priceOrNull!;
      state = state.copyWith(
        phase: TurnPhase.cellAction,
        pendingAction: PendingAction.buyOffer(
          cellIndex: cell.index,
          propertyName: cell.name,
          price: price,
        ),
        log: _append(
          t.mayBuy(_active.name, cell.name, GameRules.credits(price)),
        ),
      );
      // AI buy decision is handled by AiService (with thinking delay).
      return;
    }

    if (ownerId == _active.id || cell.isMortgagedOrFalse) {
      _finishCellAction(autoPass: true);
      return;
    }

    final rent = RulesEngine.calculateRent(
      cell: cell,
      board: state.board,
      diceTotal: state.lastRoll?.total ?? 0,
      suppressed: Nightfall.cellSuppressed(state, cell.index),
      rentMultiplier: rentMultiplier,
      utilityFlatTen: utilityFlatTen,
    );
    if (rent <= 0) {
      _finishCellAction(autoPass: true);
      return;
    }

    final owner = state.players.firstWhere((p) => p.id == ownerId);
    if (RulesEngine.isBankruptAfter(_active, rent)) {
      raiseFunds(_active.id, rent);
    }

    if (RulesEngine.isBankruptAfter(_active, rent)) {
      state = state.copyWith(
        pendingAction: PendingAction.rentNotice(
          payerName: _active.name,
          ownerName: owner.name,
          propertyName: cell.name,
          amount: rent,
        ),
      );
      _declareBankruptcy(_active, creditorId: ownerId);
      return;
    }

    final payer = _active.copyWith(balance: _active.balance - rent);
    final paidOwner = owner.copyWith(balance: owner.balance + rent);
    soundService.play(Sfx.rent);
    _speak(
      paidOwner,
      AiDialogueEvent.collectRent,
      otherName: payer.name,
      amount: rent,
    );
    state = state.copyWith(
      players: _replacePlayers([payer, paidOwner]),
      phase: TurnPhase.cellAction,
      pendingAction: PendingAction.rentNotice(
        payerName: payer.name,
        ownerName: paidOwner.name,
        propertyName: cell.name,
        amount: rent,
      ),
      log: _append(
        t.paidRent(
          payer.name,
          GameRules.credits(rent),
          paidOwner.name,
          cell.name,
        ),
      ),
    );
  }

  void _payTax(int amount, String name) {
    if (RulesEngine.isBankruptAfter(_active, amount)) {
      raiseFunds(_active.id, amount);
    }
    if (RulesEngine.isBankruptAfter(_active, amount)) {
      state = state.copyWith(
        pendingAction: PendingAction.taxNotice(
          playerName: _active.name,
          taxName: name,
          amount: amount,
        ),
      );
      _declareBankruptcy(_active, creditorId: null);
      return;
    }
    final p = _active.copyWith(balance: _active.balance - amount);
    state = state.copyWith(
      players: _replacePlayer(p),
      phase: TurnPhase.cellAction,
      pendingAction: PendingAction.taxNotice(
        playerName: p.name,
        taxName: name,
        amount: amount,
      ),
      log: _append(t.paidTax(p.name, name, GameRules.credits(amount))),
    );
  }

  void _purchase(int cellIndex) {
    final cell = state.cellAt(cellIndex);
    final price = cell.priceOrNull!;
    if (!RulesEngine.canAfford(_active, price)) {
      state = state.copyWith(
        log: _append(t.cannotAfford(_active.name, cell.name)),
      );
      return;
    }

    final buyer = _active.copyWith(
      balance: _active.balance - price,
      propertyIndexes: [..._active.propertyIndexes, cellIndex],
    );

    final BoardCell owned = switch (cell) {
      PropertyCell c => c.copyWith(ownerId: buyer.id),
      RailroadCell c => c.copyWith(ownerId: buyer.id),
      UtilityCell c => c.copyWith(ownerId: buyer.id),
      _ => cell,
    };

    final board = [...state.board];
    board[cellIndex] = owned;

    soundService.play(Sfx.buy);
    state = state.copyWith(
      board: board,
      players: _replacePlayer(buyer),
      log: _append(
        t.acquired(buyer.name, cell.name, GameRules.credits(price)),
      ),
    );
    if (cell is PropertyCell &&
        RulesEngine.ownsFullColorGroup(
          board: board,
          ownerId: buyer.id,
          group: cell.colorGroup,
        )) {
      _speak(
        buyer,
        AiDialogueEvent.monopolyBuy,
        propertyName: cell.colorGroup.districtName,
      );
    }
  }

  void _sendToJail({
    required bool resetDoubles,
    String? reason,
    PendingAction pending = const PendingAction.none(),
  }) {
    final jailed = _active.copyWith(
      position: GameRules.jailIndex,
      inJail: true,
      jailTurns: 0,
    );
    final phase =
        pending is PendingNone ? TurnPhase.canEndTurn : TurnPhase.cellAction;
    state = state.copyWith(
      players: _replacePlayer(jailed),
      phase: phase,
      consecutiveDoubles: resetDoubles ? 0 : state.consecutiveDoubles,
      moveStepsLeft: 0,
      moveFromIndex: null,
      pendingAction: pending,
      log: reason == null ? state.log : _append(reason),
    );
  }

  void _finishCellAction({bool autoPass = false}) {
    state = state.copyWith(
      phase: TurnPhase.canEndTurn,
      pendingAction: const PendingAction.none(),
    );
    if (autoPass && !_active.isAi && !state.isGameOver) {
      endTurn();
    }
  }

  void _clearPendingAndContinue() {
    if (state.isGameOver) return;
    state = state.copyWith(
      pendingAction: const PendingAction.none(),
      phase: TurnPhase.canEndTurn,
    );
    _pokeAi();
  }

  void _beginAuction(int cellIndex, String propertyName) {
    _auction = AuctionManager.start(
      cellIndex: cellIndex,
      propertyName: propertyName,
      livingPlayers: state.livingPlayers,
    );
    _publishAuction();
    _pokeAi();
  }

  void _publishAuction() {
    final a = _auction;
    if (a == null) return;
    state = state.copyWith(
      phase: TurnPhase.cellAction,
      pendingAction: PendingAction.auction(
        cellIndex: a.cellIndex,
        propertyName: a.propertyName,
        highestBid: a.highestBid,
        highestBidderId: a.highestBidderId,
        currentBidderId: a.currentBidderId,
        participantIds: a.participantIds,
        passedIds: a.passedIds.toList(),
      ),
    );
  }

  void _afterAuctionAction() {
    final a = _auction;
    if (a == null) return;
    if (a.isFinished) {
      _settleAuction();
      return;
    }
    _publishAuction();
    _pokeAi();
  }

  void _settleAuction() {
    final a = _auction;
    _auction = null;
    if (a == null) return;

    final winnerId = a.highestBidderId;
    if (winnerId == null || a.highestBid <= 0) {
      state = state.copyWith(
        pendingAction: const PendingAction.none(),
        phase: TurnPhase.canEndTurn,
        log: _append(t.pick(
          'Auction closed — no bids. Asset remains unclaimed.',
          'Аукціон закрито — ставок немає. Актив лишається вільним.',
        )),
      );
      _pokeAi();
      return;
    }

    final winner = state.players.firstWhere((p) => p.id == winnerId);
    if (!RulesEngine.canAfford(winner, a.highestBid)) {
      state = state.copyWith(
        pendingAction: const PendingAction.none(),
        phase: TurnPhase.canEndTurn,
        log: _append(t.pick(
          'Auction winner insolvent — voided.',
          'Переможець аукціону неплатоспроможний — угоду скасовано.',
        )),
      );
      _pokeAi();
      return;
    }

    // Temporarily treat winner as purchaser via active swap of purchase helper.
    final cell = state.cellAt(a.cellIndex);
    final paid = winner.copyWith(
      balance: winner.balance - a.highestBid,
      propertyIndexes: [...winner.propertyIndexes, a.cellIndex],
    );
    final BoardCell owned = switch (cell) {
      PropertyCell c => c.copyWith(ownerId: paid.id),
      RailroadCell c => c.copyWith(ownerId: paid.id),
      UtilityCell c => c.copyWith(ownerId: paid.id),
      _ => cell,
    };
    final board = [...state.board]..[a.cellIndex] = owned;
    _speak(
      paid,
      AiDialogueEvent.winAuction,
      propertyName: a.propertyName,
      amount: a.highestBid,
    );
    soundService.play(Sfx.buy);
    state = state.copyWith(
      board: board,
      players: _replacePlayer(paid),
      pendingAction: const PendingAction.none(),
      phase: TurnPhase.canEndTurn,
      log: _append(
        t.winsAuction(
          paid.name,
          a.propertyName,
          GameRules.credits(a.highestBid),
        ),
      ),
    );
    _pokeAi();
  }

  void _speak(
    Player speaker,
    AiDialogueEvent event, {
    String? otherName,
    int? amount,
    String? propertyName,
  }) {
    final line = AiDialogueService.lineFor(
      speaker: speaker,
      event: event,
      otherName: otherName,
      amount: amount,
      propertyName: propertyName,
      strings: t,
    );
    if (line == null) return;
    state = state.copyWith(
      aiDialogue: line,
      aiDialogueSpeakerId: speaker.id,
    );
  }

  Future<void> _autosaveIfNeeded() async {
    if (!autosave) return;
    if (state.phase != TurnPhase.waitingForRoll) return;
    await _storage.save(state: state, decks: _decks);
  }

  void _addSalaryToActive(int amount) {
    if (amount <= 0) return;
    final paid = _active.copyWith(balance: _active.balance + amount);
    state = state.copyWith(
      players: _replacePlayer(paid),
      log: _append(
        t.collectsReset(paid.name, GameRules.credits(amount)),
      ),
    );
    _skimOverdraftOnActive();
  }

  void _skimOverdraftOnActive() {
    var player = _active;
    if (player.overdraftInstallmentsLeft <= 0 || player.overdraftRemaining <= 0) {
      return;
    }
    final left = player.overdraftInstallmentsLeft;
    final due = left <= 1 ? player.overdraftRemaining : player.overdraftRemaining ~/ left;
    if (player.balance >= due) {
      player = player.copyWith(
        balance: player.balance - due,
        overdraftRemaining: player.overdraftRemaining - due,
        overdraftInstallmentsLeft: left - 1,
      );
      state = state.copyWith(
        players: _replacePlayer(player),
        log: _append(
          t.paysSyndicate(player.name, GameRules.credits(due)),
        ),
      );
      return;
    }
    if (left > 1) {
      final paid = player.balance;
      player = player.copyWith(
        balance: 0,
        overdraftRemaining: player.overdraftRemaining - paid,
        overdraftInstallmentsLeft: 1,
      );
      state = state.copyWith(
        players: _replacePlayer(player),
        log: _append(
          t.pick(
            '${player.name} puts ${GameRules.credits(paid)} toward the syndicate. '
            'The balance rolls to the next reset.',
            '${player.name} віддає ${GameRules.credits(paid)} синдикату. '
            'Решта переноситься на наступне коло.',
          ),
        ),
      );
      return;
    }
    final paid = player.balance;
    player = player.copyWith(
      balance: 0,
      overdraftRemaining: player.overdraftRemaining - paid,
      overdraftInstallmentsLeft: 0,
    );
    state = state.copyWith(players: _replacePlayer(player));
    final seized = _seizeUnimprovedAsset(player.id);
    if (seized != null) {
      final cleared = state.players
          .firstWhere((p) => p.id == player.id)
          .copyWith(overdraftRemaining: 0);
      state = state.copyWith(
        players: _replacePlayer(cleared),
        log: _append(
          t.seizedDebt(seized, player.name),
        ),
      );
      return;
    }
    _declareBankruptcy(
      state.players.firstWhere((p) => p.id == player.id),
      creditorId: null,
    );
  }

  String? _seizeUnimprovedAsset(String playerId) {
    final player = state.players.firstWhere((p) => p.id == playerId);
    BoardCell? best;
    var bestScore = -1;
    for (final index in player.propertyIndexes) {
      final cell = state.cellAt(index);
      if (cell is PropertyCell && cell.houses > 0) continue;
      if (!cell.isOwnable) continue;
      var score = cell.priceOrNull ?? 0;
      if (cell is PropertyCell) {
        final owned = state.board.whereType<PropertyCell>().where(
              (c) => c.colorGroup == cell.colorGroup && c.ownerId == playerId,
            );
        score += owned.length * 1000;
      }
      if (score > bestScore) {
        bestScore = score;
        best = cell;
      }
    }
    if (best == null) return null;
    final board = [...state.board];
    board[best.index] = switch (best) {
      PropertyCell c => c.copyWith(ownerId: null, isMortgaged: false, houses: 0),
      RailroadCell c => c.copyWith(ownerId: null, isMortgaged: false),
      UtilityCell c => c.copyWith(ownerId: null, isMortgaged: false),
      _ => best,
    };
    final stripped = player.copyWith(
      propertyIndexes: [
        for (final i in player.propertyIndexes)
          if (i != best.index) i,
      ],
    );
    state = state.copyWith(board: board, players: _replacePlayer(stripped));
    return best.name;
  }

  void _beginClaim({required bool consumesBuyout}) {
    if (consumesBuyout && _active.buyoutUsed) {
      state = state.copyWith(
        log: _append(t.alreadyClaimed(_active.name)),
      );
      return;
    }
    final targets = Nightfall.claimTargets(state, _active);
    if (targets.isEmpty) {
      if (state.pendingAction is PendingCardNotice) return;
      state = state.copyWith(
        log: _append(t.noClaimTarget(_active.name)),
      );
      return;
    }
    state = state.copyWith(
      phase: TurnPhase.cellAction,
      pendingAction: PendingAction.claimOffer(
        cellIndexes: targets,
        consumesBuyout: consumesBuyout,
      ),
      log: _append(t.opensClaim(_active.name)),
    );
  }

  bool _executeBuyout(int cellIndex, {required bool consumeCharge}) {
    final buyer = _active;
    final cell = state.cellAt(cellIndex);
    if (cell is! PropertyCell) return false;
    if (!Nightfall.claimTargets(state, buyer).contains(cellIndex)) return false;
    final price = Nightfall.buyoutPrice(cell.price);
    if (!RulesEngine.canAfford(buyer, price)) return false;
    final owner = state.players.firstWhere((p) => p.id == cell.ownerId);
    final paidBuyer = buyer.copyWith(
      balance: buyer.balance - price,
      buyoutUsed: consumeCharge ? true : buyer.buyoutUsed,
      propertyIndexes: [...buyer.propertyIndexes, cellIndex],
    );
    final paidOwner = owner.copyWith(
      balance: owner.balance + price,
      propertyIndexes: [
        for (final i in owner.propertyIndexes)
          if (i != cellIndex) i,
      ],
    );
    final board = [...state.board];
    board[cellIndex] = cell.copyWith(ownerId: buyer.id);
    state = state.copyWith(
      board: board,
      players: _replacePlayers([paidBuyer, paidOwner]),
      log: _append(
        t.claimed(
          buyer.name,
          cell.name,
          owner.name,
          GameRules.credits(price),
        ),
      ),
    );
    _hostSync();
    return true;
  }

  void _declareBankruptcy(Player loser, {required String? creditorId}) {
    var board = [...state.board];
    var houses = state.housesInBank;
    var hotels = state.hotelsInBank;
    for (final idx in loser.propertyIndexes) {
      final cell = board[idx];
      if (cell is PropertyCell) {
        if (cell.houses >= 5) {
          hotels = (hotels + 1).clamp(0, GameRules.hotelsInSupply);
        } else {
          houses = (houses + cell.houses).clamp(0, GameRules.housesInSupply);
        }
      }
      board[idx] = switch (cell) {
        PropertyCell c => c.copyWith(
            ownerId: creditorId,
            houses: 0,
            isMortgaged: false,
          ),
        RailroadCell c => c.copyWith(
            ownerId: creditorId,
            isMortgaged: false,
          ),
        UtilityCell c => c.copyWith(
            ownerId: creditorId,
            isMortgaged: false,
          ),
        _ => cell,
      };
    }

    var players = [...state.players];
    final loserIndex = players.indexWhere((p) => p.id == loser.id);
    final current = players[loserIndex];
    players[loserIndex] = current.copyWith(
      isBankrupt: true,
      balance: 0,
      propertyIndexes: const [],
      inJail: false,
      overdraftRemaining: 0,
      overdraftInstallmentsLeft: 0,
    );

    if (creditorId != null) {
      final ci = players.indexWhere((p) => p.id == creditorId);
      final creditor = players[ci];
      players[ci] = creditor.copyWith(
        balance: creditor.balance + current.balance,
        propertyIndexes: [
          ...creditor.propertyIndexes,
          ...loser.propertyIndexes,
        ],
      );
    }

    final living = players.where((p) => !p.isBankrupt).toList();
    final count = state.bankruptcyCount + 1;
    soundService.play(Sfx.bankrupt);
    for (final p in players) {
      if (!p.isBankrupt && p.isAi) {
        _speak(p, AiDialogueEvent.opponentBankrupt, otherName: loser.name);
        break;
      }
    }
    state = state.copyWith(
      board: board,
      players: players,
      housesInBank: houses,
      hotelsInBank: hotels,
      bankruptcyCount: count,
      moveStepsLeft: 0,
      log: _append(
        t.liquidated(loser.name, count, GameRules.bankruptciesToEnd),
      ),
    );

    if (living.length <= 1) {
      _crownSoleSurvivor(living);
      return;
    }

    if (count >= GameRules.bankruptciesToEnd) {
      _finishByNetWorth(t.pick(
        'Second bankruptcy. Net worth closes the session.',
        'Друге банкрутство. Сесію закриває вартість.',
      ));
      return;
    }

    state = state.copyWith(
      pendingAction: const PendingAction.none(),
      phase: TurnPhase.canEndTurn,
      consecutiveDoubles: 0,
    );
    _advanceToNextPlayer();
  }

  void _crownSoleSurvivor(List<Player> living) {
    final winner = living.isEmpty ? null : living.first;
    final worth = winner == null ? 0 : Nightfall.netWorth(state, winner);
    state = state.copyWith(
      phase: TurnPhase.gameOver,
      winnerId: winner?.id,
      pendingAction: winner == null
          ? const PendingAction.none()
          : PendingAction.winner(
              playerId: winner.id,
              playerName: winner.name,
              netWorth: worth,
            ),
      log: winner == null
          ? state.log
          : _append(
              t.winnerLog(winner.name, GameRules.credits(worth)),
            ),
    );
  }

  void _finishByNetWorth(String reason) {
    final ranked = [...state.livingPlayers]..sort((a, b) {
        final byWorth = Nightfall.netWorth(state, b)
            .compareTo(Nightfall.netWorth(state, a));
        if (byWorth != 0) return byWorth;
        return b.balance.compareTo(a.balance);
      });
    if (ranked.isEmpty) {
      state = state.copyWith(
        phase: TurnPhase.gameOver,
        pendingAction: const PendingAction.none(),
        log: _append(reason),
      );
      return;
    }
    final winner = ranked.first;
    final worth = Nightfall.netWorth(state, winner);
    var log = _append(reason);
    for (final p in ranked) {
      log = [
        ...log,
        t.netLine(
          p.name,
          GameRules.credits(Nightfall.netWorth(state, p)),
        ),
      ];
    }
    state = state.copyWith(
      phase: TurnPhase.gameOver,
      winnerId: winner.id,
      pendingAction: PendingAction.winner(
        playerId: winner.id,
        playerName: winner.name,
        netWorth: worth,
      ),
      log: [
        ...log,
        t.winnerLog(winner.name, GameRules.credits(worth)),
      ],
    );
  }

  void _advanceToNextPlayer() {
    if (state.isGameOver) return;

    final n = state.players.length;
    final previous = state.activePlayerIndex;
    var idx = previous;
    for (var i = 0; i < n; i++) {
      idx = (idx + 1) % n;
      if (!state.players[idx].isBankrupt) break;
    }

    var round = state.round;
    var groups = state.blackoutGroupsThisRound;
    if (idx < previous) {
      round += 1;
      groups = const [];
    }
    if (round > GameRules.blitzRoundLimit) {
      _finishByNetWorth(
        t.blitzClosed(),
      );
      return;
    }

    final incomingId = state.players[idx].id;
    final keptCells = <int>[];
    final keptBy = <String>[];
    for (var i = 0; i < state.suppressedCells.length; i++) {
      final hacker = i < state.suppressedBy.length ? state.suppressedBy[i] : '';
      if (hacker == incomingId) continue;
      keptCells.add(state.suppressedCells[i]);
      keptBy.add(hacker);
    }
    final players = _replacePlayer(
      state.players[idx].copyWith(blackoutUsedThisTurn: false),
    );

    state = state.copyWith(
      players: players,
      activePlayerIndex: idx,
      round: round,
      blackoutGroupsThisRound: groups,
      suppressedCells: keptCells,
      suppressedBy: keptBy,
      phase: TurnPhase.waitingForRoll,
      consecutiveDoubles: 0,
      lastRoll: null,
      moveFromIndex: null,
      moveStepsLeft: 0,
      pendingAction: const PendingAction.none(),
      log: _append(
        t.roundBanner(round, GameRules.blitzRoundLimit, players[idx].name),
      ),
    );
    unawaited(_autosaveIfNeeded());
    _pokeAi();
  }

  List<String> _append(String line) => [...state.log, line];

  List<Player> _replacePlayer(Player player) {
    return [
      for (final p in state.players)
        if (p.id == player.id) player else p,
    ];
  }

  List<Player> _replacePlayers(List<Player> updates) {
    final byId = {for (final p in updates) p.id: p};
    return [
      for (final p in state.players) byId[p.id] ?? p,
    ];
  }
}
