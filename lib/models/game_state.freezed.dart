// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GameState _$GameStateFromJson(Map<String, dynamic> json) {
  return _GameState.fromJson(json);
}

/// @nodoc
mixin _$GameState {
  List<BoardCell> get board => throw _privateConstructorUsedError;
  List<Player> get players => throw _privateConstructorUsedError;
  int get activePlayerIndex => throw _privateConstructorUsedError;
  TurnPhase get phase => throw _privateConstructorUsedError;
  DiceRoll? get lastRoll => throw _privateConstructorUsedError;
  int get consecutiveDoubles => throw _privateConstructorUsedError;

  /// Position before the current move (for token animation).
  int? get moveFromIndex => throw _privateConstructorUsedError;

  /// Steps still animating; 0 when settled.
  int get moveStepsLeft => throw _privateConstructorUsedError;
  List<String> get log => throw _privateConstructorUsedError;
  String? get winnerId => throw _privateConstructorUsedError;
  PendingAction get pendingAction => throw _privateConstructorUsedError;

  /// Last AI banter line for CyberDialogueBubble.
  String? get aiDialogue => throw _privateConstructorUsedError;
  String? get aiDialogueSpeakerId => throw _privateConstructorUsedError;

  /// Serializes this GameState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameStateCopyWith<GameState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameStateCopyWith<$Res> {
  factory $GameStateCopyWith(GameState value, $Res Function(GameState) then) =
      _$GameStateCopyWithImpl<$Res, GameState>;
  @useResult
  $Res call({
    List<BoardCell> board,
    List<Player> players,
    int activePlayerIndex,
    TurnPhase phase,
    DiceRoll? lastRoll,
    int consecutiveDoubles,
    int? moveFromIndex,
    int moveStepsLeft,
    List<String> log,
    String? winnerId,
    PendingAction pendingAction,
    String? aiDialogue,
    String? aiDialogueSpeakerId,
  });

  $DiceRollCopyWith<$Res>? get lastRoll;
  $PendingActionCopyWith<$Res> get pendingAction;
}

