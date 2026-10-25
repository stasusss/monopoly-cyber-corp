import 'package:freezed_annotation/freezed_annotation.dart';

import 'cell.dart';
import 'dice.dart';
import 'pending_action.dart';
import 'player.dart';

part 'game_state.freezed.dart';
part 'game_state.g.dart';

/// Phases of a single player turn (state machine).
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
  }) = _GameState;

  factory GameState.fromJson(Map<String, dynamic> json) =>
      _$GameStateFromJson(json);

  Player get activePlayer => players[activePlayerIndex];

  BoardCell cellAt(int index) => board[index];

  List<Player> get livingPlayers =>
      players.where((p) => !p.isBankrupt).toList();

  bool get isGameOver => phase == TurnPhase.gameOver || winnerId != null;
}
