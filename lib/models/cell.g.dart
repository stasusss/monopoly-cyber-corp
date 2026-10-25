// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cell.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PropertyCellImpl _$$PropertyCellImplFromJson(Map<String, dynamic> json) =>
    _$PropertyCellImpl(
      index: (json['index'] as num).toInt(),
      name: json['name'] as String,
      colorGroup: $enumDecode(_$ColorGroupEnumMap, json['colorGroup']),
      price: (json['price'] as num).toInt(),
      rents: (json['rents'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      mortgage: (json['mortgage'] as num).toInt(),
      ownerId: json['ownerId'] as String?,
      houses: (json['houses'] as num?)?.toInt() ?? 0,
      isMortgaged: json['isMortgaged'] as bool? ?? false,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$PropertyCellImplToJson(_$PropertyCellImpl instance) =>
    <String, dynamic>{
      'index': instance.index,
      'name': instance.name,
      'colorGroup': _$ColorGroupEnumMap[instance.colorGroup]!,
      'price': instance.price,
      'rents': instance.rents,
      'mortgage': instance.mortgage,
      'ownerId': instance.ownerId,
      'houses': instance.houses,
      'isMortgaged': instance.isMortgaged,
      'runtimeType': instance.$type,
    };

const _$ColorGroupEnumMap = {
  ColorGroup.brown: 'brown',
  ColorGroup.lightBlue: 'lightBlue',
  ColorGroup.pink: 'pink',
  ColorGroup.orange: 'orange',
  ColorGroup.red: 'red',
  ColorGroup.yellow: 'yellow',
  ColorGroup.green: 'green',
  ColorGroup.darkBlue: 'darkBlue',
};

_$RailroadCellImpl _$$RailroadCellImplFromJson(Map<String, dynamic> json) =>
    _$RailroadCellImpl(
      index: (json['index'] as num).toInt(),
      name: json['name'] as String,
      price: (json['price'] as num).toInt(),
      mortgage: (json['mortgage'] as num).toInt(),
      ownerId: json['ownerId'] as String?,
      isMortgaged: json['isMortgaged'] as bool? ?? false,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$RailroadCellImplToJson(_$RailroadCellImpl instance) =>
    <String, dynamic>{
      'index': instance.index,
      'name': instance.name,
      'price': instance.price,
      'mortgage': instance.mortgage,
      'ownerId': instance.ownerId,
      'isMortgaged': instance.isMortgaged,
      'runtimeType': instance.$type,
    };

_$UtilityCellImpl _$$UtilityCellImplFromJson(Map<String, dynamic> json) =>
    _$UtilityCellImpl(
      index: (json['index'] as num).toInt(),
      name: json['name'] as String,
      price: (json['price'] as num).toInt(),
      mortgage: (json['mortgage'] as num).toInt(),
      ownerId: json['ownerId'] as String?,
      isMortgaged: json['isMortgaged'] as bool? ?? false,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$UtilityCellImplToJson(_$UtilityCellImpl instance) =>
    <String, dynamic>{
      'index': instance.index,
      'name': instance.name,
      'price': instance.price,
      'mortgage': instance.mortgage,
      'ownerId': instance.ownerId,
      'isMortgaged': instance.isMortgaged,
      'runtimeType': instance.$type,
    };

_$TaxCellImpl _$$TaxCellImplFromJson(Map<String, dynamic> json) =>
    _$TaxCellImpl(
      index: (json['index'] as num).toInt(),
      name: json['name'] as String,
      amount: (json['amount'] as num).toInt(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$TaxCellImplToJson(_$TaxCellImpl instance) =>
    <String, dynamic>{
      'index': instance.index,
      'name': instance.name,
      'amount': instance.amount,
      'runtimeType': instance.$type,
    };

_$SpecialCellImpl _$$SpecialCellImplFromJson(Map<String, dynamic> json) =>
    _$SpecialCellImpl(
      index: (json['index'] as num).toInt(),
      name: json['name'] as String,
      kind: $enumDecode(_$SpecialKindEnumMap, json['kind']),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$SpecialCellImplToJson(_$SpecialCellImpl instance) =>
    <String, dynamic>{
      'index': instance.index,
      'name': instance.name,
      'kind': _$SpecialKindEnumMap[instance.kind]!,
      'runtimeType': instance.$type,
    };

const _$SpecialKindEnumMap = {
  SpecialKind.go: 'go',
  SpecialKind.jail: 'jail',
  SpecialKind.freeParking: 'freeParking',
  SpecialKind.goToJail: 'goToJail',
  SpecialKind.chance: 'chance',
  SpecialKind.communityChest: 'communityChest',
};
