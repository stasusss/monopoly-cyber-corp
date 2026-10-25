import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/audio/sound_service.dart';
import '../core/constants/game_factory.dart';
import '../core/constants/game_rules.dart';
import '../core/constants/street_colors.dart';
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
import 'rules_engine.dart';
import 'trade/auction_manager.dart';
import 'trade/trade_manager.dart';

final gameControllerProvider =
    StateNotifierProvider<GameController, GameState>((ref) {
  return GameController();
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
    this.enableAi = true,
    this.autosave = true,
  })  : _random = random ?? Random(),
        _decks = decks ?? DeckManager.shuffled(random ?? Random()),
        _storage = storage ?? GameStorage(),
        super(initial ?? GameFactory.newGame(roster: GameFactory.defaultRoster)) {
    _ai = AiService(this, random: _random);
    if (enableAi) {
      Future.microtask(_ai.scheduleIfNeeded);
    }
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
        reason: '${_active.name} викинув три дублі поспіль — у тюрму!',
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
    var balance = player.balance;
    final passedGo = nextPos == GameRules.goIndex;
    if (passedGo) {
      balance += GameRules.goSalary;
    }

    final updatedPlayer = player.copyWith(
      position: nextPos,
      balance: balance,
    );
    final stepsLeft = state.moveStepsLeft - 1;

    state = state.copyWith(
      players: _replacePlayer(updatedPlayer),
      moveStepsLeft: stepsLeft,
      log: passedGo
          ? _append(
              '${player.name} проходить Старт і отримує \$${GameRules.goSalary}.',
            )
          : state.log,
    );

    if (stepsLeft == 0) {
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
        '${_active.name} declines «${pending.propertyName}» → AUCTION.',
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
      log: _append('${bidder.name} bids ${GameRules.credits(amount)}.'),
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
    state = state.copyWith(log: _append('${bidder.name} passes auction.'));
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
      log: _append('Trade proposed.'),
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
      log: _append('Trade executed.'),
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
      log: _append('Trade declined.'),
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
        pending is PendingTradeOffer) {
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
            '${_active.name} не може сплатити штраф \$${GameRules.jailFine}.',
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
        '${freed.name} сплачує \$${GameRules.jailFine} і виходить з тюрми.',
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
        log: _append('${_active.name} ходить ще раз (дубль).'),
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
    if (!_allowActivePlayerAction()) return false;
    final cell = state.cellAt(cellIndex);
    if (cell is! PropertyCell || cell.ownerId != _active.id) return false;
    if (cell.isMortgaged || cell.houses >= 5) return false;
    if (!RulesEngine.ownsFullColorGroup(
      board: state.board,
      ownerId: _active.id,
      group: cell.colorGroup,
    )) {
      return false;
    }

    final group = state.board
        .whereType<PropertyCell>()
        .where((c) => c.colorGroup == cell.colorGroup && c.ownerId == _active.id);
    final minHouses =
        group.map((c) => c.houses).reduce((a, b) => a < b ? a : b);
    if (cell.houses > minHouses) return false;

    final cost = cell.colorGroup.houseCost;
    if (!RulesEngine.canAfford(_active, cost)) return false;

    final board = [...state.board];
    board[cellIndex] = cell.copyWith(houses: cell.houses + 1);
    final buyer = _active.copyWith(balance: _active.balance - cost);
    state = state.copyWith(
      board: board,
      players: _replacePlayer(buyer),
      log: _append(
        '${buyer.name} будує на «${cell.name}» '
        '(${cell.houses + 1}/5) за \$$cost.',
      ),
    );
    _hostSync();
    return true;
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
        '${player.name} закладає «${cell.name}» (+$mortgage\$).',
      ),
    );
    return mortgage;
  }

  /// Sell one house on [cellIndex]; returns cash raised.
  int sellHouse(int cellIndex) {
    final cell = state.cellAt(cellIndex);
    if (cell is! PropertyCell || cell.houses <= 0 || cell.ownerId == null) {
      return 0;
    }

    final group = state.board
        .whereType<PropertyCell>()
        .where((c) => c.colorGroup == cell.colorGroup && c.ownerId == cell.ownerId);
    final maxHouses =
        group.map((c) => c.houses).reduce((a, b) => a > b ? a : b);
    if (cell.houses < maxHouses) return 0; // even sell-down

    final refund = cell.colorGroup.houseCost ~/ 2;
    final player = state.players.firstWhere((p) => p.id == cell.ownerId);
    final board = [...state.board];
    board[cellIndex] = cell.copyWith(houses: cell.houses - 1);

    state = state.copyWith(
      board: board,
      players: _replacePlayer(
        player.copyWith(balance: player.balance + refund),
      ),
      log: _append(
        '${player.name} продає будинок на «${cell.name}» (+$refund\$).',
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
        reason: '${_active.name} викинув три дублі поспіль — у тюрму!',
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
      _online!.realtime.sendAction(
        NetworkAction(type: type, senderId: id, payload: payload),
      ),
    );
    return true;
  }

  bool _allowActivePlayerAction() {
    if (!isOnline || _applyingRemote) return true;
    if (isHost && state.activePlayer.isAi) return true;
    return state.activePlayer.id == localPlayerId;
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
    await online.realtime.sendStateSync({
      'game': state.toJson(),
      'decks': _decks.toJson(),
      'auction': _auction?.toJson(),
    });
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

  void _onRemoteAction(NetworkAction action) {
    if (!isHost) return;
    if (action.senderId == localPlayerId) return;

    _applyingRemote = true;
    try {
      switch (action.type) {
        case NetworkActionType.roll:
          if (state.activePlayer.id == action.senderId) rollDice();
        case NetworkActionType.buy:
          if (state.activePlayer.id == action.senderId) acceptBuy();
        case NetworkActionType.declineBuy:
          if (state.activePlayer.id == action.senderId) declineBuy();
        case NetworkActionType.endTurn:
          if (state.activePlayer.id == action.senderId) endTurn();
        case NetworkActionType.dismissNotice:
          if (state.activePlayer.id == action.senderId) dismissNotice();
        case NetworkActionType.payJailFine:
          if (state.activePlayer.id == action.senderId) payJailFine();
        case NetworkActionType.auctionBid:
          if (_auction?.currentBidderId == action.senderId) {
            auctionBid((action.payload['amount'] as num?)?.toInt() ?? 0);
          }
        case NetworkActionType.auctionPass:
          if (_auction?.currentBidderId == action.senderId) auctionPass();
        case NetworkActionType.tradeAccept:
          acceptTrade();
        case NetworkActionType.tradeDecline:
          declineTrade();
        case NetworkActionType.trade:
          proposeTrade(TradeOffer.fromJson(action.payload));
        case NetworkActionType.buildHouse:
          buildHouse((action.payload['cellIndex'] as num?)?.toInt() ?? -1);
        case NetworkActionType.kickToAi:
        case NetworkActionType.ready:
        case NetworkActionType.startGame:
          break;
      }
    } finally {
      _applyingRemote = false;
    }
    unawaited(_broadcastSync());
  }

  void _onPresenceSync(List<PresenceMember> members) {
    final onlineIds = members.map((m) => m.playerId).toSet();
    for (final id in onlineIds) {
      _disconnectTimers.remove(id)?.cancel();
    }
    if (isOnline && isHost) {
      _pokeAi();
    }
  }

  void _onPresenceLeave(
    PresenceMember left,
    List<PresenceMember> remaining,
  ) {
    if (!isOnline || !isHost) return;
    final id = left.playerId;
    _disconnectTimers[id]?.cancel();
    _disconnectTimers[id] = Timer(disconnectAiGrace, () {
      _disconnectTimers.remove(id);
      _convertDisconnectedToAi(id);
    });
  }

  void _convertDisconnectedToAi(String playerId) {
    if (!isHost) return;
    final idx = state.players.indexWhere((p) => p.id == playerId);
    if (idx < 0) return;
    final player = state.players[idx];
    if (player.isAi || player.isBankrupt) return;

    final bot = player.copyWith(
      isAi: true,
      aiProfile: player.aiProfile ?? AiProfile.strategist,
    );
    final players = [...state.players];
    players[idx] = bot;
    state = state.copyWith(
      players: players,
      log: _append(
        '${player.name} SIGNAL LOST >15s → AI TAKEOVER (${bot.aiProfile?.name ?? 'bot'}).',
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
        '${_active.name} кидає ${state.lastRoll!.die1}+${state.lastRoll!.die2}'
        ' (=${state.lastRoll!.total}'
        '${state.lastRoll!.isDoubles ? ', дубль' : ''}).',
      ),
    );
  }

  void _resolveJailRoll(DiceRoll roll) {
    if (roll.isDoubles) {
      final freed = _active.copyWith(inJail: false, jailTurns: 0);
      state = state.copyWith(
        players: _replacePlayer(freed),
        consecutiveDoubles: 0,
        log: _append('${freed.name} викидає дубль і виходить з тюрми!'),
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
          '${freed.name} сплачує \$${GameRules.jailFine} після '
          '${GameRules.maxJailTurns}-го ходу в тюрмі.',
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
        '${_active.name} лишається в тюрмі '
        '(хід $turns/${GameRules.maxJailTurns}).',
      ),
    );
  }

  void _resolveCell() {
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
          log: _append('${_active.name} на клітинці «$name».'),
        );
        _finishCellAction();
      case SpecialKind.goToJail:
        _speak(_active, AiDialogueEvent.goToJail);
        _sendToJail(
          reason: '${_active.name} hit CYBERPSYCHO DETENTION!',
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
    if (result.wentToJail) {
      _speak(_active, AiDialogueEvent.goToJail);
      return;
    }
    if (result.reresolveCell) {
      // Landed elsewhere — resolve that cell after acknowledging card.
      // Keep card notice; on dismiss we'll re-resolve.
      state = state.copyWith(
        log: _append('Card move pending cell resolve at ${state.activePlayer.position}.'),
      );
    }
  }

  void _resolveOwnable(BoardCell cell) {
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
          '${_active.name} може купити «${cell.name}» за \$$price.',
        ),
      );
      // AI buy decision is handled by AiService (with thinking delay).
      return;
    }

    if (ownerId == _active.id || cell.isMortgagedOrFalse) {
      _finishCellAction();
      return;
    }

    final rent = RulesEngine.calculateRent(
      cell: cell,
      board: state.board,
      diceTotal: state.lastRoll?.total ?? 0,
    );
    if (rent <= 0) {
      _finishCellAction();
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
        '${payer.name} paid ${GameRules.credits(rent)} to ${paidOwner.name} '
        '(«${cell.name}»).',
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
      log: _append('${p.name} сплачує $name: \$$amount.'),
    );
  }

  void _purchase(int cellIndex) {
    final cell = state.cellAt(cellIndex);
    final price = cell.priceOrNull!;
    if (!RulesEngine.canAfford(_active, price)) {
      state = state.copyWith(
        log: _append('${_active.name} не вистачає грошей на «${cell.name}».'),
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
        '${buyer.name} acquires «${cell.name}» for ${GameRules.credits(price)}.',
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

  void _finishCellAction() {
    state = state.copyWith(
      phase: TurnPhase.canEndTurn,
      pendingAction: const PendingAction.none(),
    );
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
        log: _append('Auction closed — no bids. Asset remains unclaimed.'),
      );
      _pokeAi();
      return;
    }

    final winner = state.players.firstWhere((p) => p.id == winnerId);
    if (!RulesEngine.canAfford(winner, a.highestBid)) {
      state = state.copyWith(
        pendingAction: const PendingAction.none(),
        phase: TurnPhase.canEndTurn,
        log: _append('Auction winner insolvent — voided.'),
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
        '${paid.name} wins auction for «${a.propertyName}» '
        'at ${GameRules.credits(a.highestBid)}.',
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

  void _declareBankruptcy(Player loser, {required String? creditorId}) {
    var board = [...state.board];
    for (final idx in loser.propertyIndexes) {
      final cell = board[idx];
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
    // Re-read balance after possible liquidation.
    final current = players[loserIndex];
    players[loserIndex] = current.copyWith(
      isBankrupt: true,
      balance: 0,
      propertyIndexes: const [],
      inJail: false,
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
      moveStepsLeft: 0,
      log: _append('${loser.name} liquidated — BANKRUPT.'),
    );

    if (living.length <= 1) {
      final winner = living.isEmpty ? null : living.first;
      state = state.copyWith(
        phase: TurnPhase.gameOver,
        winnerId: winner?.id,
        pendingAction: winner == null
            ? const PendingAction.none()
            : PendingAction.winner(
                playerId: winner.id,
                playerName: winner.name,
              ),
        log: winner == null ? state.log : _append('Переможець: ${winner.name}!'),
      );
      return;
    }

    state = state.copyWith(
      pendingAction: const PendingAction.none(),
      phase: TurnPhase.canEndTurn,
      consecutiveDoubles: 0,
    );
    _advanceToNextPlayer();
  }

  void _advanceToNextPlayer() {
    if (state.isGameOver) return;

    final n = state.players.length;
    var idx = state.activePlayerIndex;
    for (var i = 0; i < n; i++) {
      idx = (idx + 1) % n;
      if (!state.players[idx].isBankrupt) break;
    }

    state = state.copyWith(
      activePlayerIndex: idx,
      phase: TurnPhase.waitingForRoll,
      consecutiveDoubles: 0,
      lastRoll: null,
      moveFromIndex: null,
      moveStepsLeft: 0,
      pendingAction: const PendingAction.none(),
      log: _append('Operative turn: ${state.players[idx].name}.'),
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
