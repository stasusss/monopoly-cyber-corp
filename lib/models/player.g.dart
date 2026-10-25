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
