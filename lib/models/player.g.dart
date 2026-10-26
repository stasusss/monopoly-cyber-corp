// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlayerImpl _$$PlayerImplFromJson(Map<String, dynamic> json) => _$PlayerImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  tokenColor: $enumDecode(_$TokenColorEnumMap, json['tokenColor']),
  balance: (json['balance'] as num?)?.toInt() ?? 1500,
  position: (json['position'] as num?)?.toInt() ?? 0,
  inJail: json['inJail'] as bool? ?? false,
  jailTurns: (json['jailTurns'] as num?)?.toInt() ?? 0,
  propertyIndexes:
      (json['propertyIndexes'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const [],
  isBankrupt: json['isBankrupt'] as bool? ?? false,
  isAi: json['isAi'] as bool? ?? false,
  aiProfile: $enumDecodeNullable(_$AiProfileEnumMap, json['aiProfile']),
  getOutOfJailCards: (json['getOutOfJailCards'] as num?)?.toInt() ?? 0,
  jailCardSources:
      (json['jailCardSources'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  overdraftUsed: json['overdraftUsed'] as bool? ?? false,
  overdraftRemaining: (json['overdraftRemaining'] as num?)?.toInt() ?? 0,
  overdraftInstallmentsLeft:
      (json['overdraftInstallmentsLeft'] as num?)?.toInt() ?? 0,
  buyoutUsed: json['buyoutUsed'] as bool? ?? false,
  blackoutUsedThisTurn: json['blackoutUsedThisTurn'] as bool? ?? false,
  chrome: $enumDecodeNullable(_$ChromeEnumMap, json['chrome']) ?? Chrome.none,
  chromeSpent: json['chromeSpent'] as bool? ?? false,
  chromeArmed: json['chromeArmed'] as bool? ?? false,
  fixerSpent: json['fixerSpent'] as bool? ?? false,
  heat: (json['heat'] as num?)?.toInt() ?? 0,
  virusRound: (json['virusRound'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$PlayerImplToJson(_$PlayerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'tokenColor': _$TokenColorEnumMap[instance.tokenColor]!,
      'balance': instance.balance,
      'position': instance.position,
      'inJail': instance.inJail,
      'jailTurns': instance.jailTurns,
      'propertyIndexes': instance.propertyIndexes,
      'isBankrupt': instance.isBankrupt,
      'isAi': instance.isAi,
      'aiProfile': _$AiProfileEnumMap[instance.aiProfile],
      'getOutOfJailCards': instance.getOutOfJailCards,
      'jailCardSources': instance.jailCardSources,
      'overdraftUsed': instance.overdraftUsed,
      'overdraftRemaining': instance.overdraftRemaining,
      'overdraftInstallmentsLeft': instance.overdraftInstallmentsLeft,
      'buyoutUsed': instance.buyoutUsed,
      'blackoutUsedThisTurn': instance.blackoutUsedThisTurn,
      'chrome': _$ChromeEnumMap[instance.chrome]!,
      'chromeSpent': instance.chromeSpent,
      'chromeArmed': instance.chromeArmed,
      'fixerSpent': instance.fixerSpent,
      'heat': instance.heat,
      'virusRound': instance.virusRound,
    };

const _$TokenColorEnumMap = {
  TokenColor.red: 'red',
  TokenColor.blue: 'blue',
  TokenColor.green: 'green',
  TokenColor.yellow: 'yellow',
};

const _$AiProfileEnumMap = {
  AiProfile.aggressive: 'aggressive',
  AiProfile.banker: 'banker',
  AiProfile.strategist: 'strategist',
};

const _$ChromeEnumMap = {
  Chrome.none: 'none',
  Chrome.sandevistan: 'sandevistan',
  Chrome.kerenzikov: 'kerenzikov',
  Chrome.cyberdeck: 'cyberdeck',
  Chrome.mantis: 'mantis',
};
