// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GameStateImpl _$$GameStateImplFromJson(Map<String, dynamic> json) =>
    _$GameStateImpl(
      board: (json['board'] as List<dynamic>)
          .map((e) => BoardCell.fromJson(e as Map<String, dynamic>))
          .toList(),
      players: (json['players'] as List<dynamic>)
          .map((e) => Player.fromJson(e as Map<String, dynamic>))
          .toList(),
      activePlayerIndex: (json['activePlayerIndex'] as num?)?.toInt() ?? 0,
      phase:
          $enumDecodeNullable(_$TurnPhaseEnumMap, json['phase']) ??
          TurnPhase.waitingForRoll,
      lastRoll: json['lastRoll'] == null
          ? null
          : DiceRoll.fromJson(json['lastRoll'] as Map<String, dynamic>),
      consecutiveDoubles: (json['consecutiveDoubles'] as num?)?.toInt() ?? 0,
      moveFromIndex: (json['moveFromIndex'] as num?)?.toInt(),
      moveStepsLeft: (json['moveStepsLeft'] as num?)?.toInt() ?? 0,
      log:
          (json['log'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      winnerId: json['winnerId'] as String?,
      pendingAction: json['pendingAction'] == null
          ? const PendingAction.none()
          : PendingAction.fromJson(
              json['pendingAction'] as Map<String, dynamic>,
            ),
      aiDialogue: json['aiDialogue'] as String?,
      aiDialogueSpeakerId: json['aiDialogueSpeakerId'] as String?,
    );

Map<String, dynamic> _$$GameStateImplToJson(_$GameStateImpl instance) =>
    <String, dynamic>{
      'board': instance.board,
      'players': instance.players,
      'activePlayerIndex': instance.activePlayerIndex,
      'phase': _$TurnPhaseEnumMap[instance.phase]!,
      'lastRoll': instance.lastRoll,
      'consecutiveDoubles': instance.consecutiveDoubles,
      'moveFromIndex': instance.moveFromIndex,
      'moveStepsLeft': instance.moveStepsLeft,
      'log': instance.log,
      'winnerId': instance.winnerId,
      'pendingAction': instance.pendingAction,
      'aiDialogue': instance.aiDialogue,
      'aiDialogueSpeakerId': instance.aiDialogueSpeakerId,
    };

const _$TurnPhaseEnumMap = {
  TurnPhase.waitingForRoll: 'waitingForRoll',
  TurnPhase.rolling: 'rolling',
  TurnPhase.movingToken: 'movingToken',
  TurnPhase.cellAction: 'cellAction',
  TurnPhase.canEndTurn: 'canEndTurn',
  TurnPhase.gameOver: 'gameOver',
};
