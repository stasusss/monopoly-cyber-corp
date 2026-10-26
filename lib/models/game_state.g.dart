// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GameStateImpl _$$GameStateImplFromJson(
  Map<String, dynamic> json,
) => _$GameStateImpl(
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
      : PendingAction.fromJson(json['pendingAction'] as Map<String, dynamic>),
  aiDialogue: json['aiDialogue'] as String?,
  aiDialogueSpeakerId: json['aiDialogueSpeakerId'] as String?,
  isWaitingForReconnection: json['isWaitingForReconnection'] as bool? ?? false,
  disconnectedPlayerName: json['disconnectedPlayerName'] as String?,
  reconnectDeadlineMs: (json['reconnectDeadlineMs'] as num?)?.toInt(),
  round: (json['round'] as num?)?.toInt() ?? 1,
  bankruptcyCount: (json['bankruptcyCount'] as num?)?.toInt() ?? 0,
  housesInBank:
      (json['housesInBank'] as num?)?.toInt() ?? GameRules.housesInSupply,
  hotelsInBank:
      (json['hotelsInBank'] as num?)?.toInt() ?? GameRules.hotelsInSupply,
  suppressedCells:
      (json['suppressedCells'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const [],
  suppressedBy:
      (json['suppressedBy'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  blackoutGroupsThisRound:
      (json['blackoutGroupsThisRound'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  nextRentMultiplier: (json['nextRentMultiplier'] as num?)?.toInt() ?? 1,
  nextUtilityFlatTen: json['nextUtilityFlatTen'] as bool? ?? false,
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
      'isWaitingForReconnection': instance.isWaitingForReconnection,
      'disconnectedPlayerName': instance.disconnectedPlayerName,
      'reconnectDeadlineMs': instance.reconnectDeadlineMs,
      'round': instance.round,
      'bankruptcyCount': instance.bankruptcyCount,
      'housesInBank': instance.housesInBank,
      'hotelsInBank': instance.hotelsInBank,
      'suppressedCells': instance.suppressedCells,
      'suppressedBy': instance.suppressedBy,
      'blackoutGroupsThisRound': instance.blackoutGroupsThisRound,
      'nextRentMultiplier': instance.nextRentMultiplier,
      'nextUtilityFlatTen': instance.nextUtilityFlatTen,
    };

const _$TurnPhaseEnumMap = {
  TurnPhase.waitingForRoll: 'waitingForRoll',
  TurnPhase.rolling: 'rolling',
  TurnPhase.movingToken: 'movingToken',
  TurnPhase.cellAction: 'cellAction',
  TurnPhase.canEndTurn: 'canEndTurn',
  TurnPhase.gameOver: 'gameOver',
};
