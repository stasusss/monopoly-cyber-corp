import 'package:freezed_annotation/freezed_annotation.dart';

import '../core/constants/game_rules.dart';
import 'cell.dart';
import 'dice.dart';
import 'pending_action.dart';
import 'player.dart';

part 'game_state.freezed.dart';
part 'game_state.g.dart';

/// Phases of a single player turn (state machine).
/// Table-wide modifier chosen at rounds 10 and 20.
enum CityDecree { none, rentSurge, maglevFree, taxHoliday }

enum TurnPhase {
  /// Waiting for the active player to roll.
  waitingForRoll,

  /// Dice animation / roll in progress.
  rolling,

  /// Token is stepping across the board.
  movingToken,

  /// Resolving the landed cell (buy / rent / tax / jail / cards).
  cellAction,

  /// Player may end turn (or roll again on doubles).
  canEndTurn,

  /// Game finished — one solvent player remains.
  gameOver,
}

@freezed
abstract class GameState with _$GameState {
  const GameState._();

  const factory GameState({
    required List<BoardCell> board,
    required List<Player> players,
    @Default(0) int activePlayerIndex,
    @Default(TurnPhase.waitingForRoll) TurnPhase phase,
    DiceRoll? lastRoll,
    @Default(0) int consecutiveDoubles,

    /// Position before the current move (for token animation).
    int? moveFromIndex,

    /// Steps still animating; 0 when settled.
    @Default(0) int moveStepsLeft,
    @Default([]) List<String> log,
    String? winnerId,
    @Default(PendingAction.none()) PendingAction pendingAction,

    /// Last AI banter line for CyberDialogueBubble.
    String? aiDialogue,
    String? aiDialogueSpeakerId,

    /// Online: an operative left presence and grace timer is running.
    @Default(false) bool isWaitingForReconnection,
    String? disconnectedPlayerName,

    /// Epoch ms when [disconnectAiGrace] expires (host-authored, synced).
    int? reconnectDeadlineMs,

    /// Table round, 1-based. A round completes when the turn wraps to the
    /// first seat. Blitz ends as round [GameRules.blitzRoundLimit] + 1 starts.
    @Default(1) int round,

    @Default(0) int bankruptcyCount,
    @Default(GameRules.housesInSupply) int housesInBank,
    @Default(GameRules.hotelsInSupply) int hotelsInBank,

    /// Cell indexes whose rent is calculated one tier lower.
    @Default([]) List<int> suppressedCells,

    /// Hacker id aligned with [suppressedCells]. Cleared when that operative's
    /// next turn starts.
    @Default([]) List<String> suppressedBy,

    /// [ColorGroup.name] values already blacked out this round.
    @Default([]) List<String> blackoutGroupsThisRound,

    /// Next rent resolution is multiplied (Maglev breach = 2). Cleared after use.
    @Default(1) int nextRentMultiplier,

    /// Next utility bill is 10× dice regardless of how many grids the owner holds.
    @Default(false) bool nextUtilityFlatTen,

    /// Infected cells and how many landings the virus still has.
    @Default([]) List<int> virusCells,
    @Default([]) List<int> virusHops,

    @Default(CityDecree.none) CityDecree decree,
    @Default('') String surgeGroup,
    @Default(0) int decreeArmedRound,

    /// Street the syndicate seized; auction opens once the landing settles.
    int? queuedAuctionIndex,
  }) = _GameState;

  factory GameState.fromJson(Map<String, dynamic> json) =>
      _$GameStateFromJson(json);

  Player get activePlayer => players[activePlayerIndex];

  BoardCell cellAt(int index) => board[index];

  List<Player> get livingPlayers =>
      players.where((p) => !p.isBankrupt).toList();

  bool get isGameOver => phase == TurnPhase.gameOver || winnerId != null;
}