/// @nodoc
class _$GameStateCopyWithImpl<$Res, $Val extends GameState>
    implements $GameStateCopyWith<$Res> {
  _$GameStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? board = null,
    Object? players = null,
    Object? activePlayerIndex = null,
    Object? phase = null,
    Object? lastRoll = freezed,
    Object? consecutiveDoubles = null,
    Object? moveFromIndex = freezed,
    Object? moveStepsLeft = null,
    Object? log = null,
    Object? winnerId = freezed,
    Object? pendingAction = null,
    Object? aiDialogue = freezed,
    Object? aiDialogueSpeakerId = freezed,
  }) {
    return _then(
      _value.copyWith(
            board: null == board
                ? _value.board
                : board // ignore: cast_nullable_to_non_nullable
                      as List<BoardCell>,
            players: null == players
                ? _value.players
                : players // ignore: cast_nullable_to_non_nullable
                      as List<Player>,
            activePlayerIndex: null == activePlayerIndex
                ? _value.activePlayerIndex
                : activePlayerIndex // ignore: cast_nullable_to_non_nullable
                      as int,
            phase: null == phase
                ? _value.phase
                : phase // ignore: cast_nullable_to_non_nullable
                      as TurnPhase,
            lastRoll: freezed == lastRoll
                ? _value.lastRoll
                : lastRoll // ignore: cast_nullable_to_non_nullable
                      as DiceRoll?,
            consecutiveDoubles: null == consecutiveDoubles
                ? _value.consecutiveDoubles
                : consecutiveDoubles // ignore: cast_nullable_to_non_nullable
                      as int,
            moveFromIndex: freezed == moveFromIndex
                ? _value.moveFromIndex
                : moveFromIndex // ignore: cast_nullable_to_non_nullable
                      as int?,
            moveStepsLeft: null == moveStepsLeft
                ? _value.moveStepsLeft
                : moveStepsLeft // ignore: cast_nullable_to_non_nullable
                      as int,
            log: null == log
                ? _value.log
                : log // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            winnerId: freezed == winnerId
                ? _value.winnerId
                : winnerId // ignore: cast_nullable_to_non_nullable
                      as String?,
            pendingAction: null == pendingAction
                ? _value.pendingAction
                : pendingAction // ignore: cast_nullable_to_non_nullable
                      as PendingAction,
            aiDialogue: freezed == aiDialogue
                ? _value.aiDialogue
                : aiDialogue // ignore: cast_nullable_to_non_nullable
                      as String?,
            aiDialogueSpeakerId: freezed == aiDialogueSpeakerId
                ? _value.aiDialogueSpeakerId
                : aiDialogueSpeakerId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DiceRollCopyWith<$Res>? get lastRoll {
    if (_value.lastRoll == null) {
      return null;
    }

    return $DiceRollCopyWith<$Res>(_value.lastRoll!, (value) {
      return _then(_value.copyWith(lastRoll: value) as $Val);
    });
  }

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PendingActionCopyWith<$Res> get pendingAction {
    return $PendingActionCopyWith<$Res>(_value.pendingAction, (value) {
      return _then(_value.copyWith(pendingAction: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GameStateImplCopyWith<$Res>
    implements $GameStateCopyWith<$Res> {
  factory _$$GameStateImplCopyWith(
    _$GameStateImpl value,
    $Res Function(_$GameStateImpl) then,
  ) = __$$GameStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<BoardCell> board,
    List<Player> players,
    int activePlayerIndex,
    TurnPhase phase,
    DiceRoll? lastRoll,
    int consecutiveDoubles,
    int? moveFromIndex,
    int moveStepsLeft,
    List<String> log,
    String? winnerId,
    PendingAction pendingAction,
    String? aiDialogue,
    String? aiDialogueSpeakerId,
  });

  @override
  $DiceRollCopyWith<$Res>? get lastRoll;
  @override
  $PendingActionCopyWith<$Res> get pendingAction;
}

/// @nodoc
class __$$GameStateImplCopyWithImpl<$Res>
    extends _$GameStateCopyWithImpl<$Res, _$GameStateImpl>
    implements _$$GameStateImplCopyWith<$Res> {
  __$$GameStateImplCopyWithImpl(
    _$GameStateImpl _value,
    $Res Function(_$GameStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? board = null,
    Object? players = null,
    Object? activePlayerIndex = null,
    Object? phase = null,
    Object? lastRoll = freezed,
    Object? consecutiveDoubles = null,
    Object? moveFromIndex = freezed,
    Object? moveStepsLeft = null,
    Object? log = null,
    Object? winnerId = freezed,
    Object? pendingAction = null,
    Object? aiDialogue = freezed,
    Object? aiDialogueSpeakerId = freezed,
  }) {
    return _then(
      _$GameStateImpl(
        board: null == board
            ? _value._board
            : board // ignore: cast_nullable_to_non_nullable
                  as List<BoardCell>,
        players: null == players
            ? _value._players
            : players // ignore: cast_nullable_to_non_nullable
                  as List<Player>,
        activePlayerIndex: null == activePlayerIndex
            ? _value.activePlayerIndex
            : activePlayerIndex // ignore: cast_nullable_to_non_nullable
                  as int,
        phase: null == phase
            ? _value.phase
            : phase // ignore: cast_nullable_to_non_nullable
                  as TurnPhase,
        lastRoll: freezed == lastRoll
            ? _value.lastRoll
            : lastRoll // ignore: cast_nullable_to_non_nullable
                  as DiceRoll?,
        consecutiveDoubles: null == consecutiveDoubles
            ? _value.consecutiveDoubles
            : consecutiveDoubles // ignore: cast_nullable_to_non_nullable
                  as int,
        moveFromIndex: freezed == moveFromIndex
            ? _value.moveFromIndex
            : moveFromIndex // ignore: cast_nullable_to_non_nullable
                  as int?,
        moveStepsLeft: null == moveStepsLeft
            ? _value.moveStepsLeft
            : moveStepsLeft // ignore: cast_nullable_to_non_nullable
                  as int,
        log: null == log
            ? _value._log
            : log // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        winnerId: freezed == winnerId
            ? _value.winnerId
            : winnerId // ignore: cast_nullable_to_non_nullable
                  as String?,
        pendingAction: null == pendingAction
            ? _value.pendingAction
            : pendingAction // ignore: cast_nullable_to_non_nullable
                  as PendingAction,
        aiDialogue: freezed == aiDialogue
            ? _value.aiDialogue
            : aiDialogue // ignore: cast_nullable_to_non_nullable
                  as String?,
        aiDialogueSpeakerId: freezed == aiDialogueSpeakerId
            ? _value.aiDialogueSpeakerId
            : aiDialogueSpeakerId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GameStateImpl extends _GameState {
  const _$GameStateImpl({
    required final List<BoardCell> board,
    required final List<Player> players,
    this.activePlayerIndex = 0,
    this.phase = TurnPhase.waitingForRoll,
    this.lastRoll,
    this.consecutiveDoubles = 0,
    this.moveFromIndex,
    this.moveStepsLeft = 0,
    final List<String> log = const [],
    this.winnerId,
    this.pendingAction = const PendingAction.none(),
    this.aiDialogue,
    this.aiDialogueSpeakerId,
  }) : _board = board,
       _players = players,
       _log = log,
       super._();

  factory _$GameStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameStateImplFromJson(json);

  final List<BoardCell> _board;
  @override
  List<BoardCell> get board {
    if (_board is EqualUnmodifiableListView) return _board;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_board);
  }

  final List<Player> _players;
  @override
  List<Player> get players {
    if (_players is EqualUnmodifiableListView) return _players;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_players);
  }

  @override
  @JsonKey()
  final int activePlayerIndex;
  @override
  @JsonKey()
  final TurnPhase phase;
  @override
  final DiceRoll? lastRoll;
  @override
  @JsonKey()
  final int consecutiveDoubles;

  /// Position before the current move (for token animation).
  @override
  final int? moveFromIndex;

  /// Steps still animating; 0 when settled.
  @override
  @JsonKey()
  final int moveStepsLeft;
  final List<String> _log;
  @override
  @JsonKey()
  List<String> get log {
    if (_log is EqualUnmodifiableListView) return _log;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_log);
  }

  @override
  final String? winnerId;
  @override
  @JsonKey()
  final PendingAction pendingAction;

  /// Last AI banter line for CyberDialogueBubble.
  @override
  final String? aiDialogue;
  @override
  final String? aiDialogueSpeakerId;

  @override
  String toString() {
    return 'GameState(board: $board, players: $players, activePlayerIndex: $activePlayerIndex, phase: $phase, lastRoll: $lastRoll, consecutiveDoubles: $consecutiveDoubles, moveFromIndex: $moveFromIndex, moveStepsLeft: $moveStepsLeft, log: $log, winnerId: $winnerId, pendingAction: $pendingAction, aiDialogue: $aiDialogue, aiDialogueSpeakerId: $aiDialogueSpeakerId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameStateImpl &&
            const DeepCollectionEquality().equals(other._board, _board) &&
            const DeepCollectionEquality().equals(other._players, _players) &&
            (identical(other.activePlayerIndex, activePlayerIndex) ||
                other.activePlayerIndex == activePlayerIndex) &&
            (identical(other.phase, phase) || other.phase == phase) &&
            (identical(other.lastRoll, lastRoll) ||
                other.lastRoll == lastRoll) &&
            (identical(other.consecutiveDoubles, consecutiveDoubles) ||
                other.consecutiveDoubles == consecutiveDoubles) &&
            (identical(other.moveFromIndex, moveFromIndex) ||
                other.moveFromIndex == moveFromIndex) &&
            (identical(other.moveStepsLeft, moveStepsLeft) ||
                other.moveStepsLeft == moveStepsLeft) &&
            const DeepCollectionEquality().equals(other._log, _log) &&
            (identical(other.winnerId, winnerId) ||
                other.winnerId == winnerId) &&
            (identical(other.pendingAction, pendingAction) ||
                other.pendingAction == pendingAction) &&
            (identical(other.aiDialogue, aiDialogue) ||
                other.aiDialogue == aiDialogue) &&
            (identical(other.aiDialogueSpeakerId, aiDialogueSpeakerId) ||
                other.aiDialogueSpeakerId == aiDialogueSpeakerId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_board),
    const DeepCollectionEquality().hash(_players),
    activePlayerIndex,
    phase,
    lastRoll,
    consecutiveDoubles,
    moveFromIndex,
    moveStepsLeft,
    const DeepCollectionEquality().hash(_log),
    winnerId,
    pendingAction,
    aiDialogue,
    aiDialogueSpeakerId,
  );

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameStateImplCopyWith<_$GameStateImpl> get copyWith =>
      __$$GameStateImplCopyWithImpl<_$GameStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GameStateImplToJson(this);
  }
}

abstract class _GameState extends GameState {
  const factory _GameState({
    required final List<BoardCell> board,
    required final List<Player> players,
    final int activePlayerIndex,
    final TurnPhase phase,
    final DiceRoll? lastRoll,
    final int consecutiveDoubles,
    final int? moveFromIndex,
    final int moveStepsLeft,
    final List<String> log,
    final String? winnerId,
    final PendingAction pendingAction,
    final String? aiDialogue,
    final String? aiDialogueSpeakerId,
  }) = _$GameStateImpl;
  const _GameState._() : super._();

  factory _GameState.fromJson(Map<String, dynamic> json) =
      _$GameStateImpl.fromJson;

  @override
  List<BoardCell> get board;
  @override
  List<Player> get players;
  @override
  int get activePlayerIndex;
  @override
  TurnPhase get phase;
  @override
  DiceRoll? get lastRoll;
  @override
  int get consecutiveDoubles;

  /// Position before the current move (for token animation).
  @override
  int? get moveFromIndex;

  /// Steps still animating; 0 when settled.
  @override
  int get moveStepsLeft;
  @override
  List<String> get log;
  @override
  String? get winnerId;
  @override
  PendingAction get pendingAction;

  /// Last AI banter line for CyberDialogueBubble.
  @override
  String? get aiDialogue;
  @override
  String? get aiDialogueSpeakerId;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameStateImplCopyWith<_$GameStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
